import Foundation
import XCTest

@MainActor
final class MappingViewportRoutingTests: XCTestCase {
    func testMainSplitRoutesAllReadMappersThroughMappingViewport() throws {
        let source = try loadSource(at: "Sources/LungfishApp/Views/MainWindow/MainSplitViewController.swift")

        XCTAssertTrue(source.contains("displayMappingAnalysisFromSidebar(at: url)"))
        XCTAssertTrue(source.contains("toolId == MappingTool.minimap2.rawValue"))
        XCTAssertTrue(source.contains("toolId == MappingTool.bwaMem2.rawValue"))
        XCTAssertTrue(source.contains("toolId == MappingTool.bowtie2.rawValue"))
        XCTAssertTrue(source.contains("toolId == MappingTool.bbmap.rawValue"))
    }

    func testViewerUsesDedicatedMappingViewportExtension() throws {
        let source = try loadSource(at: "Sources/LungfishApp/Views/Viewer/ViewerViewController+Mapping.swift")

        XCTAssertTrue(source.contains("displayMappingResult(_ result: MappingResult)"))
        XCTAssertTrue(source.contains("MappingResultViewController()"))
        XCTAssertTrue(source.contains("contentMode = .mapping"))
        XCTAssertTrue(source.contains("hideMappingView()"))
    }

    func testBundleOpenPathsUseExplicitBrowseAndSequenceModes() throws {
        let viewerSource = try loadSource(at: "Sources/LungfishApp/Views/Viewer/ViewerViewController+BundleDisplay.swift")
        let mainWindowSource = try loadSource(at: "Sources/LungfishApp/Views/MainWindow/MainSplitViewController.swift")
        let mappingSource = try loadSource(at: "Sources/LungfishApp/Views/Results/Mapping/MappingResultViewController.swift")

        XCTAssertTrue(viewerSource.contains("public func displayBundle(at url: URL) throws"))
        XCTAssertTrue(viewerSource.contains("try displayBundle(at: url, mode: .browse)"))
        XCTAssertTrue(mainWindowSource.contains("displayBundle(at: url, mode: .browse)"))
        XCTAssertTrue(mainWindowSource.contains("viewerController.bundleBrowserController != nil"))
        XCTAssertTrue(mappingSource.contains("mode: .sequence(name: sequenceName, restoreViewState: false)"))
        XCTAssertFalse(mappingSource.contains("try embeddedViewerController.displayBundle(at: standardized)"))
    }

    func testBundleBackNavigationButtonUsesStableAccessibilityIdentifier() throws {
        let viewerSource = try loadSource(at: "Sources/LungfishApp/Views/Viewer/ViewerViewController.swift")

        XCTAssertTrue(viewerSource.contains("viewer-back-navigation-button"))
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
