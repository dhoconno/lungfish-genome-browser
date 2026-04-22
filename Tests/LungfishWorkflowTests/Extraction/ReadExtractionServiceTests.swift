import XCTest
@testable import LungfishWorkflow
import LungfishCore

final class ReadExtractionServiceTests: XCTestCase {
    func testSamtoolsRegionsMergeAdjacentBlocksAndUseOneBasedInclusiveCoordinates() throws {
        let annotation = SequenceAnnotation(
            type: .gene,
            name: "orf1ab",
            chromosome: "chr1",
            intervals: [
                AnnotationInterval(start: 100, end: 120),
                AnnotationInterval(start: 120, end: 130),
                AnnotationInterval(start: 200, end: 210),
                AnnotationInterval(start: 205, end: 220)
            ]
        )

        XCTAssertEqual(
            ReadExtractionService.samtoolsRegions(for: annotation),
            ["chr1:101-130", "chr1:201-220"]
        )
    }

    func testSamtoolsRegionsReturnEmptyWhenChromosomeIsMissing() throws {
        let annotation = SequenceAnnotation(
            type: .gene,
            name: "orf1ab",
            intervals: [AnnotationInterval(start: 100, end: 130)]
        )

        XCTAssertTrue(ReadExtractionService.samtoolsRegions(for: annotation).isEmpty)
    }
}
