// BundleBuildHelpers.swift - Shared utilities for bundle building ViewModels
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import LungfishCore
import LungfishWorkflow

/// Shared helpers used by both ``GenomeDownloadViewModel`` and ``GenBankBundleDownloadViewModel``
/// during `.lungfishref` bundle creation.
enum BundleBuildHelpers {

    static func sanitizedFilename(_ raw: String) -> String {
        raw
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: ":", with: "-")
            .replacingOccurrences(of: " ", with: "_")
    }

    static func makeUniqueBundleURL(baseName: String, in directory: URL) -> URL {
        var candidate = directory.appendingPathComponent("\(baseName).lungfishref", isDirectory: true)
        var counter = 1
        while FileManager.default.fileExists(atPath: candidate.path) {
            candidate = directory.appendingPathComponent("\(baseName)_\(counter).lungfishref", isDirectory: true)
            counter += 1
        }
        return candidate
    }

    static func parseFai(at url: URL) throws -> [ChromosomeInfo] {
        let content = try String(contentsOf: url, encoding: .utf8)
        let lines = content.split(whereSeparator: \.isNewline)

        var chromosomes: [ChromosomeInfo] = []
        for line in lines {
            let fields = line.split(separator: "\t")
            guard fields.count >= 5,
                  let length = Int64(fields[1]),
                  let offset = Int64(fields[2]),
                  let lineBases = Int(fields[3]),
                  let lineWidth = Int(fields[4]) else {
                continue
            }

            let name = String(fields[0])
            let isMito = name.lowercased() == "mt" || name.lowercased() == "chrm" || name.uppercased().contains("MITO")
            chromosomes.append(
                ChromosomeInfo(
                    name: name,
                    length: length,
                    offset: offset,
                    lineBases: lineBases,
                    lineWidth: lineWidth,
                    aliases: [],
                    isPrimary: true,
                    isMitochondrial: isMito,
                    fastaDescription: nil
                )
            )
        }

        if chromosomes.isEmpty {
            throw BundleBuildError.indexingFailed("FASTA index is empty or unreadable")
        }

        return chromosomes
    }

    static func writeChromSizes(_ chromosomes: [ChromosomeInfo], to url: URL) throws {
        let lines = chromosomes.map { "\($0.name)\t\($0.length)" }
        try lines.joined(separator: "\n").appending("\n").write(to: url, atomically: true, encoding: .utf8)
    }

    /// Clips BED coordinates to chromosome boundaries.
    static func clipBEDCoordinates(bedURL: URL, chromosomeSizes: [(String, Int64)]) {
        let chromSizeMap = Dictionary(uniqueKeysWithValues: chromosomeSizes)
        guard let content = try? String(contentsOf: bedURL, encoding: .utf8) else { return }
        let lines = content.components(separatedBy: .newlines)

        var clipped: [String] = []
        for line in lines {
            if line.isEmpty || line.hasPrefix("#") {
                clipped.append(line)
                continue
            }
            var fields = line.split(separator: "\t", omittingEmptySubsequences: false).map(String.init)
            guard fields.count >= 3 else {
                clipped.append(line)
                continue
            }
            let chrom = fields[0]
            guard let chromSize = chromSizeMap[chrom] else {
                clipped.append(line)
                continue
            }
            if let start = Int64(fields[1]), start >= chromSize { continue }
            if let end = Int64(fields[2]), end > chromSize {
                fields[2] = "\(chromSize)"
            }
            // Also clip thickEnd (BED12 column 7) to chromosome boundary
            if fields.count >= 7 {
                if let thickEnd = Int64(fields[6]), thickEnd > chromSize {
                    fields[6] = "\(chromSize)"
                }
            }
            clipped.append(fields.joined(separator: "\t"))
        }

        try? clipped.joined(separator: "\n").write(to: bedURL, atomically: true, encoding: .utf8)
    }

    /// Strips columns beyond `keepColumns`.
    static func stripExtraBEDColumns(bedURL: URL, keepColumns: Int) {
        guard let content = try? String(contentsOf: bedURL, encoding: .utf8) else { return }
        let lines = content.components(separatedBy: .newlines)

        var stripped: [String] = []
        for line in lines {
            if line.isEmpty || line.hasPrefix("#") {
                stripped.append(line)
                continue
            }
            let fields = line.split(separator: "\t", omittingEmptySubsequences: false)
            if fields.count > keepColumns {
                stripped.append(fields.prefix(keepColumns).joined(separator: "\t"))
            } else {
                stripped.append(line)
            }
        }

        try? stripped.joined(separator: "\n").write(to: bedURL, atomically: true, encoding: .utf8)
    }

    /// Validates that required tools (bgzip, samtools) are available.
    ///
    /// - Throws: `BundleBuildError.missingTools` if essential tools are missing.
    static func validateTools(using toolRunner: NativeToolRunner) async throws {
        let (valid, missing) = await toolRunner.validateToolsInstallation()
        if !valid {
            let essential = missing.filter { $0 == .bgzip || $0 == .samtools }
            if !essential.isEmpty {
                throw BundleBuildError.missingTools(essential.map(\.rawValue))
            }
        }
    }

    /// Formats a byte count as a human-readable string.
    static func formatBytes(_ bytes: Int64) -> String {
        ByteCountFormatter.string(fromByteCount: bytes, countStyle: .file)
    }
}
