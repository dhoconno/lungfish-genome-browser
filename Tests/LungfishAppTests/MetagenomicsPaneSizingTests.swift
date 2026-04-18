import XCTest
@testable import LungfishApp

final class MetagenomicsPaneSizingTests: XCTestCase {
    func testClampedDrawerExtentLeavesVisibleHostStrip() {
        let height = MetagenomicsPaneSizing.clampedDrawerExtent(
            proposed: 960,
            containerExtent: 1000,
            minimumDrawerExtent: 140,
            minimumSiblingExtent: 120
        )

        XCTAssertEqual(height, 880)
    }

    func testClampedDrawerExtentHonorsMinimumDrawerHeight() {
        let height = MetagenomicsPaneSizing.clampedDrawerExtent(
            proposed: 50,
            containerExtent: 1000,
            minimumDrawerExtent: 140,
            minimumSiblingExtent: 120
        )

        XCTAssertEqual(height, 140)
    }

    func testClampedDividerPositionLeavesVisibleTrailingPane() {
        let position = MetagenomicsPaneSizing.clampedDividerPosition(
            proposed: 980,
            containerExtent: 1000,
            minimumLeadingExtent: 120,
            minimumTrailingExtent: 120
        )

        XCTAssertEqual(position, 880)
    }
}
