import XCTest
import LungfishCore
@testable import LungfishApp

@MainActor
final class InspectorNotificationScopingTests: XCTestCase {
    func testInspectorIgnoresSelectionNotificationFromDifferentWindowScope() {
        let inspector = InspectorViewController()
        _ = inspector.view
        inspector.testingWindowStateScope = WindowStateScope()

        let otherScope = WindowStateScope()
        let item = SidebarItem(
            title: "Other Window",
            type: .sequence,
            url: URL(fileURLWithPath: "/tmp/other.fasta")
        )

        inspector.testingHandleSidebarSelectionChanged(
            Notification(
                name: .sidebarSelectionChanged,
                object: nil,
                userInfo: [
                    "item": item,
                    NotificationUserInfoKey.windowStateScope: otherScope,
                ]
            )
        )

        XCTAssertNil(inspector.viewModel.selectedItem)
    }

    func testInspectorStillAcceptsLegacyUnscopedSelectionNotification() {
        let inspector = InspectorViewController()
        _ = inspector.view
        inspector.testingWindowStateScope = WindowStateScope()

        let item = SidebarItem(
            title: "Legacy",
            type: .sequence,
            url: URL(fileURLWithPath: "/tmp/legacy.fasta")
        )

        inspector.testingHandleSidebarSelectionChanged(
            Notification(
                name: .sidebarSelectionChanged,
                object: nil,
                userInfo: ["item": item]
            )
        )

        XCTAssertEqual(inspector.viewModel.selectedItem, "Legacy")
    }
}
