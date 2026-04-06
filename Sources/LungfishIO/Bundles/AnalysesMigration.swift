// AnalysesMigration.swift - Migrate analysis results from derivatives/ to Analyses/
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import os

private let logger = Logger(subsystem: LogSubsystem.io, category: "AnalysesMigration")

public enum AnalysesMigration {

    /// Analysis directory prefixes that should be migrated from derivatives/.
    private static let analysisPrefixes = [
        "classification-", "esviritu-", "taxtriage-", "naomgs-", "nvd-",
    ]

    /// Maps a directory prefix to the tool name used in Analyses/.
    private static func toolForPrefix(_ prefix: String) -> String {
        switch prefix {
        case "classification-": return "kraken2"
        case "esviritu-": return "esviritu"
        case "taxtriage-": return "taxtriage"
        case "naomgs-": return "naomgs"
        case "nvd-": return "nvd"
        default: return prefix.replacingOccurrences(of: "-", with: "")
        }
    }

    /// Scans all .lungfishfastq bundles for analysis results in derivatives/
    /// and moves them to Analyses/. Returns count of directories migrated.
    @discardableResult
    public static func migrateProject(at projectURL: URL) throws -> Int {
        let fm = FileManager.default
        var totalMigrated = 0

        // 1. Find all .lungfishfastq bundles as direct children of projectURL
        let projectContents = try fm.contentsOfDirectory(
            at: projectURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )

        let bundles = projectContents.filter {
            $0.pathExtension.lowercased() == "lungfishfastq" &&
            (try? $0.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true
        }

        for bundleURL in bundles {
            let derivativesURL = bundleURL.appendingPathComponent("derivatives", isDirectory: true)

            // Skip bundles with no derivatives directory
            var isDir: ObjCBool = false
            guard fm.fileExists(atPath: derivativesURL.path, isDirectory: &isDir),
                  isDir.boolValue else {
                continue
            }

            // 2. Scan derivatives/ for directories matching analysisPrefixes
            let derivContents = try fm.contentsOfDirectory(
                at: derivativesURL,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsHiddenFiles]
            )

            for candidateURL in derivContents {
                let name = candidateURL.lastPathComponent

                // 3. Skip .lungfishfastq directories — those are FASTQ-to-FASTQ transforms, not analyses
                if candidateURL.pathExtension.lowercased() == "lungfishfastq" {
                    continue
                }

                // Only consider subdirectories
                guard (try? candidateURL.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true else {
                    continue
                }

                // Find matching prefix
                guard let matchedPrefix = analysisPrefixes.first(where: { name.hasPrefix($0) }) else {
                    continue
                }

                let tool = toolForPrefix(matchedPrefix)

                // 4. Extract timestamp from the sidecar's savedAt field
                let date = extractTimestamp(from: candidateURL) ?? Date()
                let timestamp = AnalysesFolder.formatTimestamp(date)

                // 5. Determine destination: Analyses/{tool}-{timestamp}/
                let analysesDir = try AnalysesFolder.url(for: projectURL)
                let destName = "\(tool)-\(timestamp)"
                let destURL = analysesDir.appendingPathComponent(destName, isDirectory: true)

                // Skip if destination already exists (idempotent)
                if fm.fileExists(atPath: destURL.path) {
                    logger.info("Migration: skipping \(name), destination \(destName) already exists")
                    continue
                }

                // 6. Move directory to Analyses/{tool}-{timestamp}/
                try fm.moveItem(at: candidateURL, to: destURL)
                logger.info("Migration: moved \(name) -> Analyses/\(destName)")

                // 7. Record in analyses-manifest.json of the source bundle
                let entry = AnalysisManifestEntry(
                    tool: tool,
                    timestamp: date,
                    analysisDirectoryName: destName,
                    displayName: displayName(for: tool),
                    summary: "Migrated from derivatives/\(name)"
                )
                try AnalysisManifestStore.recordAnalysis(entry, bundleURL: bundleURL)

                totalMigrated += 1
            }
        }

        if totalMigrated > 0 {
            logger.info("Migration: migrated \(totalMigrated) analysis director\(totalMigrated == 1 ? "y" : "ies") in \(projectURL.lastPathComponent)")
        }

        return totalMigrated
    }

    /// Display name for a tool identifier.
    private static func displayName(for tool: String) -> String {
        switch tool {
        case "esviritu": return "EsViritu Detection"
        case "kraken2": return "Kraken2 Classification"
        case "taxtriage": return "TaxTriage Analysis"
        case "naomgs": return "NAO-MGS Import"
        case "nvd": return "NVD Analysis"
        default: return tool.capitalized
        }
    }

    /// Extract timestamp from sidecar JSON's savedAt field.
    private static func extractTimestamp(from analysisDir: URL) -> Date? {
        let sidecarNames = [
            "esviritu-result.json",
            "classification-result.json",
            "taxtriage-result.json",
        ]
        for name in sidecarNames {
            let sidecarURL = analysisDir.appendingPathComponent(name)
            guard let data = try? Data(contentsOf: sidecarURL) else { continue }
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let savedAtString = json["savedAt"] as? String {
                let formatter = ISO8601DateFormatter()
                if let date = formatter.date(from: savedAtString) {
                    return date
                }
            }
        }
        return nil
    }
}
