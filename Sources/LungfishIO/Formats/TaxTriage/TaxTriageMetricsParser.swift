// TaxTriageMetricsParser.swift - Parser for TaxTriage TASS confidence metrics
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation

// MARK: - TaxTriageMetricsParser

/// Parses TaxTriage TASS (Taxonomic Assignment Scoring System) confidence metrics.
///
/// TaxTriage outputs tab-separated value (TSV) files containing detailed per-taxon
/// confidence metrics. These metrics include the TASS score, read counts,
/// coverage breadth, and other QC indicators used for confidence assessment.
///
/// ## TSV Format
///
/// The first row is a header. Subsequent rows contain one record per taxon:
///
/// ```tsv
/// sample\ttaxid\torganism\trank\treads\tabundance\tcoverage_breadth\tcoverage_depth\ttass_score\tconfidence
/// MySample\t562\tEscherichia coli\tS\t12345\t0.45\t85.3\t12.7\t0.95\thigh
/// ```
///
/// ## Example
///
/// ```swift
/// let metrics = try TaxTriageMetricsParser.parse(url: metricsURL)
/// for metric in metrics {
///     print("\(metric.organism): TASS=\(metric.tassScore), reads=\(metric.reads)")
/// }
/// ```
public enum TaxTriageMetricsParser {

    // MARK: - Known Column Names

    /// Standard column names recognized by the parser (case-insensitive).
    private enum Column: String, CaseIterable {
        case sample
        case taxid
        case organism
        case rank
        case reads
        case abundance
        case coverageBreadth = "coverage_breadth"
        case coverageDepth = "coverage_depth"
        case tassScore = "tass_score"
        case confidence
    }

    // MARK: - Parsing

    /// Parses a TASS metrics TSV file.
    ///
    /// - Parameter url: The metrics TSV file URL.
    /// - Returns: An array of parsed metric records.
    /// - Throws: If the file cannot be read or the header is invalid.
    public static func parse(url: URL) throws -> [TaxTriageMetric] {
        let content = try String(contentsOf: url, encoding: .utf8)
        return try parse(tsv: content)
    }

    /// Parses TASS metrics from TSV content.
    ///
    /// The parser is column-order-independent: it reads the header row to determine
    /// column positions, then extracts fields by name. Unrecognized columns are
    /// stored in the ``TaxTriageMetric/additionalFields`` dictionary.
    ///
    /// - Parameter tsv: The TSV content string.
    /// - Returns: An array of parsed metric records.
    /// - Throws: ``TaxTriageMetricsParserError`` if the format is invalid.
    public static func parse(tsv: String) throws -> [TaxTriageMetric] {
        let lines = tsv.components(separatedBy: .newlines)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }

        guard let headerLine = lines.first else {
            throw TaxTriageMetricsParserError.emptyFile
        }

        // Build column index mapping
        let columns = headerLine.components(separatedBy: "\t")
            .map { $0.trimmingCharacters(in: .whitespaces).lowercased() }

        guard !columns.isEmpty else {
            throw TaxTriageMetricsParserError.emptyHeader
        }

        var columnMap: [String: Int] = [:]
        for (index, name) in columns.enumerated() {
            columnMap[name] = index
        }

        // Parse data rows
        var metrics: [TaxTriageMetric] = []

        for (lineIndex, line) in lines.dropFirst().enumerated() {
            let fields = line.components(separatedBy: "\t")
                .map { $0.trimmingCharacters(in: .whitespaces) }

            let metric = TaxTriageMetric(
                sample: fieldValue(fields, columnMap, "sample"),
                taxId: fieldInt(fields, columnMap, "taxid"),
                organism: fieldValue(fields, columnMap, "organism") ?? "unknown",
                rank: fieldValue(fields, columnMap, "rank"),
                reads: fieldInt(fields, columnMap, "reads") ?? 0,
                abundance: fieldDouble(fields, columnMap, "abundance"),
                coverageBreadth: fieldDouble(fields, columnMap, "coverage_breadth"),
                coverageDepth: fieldDouble(fields, columnMap, "coverage_depth"),
                tassScore: fieldDouble(fields, columnMap, "tass_score") ?? 0.0,
                confidence: fieldValue(fields, columnMap, "confidence"),
                additionalFields: collectAdditionalFields(
                    fields: fields,
                    columns: columns,
                    knownColumns: Set(Column.allCases.map(\.rawValue))
                ),
                sourceLineNumber: lineIndex + 2
            )

            metrics.append(metric)
        }

        return metrics
    }

    // MARK: - Field Extraction

    /// Extracts a string field by column name.
    private static func fieldValue(
        _ fields: [String],
        _ columnMap: [String: Int],
        _ name: String
    ) -> String? {
        guard let index = columnMap[name], index < fields.count else { return nil }
        let value = fields[index]
        return value.isEmpty ? nil : value
    }

    /// Extracts an integer field by column name.
    private static func fieldInt(
        _ fields: [String],
        _ columnMap: [String: Int],
        _ name: String
    ) -> Int? {
        guard let str = fieldValue(fields, columnMap, name) else { return nil }
        return Int(str)
    }

    /// Extracts a double field by column name.
    private static func fieldDouble(
        _ fields: [String],
        _ columnMap: [String: Int],
        _ name: String
    ) -> Double? {
        guard let str = fieldValue(fields, columnMap, name) else { return nil }
        return Double(str)
    }

    /// Collects fields not in the known column set.
    private static func collectAdditionalFields(
        fields: [String],
        columns: [String],
        knownColumns: Set<String>
    ) -> [String: String] {
        var additional: [String: String] = [:]
        for (index, column) in columns.enumerated() where !knownColumns.contains(column) {
            if index < fields.count && !fields[index].isEmpty {
                additional[column] = fields[index]
            }
        }
        return additional
    }
}

// MARK: - TaxTriageMetric

/// A single TASS confidence metric record for one taxon in one sample.
///
/// Contains the organism identification along with confidence scoring metrics
/// produced by TaxTriage's taxonomic assignment confidence system.
public struct TaxTriageMetric: Sendable, Codable, Equatable {

    /// Sample identifier (nil if single-sample file).
    public let sample: String?

    /// NCBI taxonomy ID.
    public let taxId: Int?

    /// Scientific name of the organism.
    public let organism: String

    /// Taxonomic rank code (e.g., "S" for species, "G" for genus).
    public let rank: String?

    /// Number of reads assigned to this taxon.
    public let reads: Int

    /// Relative abundance within the sample (0.0 to 1.0).
    public let abundance: Double?

    /// Genome coverage breadth percentage (0.0 to 100.0).
    ///
    /// Fraction of the reference genome covered by at least one read.
    public let coverageBreadth: Double?

    /// Mean coverage depth.
    ///
    /// Average number of reads covering each base of the reference.
    public let coverageDepth: Double?

    /// TASS (Taxonomic Assignment Scoring System) confidence score (0.0 to 1.0).
    ///
    /// A composite score incorporating read count, coverage breadth, coverage
    /// depth, and other factors. Higher scores indicate more reliable identifications.
    public let tassScore: Double

    /// Qualitative confidence label (e.g., "high", "medium", "low").
    public let confidence: String?

    /// Additional columns not in the standard schema.
    public let additionalFields: [String: String]

    /// The line number in the source file (for diagnostics).
    public let sourceLineNumber: Int?

    /// Creates a new TASS metric record.
    ///
    /// - Parameters:
    ///   - sample: Sample identifier.
    ///   - taxId: NCBI taxonomy ID.
    ///   - organism: Scientific name.
    ///   - rank: Taxonomic rank code.
    ///   - reads: Read count.
    ///   - abundance: Relative abundance.
    ///   - coverageBreadth: Genome coverage breadth percentage.
    ///   - coverageDepth: Mean coverage depth.
    ///   - tassScore: TASS confidence score.
    ///   - confidence: Qualitative confidence label.
    ///   - additionalFields: Extra columns.
    ///   - sourceLineNumber: Source file line number.
    public init(
        sample: String? = nil,
        taxId: Int? = nil,
        organism: String,
        rank: String? = nil,
        reads: Int = 0,
        abundance: Double? = nil,
        coverageBreadth: Double? = nil,
        coverageDepth: Double? = nil,
        tassScore: Double = 0.0,
        confidence: String? = nil,
        additionalFields: [String: String] = [:],
        sourceLineNumber: Int? = nil
    ) {
        self.sample = sample
        self.taxId = taxId
        self.organism = organism
        self.rank = rank
        self.reads = reads
        self.abundance = abundance
        self.coverageBreadth = coverageBreadth
        self.coverageDepth = coverageDepth
        self.tassScore = tassScore
        self.confidence = confidence
        self.additionalFields = additionalFields
        self.sourceLineNumber = sourceLineNumber
    }
}

// MARK: - TaxTriageMetricsParserError

/// Errors produced when parsing TASS metrics files.
public enum TaxTriageMetricsParserError: Error, LocalizedError, Sendable {

    /// The metrics file is empty.
    case emptyFile

    /// The header row is empty or missing.
    case emptyHeader

    public var errorDescription: String? {
        switch self {
        case .emptyFile:
            return "TASS metrics file is empty"
        case .emptyHeader:
            return "TASS metrics file has an empty header row"
        }
    }
}
