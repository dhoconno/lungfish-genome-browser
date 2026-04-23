// MappingViewerBundlePreparer.swift - Builds lightweight mapping viewer bundles
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import LungfishCore
import LungfishIO

enum MappingViewerBundlePreparer {

    static func prepareBaseBundle(
        sourceBundleURL: URL,
        viewerBundleURL: URL,
        fileManager: FileManager = .default
    ) throws {
        let sourceManifest = try BundleManifest.load(from: sourceBundleURL)

        if fileManager.fileExists(atPath: viewerBundleURL.path) {
            try fileManager.removeItem(at: viewerBundleURL)
        }
        try fileManager.createDirectory(
            at: viewerBundleURL,
            withIntermediateDirectories: true
        )

        for itemName in referencedTopLevelItems(in: sourceManifest).sorted() {
            let sourceItem = sourceBundleURL.appendingPathComponent(itemName)
            guard fileManager.fileExists(atPath: sourceItem.path) else { continue }

            let viewerItem = viewerBundleURL.appendingPathComponent(itemName)
            try linkOrCopyItem(from: sourceItem, to: viewerItem, fileManager: fileManager)
        }

        let manifest = BundleManifest(
            formatVersion: sourceManifest.formatVersion,
            name: sourceManifest.name,
            identifier: sourceManifest.identifier,
            description: sourceManifest.description,
            originBundlePath: originBundlePath(from: viewerBundleURL, to: sourceBundleURL),
            createdDate: sourceManifest.createdDate,
            modifiedDate: Date(),
            source: sourceManifest.source,
            genome: sourceManifest.genome,
            annotations: sourceManifest.annotations,
            variants: sourceManifest.variants,
            tracks: sourceManifest.tracks,
            alignments: [],
            metadata: sourceManifest.metadata,
            browserSummary: nil
        )
        try manifest.save(to: viewerBundleURL)
    }

    private static func referencedTopLevelItems(in manifest: BundleManifest) -> Set<String> {
        var items = Set<String>()

        if let genome = manifest.genome {
            insertTopLevelItem(from: genome.path, into: &items)
            insertTopLevelItem(from: genome.indexPath, into: &items)
        }

        for annotation in manifest.annotations {
            insertTopLevelItem(from: annotation.path, into: &items)
            if let databasePath = annotation.databasePath {
                insertTopLevelItem(from: databasePath, into: &items)
            }
        }

        for variant in manifest.variants {
            insertTopLevelItem(from: variant.path, into: &items)
            insertTopLevelItem(from: variant.indexPath, into: &items)
            if let databasePath = variant.databasePath {
                insertTopLevelItem(from: databasePath, into: &items)
            }
        }

        for track in manifest.tracks {
            insertTopLevelItem(from: track.path, into: &items)
        }

        items.remove(BundleManifest.filename)
        items.remove("alignments")
        return items
    }

    private static func insertTopLevelItem(from path: String, into items: inout Set<String>) {
        guard !path.isEmpty, !path.hasPrefix("/") else { return }
        let components = path.split(separator: "/", omittingEmptySubsequences: true)
        guard let first = components.first else { return }
        items.insert(String(first))
    }

    private static func linkOrCopyItem(
        from sourceURL: URL,
        to destinationURL: URL,
        fileManager: FileManager
    ) throws {
        if fileManager.fileExists(atPath: destinationURL.path) {
            try fileManager.removeItem(at: destinationURL)
        }

        do {
            try fileManager.createSymbolicLink(
                at: destinationURL,
                withDestinationURL: sourceURL
            )
        } catch {
            try fileManager.copyItem(at: sourceURL, to: destinationURL)
        }
    }

    private static func originBundlePath(from viewerBundleURL: URL, to sourceBundleURL: URL) -> String {
        FASTQBundle.projectRelativePath(for: sourceBundleURL, from: viewerBundleURL)
            ?? filesystemRelativePath(from: viewerBundleURL, to: sourceBundleURL)
    }

    private static func filesystemRelativePath(from baseURL: URL, to targetURL: URL) -> String {
        let baseComponents = baseURL.standardizedFileURL.pathComponents
        let targetComponents = targetURL.standardizedFileURL.pathComponents

        var common = 0
        while common < min(baseComponents.count, targetComponents.count),
              baseComponents[common] == targetComponents[common] {
            common += 1
        }

        let up = Array(repeating: "..", count: max(0, baseComponents.count - common))
        let down = Array(targetComponents.dropFirst(common))
        let parts = up + down
        return parts.isEmpty ? "." : parts.joined(separator: "/")
    }
}
