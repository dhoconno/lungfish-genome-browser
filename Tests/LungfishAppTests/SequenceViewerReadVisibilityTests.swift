import AppKit
import XCTest
@testable import LungfishApp
@testable import LungfishCore

@MainActor
final class SequenceViewerReadVisibilityTests: XCTestCase {

    func testEnteringCoverageTierClearsReadCachesAndInvalidatesOutstandingFetches() {
        let view = SequenceViewerView(frame: NSRect(x: 0, y: 0, width: 800, height: 400))
        let hoveredRead = makeAlignedRead(name: "hovered")
        let selectedRead = makeAlignedRead(name: "selected")
        view.testSetCachedAlignedReads([hoveredRead, selectedRead])
        view.testSetCachedPackedReads([(0, selectedRead)])
        view.testSetLastRenderedReadTier(.packed)
        view.testSetHoveredRead(hoveredRead)
        view.testSetSelectedReadIDs([selectedRead.id])
        view.testShowHoverTooltip(text: "Read tooltip")
        let originalGeneration = view.testReadFetchGeneration

        let tier = view.testApplyReadViewportPolicy(scale: 3.0)

        XCTAssertEqual(tier, .coverage)
        XCTAssertTrue(view.testCachedAlignedReads.isEmpty)
        XCTAssertTrue(view.testCachedPackedReads.isEmpty)
        XCTAssertNil(view.testHoveredRead)
        XCTAssertTrue(view.testSelectedReadIDs.isEmpty)
        XCTAssertTrue(view.testIsHoverTooltipHidden)
        XCTAssertEqual(view.testHoverTooltipText, "")
        XCTAssertNil(view.testSelectionStatusText)
        XCTAssertEqual(view.testReadFetchGeneration, originalGeneration + 1)
    }

    func testRemainingInCoverageTierDoesNotReinvalidateReadState() {
        let view = SequenceViewerView(frame: NSRect(x: 0, y: 0, width: 800, height: 400))
        view.testSetLastRenderedReadTier(.coverage)
        let originalGeneration = view.testReadFetchGeneration

        let tier = view.testApplyReadViewportPolicy(scale: 3.0)

        XCTAssertEqual(tier, .coverage)
        XCTAssertEqual(view.testReadFetchGeneration, originalGeneration)
    }

    func testLeavingBaseVisibleScaleClearsConsensusCache() {
        let view = SequenceViewerView(frame: NSRect(x: 0, y: 0, width: 800, height: 400))
        view.cachedConsensusRegion = GenomicRegion(chromosome: "chr1", start: 100, end: 200)

        let tier = view.testApplyReadViewportPolicy(
            scale: AppSettings.shared.showLettersThresholdBpPerPixel + 1
        )

        XCTAssertEqual(tier, .coverage)
        XCTAssertNil(view.cachedConsensusRegion)
    }

    func testBaseVisibleScalePreservesConsensusCache() {
        let view = SequenceViewerView(frame: NSRect(x: 0, y: 0, width: 800, height: 400))
        view.cachedConsensusRegion = GenomicRegion(chromosome: "chr1", start: 100, end: 200)
        view.testSetLastRenderedReadTier(.coverage)

        let tier = view.testApplyReadViewportPolicy(
            scale: max(0.1, AppSettings.shared.showLettersThresholdBpPerPixel - 1)
        )

        XCTAssertEqual(tier, .coverage)
        XCTAssertEqual(view.cachedConsensusRegion?.chromosome, "chr1")
        XCTAssertEqual(view.cachedConsensusRegion?.start, 100)
        XCTAssertEqual(view.cachedConsensusRegion?.end, 200)
    }

    private func makeAlignedRead(name: String) -> AlignedRead {
        AlignedRead(
            name: name,
            flag: 0,
            chromosome: "chr1",
            position: 10,
            mapq: 60,
            cigar: [CIGAROperation(op: .match, length: 20)],
            sequence: "AAAAAAAAAAAAAAAAAAAA",
            qualities: Array(repeating: 30, count: 20)
        )
    }
}
