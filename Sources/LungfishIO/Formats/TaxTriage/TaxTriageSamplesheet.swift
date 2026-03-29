// TaxTriageSamplesheet.swift - TaxTriage input samplesheet CSV generator
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import LungfishCore

// MARK: - TaxTriageSamplesheet

/// Generates and parses TaxTriage samplesheet CSV files.
///
/// TaxTriage requires a CSV samplesheet as input that describes each sample's
/// FASTQ file paths and sequencing platform. This type handles both generation
/// and parsing of the samplesheet format.
///
/// ## Samplesheet Format
///
/// ```csv
/// sample,fastq_1,fastq_2,platform
/// MySample,/path/to/R1.fastq.gz,/path/to/R2.fastq.gz,ILLUMINA
/// SingleEnd,/path/to/reads.fastq.gz,,OXFORD
/// ```
///
/// ## Example
///
/// ```swift
/// let csv = TaxTriageSamplesheet.generate(from: config)
/// try TaxTriageSamplesheet.write(config: config, to: outputURL)
/// ```
public enum TaxTriageSamplesheet {

    /// The CSV header line for the TaxTriage samplesheet.
    public static let header = "sample,fastq_1,fastq_2,platform"

    // MARK: - Generation

    /// Generates the samplesheet CSV content from a TaxTriage configuration.
    ///
    /// Each sample is written as a row with the sample ID, FASTQ paths, and
    /// platform. Paired-end samples have both `fastq_1` and `fastq_2` populated;
    /// single-end samples leave `fastq_2` empty.
    ///
    /// - Parameter samples: The sample definitions.
    /// - Returns: The complete CSV content as a string.
    public static func generate(from samples: [TaxTriageSampleEntry]) -> String {
        var lines = [header]

        for sample in samples {
            let fastq2Field = sample.fastq2Path ?? ""
            let row = "\(csvEscape(sample.sampleId)),\(csvEscape(sample.fastq1Path)),\(csvEscape(fastq2Field)),\(sample.platform)"
            lines.append(row)
        }

        return lines.joined(separator: "\n") + "\n"
    }

    /// Writes the samplesheet CSV to disk.
    ///
    /// Creates the parent directory if needed, then writes the CSV content
    /// atomically to the specified URL.
    ///
    /// - Parameters:
    ///   - samples: The sample entries to write.
    ///   - url: The destination file URL.
    /// - Throws: If directory creation or file writing fails.
    public static func write(samples: [TaxTriageSampleEntry], to url: URL) throws {
        let fm = FileManager.default
        let parentDir = url.deletingLastPathComponent()
        if !fm.fileExists(atPath: parentDir.path) {
            try fm.createDirectory(at: parentDir, withIntermediateDirectories: true)
        }

        let content = generate(from: samples)
        try content.write(to: url, atomically: true, encoding: .utf8)
    }

    // MARK: - Parsing

    /// Parses a samplesheet CSV file into sample entries.
    ///
    /// - Parameter url: The samplesheet file URL.
    /// - Returns: An array of parsed sample entries.
    /// - Throws: If the file cannot be read or the format is invalid.
    public static func parse(url: URL) throws -> [TaxTriageSampleEntry] {
        let content = try String(contentsOf: url, encoding: .utf8)
        return try parse(csv: content)
    }

    /// Parses samplesheet CSV content into sample entries.
    ///
    /// - Parameter csv: The CSV content string.
    /// - Returns: An array of parsed sample entries.
    /// - Throws: ``TaxTriageSamplesheetError`` if the format is invalid.
    public static func parse(csv: String) throws -> [TaxTriageSampleEntry] {
        let lines = csv.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        guard let headerLine = lines.first else {
            throw TaxTriageSamplesheetError.emptyFile
        }

        // Validate header
        let expectedColumns = ["sample", "fastq_1", "fastq_2", "platform"]
        let headerColumns = headerLine.components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces).lowercased() }
        guard headerColumns == expectedColumns else {
            throw TaxTriageSamplesheetError.invalidHeader(
                expected: expectedColumns,
                got: headerColumns
            )
        }

        var entries: [TaxTriageSampleEntry] = []

        for (lineIndex, line) in lines.dropFirst().enumerated() {
            let fields = line.components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }

            guard fields.count >= 4 else {
                throw TaxTriageSamplesheetError.insufficientColumns(
                    line: lineIndex + 2,
                    expected: 4,
                    got: fields.count
                )
            }

            let sampleId = fields[0]
            let fastq1 = fields[1]
            let fastq2 = fields[2].isEmpty ? nil : fields[2]
            let platform = fields[3]

            guard !sampleId.isEmpty else {
                throw TaxTriageSamplesheetError.emptySampleId(line: lineIndex + 2)
            }

            guard !fastq1.isEmpty else {
                throw TaxTriageSamplesheetError.emptyFastq1(
                    line: lineIndex + 2,
                    sampleId: sampleId
                )
            }

            entries.append(TaxTriageSampleEntry(
                sampleId: sampleId,
                fastq1Path: fastq1,
                fastq2Path: fastq2,
                platform: platform
            ))
        }

        return entries
    }

    // MARK: - Helpers

    /// Escapes a field value for CSV output.
    ///
    /// Wraps the value in double quotes if it contains commas, quotes, or newlines.
    ///
    /// - Parameter value: The raw field value.
    /// - Returns: The CSV-safe field value.
    private static func csvEscape(_ value: String) -> String {
        let needsQuoting = value.contains(",") || value.contains("\"") || value.contains("\n")
        if needsQuoting {
            let escaped = value.replacingOccurrences(of: "\"", with: "\"\"")
            return "\"\(escaped)\""
        }
        return value
    }
}

// MARK: - TaxTriageSampleEntry

/// A single entry in a TaxTriage samplesheet.
///
/// This is a parse-friendly representation that uses raw strings rather than
/// typed URLs, making it suitable for both generation and parsing.
public struct TaxTriageSampleEntry: Sendable, Codable, Equatable {

    /// The sample identifier.
    public let sampleId: String

    /// Path to the first FASTQ file.
    public let fastq1Path: String

    /// Path to the second FASTQ file (nil for single-end).
    public let fastq2Path: String?

    /// Platform string (e.g., "ILLUMINA", "OXFORD", "PACBIO").
    public let platform: String

    /// Creates a new samplesheet entry.
    ///
    /// - Parameters:
    ///   - sampleId: Sample identifier.
    ///   - fastq1Path: Path to R1 FASTQ.
    ///   - fastq2Path: Path to R2 FASTQ (nil for single-end).
    ///   - platform: Platform string.
    public init(
        sampleId: String,
        fastq1Path: String,
        fastq2Path: String? = nil,
        platform: String = "ILLUMINA"
    ) {
        self.sampleId = sampleId
        self.fastq1Path = fastq1Path
        self.fastq2Path = fastq2Path
        self.platform = platform
    }

    /// Whether this entry represents paired-end data.
    public var isPairedEnd: Bool {
        fastq2Path != nil && !(fastq2Path?.isEmpty ?? true)
    }
}

// MARK: - TaxTriageSamplesheetError

/// Errors produced when parsing or validating TaxTriage samplesheets.
public enum TaxTriageSamplesheetError: Error, LocalizedError, Sendable {

    /// The samplesheet file is empty.
    case emptyFile

    /// The header row does not match the expected format.
    case invalidHeader(expected: [String], got: [String])

    /// A data row has too few columns.
    case insufficientColumns(line: Int, expected: Int, got: Int)

    /// A sample ID field is empty.
    case emptySampleId(line: Int)

    /// The fastq_1 field is empty for a sample.
    case emptyFastq1(line: Int, sampleId: String)

    public var errorDescription: String? {
        switch self {
        case .emptyFile:
            return "Samplesheet file is empty"
        case .invalidHeader(let expected, let got):
            return "Invalid header: expected [\(expected.joined(separator: ","))] but got [\(got.joined(separator: ","))]"
        case .insufficientColumns(let line, let expected, let got):
            return "Line \(line): expected \(expected) columns, got \(got)"
        case .emptySampleId(let line):
            return "Line \(line): sample ID is empty"
        case .emptyFastq1(let line, let sampleId):
            return "Line \(line): fastq_1 is empty for sample '\(sampleId)'"
        }
    }
}
