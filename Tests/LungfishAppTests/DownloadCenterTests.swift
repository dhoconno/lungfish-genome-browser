// DownloadCenterTests.swift - Unit tests for DownloadCenter
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishApp

/// Unit tests for ``DownloadCenter``.
///
/// Tests cover:
/// - Starting downloads creates items
/// - Updating progress and detail
/// - Completing and failing items
/// - Trim keeps max 20 finished items
/// - clearCompleted removes non-running items
/// - Active count tracking
@MainActor
final class DownloadCenterTests: XCTestCase {

    private var center: DownloadCenter!

    override func setUp() async throws {
        try await super.setUp()
        center = DownloadCenter()
    }

    override func tearDown() async throws {
        center = nil
        try await super.tearDown()
    }

    // MARK: - Start

    func testStartCreatesRunningItem() {
        let id = center.start(title: "Test", detail: "Starting...")

        XCTAssertEqual(center.items.count, 1)
        let item = center.items.first
        XCTAssertEqual(item?.id, id)
        XCTAssertEqual(item?.title, "Test")
        XCTAssertEqual(item?.detail, "Starting...")
        XCTAssertEqual(item?.progress, 0)
        XCTAssertEqual(item?.state, .running)
        XCTAssertNil(item?.finishedAt)
    }

    func testStartInsertsAtFront() {
        let id1 = center.start(title: "First", detail: "")
        let id2 = center.start(title: "Second", detail: "")

        XCTAssertEqual(center.items.count, 2)
        XCTAssertEqual(center.items[0].id, id2)
        XCTAssertEqual(center.items[1].id, id1)
    }

    // MARK: - Update

    func testUpdateChangesProgressAndDetail() {
        let id = center.start(title: "Test", detail: "Starting...")

        center.update(id: id, progress: 0.5, detail: "Halfway")

        let item = center.items.first
        XCTAssertEqual(item?.progress ?? -1, 0.5, accuracy: 0.001)
        XCTAssertEqual(item?.detail, "Halfway")
        XCTAssertEqual(item?.state, .running)
    }

    func testUpdateClampsProgress() {
        let id = center.start(title: "Test", detail: "")

        center.update(id: id, progress: 1.5, detail: "Over")
        XCTAssertEqual(center.items.first?.progress ?? -1, 1.0, accuracy: 0.001)

        center.update(id: id, progress: -0.5, detail: "Under")
        XCTAssertEqual(center.items.first?.progress ?? -1, 0.0, accuracy: 0.001)
    }

    func testUpdateIgnoresUnknownId() {
        _ = center.start(title: "Test", detail: "Starting...")

        center.update(id: UUID(), progress: 0.9, detail: "Other")

        XCTAssertEqual(center.items.first?.detail, "Starting...")
    }

    // MARK: - Complete

    func testCompleteSetsStateAndFinishedAt() {
        let id = center.start(title: "Test", detail: "Starting...")

        center.complete(id: id, detail: "Done!")

        let item = center.items.first
        XCTAssertEqual(item?.state, .completed)
        XCTAssertEqual(item?.progress ?? -1, 1.0, accuracy: 0.001)
        XCTAssertEqual(item?.detail, "Done!")
        XCTAssertNotNil(item?.finishedAt)
    }

    // MARK: - Fail

    func testFailSetsStateAndFinishedAt() {
        let id = center.start(title: "Test", detail: "Starting...")

        center.fail(id: id, detail: "Network error")

        let item = center.items.first
        XCTAssertEqual(item?.state, .failed)
        XCTAssertEqual(item?.detail, "Network error")
        XCTAssertNotNil(item?.finishedAt)
    }

    // MARK: - Active Count

    func testActiveCountTracksRunningItems() {
        XCTAssertEqual(center.activeCount, 0)

        let id1 = center.start(title: "A", detail: "")
        _ = center.start(title: "B", detail: "")

        XCTAssertEqual(center.activeCount, 2)

        center.complete(id: id1, detail: "Done")
        XCTAssertEqual(center.activeCount, 1)
    }

    // MARK: - Clear Completed

    func testClearCompletedRemovesFinishedItems() {
        let id1 = center.start(title: "Running", detail: "")
        let id2 = center.start(title: "Done", detail: "")
        let id3 = center.start(title: "Failed", detail: "")

        center.complete(id: id2, detail: "Completed")
        center.fail(id: id3, detail: "Error")

        XCTAssertEqual(center.items.count, 3)

        center.clearCompleted()

        XCTAssertEqual(center.items.count, 1)
        XCTAssertEqual(center.items.first?.id, id1)
        XCTAssertEqual(center.items.first?.state, .running)
    }

    func testClearCompletedWithNoFinishedItemsIsNoOp() {
        _ = center.start(title: "Running", detail: "")
        XCTAssertEqual(center.items.count, 1)

        center.clearCompleted()
        XCTAssertEqual(center.items.count, 1)
    }

    // MARK: - Trim

    func testTrimKeepsMaxFinishedItems() {
        // Start and complete 25 items (exceeds the 20-item limit)
        for i in 0..<25 {
            let id = center.start(title: "Item \(i)", detail: "")
            center.complete(id: id, detail: "Done \(i)")
        }

        // All 25 are completed; trim should keep only 20
        XCTAssertLessThanOrEqual(center.items.count, 20)
    }

    func testTrimPreservesRunningItems() {
        // Start a running item
        _ = center.start(title: "Running", detail: "In progress")

        // Start and complete 25 items
        for i in 0..<25 {
            let id = center.start(title: "Item \(i)", detail: "")
            center.complete(id: id, detail: "Done \(i)")
        }

        // Running item must be preserved
        let runningItems = center.items.filter { $0.state == .running }
        XCTAssertEqual(runningItems.count, 1)
        XCTAssertEqual(runningItems.first?.title, "Running")
    }

    // MARK: - Item Identity

    func testItemIdentityByUUID() {
        let id1 = center.start(title: "A", detail: "")
        let id2 = center.start(title: "B", detail: "")

        XCTAssertNotEqual(id1, id2)
        XCTAssertEqual(center.items.count, 2)
    }

    // MARK: - Item State Enum

    func testItemStateRawValues() {
        XCTAssertEqual(DownloadCenter.Item.State.running.rawValue, "running")
        XCTAssertEqual(DownloadCenter.Item.State.completed.rawValue, "completed")
        XCTAssertEqual(DownloadCenter.Item.State.failed.rawValue, "failed")
    }

    // MARK: - Bundle URLs

    func testCompleteWithBundleURLsStoresURLs() {
        let id = center.start(title: "Test", detail: "Starting...")
        let urls = [URL(fileURLWithPath: "/tmp/test.lungfishref")]

        center.complete(id: id, detail: "Done!", bundleURLs: urls)

        let item = center.items.first
        XCTAssertEqual(item?.state, .completed)
        XCTAssertEqual(item?.bundleURLs.count, 1)
        XCTAssertEqual(item?.bundleURLs.first?.lastPathComponent, "test.lungfishref")
    }

    func testCompleteWithBundleURLsFiresOnBundleReady() {
        var receivedURLs: [URL]?
        center.onBundleReady = { urls in
            receivedURLs = urls
        }

        let id = center.start(title: "Test", detail: "Starting...")
        let urls = [URL(fileURLWithPath: "/tmp/a.lungfishref"), URL(fileURLWithPath: "/tmp/b.lungfishref")]

        center.complete(id: id, detail: "Done!", bundleURLs: urls)

        XCTAssertEqual(receivedURLs?.count, 2)
        XCTAssertEqual(receivedURLs?.first?.lastPathComponent, "a.lungfishref")
    }

    func testCompleteWithEmptyBundleURLsDoesNotFireCallback() {
        var callbackFired = false
        center.onBundleReady = { _ in
            callbackFired = true
        }

        let id = center.start(title: "Test", detail: "Starting...")
        center.complete(id: id, detail: "Done!", bundleURLs: [])

        XCTAssertFalse(callbackFired)
    }

    func testCompleteWithoutBundleURLsDoesNotFireCallback() {
        var callbackFired = false
        center.onBundleReady = { _ in
            callbackFired = true
        }

        let id = center.start(title: "Test", detail: "Starting...")
        center.complete(id: id, detail: "Done!")

        XCTAssertFalse(callbackFired)
    }

    func testStartItemHasEmptyBundleURLs() {
        let id = center.start(title: "Test", detail: "Starting...")
        let item = center.items.first { $0.id == id }
        XCTAssertEqual(item?.bundleURLs, [])
    }
}
