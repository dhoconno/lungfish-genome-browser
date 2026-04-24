// BAMPrimerTrimPipeline.swift - Run ivar trim + samtools sort/index with provenance
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import LungfishIO

/// Runs the primer-trim workflow against a BAM file.
///
/// Resolves the primer scheme's BED to the BAM's reference name, runs `ivar trim`,
/// sorts and indexes the output, and writes a provenance sidecar JSON documenting
/// the primer scheme and iVar arguments used.
public struct BAMPrimerTrimPipeline {
    /// Builds the argument list passed to `ivar trim`.
    ///
    /// This pure, synchronous helper exists so callers (and tests) can reason
    /// about the exact iVar invocation without running a process. The returned
    /// array begins with `"trim"` (iVar's subcommand) and ends with `"-e"` so
    /// reads without a matching primer are kept rather than discarded.
    /// - Parameters:
    ///   - bedPath: Path to the primer BED (already resolved to the BAM's reference name).
    ///   - inputBAMPath: Path to the source BAM.
    ///   - outputPrefix: Prefix for iVar's output; `.bam` is appended by iVar.
    ///   - minReadLength: Minimum read length (bp) to retain; passed via `-m`.
    ///   - minQuality: Minimum Phred quality for the sliding-window trim; passed via `-q`.
    ///   - slidingWindow: Sliding-window width (bp); passed via `-s`.
    ///   - primerOffset: Primer coordinate offset (bp); passed via `-x`.
    /// - Returns: The argv (without the program name) suitable for `NativeToolRunner.run(.ivar, arguments:)`.
    public static func buildIvarTrimArgv(
        bedPath: String,
        inputBAMPath: String,
        outputPrefix: String,
        minReadLength: Int,
        minQuality: Int,
        slidingWindow: Int,
        primerOffset: Int
    ) -> [String] {
        [
            "trim",
            "-b", bedPath,
            "-i", inputBAMPath,
            "-p", outputPrefix,
            "-q", "\(minQuality)",
            "-m", "\(minReadLength)",
            "-s", "\(slidingWindow)",
            "-x", "\(primerOffset)",
            "-e"
        ]
    }
}

extension BAMPrimerTrimPipeline {
    /// Errors reported by the primer-trim pipeline when an external stage fails.
    ///
    /// Each case carries the captured stderr from the corresponding tool, which
    /// is surfaced verbatim in the user-facing error description (or
    /// `"no stderr"` when the tool produced none).
    public enum PipelineError: Error, LocalizedError, Sendable {
        /// `ivar trim` exited non-zero.
        case ivarTrimFailed(stderr: String)

        /// `samtools sort` exited non-zero.
        case samtoolsSortFailed(stderr: String)

        /// `samtools index` exited non-zero.
        case samtoolsIndexFailed(stderr: String)

        public var errorDescription: String? {
            switch self {
            case .ivarTrimFailed(let s):
                return "ivar trim failed: \(s.isEmpty ? "no stderr" : s)"
            case .samtoolsSortFailed(let s):
                return "samtools sort failed: \(s.isEmpty ? "no stderr" : s)"
            case .samtoolsIndexFailed(let s):
                return "samtools index failed: \(s.isEmpty ? "no stderr" : s)"
            }
        }
    }

    /// Runs the full primer-trim pipeline: `ivar trim` → `samtools sort` → `samtools index`,
    /// then writes a JSON provenance sidecar next to the output BAM.
    ///
    /// The primer bundle's BED is resolved against `targetReferenceName` before
    /// iVar is invoked; if the match is on an equivalent (rather than canonical)
    /// accession, a rewritten BED is produced in the system temp directory and
    /// cleaned up after the run. Intermediate unsorted BAMs are also removed.
    /// Progress is reported through `progress(fraction, description)` at five
    /// coarse checkpoints.
    ///
    /// - Parameters:
    ///   - request: Inputs (source BAM, primer bundle, output BAM URL, iVar parameters).
    ///   - targetReferenceName: The `@SQ` `SN` name of the source BAM; used to resolve the primer BED.
    ///   - runner: The `NativeToolRunner` that locates `ivar` and `samtools`.
    ///   - progress: Optional progress callback receiving `(fraction, description)`.
    /// - Returns: A `BAMPrimerTrimResult` describing the sorted BAM, its BAI,
    ///   the provenance sidecar URL, and the provenance struct written to it.
    /// - Throws: `PrimerSchemeResolver.ResolveError` if the primer scheme does
    ///   not cover `targetReferenceName`, or `PipelineError.*` when a tool fails.
    public static func run(
        _ request: BAMPrimerTrimRequest,
        targetReferenceName: String,
        runner: NativeToolRunner,
        progress: @Sendable @escaping (Double, String) -> Void = { _, _ in }
    ) async throws -> BAMPrimerTrimResult {
        progress(0.0, "Resolving primer scheme")
        let resolved = try PrimerSchemeResolver.resolve(
            bundle: request.primerSchemeBundle,
            targetReferenceName: targetReferenceName
        )

        let workDir = request.outputBAMURL.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: workDir, withIntermediateDirectories: true)

        let trimmedPrefix = workDir.appendingPathComponent("trimmed.unsorted")
        let trimmedUnsortedBAM = trimmedPrefix.appendingPathExtension("bam")

        progress(0.1, "Running ivar trim")
        let ivarArgs = buildIvarTrimArgv(
            bedPath: resolved.bedURL.path,
            inputBAMPath: request.sourceBAMURL.path,
            outputPrefix: trimmedPrefix.path,
            minReadLength: request.minReadLength,
            minQuality: request.minQuality,
            slidingWindow: request.slidingWindow,
            primerOffset: request.primerOffset
        )

        let ivarResult = try await runner.run(
            .ivar,
            arguments: ivarArgs,
            workingDirectory: workDir,
            timeout: 3_600
        )
        guard ivarResult.isSuccess else {
            if resolved.isRewritten { try? FileManager.default.removeItem(at: resolved.bedURL) }
            throw PipelineError.ivarTrimFailed(stderr: ivarResult.stderr)
        }

        progress(0.55, "Sorting BAM")
        let sortResult = try await runner.run(
            .samtools,
            arguments: ["sort", "-o", request.outputBAMURL.path, trimmedUnsortedBAM.path],
            workingDirectory: workDir,
            timeout: 3_600
        )
        guard sortResult.isSuccess else {
            try? FileManager.default.removeItem(at: trimmedUnsortedBAM)
            if resolved.isRewritten { try? FileManager.default.removeItem(at: resolved.bedURL) }
            throw PipelineError.samtoolsSortFailed(stderr: sortResult.stderr)
        }

        progress(0.85, "Indexing BAM")
        let indexResult = try await runner.run(
            .samtools,
            arguments: ["index", request.outputBAMURL.path],
            workingDirectory: workDir,
            timeout: 600
        )
        guard indexResult.isSuccess else {
            try? FileManager.default.removeItem(at: trimmedUnsortedBAM)
            if resolved.isRewritten { try? FileManager.default.removeItem(at: resolved.bedURL) }
            throw PipelineError.samtoolsIndexFailed(stderr: indexResult.stderr)
        }

        // Cleanup intermediates (best-effort; non-fatal if cleanup fails).
        try? FileManager.default.removeItem(at: trimmedUnsortedBAM)
        if resolved.isRewritten {
            try? FileManager.default.removeItem(at: resolved.bedURL)
        }

        let bamIndexURL = URL(fileURLWithPath: request.outputBAMURL.path + ".bai")
        let provenance = BAMPrimerTrimProvenance(
            operation: "primer-trim",
            primerScheme: .init(
                bundleName: request.primerSchemeBundle.manifest.name,
                bundleSource: request.primerSchemeBundle.manifest.source ?? "project-local",
                bundleVersion: request.primerSchemeBundle.manifest.version,
                canonicalAccession: request.primerSchemeBundle.manifest.canonicalAccession
            ),
            sourceBAMRelativePath: request.sourceBAMURL.lastPathComponent,
            ivarVersion: "unknown",
            ivarTrimArgs: ivarArgs,
            timestamp: Date()
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let provenanceData = try encoder.encode(provenance)
        let provenanceURL = request.outputBAMURL
            .deletingPathExtension()
            .appendingPathExtension("primer-trim-provenance.json")
        try provenanceData.write(to: provenanceURL)

        progress(1.0, "Primer trim complete")

        return BAMPrimerTrimResult(
            outputBAMURL: request.outputBAMURL,
            outputBAMIndexURL: bamIndexURL,
            provenanceURL: provenanceURL,
            provenance: provenance
        )
    }
}
