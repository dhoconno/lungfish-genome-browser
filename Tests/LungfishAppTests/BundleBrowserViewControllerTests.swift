import XCTest
@testable import LungfishApp
@testable import LungfishCore

@MainActor
final class BundleBrowserViewControllerTests: XCTestCase {
    func testConfigureSelectsFirstRowAndShowsDetail() {
        let vc = BundleBrowserViewController()
        _ = vc.view

        vc.configure(summary: makeSummary())

        XCTAssertEqual(vc.testDisplayedNames, ["chr1", "chrM"])
        XCTAssertEqual(vc.testSelectedName, "chr1")
        XCTAssertEqual(vc.testDetailLengthText, "200 bp")
    }

    func testFilterMatchesAliasAndDescription() {
        let vc = BundleBrowserViewController()
        _ = vc.view

        vc.configure(summary: makeSummary())
        vc.testSetFilterText("mitochondrion")
        XCTAssertEqual(vc.testDisplayedNames, ["chrM"])

        vc.testSetFilterText("  MT  ")
        XCTAssertEqual(vc.testDisplayedNames, ["chrM"])
    }

    func testOpenCallbackUsesSelectedRow() {
        let vc = BundleBrowserViewController()
        _ = vc.view
        var opened: String?
        vc.onOpenSequence = { opened = $0.name }
        vc.configure(summary: makeSummary())

        vc.testSelectRow(named: "chrM")
        vc.testInvokeOpen()

        XCTAssertEqual(opened, "chrM")
    }

    func testNoSelectionStateDisablesOpenAfterFilterRemovesAllRows() {
        let vc = BundleBrowserViewController()
        _ = vc.view

        vc.configure(summary: makeSummary())
        vc.testSetFilterText("no matches")
        vc.testInvokeOpen()

        XCTAssertNil(vc.testSelectedName)
        XCTAssertEqual(vc.testDetailLengthText, "")
        XCTAssertFalse(vc.testOpenButtonEnabled)
    }

    func testCaptureStateRestoresFilterSelectionAndScrollPosition() {
        let vc = BundleBrowserViewController()
        _ = vc.view
        vc.configure(summary: makeScrollableSummary())
        vc.view.layoutSubtreeIfNeeded()

        vc.testSetFilterText("chr")
        vc.testSelectRow(named: "chr18")
        vc.testSetScrollOriginY(44)

        let captured = vc.captureState()

        let restored = BundleBrowserViewController()
        _ = restored.view
        restored.configure(summary: makeScrollableSummary(), restoredState: captured)

        XCTAssertEqual(restored.testFilterText, "chr")
        XCTAssertEqual(restored.testSelectedName, "chr18")
        XCTAssertEqual(restored.testScrollOriginY, 44, accuracy: 0.5)
    }

    func testCaptureStateClearsSelectedSequenceWhenFilterHasNoMatches() {
        let vc = BundleBrowserViewController()
        _ = vc.view
        vc.configure(summary: makeSummary())

        vc.testSelectRow(named: "chrM")
        vc.testSetFilterText("no matches")

        let captured = vc.captureState()

        XCTAssertEqual(captured.filterText, "no matches")
        XCTAssertNil(captured.selectedSequenceName)
    }

    private func makeSummary() -> BundleBrowserSummary {
        BundleBrowserSummary(
            schemaVersion: 1,
            aggregate: .init(
                annotationTrackCount: 1,
                variantTrackCount: 0,
                alignmentTrackCount: 1,
                totalMappedReads: 300
            ),
            sequences: [
                BundleBrowserSequenceSummary(
                    name: "chr1",
                    displayDescription: "primary contig",
                    length: 200,
                    aliases: ["1"],
                    isPrimary: true,
                    isMitochondrial: false,
                    metrics: .init(
                        mappedReads: 220,
                        mappedPercent: 73.3,
                        meanDepth: 11.2,
                        coverageBreadth: 97.1,
                        medianMAPQ: 60.0,
                        meanIdentity: 99.1
                    )
                ),
                BundleBrowserSequenceSummary(
                    name: "chrM",
                    displayDescription: "mitochondrion",
                    length: 80,
                    aliases: ["MT"],
                    isPrimary: false,
                    isMitochondrial: true,
                    metrics: .init(
                        mappedReads: 80,
                        mappedPercent: 26.7,
                        meanDepth: 42.0,
                        coverageBreadth: 100.0,
                        medianMAPQ: 60.0,
                        meanIdentity: 99.9
                    )
                )
            ]
        )
    }

    private func makeScrollableSummary() -> BundleBrowserSummary {
        BundleBrowserSummary(
            schemaVersion: 1,
            aggregate: .init(
                annotationTrackCount: 1,
                variantTrackCount: 0,
                alignmentTrackCount: 1,
                totalMappedReads: 300
            ),
            sequences: (1...40).map { index in
                BundleBrowserSequenceSummary(
                    name: "chr\(index)",
                    displayDescription: "contig \(index)",
                    length: Int64(index) * 100,
                    aliases: ["\(index)"],
                    isPrimary: true,
                    isMitochondrial: false,
                    metrics: nil
                )
            }
        )
    }
}
