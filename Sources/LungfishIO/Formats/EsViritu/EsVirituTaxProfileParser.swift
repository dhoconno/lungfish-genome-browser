// EsVirituTaxProfileParser.swift - Parser for EsViritu tax_profile.tsv
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Reference: https://github.com/hurwitzlab/EsViritu

import Foundation
import os.log

/// Logger for EsViritu tax profile parsing operations.
private let logger = Logger(subsystem: "com.lungfish.io", category: "EsVirituTaxProfileParser")

/// Errors that can occur during EsViritu tax profile file parsing.
public enum EsVirituTaxProfileParserError: Error, LocalizedError, Sendable {

    /// The tax profile file is empty or contains no parseable data lines.
    case emptyFile

    /// The tax profile file could not be read from disk.
    case fileReadError(URL, String)

    /// A required column value could not be parsed on a specific line.
    case invalidColumnValue(line: Int, column: String, value: String)

    public var errorDescription: String? {
        switch self {
        case .emptyFile:
            return "Empty EsViritu tax profile file"
        case .fileReadError(let url, let detail):
            return "Cannot read EsViritu tax profile at \(url.lastPathComponent): \(detail)"
        case .invalidColumnValue(let line, let column, let value):
            return "Invalid \(column) value '\(value)' on line \(line)"
        }
    }
}

/// A pure-function parser for EsViritu `tax_profile.tsv` files.
///
/// The `tax_profile.tsv` file is a 14-column tab-separated file that aggregates
/// detection results at each taxonomic level. Each row provides read counts,
/// RPKMF, average identity, and the list of assemblies contributing to a taxon.
///
/// **Columns:**
///
/// | Index | Header | Description |
/// |-------|--------|-------------|
/// | 0 | sample_ID | Sample identifier |
/// | 1 | filtered_reads_in_sample | Total filtered reads |
/// | 2 | kingdom | Taxonomic kingdom |
/// | 3 | phylum | Taxonomic phylum |
/// | 4 | tclass | Taxonomic class |
/// | 5 | order | Taxonomic order |
/// | 6 | family | Taxonomic family |
/// | 7 | genus | Taxonomic genus |
/// | 8 | species | Taxonomic species |
/// | 9 | subspecies | Taxonomic subspecies |
/// | 10 | read_count | Reads at this taxon |
/// | 11 | RPKMF | Reads per kilobase per million filtered |
/// | 12 | avg_read_identity | Average read identity % |
/// | 13 | assembly_list | Comma-separated assembly accessions |
///
/// ## Usage
///
/// ```swift
/// let profiles = try EsVirituTaxProfileParser.parse(url: taxProfileURL)
/// for profile in profiles {
///     print("\(profile.family ?? "Unknown"): \(profile.readCount) reads")
/// }
/// ```
///
/// ## Thread Safety
///
/// All methods are static and pure -- they take input and return output without
/// side effects. They are safe to call from any isolation domain.
public enum EsVirituTaxProfileParser {

    /// Expected minimum number of columns in each data row.
    private static let expectedColumnCount = 14

    // MARK: - Public API

    /// Parses an EsViritu tax profile file from a URL.
    ///
    /// - Parameter url: The file URL to the `tax_profile.tsv` file.
    /// - Returns: An array of ``ViralTaxProfile`` values.
    /// - Throws: ``EsVirituTaxProfileParserError`` if the file cannot be read or parsed.
    public static func parse(url: URL) throws -> [ViralTaxProfile] {
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw EsVirituTaxProfileParserError.fileReadError(url, error.localizedDescription)
        }
        return try parse(data: data)
    }

    /// Parses EsViritu tax profile data from in-memory bytes.
    ///
    /// - Parameter data: The raw bytes of the tax profile file.
    /// - Returns: An array of ``ViralTaxProfile`` values.
    /// - Throws: ``EsVirituTaxProfileParserError`` if the data cannot be parsed.
    public static func parse(data: Data) throws -> [ViralTaxProfile] {
        guard let text = String(data: data, encoding: .utf8) else {
            throw EsVirituTaxProfileParserError.emptyFile
        }
        return try parse(text: text)
    }

    /// Parses EsViritu tax profile data from a string.
    ///
    /// - Parameter text: The tax profile file content as a string.
    /// - Returns: An array of ``ViralTaxProfile`` values.
    /// - Throws: ``EsVirituTaxProfileParserError`` if the text cannot be parsed.
    public static func parse(text: String) throws -> [ViralTaxProfile] {
        let lines = text.components(separatedBy: .newlines)
        var profiles: [ViralTaxProfile] = []
        var lineNumber = 0

        for line in lines {
            lineNumber += 1

            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.isEmpty { continue }

            // Skip header line
            if trimmed.hasPrefix("sample_ID") || trimmed.hasPrefix("sample_id") {
                continue
            }

            // Skip comment lines
            if trimmed.hasPrefix("#") { continue }

            guard let profile = parseLine(line, lineNumber: lineNumber) else {
                continue
            }

            profiles.append(profile)
        }

        if profiles.isEmpty {
            throw EsVirituTaxProfileParserError.emptyFile
        }

        logger.info("Parsed EsViritu tax profile: \(profiles.count) taxa")
        return profiles
    }

    // MARK: - Line Parsing

    /// Parses a single line from the tax profile file.
    ///
    /// - Parameters:
    ///   - line: The raw tab-separated line.
    ///   - lineNumber: The 1-based line number for error reporting.
    /// - Returns: A ``ViralTaxProfile`` if the line is valid, or `nil` if it
    ///   should be skipped.
    static func parseLine(_ line: String, lineNumber: Int) -> ViralTaxProfile? {
        let columns = line.split(separator: "\t", omittingEmptySubsequences: false)
            .map { String($0) }

        guard columns.count >= expectedColumnCount else {
            logger.warning(
                "Skipping malformed EsViritu tax profile line \(lineNumber): expected \(expectedColumnCount) columns, got \(columns.count)"
            )
            return nil
        }

        let sampleId = columns[0].trimmingCharacters(in: .whitespaces)

        let filteredReadsInSample = EsVirituDetectionParser.parseInt(
            columns[1], default: 0
        )

        // Taxonomy fields (columns 2-9) -- all optional
        let kingdom = EsVirituDetectionParser.optionalString(columns[2])
        let phylum = EsVirituDetectionParser.optionalString(columns[3])
        let tclass = EsVirituDetectionParser.optionalString(columns[4])
        let order = EsVirituDetectionParser.optionalString(columns[5])
        let family = EsVirituDetectionParser.optionalString(columns[6])
        let genus = EsVirituDetectionParser.optionalString(columns[7])
        let species = EsVirituDetectionParser.optionalString(columns[8])
        let subspecies = EsVirituDetectionParser.optionalString(columns[9])

        // Metric fields (columns 10-12)
        let readCount = EsVirituDetectionParser.parseInt(columns[10], default: 0)
        let rpkmf = EsVirituDetectionParser.parseDouble(columns[11], default: 0.0)
        let avgReadIdentity = EsVirituDetectionParser.parseDouble(columns[12], default: 0.0)

        // Assembly list (column 13)
        let assemblyList = columns[13].trimmingCharacters(in: .whitespaces)

        return ViralTaxProfile(
            sampleId: sampleId,
            filteredReadsInSample: filteredReadsInSample,
            kingdom: kingdom,
            phylum: phylum,
            tclass: tclass,
            order: order,
            family: family,
            genus: genus,
            species: species,
            subspecies: subspecies,
            readCount: readCount,
            rpkmf: rpkmf,
            avgReadIdentity: avgReadIdentity,
            assemblyList: assemblyList
        )
    }
}
