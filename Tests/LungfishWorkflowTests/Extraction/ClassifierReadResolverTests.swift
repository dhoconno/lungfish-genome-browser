// ClassifierReadResolverTests.swift — Unit tests for the unified classifier extraction actor
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishWorkflow

final class ClassifierReadResolverTests: XCTestCase {

    // MARK: - resolveProjectRoot

    func testResolveProjectRoot_walksUpToLungfishMarker() throws {
        let fm = FileManager.default
        let tempRoot = fm.temporaryDirectory.appendingPathComponent("resolver-root-\(UUID().uuidString)")
        let lungfishMarker = tempRoot.appendingPathComponent(".lungfish")
        let analyses = tempRoot.appendingPathComponent("analyses")
        let resultDir = analyses.appendingPathComponent("esviritu-20260401")
        try fm.createDirectory(at: lungfishMarker, withIntermediateDirectories: true)
        try fm.createDirectory(at: resultDir, withIntermediateDirectories: true)
        defer { try? fm.removeItem(at: tempRoot) }

        let fakeResultPath = resultDir.appendingPathComponent("results.sqlite")
        fm.createFile(atPath: fakeResultPath.path, contents: Data())

        let resolved = ClassifierReadResolver.resolveProjectRoot(from: fakeResultPath)
        XCTAssertEqual(
            resolved.standardizedFileURL.path,
            tempRoot.standardizedFileURL.path,
            "Expected to walk up to the .lungfish project root"
        )
    }

    func testResolveProjectRoot_noMarker_fallsBackToParentDirectory() throws {
        let fm = FileManager.default
        let tempRoot = fm.temporaryDirectory.appendingPathComponent("resolver-nomarker-\(UUID().uuidString)")
        let resultDir = tempRoot.appendingPathComponent("loose-results")
        try fm.createDirectory(at: resultDir, withIntermediateDirectories: true)
        defer { try? fm.removeItem(at: tempRoot) }

        let fakeResultPath = resultDir.appendingPathComponent("results.sqlite")
        fm.createFile(atPath: fakeResultPath.path, contents: Data())

        let resolved = ClassifierReadResolver.resolveProjectRoot(from: fakeResultPath)
        XCTAssertEqual(
            resolved.standardizedFileURL.path,
            resultDir.standardizedFileURL.path,
            "Expected fallback to the result path's parent directory"
        )
    }

    func testResolveProjectRoot_directoryInput_walksUpFromDirectoryItself() throws {
        let fm = FileManager.default
        let tempRoot = fm.temporaryDirectory.appendingPathComponent("resolver-dir-\(UUID().uuidString)")
        let lungfishMarker = tempRoot.appendingPathComponent(".lungfish")
        let resultDir = tempRoot.appendingPathComponent("analyses/esviritu-20260401")
        try fm.createDirectory(at: lungfishMarker, withIntermediateDirectories: true)
        try fm.createDirectory(at: resultDir, withIntermediateDirectories: true)
        defer { try? fm.removeItem(at: tempRoot) }

        let resolved = ClassifierReadResolver.resolveProjectRoot(from: resultDir)
        XCTAssertEqual(
            resolved.standardizedFileURL.path,
            tempRoot.standardizedFileURL.path
        )
    }

    // MARK: - estimateReadCount

    func testEstimateReadCount_emptySelection_returnsZero() async throws {
        let resolver = ClassifierReadResolver()
        let count = try await resolver.estimateReadCount(
            tool: .esviritu,
            resultPath: URL(fileURLWithPath: "/tmp/nonexistent.sqlite"),
            selections: [],
            options: ExtractionOptions()
        )
        XCTAssertEqual(count, 0)
    }

    func testEstimateReadCount_allEmptySelectors_returnsZero() async throws {
        let resolver = ClassifierReadResolver()
        let count = try await resolver.estimateReadCount(
            tool: .esviritu,
            resultPath: URL(fileURLWithPath: "/tmp/nonexistent.sqlite"),
            selections: [
                ClassifierRowSelector(sampleId: "S1", accessions: [], taxIds: [])
            ],
            options: ExtractionOptions()
        )
        XCTAssertEqual(count, 0)
    }

    // MARK: - resolveBAMURL (per-tool)

    /// Helper: creates a throwaway directory layout that looks like a real
    /// classifier result for the purpose of BAM-path resolution only.
    /// Does NOT create a functional BAM — just a file at the expected path
    /// so `FileManager.fileExists` returns true.
    private func makeFakeClassifierResult(
        tool: ClassifierTool,
        sampleId: String
    ) throws -> (resultPath: URL, expectedBAM: URL) {
        let fm = FileManager.default
        let root = fm.temporaryDirectory.appendingPathComponent("fake-\(tool.rawValue)-\(UUID().uuidString)")
        try fm.createDirectory(at: root, withIntermediateDirectories: true)

        switch tool {
        case .esviritu:
            let bam = root.appendingPathComponent("\(sampleId).sorted.bam")
            fm.createFile(atPath: bam.path, contents: Data([0x1F, 0x8B]))  // fake BGZF magic
            return (resultPath: root.appendingPathComponent("esviritu.sqlite"), expectedBAM: bam)

        case .taxtriage:
            let subdir = root.appendingPathComponent("minimap2")
            try fm.createDirectory(at: subdir, withIntermediateDirectories: true)
            let bam = subdir.appendingPathComponent("\(sampleId).bam")
            fm.createFile(atPath: bam.path, contents: Data([0x1F, 0x8B]))
            return (resultPath: root.appendingPathComponent("taxtriage.sqlite"), expectedBAM: bam)

        case .naomgs:
            let subdir = root.appendingPathComponent("bams")
            try fm.createDirectory(at: subdir, withIntermediateDirectories: true)
            let bam = subdir.appendingPathComponent("\(sampleId).sorted.bam")
            fm.createFile(atPath: bam.path, contents: Data([0x1F, 0x8B]))
            return (resultPath: root.appendingPathComponent("naomgs.sqlite"), expectedBAM: bam)

        case .nvd:
            let bam = root.appendingPathComponent("\(sampleId).bam")
            fm.createFile(atPath: bam.path, contents: Data([0x1F, 0x8B]))
            return (resultPath: root.appendingPathComponent("nvd.sqlite"), expectedBAM: bam)

        case .kraken2:
            fatalError("kraken2 is not a BAM-backed tool")
        }
    }

    func testResolveBAMURL_esviritu_findsSiblingSortedBAM() async throws {
        let (resultPath, expected) = try makeFakeClassifierResult(tool: .esviritu, sampleId: "SRR123")
        defer { try? FileManager.default.removeItem(at: resultPath.deletingLastPathComponent()) }

        let resolver = ClassifierReadResolver()
        let resolved = try await resolver.testingResolveBAMURL(
            tool: .esviritu,
            sampleId: "SRR123",
            resultPath: resultPath
        )
        XCTAssertEqual(resolved.standardizedFileURL.path, expected.standardizedFileURL.path)
    }

    func testResolveBAMURL_taxtriage_findsMinimap2Subdir() async throws {
        let (resultPath, expected) = try makeFakeClassifierResult(tool: .taxtriage, sampleId: "S01")
        defer { try? FileManager.default.removeItem(at: resultPath.deletingLastPathComponent()) }

        let resolver = ClassifierReadResolver()
        let resolved = try await resolver.testingResolveBAMURL(
            tool: .taxtriage,
            sampleId: "S01",
            resultPath: resultPath
        )
        XCTAssertEqual(resolved.standardizedFileURL.path, expected.standardizedFileURL.path)
    }

    func testResolveBAMURL_naomgs_findsBamsSubdir() async throws {
        let (resultPath, expected) = try makeFakeClassifierResult(tool: .naomgs, sampleId: "S02")
        defer { try? FileManager.default.removeItem(at: resultPath.deletingLastPathComponent()) }

        let resolver = ClassifierReadResolver()
        let resolved = try await resolver.testingResolveBAMURL(
            tool: .naomgs,
            sampleId: "S02",
            resultPath: resultPath
        )
        XCTAssertEqual(resolved.standardizedFileURL.path, expected.standardizedFileURL.path)
    }

    func testResolveBAMURL_nvd_findsSiblingBAM() async throws {
        let (resultPath, expected) = try makeFakeClassifierResult(tool: .nvd, sampleId: "SampleX")
        defer { try? FileManager.default.removeItem(at: resultPath.deletingLastPathComponent()) }

        let resolver = ClassifierReadResolver()
        let resolved = try await resolver.testingResolveBAMURL(
            tool: .nvd,
            sampleId: "SampleX",
            resultPath: resultPath
        )
        XCTAssertEqual(resolved.standardizedFileURL.path, expected.standardizedFileURL.path)
    }

    func testResolveBAMURL_missingBAM_throwsBamNotFound() async throws {
        let fm = FileManager.default
        let root = fm.temporaryDirectory.appendingPathComponent("missing-\(UUID().uuidString)")
        try fm.createDirectory(at: root, withIntermediateDirectories: true)
        defer { try? fm.removeItem(at: root) }

        let resultPath = root.appendingPathComponent("esviritu.sqlite")
        let resolver = ClassifierReadResolver()

        do {
            _ = try await resolver.testingResolveBAMURL(
                tool: .esviritu,
                sampleId: "SRR999",
                resultPath: resultPath
            )
            XCTFail("Expected bamNotFound error")
        } catch ClassifierExtractionError.bamNotFound(let sampleId) {
            XCTAssertEqual(sampleId, "SRR999")
        } catch {
            XCTFail("Expected bamNotFound, got \(error)")
        }
    }
}
