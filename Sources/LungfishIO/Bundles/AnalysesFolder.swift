// AnalysesFolder.swift - Manage project-level Analyses/ directory
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import os.log

private let logger = Logger(subsystem: LogSubsystem.io, category: "AnalysesFolder")

/// Manages the `Analyses/` directory within a project directory.
///
/// Analysis results (classification, assembly, alignment) are stored as
/// timestamped subdirectories: `{tool}-{yyyy-MM-dd'T'HH-mm-ss}/` or
/// `{tool}-batch-{yyyy-MM-dd'T'HH-mm-ss}/` for batch runs.
public enum AnalysesFolder {

    /// The directory name within the project directory.
    public static let directoryName = "Analyses"

    /// The set of recognised tool names used to parse directory entries.
    public static let knownTools: Set<String> = [
        "esviritu", "kraken2", "taxtriage", "minimap2",
        "spades", "megahit", "naomgs", "nvd",
    ]

    // MARK: - Tool Metadata

    /// Human-readable display name for a tool identifier.
    public static func displayName(for tool: String) -> String {
        switch tool {
        case "esviritu": return "EsViritu"
        case "kraken2": return "Kraken2"
        case "taxtriage": return "TaxTriage"
        case "spades": return "SPAdes"
        case "megahit": return "MEGAHIT"
        case "minimap2": return "Minimap2"
        case "naomgs": return "NAO-MGS"
        case "nvd": return "NVD"
        default: return tool.capitalized
        }
    }

    // MARK: - Directory Management

    /// Returns the `Analyses/` URL for a project, creating the directory if it doesn't exist.
    public static func url(for projectURL: URL) throws -> URL {
        let dir = projectURL.appendingPathComponent(directoryName, isDirectory: true)
        let fm = FileManager.default
        if !fm.fileExists(atPath: dir.path) {
            try fm.createDirectory(at: dir, withIntermediateDirectories: true)
            logger.info("Created Analyses directory at \(dir.path)")
        }
        return dir
    }

    // MARK: - Creating Analysis Directories

    /// Creates a new timestamped analysis subdirectory.
    ///
    /// - Single run:  `Analyses/{tool}-{yyyy-MM-dd'T'HH-mm-ss}/`
    /// - Batch run:   `Analyses/{tool}-batch-{yyyy-MM-dd'T'HH-mm-ss}/`
    ///
    /// - Parameters:
    ///   - tool: The tool identifier (e.g. `"kraken2"`).
    ///   - projectURL: Path to the project directory.
    ///   - isBatch: Whether this is a batch run.
    ///   - date: The date to embed in the directory name (defaults to now).
    /// - Returns: URL of the newly created analysis directory.
    @discardableResult
    public static func createAnalysisDirectory(
        tool: String,
        in projectURL: URL,
        isBatch: Bool = false,
        date: Date = Date()
    ) throws -> URL {
        let analysesDir = try url(for: projectURL)
        let timestamp = formatTimestamp(date)
        let name = isBatch ? "\(tool)-batch-\(timestamp)" : "\(tool)-\(timestamp)"
        let analysisURL = analysesDir.appendingPathComponent(name, isDirectory: true)
        try FileManager.default.createDirectory(at: analysisURL, withIntermediateDirectories: true)
        logger.info("Created analysis directory: \(name)")
        return analysisURL
    }

    // MARK: - Listing

    /// Lists all analysis directories in `Analyses/`, sorted newest first.
    ///
    /// Directories whose names cannot be parsed as `{tool}[-batch]-{timestamp}`
    /// (with a recognised tool name) are silently ignored. Returns an empty
    /// array if `Analyses/` does not exist.
    public static func listAnalyses(in projectURL: URL) throws -> [AnalysisDirectoryInfo] {
        let dir = projectURL.appendingPathComponent(directoryName, isDirectory: true)
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: dir.path, isDirectory: &isDirectory),
              isDirectory.boolValue else {
            return []
        }

        let contents = try FileManager.default.contentsOfDirectory(
            at: dir,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )

        var results: [AnalysisDirectoryInfo] = []
        for url in contents {
            // Only consider subdirectories.
            guard (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true else {
                continue
            }
            guard let info = parseDirectoryName(url.lastPathComponent, url: url) else {
                continue
            }
            results.append(info)
        }

        return results.sorted { $0.timestamp > $1.timestamp }
    }

    // MARK: - Timestamp Formatting

    /// Formats a date as `yyyy-MM-dd'T'HH-mm-ss` (filesystem-safe ISO 8601).
    public static func formatTimestamp(_ date: Date) -> String {
        timestampFormatter.string(from: date)
    }

    /// Parses a `yyyy-MM-dd'T'HH-mm-ss` string back to a `Date`.
    public static func parseTimestamp(_ string: String) -> Date? {
        timestampFormatter.date(from: string)
    }

    // MARK: - AnalysisDirectoryInfo

    /// Metadata about a discovered analysis directory.
    public struct AnalysisDirectoryInfo: Sendable {
        /// The URL of the analysis directory.
        public let url: URL
        /// The tool that produced this analysis (e.g. `"kraken2"`).
        public let tool: String
        /// When the analysis was created (parsed from the directory name).
        public let timestamp: Date
        /// Whether this was a batch run.
        public let isBatch: Bool
    }

    // MARK: - Private Helpers

    /// Parses a directory name of the form `{tool}-batch-{timestamp}` or
    /// `{tool}-{timestamp}`, checking that the tool is in `knownTools`.
    private static func parseDirectoryName(_ name: String, url: URL) -> AnalysisDirectoryInfo? {
        // Try batch pattern first: {tool}-batch-{timestamp}
        for tool in knownTools {
            let batchPrefix = "\(tool)-batch-"
            if name.hasPrefix(batchPrefix) {
                let timestampPart = String(name.dropFirst(batchPrefix.count))
                if let date = parseTimestamp(timestampPart) {
                    return AnalysisDirectoryInfo(url: url, tool: tool, timestamp: date, isBatch: true)
                }
            }
        }

        // Try single pattern: {tool}-{timestamp}
        for tool in knownTools {
            let prefix = "\(tool)-"
            if name.hasPrefix(prefix) {
                let timestampPart = String(name.dropFirst(prefix.count))
                if let date = parseTimestamp(timestampPart) {
                    return AnalysisDirectoryInfo(url: url, tool: tool, timestamp: date, isBatch: false)
                }
            }
        }

        return nil
    }

    /// Shared `DateFormatter` for `yyyy-MM-dd'T'HH-mm-ss`.
    private static let timestampFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH-mm-ss"
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone.current
        return df
    }()
}
