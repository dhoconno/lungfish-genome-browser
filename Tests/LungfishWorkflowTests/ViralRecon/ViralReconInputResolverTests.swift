import XCTest
@testable import LungfishWorkflow

final class ViralReconInputResolverTests: XCTestCase {
    func testResolverRejectsMixedIlluminaAndNanoporeSelections() throws {
        let illumina = ViralReconResolvedInput(
            bundleURL: URL(fileURLWithPath: "/tmp/I.lungfishfastq"),
            sampleName: "I",
            fastqURLs: [URL(fileURLWithPath: "/tmp/I_R1.fastq.gz")],
            platform: .illumina,
            barcode: nil,
            sequencingSummaryURL: nil
        )
        let nanopore = ViralReconResolvedInput(
            bundleURL: URL(fileURLWithPath: "/tmp/N.lungfishfastq"),
            sampleName: "N",
            fastqURLs: [URL(fileURLWithPath: "/tmp/N.fastq")],
            platform: .nanopore,
            barcode: "01",
            sequencingSummaryURL: nil
        )

        XCTAssertThrowsError(try ViralReconInputResolver.makeSamples(from: [illumina, nanopore])) { error in
            XCTAssertEqual(error as? ViralReconInputResolver.ResolveError, .mixedPlatforms)
        }
    }
}
