import XCTest
@testable import LungfishApp

@MainActor
final class MainSplitSelectionCoordinatorTests: XCTestCase {
    func testSlowSelectionCannotCommitAfterNewerSelectionBecomesActive() {
        let controller = MainSplitViewController()
        _ = controller.view

        let first = ContentSelectionIdentity(
            url: URL(fileURLWithPath: "/tmp/A.naomgs"),
            kind: "naoMgsResult"
        )
        let second = ContentSelectionIdentity(
            url: URL(fileURLWithPath: "/tmp/B.nvd"),
            kind: "nvdResult"
        )

        let firstToken = controller.testingBeginDisplayRequest(identity: first)
        let secondToken = controller.testingBeginDisplayRequest(identity: second)

        XCTAssertFalse(controller.testingCanCommitDisplayRequest(firstToken, identity: first))
        XCTAssertTrue(controller.testingCanCommitDisplayRequest(secondToken, identity: second))
    }

    func testContextMenuOpenRoutesThroughExplicitDisplayPath() throws {
        let sourceURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            .appendingPathComponent("Sources/LungfishApp/Views/Sidebar/SidebarViewController.swift")
        let source = try String(contentsOf: sourceURL, encoding: .utf8)
        let contextOpenRange = try XCTUnwrap(source.range(of: "@objc private func contextMenuOpen"))
        let followingSource = String(source[contextOpenRange.lowerBound...])
        let methodEnd = try XCTUnwrap(followingSource.range(of: "@objc private func contextMenuMergeIntoNewBundle"))
        let methodSource = String(followingSource[..<methodEnd.lowerBound])

        XCTAssertTrue(
            methodSource.contains("selectionDelegate?.sidebarDidSelectItem(item)"),
            "Context-menu Open must invoke the explicit display delegate path, not only post sidebarSelectionChanged."
        )
    }
}
