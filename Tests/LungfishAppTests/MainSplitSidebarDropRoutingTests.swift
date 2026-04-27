// MainSplitSidebarDropRoutingTests.swift - Tests for sidebar drop notification ownership
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import XCTest
@testable import LungfishApp

@MainActor
final class MainSplitSidebarDropRoutingTests: XCTestCase {

    func testSidebarDropNotificationsAreHandledOnlyByOwningSplitController() {
        let sourceSidebar = SidebarViewController()
        let destinationSidebar = SidebarViewController()

        XCTAssertFalse(
            MainSplitViewController.shouldHandleSidebarFileDropNotification(
                from: destinationSidebar,
                owningSidebar: sourceSidebar,
                owningViewer: nil
            ),
            "A source project window must not process a drop posted by a different sidebar."
        )
        XCTAssertTrue(
            MainSplitViewController.shouldHandleSidebarFileDropNotification(
                from: destinationSidebar,
                owningSidebar: destinationSidebar,
                owningViewer: nil
            ),
            "The destination project window should process drops posted by its own sidebar."
        )
        XCTAssertTrue(
            MainSplitViewController.shouldHandleSidebarFileDropNotification(
                from: nil,
                owningSidebar: sourceSidebar,
                owningViewer: nil
            ),
            "Legacy/global import notifications should continue to route through the existing handler."
        )
    }
}
