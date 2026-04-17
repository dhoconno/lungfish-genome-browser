import AppKit
import XCTest
@testable import LungfishApp

@MainActor
final class ImportCenterMenuTests: XCTestCase {

    func testFileMenuImportSubmenuContainsOnlyImportCenter() throws {
        let _ = NSApplication.shared
        let mainMenu = MainMenu.createMainMenu()
        let fileMenu = try XCTUnwrap(mainMenu.items.first(where: { $0.title == "File" })?.submenu)
        XCTAssertNil(fileMenu.items.first(where: { $0.title == "Import" }))
        XCTAssertNotNil(fileMenu.items.first(where: { $0.title == "Import Center…" }))
    }

    func testApplicationMenuContainsQuitItem() throws {
        let _ = NSApplication.shared
        let mainMenu = MainMenu.createMainMenu()
        let appMenu = try XCTUnwrap(mainMenu.items.first?.submenu)
        XCTAssertNotNil(appMenu.items.first(where: { $0.title == "Quit Lungfish Genome Explorer" }))
    }

    func testImportCenterCatalogUsesExplicitImportCategoriesInsteadOfProjectFiles() {
        let viewModel = ImportCenterViewModel()
        let ids = Set(viewModel.allCards.map(\.id))

        XCTAssertTrue(ids.contains("fastq"))
        XCTAssertTrue(ids.contains("ont-run"))
        XCTAssertTrue(ids.contains("bam-cram"))
        XCTAssertTrue(ids.contains("vcf"))
        XCTAssertTrue(ids.contains("kraken2"))
        XCTAssertTrue(ids.contains("esviritu"))
        XCTAssertTrue(ids.contains("taxtriage"))
        XCTAssertTrue(ids.contains("nvd"))
        XCTAssertTrue(ids.contains("fasta"))
        XCTAssertFalse(ids.contains("project-files"))
        XCTAssertFalse(ids.contains("bundle-sample-metadata"))
        XCTAssertFalse(ids.contains("project-sample-metadata"))
    }

    func testImportCenterOmitsDeferredMetadataSection() {
        XCTAssertFalse(ImportCenterViewModel.Tab.allCases.map(\.title).contains("Metadata"))
    }

    func testDeferredImportCenterTodoMentionsDatasetLevelMetadataRequirements() throws {
        let todo = try String(
            contentsOf: URL(fileURLWithPath: #filePath)
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .appendingPathComponent("docs/TODO.md"),
            encoding: .utf8
        )

        XCTAssertTrue(todo.contains("Import Center dataset-level metadata import"))
        XCTAssertTrue(todo.contains("Support both CSV and TSV"))
        XCTAssertTrue(todo.contains("Choose which dataset in the current project receives the metadata file"))
        XCTAssertTrue(todo.contains("Preview and matching UI"))
    }
}
