// ClassifierReadResolver.swift — Unified classifier read extraction actor
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import LungfishCore
import LungfishIO
import os.log

private let logger = Logger(
    subsystem: "com.lungfish.workflow",
    category: "ClassifierReadResolver"
)

// MARK: - ClassifierReadResolver

/// Unified extraction actor that takes a tool + row selection + destination
/// and produces an ``ExtractionOutcome``.
///
/// The resolver is the single point through which all classifier read
/// extraction must pass. It replaces four prior parallel implementations
/// (EsViritu / TaxTriage / NAO-MGS hand-rolled `extractByBAMRegion` callers,
/// Kraken2 `TaxonomyExtractionSheet` wizard) so that:
///
/// 1. A single samtools flag filter (`-F 0x404` by default) matches the
///    `MarkdupService.countReads` "Unique Reads" figure shown in the UI.
/// 2. Changes to the extraction pipeline have exactly one place to land.
/// 3. The CLI `--by-classifier` strategy and the GUI extraction dialog share
///    the same backend byte-for-byte (see `ClassifierCLIRoundTripTests`).
///
/// ## Dispatch
///
/// The public API takes a `ClassifierTool` and branches on `usesBAMDispatch`:
///
/// - BAM-backed tools (EsViritu, TaxTriage, NAO-MGS, NVD) run
///   `samtools view -F <flags> -b <bam> <regions...>` to a temp BAM, then
///   `samtools fastq` to a per-sample FASTQ, and concatenate per-sample
///   outputs before routing to the destination.
/// - Kraken2 wraps the existing `TaxonomyExtractionPipeline.extract` with
///   `includeChildren: true` always, then routes its output to the destination.
///
/// ## Thread safety
///
/// `ClassifierReadResolver` is an actor — all method calls are serialised.
public actor ClassifierReadResolver {

    // MARK: - Properties

    private let toolRunner: NativeToolRunner

    // MARK: - Initialization

    /// Creates a resolver using the shared native tool runner.
    public init(toolRunner: NativeToolRunner = .shared) {
        self.toolRunner = toolRunner
    }

    // MARK: - Static helpers

    /// Walks up from `resultPath` to find the enclosing `.lungfish/` project root.
    ///
    /// If no `.lungfish/` marker is found in any ancestor directory, falls back
    /// to the result path's parent directory. This means callers always get
    /// back *some* writable directory — never `nil`.
    ///
    /// - Parameter resultPath: A file or directory URL inside a Lungfish project.
    /// - Returns: The `.lungfish/`-containing project root, or `resultPath`'s parent on fallback.
    public static func resolveProjectRoot(from resultPath: URL) -> URL {
        let fm = FileManager.default
        var isDirectory: ObjCBool = false
        let exists = fm.fileExists(atPath: resultPath.path, isDirectory: &isDirectory)

        // Start from the directory containing resultPath (unless resultPath is a directory).
        var current: URL
        if exists && isDirectory.boolValue {
            current = resultPath.standardizedFileURL
        } else {
            current = resultPath.deletingLastPathComponent().standardizedFileURL
        }

        let fallback = current

        // Walk up until we find .lungfish/ or hit the filesystem root.
        while current.path != "/" {
            let marker = current.appendingPathComponent(".lungfish")
            if fm.fileExists(atPath: marker.path) {
                return current
            }
            let parent = current.deletingLastPathComponent().standardizedFileURL
            if parent == current { break }  // can't go higher
            current = parent
        }

        return fallback
    }

    // MARK: - Public API (stubs — filled in later tasks)

    /// Runs an extraction and routes the result to the requested destination.
    ///
    /// Implemented in Task 2.3 and later. The stub throws so no caller can
    /// reach production code yet.
    public func resolveAndExtract(
        tool: ClassifierTool,
        resultPath: URL,
        selections: [ClassifierRowSelector],
        options: ExtractionOptions,
        destination: ExtractionDestination,
        progress: (@Sendable (Double, String) -> Void)? = nil
    ) async throws -> ExtractionOutcome {
        throw ClassifierExtractionError.notImplemented
    }

    /// Cheap pre-flight count. Implemented in Task 2.2.
    public func estimateReadCount(
        tool: ClassifierTool,
        resultPath: URL,
        selections: [ClassifierRowSelector],
        options: ExtractionOptions
    ) async throws -> Int {
        // Early return: no selections means nothing to count.
        let nonEmpty = selections.filter { !$0.isEmpty }
        guard !nonEmpty.isEmpty else { return 0 }

        if tool.usesBAMDispatch {
            return try await estimateBAMReadCount(
                tool: tool,
                resultPath: resultPath,
                selections: nonEmpty,
                options: options
            )
        } else {
            return try await estimateKraken2ReadCount(
                resultPath: resultPath,
                selections: nonEmpty
            )
        }
    }

    // MARK: - Private BAM dispatch

    /// Sums `samtools view -c -F <flags> <bam> <regions...>` across samples.
    private func estimateBAMReadCount(
        tool: ClassifierTool,
        resultPath: URL,
        selections: [ClassifierRowSelector],
        options: ExtractionOptions
    ) async throws -> Int {
        let groupedBySample = groupBySample(selections)
        var total = 0
        for (sampleId, group) in groupedBySample {
            let regions = group.flatMap { $0.accessions }
            guard !regions.isEmpty else { continue }

            let bamURL = try await resolveBAMURL(
                tool: tool,
                sampleId: sampleId,
                resultPath: resultPath
            )

            var args = ["view", "-c", "-F", String(options.samtoolsExcludeFlags), bamURL.path]
            args.append(contentsOf: regions)

            let result = try await toolRunner.run(.samtools, arguments: args, timeout: 600)
            guard result.isSuccess else {
                throw ClassifierExtractionError.samtoolsFailed(
                    sampleId: sampleId ?? "(single)",
                    stderr: result.stderr
                )
            }

            // samtools view -c writes a single integer to stdout.
            let trimmed = result.stdout.trimmingCharacters(in: .whitespacesAndNewlines)
            if let n = Int(trimmed) {
                total += n
            }
        }
        return total
    }

    /// Kraken2 estimate: sum of `readsClade` across selected taxa, pulled from
    /// the on-disk taxonomy tree rather than running samtools.
    private func estimateKraken2ReadCount(
        resultPath: URL,
        selections: [ClassifierRowSelector]
    ) async throws -> Int {
        // The resolver knows how to load a Kraken2 result from disk because
        // the ClassificationResult type exposes a .load(from:) initializer.
        // We defer the actual tree-walking until Task 2.6 where we also
        // implement the full Kraken2 extraction path; for now, just sum
        // `selections.taxIds.count * 0` and return zero — a correct-but-
        // conservative lower bound. Dialog live-update will show a real
        // number after Task 2.6 fills this in.
        //
        // TODO[phase2]: real Kraken2 estimate lands in Task 2.6.
        let _ = resultPath
        let _ = selections
        return 0
    }

    // MARK: - Private helpers

    /// Groups selectors by `sampleId`, treating `nil` as a single implicit sample.
    private func groupBySample(
        _ selections: [ClassifierRowSelector]
    ) -> [(String?, [ClassifierRowSelector])] {
        var bySample: [String?: [ClassifierRowSelector]] = [:]
        var order: [String?] = []
        for sel in selections {
            if bySample[sel.sampleId] == nil {
                order.append(sel.sampleId)
            }
            bySample[sel.sampleId, default: []].append(sel)
        }
        return order.map { ($0, bySample[$0] ?? []) }
    }

    /// Resolves the per-sample BAM URL for a classifier tool.
    ///
    /// Each tool stores its BAM differently; this function centralizes the
    /// knowledge. When `sampleId` is `nil` (single-sample result views) we
    /// look for a single BAM file using the tool's default naming convention.
    private func resolveBAMURL(
        tool: ClassifierTool,
        sampleId: String?,
        resultPath: URL
    ) async throws -> URL {
        let fm = FileManager.default
        let resultDir = resultPath.hasDirectoryPath
            ? resultPath
            : resultPath.deletingLastPathComponent()

        let sample = sampleId ?? "(single)"

        // Build the candidate URL list in the order we want to try them.
        let candidates: [URL]
        switch tool {
        case .esviritu:
            // EsViritu writes {sampleId}.sorted.bam next to the result DB.
            // Historical layouts may have it in a temp subdir; we try both.
            var urls: [URL] = []
            if let sampleId {
                urls.append(resultDir.appendingPathComponent("\(sampleId).sorted.bam"))
                urls.append(resultDir.appendingPathComponent("\(sampleId)_temp/\(sampleId).sorted.bam"))
            } else {
                // Single-sample: any *.sorted.bam in the result dir.
                if let enumerator = fm.enumerator(at: resultDir, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]),
                   let match = enumerator.compactMap({ $0 as? URL }).first(where: { $0.lastPathComponent.hasSuffix(".sorted.bam") }) {
                    urls.append(match)
                }
            }
            candidates = urls

        case .taxtriage:
            // TaxTriage nf-core layout: minimap2/{sampleId}.bam
            guard let sampleId else {
                candidates = []
                break
            }
            candidates = [resultDir.appendingPathComponent("minimap2/\(sampleId).bam")]

        case .naomgs:
            // NAO-MGS: bams/{sampleId}.sorted.bam (materialized from SQLite if missing).
            guard let sampleId else {
                candidates = []
                break
            }
            candidates = [resultDir.appendingPathComponent("bams/\(sampleId).sorted.bam")]

        case .nvd:
            // NVD: adjacent {sampleId}.bam or sorted.bam
            guard let sampleId else {
                candidates = []
                break
            }
            candidates = [
                resultDir.appendingPathComponent("\(sampleId).bam"),
                resultDir.appendingPathComponent("\(sampleId).sorted.bam"),
            ]

        case .kraken2:
            throw ClassifierExtractionError.notImplemented  // Kraken2 isn't BAM-backed.
        }

        for url in candidates {
            if fm.fileExists(atPath: url.path) {
                return url
            }
        }

        throw ClassifierExtractionError.bamNotFound(sampleId: sample)
    }

    // MARK: - Test hooks

    #if DEBUG
    /// Test-only wrapper exposing `resolveBAMURL` for unit testing.
    public func testingResolveBAMURL(
        tool: ClassifierTool,
        sampleId: String?,
        resultPath: URL
    ) async throws -> URL {
        try await resolveBAMURL(tool: tool, sampleId: sampleId, resultPath: resultPath)
    }
    #endif
}

// MARK: - ClassifierExtractionError

/// Errors produced by `ClassifierReadResolver`.
///
/// Distinct from the lower-level `ExtractionError` so callers can differentiate
/// resolver-scoped failures (BAM-not-found-for-sample, missing Kraken2 output,
/// etc.) from primitive samtools/seqkit failures.
public enum ClassifierExtractionError: Error, LocalizedError, Sendable {

    /// The resolver method is not yet implemented (build-time stub).
    case notImplemented

    /// No BAM file could be found for the given sample ID.
    case bamNotFound(sampleId: String)

    /// The Kraken2 per-read classified output file was missing or unreadable.
    case kraken2OutputMissing(URL)

    /// The Kraken2 taxonomy tree could not be loaded from disk.
    case kraken2TreeMissing(URL)

    /// The Kraken2 source FASTQ could not be located on disk.
    case kraken2SourceMissing

    /// A per-sample samtools invocation failed.
    case samtoolsFailed(sampleId: String, stderr: String)

    /// An extracted clipboard payload exceeded the requested cap.
    case clipboardCapExceeded(requested: Int, cap: Int)

    /// Destination directory not writable.
    case destinationNotWritable(URL)

    /// FASTQ → FASTA conversion failed while reading an input record.
    case fastaConversionFailed(String)

    /// Zero reads were extracted despite a non-empty pre-flight estimate.
    case zeroReadsExtracted

    /// The underlying extraction was cancelled.
    case cancelled

    // MARK: - LocalizedError

    public var errorDescription: String? {
        switch self {
        case .notImplemented:
            return "ClassifierReadResolver path is not yet implemented"
        case .bamNotFound(let sampleId):
            return "No BAM file found for sample '\(sampleId)'. The classifier result may be corrupted or imported without the underlying alignment data."
        case .kraken2OutputMissing(let url):
            return "Kraken2 per-read classification output not found: \(url.lastPathComponent)"
        case .kraken2TreeMissing(let url):
            return "Kraken2 taxonomy tree not found: \(url.lastPathComponent)"
        case .kraken2SourceMissing:
            return "Kraken2 source FASTQ could not be located. The source file may have been moved or deleted."
        case .samtoolsFailed(let sampleId, let stderr):
            return "samtools view failed for sample '\(sampleId)': \(stderr)"
        case .clipboardCapExceeded(let requested, let cap):
            return "Selection contains \(requested) reads, which exceeds the clipboard cap of \(cap). Choose Save to File, Save as Bundle, or Share instead."
        case .destinationNotWritable(let url):
            return "Destination is not writable: \(url.path)"
        case .fastaConversionFailed(let reason):
            return "FASTQ → FASTA conversion failed: \(reason)"
        case .zeroReadsExtracted:
            return "The selection produced zero reads. Try adjusting the flag filter or selecting different rows."
        case .cancelled:
            return "Extraction was cancelled"
        }
    }
}
