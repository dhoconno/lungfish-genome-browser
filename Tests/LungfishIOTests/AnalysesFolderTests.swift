// AnalysesFolderTests.swift - Tests for AnalysesFolder manager
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishIO

final class AnalysesFolderTests: XCTestCase {
    private var tempDir: URL!

    override func setUp() {
        super.setUp()
        tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("test-analyses-folder-\(UUID().uuidString)")
        try! FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: tempDir)
        super.tearDown()
    }

    func testURLCreatesDirectoryIfMissing() throws {
        let url = try AnalysesFolder.url(for: tempDir)
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
        XCTAssertEqual(url.lastPathComponent, "Analyses")
    }

    func testURLReturnsExistingDirectory() throws {
        let existing = tempDir.appendingPathComponent("Analyses")
        try FileManager.default.createDirectory(at: existing, withIntermediateDirectories: true)
        let url = try AnalysesFolder.url(for: tempDir)
        XCTAssertEqual(url.path, existing.path)
    }

    func testCreateAnalysisDirectoryFormatsTimestamp() throws {
        let date = Date(timeIntervalSince1970: 1775398200) // some fixed date
        let url = try AnalysesFolder.createAnalysisDirectory(
            tool: "esviritu", in: tempDir, date: date
        )
        XCTAssertTrue(url.lastPathComponent.hasPrefix("esviritu-"))
        XCTAssertTrue(url.lastPathComponent.contains("2026"))
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }

    func testCreateAnalysisDirectoryIsBatchAware() throws {
        let url = try AnalysesFolder.createAnalysisDirectory(
            tool: "kraken2", in: tempDir, isBatch: true
        )
        XCTAssertTrue(url.lastPathComponent.hasPrefix("kraken2-batch-"))
    }

    func testListAnalysesFindsAllTypes() throws {
        let analysesDir = try AnalysesFolder.url(for: tempDir)
        for name in ["esviritu-2026-01-15T10-00-00", "kraken2-2026-01-15T11-00-00", "spades-2026-01-15T13-00-00"] {
            try FileManager.default.createDirectory(
                at: analysesDir.appendingPathComponent(name),
                withIntermediateDirectories: true
            )
        }
        let analyses = try AnalysesFolder.listAnalyses(in: tempDir)
        XCTAssertEqual(analyses.count, 3)
    }

    func testListAnalysesParseToolAndTimestamp() throws {
        let analysesDir = try AnalysesFolder.url(for: tempDir)
        try FileManager.default.createDirectory(
            at: analysesDir.appendingPathComponent("esviritu-2026-01-15T10-00-00"),
            withIntermediateDirectories: true
        )
        let analyses = try AnalysesFolder.listAnalyses(in: tempDir)
        XCTAssertEqual(analyses.first?.tool, "esviritu")
        XCTAssertFalse(analyses.first?.isBatch ?? true)
    }

    func testListAnalysesDetectsBatch() throws {
        let analysesDir = try AnalysesFolder.url(for: tempDir)
        try FileManager.default.createDirectory(
            at: analysesDir.appendingPathComponent("esviritu-batch-2026-01-15T15-00-00"),
            withIntermediateDirectories: true
        )
        let analyses = try AnalysesFolder.listAnalyses(in: tempDir)
        XCTAssertTrue(analyses.first?.isBatch ?? false)
    }

    func testListAnalysesIgnoresNonAnalysisDirectories() throws {
        let analysesDir = try AnalysesFolder.url(for: tempDir)
        try FileManager.default.createDirectory(
            at: analysesDir.appendingPathComponent("random-folder"),
            withIntermediateDirectories: true
        )
        try "not an analysis".write(
            to: analysesDir.appendingPathComponent("readme.txt"),
            atomically: true, encoding: .utf8
        )
        let analyses = try AnalysesFolder.listAnalyses(in: tempDir)
        XCTAssertEqual(analyses.count, 0)
    }

    func testListAnalysesReturnsEmptyForMissingFolder() throws {
        let analyses = try AnalysesFolder.listAnalyses(in: tempDir)
        XCTAssertEqual(analyses.count, 0)
    }

    func testTimestampFormat() {
        let formatted = AnalysesFolder.formatTimestamp(
            Date(timeIntervalSince1970: 1775398200)
        )
        XCTAssertFalse(formatted.contains(":"))
        XCTAssertTrue(formatted.contains("T"))
    }
}
