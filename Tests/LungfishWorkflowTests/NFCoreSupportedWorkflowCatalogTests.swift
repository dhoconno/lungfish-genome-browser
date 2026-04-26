import XCTest
@testable import LungfishWorkflow

final class NFCoreSupportedWorkflowCatalogTests: XCTestCase {
    func testFirstWaveWorkflowsAreCuratedAsEasyAndGenericAdapterCompatible() {
        let expectedNames = [
            "fetchngs",
            "bamtofastq",
            "fastqrepair",
            "seqinspector",
            "references",
            "nanoseq",
            "viralrecon",
            "vipr",
        ]

        XCTAssertEqual(NFCoreSupportedWorkflowCatalog.firstWave.map(\.name), expectedNames)

        for workflow in NFCoreSupportedWorkflowCatalog.firstWave {
            XCTAssertEqual(workflow.difficulty, .easy, "\(workflow.fullName) should be first-wave easy")
            XCTAssertFalse(workflow.resultSurfaces.isEmpty, "\(workflow.fullName) should declare result surfaces")
            XCTAssertTrue(
                workflow.supportedAdapterIDs.contains("generic-report"),
                "\(workflow.fullName) should always support the generic report adapter"
            )
        }
    }

    func testCatalogKeepsCustomInterfaceWorkflowsRepresentableForFutureAdapters() {
        let scrnaseq = NFCoreSupportedWorkflowCatalog.workflow(named: "scrnaseq")

        XCTAssertEqual(scrnaseq?.difficulty, .hard)
        XCTAssertEqual(scrnaseq?.resultSurfaces, [.singleCell])
        XCTAssertEqual(scrnaseq?.supportedAdapterIDs, ["generic-report"])
    }

    func testWorkflowLookupAcceptsFullNFCoreNames() {
        let workflow = NFCoreSupportedWorkflowCatalog.workflow(named: "nf-core/viralrecon")

        XCTAssertEqual(workflow?.name, "viralrecon")
        XCTAssertEqual(workflow?.fullName, "nf-core/viralrecon")
        XCTAssertTrue(workflow?.resultSurfaces.contains(.variantTracks) == true)
    }
}
