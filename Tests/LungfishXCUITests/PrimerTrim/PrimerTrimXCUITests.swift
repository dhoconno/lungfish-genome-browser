// PrimerTrimXCUITests.swift - Inspector surfaces the Primer-trim BAM button and opens the dialog
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest

/// Exercises the primer-trim Inspector button against a sarscov2 mapped bundle
/// fixture. The test:
///
/// 1. Launches the app with a pre-built mapped bundle project.
/// 2. Asserts the "Primer-trim BAM…" button is present in the Inspector.
/// 3. Clicks it and confirms the dialog opens.
/// 4. Confirms the built-in QIAseq scheme row is selectable and the Run button is enabled.
///
/// Skipped pending a `makePrimerTrimBundleProject` fixture builder under
/// ``LungfishProjectFixtureBuilder``. The plan (Task 18) specifies the two
/// XCUI fixture project snapshots should live at
/// `Tests/Fixtures/xcui/sarscov2-mapped-bundle/` and
/// `.../sarscov2-primer-trimmed-bundle/`; both need pre-computed alignment
/// bundles that this branch doesn't yet author. When those fixtures land, flip
/// the skip gate and the body below exercises the canonical flow.
final class PrimerTrimXCUITests: XCTestCase {
    @MainActor
    func testInspectorExposesPrimerTrimButtonAndOpensDialog() throws {
        throw XCTSkip(
            "Pending: LungfishProjectFixtureBuilder.makeMappedBundleProject(..) and the corresponding Tests/Fixtures/xcui/sarscov2-mapped-bundle/ snapshot. Unblock by landing those fixtures, then remove this skip and ensure accessibility identifiers (or stable labels) are wired to the Primer-trim BAM button and dialog controls."
        )

        // Reference implementation preserved so the eventual fixture author knows
        // what the happy path looks like when they unblock the test.
        //
        // let projectURL = try LungfishProjectFixtureBuilder.makeMappedBundleProject(
        //     named: "PrimerTrimXCUIFixture"
        // )
        // let app = XCUIApplication()
        // app.launchArguments = LungfishUITestLaunchOptions.launchArguments(openingProject: projectURL)
        // app.launch()
        // defer {
        //     app.terminate()
        //     try? FileManager.default.removeItem(at: projectURL.deletingLastPathComponent())
        // }
        //
        // let primerTrimButton = app.buttons["Primer-trim BAM…"]
        // XCTAssertTrue(primerTrimButton.waitForExistence(timeout: 10),
        //               "Inspector must surface the Primer-trim BAM button.")
        // primerTrimButton.click()
        //
        // XCTAssertTrue(
        //     app.windows.containing(
        //         NSPredicate(format: "title == %@", "Primer-trim BAM")
        //     ).firstMatch.waitForExistence(timeout: 5),
        //     "Clicking the button must open the primer-trim dialog."
        // )
        //
        // let schemeRow = app.buttons["QIAseq Direct SARS-CoV-2 with Booster A"]
        // XCTAssertTrue(schemeRow.waitForExistence(timeout: 5),
        //               "Shipped QIAseq scheme must appear in the picker.")
        // schemeRow.click()
        //
        // let runButton = app.buttons["Run"]
        // XCTAssertTrue(runButton.isEnabled,
        //               "Run button must enable once a scheme is selected.")
    }
}
