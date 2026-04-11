// TaxonomyFilterRowView.swift - Inline per-column filter row for taxonomy tables
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit

/// Delegate protocol for filter row changes.
@MainActor
protocol TaxonomyFilterRowDelegate: AnyObject {
    func filterRowDidChangeFilters(_ filterRow: TaxonomyFilterRowView)
}

/// An inline filter row that sits below the table header, providing
/// per-column filter controls (Excel auto-filter style). Each column
/// gets a compact operator popup + text field.
///
/// The row auto-syncs with the table's column layout (widths, order,
/// visibility) via NSTableView notifications.
final class TaxonomyFilterRowView: NSView, NSTextFieldDelegate {

    weak var delegate: TaxonomyFilterRowDelegate?
    private weak var tableView: NSTableView?

    /// Current filter state keyed by column identifier.
    private(set) var filters: [String: ColumnFilter] = [:]

    /// Column type hints — true = numeric, false = text.
    private var columnTypes: [String: Bool] = [:]

    /// Filter cells keyed by column identifier.
    private var filterCells: [String: FilterCellView] = [:]

    /// Debounce timer for text field changes.
    private var debounceWorkItem: DispatchWorkItem?

    /// Height of the filter row.
    static let rowHeight: CGFloat = 24

    // MARK: - Setup

    /// Installs the filter row on a table view, positioned below the header.
    func install(on tableView: NSTableView) {
        self.tableView = tableView
        translatesAutoresizingMaskIntoConstraints = false

        // Register for column layout changes
        NotificationCenter.default.addObserver(
            self, selector: #selector(columnsDidChange),
            name: NSTableView.columnDidResizeNotification, object: tableView
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(columnsDidChange),
            name: NSTableView.columnDidMoveNotification, object: tableView
        )

        rebuildFilterCells()
    }

    /// Sets the data type for a column. Call before or after install.
    func setColumnType(_ columnId: String, isNumeric: Bool) {
        columnTypes[columnId] = isNumeric
        if let cell = filterCells[columnId] {
            cell.setOperators(isNumeric ? FilterOperator.numericOperators : FilterOperator.textOperators)
        }
    }

    /// Returns all active (non-empty) filters.
    var activeFilters: [String: ColumnFilter] {
        filters.filter { $0.value.isActive }
    }

    /// Clears all filters and updates the display.
    func clearAllFilters() {
        for (key, _) in filterCells {
            filterCells[key]?.clearValue()
            filters[key] = nil
        }
        delegate?.filterRowDidChangeFilters(self)
    }

    /// Adds or removes a filter cell for a column. Call when metadata columns
    /// are added or removed dynamically.
    func refreshColumns() {
        rebuildFilterCells()
    }

    // MARK: - Layout

    private func rebuildFilterCells() {
        // Remove existing cells
        for (_, cell) in filterCells {
            cell.removeFromSuperview()
        }
        filterCells.removeAll()

        guard let tableView else { return }

        for column in tableView.tableColumns where !column.isHidden {
            let colId = column.identifier.rawValue
            let isNumeric = columnTypes[colId] ?? false
            let cell = FilterCellView(
                columnId: colId,
                isNumeric: isNumeric,
                delegate: self
            )
            addSubview(cell)
            filterCells[colId] = cell

            // Restore any existing filter state
            if let existingFilter = filters[colId] {
                cell.setFilter(existingFilter)
            }
        }

        layoutFilterCells()
    }

    private func layoutFilterCells() {
        guard let tableView else { return }

        // The filter row must match the table's column layout exactly.
        // Account for the table's intercell spacing and any scroll offset.
        let intercellWidth = tableView.intercellSpacing.width

        for column in tableView.tableColumns where !column.isHidden {
            let colId = column.identifier.rawValue
            guard let cell = filterCells[colId] else { continue }

            let colIndex = tableView.column(withIdentifier: column.identifier)
            guard colIndex >= 0 else { continue }

            let colRect = tableView.rect(ofColumn: colIndex)
            cell.frame = NSRect(
                x: colRect.origin.x,
                y: 0,
                width: colRect.width - intercellWidth,
                height: Self.rowHeight
            )
        }
    }

    override func layout() {
        super.layout()
        layoutFilterCells()
    }

    @objc private func columnsDidChange(_ notification: Notification) {
        // Check if columns were added/removed (count changed)
        let currentColumnIds = Set(filterCells.keys)
        let tableColumnIds = Set(
            (tableView?.tableColumns ?? [])
                .filter { !$0.isHidden }
                .map { $0.identifier.rawValue }
        )

        if currentColumnIds != tableColumnIds {
            rebuildFilterCells()
        } else {
            layoutFilterCells()
        }
    }

    // MARK: - Filter Updates

    fileprivate func filterCellDidChange(columnId: String, op: FilterOperator, value: String, value2: String?) {
        if value.trimmingCharacters(in: .whitespaces).isEmpty {
            filters.removeValue(forKey: columnId)
        } else {
            filters[columnId] = ColumnFilter(columnId: columnId, op: op, value: value, value2: value2)
        }

        // Debounce to avoid excessive reloads during typing
        debounceWorkItem?.cancel()
        let work = DispatchWorkItem { [weak self] in
            guard let self else { return }
            self.delegate?.filterRowDidChangeFilters(self)
        }
        debounceWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: work)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - FilterCellView

/// A single filter cell containing an operator popup and a text field.
private final class FilterCellView: NSView {
    private let columnId: String
    private let operatorPopup: NSPopUpButton
    private let valueField: NSTextField
    private weak var filterDelegate: TaxonomyFilterRowView?

    init(columnId: String, isNumeric: Bool, delegate: TaxonomyFilterRowView) {
        self.columnId = columnId
        self.filterDelegate = delegate
        self.operatorPopup = NSPopUpButton(frame: .zero, pullsDown: false)
        self.valueField = NSTextField()

        super.init(frame: .zero)

        // Operator popup
        operatorPopup.controlSize = .mini
        operatorPopup.font = .systemFont(ofSize: 10)
        operatorPopup.isBordered = false
        operatorPopup.translatesAutoresizingMaskIntoConstraints = false
        operatorPopup.target = self
        operatorPopup.action = #selector(operatorChanged)
        addSubview(operatorPopup)

        setOperators(isNumeric ? FilterOperator.numericOperators : FilterOperator.textOperators)

        // Value field
        valueField.controlSize = .mini
        valueField.font = .systemFont(ofSize: 10)
        valueField.placeholderString = isNumeric ? "filter…" : "filter…"
        valueField.translatesAutoresizingMaskIntoConstraints = false
        valueField.delegate = delegate
        valueField.target = self
        valueField.action = #selector(valueChanged)
        valueField.cell?.sendsActionOnEndEditing = true
        valueField.identifier = NSUserInterfaceItemIdentifier("filter_\(columnId)")
        if isNumeric {
            valueField.alignment = .right
        }
        addSubview(valueField)

        NSLayoutConstraint.activate([
            operatorPopup.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1),
            operatorPopup.centerYAnchor.constraint(equalTo: centerYAnchor),
            operatorPopup.widthAnchor.constraint(equalToConstant: 28),

            valueField.leadingAnchor.constraint(equalTo: operatorPopup.trailingAnchor, constant: 1),
            valueField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1),
            valueField.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueField.heightAnchor.constraint(equalToConstant: 18),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func setOperators(_ operators: [FilterOperator]) {
        operatorPopup.removeAllItems()
        for op in operators {
            operatorPopup.addItem(withTitle: op.rawValue)
            operatorPopup.lastItem?.representedObject = op
        }
    }

    func setFilter(_ filter: ColumnFilter) {
        // Select the matching operator
        for (i, item) in operatorPopup.itemArray.enumerated() {
            if (item.representedObject as? FilterOperator) == filter.op {
                operatorPopup.selectItem(at: i)
                break
            }
        }
        valueField.stringValue = filter.value
    }

    func clearValue() {
        valueField.stringValue = ""
    }

    private var selectedOperator: FilterOperator {
        operatorPopup.selectedItem?.representedObject as? FilterOperator ?? .greaterOrEqual
    }

    @objc private func operatorChanged() {
        notifyChange()
    }

    @objc private func valueChanged() {
        notifyChange()
    }

    private func notifyChange() {
        filterDelegate?.filterCellDidChange(
            columnId: columnId,
            op: selectedOperator,
            value: valueField.stringValue,
            value2: nil
        )
    }
}
