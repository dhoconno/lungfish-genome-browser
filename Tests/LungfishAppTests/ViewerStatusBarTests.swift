import AppKit
import XCTest
@testable import LungfishApp

@MainActor
final class ViewerStatusBarTests: XCTestCase {
    func testLongStatusTextDoesNotOverlapAtNarrowWidth() throws {
        let statusBar = ViewerStatusBar(frame: NSRect(x: 0, y: 0, width: 360, height: 24))

        statusBar.update(
            position: "MF0214_2__h2tg000003l_28523125_35203480:1-6680356",
            selection: "Visible: 1-6680356 (6,680,356 bp)",
            scale: 6680.4
        )
        statusBar.layoutSubtreeIfNeeded()

        let labels = allTextFields(in: statusBar)
        let positionLabel = try XCTUnwrap(labels.first { $0.accessibilityIdentifier() == "position-label" })
        let selectionLabel = try XCTUnwrap(labels.first { $0.accessibilityIdentifier() == "selection-label" })
        let scaleLabel = try XCTUnwrap(labels.first { $0.accessibilityIdentifier() == "scale-label" })

        XCTAssertLessThanOrEqual(positionLabel.frame.maxX, selectionLabel.frame.minX)
        XCTAssertLessThanOrEqual(selectionLabel.frame.maxX, scaleLabel.frame.minX)
    }

    private func allTextFields(in view: NSView) -> [NSTextField] {
        view.subviews.flatMap { subview -> [NSTextField] in
            let current = (subview as? NSTextField).map { [$0] } ?? []
            return current + allTextFields(in: subview)
        }
    }
}
