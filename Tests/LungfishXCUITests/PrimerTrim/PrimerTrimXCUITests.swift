// PrimerTrimXCUITests.swift - Inspector surfaces the Primer-trim BAM button and runs the dialog
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest

/// Exercises the primer-trim Inspector button against a sarscov2 mapped bundle
/// fixture. The first test asserts the dialog opens and exposes the project-
/// local scheme; the second exercises the full Run path and waits for the
/// new primer-trimmed alignment track to appear in the sidebar.
final class PrimerTrimXCUITests: XCTestCase {
    @MainActor
    func testInspectorExposesPrimerTrimButtonAndOpensDialog() throws {
        let projectURL = try LungfishProjectFixtureBuilder.makeMappedBundleProject(
            named: "PrimerTrimXCUIFixture"
        )
        let robot = BundleBrowserRobot()
        defer {
            robot.app.terminate()
            try? FileManager.default.removeItem(at: projectURL.deletingLastPathComponent())
        }

        robot.launch(opening: projectURL)
        robot.openBundle(named: "Sample.lungfishref")
        robot.selectInspectorTab(named: "Analysis")
        robot.selectInspectorTab(named: "Primer Trim")

        let primerTrimButton = robot.app.buttons["Primer-trim BAM…"]
        XCTAssertTrue(
            primerTrimButton.waitForExistence(timeout: 10),
            "Inspector must surface the Primer-trim BAM button"
        )
        primerTrimButton.click()

        // The mt192765-integration scheme should appear in the picker.
        let schemeRow = robot.app.staticTexts["mt192765-integration"]
        XCTAssertTrue(
            schemeRow.waitForExistence(timeout: 5),
            "Clicking the button must open the primer-trim dialog with the project-local scheme in the picker"
        )
    }

    @MainActor
    func testRunButtonProducesNewAlignmentTrack() throws {
        let projectURL = try LungfishProjectFixtureBuilder.makeMappedBundleProject(
            named: "PrimerTrimRunFixture"
        )
        let robot = BundleBrowserRobot()
        defer {
            robot.app.terminate()
            try? FileManager.default.removeItem(at: projectURL.deletingLastPathComponent())
        }

        robot.launch(opening: projectURL)
        robot.openBundle(named: "Sample.lungfishref")
        robot.selectInspectorTab(named: "Analysis")
        robot.selectInspectorTab(named: "Primer Trim")

        let primerTrimButton = robot.app.buttons["Primer-trim BAM…"]
        XCTAssertTrue(primerTrimButton.waitForExistence(timeout: 10))
        primerTrimButton.click()

        let schemeRow = robot.app.staticTexts["mt192765-integration"]
        XCTAssertTrue(schemeRow.waitForExistence(timeout: 5))
        let schemeButton = robot.app.buttons["primer-scheme-mt192765-integration"]
        XCTAssertTrue(schemeButton.waitForExistence(timeout: 5))
        schemeButton.click()

        let runButton = robot.app.buttons["Run"]
        XCTAssertTrue(runButton.waitForExistence(timeout: 5))
        XCTAssertTrue(runButton.isEnabled)
        runButton.click()

        XCTAssertTrue(
            waitForPrimerTrimmedAlignment(in: projectURL, timeout: 120),
            "The GUI run must append a primer-trimmed alignment track with real BAM/BAI artifacts."
        )
    }

    private func waitForPrimerTrimmedAlignment(
        in projectURL: URL,
        timeout: TimeInterval
    ) -> Bool {
        let bundleURL = projectURL.appendingPathComponent("Sample.lungfishref", isDirectory: true)
        let manifestURL = bundleURL.appendingPathComponent("manifest.json")
        let deadline = Date().addingTimeInterval(timeout)

        while Date() < deadline {
            if primerTrimmedAlignmentExists(bundleURL: bundleURL, manifestURL: manifestURL) {
                return true
            }
            RunLoop.current.run(until: Date().addingTimeInterval(1))
        }
        return false
    }

    private func primerTrimmedAlignmentExists(bundleURL: URL, manifestURL: URL) -> Bool {
        guard let data = try? Data(contentsOf: manifestURL),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let alignments = json["alignments"] as? [[String: Any]] else {
            return false
        }

        for alignment in alignments {
            guard let name = alignment["name"] as? String,
                  name.contains("Primer-trimmed"),
                  let sourcePath = alignment["source_path"] as? String,
                  let indexPath = alignment["index_path"] as? String else {
                continue
            }

            let bamURL = bundleURL.appendingPathComponent(sourcePath)
            let indexURL = bundleURL.appendingPathComponent(indexPath)
            let provenanceURL = bamURL
                .deletingPathExtension()
                .appendingPathExtension("primer-trim-provenance.json")

            if FileManager.default.fileExists(atPath: bamURL.path),
               FileManager.default.fileExists(atPath: indexURL.path),
               FileManager.default.fileExists(atPath: provenanceURL.path) {
                return true
            }
        }

        return false
    }
}
