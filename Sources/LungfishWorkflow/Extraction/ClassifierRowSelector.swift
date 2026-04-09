// ClassifierRowSelector.swift — Tool identifier + minimal row-selection value type
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation

// MARK: - ClassifierTool

/// Identifier for the five classifier tools supported by the unified extraction pipeline.
///
/// The raw values match the CLI `--tool` argument spelling, the GUI context-menu
/// suffixes, and the Tests/Fixtures/classifier-results/ subdirectory names.
///
/// ## Dispatch semantics
///
/// Four of the five tools (EsViritu, TaxTriage, NAO-MGS, NVD) are *BAM-backed*:
/// they store per-sample BAM files that can be queried with `samtools view`.
/// Kraken2 alone stores per-read classifications in a flat TSV + source FASTQ,
/// so it uses the existing `TaxonomyExtractionPipeline` as its backend. The
/// `usesBAMDispatch` property lets the resolver make this binary decision with
/// no per-tool switch on the GUI side.
public enum ClassifierTool: String, Sendable, CaseIterable, Hashable, Codable {
    case esviritu
    case taxtriage
    case kraken2
    case naomgs
    case nvd

    /// Whether this tool is extracted via `samtools view` on a per-sample BAM.
    ///
    /// - Returns: `true` for EsViritu, TaxTriage, NAO-MGS, and NVD.
    /// - Returns: `false` for Kraken2 (uses `TaxonomyExtractionPipeline`).
    public var usesBAMDispatch: Bool {
        switch self {
        case .esviritu, .taxtriage, .naomgs, .nvd:
            return true
        case .kraken2:
            return false
        }
    }

    /// Human-readable display name for progress / log / error messages.
    public var displayName: String {
        switch self {
        case .esviritu:  return "EsViritu"
        case .taxtriage: return "TaxTriage"
        case .kraken2:   return "Kraken2"
        case .naomgs:    return "NAO-MGS"
        case .nvd:       return "NVD"
        }
    }
}

// MARK: - ClassifierRowSelector

/// The minimal description of a classifier-view row selection — tool-agnostic.
///
/// Each row (or group of rows) the user selects in a classifier table maps to
/// exactly one `ClassifierRowSelector`. Multiple selectors can be passed to the
/// resolver; the resolver groups them by `sampleId` before running
/// `samtools view`.
///
/// ## Field semantics
///
/// - ``sampleId`` — Non-nil for multi-sample batch tables. Each distinct
///   `sampleId` becomes one `samtools view` invocation against that sample's
///   BAM. Nil means "there is only one sample; use the result path directly."
/// - ``accessions`` — Region names passed to `samtools view` for BAM-backed
///   tools. For EsViritu/TaxTriage these are reference accession identifiers
///   (e.g. `NC_001803.1`). For NVD these are contig names.
/// - ``taxIds`` — NCBI taxonomy IDs. Only used for Kraken2; the resolver wraps
///   these into a `TaxonomyExtractionConfig` and delegates to
///   `TaxonomyExtractionPipeline`. Ignored for BAM-backed tools.
///
/// ## Thread safety
///
/// `ClassifierRowSelector` is a value type conforming to `Sendable`, safe to
/// pass across isolation boundaries.
public struct ClassifierRowSelector: Sendable, Hashable {

    /// Sample identifier for multi-sample batch tables. Nil for single-sample result views.
    public var sampleId: String?

    /// Reference sequence names passed to `samtools view` (BAM-backed tools).
    public var accessions: [String]

    /// NCBI taxonomy IDs (Kraken2 only).
    public var taxIds: [Int]

    /// Creates a row selector.
    ///
    /// - Parameters:
    ///   - sampleId: Sample identifier (nil for single-sample).
    ///   - accessions: Region names for BAM-backed tools.
    ///   - taxIds: Tax IDs for Kraken2.
    public init(
        sampleId: String? = nil,
        accessions: [String] = [],
        taxIds: [Int] = []
    ) {
        self.sampleId = sampleId
        self.accessions = accessions
        self.taxIds = taxIds
    }

    /// Whether this selector carries any extraction targets at all.
    public var isEmpty: Bool {
        accessions.isEmpty && taxIds.isEmpty
    }
}
