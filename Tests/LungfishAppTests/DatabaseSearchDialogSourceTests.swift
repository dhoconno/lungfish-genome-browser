import XCTest

final class DatabaseSearchDialogSourceTests: XCTestCase {
    func testDatabaseSearchDialogReusesSharedOperationsShell() throws {
        let source = try String(
            contentsOf: repositoryRoot()
                .appendingPathComponent("Sources/LungfishApp/Views/DatabaseBrowser/DatabaseSearchDialog.swift"),
            encoding: .utf8
        )

        XCTAssertTrue(source.contains("DatasetOperationsDialog("))
        XCTAssertTrue(source.contains("primaryActionTitle: state.primaryActionTitle"))
        XCTAssertTrue(source.contains("onRun: state.performPrimaryAction"))
        XCTAssertTrue(source.contains("switch state.selectedDestination"))
    }

    func testGenBankGenomesPaneExposesNCBIModePicker() throws {
        let source = try String(
            contentsOf: repositoryRoot()
                .appendingPathComponent("Sources/LungfishApp/Views/DatabaseBrowser/GenBankGenomesSearchPane.swift"),
            encoding: .utf8
        )

        XCTAssertTrue(source.contains(#"Picker("Mode", selection: $viewModel.ncbiSearchType)"#))
        XCTAssertTrue(source.contains("Nucleotide"))
        XCTAssertTrue(source.contains("Genome"))
        XCTAssertTrue(source.contains("Virus"))
    }

    func testSRARunsPaneImportsAccessionListsExplicitly() throws {
        let source = try String(
            contentsOf: repositoryRoot()
                .appendingPathComponent("Sources/LungfishApp/Views/DatabaseBrowser/SRARunsSearchPane.swift"),
            encoding: .utf8
        )

        XCTAssertTrue(source.contains(#"Button("Import Accessions")"#))
        XCTAssertTrue(source.contains("viewModel.importAccessionList()"))
    }

    func testSharedBrowserPaneUsesTextFirstSearchScaffold() throws {
        let source = try String(
            contentsOf: repositoryRoot()
                .appendingPathComponent("Sources/LungfishApp/Views/DatabaseBrowser/DatabaseBrowserPane.swift"),
            encoding: .utf8
        )

        XCTAssertTrue(source.contains("AppKitTextField"))
        XCTAssertTrue(source.contains(#"Button("Search")"#))
        XCTAssertTrue(source.contains("ProgressView"))
        XCTAssertTrue(source.contains("List"))
        XCTAssertTrue(source.contains("DatabaseSearchResultRow"))
    }

    func testPathoplexusPaneNotesTheTaskThreeScope() throws {
        let source = try String(
            contentsOf: repositoryRoot()
                .appendingPathComponent("Sources/LungfishApp/Views/DatabaseBrowser/PathoplexusSearchPane.swift"),
            encoding: .utf8
        )

        XCTAssertTrue(source.contains("consent-aware browsing"))
        XCTAssertTrue(source.contains("organism targeting"))
    }

    private func repositoryRoot() -> URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }
}
