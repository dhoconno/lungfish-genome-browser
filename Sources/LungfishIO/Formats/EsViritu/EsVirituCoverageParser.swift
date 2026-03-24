// EsVirituCoverageParser.swift - Parser for EsViritu virus_coverage_windows.tsv
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Reference: https://github.com/hurwitzlab/EsViritu

import Foundation
import os.log

/// Logger for EsViritu coverage window parsing operations.
private let logger = Logger(subsystem: "com.lungfish.io", category: "EsVirituCoverageParser")

/// Errors that can occur during EsViritu coverage window file parsing.
public enum EsVirituCoverageParserError: Error, LocalizedError, Sendable {

    /// The coverage file is empty or contains no parseable data lines.
    case emptyFile

    /// The coverage file could not be read from disk.
    case fileReadError(URL, String)

    /// A required column value could not be parsed on a specific line.
    case invalidColumnValue(line: Int, column: String, value: String)

    public var errorDescription: String? {
        switch self {
        case .emptyFile:
            return "Empty EsViritu coverage windows file"
        case .fileReadError(let url, let detail):
            return "Cannot read EsViritu coverage file at \(url.lastPathComponent): \(detail)"
        case .invalidColumnValue(let line, let column, let value):
            return "Invalid \(column) value '\(value)' on line \(line)"
        }
    }
}

/// A pure-function parser for EsViritu `virus_coverage_windows.tsv` files.
///
/// The `virus_coverage_windows.tsv` file is a 5-column tab-separated file that
/// describes the average read depth within fixed-width windows along each
/// detected viral contig. Used for plotting coverage depth profiles.
///
/// **Columns:**
///
/// | Index | Header | Description |
/// |-------|--------|-------------|
/// | 0 | Accession | GenBank accession |
/// | 1 | window_index | Zero-based window index |
/// | 2 | window_start | Window start position (0-based) |
/// | 3 | window_end | Window end position |
/// | 4 | average_coverage | Mean read depth in window |
///
/// ## Usage
///
/// ```swift
/// let windows = try EsVirituCoverageParser.parse(url: coverageURL)
/// let windowsByAccession = Dictionary(grouping: windows, by: \.accession)
/// ```
///
/// ## Thread Safety
///
/// All methods are static and pure -- they take input and return output without
/// side effects. They are safe to call from any isolation domain.
public enum EsVirituCoverageParser {

    /// Expected minimum number of columns in each data row.
    private static let expectedColumnCount = 5

    // MARK: - Public API

    /// Parses an EsViritu coverage windows file from a URL.
    ///
    /// - Parameter url: The file URL to the `virus_coverage_windows.tsv` file.
    /// - Returns: An array of ``ViralCoverageWindow`` values.
    /// - Throws: ``EsVirituCoverageParserError`` if the file cannot be read or parsed.
    public static func parse(url: URL) throws -> [ViralCoverageWindow] {
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw EsVirituCoverageParserError.fileReadError(url, error.localizedDescription)
        }
        return try parse(data: data)
    }

    /// Parses EsViritu coverage data from in-memory bytes.
    ///
    /// - Parameter data: The raw bytes of the coverage file.
    /// - Returns: An array of ``ViralCoverageWindow`` values.
    /// - Throws: ``EsVirituCoverageParserError`` if the data cannot be parsed.
    public static func parse(data: Data) throws -> [ViralCoverageWindow] {
        guard let text = String(data: data, encoding: .utf8) else {
            throw EsVirituCoverageParserError.emptyFile
        }
        return try parse(text: text)
    }

    /// Parses EsViritu coverage data from a string.
    ///
    /// - Parameter text: The coverage file content as a string.
    /// - Returns: An array of ``ViralCoverageWindow`` values.
    /// - Throws: ``EsVirituCoverageParserError`` if the text cannot be parsed.
    public static func parse(text: String) throws -> [ViralCoverageWindow] {
        let lines = text.components(separatedBy: .newlines)
        var windows: [ViralCoverageWindow] = []
        var lineNumber = 0

        for line in lines {
            lineNumber += 1

            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.isEmpty { continue }

            // Skip header line
            if trimmed.hasPrefix("Accession") || trimmed.hasPrefix("accession") {
                continue
            }

            // Skip comment lines
            if trimmed.hasPrefix("#") { continue }

            guard let window = parseLine(line, lineNumber: lineNumber) else {
                continue
            }

            windows.append(window)
        }

        if windows.isEmpty {
            throw EsVirituCoverageParserError.emptyFile
        }

        logger.info("Parsed EsViritu coverage: \(windows.count) windows")
        return windows
    }

    // MARK: - Line Parsing

    /// Parses a single line from the coverage windows file.
    ///
    /// - Parameters:
    ///   - line: The raw tab-separated line.
    ///   - lineNumber: The 1-based line number for error reporting.
    /// - Returns: A ``ViralCoverageWindow`` if the line is valid, or `nil` if it
    ///   should be skipped.
    static func parseLine(_ line: String, lineNumber: Int) -> ViralCoverageWindow? {
        let columns = line.split(separator: "\t", omittingEmptySubsequences: false)
            .map { String($0) }

        guard columns.count >= expectedColumnCount else {
            logger.warning(
                "Skipping malformed EsViritu coverage line \(lineNumber): expected \(expectedColumnCount) columns, got \(columns.count)"
            )
            return nil
        }

        let accession = columns[0].trimmingCharacters(in: .whitespaces)

        guard let windowIndex = Int(columns[1].trimmingCharacters(in: .whitespaces)) else {
            logger.warning(
                "Skipping EsViritu coverage line \(lineNumber): invalid window_index '\(columns[1])'"
            )
            return nil
        }

        guard let windowStart = Int(columns[2].trimmingCharacters(in: .whitespaces)) else {
            logger.warning(
                "Skipping EsViritu coverage line \(lineNumber): invalid window_start '\(columns[2])'"
            )
            return nil
        }

        guard let windowEnd = Int(columns[3].trimmingCharacters(in: .whitespaces)) else {
            logger.warning(
                "Skipping EsViritu coverage line \(lineNumber): invalid window_end '\(columns[3])'"
            )
            return nil
        }

        guard let averageCoverage = Double(columns[4].trimmingCharacters(in: .whitespaces)) else {
            logger.warning(
                "Skipping EsViritu coverage line \(lineNumber): invalid average_coverage '\(columns[4])'"
            )
            return nil
        }

        return ViralCoverageWindow(
            accession: accession,
            windowIndex: windowIndex,
            windowStart: windowStart,
            windowEnd: windowEnd,
            averageCoverage: averageCoverage
        )
    }
}
