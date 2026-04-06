// BatchEsVirituTableView.swift - Flat NSTableView wrapper for EsViritu batch results
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import LungfishCore
import os.log

private let logger = Logger(subsystem: LogSubsystem.app, category: "BatchEsVirituTableView")

// MARK: - Column Identifiers

private extension NSUserInterfaceItemIdentifier {
    static let esv_sample       = NSUserInterfaceItemIdentifier("sample")
    static let esv_name         = NSUserInterfaceItemIdentifier("name")
    static let esv_family       = NSUserInterfaceItemIdentifier("family")
    static let esv_assembly     = NSUserInterfaceItemIdentifier("assembly")
    static let esv_reads        = NSUserInterfaceItemIdentifier("reads")
    static let esv_uniqueReads  = NSUserInterfaceItemIdentifier("uniqueReads")
    static let esv_rpkmf        = NSUserInterfaceItemIdentifier("rpkmf")
    static let esv_coverage     = NSUserInterfaceItemIdentifier("coverage")
}

// MARK: - BatchEsVirituTableView

/// A scrollable flat table showing ``BatchEsVirituRow`` records for EsViritu batch mode.
///
/// ## Layout
///
/// One row per viral assembly × sample combination. Fixed columns: Sample, Name, Family,
/// Assembly, Reads, Unique Reads, RPKMF, and Coverage (breadth). Dynamic metadata columns
/// are managed by a ``MetadataColumnController``.
///
/// ## Sorting
///
/// Click any column header to sort. Multi-column sort is not supported.
///
/// ## Selection
///
/// Multi-row selection is enabled. Selection callbacks fire on every selection change.
///
/// ## Thread Safety
///
/// `@MainActor` isolated. All data must be set via ``configure(rows:)``.
@MainActor
final class BatchEsVirituTableView: NSView {

    // MARK: - State

    /// The rows currently displayed (after any sort).
    private(set) var displayedRows: [BatchEsVirituRow] = []

    /// Unsorted copy preserved so re-sort can restart from a stable baseline.
    private var unsortedRows: [BatchEsVirituRow] = []

    // MARK: - Callbacks

    /// Called when the user selects a single row.
    var onRowSelected: ((BatchEsVirituRow) -> Void)?

    /// Called when the user selects multiple rows.
    var onMultipleRowsSelected: (([BatchEsVirituRow]) -> Void)?

    /// Called when the selection is cleared.
    var onSelectionCleared: (() -> Void)?

    // MARK: - Metadata Columns

    /// Controller for dynamic sample-metadata columns (from imported CSV/TSV).
    let metadataColumns = MetadataColumnController()

    // MARK: - Child Views

    private let scrollView = NSScrollView()
    private let tableView  = NSTableView()

    // MARK: - Init

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupTableView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
    }

    // MARK: - Setup

    private func setupTableView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.hasVerticalScroller   = true
        scrollView.hasHorizontalScroller = true
        scrollView.autohidesScrollers    = true
        addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        tableView.usesAlternatingRowBackgroundColors = true
        tableView.allowsColumnReordering  = true
        tableView.allowsColumnResizing    = true
        tableView.allowsColumnSelection   = false
        tableView.allowsMultipleSelection = true
        tableView.rowHeight               = 22
        tableView.style                   = .plain
        tableView.delegate                = self
        tableView.dataSource              = self
        tableView.columnAutoresizingStyle = .noColumnAutoresizing

        addFixedColumns()
        scrollView.documentView = tableView

        metadataColumns.isMultiSampleMode = true
        metadataColumns.standardColumnNames = ["Sample", "Name", "Family",
                                               "Assembly", "Reads", "Unique Reads", "RPKMF", "Coverage"]
        metadataColumns.install(on: tableView)
    }

    private func addFixedColumns() {
        let specs: [(NSUserInterfaceItemIdentifier, String, CGFloat, CGFloat, Bool)] = [
            (.esv_sample,      "Sample",       130, 70,  true),
            (.esv_name,        "Name",         220, 100, true),
            (.esv_family,      "Family",       130, 70,  true),
            (.esv_assembly,    "Assembly",     130, 70,  true),
            (.esv_reads,       "Reads",         80, 50,  false),
            (.esv_uniqueReads, "Unique Reads",  90, 55,  false),
            (.esv_rpkmf,       "RPKMF",         80, 50,  false),
            (.esv_coverage,    "Coverage",      80, 50,  false),
        ]
        for (id, title, width, minWidth, ascending) in specs {
            let col = NSTableColumn(identifier: id)
            col.title    = title
            col.width    = width
            col.minWidth = minWidth
            col.sortDescriptorPrototype = NSSortDescriptor(key: id.rawValue, ascending: ascending)
            tableView.addTableColumn(col)
        }
    }

    // MARK: - Public API

    /// Replaces the displayed rows and reloads the table.
    ///
    /// - Parameter rows: The new rows to display.
    func configure(rows: [BatchEsVirituRow]) {
        self.unsortedRows  = rows
        self.displayedRows = rows
        tableView.reloadData()
        logger.info("BatchEsVirituTableView configured with \(rows.count) rows")
    }

    // MARK: - Cell Factory

    private func makeCellView(identifier: NSUserInterfaceItemIdentifier) -> NSTableCellView {
        let cell = NSTableCellView()
        cell.identifier = identifier
        let tf = NSTextField(labelWithString: "")
        tf.font = .monospacedDigitSystemFont(ofSize: 11, weight: .regular)
        tf.lineBreakMode = .byTruncatingTail
        tf.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(tf)
        cell.textField = tf
        NSLayoutConstraint.activate([
            tf.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 4),
            tf.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -4),
            tf.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
        ])
        return cell
    }
}

// MARK: - NSTableViewDataSource

extension BatchEsVirituTableView: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        displayedRows.count
    }

    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        guard let descriptor = tableView.sortDescriptors.first,
              let key = descriptor.key else {
            displayedRows = unsortedRows
            tableView.reloadData()
            return
        }

        let ascending = descriptor.ascending
        displayedRows = unsortedRows.sorted { a, b in
            let result: Bool
            switch key {
            case "sample":
                result = a.sample.localizedCaseInsensitiveCompare(b.sample) == .orderedAscending
            case "name":
                result = a.virusName.localizedCaseInsensitiveCompare(b.virusName) == .orderedAscending
            case "family":
                let af = a.family ?? ""
                let bf = b.family ?? ""
                result = af.localizedCaseInsensitiveCompare(bf) == .orderedAscending
            case "assembly":
                result = a.assembly.localizedCaseInsensitiveCompare(b.assembly) == .orderedAscending
            case "reads":
                result = a.readCount < b.readCount
            case "uniqueReads":
                result = a.uniqueReads < b.uniqueReads
            case "rpkmf":
                result = a.rpkmf < b.rpkmf
            case "coverage":
                result = a.coverageBreadth < b.coverageBreadth
            default:
                result = false
            }
            return ascending ? result : !result
        }
        tableView.reloadData()
    }
}

// MARK: - NSTableViewDelegate

extension BatchEsVirituTableView: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let column = tableColumn, row < displayedRows.count else { return nil }

        // Metadata columns handled by the controller
        if MetadataColumnController.isMetadataColumn(column.identifier) {
            let rowData = displayedRows[row]
            return metadataColumns.cellForColumn(column, sampleId: rowData.sample)
        }

        let rowData = displayedRows[row]
        let id = column.identifier

        let cellView = tableView.makeView(withIdentifier: id, owner: self) as? NSTableCellView
            ?? makeCellView(identifier: id)

        switch id {
        case .esv_sample:
            cellView.textField?.stringValue = rowData.sample
            cellView.textField?.font = .systemFont(ofSize: 11, weight: .medium)
            cellView.textField?.alignment = .left

        case .esv_name:
            cellView.textField?.stringValue = rowData.virusName
            cellView.textField?.font = .systemFont(ofSize: 11, weight: .regular)
            cellView.textField?.alignment = .left

        case .esv_family:
            cellView.textField?.stringValue = rowData.family ?? "—"
            cellView.textField?.font = .systemFont(ofSize: 11)
            cellView.textField?.alignment = .left

        case .esv_assembly:
            cellView.textField?.stringValue = rowData.assembly
            cellView.textField?.font = .monospacedDigitSystemFont(ofSize: 11, weight: .regular)
            cellView.textField?.alignment = .left

        case .esv_reads:
            cellView.textField?.stringValue = formatEsvReadCount(rowData.readCount)
            cellView.textField?.alignment = .right

        case .esv_uniqueReads:
            cellView.textField?.stringValue = formatEsvReadCount(rowData.uniqueReads)
            cellView.textField?.alignment = .right

        case .esv_rpkmf:
            cellView.textField?.stringValue = String(format: "%.1f", rowData.rpkmf)
            cellView.textField?.alignment = .right

        case .esv_coverage:
            cellView.textField?.stringValue = String(format: "%.1f%%", rowData.coverageBreadth * 100)
            cellView.textField?.alignment = .right

        default:
            cellView.textField?.stringValue = ""
        }

        return cellView
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedIndexes = tableView.selectedRowIndexes
        if selectedIndexes.isEmpty {
            onSelectionCleared?()
            return
        }

        let selected = selectedIndexes.compactMap { idx -> BatchEsVirituRow? in
            guard idx < displayedRows.count else { return nil }
            return displayedRows[idx]
        }

        if selected.count == 1, let row = selected.first {
            onRowSelected?(row)
        } else if selected.count > 1 {
            onMultipleRowsSelected?(selected)
        }
    }
}

// MARK: - Helpers

private func formatEsvReadCount(_ count: Int) -> String {
    if count >= 1_000_000 {
        return String(format: "%.1fM", Double(count) / 1_000_000)
    } else if count >= 1_000 {
        return String(format: "%.1fK", Double(count) / 1_000)
    }
    return "\(count)"
}
