// ProjectRootDiscoveryTests.swift — Tests for findProjectRoot utility
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishApp

final class ProjectRootDiscoveryTests: XCTestCase {

    private var tempDir: URL!

    override func setUp() async throws {
        try await super.setUp()
        tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("project-root-test-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
    }

    override func tearDown() async throws {
        if let dir = tempDir {
            try? FileManager.default.removeItem(at: dir)
        }
        try await super.tearDown()
    }

    // MARK: - Derivatives Path (standard classifier output)

    /// The standard path for classifier results run from a FASTQ bundle:
    /// project.lungfish/Downloads/sample.lungfishfastq/derivatives/esviritu-XXXX/
    func testDerivativesPath() throws {
        let projectURL = tempDir.appendingPathComponent("myproject.lungfish")
        let deepPath = projectURL
            .appendingPathComponent("Downloads")
            .appendingPathComponent("sample.lungfishfastq")
            .appendingPathComponent("derivatives")
            .appendingPathComponent("esviritu-ABC123")
        try FileManager.default.createDirectory(at: deepPath, withIntermediateDirectories: true)

        let result = findProjectRoot(deepPath)
        XCTAssertEqual(result?.standardizedFileURL, projectURL.standardizedFileURL)
    }

    // MARK: - Imports Path (NAO-MGS import)

    /// NAO-MGS imports live directly under Imports/:
    /// project.lungfish/Imports/naomgs-MU-CASPER-2026-03-31/
    func testImportsPath() throws {
        let projectURL = tempDir.appendingPathComponent("test.lungfish")
        let importPath = projectURL
            .appendingPathComponent("Imports")
            .appendingPathComponent("naomgs-MU-CASPER-2026-03-31")
        try FileManager.default.createDirectory(at: importPath, withIntermediateDirectories: true)

        let result = findProjectRoot(importPath)
        XCTAssertEqual(result?.standardizedFileURL, projectURL.standardizedFileURL)
    }

    // MARK: - Project root itself

    /// When called with the project directory itself, returns it.
    func testProjectRootItself() throws {
        let projectURL = tempDir.appendingPathComponent("test.lungfish")
        try FileManager.default.createDirectory(at: projectURL, withIntermediateDirectories: true)

        let result = findProjectRoot(projectURL)
        XCTAssertEqual(result?.standardizedFileURL, projectURL.standardizedFileURL)
    }

    // MARK: - No project root

    /// When no .lungfish ancestor exists, returns nil.
    func testNoProjectRoot() {
        let result = findProjectRoot(tempDir)
        XCTAssertNil(result)
    }

    // MARK: - Database file deep inside project

    /// Database path: project.lungfish/Imports/naomgs-*/hits.sqlite
    func testDatabaseFilePath() throws {
        let projectURL = tempDir.appendingPathComponent("test.lungfish")
        let dbDir = projectURL
            .appendingPathComponent("Imports")
            .appendingPathComponent("naomgs-test-import")
        try FileManager.default.createDirectory(at: dbDir, withIntermediateDirectories: true)
        let dbFile = dbDir.appendingPathComponent("hits.sqlite")
        FileManager.default.createFile(atPath: dbFile.path, contents: nil)

        let result = findProjectRoot(dbFile)
        XCTAssertEqual(result?.standardizedFileURL, projectURL.standardizedFileURL)
    }
}
