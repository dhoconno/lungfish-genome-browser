// DemultiplexingPipeline.swift - Cutadapt-based barcode demultiplexing
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import LungfishIO
import os.log

private let logger = Logger(subsystem: "com.lungfish.workflow", category: "DemultiplexingPipeline")

// MARK: - Demultiplex Configuration

/// Configuration for a cutadapt-based demultiplexing run.
public struct DemultiplexConfig: Sendable {
    /// Input FASTQ file URL (may be inside a .lungfishfastq bundle or standalone).
    public let inputURL: URL

    /// Barcode kit definition (built-in or custom).
    public let barcodeKit: IlluminaBarcodeDefinition

    /// Output directory for per-barcode .lungfishfastq bundles.
    public let outputDirectory: URL

    /// Where barcodes are located in the reads.
    public let barcodeLocation: BarcodeLocation

    /// Maximum error rate for barcode matching (cutadapt -e). Default 0.15.
    public let errorRate: Double

    /// Minimum overlap between barcode and read (cutadapt --overlap). Default 3.
    public let minimumOverlap: Int

    /// Maximum bases from the 5' terminus where a barcode may begin.
    public let maxDistanceFrom5Prime: Int

    /// Maximum bases from the 3' terminus where a barcode may end.
    public let maxDistanceFrom3Prime: Int

    /// Whether to trim barcode sequences from output reads.
    public let trimBarcodes: Bool

    /// What to do with reads that don't match any barcode.
    public let unassignedDisposition: UnassignedDisposition

    /// Number of threads for cutadapt (--cores).
    public let threads: Int

    /// Optional explicit asymmetric sample assignments.
    ///
    /// When present, these are used to build linked 5'/3' adapters directly,
    /// avoiding cartesian expansion for combinatorial kits.
    public let sampleAssignments: [FASTQSampleBarcodeAssignment]

    public init(
        inputURL: URL,
        barcodeKit: IlluminaBarcodeDefinition,
        outputDirectory: URL,
        barcodeLocation: BarcodeLocation = .bothEnds,
        errorRate: Double = 0.15,
        minimumOverlap: Int = 3,
        maxDistanceFrom5Prime: Int = 0,
        maxDistanceFrom3Prime: Int = 0,
        trimBarcodes: Bool = true,
        unassignedDisposition: UnassignedDisposition = .keep,
        threads: Int = 4,
        sampleAssignments: [FASTQSampleBarcodeAssignment] = []
    ) {
        self.inputURL = inputURL
        self.barcodeKit = barcodeKit
        self.outputDirectory = outputDirectory
        self.barcodeLocation = barcodeLocation
        self.errorRate = errorRate
        self.minimumOverlap = minimumOverlap
        self.maxDistanceFrom5Prime = max(0, maxDistanceFrom5Prime)
        self.maxDistanceFrom3Prime = max(0, maxDistanceFrom3Prime)
        self.trimBarcodes = trimBarcodes
        self.unassignedDisposition = unassignedDisposition
        self.threads = threads
        self.sampleAssignments = sampleAssignments
    }
}

// MARK: - Demultiplex Result

/// Result of a demultiplexing pipeline run.
public struct DemultiplexResult: Sendable {
    /// Generated demultiplex manifest.
    public let manifest: DemultiplexManifest

    /// URLs of created per-barcode .lungfishfastq bundles.
    public let outputBundleURLs: [URL]

    /// URL of the unassigned reads bundle (nil if discarded or empty).
    public let unassignedBundleURL: URL?

    /// Wall clock time in seconds.
    public let wallClockSeconds: Double
}

// MARK: - Demultiplex Error

public enum DemultiplexError: Error, LocalizedError {
    case inputFileNotFound(URL)
    case cutadaptFailed(exitCode: Int32, stderr: String)
    case noBarcodes
    case combinatorialRequiresSampleAssignments
    case outputParsingFailed(String)
    case bundleCreationFailed(barcode: String, underlying: Error)

    public var errorDescription: String? {
        switch self {
        case .inputFileNotFound(let url):
            return "Input FASTQ not found: \(url.lastPathComponent)"
        case .cutadaptFailed(let code, let stderr):
            return "cutadapt failed (exit \(code)): \(String(stderr.suffix(500)))"
        case .noBarcodes:
            return "Barcode kit has no barcodes defined"
        case .combinatorialRequiresSampleAssignments:
            return "Combinatorial kits require explicit sample barcode assignments."
        case .outputParsingFailed(let msg):
            return "Failed to parse cutadapt output: \(msg)"
        case .bundleCreationFailed(let barcode, let error):
            return "Failed to create bundle for \(barcode): \(error)"
        }
    }
}

// MARK: - Demultiplexing Pipeline

/// Demultiplexes FASTQ reads using bundled cutadapt.
///
/// Pipeline steps:
/// 1. Generate adapter FASTA from barcode kit definition
/// 2. Run cutadapt with `{name}` output pattern for per-barcode files
/// 3. Create `.lungfishfastq` bundles from each output file
/// 4. Generate a `DemultiplexManifest` with per-barcode statistics
///
/// Supports both single-indexed and dual-indexed kits and terminally anchored
/// barcode matching with configurable 5'/3' search windows.
///
/// ```
/// input.lungfishfastq/
///   reads.fastq.gz
///   demux-manifest.json          <- written after demux
/// input-demux/
///   D701.lungfishfastq/          <- per-barcode bundles
///   D702.lungfishfastq/
///   unassigned.lungfishfastq/
/// ```
public final class DemultiplexingPipeline: @unchecked Sendable {

    private let runner = NativeToolRunner.shared

    public init() {}

    /// Runs the demultiplexing pipeline.
    ///
    /// - Parameters:
    ///   - config: Demultiplexing configuration.
    ///   - progress: Progress callback (fraction 0-1, status message).
    /// - Returns: Demultiplex result with manifest and bundle URLs.
    public func run(
        config: DemultiplexConfig,
        progress: @escaping @Sendable (Double, String) -> Void
    ) async throws -> DemultiplexResult {
        let startTime = Date()

        guard !config.barcodeKit.barcodes.isEmpty else {
            throw DemultiplexError.noBarcodes
        }

        // Resolve the input FASTQ
        let inputFASTQ = resolveInputFASTQ(config.inputURL)
        guard FileManager.default.fileExists(atPath: inputFASTQ.path) else {
            throw DemultiplexError.inputFileNotFound(inputFASTQ)
        }

        let fm = FileManager.default

        // Create working directories
        let workDir = fm.temporaryDirectory
            .appendingPathComponent("lungfish-demux-\(UUID().uuidString)", isDirectory: true)
        try fm.createDirectory(at: workDir, withIntermediateDirectories: true)
        defer { try? fm.removeItem(at: workDir) }

        try fm.createDirectory(at: config.outputDirectory, withIntermediateDirectories: true)

        // Step 1: Generate adapter FASTA (5% progress)
        progress(0.0, "Generating adapter sequences...")
        let adapterConfig = try await createAdapterConfiguration(
            for: config,
            workDirectory: workDir
        )

        // Step 2: Build cutadapt command (5% progress)
        progress(0.05, "Configuring cutadapt...")

        let demuxOutputDir = workDir.appendingPathComponent("demux-output", isDirectory: true)
        try fm.createDirectory(at: demuxOutputDir, withIntermediateDirectories: true)

        let outputPattern = demuxOutputDir
            .appendingPathComponent("{name}.fastq.gz").path
        let unassignedPath = demuxOutputDir
            .appendingPathComponent("unassigned.fastq.gz").path
        let jsonReportPath = workDir
            .appendingPathComponent("cutadapt-report.json").path

        var args = buildCutadaptArguments(
            config: config,
            adapterFASTA: adapterConfig.adapterFASTA,
            adapterFlag: adapterConfig.adapterFlag,
            outputPattern: outputPattern,
            unassignedPath: unassignedPath,
            jsonReportPath: jsonReportPath
        )

        args.append(inputFASTQ.path)

        // Step 3: Run cutadapt (70% progress)
        progress(0.10, "Running cutadapt demultiplexing...")

        let inputSize = fileSize(inputFASTQ)
        let timeout = max(600.0, Double(inputSize) / 5_000_000)

        let result = try await runner.run(
            .cutadapt,
            arguments: args,
            workingDirectory: workDir,
            timeout: timeout
        )

        guard result.isSuccess else {
            throw DemultiplexError.cutadaptFailed(
                exitCode: result.exitCode,
                stderr: result.stderr
            )
        }

        progress(0.80, "cutadapt complete, creating bundles...")

        // Step 4: Create per-barcode .lungfishfastq bundles (15% progress)
        let demuxOutputContents = try fm.contentsOfDirectory(
            at: demuxOutputDir,
            includingPropertiesForKeys: [.fileSizeKey],
            options: [.skipsHiddenFiles]
        ).filter { $0.pathExtension == "gz" || $0.pathExtension == "fastq" }

        var barcodeResults: [BarcodeResult] = []
        var bundleURLs: [URL] = []
        var unassignedBundleURL: URL?
        var assignedReadCount = 0
        var unassignedReadCount = 0
        var unassignedBaseCount: Int64 = 0
        let progressPerFile = 0.15 / max(1.0, Double(demuxOutputContents.count))

        for (i, outputFile) in demuxOutputContents.enumerated() {
            try Task.checkCancellation()

            let baseName = outputFile.deletingPathExtension().deletingPathExtension().lastPathComponent
            let isUnassigned = baseName == "unassigned"
            let fileBytes = fileSize(outputFile)

            // Skip empty output files (0 bytes or just gzip header)
            if fileBytes <= 20 { continue }

            let bundleName = "\(baseName).\(FASTQBundle.directoryExtension)"
            let bundleURL = config.outputDirectory
                .appendingPathComponent(bundleName, isDirectory: true)
            try fm.createDirectory(at: bundleURL, withIntermediateDirectories: true)

            let destFASTQ = bundleURL.appendingPathComponent("reads.fastq.gz")
            // Use replaceItemAt for idempotent re-runs
            if fm.fileExists(atPath: destFASTQ.path) {
                _ = try fm.replaceItemAt(destFASTQ, withItemAt: outputFile)
            } else {
                try fm.moveItem(at: outputFile, to: destFASTQ)
            }

            // Count reads
            let readCount = countReadsInFASTQ(url: destFASTQ)

            // Estimate base count (compressed bytes × ~1.5 for FASTQ overhead in decompressed)
            let baseCount = Int64(Double(fileBytes) * 1.5)

            if isUnassigned {
                unassignedReadCount = readCount
                unassignedBaseCount = baseCount
                if config.unassignedDisposition == .keep {
                    unassignedBundleURL = bundleURL
                } else {
                    try? fm.removeItem(at: bundleURL)
                }
            } else {
                assignedReadCount += readCount
                let sequenceInfo = barcodeSequenceInfo(
                    for: baseName,
                    kit: config.barcodeKit,
                    sampleAssignments: config.sampleAssignments
                )
                barcodeResults.append(BarcodeResult(
                    barcodeID: baseName,
                    sampleName: sequenceInfo.sampleName,
                    forwardSequence: sequenceInfo.forward,
                    reverseSequence: sequenceInfo.reverse,
                    readCount: readCount,
                    baseCount: baseCount,
                    bundleRelativePath: bundleName
                ))
                bundleURLs.append(bundleURL)
            }

            progress(
                0.80 + Double(i + 1) * progressPerFile,
                "Created bundle for \(baseName)"
            )
        }

        // Sort barcode results by ID
        barcodeResults.sort { $0.barcodeID.localizedStandardCompare($1.barcodeID) == .orderedAscending }

        let elapsed = Date().timeIntervalSince(startTime)

        // Build BarcodeKit for manifest
        let usesExplicitAssignments = !config.sampleAssignments.isEmpty
        let kitForManifest = BarcodeKit(
            name: config.barcodeKit.displayName,
            vendor: config.barcodeKit.vendor,
            barcodeCount: usesExplicitAssignments ? config.sampleAssignments.count : config.barcodeKit.barcodes.count,
            isDualIndexed: usesExplicitAssignments ? true : config.barcodeKit.isDualIndexed,
            barcodeType: usesExplicitAssignments
                ? .asymmetric
                : (config.barcodeKit.pairingMode == .singleEnd ? .singleEnd : .asymmetric)
        )

        // Build the cutadapt version string
        let versionResult = try? await runner.run(.cutadapt, arguments: ["--version"])
        let cutadaptVersion = versionResult?.stdout.trimmingCharacters(in: .whitespacesAndNewlines)

        let manifest = DemultiplexManifest(
            barcodeKit: kitForManifest,
            parameters: DemultiplexParameters(
                tool: "cutadapt",
                toolVersion: cutadaptVersion,
                maxMismatches: Int(config.errorRate * Double(config.barcodeKit.barcodes[0].i7Sequence.count)),
                requireBothEnds: config.barcodeLocation == .bothEnds || config.barcodeKit.isDualIndexed || usesExplicitAssignments,
                trimBarcodes: config.trimBarcodes,
                commandLine: "cutadapt \(args.joined(separator: " "))",
                wallClockSeconds: elapsed
            ),
            barcodes: barcodeResults,
            unassigned: UnassignedReadsSummary(
                readCount: unassignedReadCount,
                baseCount: unassignedBaseCount,
                disposition: config.unassignedDisposition,
                bundleRelativePath: unassignedBundleURL?.lastPathComponent
            ),
            outputDirectoryRelativePath: ".",
            inputReadCount: assignedReadCount + unassignedReadCount
        )

        // Save manifest to output directory
        try manifest.save(to: config.outputDirectory)

        // If input was a .lungfishfastq bundle, also save manifest to the bundle
        if FASTQBundle.isBundleURL(config.inputURL) {
            try? manifest.save(to: config.inputURL)
        }

        progress(1.0, "Demultiplexing complete: \(barcodeResults.count) barcodes, \(String(format: "%.0f%%", manifest.assignmentRate * 100)) assigned")

        logger.info("Demux complete: \(barcodeResults.count) barcodes, \(manifest.assignmentRate * 100)% assigned, \(String(format: "%.1f", elapsed))s")

        return DemultiplexResult(
            manifest: manifest,
            outputBundleURLs: bundleURLs,
            unassignedBundleURL: unassignedBundleURL,
            wallClockSeconds: elapsed
        )
    }

    // MARK: - Private Helpers

    /// Resolves the actual FASTQ file from a URL (handles .lungfishfastq bundles).
    private func resolveInputFASTQ(_ url: URL) -> URL {
        if FASTQBundle.isBundleURL(url) {
            return FASTQBundle.resolvePrimaryFASTQURL(for: url) ?? url
        }
        return url
    }

    private struct AdapterConfiguration {
        let adapterFASTA: URL
        let adapterFlag: String
    }

    private func createAdapterConfiguration(
        for config: DemultiplexConfig,
        workDirectory: URL
    ) async throws -> AdapterConfiguration {
        let adapterFASTA = workDirectory.appendingPathComponent("adapters.fasta")

        if !config.sampleAssignments.isEmpty {
            let entries: [(name: String, first: String, second: String)] = config.sampleAssignments.compactMap { assignment in
                guard let forward = resolveSequence(
                    explicitSequence: assignment.forwardSequence,
                    barcodeID: assignment.forwardBarcodeID,
                    kit: config.barcodeKit
                ), let reverse = resolveSequence(
                    explicitSequence: assignment.reverseSequence,
                    barcodeID: assignment.reverseBarcodeID,
                    kit: config.barcodeKit
                ) else {
                    return nil
                }

                return (
                    name: sanitizedSampleIdentifier(assignment.sampleID),
                    first: contextualizedSequence(forward, role: .i7, vendor: config.barcodeKit.vendor),
                    second: contextualizedSequence(reverse, role: .i5, vendor: config.barcodeKit.vendor)
                )
            }

            guard !entries.isEmpty else {
                throw DemultiplexError.combinatorialRequiresSampleAssignments
            }

            try writeLinkedAdapterFASTA(
                entries: entries,
                location: config.barcodeLocation,
                maxDistanceFrom5Prime: config.maxDistanceFrom5Prime,
                maxDistanceFrom3Prime: config.maxDistanceFrom3Prime,
                to: adapterFASTA
            )
            return AdapterConfiguration(adapterFASTA: adapterFASTA, adapterFlag: "-g")
        }

        switch config.barcodeKit.pairingMode {
        case .singleEnd:
            let entries: [(name: String, sequence: String)] = config.barcodeKit.barcodes.map { barcode in
                (
                    name: barcode.id,
                    sequence: contextualizedSequence(barcode.i7Sequence, role: .i7, vendor: config.barcodeKit.vendor)
                )
            }
            try writeSingleEndAdapterFASTA(
                entries: entries,
                location: config.barcodeLocation,
                maxDistanceFrom5Prime: config.maxDistanceFrom5Prime,
                maxDistanceFrom3Prime: config.maxDistanceFrom3Prime,
                to: adapterFASTA
            )
            return AdapterConfiguration(
                adapterFASTA: adapterFASTA,
                adapterFlag: adapterFlag(for: config.barcodeLocation)
            )

        case .fixedDual:
            let entries: [(name: String, first: String, second: String)] = config.barcodeKit.barcodes.compactMap { barcode in
                guard let i5 = barcode.i5Sequence else { return nil }
                return (
                    name: barcode.id,
                    first: contextualizedSequence(
                        barcode.i7Sequence,
                        role: .i7,
                        vendor: config.barcodeKit.vendor
                    ),
                    second: contextualizedSequence(
                        i5,
                        role: .i5,
                        vendor: config.barcodeKit.vendor
                    )
                )
            }
            guard !entries.isEmpty else { throw DemultiplexError.noBarcodes }
            try writeLinkedAdapterFASTA(
                entries: entries,
                location: config.barcodeLocation,
                maxDistanceFrom5Prime: config.maxDistanceFrom5Prime,
                maxDistanceFrom3Prime: config.maxDistanceFrom3Prime,
                to: adapterFASTA
            )
            return AdapterConfiguration(adapterFASTA: adapterFASTA, adapterFlag: "-g")

        case .combinatorialDual:
            throw DemultiplexError.combinatorialRequiresSampleAssignments
        }
    }

    private enum BarcodeRole {
        case i7
        case i5
    }

    private func contextualizedSequence(_ sequence: String, role: BarcodeRole, vendor: String) -> String {
        guard vendor.lowercased() == "illumina" else { return sequence.uppercased() }
        switch role {
        case .i7:
            return IlluminaAdapterContext.withContext(
                sequence: sequence.uppercased(),
                upstream: IlluminaAdapterContext.i7Upstream,
                downstream: IlluminaAdapterContext.i7Downstream
            )
        case .i5:
            return IlluminaAdapterContext.withContext(
                sequence: sequence.uppercased(),
                upstream: IlluminaAdapterContext.i5Upstream,
                downstream: IlluminaAdapterContext.i5Downstream
            )
        }
    }

    private func adapterFlag(for location: BarcodeLocation) -> String {
        switch location {
        case .fivePrime:
            return "-g"
        case .threePrime:
            return "-a"
        case .bothEnds:
            return "-g"
        }
    }

    private func writeSingleEndAdapterFASTA(
        entries: [(name: String, sequence: String)],
        location: BarcodeLocation,
        maxDistanceFrom5Prime: Int,
        maxDistanceFrom3Prime: Int,
        to outputURL: URL
    ) throws {
        var lines: [String] = []
        let fivePrimeOffsets = Array(0...max(0, maxDistanceFrom5Prime))
        let threePrimeOffsets = Array(0...max(0, maxDistanceFrom3Prime))
        let perEntryPatternCount: Int
        switch location {
        case .fivePrime:
            perEntryPatternCount = fivePrimeOffsets.count
        case .threePrime:
            perEntryPatternCount = threePrimeOffsets.count
        case .bothEnds:
            // Single-end kits are matched as 5' barcodes by convention.
            perEntryPatternCount = fivePrimeOffsets.count
        }
        lines.reserveCapacity(max(1, entries.count * perEntryPatternCount * 2))

        for entry in entries {
            let sequence = entry.sequence.uppercased()
            switch location {
            case .fivePrime:
                for offset in fivePrimeOffsets {
                    lines.append(">\(entry.name)")
                    lines.append("^\(wildcardExact(offset))\(sequence)")
                }
            case .threePrime:
                for offset in threePrimeOffsets {
                    lines.append(">\(entry.name)")
                    lines.append("\(sequence)\(wildcardExact(offset))$")
                }
            case .bothEnds:
                for offset in fivePrimeOffsets {
                    lines.append(">\(entry.name)")
                    lines.append("^\(wildcardExact(offset))\(sequence)")
                }
            }
        }

        let content = lines.joined(separator: "\n") + "\n"
        try content.write(to: outputURL, atomically: true, encoding: .utf8)
    }

    private func writeLinkedAdapterFASTA(
        entries: [(name: String, first: String, second: String)],
        location: BarcodeLocation,
        maxDistanceFrom5Prime: Int,
        maxDistanceFrom3Prime: Int,
        to outputURL: URL
    ) throws {
        var lines: [String] = []
        let fivePrimeOffsets = Array(0...max(0, maxDistanceFrom5Prime))
        let threePrimeOffsets = Array(0...max(0, maxDistanceFrom3Prime))
        let perOrientationPatternCount: Int
        switch location {
        case .fivePrime:
            perOrientationPatternCount = fivePrimeOffsets.count
        case .threePrime:
            perOrientationPatternCount = threePrimeOffsets.count
        case .bothEnds:
            perOrientationPatternCount = fivePrimeOffsets.count * threePrimeOffsets.count
        }
        lines.reserveCapacity(max(1, entries.count * perOrientationPatternCount * 4))

        for entry in entries {
            let first = entry.first.uppercased()
            let second = entry.second.uppercased()
            let forwardPatterns = linkedAdapterPatterns(
                first: first,
                second: second,
                location: location,
                fivePrimeOffsets: fivePrimeOffsets,
                threePrimeOffsets: threePrimeOffsets
            )
            for pattern in forwardPatterns {
                lines.append(">\(entry.name)")
                lines.append(pattern)
            }

            if first != second {
                let reversePatterns = linkedAdapterPatterns(
                    first: second,
                    second: first,
                    location: location,
                    fivePrimeOffsets: fivePrimeOffsets,
                    threePrimeOffsets: threePrimeOffsets
                )
                for pattern in reversePatterns {
                    lines.append(">\(entry.name)")
                    lines.append(pattern)
                }
            }
        }

        let content = lines.joined(separator: "\n") + "\n"
        try content.write(to: outputURL, atomically: true, encoding: .utf8)
    }

    private func linkedAdapterPatterns(
        first: String,
        second: String,
        location: BarcodeLocation,
        fivePrimeOffsets: [Int],
        threePrimeOffsets: [Int]
    ) -> [String] {
        var patterns: [String] = []
        switch location {
        case .fivePrime:
            patterns.reserveCapacity(fivePrimeOffsets.count)
            for offset in fivePrimeOffsets {
                patterns.append("^\(wildcardExact(offset))\(first)...\(second)")
            }
        case .threePrime:
            patterns.reserveCapacity(threePrimeOffsets.count)
            for offset in threePrimeOffsets {
                patterns.append("\(first)...\(second)\(wildcardExact(offset))$")
            }
        case .bothEnds:
            patterns.reserveCapacity(fivePrimeOffsets.count * threePrimeOffsets.count)
            for offset5 in fivePrimeOffsets {
                for offset3 in threePrimeOffsets {
                    patterns.append("^\(wildcardExact(offset5))\(first)...\(second)\(wildcardExact(offset3))$")
                }
            }
        }
        return patterns
    }

    private func wildcardExact(_ offset: Int) -> String {
        let distance = max(0, offset)
        guard distance > 0 else { return "" }
        return "N{\(distance)}"
    }

    private func resolveSequence(
        explicitSequence: String?,
        barcodeID: String?,
        kit: IlluminaBarcodeDefinition
    ) -> String? {
        if let explicitSequence, !explicitSequence.isEmpty {
            return explicitSequence.uppercased()
        }
        guard let barcodeID else { return nil }
        guard let barcode = kit.barcodes.first(where: { $0.id.caseInsensitiveCompare(barcodeID) == .orderedSame }) else {
            return nil
        }
        return barcode.i7Sequence.uppercased()
    }

    private func sanitizedSampleIdentifier(_ sampleID: String) -> String {
        let trimmed = sampleID.trimmingCharacters(in: .whitespacesAndNewlines)
        let sanitized = trimmed
            .replacingOccurrences(of: "[^A-Za-z0-9._-]+", with: "_", options: .regularExpression)
            .trimmingCharacters(in: CharacterSet(charactersIn: "._-"))
        return sanitized.isEmpty ? "sample" : sanitized
    }

    private func canonicalSampleID(_ value: String) -> String {
        sanitizedSampleIdentifier(value).lowercased()
    }

    private func sampleAssignmentLookup(
        _ assignments: [FASTQSampleBarcodeAssignment]
    ) -> [String: FASTQSampleBarcodeAssignment] {
        var lookup: [String: FASTQSampleBarcodeAssignment] = [:]
        for assignment in assignments {
            lookup[canonicalSampleID(assignment.sampleID)] = assignment
        }
        return lookup
    }

    private func sampleAssignment(
        for outputName: String,
        assignments: [FASTQSampleBarcodeAssignment]
    ) -> FASTQSampleBarcodeAssignment? {
        let lookup = sampleAssignmentLookup(assignments)
        return lookup[canonicalSampleID(outputName)]
    }

    private func assignmentSequence(_ explicit: String?, id: String?, kit: IlluminaBarcodeDefinition) -> String? {
        resolveSequence(explicitSequence: explicit, barcodeID: id, kit: kit)
    }

    private func barcodeSequenceInfo(
        for outputName: String,
        kit: IlluminaBarcodeDefinition,
        sampleAssignments: [FASTQSampleBarcodeAssignment]
    ) -> (sampleName: String?, forward: String?, reverse: String?) {
        if let assignment = sampleAssignment(for: outputName, assignments: sampleAssignments) {
            let sampleLabel = assignment.sampleName ?? assignment.sampleID
            let forward = assignmentSequence(assignment.forwardSequence, id: assignment.forwardBarcodeID, kit: kit)
            let reverse = assignmentSequence(assignment.reverseSequence, id: assignment.reverseBarcodeID, kit: kit)
            return (sampleLabel, forward, reverse)
        }

        switch kit.pairingMode {
        case .singleEnd, .fixedDual:
            if let barcode = kit.barcodes.first(where: { $0.id == outputName }) {
                return (barcode.sampleName, barcode.i7Sequence, barcode.i5Sequence)
            }
            return (nil, nil, nil)

        case .combinatorialDual:
            let parts = outputName.components(separatedBy: "--")
            if parts.count == 2,
               let first = kit.barcodes.first(where: { $0.id == parts[0] }),
               let second = kit.barcodes.first(where: { $0.id == parts[1] }) {
                return (nil, first.i7Sequence, second.i7Sequence)
            }
            if let barcode = kit.barcodes.first(where: { $0.id == outputName }) {
                return (barcode.sampleName, barcode.i7Sequence, nil)
            }
            return (nil, nil, nil)
        }
    }

    /// Builds the cutadapt argument array.
    private func buildCutadaptArguments(
        config: DemultiplexConfig,
        adapterFASTA: URL,
        adapterFlag: String,
        outputPattern: String,
        unassignedPath: String,
        jsonReportPath: String
    ) -> [String] {
        var args: [String] = []

        // Adapter specification.
        args += [adapterFlag, "file:\(adapterFASTA.path)"]

        // Error rate and overlap
        args += ["-e", String(config.errorRate)]
        args += ["--overlap", String(config.minimumOverlap)]

        // Search both strand orientations (ONT reads can be in either direction)
        args += ["--revcomp"]

        // Single-end barcode mode can trim both ends from one read via repeated matching.
        if config.barcodeKit.pairingMode == .singleEnd {
            args += ["--times", "2"]
        }

        // Trim or retain barcode
        args += ["--action", config.trimBarcodes ? "trim" : "none"]

        // Output: cutadapt {name} pattern creates one file per adapter name
        args += ["-o", outputPattern]

        // Unassigned reads
        args += ["--untrimmed-output", unassignedPath]

        // JSON report
        args += ["--json", jsonReportPath]

        // Threading
        args += ["--cores", String(max(1, config.threads))]

        return args
    }

    /// Returns file size in bytes.
    private func fileSize(_ url: URL) -> Int64 {
        (try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int64) ?? 0
    }

    /// Counts reads in a FASTQ file (gzipped or plain).
    private func countReadsInFASTQ(url: URL) -> Int {
        let isGzipped = url.pathExtension.lowercased() == "gz"

        let process = Process()
        if isGzipped {
            process.executableURL = URL(fileURLWithPath: "/usr/bin/gzcat")
            process.arguments = [url.path]
        } else {
            process.executableURL = URL(fileURLWithPath: "/bin/cat")
            process.arguments = [url.path]
        }

        let countProcess = Process()
        countProcess.executableURL = URL(fileURLWithPath: "/usr/bin/wc")
        countProcess.arguments = ["-l"]

        let pipe = Pipe()
        process.standardOutput = pipe
        countProcess.standardInput = pipe

        let outputPipe = Pipe()
        countProcess.standardOutput = outputPipe
        process.standardError = FileHandle.nullDevice
        countProcess.standardError = FileHandle.nullDevice

        do {
            try process.run()
            try countProcess.run()

            let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
            process.waitUntilExit()
            countProcess.waitUntilExit()

            if let str = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
               let lineCount = Int(str) {
                return lineCount / 4  // 4 lines per FASTQ record
            }
        } catch {
            logger.warning("Failed to count reads in \(url.lastPathComponent): \(error)")
        }

        return 0
    }
}
