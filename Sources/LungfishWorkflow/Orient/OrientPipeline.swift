// OrientPipeline.swift - Orient FASTQ reads using vsearch
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import LungfishIO
import os.log

private let logger = Logger(subsystem: "com.lungfish.workflow", category: "OrientPipeline")

/// Configuration for the orient pipeline.
public struct OrientConfig: Sendable {
    /// Path to the input FASTQ file.
    public let inputURL: URL

    /// Path to the reference FASTA file (in the desired forward orientation).
    public let referenceURL: URL

    /// Word length for vsearch k-mer matching (3-15, default 12).
    public let wordLength: Int

    /// Low-complexity masking mode for the database ("dust" or "none").
    public let dbMask: String

    /// Low-complexity masking mode for queries ("dust" or "none").
    public let qMask: String

    /// Whether to save unoriented reads as a separate derivative.
    public let saveUnoriented: Bool

    /// Number of threads (0 = all cores).
    public let threads: Int

    public init(
        inputURL: URL,
        referenceURL: URL,
        wordLength: Int = 12,
        dbMask: String = "dust",
        qMask: String = "dust",
        saveUnoriented: Bool = true,
        threads: Int = 0
    ) {
        self.inputURL = inputURL
        self.referenceURL = referenceURL
        self.wordLength = wordLength
        self.dbMask = dbMask
        self.qMask = qMask
        self.saveUnoriented = saveUnoriented
        self.threads = threads
    }
}

/// Result of an orient pipeline run.
public struct OrientResult: Sendable {
    /// Path to the oriented FASTQ output.
    public let orientedFASTQ: URL

    /// Path to the unoriented reads output (nil if saveUnoriented was false).
    public let unorientedFASTQ: URL?

    /// Path to the tabbed orientation results.
    public let tabbedOutput: URL

    /// Number of reads that were already in forward orientation.
    public let forwardCount: Int

    /// Number of reads that were reverse-complemented.
    public let reverseComplementedCount: Int

    /// Number of reads that could not be oriented.
    public let unmatchedCount: Int

    /// Total reads processed.
    public var totalCount: Int { forwardCount + reverseComplementedCount + unmatchedCount }

    /// Wall clock time in seconds.
    public let wallClockSeconds: Double
}

/// Pipeline for orienting FASTQ reads against a reference using vsearch.
///
/// Uses `vsearch --orient` to determine the correct orientation of each read
/// relative to a reference sequence. Reads that are in reverse complement
/// orientation are RC'd to match the reference.
///
/// Results are stored as a lightweight orient-map TSV file rather than a
/// full copy of the oriented FASTQ.
public final class OrientPipeline: @unchecked Sendable {
    private let runner: NativeToolRunner

    public init(runner: NativeToolRunner? = nil) {
        if let runner {
            self.runner = runner
        } else {
            self.runner = NativeToolRunner()
        }
    }

    /// Runs the orient pipeline.
    ///
    /// - Parameters:
    ///   - config: Orient configuration
    ///   - progress: Progress callback (fraction 0-1, message)
    /// - Returns: OrientResult with paths and statistics
    public func run(
        config: OrientConfig,
        progress: @Sendable (Double, String) -> Void = { _, _ in }
    ) async throws -> OrientResult {
        let startTime = Date()
        let fm = FileManager.default

        // Validate inputs exist
        guard fm.fileExists(atPath: config.inputURL.path) else {
            throw OrientPipelineError.inputNotFound(config.inputURL)
        }
        guard fm.fileExists(atPath: config.referenceURL.path) else {
            throw OrientPipelineError.referenceNotFound(config.referenceURL)
        }

        // Create work directory
        let workDir = fm.temporaryDirectory.appendingPathComponent(
            "lungfish-orient-\(UUID().uuidString)", isDirectory: true
        )
        try fm.createDirectory(at: workDir, withIntermediateDirectories: true)

        progress(0.05, "Starting orientation against reference...")

        // Build vsearch arguments
        let orientedOutput = workDir.appendingPathComponent("oriented.fastq")
        let tabbedOutput = workDir.appendingPathComponent("orient-results.tsv")

        var args: [String] = [
            "--orient", config.inputURL.path,
            "--db", config.referenceURL.path,
            "--fastqout", orientedOutput.path,
            "--tabbedout", tabbedOutput.path,
            "--wordlength", String(config.wordLength),
            "--dbmask", config.dbMask,
            "--qmask", config.qMask,
            "--threads", String(config.threads),
        ]

        var unmatchedOutput: URL?
        if config.saveUnoriented {
            let unmatchedURL = workDir.appendingPathComponent("unoriented.fastq")
            args.append(contentsOf: ["--notmatched", unmatchedURL.path])
            unmatchedOutput = unmatchedURL
        }

        progress(0.10, "Running vsearch orient...")

        let result = try await runner.run(
            .vsearch,
            arguments: args,
            workingDirectory: workDir,
            timeout: 1800
        )

        guard result.isSuccess else {
            throw OrientPipelineError.vsearchFailed(result.stderr)
        }

        progress(0.70, "Parsing orientation results...")

        // Parse the tabbed output to count orientations
        let (forwardCount, rcCount, unmatchedCount) = try parseOrientResults(tabbedOutput)

        progress(0.90, "Orient complete: \(forwardCount) forward, \(rcCount) RC'd, \(unmatchedCount) unmatched")

        let elapsed = Date().timeIntervalSince(startTime)
        logger.info("Orient complete in \(String(format: "%.1f", elapsed))s: \(forwardCount) fwd, \(rcCount) rc, \(unmatchedCount) unmatched")

        return OrientResult(
            orientedFASTQ: orientedOutput,
            unorientedFASTQ: unmatchedOutput,
            tabbedOutput: tabbedOutput,
            forwardCount: forwardCount,
            reverseComplementedCount: rcCount,
            unmatchedCount: unmatchedCount,
            wallClockSeconds: elapsed
        )
    }

    /// Creates an orient-map TSV from vsearch tabbed output.
    ///
    /// The orient-map format is simpler than vsearch's tabbed output:
    /// just `read_id\t+/-\n` for each read that was successfully oriented.
    /// Unmatched reads (orientation "?") are excluded.
    ///
    /// - Parameters:
    ///   - tabbedOutput: URL to vsearch's --tabbedout file
    ///   - outputURL: URL to write the orient-map TSV
    /// - Returns: Tuple of (forwardCount, rcCount) for reads written
    public func createOrientMap(
        from tabbedOutput: URL,
        to outputURL: URL
    ) throws -> (forwardCount: Int, rcCount: Int) {
        let content = try String(contentsOf: tabbedOutput, encoding: .utf8)
        FileManager.default.createFile(atPath: outputURL.path, contents: nil)
        let handle = try FileHandle(forWritingTo: outputURL)
        defer { try? handle.close() }

        var forwardCount = 0
        var rcCount = 0

        for line in content.split(separator: "\n", omittingEmptySubsequences: true) {
            let fields = line.split(separator: "\t")
            guard fields.count >= 2 else { continue }
            let readID = String(fields[0])
            let orientation = String(fields[1])

            if orientation == "+" {
                handle.write(Data("\(readID)\t+\n".utf8))
                forwardCount += 1
            } else if orientation == "-" {
                handle.write(Data("\(readID)\t-\n".utf8))
                rcCount += 1
            }
            // Skip "?" (unmatched) reads
        }

        return (forwardCount, rcCount)
    }

    // MARK: - Private

    /// Parses vsearch tabbed output to count orientations.
    private func parseOrientResults(_ url: URL) throws -> (forward: Int, rc: Int, unmatched: Int) {
        let content = try String(contentsOf: url, encoding: .utf8)
        var forward = 0
        var rc = 0
        var unmatched = 0

        for line in content.split(separator: "\n", omittingEmptySubsequences: true) {
            let fields = line.split(separator: "\t")
            guard fields.count >= 2 else { continue }
            switch fields[1] {
            case "+": forward += 1
            case "-": rc += 1
            default: unmatched += 1
            }
        }
        return (forward, rc, unmatched)
    }
}

// MARK: - Errors

public enum OrientPipelineError: Error, LocalizedError, Sendable {
    case vsearchFailed(String)
    case referenceNotFound(URL)
    case inputNotFound(URL)

    public var errorDescription: String? {
        switch self {
        case .vsearchFailed(let stderr):
            return "vsearch orient failed: \(stderr)"
        case .referenceNotFound(let url):
            return "Reference FASTA not found: \(url.lastPathComponent)"
        case .inputNotFound(let url):
            return "Input FASTQ not found: \(url.lastPathComponent)"
        }
    }
}
