// SamtoolsLocatorTests.swift - Tests for shared samtools discovery
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishIO

final class SamtoolsLocatorTests: XCTestCase {
    func testLocateFindsExecutableInProvidedPath() throws {
        let fm = FileManager.default
        let tempDir = fm.temporaryDirectory.appendingPathComponent("samtools-locator-\(UUID().uuidString)")
        try fm.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? fm.removeItem(at: tempDir) }

        let samtoolsURL = tempDir.appendingPathComponent("samtools")
        try "#!/bin/sh\nexit 0\n".write(to: samtoolsURL, atomically: true, encoding: .utf8)
        try fm.setAttributes([.posixPermissions: 0o755], ofItemAtPath: samtoolsURL.path)

        let resolved = SamtoolsLocator.locate(searchPath: tempDir.path)

        XCTAssertEqual(resolved, samtoolsURL.path)
    }

    func testLocatePrefersManagedHomeBeforePathFallbacks() throws {
        let fm = FileManager.default
        let home = fm.temporaryDirectory.appendingPathComponent("samtools-home-\(UUID().uuidString)")
        let managedSamtools = home
            .appendingPathComponent(".lungfish/conda/envs/samtools/bin/samtools")
        try fm.createDirectory(at: managedSamtools.deletingLastPathComponent(), withIntermediateDirectories: true)
        try "#!/bin/sh\nexit 0\n".write(to: managedSamtools, atomically: true, encoding: .utf8)
        try fm.setAttributes([.posixPermissions: 0o755], ofItemAtPath: managedSamtools.path)

        let pathDir = fm.temporaryDirectory.appendingPathComponent("samtools-path-\(UUID().uuidString)")
        try fm.createDirectory(at: pathDir, withIntermediateDirectories: true)
        defer {
            try? fm.removeItem(at: home)
            try? fm.removeItem(at: pathDir)
        }

        let pathSamtools = pathDir.appendingPathComponent("samtools")
        try "#!/bin/sh\nexit 0\n".write(to: pathSamtools, atomically: true, encoding: .utf8)
        try fm.setAttributes([.posixPermissions: 0o755], ofItemAtPath: pathSamtools.path)

        let resolved = SamtoolsLocator.locate(
            homeDirectory: home,
            searchPath: pathDir.path
        )

        XCTAssertEqual(resolved, managedSamtools.path)
    }
}
