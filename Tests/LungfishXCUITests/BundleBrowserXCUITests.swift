import XCTest

final class BundleBrowserXCUITests: XCTestCase {
    @MainActor
    func testOpeningReferenceBundleShowsBrowserAndBackNavigationRestoresSelection() throws {
        let projectURL = try LungfishProjectFixtureBuilder.makeBundleBrowserProject(
            named: "BundleBrowserFixture"
        )
        let robot = BundleBrowserRobot()
        defer {
            robot.app.terminate()
            try? FileManager.default.removeItem(at: projectURL.deletingLastPathComponent())
        }

        robot.launch(opening: projectURL)
        robot.openBundle(named: "TestGenome.lungfishref")
        robot.waitForBrowserLoaded()
        robot.waitForBrowserRow(named: "chr1")

        robot.selectBrowserRow(named: "chr2")
        robot.openSelectedSequence()
        robot.waitForBackNavigationButton()

        robot.tapBackNavigation()
        robot.waitForBrowserLoaded()
        robot.waitForSelectedBrowserRow(named: "chr2")
    }
}
