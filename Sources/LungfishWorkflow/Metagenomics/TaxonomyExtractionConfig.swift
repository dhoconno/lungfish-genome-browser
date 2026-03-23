// TaxonomyExtractionConfig.swift - Configuration for extracting reads by taxonomic classification
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation

// MARK: - TaxonomyExtractionConfig

/// Configuration for extracting reads classified to specific taxa from a FASTQ file.
///
/// An extraction selects reads from a classified FASTQ based on their Kraken2
/// per-read taxonomy assignments. When ``includeChildren`` is `true`, all
/// descendant tax IDs from the target nodes are included in the filter.
///
/// ## Usage
///
/// ```swift
/// let config = TaxonomyExtractionConfig(
///     taxIds: [562],
///     includeChildren: true,
///     sourceFile: inputFASTQ,
///     outputFile: outputFASTQ,
///     classificationOutput: krakenOutputURL
/// )
/// ```
///
/// ## Thread Safety
///
/// `TaxonomyExtractionConfig` is a value type conforming to `Sendable`, safe
/// to pass across isolation boundaries.
public struct TaxonomyExtractionConfig: Sendable, Equatable {

    /// The set of NCBI taxonomy IDs to extract reads for.
    ///
    /// These are the directly selected taxa. If ``includeChildren`` is `true`,
    /// the extraction pipeline will also collect all descendant tax IDs from
    /// the taxonomy tree before filtering.
    public let taxIds: Set<Int>

    /// Whether to include reads classified to descendant taxa.
    ///
    /// When `true`, the pipeline traverses the taxonomy tree to collect all
    /// child tax IDs for each entry in ``taxIds``, creating a comprehensive
    /// clade-level extraction.
    public let includeChildren: Bool

    /// The input FASTQ file from which reads are extracted.
    ///
    /// May be gzip-compressed (`.fastq.gz`).
    public let sourceFile: URL

    /// The output FASTQ file for matching reads.
    ///
    /// The pipeline writes matching reads here in the same format as the source.
    public let outputFile: URL

    /// The Kraken2 per-read classification output file.
    ///
    /// This is the 5-column TSV produced by `kraken2 --output`, not the kreport.
    /// Each line maps a read ID to its assigned taxonomy ID, which is used to
    /// determine which reads to extract.
    public let classificationOutput: URL

    /// Creates a taxonomy extraction configuration.
    ///
    /// - Parameters:
    ///   - taxIds: Tax IDs to extract.
    ///   - includeChildren: Whether to include descendant taxa.
    ///   - sourceFile: Input FASTQ file.
    ///   - outputFile: Output FASTQ file.
    ///   - classificationOutput: Kraken2 per-read output file.
    public init(
        taxIds: Set<Int>,
        includeChildren: Bool,
        sourceFile: URL,
        outputFile: URL,
        classificationOutput: URL
    ) {
        self.taxIds = taxIds
        self.includeChildren = includeChildren
        self.sourceFile = sourceFile
        self.outputFile = outputFile
        self.classificationOutput = classificationOutput
    }

    /// A human-readable description of this extraction for logging.
    public var summary: String {
        let taxStr = taxIds.count == 1
            ? "taxId \(taxIds.first!)"
            : "\(taxIds.count) taxa"
        let childStr = includeChildren ? " (with children)" : ""
        return "Extract \(taxStr)\(childStr) from \(sourceFile.lastPathComponent)"
    }
}

// MARK: - TaxonomyExtractionError

/// Errors produced during taxonomy-based read extraction.
public enum TaxonomyExtractionError: Error, LocalizedError, Sendable {

    /// The classification output file could not be read.
    case classificationOutputNotFound(URL)

    /// The source FASTQ file could not be read.
    case sourceFileNotFound(URL)

    /// No read IDs matched the specified taxonomy filter.
    case noMatchingReads

    /// The output file could not be written.
    case outputWriteFailed(URL, String)

    /// The extraction was cancelled.
    case cancelled

    public var errorDescription: String? {
        switch self {
        case .classificationOutputNotFound(let url):
            return "Classification output not found: \(url.lastPathComponent)"
        case .sourceFileNotFound(let url):
            return "Source FASTQ not found: \(url.lastPathComponent)"
        case .noMatchingReads:
            return "No reads matched the specified taxa"
        case .outputWriteFailed(let url, let reason):
            return "Cannot write output to \(url.lastPathComponent): \(reason)"
        case .cancelled:
            return "Extraction was cancelled"
        }
    }
}
