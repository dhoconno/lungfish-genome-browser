import XCTest
@testable import LungfishApp

final class DatasetOperationsDialogTests: XCTestCase {
    func testSharedSectionOrderMatchesApprovedDialogContract() {
        XCTAssertEqual(DatasetOperationSection.allCases.map(\.title), [
            "Overview",
            "Inputs",
            "Primary Settings",
            "Advanced Settings",
            "Output",
            "Readiness",
        ])
    }

    func testToolAvailabilityStatePreservesComingSoonAndDisabledReason() {
        XCTAssertEqual(DatasetOperationAvailability.comingSoon.badgeText, "Coming Soon")
        XCTAssertEqual(
            DatasetOperationAvailability.disabled(reason: "Requires Alignment Pack").badgeText,
            "Requires Alignment Pack"
        )
    }
}
