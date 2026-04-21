import Foundation
import XCTest

@MainActor
final class AssemblyViewportConcurrencyTests: XCTestCase {
    func testAssemblyViewportCancelsStaleSelectionLoadsBeforeDisplay() throws {
        let source = try loadSource(at: "Sources/LungfishApp/Views/MainWindow/MainSplitViewController.swift")

        XCTAssertTrue(source.contains("cancelFASTQLoadIfNeeded(hideProgress: true, reason: \"display assembly analysis\")"))
        XCTAssertTrue(source.contains("cancelMultiDocumentLoadIfNeeded(hideProgress: true, reason: \"display assembly analysis\")"))
    }

    func testMultiSelectionLoadsDiscardStaleResultsBeforeDisplayingCollection() throws {
        let source = try loadSource(at: "Sources/LungfishApp/Views/MainWindow/MainSplitViewController.swift")

        XCTAssertTrue(source.contains("let generation = selectionGeneration"))
        XCTAssertTrue(source.contains("self.selectionGeneration == generation"))
        XCTAssertTrue(source.contains("Discarding stale multi-select load before collection display"))
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
