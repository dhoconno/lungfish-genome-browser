// StorageSettingsTabTests.swift - Tests for the shared storage settings tab
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest

final class StorageSettingsTabTests: XCTestCase {
    func testStorageSettingsSourceUsesSharedManagedStorageCopy() throws {
        let source = try String(
            contentsOf: repositoryRoot()
                .appendingPathComponent("Sources/LungfishApp/Views/Settings/StorageSettingsTab.swift"),
            encoding: .utf8
        )

        XCTAssertTrue(source.contains("Third-Party Tools and Databases"))
        XCTAssertFalse(source.contains("Section(\"Database Storage\")"))
    }

    func testStorageSettingsSourceIncludesCleanupAction() throws {
        let source = try String(
            contentsOf: repositoryRoot()
                .appendingPathComponent("Sources/LungfishApp/Views/Settings/StorageSettingsTab.swift"),
            encoding: .utf8
        )

        XCTAssertTrue(source.contains("Remove old local copies"))
    }

    private func repositoryRoot() -> URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }
}
