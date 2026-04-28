import XCTest
@testable import LungfishWorkflow

final class ViralReconPrimerStagerTests: XCTestCase {
    func testPrimerStagerDerivesPrimerFastaWhenBundleHasOnlyBed() throws {
        let tempDirectory = try ViralReconWorkflowTestFixtures.makeTempDirectory()
        let fixtureReferenceFASTA = try ViralReconWorkflowTestFixtures.writeReferenceFASTA(in: tempDirectory)
        let fixturePrimerBundleWithoutFasta = try ViralReconWorkflowTestFixtures.writePrimerBundleWithoutFasta(in: tempDirectory)

        let staged = try ViralReconPrimerStager.stage(
            primerBundleURL: fixturePrimerBundleWithoutFasta,
            referenceFASTAURL: fixtureReferenceFASTA,
            referenceName: "MN908947.3",
            destinationDirectory: tempDirectory
        )

        XCTAssertTrue(staged.derivedFasta)
        XCTAssertTrue(FileManager.default.fileExists(atPath: staged.fastaURL.path))
        XCTAssertTrue(try String(contentsOf: staged.fastaURL, encoding: .utf8).contains(">"))
    }
}
