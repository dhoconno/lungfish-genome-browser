// PrimerSchemeImportViewModel.swift - Import Center view model for user-authored primer schemes
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import LungfishIO
import Observation

/// View model that writes a user-authored `.lungfishprimers` bundle from a BED
/// file (and optional FASTA + attachments) into the active project's
/// `Primer Schemes/` folder.
///
/// Separate from ``BuiltInPrimerSchemeService``: this writes to the project,
/// not the shipped Resources bundle. The user edits the canonical accession,
/// display name, and any equivalents; the view model parses primer/amplicon
/// counts from column 4 of the BED.
@MainActor
@Observable
final class PrimerSchemeImportViewModel {
    /// Result returned to the Import Center when an import succeeds.
    public struct ImportResult: Sendable {
        public let bundleURL: URL
    }

    /// Errors thrown by ``performImport``.
    public enum ImportError: Error, LocalizedError, Sendable {
        case bedUnreadable(underlying: Error & Sendable)
        case emptyName
        case emptyCanonical
        case bundleAlreadyExists(name: String, url: URL)
        case copyFailed(path: String, underlying: Error & Sendable)
        case writeFailed(underlying: Error & Sendable)

        public var errorDescription: String? {
            switch self {
            case .bedUnreadable(let underlying):
                return "Could not read the primer BED: \(underlying.localizedDescription)"
            case .emptyName:
                return "Give the primer scheme a file-safe name."
            case .emptyCanonical:
                return "Enter the canonical reference accession (e.g., MN908947.3)."
            case .bundleAlreadyExists(let name, _):
                return "A primer scheme named \(name) already exists in this project."
            case .copyFailed(let path, let underlying):
                return "Failed to copy \(path): \(underlying.localizedDescription)"
            case .writeFailed(let underlying):
                return "Failed to write the primer-scheme bundle: \(underlying.localizedDescription)"
            }
        }
    }

    public init() {}

    /// Writes a primer-scheme bundle into `projectURL/Primer Schemes/<name>.lungfishprimers`.
    ///
    /// - Parameters:
    ///   - bedURL: Required BED file describing primer coordinates.
    ///   - fastaURL: Optional primer-sequences FASTA; bundled as `primers.fasta` when present.
    ///   - attachments: Optional extra files copied under `attachments/`.
    ///   - name: File-safe bundle name (slashes are replaced with underscores).
    ///   - displayName: Human-readable name shown in pickers.
    ///   - canonicalAccession: Reference accession the BED's column 1 is anchored to.
    ///   - equivalentAccessions: Additional accessions the resolver may rewrite to.
    ///   - projectURL: The currently open project's folder.
    public func performImport(
        bedURL: URL,
        fastaURL: URL?,
        attachments: [URL],
        name: String,
        displayName: String,
        canonicalAccession: String,
        equivalentAccessions: [String],
        projectURL: URL
    ) throws -> ImportResult {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCanonical = canonicalAccession.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { throw ImportError.emptyName }
        guard !trimmedCanonical.isEmpty else { throw ImportError.emptyCanonical }

        let safeName = trimmedName.replacingOccurrences(of: "/", with: "_")
        let folder: URL
        do {
            folder = try PrimerSchemesFolder.ensureFolder(in: projectURL)
        } catch {
            throw ImportError.writeFailed(underlying: error as NSError)
        }
        let bundleURL = folder.appendingPathComponent("\(safeName).lungfishprimers", isDirectory: true)

        if FileManager.default.fileExists(atPath: bundleURL.path) {
            throw ImportError.bundleAlreadyExists(name: safeName, url: bundleURL)
        }

        let counts: (primerCount: Int, ampliconCount: Int)
        do {
            counts = try Self.parseCounts(bedURL: bedURL)
        } catch {
            throw ImportError.bedUnreadable(underlying: error as NSError)
        }

        do {
            try FileManager.default.createDirectory(at: bundleURL, withIntermediateDirectories: true)
            try FileManager.default.copyItem(at: bedURL, to: bundleURL.appendingPathComponent("primers.bed"))
            if let fastaURL {
                try FileManager.default.copyItem(at: fastaURL, to: bundleURL.appendingPathComponent("primers.fasta"))
            }
            if !attachments.isEmpty {
                let attachmentsDir = bundleURL.appendingPathComponent("attachments", isDirectory: true)
                try FileManager.default.createDirectory(at: attachmentsDir, withIntermediateDirectories: true)
                for attachment in attachments {
                    try FileManager.default.copyItem(
                        at: attachment,
                        to: attachmentsDir.appendingPathComponent(attachment.lastPathComponent)
                    )
                }
            }
        } catch {
            throw ImportError.copyFailed(path: bundleURL.lastPathComponent, underlying: error as NSError)
        }

        let references: [PrimerSchemeManifest.ReferenceAccession] =
            [.init(accession: trimmedCanonical, canonical: true, equivalent: false)]
            + equivalentAccessions
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
                .map { .init(accession: $0, canonical: false, equivalent: true) }

        let manifest = PrimerSchemeManifest(
            schemaVersion: 1,
            name: safeName,
            displayName: displayName.isEmpty ? safeName : displayName,
            description: nil,
            organism: nil,
            referenceAccessions: references,
            primerCount: counts.primerCount,
            ampliconCount: counts.ampliconCount,
            source: "imported",
            sourceURL: nil,
            version: nil,
            created: Date(),
            imported: Date(),
            attachments: attachments.isEmpty
                ? nil
                : attachments.map { .init(path: "attachments/\($0.lastPathComponent)", description: nil) }
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let manifestData: Data
        do {
            manifestData = try encoder.encode(manifest)
            try manifestData.write(to: bundleURL.appendingPathComponent("manifest.json"))
        } catch {
            throw ImportError.writeFailed(underlying: error as NSError)
        }

        let provenance = """
            # PROVENANCE

            Imported via Lungfish Genome Explorer on \(ISO8601DateFormatter().string(from: Date())).
            BED source: \(bedURL.path)
            """
        do {
            try provenance.write(
                to: bundleURL.appendingPathComponent("PROVENANCE.md"),
                atomically: true,
                encoding: .utf8
            )
        } catch {
            throw ImportError.writeFailed(underlying: error as NSError)
        }

        return ImportResult(bundleURL: bundleURL)
    }

    /// Parses `bedURL` and returns `(primerCount, ampliconCount)`.
    ///
    /// `primerCount` is the number of non-empty, non-comment lines.
    /// `ampliconCount` is the distinct amplicon names — primer names in column 4
    /// with trailing `_LEFT`/`_RIGHT` stripped and any trailing `-N` variant tag removed.
    private static func parseCounts(bedURL: URL) throws -> (primerCount: Int, ampliconCount: Int) {
        let content = try String(contentsOf: bedURL, encoding: .utf8)
        let lines = content
            .split(separator: "\n", omittingEmptySubsequences: true)
            .filter { !$0.hasPrefix("#") && !$0.isEmpty }
        let primerCount = lines.count
        var ampliconNames = Set<String>()
        for line in lines {
            let cols = line.split(separator: "\t")
            guard cols.count >= 4 else { continue }
            var name = String(cols[3])
            if name.hasSuffix("_LEFT") {
                name = String(name.dropLast("_LEFT".count))
            } else if name.hasSuffix("_RIGHT") {
                name = String(name.dropLast("_RIGHT".count))
            }
            // Strip a trailing variant tag like "-2", "-3" that follows after the stripped _LEFT/_RIGHT.
            if let dashIndex = name.lastIndex(of: "-"),
               name.distance(from: dashIndex, to: name.endIndex) <= 3,
               name[name.index(after: dashIndex)...].allSatisfy(\.isNumber) {
                name = String(name[..<dashIndex])
            }
            ampliconNames.insert(name)
        }
        return (primerCount, ampliconNames.count)
    }
}
