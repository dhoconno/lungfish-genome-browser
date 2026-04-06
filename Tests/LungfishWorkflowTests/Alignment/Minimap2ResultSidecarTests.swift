// Minimap2ResultSidecarTests.swift - Tests for Minimap2 alignment result persistence
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishWorkflow

final class Minimap2ResultSidecarTests: XCTestCase {
    private var tempDir: URL!

    override func setUp() {
        super.setUp()
        tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("test-minimap2-sidecar-\(UUID().uuidString)")
        try! FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: tempDir)
        super.tearDown()
    }

    private func makeResult() -> Minimap2Result {
        Minimap2Result(
            bamURL: tempDir.appendingPathComponent("sample.sorted.bam"),
            baiURL: tempDir.appendingPathComponent("sample.sorted.bam.bai"),
            totalReads: 10_000,
            mappedReads: 9_500,
            unmappedReads: 500,
            wallClockSeconds: 45.2
        )
    }

    func testExistsReturnsFalseForMissingFile() {
        XCTAssertFalse(Minimap2Result.exists(in: tempDir))
    }

    func testExistsReturnsTrueAfterSave() throws {
        let result = makeResult()
        try result.save(to: tempDir, toolVersion: "2.28")
        XCTAssertTrue(Minimap2Result.exists(in: tempDir))
    }

    func testSaveWritesJSONFile() throws {
        let result = makeResult()
        try result.save(to: tempDir, toolVersion: "2.28")
        let jsonURL = tempDir.appendingPathComponent("alignment-result.json")
        XCTAssertTrue(FileManager.default.fileExists(atPath: jsonURL.path))
        let data = try Data(contentsOf: jsonURL)
        XCTAssertGreaterThan(data.count, 0)
    }

    func testSaveAndLoadRoundTrip() throws {
        let result = makeResult()
        try result.save(to: tempDir, toolVersion: "2.28")
        XCTAssertTrue(Minimap2Result.exists(in: tempDir))
        let loaded = try Minimap2Result.load(from: tempDir)

        XCTAssertEqual(loaded.bamURL.lastPathComponent, "sample.sorted.bam")
        XCTAssertEqual(loaded.baiURL.lastPathComponent, "sample.sorted.bam.bai")
        XCTAssertEqual(loaded.totalReads, 10_000)
        XCTAssertEqual(loaded.mappedReads, 9_500)
        XCTAssertEqual(loaded.unmappedReads, 500)
        XCTAssertEqual(loaded.wallClockSeconds, 45.2, accuracy: 1e-9)
    }

    func testLoadedURLsAreRelativeToDirectory() throws {
        let result = makeResult()
        try result.save(to: tempDir, toolVersion: "2.28")
        let loaded = try Minimap2Result.load(from: tempDir)

        // Compare via path strings to avoid trailing-slash URL discrepancy from
        // deletingLastPathComponent(). Trim "/" as CharacterSet scalar.
        XCTAssertEqual(
            loaded.bamURL.deletingLastPathComponent().path.trimmingCharacters(in: CharacterSet(charactersIn: "/")),
            tempDir.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        )
        XCTAssertEqual(
            loaded.baiURL.deletingLastPathComponent().path.trimmingCharacters(in: CharacterSet(charactersIn: "/")),
            tempDir.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        )
    }

    func testLoadThrowsWhenSidecarMissing() {
        XCTAssertThrowsError(try Minimap2Result.load(from: tempDir)) { error in
            XCTAssertTrue(error is Minimap2ResultLoadError)
        }
    }

    func testJSONContainsToolVersion() throws {
        let result = makeResult()
        try result.save(to: tempDir, toolVersion: "2.28-r1209")
        let jsonURL = tempDir.appendingPathComponent("alignment-result.json")
        let text = try String(contentsOf: jsonURL, encoding: .utf8)
        XCTAssertTrue(text.contains("2.28-r1209"), "JSON should contain the tool version")
    }
}
