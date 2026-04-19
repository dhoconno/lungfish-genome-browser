import XCTest
@testable import LungfishApp

final class AppUITestConfigurationTests: XCTestCase {
    func testLaunchArgumentEnablesUITestModeAndCapturesScenario() {
        let config = AppUITestConfiguration(
            arguments: ["Lungfish", "--skip-welcome", "--ui-test-mode"],
            environment: ["LUNGFISH_UI_TEST_SCENARIO": "database-search-basic"]
        )

        XCTAssertTrue(config.isEnabled)
        XCTAssertEqual(config.scenarioName, "database-search-basic")
    }

    func testEnvironmentFlagAlsoEnablesUITestMode() {
        let config = AppUITestConfiguration(
            arguments: ["Lungfish"],
            environment: ["LUNGFISH_UI_TEST_MODE": "1"]
        )

        XCTAssertTrue(config.isEnabled)
        XCTAssertNil(config.scenarioName)
    }

    func testNormalLaunchLeavesUITestModeDisabled() {
        let config = AppUITestConfiguration(
            arguments: ["Lungfish"],
            environment: [:]
        )

        XCTAssertFalse(config.isEnabled)
        XCTAssertNil(config.scenarioName)
    }
}
