// BatchTableView.swift - Generic base class for batch aggregated classifier table views
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import LungfishCore
import os.log

// MARK: - BatchColumnSpec

/// Column specification for a batch table.
///
/// Each entry describes one fixed column in a ``BatchTableView`` subclass.
struct BatchColumnSpec {
    /// The column's unique identifier (used as the sort-descriptor key too).
    let identifier: NSUserInterfaceItemIdentifier
    /// The header title string.
    let title: String
    /// Default column width.
    let width: CGFloat
    /// Minimum column width enforced by the table.
    let minWidth: CGFloat
    /// Whether the column sorts ascending by default (`true`) or descending (`false`).
    let defaultAscending: Bool
}

// MARK: - BatchTableView

/// Generic base class for batch aggregated table views (Kraken2, EsViritu, TaxTriage).
///
/// Subclasses provide:
/// - ``columnSpecs`` — fixed column definitions
/// - ``searchPlaceholder`` — placeholder text for the search field
/// - ``cellContent(for:row:)`` — cell text, alignment, and optional font for a given column
/// - ``rowMatchesFilter(_:filterText:)`` — whether a row matches the current filter
/// - ``compareRows(_:_:by:ascending:)`` — comparator for sorting by column key
/// - ``sampleId(for:)`` — sample identifier for metadata column lookups
///
/// All shared boilerplate (layout, scroll view, NSTableView configuration, sort/filter
/// pipeline, selection callbacks, metadata column controller) lives here.
///
/// ## Thread Safety
///
/// `@MainActor` isolated. All data must be provided via ``configure(rows:)``.
///
/// ## Swift Generics Constraint
///
/// `NSTableViewDataSource` and `NSTableViewDelegate` conformances are declared on the
/// class header (not in extensions) because Swift does not allow `@objc` protocol
/// conformances in extensions of generic classes.
@MainActor
class BatchTableView<Row>: NSView, NSTableViewDataSource, NSTableViewDelegate {

    // MARK: - Subclass Hooks

    /// Fixed column specifications. Subclasses must override this.
    var columnSpecs: [BatchColumnSpec] { [] }

    /// Placeholder string for the search field. Defaults to `"Filter…"`.
    var searchPlaceholder: String { "Filter\u{2026}" }

    /// The list of standard (non-metadata) column titles registered with
    /// ``metadataColumns``. Defaults to the ``columnSpecs`` titles.
    var standardColumnNames: [String] { columnSpecs.map(\.title) }

    /// Returns the text, alignment, and optional font override for a cell.
    ///
    /// Subclasses override this to provide tool-specific rendering.
    /// When `font` is `nil`, the cell keeps the default font set by ``makeCellView(identifier:)``.
    /// The default implementation returns an empty string with left alignment and no font override.
    func cellContent(
        for column: NSUserInterfaceItemIdentifier,
        row: Row
    ) -> (text: String, alignment: NSTextAlignment, font: NSFont?) {
        ("", .left, nil)
    }

    /// Returns whether the given row matches `filterText`.
    ///
    /// The default implementation always returns `true` (no filtering).
    func rowMatchesFilter(_ row: Row, filterText: String) -> Bool { true }

    /// Returns `true` if `lhs` should be ordered before `rhs` when sorting by `key`.
    ///
    /// Pass `ascending` directly to control the result direction. Returning `false` for
    /// both `(lhs, rhs)` and `(rhs, lhs)` is treated as equal by the sort. The default
    /// returns `false` for all keys.
    func compareRows(_ lhs: Row, _ rhs: Row, by key: String, ascending: Bool) -> Bool { false }

    /// Returns the sample identifier for `row`, used for metadata column lookups.
    ///
    /// Return `nil` if the row has no associated sample. The default returns `nil`.
    func sampleId(for row: Row) -> String? { nil }

    // MARK: - State

    /// The rows currently displayed (after any filter and sort).
    private(set) var displayedRows: [Row] = []

    /// Pre-filter baseline preserved so re-sort can restart without re-filtering.
    private var unsortedRows: [Row] = []

    /// The full unfiltered set of rows as last provided by ``configure(rows:)``.
    var unfilteredRows: [Row] = []

    /// Current filter text applied to rows.
    private var filterText: String = ""

    // MARK: - Callbacks

    /// Called when the user selects a single row.
    var onRowSelected: ((Row) -> Void)?

    /// Called when the user selects multiple rows. Provides the full array of selected rows.
    var onMultipleRowsSelected: (([Row]) -> Void)?

    /// Called when the selection is cleared.
    var onSelectionCleared: (() -> Void)?

    // MARK: - Metadata Columns

    /// Controller for dynamic sample-metadata columns (from imported CSV/TSV).
    let metadataColumns = MetadataColumnController()

    // MARK: - Child Views

    /// The table view. Accessible to subclasses for targeted column reloads.
    private(set) var tableView: NSTableView!
    private var scrollView: NSScrollView!
    private var searchField: NSSearchField!

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
        // Search field above the table.
        let sf = NSSearchField()
        sf.translatesAutoresizingMaskIntoConstraints = false
        sf.placeholderString = searchPlaceholder
        sf.font = .systemFont(ofSize: 11)
        sf.controlSize = .small
        sf.target = self
        sf.action = #selector(filterChanged(_:))
        sf.sendsSearchStringImmediately = true
        addSubview(sf)
        self.searchField = sf

        let sv = NSScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.hasVerticalScroller   = true
        sv.hasHorizontalScroller = true
        sv.autohidesScrollers    = true
        addSubview(sv)
        self.scrollView = sv

        NSLayoutConstraint.activate([
            sf.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            sf.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            sf.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            sf.heightAnchor.constraint(equalToConstant: 24),
            sv.topAnchor.constraint(equalTo: sf.bottomAnchor, constant: 4),
            sv.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        let tv = NSTableView()
        tv.usesAlternatingRowBackgroundColors = true
        tv.allowsColumnReordering  = true
        tv.allowsColumnResizing    = true
        tv.allowsColumnSelection   = false
        tv.allowsMultipleSelection = true
        tv.rowHeight               = 22
        tv.style                   = .plain
        tv.delegate                = self
        tv.dataSource              = self
        tv.columnAutoresizingStyle = .noColumnAutoresizing
        self.tableView = tv

        addFixedColumns()
        sv.documentView = tv

        metadataColumns.isMultiSampleMode = true
        metadataColumns.standardColumnNames = standardColumnNames
        metadataColumns.install(on: tv)
    }

    private func addFixedColumns() {
        for spec in columnSpecs {
            let col = NSTableColumn(identifier: spec.identifier)
            col.title    = spec.title
            col.width    = spec.width
            col.minWidth = spec.minWidth
            col.sortDescriptorPrototype = NSSortDescriptor(
                key: spec.identifier.rawValue,
                ascending: spec.defaultAscending
            )
            tableView.addTableColumn(col)
        }
    }

    // MARK: - Public API

    /// Replaces the displayed rows and reloads the table.
    ///
    /// The current filter text is re-applied automatically so that existing
    /// filter state is preserved across sample filter changes.
    ///
    /// - Parameter rows: The new rows to display.
    func configure(rows: [Row]) {
        self.unfilteredRows = rows
        applyFilter()
        hideEmptyColumns()
    }

    // MARK: - Empty Column Hiding

    /// Returns `true` if the given column has at least one non-nil / non-empty data value
    /// across all rows in ``unfilteredRows``.
    ///
    /// The default implementation always returns `true` (no columns hidden).
    /// Subclasses override this to hide columns that are never populated for a given tool.
    func columnHasData(_ columnId: NSUserInterfaceItemIdentifier) -> Bool {
        return true
    }

    /// Hides fixed (non-metadata) columns that have no data across all rows.
    ///
    /// Called automatically at the end of ``configure(rows:)``. Each non-metadata column
    /// is shown or hidden based on the result of ``columnHasData(_:)``.
    func hideEmptyColumns() {
        for col in tableView.tableColumns {
            guard !MetadataColumnController.isMetadataColumn(col.identifier) else { continue }
            col.isHidden = !columnHasData(col.identifier)
        }
    }

    // MARK: - Filter

    @objc private func filterChanged(_ sender: NSSearchField) {
        filterText = sender.stringValue
        applyFilter()
    }

    private func applyFilter() {
        let filtered: [Row]
        if filterText.isEmpty {
            filtered = unfilteredRows
        } else {
            filtered = unfilteredRows.filter { rowMatchesFilter($0, filterText: filterText) }
        }
        // Re-apply current sort order on top of the filtered set.
        if let descriptor = tableView.sortDescriptors.first, let key = descriptor.key {
            let ascending = descriptor.ascending
            self.unsortedRows  = filtered
            self.displayedRows = filtered.sorted { compareRows($0, $1, by: key, ascending: ascending) }
        } else {
            self.unsortedRows  = filtered
            self.displayedRows = filtered
        }
        tableView.reloadData()
    }

    // MARK: - Cell Factory

    func makeCellView(identifier: NSUserInterfaceItemIdentifier) -> NSTableCellView {
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

    // MARK: - NSTableViewDataSource

    func numberOfRows(in tableView: NSTableView) -> Int {
        displayedRows.count
    }

    func tableView(
        _ tableView: NSTableView,
        sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]
    ) {
        guard let descriptor = tableView.sortDescriptors.first,
              let key = descriptor.key else {
            displayedRows = unsortedRows
            tableView.reloadData()
            return
        }
        let ascending = descriptor.ascending
        displayedRows = unsortedRows.sorted { compareRows($0, $1, by: key, ascending: ascending) }
        tableView.reloadData()
    }

    // MARK: - NSTableViewDelegate

    func tableView(
        _ tableView: NSTableView,
        viewFor tableColumn: NSTableColumn?,
        row: Int
    ) -> NSView? {
        guard let column = tableColumn, row < displayedRows.count else { return nil }

        // Metadata columns handled by the controller.
        if MetadataColumnController.isMetadataColumn(column.identifier) {
            let rowData = displayedRows[row]
            return metadataColumns.cellForColumn(column, sampleId: sampleId(for: rowData) ?? "")
        }

        let rowData = displayedRows[row]
        let id = column.identifier

        let cellView = tableView.makeView(withIdentifier: id, owner: self) as? NSTableCellView
            ?? makeCellView(identifier: id)

        let (text, alignment, font) = cellContent(for: id, row: rowData)
        cellView.textField?.stringValue = text
        cellView.textField?.alignment   = alignment
        if let font {
            cellView.textField?.font = font
        }

        return cellView
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedIndexes = tableView.selectedRowIndexes
        if selectedIndexes.isEmpty {
            onSelectionCleared?()
            return
        }

        let selected = selectedIndexes.compactMap { idx -> Row? in
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

// MARK: - Shared Helpers

/// Formats an integer read count as a compact human-readable string.
///
/// - `>= 1 000 000` → `"12.3M"`
/// - `>= 1 000`     → `"4.5K"`
/// - otherwise      → `"123"`
func formatReadCount(_ count: Int) -> String {
    if count >= 1_000_000 {
        return String(format: "%.1fM", Double(count) / 1_000_000)
    } else if count >= 1_000 {
        return String(format: "%.1fK", Double(count) / 1_000)
    }
    return "\(count)"
}
