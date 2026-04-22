import XCTest
@testable import LungfishApp
@testable import LungfishWorkflow

@MainActor
final class MappingResultViewControllerTests: XCTestCase {
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: MappingPanelLayout.defaultsKey)
        super.tearDown()
    }

    func testViewportUsesClassifierStyleColumnsAndDefaultMappedReadSort() {
        let vc = MappingResultViewController()
        _ = vc.view
        vc.configureForTesting(result: makeMappingResult())

        XCTAssertEqual(
            vc.testContigTableView.testTableView.tableColumns.map(\.title),
            ["Contig", "Length", "Mapped Reads", "% Mapped", "Mean Depth", "Coverage Breadth", "Median MAPQ", "Mean Identity"]
        )
        XCTAssertEqual(vc.testContigTableView.record(at: 0)?.contigName, "beta")
    }

    func testTableSupportsTextAndNumericFilters() {
        let table = MappingContigTableView()
        table.configure(rows: makeContigs())

        table.applyTestFilter(columnID: "contig", op: .contains, value: "alp")
        XCTAssertEqual(table.displayedRows.map(\.contigName), ["alpha"])

        table.clearTestFilters()
        table.applyTestFilter(columnID: "reads", op: .greaterOrEqual, value: "150")
        XCTAssertEqual(table.displayedRows.map(\.contigName), ["beta"])
    }

    func testTextAndNumericColumnsUseClassifierFonts() {
        let table = MappingContigTableView()
        let row = makeContigs()[0]

        let textCell = table.cellContent(for: NSUserInterfaceItemIdentifier("contig"), row: row)
        let numericCell = table.cellContent(for: NSUserInterfaceItemIdentifier("reads"), row: row)

        XCTAssertEqual(textCell.font, .systemFont(ofSize: 12))
        XCTAssertEqual(
            numericCell.font,
            .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        )
    }

    func testViewportShowsExplicitPlaceholderWhenViewerBundleIsMissing() {
        let vc = MappingResultViewController()
        _ = vc.view

        vc.configureForTesting(result: makeMappingResult(viewerBundleURL: nil))

        XCTAssertEqual(
            vc.testDetailPlaceholderMessage,
            "Reference bundle viewer unavailable for this mapping result."
        )
    }

    func testEmbeddedViewerDoesNotPublishGlobalViewportNotifications() {
        let vc = MappingResultViewController()
        _ = vc.view

        XCTAssertFalse(vc.testEmbeddedViewerPublishesGlobalViewportNotifications)
    }

    private func makeMappingResult(viewerBundleURL: URL? = nil) -> MappingResult {
        MappingResult(
            mapper: .minimap2,
            modeID: MappingMode.defaultShortRead.id,
            sourceReferenceBundleURL: nil,
            viewerBundleURL: viewerBundleURL,
            bamURL: URL(fileURLWithPath: "/tmp/example.sorted.bam"),
            baiURL: URL(fileURLWithPath: "/tmp/example.sorted.bam.bai"),
            totalReads: 200,
            mappedReads: 198,
            unmappedReads: 2,
            wallClockSeconds: 1.5,
            contigs: makeContigs()
        )
    }

    private func makeContigs() -> [MappingContigSummary] {
        [
            MappingContigSummary(
                contigName: "alpha",
                contigLength: 29_903,
                mappedReads: 42,
                mappedReadPercent: 21.0,
                meanDepth: 2.4,
                coverageBreadth: 8.0,
                medianMAPQ: 32.0,
                meanIdentity: 98.5
            ),
            MappingContigSummary(
                contigName: "beta",
                contigLength: 29_903,
                mappedReads: 197,
                mappedReadPercent: 98.5,
                meanDepth: 9.1,
                coverageBreadth: 96.2,
                medianMAPQ: 60.0,
                meanIdentity: 99.7
            ),
        ]
    }
}
