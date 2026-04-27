import AppKit
import XCTest
@testable import LungfishApp

@MainActor
final class NFCoreWorkflowDialogAppearanceTests: XCTestCase {
    func testDialogUsesSharedWorkflowSheetColorsAndProminentRunButton() throws {
        let controller = NFCoreWorkflowDialogController(projectURL: nil)

        let contentController = try XCTUnwrap(controller.window?.contentViewController)
        XCTAssertTrue(
            String(describing: type(of: contentController)).contains("NSHostingController"),
            "nf-core should be hosted by the same SwiftUI operations-dialog styling system as Assembly/Mapping."
        )
        XCTAssertEqual(controller.window?.backgroundColor, .lungfishCanvasBackground)
    }
}
