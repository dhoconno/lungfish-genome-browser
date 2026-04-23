import AppKit
import LungfishCore

struct BundleBrowserState: Equatable {
    var filterText: String = ""
    var selectedSequenceName: String?
    var scrollOriginY: CGFloat = 0
}

@MainActor
final class BundleBrowserViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    var onOpenSequence: ((BundleBrowserSequenceSummary) -> Void)?

    private var summary: BundleBrowserSummary?
    private var displayedRows: [BundleBrowserSequenceSummary] = []
    private var preferredSelectedSequenceName: String?
    private var isRestoringSelection = false

    private let splitView = NSSplitView()
    private let listPane = NSView()
    private let detailPane = NSView()
    private let searchField = NSSearchField()
    private let scrollView = NSScrollView()
    private let tableView = NSTableView()
    private let openButton = NSButton(title: "Open in Browser", target: nil, action: nil)
    private let detailStack = NSStackView()
    private let detailNameLabel = NSTextField(labelWithString: "")
    private let detailDescriptionLabel = NSTextField(labelWithString: "")
    private let detailLengthLabel = NSTextField(labelWithString: "")
    private let detailMetricsLabel = NSTextField(labelWithString: "")

    override func loadView() {
        let rootView = NSView(frame: NSRect(x: 0, y: 0, width: 960, height: 640))
        rootView.setAccessibilityIdentifier("bundle-browser-view")
        view = rootView

        configureSplitView()
        configureListPane()
        configureDetailPane()

        view.addSubview(splitView)
        NSLayoutConstraint.activate([
            splitView.topAnchor.constraint(equalTo: view.topAnchor),
            splitView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            splitView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            splitView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func configure(summary: BundleBrowserSummary, restoredState: BundleBrowserState? = nil) {
        self.summary = summary

        let state = restoredState ?? BundleBrowserState(
            filterText: "",
            selectedSequenceName: summary.sequences.first?.name,
            scrollOriginY: 0
        )

        preferredSelectedSequenceName = state.selectedSequenceName ?? summary.sequences.first?.name
        searchField.stringValue = state.filterText
        applyFilterAndRestoreSelection()
        restoreScrollPosition(state.scrollOriginY)
    }

    func captureState() -> BundleBrowserState {
        BundleBrowserState(
            filterText: searchField.stringValue,
            selectedSequenceName: selectedRow?.name,
            scrollOriginY: scrollView.contentView.bounds.origin.y
        )
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        displayedRows.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = NSUserInterfaceItemIdentifier("BundleBrowserCell")
        let cell = (tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView) ?? NSTableCellView()
        let cellTextField = cell.textField ?? NSTextField(labelWithString: "")
        cell.identifier = identifier
        cellTextField.translatesAutoresizingMaskIntoConstraints = false
        cellTextField.lineBreakMode = .byTruncatingTail
        cell.textField = cellTextField

        if cellTextField.superview == nil {
            cell.addSubview(cellTextField)
            NSLayoutConstraint.activate([
                cellTextField.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 8),
                cellTextField.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -8),
                cellTextField.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            ])
        }

        cellTextField.stringValue = displayedRows[row].name
        return cell
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard !isRestoringSelection else { return }
        let row = selectedRow
        preferredSelectedSequenceName = row?.name ?? preferredSelectedSequenceName
        updateDetailPane(for: row)
    }

    @objc private func searchFieldChanged(_ sender: NSSearchField) {
        applyFilterAndRestoreSelection()
    }

    @objc private func openSelectedSequence(_ sender: Any?) {
        guard let row = selectedRow else { return }
        onOpenSequence?(row)
    }

    var testDisplayedNames: [String] { displayedRows.map(\.name) }
    var testSelectedName: String? { selectedRow?.name }
    var testDetailLengthText: String { detailLengthLabel.stringValue }
    var testFilterText: String { searchField.stringValue }
    var testScrollOriginY: CGFloat { scrollView.contentView.bounds.origin.y }
    var testOpenButtonEnabled: Bool { openButton.isEnabled }

    func testSetFilterText(_ text: String) {
        searchField.stringValue = text
        searchFieldChanged(searchField)
    }

    func testSelectRow(named name: String) {
        guard let rowIndex = displayedRows.firstIndex(where: { $0.name == name }) else { return }
        preferredSelectedSequenceName = name
        tableView.selectRowIndexes(IndexSet(integer: rowIndex), byExtendingSelection: false)
        updateDetailPane(for: displayedRows[rowIndex])
    }

    func testInvokeOpen() {
        openSelectedSequence(nil)
    }

    func testSetScrollOriginY(_ originY: CGFloat) {
        restoreScrollPosition(originY)
    }

    private var selectedRow: BundleBrowserSequenceSummary? {
        let rowIndex = tableView.selectedRow
        guard rowIndex >= 0, rowIndex < displayedRows.count else { return nil }
        return displayedRows[rowIndex]
    }

    private func configureSplitView() {
        splitView.translatesAutoresizingMaskIntoConstraints = false
        splitView.isVertical = true
        splitView.dividerStyle = .thin
        splitView.setHoldingPriority(.defaultLow, forSubviewAt: 0)
        splitView.setPosition(340, ofDividerAt: 0)

        listPane.translatesAutoresizingMaskIntoConstraints = false
        detailPane.translatesAutoresizingMaskIntoConstraints = false
        splitView.addArrangedSubview(listPane)
        splitView.addArrangedSubview(detailPane)

        NSLayoutConstraint.activate([
            listPane.widthAnchor.constraint(greaterThanOrEqualToConstant: 260),
            detailPane.widthAnchor.constraint(greaterThanOrEqualToConstant: 280),
        ])
    }

    private func configureListPane() {
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.placeholderString = "Filter sequences"
        searchField.sendsSearchStringImmediately = true
        searchField.target = self
        searchField.action = #selector(searchFieldChanged(_:))

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.drawsBackground = false

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.setAccessibilityIdentifier("bundle-browser-table")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.headerView = nil
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.rowHeight = 28
        tableView.allowsEmptySelection = true
        tableView.allowsMultipleSelection = false
        tableView.doubleAction = #selector(openSelectedSequence(_:))
        tableView.target = self

        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("sequence"))
        column.title = "Sequence"
        column.resizingMask = .autoresizingMask
        tableView.addTableColumn(column)

        scrollView.documentView = tableView
        listPane.addSubview(searchField)
        listPane.addSubview(scrollView)

        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: listPane.topAnchor, constant: 12),
            searchField.leadingAnchor.constraint(equalTo: listPane.leadingAnchor, constant: 12),
            searchField.trailingAnchor.constraint(equalTo: listPane.trailingAnchor, constant: -12),

            scrollView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: listPane.leadingAnchor, constant: 12),
            scrollView.trailingAnchor.constraint(equalTo: listPane.trailingAnchor, constant: -12),
            scrollView.bottomAnchor.constraint(equalTo: listPane.bottomAnchor, constant: -12),
        ])
    }

    private func configureDetailPane() {
        detailStack.translatesAutoresizingMaskIntoConstraints = false
        detailStack.orientation = .vertical
        detailStack.alignment = .leading
        detailStack.spacing = 8

        detailNameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        detailDescriptionLabel.font = .systemFont(ofSize: 12)
        detailDescriptionLabel.textColor = .secondaryLabelColor
        detailLengthLabel.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        detailMetricsLabel.font = .systemFont(ofSize: 12)
        detailMetricsLabel.textColor = .secondaryLabelColor

        [detailNameLabel, detailDescriptionLabel, detailLengthLabel, detailMetricsLabel].forEach {
            $0.lineBreakMode = .byTruncatingTail
            detailStack.addArrangedSubview($0)
        }

        openButton.translatesAutoresizingMaskIntoConstraints = false
        openButton.setAccessibilityIdentifier("bundle-browser-open-button")
        openButton.bezelStyle = .rounded
        openButton.target = self
        openButton.action = #selector(openSelectedSequence(_:))

        detailPane.addSubview(detailStack)
        detailPane.addSubview(openButton)

        NSLayoutConstraint.activate([
            detailStack.topAnchor.constraint(equalTo: detailPane.topAnchor, constant: 16),
            detailStack.leadingAnchor.constraint(equalTo: detailPane.leadingAnchor, constant: 16),
            detailStack.trailingAnchor.constraint(lessThanOrEqualTo: detailPane.trailingAnchor, constant: -16),

            openButton.topAnchor.constraint(equalTo: detailStack.bottomAnchor, constant: 16),
            openButton.leadingAnchor.constraint(equalTo: detailPane.leadingAnchor, constant: 16),
            openButton.bottomAnchor.constraint(lessThanOrEqualTo: detailPane.bottomAnchor, constant: -16),
        ])

        updateDetailPane(for: nil)
    }

    private func applyFilterAndRestoreSelection() {
        guard let summary else {
            displayedRows = []
            tableView.reloadData()
            updateDetailPane(for: nil)
            return
        }

        let query = searchField.stringValue
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        if query.isEmpty {
            displayedRows = summary.sequences
        } else {
            displayedRows = summary.sequences.filter { row in
                row.name.lowercased().contains(query)
                    || (row.displayDescription?.lowercased().contains(query) ?? false)
                    || row.aliases.contains(where: { $0.lowercased().contains(query) })
            }
        }

        tableView.reloadData()
        restoreSelectionAfterFiltering()
    }

    private func restoreSelectionAfterFiltering() {
        guard !displayedRows.isEmpty else {
            tableView.deselectAll(nil)
            updateDetailPane(for: nil)
            return
        }

        let selectionName = preferredSelectedSequenceName
        let rowIndex = selectionName.flatMap { name in
            displayedRows.firstIndex(where: { $0.name == name })
        } ?? 0

        isRestoringSelection = true
        tableView.selectRowIndexes(IndexSet(integer: rowIndex), byExtendingSelection: false)
        isRestoringSelection = false
        updateDetailPane(for: displayedRows[rowIndex])
    }

    private func restoreScrollPosition(_ originY: CGFloat) {
        view.layoutSubtreeIfNeeded()
        scrollView.layoutSubtreeIfNeeded()
        scrollView.contentView.scroll(to: NSPoint(x: 0, y: originY))
        scrollView.reflectScrolledClipView(scrollView.contentView)
    }

    private func updateDetailPane(for row: BundleBrowserSequenceSummary?) {
        guard let row else {
            detailNameLabel.stringValue = "No sequence selected"
            detailDescriptionLabel.stringValue = ""
            detailLengthLabel.stringValue = ""
            detailMetricsLabel.stringValue = ""
            openButton.isEnabled = false
            return
        }

        detailNameLabel.stringValue = row.name
        detailDescriptionLabel.stringValue = row.displayDescription ?? ""
        detailLengthLabel.stringValue = "\(row.length.formatted()) bp"

        if let mappedReads = row.metrics?.mappedReads {
            detailMetricsLabel.stringValue = "Mapped reads: \(mappedReads.formatted())"
        } else {
            detailMetricsLabel.stringValue = "Mapped reads: unavailable"
        }

        openButton.isEnabled = true
    }
}
