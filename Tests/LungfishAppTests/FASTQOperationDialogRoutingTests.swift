import XCTest
@testable import LungfishApp

@MainActor
final class FASTQOperationDialogRoutingTests: XCTestCase {
    func testClassificationToolsUseFixedBatchOutputModeAndHideOutputStrategyPicker() {
        let state = FASTQOperationDialogState(
            initialCategory: .classification,
            selectedInputURLs: [URL(fileURLWithPath: "/tmp/sample.lungfishfastq")]
        )

        for toolID in [FASTQOperationToolID.kraken2, .esViritu, .taxTriage] {
            state.selectTool(toolID)

            XCTAssertEqual(state.outputMode, .fixedBatch, "\(toolID.rawValue) should force fixedBatch output mode")
            XCTAssertFalse(state.showsOutputStrategyPicker, "\(toolID.rawValue) should hide the output strategy picker")
        }
    }

    func testMappingDefaultsToPerInputOutputModeAndRequiresReferenceSelection() {
        let state = FASTQOperationDialogState(
            initialCategory: .mapping,
            selectedInputURLs: [URL(fileURLWithPath: "/tmp/sample.lungfishfastq")]
        )

        state.selectTool(.minimap2)

        XCTAssertEqual(state.outputMode, .perInput)
        XCTAssertTrue(state.showsOutputStrategyPicker)
        XCTAssertTrue(state.requiredInputKinds.contains(.referenceSequence))
    }

    func testAssemblyCategorySeedsSpadesAsDefaultTool() {
        let state = FASTQOperationDialogState(
            initialCategory: .assembly,
            selectedInputURLs: [URL(fileURLWithPath: "/tmp/sample.lungfishfastq")]
        )

        XCTAssertEqual(state.selectedToolID, .spades)
    }
}
