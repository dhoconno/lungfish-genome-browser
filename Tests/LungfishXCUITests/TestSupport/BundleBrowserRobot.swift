import XCTest

@MainActor
struct BundleBrowserRobot {
    let app: XCUIApplication

    init(app: XCUIApplication = XCUIApplication()) {
        self.app = app
    }

    func launch(
        opening projectURL: URL,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        var options = LungfishUITestLaunchOptions(
            projectPath: projectURL,
            fixtureRootPath: LungfishFixtureCatalog.fixturesRoot
        )
        options.apply(to: app)
        app.launchEnvironment["LUNGFISH_DEBUG_BYPASS_REQUIRED_SETUP"] = "1"
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 10), file: file, line: line)
    }

    func openBundle(
        named label: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let outline = app.outlines["sidebar-outline"]
        XCTAssertTrue(outline.waitForExistence(timeout: 10), file: file, line: line)
        let item = outline.staticTexts[label].firstMatch
        XCTAssertTrue(item.waitForExistence(timeout: 10), file: file, line: line)
        item.click()
    }

    func waitForBrowserLoaded(
        timeout: TimeInterval = 10,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertTrue(browserView.waitForExistence(timeout: timeout), file: file, line: line)
        XCTAssertTrue(browserTable.waitForExistence(timeout: timeout), file: file, line: line)
    }

    func waitForBrowserRow(
        named name: String,
        timeout: TimeInterval = 10,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        waitForBrowserLoaded(timeout: timeout, file: file, line: line)
        let row = browserTable.staticTexts[name].firstMatch
        XCTAssertTrue(row.waitForExistence(timeout: timeout), file: file, line: line)
    }

    func selectBrowserRow(
        named name: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        waitForBrowserLoaded(file: file, line: line)
        let row = browserTable.staticTexts[name].firstMatch
        XCTAssertTrue(row.waitForExistence(timeout: 10), file: file, line: line)
        row.click()
    }

    func openSelectedSequence(
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        waitForBrowserLoaded(file: file, line: line)
        XCTAssertTrue(openButton.waitForExistence(timeout: 10), file: file, line: line)
        XCTAssertTrue(openButton.isEnabled, file: file, line: line)
        openButton.click()
    }

    func waitForBackNavigationButton(
        timeout: TimeInterval = 10,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertTrue(backButton.waitForExistence(timeout: timeout), file: file, line: line)
    }

    func tapBackNavigation(
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        waitForBackNavigationButton(file: file, line: line)
        backButton.click()
    }

    func waitForSelectedBrowserRow(
        named name: String,
        timeout: TimeInterval = 10,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        waitForBrowserLoaded(timeout: timeout, file: file, line: line)
        let selectedRow = browserTable
            .descendants(matching: .any)
            .matching(NSPredicate(format: "selected == true"))
            .containing(NSPredicate(format: "label == %@", name))
            .firstMatch
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == true"),
            object: selectedRow
        )
        XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: timeout), .completed, file: file, line: line)
    }

    var browserView: XCUIElement {
        app.otherElements["bundle-browser-view"]
    }

    var browserTable: XCUIElement {
        app.tables["bundle-browser-table"]
    }

    var openButton: XCUIElement {
        app.buttons["bundle-browser-open-button"]
    }

    var backButton: XCUIElement {
        app.buttons["viewer-back-navigation-button"]
    }
}
