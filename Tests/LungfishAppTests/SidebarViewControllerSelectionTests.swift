import XCTest
@testable import LungfishApp
import LungfishIO

@MainActor
final class SidebarViewControllerSelectionTests: XCTestCase {
    func testSelectItemFindsAnalysisWhenCallerUsesSymlinkedPath() throws {
        let tempRoot = FileManager.default.temporaryDirectory
            .appendingPathComponent("SidebarSelection-\(UUID().uuidString)", isDirectory: true)
        let projectURL = tempRoot.appendingPathComponent("Fixture.lungfish", isDirectory: true)
        let aliasURL = tempRoot.appendingPathComponent("Fixture-alias.lungfish", isDirectory: false)

        try FileManager.default.createDirectory(at: projectURL, withIntermediateDirectories: true)
        let analysisURL = try AnalysesFolder.createAnalysisDirectory(
            tool: "skesa",
            in: projectURL,
            date: Date(timeIntervalSince1970: 1_715_000_000)
        )
        try FileManager.default.createSymbolicLink(at: aliasURL, withDestinationURL: projectURL)

        let sidebar = SidebarViewController()
        sidebar.loadViewIfNeeded()

        defer {
            sidebar.closeProject()
            try? FileManager.default.removeItem(at: tempRoot)
        }

        sidebar.openProject(at: projectURL)

        let symlinkedAnalysisURL = aliasURL
            .appendingPathComponent("Analyses", isDirectory: true)
            .appendingPathComponent(analysisURL.lastPathComponent, isDirectory: true)

        XCTAssertTrue(sidebar.selectItem(forURL: symlinkedAnalysisURL))
        XCTAssertEqual(
            sidebar.selectedFileURL?.resolvingSymlinksInPath(),
            analysisURL.resolvingSymlinksInPath()
        )
    }
}
