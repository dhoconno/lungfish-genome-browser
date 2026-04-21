import XCTest
@testable import LungfishApp
import LungfishCore

@MainActor
final class InspectorAssemblyModeTests: XCTestCase {
    func testAssemblyModeUsesDocumentOnlyInspectorTabAndHeaderLabel() {
        let viewModel = InspectorViewModel()
        viewModel.contentMode = .assembly

        XCTAssertEqual(viewModel.availableTabs, [.document])
        XCTAssertEqual(viewModel.availableTabs.first?.displayLabel, "Document")
    }

    func testInspectorSingleTabHeaderUsesDocumentLabelSourcePath() throws {
        let source = try loadSource(at: "Sources/LungfishApp/Views/Inspector/InspectorViewController.swift")

        XCTAssertTrue(source.contains("case .document: return \"Document\""))
        XCTAssertTrue(source.contains("Text(single.displayLabel)"))
    }

    private func loadSource(at relativePath: String) throws -> String {
        let sourceURL = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent(relativePath)

        return try String(contentsOf: sourceURL, encoding: .utf8)
    }
}
