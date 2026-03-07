// FASTQIngestionPipeline.swift - Clumpify, compress, and index FASTQ files
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import os.log

private let logger = Logger(subsystem: "com.lungfish.workflow", category: "FASTQIngestionPipeline")

// MARK: - FASTQIngestionConfig

/// Configuration for the FASTQ ingestion pipeline.
public struct FASTQIngestionConfig: Sendable {

    /// Pairing mode for the input files.
    public enum PairingMode: String, Sendable {
        case singleEnd
        case pairedEnd
        case interleaved
    }

    /// Input FASTQ files. For paired-end, provide [R1, R2].
    public let inputFiles: [URL]

    /// Pairing mode.
    public let pairingMode: PairingMode

    /// Output directory where the processed file will be written.
    public let outputDirectory: URL

    /// Number of threads for pigz compression.
    public let threads: Int

    /// Whether to delete original files after successful ingestion.
    public let deleteOriginals: Bool

    /// Quality binning scheme for compression optimization.
    public let qualityBinning: QualityBinningScheme

    public init(
        inputFiles: [URL],
        pairingMode: PairingMode = .singleEnd,
        outputDirectory: URL,
        threads: Int = 4,
        deleteOriginals: Bool = true,
        qualityBinning: QualityBinningScheme = .illumina4
    ) {
        self.inputFiles = inputFiles
        self.pairingMode = pairingMode
        self.outputDirectory = outputDirectory
        self.threads = threads
        self.deleteOriginals = deleteOriginals
        self.qualityBinning = qualityBinning
    }
}

// MARK: - FASTQIngestionResult

/// Result of the FASTQ ingestion pipeline.
public struct FASTQIngestionResult: Sendable {
    /// URL of the final processed FASTQ file (.fastq.gz).
    public let outputFile: URL
    /// URL of the FASTQ index file (.fastq.gz.fai).
    public let indexFile: URL?
    /// Whether the file was clumpified (k-mer sorted).
    public let wasClumpified: Bool
    /// Quality binning scheme applied.
    public let qualityBinning: QualityBinningScheme
    /// Original filenames before processing.
    public let originalFilenames: [String]
    /// Original total size in bytes (before processing).
    public let originalSizeBytes: Int64
    /// Final size in bytes (after processing).
    public let finalSizeBytes: Int64
    /// Pairing mode of the output.
    public let pairingMode: FASTQIngestionConfig.PairingMode
}

// MARK: - FASTQIngestionError

public enum FASTQIngestionError: Error, LocalizedError {
    case noInputFiles
    case inputFileNotFound(URL)
    case pairedEndRequiresTwoFiles
    case clumpifyFailed(String)
    case compressionFailed(String)
    case indexingFailed(String)
    case toolNotFound(String)

    public var errorDescription: String? {
        switch self {
        case .noInputFiles:
            return "No input FASTQ files provided"
        case .inputFileNotFound(let url):
            return "Input file not found: \(url.lastPathComponent)"
        case .pairedEndRequiresTwoFiles:
            return "Paired-end mode requires exactly 2 input files (R1 and R2)"
        case .clumpifyFailed(let msg):
            return "Clumpify failed: \(msg)"
        case .compressionFailed(let msg):
            return "Compression failed: \(msg)"
        case .indexingFailed(let msg):
            return "Indexing failed: \(msg)"
        case .toolNotFound(let tool):
            return "Required tool not found: \(tool)"
        }
    }
}

// MARK: - FASTQIngestionPipeline

/// Pipeline that processes raw FASTQ files into a compressed, optimized format:
/// 1. **Clumpify** (native Swift) — reorders reads by k-mer hash + bins quality scores
/// 2. **Compress** (pigz/bgzip) — parallel gzip compression
/// 3. **Index** (samtools fqidx) — creates .fai index for random access
///
/// The clumpify step sorts reads so that sequences sharing k-mers are adjacent,
/// letting gzip find longer matches. Quality binning reduces the quality alphabet
/// from ~42 to 4-8 distinct values, further improving compression.
///
/// Original files are deleted after successful processing.
public final class FASTQIngestionPipeline: @unchecked Sendable {

    private let runner = NativeToolRunner.shared

    public init() {}

    /// Runs the ingestion pipeline.
    ///
    /// - Parameters:
    ///   - config: Ingestion configuration
    ///   - progress: Progress callback (fraction 0-1, status message)
    /// - Returns: Ingestion result with output file paths
    public func run(
        config: FASTQIngestionConfig,
        progress: @escaping @Sendable (Double, String) -> Void
    ) async throws -> FASTQIngestionResult {

        // Validate inputs
        guard !config.inputFiles.isEmpty else {
            throw FASTQIngestionError.noInputFiles
        }

        if config.pairingMode == .pairedEnd && config.inputFiles.count != 2 {
            throw FASTQIngestionError.pairedEndRequiresTwoFiles
        }

        for file in config.inputFiles {
            guard FileManager.default.fileExists(atPath: file.path) else {
                throw FASTQIngestionError.inputFileNotFound(file)
            }
        }

        let originalFilenames = config.inputFiles.map { $0.lastPathComponent }
        let originalSize = config.inputFiles.reduce(Int64(0)) { total, url in
            let attrs = try? FileManager.default.attributesOfItem(atPath: url.path)
            return total + (attrs?[.size] as? Int64 ?? 0)
        }

        let baseName = Self.deriveBaseName(from: config.inputFiles[0])
        let outputFile = config.outputDirectory.appendingPathComponent("\(baseName).fastq.gz")

        try FileManager.default.createDirectory(
            at: config.outputDirectory,
            withIntermediateDirectories: true
        )

        // Step 1: Clumpify + quality bin (50% of progress)
        progress(0.0, "Sorting reads by k-mer similarity...")
        let clumpifiedFile: URL
        let wasClumpified: Bool

        do {
            clumpifiedFile = try await clumpify(
                config: config,
                baseName: baseName,
                progress: { fraction, msg in
                    progress(fraction * 0.5, msg)
                }
            )
            wasClumpified = true
        } catch {
            logger.warning("Clumpify failed (non-fatal): \(error)")
            clumpifiedFile = config.inputFiles[0]
            wasClumpified = false
            progress(0.5, "Clumpify failed, continuing with original...")
        }

        try Task.checkCancellation()

        // Step 2: Compress with pigz/bgzip (35% of progress)
        progress(0.5, "Compressing...")
        let compressedFile: URL

        if clumpifiedFile.pathExtension == "gz" && !wasClumpified {
            // Already compressed and no clumpification happened
            compressedFile = clumpifiedFile
            progress(0.85, "Already compressed")
        } else {
            compressedFile = try await compress(
                inputFile: clumpifiedFile,
                outputFile: outputFile,
                threads: config.threads,
                progress: { fraction, msg in
                    progress(0.5 + fraction * 0.35, msg)
                }
            )
            // Remove uncompressed clumpified temp file
            if wasClumpified {
                try? FileManager.default.removeItem(at: clumpifiedFile)
            }
        }

        try Task.checkCancellation()

        // Step 3: Index with samtools fqidx (15% of progress)
        progress(0.85, "Indexing with samtools fqidx...")
        let indexFile: URL?
        do {
            indexFile = try await index(
                fastqFile: compressedFile,
                progress: { fraction, msg in
                    progress(0.85 + fraction * 0.15, msg)
                }
            )
        } catch {
            logger.warning("FASTQ indexing failed (non-fatal): \(error)")
            indexFile = nil
        }

        // Delete originals if requested
        if config.deleteOriginals {
            for original in config.inputFiles {
                if original != compressedFile {
                    try? FileManager.default.removeItem(at: original)
                    logger.info("Deleted original: \(original.lastPathComponent)")
                }
            }
        }

        let finalAttrs = try? FileManager.default.attributesOfItem(atPath: compressedFile.path)
        let finalSize = (finalAttrs?[.size] as? Int64) ?? 0

        progress(1.0, "Ingestion complete")

        return FASTQIngestionResult(
            outputFile: compressedFile,
            indexFile: indexFile,
            wasClumpified: wasClumpified,
            qualityBinning: config.qualityBinning,
            originalFilenames: originalFilenames,
            originalSizeBytes: originalSize,
            finalSizeBytes: finalSize,
            pairingMode: config.pairingMode
        )
    }

    // MARK: - Pipeline Steps

    /// Sorts reads by k-mer hash and bins quality scores using native Swift.
    private func clumpify(
        config: FASTQIngestionConfig,
        baseName: String,
        progress: @escaping @Sendable (Double, String) -> Void
    ) async throws -> URL {
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("lungfish-clumpify-\(UUID().uuidString.prefix(8))")
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        let outputFile = tempDir.appendingPathComponent("\(baseName).clumpified.fastq")

        let clumpifier = ReadClumpifier(
            kmerSize: 31,
            binningScheme: config.qualityBinning
        )

        // For now, process the first input file.
        // Paired-end interleaving can be added later.
        let inputFile = config.inputFiles[0]

        let result = try await clumpifier.process(
            inputFile: inputFile,
            outputFile: outputFile,
            progress: progress
        )

        logger.info("Clumpified \(result.readCount) reads (\(config.qualityBinning.rawValue) binning)")

        return outputFile
    }

    /// Compresses a FASTQ file with pigz (parallel gzip) or bgzip.
    private func compress(
        inputFile: URL,
        outputFile: URL,
        threads: Int,
        progress: @escaping @Sendable (Double, String) -> Void
    ) async throws -> URL {
        let tool: NativeTool
        let args: [String]

        if (try? await runner.toolPath(for: .pigz)) != nil {
            tool = .pigz
            args = ["-p", String(threads), "-c", inputFile.path]
        } else if (try? await runner.toolPath(for: .bgzip)) != nil {
            tool = .bgzip
            args = ["-@", String(threads), "-c", inputFile.path]
        } else {
            throw FASTQIngestionError.toolNotFound("pigz or bgzip")
        }

        let inputAttrs = try? FileManager.default.attributesOfItem(atPath: inputFile.path)
        let inputSize = (inputAttrs?[.size] as? Int64) ?? 0
        let timeoutSeconds = max(600, Double(inputSize) / 5_000_000)

        progress(0.1, "Compressing with \(tool.executableName)...")

        let result = try await runner.runWithFileOutput(
            tool,
            arguments: args,
            outputFile: outputFile,
            timeout: timeoutSeconds
        )

        guard result.isSuccess else {
            throw FASTQIngestionError.compressionFailed(
                String(result.stderr.suffix(500)).trimmingCharacters(in: .whitespacesAndNewlines)
            )
        }

        progress(1.0, "Compression complete")
        return outputFile
    }

    /// Creates a FASTQ index with samtools fqidx.
    private func index(
        fastqFile: URL,
        progress: @escaping @Sendable (Double, String) -> Void
    ) async throws -> URL {
        let args = ["fqidx", fastqFile.path]

        let inputAttrs = try? FileManager.default.attributesOfItem(atPath: fastqFile.path)
        let inputSize = (inputAttrs?[.size] as? Int64) ?? 0
        let timeoutSeconds = max(300, Double(inputSize) / 10_000_000)

        progress(0.1, "Creating FASTQ index...")

        let result = try await runner.run(
            .samtools,
            arguments: args,
            timeout: timeoutSeconds
        )

        guard result.isSuccess else {
            throw FASTQIngestionError.indexingFailed(
                String(result.stderr.suffix(500)).trimmingCharacters(in: .whitespacesAndNewlines)
            )
        }

        let indexFile = fastqFile.appendingPathExtension("fai")
        progress(1.0, "Index created")
        return indexFile
    }

    // MARK: - Helpers

    /// Derives a clean base name from a FASTQ filename.
    ///
    /// Strips common suffixes: `.fastq`, `.fq`, `.gz`, `_R1`, `_R2`, `_1`, `_2`
    public static func deriveBaseName(from url: URL) -> String {
        var name = url.lastPathComponent

        // Strip extensions
        let extensions = [".gz", ".fastq", ".fq", ".fastq.gz", ".fq.gz"]
        for ext in extensions.sorted(by: { $0.count > $1.count }) {
            if name.hasSuffix(ext) {
                name = String(name.dropLast(ext.count))
                break
            }
        }

        // Strip paired-end suffixes
        let suffixes = ["_R1", "_R2", "_1", "_2", "_r1", "_r2"]
        for suffix in suffixes {
            if name.hasSuffix(suffix) {
                name = String(name.dropLast(suffix.count))
                break
            }
        }

        return name
    }
}
