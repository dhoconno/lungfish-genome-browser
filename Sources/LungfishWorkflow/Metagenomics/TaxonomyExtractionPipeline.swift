// TaxonomyExtractionPipeline.swift - Extracts reads by taxonomic classification
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import LungfishCore
import LungfishIO
import os.log

private let logger = Logger(subsystem: LogSubsystem.workflow, category: "TaxonomyExtraction")

// MARK: - TaxonomyExtractionPipeline

/// Actor that extracts reads classified to specific taxa from a FASTQ file.
///
/// The extraction flow:
/// 1. Parse the Kraken2 per-read classification output to build a set of
///    read IDs assigned to the target tax IDs.
/// 2. If ``TaxonomyExtractionConfig/includeChildren`` is `true`, collect all
///    descendant tax IDs from the ``TaxonTree`` before filtering.
/// 3. Read the source FASTQ file using buffered I/O, handling both plain
///    and gzip-compressed input.
/// 4. Write matching reads (4-line FASTQ records) to the output file.
/// 5. Record provenance via ``ProvenanceRecorder``.
///
/// ## Progress Reporting
///
/// Progress is reported via a `@Sendable (Double, String) -> Void` callback:
///
/// | Range        | Phase |
/// |-------------|-------|
/// | 0.0 -- 0.20 | Parsing classification output |
/// | 0.20 -- 0.30 | Building read ID set |
/// | 0.30 -- 0.95 | Filtering FASTQ |
/// | 0.95 -- 1.00 | Provenance recording |
///
/// ## Thread Safety
///
/// All mutable state is isolated to this actor.
///
/// ## Usage
///
/// ```swift
/// let pipeline = TaxonomyExtractionPipeline()
/// let config = TaxonomyExtractionConfig(
///     taxIds: [562],
///     includeChildren: true,
///     sourceFile: inputFASTQ,
///     outputFile: outputFASTQ,
///     classificationOutput: krakenOutput
/// )
/// let tree = classificationResult.tree
/// let outputURL = try await pipeline.extract(config: config, tree: tree) { pct, msg in
///     print("\(Int(pct * 100))% \(msg)")
/// }
/// ```
public actor TaxonomyExtractionPipeline {

    /// Shared instance for convenience.
    public static let shared = TaxonomyExtractionPipeline()

    /// Creates an extraction pipeline.
    public init() {}

    // MARK: - Public API

    /// Extracts reads classified to specific taxa from a FASTQ file.
    ///
    /// - Parameters:
    ///   - config: The extraction configuration.
    ///   - tree: The taxonomy tree for descendant lookup.
    ///   - progress: Optional progress callback.
    /// - Returns: The URL of the output FASTQ file.
    /// - Throws: ``TaxonomyExtractionError`` for extraction failures.
    public func extract(
        config: TaxonomyExtractionConfig,
        tree: TaxonTree,
        progress: (@Sendable (Double, String) -> Void)? = nil
    ) async throws -> URL {
        let startTime = Date()

        // Phase 1: Parse classification output (0.0 -- 0.20)
        progress?(0.0, "Reading classification output...")

        let fm = FileManager.default
        guard fm.fileExists(atPath: config.classificationOutput.path) else {
            throw TaxonomyExtractionError.classificationOutputNotFound(config.classificationOutput)
        }
        guard fm.fileExists(atPath: config.sourceFile.path) else {
            throw TaxonomyExtractionError.sourceFileNotFound(config.sourceFile)
        }

        // Build the complete set of target tax IDs
        let targetTaxIds: Set<Int>
        if config.includeChildren {
            targetTaxIds = collectDescendantTaxIds(config.taxIds, tree: tree)
        } else {
            targetTaxIds = config.taxIds
        }

        let taxIdCount = targetTaxIds.count
        logger.info("Extraction targeting \(taxIdCount, privacy: .public) tax IDs")
        progress?(0.10, "Filtering \(taxIdCount) tax IDs...")

        // Phase 2: Build read ID set from classification output (0.10 -- 0.30)
        let matchingReadIds = try buildReadIdSet(
            classificationURL: config.classificationOutput,
            targetTaxIds: targetTaxIds,
            progress: progress
        )

        if matchingReadIds.isEmpty {
            throw TaxonomyExtractionError.noMatchingReads
        }

        let matchCount = matchingReadIds.count
        logger.info("Found \(matchCount, privacy: .public) matching reads")
        progress?(0.30, "Extracting \(matchCount) reads...")

        // Phase 3: Filter FASTQ (0.30 -- 0.95)
        try Task.checkCancellation()

        let extractedCount = try filterFASTQ(
            source: config.sourceFile,
            output: config.outputFile,
            readIds: matchingReadIds,
            progress: progress
        )

        logger.info("Extracted \(extractedCount, privacy: .public) reads to \(config.outputFile.lastPathComponent, privacy: .public)")

        // Phase 4: Provenance recording (0.95 -- 1.00)
        progress?(0.95, "Recording provenance...")

        let runtime = Date().timeIntervalSince(startTime)
        await recordProvenance(config: config, extractedCount: extractedCount, runtime: runtime)

        progress?(1.0, "Extraction complete: \(extractedCount) reads")
        return config.outputFile
    }

    // MARK: - Descendant Collection

    /// Collects all descendant tax IDs for the given set of tax IDs.
    ///
    /// For each tax ID in the input set, this method finds the corresponding
    /// node in the taxonomy tree and collects the tax IDs of all descendants.
    ///
    /// - Parameters:
    ///   - taxIds: The starting set of tax IDs.
    ///   - tree: The taxonomy tree.
    /// - Returns: A set containing the input tax IDs and all descendant tax IDs.
    public func collectDescendantTaxIds(_ taxIds: Set<Int>, tree: TaxonTree) -> Set<Int> {
        var result = taxIds
        for taxId in taxIds {
            guard let node = tree.node(taxId: taxId) else { continue }
            for descendant in node.allDescendants() {
                result.insert(descendant.taxId)
            }
        }
        return result
    }

    // MARK: - Read ID Building

    /// Parses the Kraken2 per-read output to find read IDs matching target taxa.
    ///
    /// Uses line-by-line buffered reading to avoid loading the entire file into
    /// memory for large datasets.
    ///
    /// - Parameters:
    ///   - classificationURL: Path to the Kraken2 per-read output file.
    ///   - targetTaxIds: The set of taxonomy IDs to match.
    ///   - progress: Optional progress callback.
    /// - Returns: A set of read IDs assigned to any of the target taxa.
    /// - Throws: ``TaxonomyExtractionError`` on file read failure.
    private func buildReadIdSet(
        classificationURL: URL,
        targetTaxIds: Set<Int>,
        progress: (@Sendable (Double, String) -> Void)?
    ) throws -> Set<String> {
        guard let fileHandle = FileHandle(forReadingAtPath: classificationURL.path) else {
            throw TaxonomyExtractionError.classificationOutputNotFound(classificationURL)
        }
        defer { fileHandle.closeFile() }

        // Get file size for progress estimation
        let fileSize = (try? FileManager.default.attributesOfItem(
            atPath: classificationURL.path
        )[.size] as? Int64) ?? 0

        var matchingReadIds = Set<String>()
        var bytesRead: Int64 = 0
        var residual = Data()
        let bufferSize = 1_048_576 // 1 MB read chunks

        while true {
            let chunk = fileHandle.readData(ofLength: bufferSize)
            if chunk.isEmpty { break }
            bytesRead += Int64(chunk.count)

            // Combine residual from previous chunk with current chunk
            var data = residual + chunk
            residual = Data()

            // Find the last newline -- everything after it is residual for next iteration
            if let lastNewline = data.lastIndex(of: UInt8(ascii: "\n")) {
                if lastNewline < data.endIndex - 1 {
                    residual = data[(lastNewline + 1)...]
                    data = data[...lastNewline]
                }
            } else if !chunk.isEmpty {
                // No newline found -- accumulate and continue
                residual = data
                continue
            }

            // Process lines
            if let text = String(data: data, encoding: .utf8) {
                for line in text.split(separator: "\n", omittingEmptySubsequences: true) {
                    // Kraken2 output format: C/U \t readId \t taxId \t length \t kmerHits
                    let columns = line.split(separator: "\t", maxSplits: 3, omittingEmptySubsequences: false)
                    guard columns.count >= 3 else { continue }

                    // Column 0: C or U
                    let status = columns[0].trimmingCharacters(in: .whitespaces)
                    guard status == "C" else { continue }

                    // Column 2: taxonomy ID
                    let taxIdStr = columns[2].trimmingCharacters(in: .whitespaces)
                    guard let taxId = Int(taxIdStr), targetTaxIds.contains(taxId) else { continue }

                    // Column 1: read ID
                    let readId = String(columns[1].trimmingCharacters(in: .whitespaces))
                    matchingReadIds.insert(readId)
                }
            }

            // Report progress
            if fileSize > 0 {
                let fraction = 0.10 + 0.20 * (Double(bytesRead) / Double(fileSize))
                progress?(min(fraction, 0.30), "Scanning classification: \(matchingReadIds.count) matches...")
            }
        }

        // Process remaining residual
        if !residual.isEmpty, let text = String(data: residual, encoding: .utf8) {
            for line in text.split(separator: "\n", omittingEmptySubsequences: true) {
                let columns = line.split(separator: "\t", maxSplits: 3, omittingEmptySubsequences: false)
                guard columns.count >= 3 else { continue }
                let status = columns[0].trimmingCharacters(in: .whitespaces)
                guard status == "C" else { continue }
                let taxIdStr = columns[2].trimmingCharacters(in: .whitespaces)
                guard let taxId = Int(taxIdStr), targetTaxIds.contains(taxId) else { continue }
                let readId = String(columns[1].trimmingCharacters(in: .whitespaces))
                matchingReadIds.insert(readId)
            }
        }

        return matchingReadIds
    }

    // MARK: - FASTQ Filtering

    /// Filters a FASTQ file, writing only reads whose IDs are in the match set.
    ///
    /// Handles both plain text and gzip-compressed FASTQ files. FASTQ records
    /// are 4-line units: header, sequence, separator (+), quality.
    ///
    /// - Parameters:
    ///   - source: Input FASTQ file (plain or .gz).
    ///   - output: Output FASTQ file.
    ///   - readIds: Set of read IDs to extract.
    ///   - progress: Optional progress callback.
    /// - Returns: The number of reads extracted.
    /// - Throws: ``TaxonomyExtractionError`` on I/O failure.
    private func filterFASTQ(
        source: URL,
        output: URL,
        readIds: Set<String>,
        progress: (@Sendable (Double, String) -> Void)?
    ) throws -> Int {
        // Determine if input is gzip-compressed
        let isGzipped = source.pathExtension.lowercased() == "gz"

        // Create output directory if needed
        let outputDir = output.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: outputDir.path) {
            try FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)
        }

        // Get file size for progress
        let fileSize = (try? FileManager.default.attributesOfItem(
            atPath: source.path
        )[.size] as? Int64) ?? 0

        // For gzip files, use Process with zcat/gzcat. For plain, use FileHandle.
        if isGzipped {
            return try filterGzippedFASTQ(
                source: source,
                output: output,
                readIds: readIds,
                progress: progress
            )
        }

        guard let inputHandle = FileHandle(forReadingAtPath: source.path) else {
            throw TaxonomyExtractionError.sourceFileNotFound(source)
        }
        defer { inputHandle.closeFile() }

        // Create output file
        FileManager.default.createFile(atPath: output.path, contents: nil)
        guard let outputHandle = FileHandle(forWritingAtPath: output.path) else {
            throw TaxonomyExtractionError.outputWriteFailed(output, "Cannot open for writing")
        }
        defer { outputHandle.closeFile() }

        var extractedCount = 0
        var bytesRead: Int64 = 0
        var residual = ""
        let bufferSize = 4_194_304 // 4 MB
        var lineBuffer: [String] = []

        while true {
            try Task.checkCancellation()

            let chunk = inputHandle.readData(ofLength: bufferSize)
            if chunk.isEmpty { break }
            bytesRead += Int64(chunk.count)

            guard let text = String(data: chunk, encoding: .utf8) else { continue }

            let combined = residual + text
            residual = ""

            // Split into lines, keeping partial last line as residual
            var lines = combined.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
            if !combined.hasSuffix("\n") && !lines.isEmpty {
                residual = lines.removeLast()
            }

            for line in lines {
                lineBuffer.append(line)

                // FASTQ records are 4 lines
                if lineBuffer.count == 4 {
                    let header = lineBuffer[0]
                    // Extract read ID from FASTQ header: @readId [optional description]
                    if header.hasPrefix("@") {
                        let readId = extractReadId(from: header)
                        if readIds.contains(readId) {
                            let record = lineBuffer.joined(separator: "\n") + "\n"
                            outputHandle.write(Data(record.utf8))
                            extractedCount += 1
                        }
                    }
                    lineBuffer.removeAll(keepingCapacity: true)
                }
            }

            // Report progress
            if fileSize > 0 {
                let fraction = 0.30 + 0.65 * (Double(bytesRead) / Double(fileSize))
                progress?(min(fraction, 0.95), "Extracting: \(extractedCount) reads...")
            }
        }

        // Process remaining residual
        if !residual.isEmpty {
            lineBuffer.append(residual)
        }
        if lineBuffer.count == 4 {
            let header = lineBuffer[0]
            if header.hasPrefix("@") {
                let readId = extractReadId(from: header)
                if readIds.contains(readId) {
                    let record = lineBuffer.joined(separator: "\n") + "\n"
                    outputHandle.write(Data(record.utf8))
                    extractedCount += 1
                }
            }
        }

        return extractedCount
    }

    /// Filters a gzip-compressed FASTQ using a pipe through `gzcat`.
    ///
    /// - Parameters:
    ///   - source: Input .fastq.gz file.
    ///   - output: Output FASTQ file.
    ///   - readIds: Set of read IDs to extract.
    ///   - progress: Optional progress callback.
    /// - Returns: The number of reads extracted.
    private func filterGzippedFASTQ(
        source: URL,
        output: URL,
        readIds: Set<String>,
        progress: (@Sendable (Double, String) -> Void)?
    ) throws -> Int {
        // Create output file
        FileManager.default.createFile(atPath: output.path, contents: nil)
        guard let outputHandle = FileHandle(forWritingAtPath: output.path) else {
            throw TaxonomyExtractionError.outputWriteFailed(output, "Cannot open for writing")
        }
        defer { outputHandle.closeFile() }

        // Use gzcat to decompress on the fly
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/gzcat")
        process.arguments = [source.path]

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = FileHandle.nullDevice

        try process.run()

        let readHandle = pipe.fileHandleForReading
        var extractedCount = 0
        var lineBuffer: [String] = []
        var residual = ""
        let bufferSize = 4_194_304 // 4 MB

        while true {
            let chunk = readHandle.readData(ofLength: bufferSize)
            if chunk.isEmpty { break }

            guard let text = String(data: chunk, encoding: .utf8) else { continue }

            let combined = residual + text
            residual = ""

            var lines = combined.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
            if !combined.hasSuffix("\n") && !lines.isEmpty {
                residual = lines.removeLast()
            }

            for line in lines {
                lineBuffer.append(line)

                if lineBuffer.count == 4 {
                    let header = lineBuffer[0]
                    if header.hasPrefix("@") {
                        let readId = extractReadId(from: header)
                        if readIds.contains(readId) {
                            let record = lineBuffer.joined(separator: "\n") + "\n"
                            outputHandle.write(Data(record.utf8))
                            extractedCount += 1
                        }
                    }
                    lineBuffer.removeAll(keepingCapacity: true)
                }
            }

            progress?(0.60, "Extracting: \(extractedCount) reads...")
        }

        // Process remaining residual
        if !residual.isEmpty {
            lineBuffer.append(residual)
        }
        if lineBuffer.count == 4 {
            let header = lineBuffer[0]
            if header.hasPrefix("@") {
                let readId = extractReadId(from: header)
                if readIds.contains(readId) {
                    let record = lineBuffer.joined(separator: "\n") + "\n"
                    outputHandle.write(Data(record.utf8))
                    extractedCount += 1
                }
            }
        }

        process.waitUntilExit()
        return extractedCount
    }

    // MARK: - Helpers

    /// Extracts the read ID from a FASTQ header line.
    ///
    /// FASTQ headers have the format `@readId [optional description]`.
    /// The read ID is everything after `@` up to the first whitespace.
    ///
    /// - Parameter header: The FASTQ header line.
    /// - Returns: The read ID string.
    private func extractReadId(from header: String) -> String {
        var id = header
        if id.hasPrefix("@") {
            id = String(id.dropFirst())
        }
        // Read ID ends at first whitespace
        if let spaceIndex = id.firstIndex(where: { $0.isWhitespace }) {
            id = String(id[id.startIndex..<spaceIndex])
        }
        return id
    }

    // MARK: - Provenance

    /// Records provenance for the extraction operation.
    private func recordProvenance(
        config: TaxonomyExtractionConfig,
        extractedCount: Int,
        runtime: TimeInterval
    ) async {
        let recorder = ProvenanceRecorder.shared
        let runID = await recorder.beginRun(
            name: "Taxonomy Read Extraction",
            parameters: [
                "taxIds": .string(config.taxIds.sorted().map(String.init).joined(separator: ",")),
                "includeChildren": .boolean(config.includeChildren),
                "extractedReads": .integer(extractedCount),
            ]
        )

        let inputs = [
            FileRecord(path: config.sourceFile.path, format: .fastq, role: .input),
            FileRecord(path: config.classificationOutput.path, format: .text, role: .input),
        ]
        let outputs = [
            FileRecord(path: config.outputFile.path, format: .fastq, role: .output),
        ]

        await recorder.recordStep(
            runID: runID,
            toolName: "lungfish-extract",
            toolVersion: "1.0",
            command: ["lungfish", "extract", "--source", config.sourceFile.path,
                      "--output", config.outputFile.path],
            inputs: inputs,
            outputs: outputs,
            exitCode: 0,
            wallTime: runtime
        )

        await recorder.completeRun(runID, status: .completed)

        do {
            let outputDir = config.outputFile.deletingLastPathComponent()
            try await recorder.save(runID: runID, to: outputDir)
        } catch {
            logger.warning("Failed to save extraction provenance: \(error.localizedDescription, privacy: .public)")
        }
    }
}
