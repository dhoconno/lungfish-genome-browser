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
}
