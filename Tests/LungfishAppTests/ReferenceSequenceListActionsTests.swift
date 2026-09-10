import AppKit
import XCTest
import LungfishCore
import LungfishKit
@testable import LungfishApp

@MainActor
final class ReferenceSequenceListActionsTests: XCTestCase {
    private func row(_ name: String) -> ReferenceBundleRecordRow {
        ReferenceBundleRecordRow(summary: .init(name: name, displayDescription: nil, length: 4, aliases: [], isPrimary: true, isMitochondrial: false, metrics: nil), values: [:])
    }

    func testAlleleDefaultKeepsCollapsedAliasesAndOptionalCanonicalName() {
        let table = ReferenceBundleRecordTable()
        table.displaysAlleles = true
        table.bundleDisplayName = "MCM reference"
        let name = "target_1|alleles=Mafa-A1_01:01,Mafa-A1_02:01|source_loci=MHC-A1"
        let record = row(name)
        table.configure(dynamicFields: [], rows: [record])
        XCTAssertEqual(table.tableView.tableColumn(withIdentifier: .init("sequence"))?.title, "Allele")
        XCTAssertEqual(table.cellContent(for: .init("sequence"), row: record).text, "Mafa-A1_01:01 / Mafa-A1_02:01")
        XCTAssertEqual(table.columnValue(for: "fullReferenceName", row: record), name)
        XCTAssertEqual(table.tableView.tableColumn(withIdentifier: .init("fullReferenceName"))?.isHidden, true)
        XCTAssertTrue(table.rowIdentity(for: record)?.contains(name) == true)
        table.tableView.tableColumn(withIdentifier: .init("fullReferenceName"))?.isHidden = false
        table.configure(dynamicFields: [], rows: [record])
        XCTAssertEqual(table.tableView.tableColumn(withIdentifier: .init("fullReferenceName"))?.isHidden, false)
    }

    func testContextSelectionAndExtractionUseCanonicalRecords() {
        _ = NSApplication.shared
        let table = ReferenceBundleRecordTable()
        table.displaysAlleles = true
        let rows = [row("a|alleles=Mafa-A1_01:01"), row("b|alleles=Mafa-B_02:01"), row("c|alleles=Mafa-E_03:01")]
        table.configure(dynamicFields: [], rows: rows)
        table.onCopySequences = { _, _ in }
        var extracted: [ReferenceBundleRecordRow] = []
        table.onExtractSequences = { extracted = $0 }
        table.tableView.selectRowIndexes(IndexSet([0, 1]), byExtendingSelection: false)
        let menu = table.sequenceActionMenu(clickedRow: 1)
        XCTAssertEqual(table.selectedSequenceRows.map(\.summary.name), Array(rows.prefix(2)).map(\.summary.name))
        XCTAssertTrue(menu.items.map(\.title).contains("Copy Names"))
        XCTAssertTrue(menu.items.map(\.title).contains("Copy Sequences"))
        let item = menu.items.first { $0.title == "Extract to New Bundle…" }!
        NSApp.sendAction(item.action!, to: item.target, from: item)
        XCTAssertEqual(extracted, Array(rows.prefix(2)))
        _ = table.sequenceActionMenu(clickedRow: 2)
        XCTAssertEqual(table.selectedSequenceRows, [rows[2]])
        XCTAssertTrue(table.sequenceActionMenu(clickedRow: -1).items.isEmpty)
    }

    func testSharedMenuCopyHandlersAndPluralNames() {
        let menu = FASTASequenceActionMenuBuilder.buildMenu(selectionCount: 2, handlers: .init(onCopyNames: {}, onCopySequences: {}, onCopyFullNames: {}, onCopy: {}))
        XCTAssertEqual(menu.items.map(\.title), ["Copy Names", "Copy Full Reference Names", "Copy Sequences", "Copy FASTA"])
    }
}
