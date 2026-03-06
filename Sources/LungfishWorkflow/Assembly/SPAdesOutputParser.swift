// SPAdesOutputParser.swift - Parses SPAdes log output for progress and errors
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation

// MARK: - SPAdesStage

/// Stages of the SPAdes assembly pipeline.
public enum SPAdesStage: String, Sendable, CaseIterable {
    case started = "started"
    case errorCorrection = "error_correction"
    case assembling = "assembling"
    case kmerIteration = "kmer_iteration"
    case mismatchCorrection = "mismatch_correction"
    case scaffolding = "scaffolding"
    case writingOutput = "writing_output"
    case finished = "finished"
    case failed = "failed"

    /// Human-readable display name.
    public var displayName: String {
        switch self {
        case .started: return "Starting"
        case .errorCorrection: return "Error correction"
        case .assembling: return "Assembling"
        case .kmerIteration: return "K-mer iteration"
        case .mismatchCorrection: return "Mismatch correction"
        case .scaffolding: return "Scaffolding"
        case .writingOutput: return "Writing output"
        case .finished: return "Finished"
        case .failed: return "Failed"
        }
    }
}

// MARK: - SPAdesProgress

/// Progress update from SPAdes log parsing.
public struct SPAdesProgress: Sendable {
    /// Current stage of the pipeline.
    public let stage: SPAdesStage
    /// Progress fraction (0.0 to 1.0), nil if indeterminate.
    public let fraction: Double?
    /// Human-readable status message.
    public let message: String
    /// K-mer size if in a k-mer iteration stage.
    public let kmerSize: Int?

    public init(stage: SPAdesStage, fraction: Double?, message: String, kmerSize: Int? = nil) {
        self.stage = stage
        self.fraction = fraction
        self.message = message
        self.kmerSize = kmerSize
    }
}

// MARK: - SPAdesError

/// Errors detected in SPAdes log output.
public enum SPAdesError: Sendable, Equatable {
    case outOfMemory(String)
    case diskFull(String)
    case invalidInput(String)
    case internalError(String)
    case unknown(String)

    /// Human-readable description.
    public var description: String {
        switch self {
        case .outOfMemory(let detail): return "Out of memory: \(detail)"
        case .diskFull(let detail): return "Disk full: \(detail)"
        case .invalidInput(let detail): return "Invalid input: \(detail)"
        case .internalError(let detail): return "Internal error: \(detail)"
        case .unknown(let detail): return "Error: \(detail)"
        }
    }

    /// Recovery suggestion for the user.
    public var recoverySuggestion: String {
        switch self {
        case .outOfMemory:
            return "Increase memory allocation or reduce k-mer sizes"
        case .diskFull:
            return "Free disk space. SPAdes needs ~5-10x input size"
        case .invalidInput:
            return "Check that input files are valid FASTQ format"
        case .internalError:
            return "Check the full SPAdes log for details"
        case .unknown:
            return "Check the full SPAdes log for details"
        }
    }
}

// MARK: - SPAdesOutputParser

/// Parses SPAdes stderr/log output to extract progress, stage transitions, and errors.
///
/// SPAdes writes stage transitions to stderr in the format:
/// ```
/// == Running read error correction ==
/// == Running assembler ==
/// == K21 ==
/// == K33 ==
/// ...
/// == SPAdes pipeline finished ==
/// ```
///
/// This parser extracts structured progress updates from these lines.
public struct SPAdesOutputParser: Sendable {

    /// K-mer sizes expected in the run (for progress interpolation).
    /// If nil, uses default SPAdes auto k-mers.
    private let expectedKmers: [Int]?

    /// Creates a parser.
    ///
    /// - Parameter expectedKmers: Custom k-mer sizes, or nil for auto detection
    public init(expectedKmers: [Int]? = nil) {
        self.expectedKmers = expectedKmers
    }

    // MARK: - Stage Detection

    /// Parses a single log line and returns a progress update if the line indicates a stage transition.
    ///
    /// - Parameter line: A single line from SPAdes stderr/log
    /// - Returns: A progress update, or nil if the line is not a stage transition
    public func parseLine(_ line: String) -> SPAdesProgress? {
        let trimmed = line.trimmingCharacters(in: .whitespaces)

        // Stage markers: "== <stage name> =="
        if trimmed.hasPrefix("==") && trimmed.hasSuffix("==") {
            let inner = trimmed
                .dropFirst(2).dropLast(2)
                .trimmingCharacters(in: .whitespaces)

            return parseStageMarker(inner)
        }

        return nil
    }

    /// Detects errors in a log line.
    ///
    /// - Parameter line: A single line from SPAdes stderr/log
    /// - Returns: A detected error, or nil
    public func detectError(_ line: String) -> SPAdesError? {
        let lower = line.lowercased()

        if lower.contains("not enough memory") || lower.contains("out of memory")
            || lower.contains("mmap") && lower.contains("cannot allocate")
            || lower.contains("bad_alloc")
        {
            return .outOfMemory(line.trimmingCharacters(in: .whitespacesAndNewlines))
        }

        if lower.contains("no space left") || lower.contains("disk quota exceeded") {
            return .diskFull(line.trimmingCharacters(in: .whitespacesAndNewlines))
        }

        if lower.contains("error") && lower.contains("input") && lower.contains("file") {
            return .invalidInput(line.trimmingCharacters(in: .whitespacesAndNewlines))
        }

        if lower.contains("error!") || lower.contains("exception") || lower.contains("traceback") {
            return .internalError(line.trimmingCharacters(in: .whitespacesAndNewlines))
        }

        return nil
    }

    /// Extracts the SPAdes version from a `spades.py --version` output line.
    ///
    /// - Parameter output: Output from `spades.py --version`
    /// - Returns: Version string (e.g., "4.0.0"), or nil if not found
    public static func parseVersion(_ output: String) -> String? {
        // SPAdes outputs: "SPAdes genome assembler v4.0.0"
        // or just "v4.0.0"
        let pattern = /v?(\d+\.\d+\.\d+)/
        if let match = output.firstMatch(of: pattern) {
            return String(match.1)
        }
        return nil
    }

    // MARK: - Private

    private func parseStageMarker(_ inner: String) -> SPAdesProgress {
        let lower = inner.lowercased()

        // K-mer iteration: "K21", "K33", etc.
        if let kMatch = inner.firstMatch(of: /^K(\d+)$/) {
            let k = Int(kMatch.1)!
            let fraction = kmerProgress(k)
            return SPAdesProgress(
                stage: .kmerIteration,
                fraction: fraction,
                message: "Assembling with k=\(k)",
                kmerSize: k
            )
        }

        if lower.contains("read error correction") || lower.contains("error correction") {
            return SPAdesProgress(stage: .errorCorrection, fraction: 0.10, message: "Running error correction")
        }

        if lower.contains("running assembler") {
            return SPAdesProgress(stage: .assembling, fraction: 0.30, message: "Running assembler")
        }

        if lower.contains("mismatch correction") {
            return SPAdesProgress(stage: .mismatchCorrection, fraction: 0.75, message: "Mismatch correction")
        }

        if lower.contains("scaffolding") {
            return SPAdesProgress(stage: .scaffolding, fraction: 0.85, message: "Scaffolding")
        }

        if lower.contains("writing output") {
            return SPAdesProgress(stage: .writingOutput, fraction: 0.90, message: "Writing output")
        }

        if lower.contains("pipeline finished") || lower.contains("spades pipeline finished") {
            return SPAdesProgress(stage: .finished, fraction: 0.95, message: "SPAdes pipeline finished")
        }

        // Unknown stage marker
        return SPAdesProgress(stage: .assembling, fraction: nil, message: inner)
    }

    /// Interpolates progress for a k-mer iteration.
    private func kmerProgress(_ k: Int) -> Double {
        let defaultKmers = [21, 33, 55, 77, 99, 127]
        let kmers = expectedKmers ?? defaultKmers

        guard let idx = kmers.firstIndex(of: k) else {
            // Unknown k-mer, estimate based on value
            let fraction = Double(k - 21) / Double(127 - 21)
            return 0.30 + fraction * 0.40  // 30% to 70%
        }

        let fraction = Double(idx) / Double(max(kmers.count - 1, 1))
        return 0.30 + fraction * 0.40  // 30% to 70%
    }
}
