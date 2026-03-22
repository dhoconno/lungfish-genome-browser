// ClassificationResult.swift - Result of a Kraken2 classification pipeline run
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import LungfishIO

// MARK: - ClassificationResult

/// The result of a completed classification pipeline run.
///
/// Contains the parsed taxonomy tree, paths to all output files, runtime
/// metadata, and the provenance record ID for traceability.
///
/// ## Output Files
///
/// Every run produces at least two files:
/// - ``reportURL``: The Kraken2 kreport (6-column TSV with clade counts)
/// - ``outputURL``: The per-read classification output
///
/// If Bracken profiling was requested, ``brackenURL`` will be non-nil.
///
/// ## Thread Safety
///
/// `ClassificationResult` is `Sendable` because ``tree`` contains only
/// `@unchecked Sendable` nodes that are immutable after construction.
public struct ClassificationResult: Sendable {

    /// The configuration that produced this result.
    public let config: ClassificationConfig

    /// The parsed taxonomy tree from the Kraken2 report.
    public let tree: TaxonTree

    /// Path to the Kraken2 report file (.kreport).
    public let reportURL: URL

    /// Path to the per-read Kraken2 output file (.kraken).
    public let outputURL: URL

    /// Path to the Bracken output file, if profiling was performed.
    public let brackenURL: URL?

    /// Total wall-clock time for the pipeline run, in seconds.
    public let runtime: TimeInterval

    /// Version string of the kraken2 tool that was executed.
    public let toolVersion: String

    /// The provenance run ID, if provenance recording was enabled.
    public let provenanceId: UUID?

    /// Creates a classification result.
    ///
    /// - Parameters:
    ///   - config: The configuration used for this run.
    ///   - tree: The parsed taxonomy tree.
    ///   - reportURL: Path to the kreport file.
    ///   - outputURL: Path to the per-read output.
    ///   - brackenURL: Path to the Bracken output, or `nil`.
    ///   - runtime: Wall-clock time in seconds.
    ///   - toolVersion: Kraken2 version string.
    ///   - provenanceId: Provenance run ID, or `nil`.
    public init(
        config: ClassificationConfig,
        tree: TaxonTree,
        reportURL: URL,
        outputURL: URL,
        brackenURL: URL?,
        runtime: TimeInterval,
        toolVersion: String,
        provenanceId: UUID?
    ) {
        self.config = config
        self.tree = tree
        self.reportURL = reportURL
        self.outputURL = outputURL
        self.brackenURL = brackenURL
        self.runtime = runtime
        self.toolVersion = toolVersion
        self.provenanceId = provenanceId
    }

    // MARK: - Convenience

    /// A human-readable summary of the classification result.
    public var summary: String {
        var lines: [String] = []
        lines.append("Classification Summary")
        lines.append("  Database: \(config.databaseName)")
        lines.append("  Total reads: \(tree.totalReads)")
        lines.append("  Classified: \(tree.classifiedReads) (\(String(format: "%.1f", tree.classifiedFraction * 100))%)")
        lines.append("  Unclassified: \(tree.unclassifiedReads) (\(String(format: "%.1f", tree.unclassifiedFraction * 100))%)")
        lines.append("  Species: \(tree.speciesCount)")
        lines.append("  Genera: \(tree.generaCount)")

        if let dominant = tree.dominantSpecies {
            let pct = String(format: "%.1f", dominant.fractionClade * 100)
            lines.append("  Dominant species: \(dominant.name) (\(pct)%)")
        }

        let shannonStr = String(format: "%.3f", tree.shannonDiversity)
        lines.append("  Shannon diversity (H'): \(shannonStr)")

        let runtimeStr = String(format: "%.1f", runtime)
        lines.append("  Runtime: \(runtimeStr)s")
        lines.append("  Tool: kraken2 \(toolVersion)")

        if brackenURL != nil {
            lines.append("  Bracken profiling: yes")
        }

        return lines.joined(separator: "\n")
    }
}
