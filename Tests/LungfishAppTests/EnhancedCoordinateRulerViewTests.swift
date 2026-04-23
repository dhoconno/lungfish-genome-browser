import XCTest
@testable import LungfishApp

@MainActor
final class EnhancedCoordinateRulerViewTests: XCTestCase {

    func testInfoBarLayoutKeepsLabelsBeforePositionControlsInNarrowPane() {
        let layout = EnhancedCoordinateRulerView.infoBarTextLayout(
            viewWidth: 330,
            rangeTextWidth: 150,
            totalTextWidth: 85
        )

        XCTAssertLessThanOrEqual(layout.rangeRect.maxX, layout.textClipMaxX)
        XCTAssertNil(layout.totalRect)
        XCTAssertLessThan(layout.rangeRect.width, 150)
    }

    func testInfoBarLayoutShowsTotalTextWhenSpaceAllows() {
        let layout = EnhancedCoordinateRulerView.infoBarTextLayout(
            viewWidth: 900,
            rangeTextWidth: 150,
            totalTextWidth: 85
        )

        XCTAssertEqual(layout.rangeRect.width, 150)
        XCTAssertEqual(layout.totalRect?.width, 85)
        XCTAssertLessThanOrEqual(layout.totalRect?.maxX ?? 0, layout.textClipMaxX)
    }
}
