// FASTQMetadataDrawerView.swift - Bottom drawer for FASTQ sample/barcode metadata
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import LungfishIO

@MainActor
public protocol FASTQMetadataDrawerViewDelegate: AnyObject {
    func fastqMetadataDrawerViewDidSave(
        _ drawer: FASTQMetadataDrawerView,
        fastqURL: URL?,
        metadata: FASTQDemultiplexMetadata
    )
}

@MainActor
public final class FASTQMetadataDrawerView: NSView, NSTableViewDataSource, NSTableViewDelegate {

    private enum Tab: Int {
        case samples = 0
        case barcodeSets = 1
    }

    private weak var delegate: FASTQMetadataDrawerViewDelegate?

    private var fastqURL: URL?
    private var activeTab: Tab = .samples
    private var sampleAssignments: [FASTQSampleBarcodeAssignment] = []
    private var customBarcodeSets: [IlluminaBarcodeDefinition] = []
    private var preferredBarcodeSetID: String?
    private var preferredSetIDByPopupIndex: [Int: String] = [:]

    private let headerBar = NSView()
    private let tabControl = NSSegmentedControl()
    private let preferredSetLabel = NSTextField(labelWithString: "Preferred Set:")
    private let preferredSetPopup = NSPopUpButton()
    private let addButton = NSButton(title: "Add", target: nil, action: nil)
    private let removeButton = NSButton(title: "Remove", target: nil, action: nil)
    private let importButton = NSButton(title: "Import CSV", target: nil, action: nil)
    private let exportButton = NSButton(title: "Export CSV", target: nil, action: nil)
    private let saveButton = NSButton(title: "Save", target: nil, action: nil)

    private let scrollView = NSScrollView()
    private let tableView = NSTableView()
    private let statusLabel = NSTextField(labelWithString: "")
    private let topDivider = NSBox()

    public init(delegate: FASTQMetadataDrawerViewDelegate? = nil) {
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        setupUI()
        rebuildColumns()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setDelegate(_ delegate: FASTQMetadataDrawerViewDelegate?) {
        self.delegate = delegate
    }

    public func configure(fastqURL: URL?, metadata: FASTQDemultiplexMetadata?) {
        self.fastqURL = fastqURL
        if let metadata {
            sampleAssignments = metadata.sampleAssignments
            customBarcodeSets = metadata.customBarcodeSets
            preferredBarcodeSetID = metadata.preferredBarcodeSetID
        } else {
            sampleAssignments = []
            customBarcodeSets = []
            preferredBarcodeSetID = nil
        }
        rebuildPreferredSetPopup()
        tableView.reloadData()
        statusLabel.stringValue = sampleAssignments.isEmpty
            ? "No FASTQ sample metadata loaded."
            : "Loaded \(sampleAssignments.count) sample assignment(s)."
    }

    public func currentMetadata() -> FASTQDemultiplexMetadata {
        FASTQDemultiplexMetadata(
            sampleAssignments: sampleAssignments,
            customBarcodeSets: customBarcodeSets,
            preferredBarcodeSetID: preferredBarcodeSetID
        )
    }

    private func setupUI() {
        topDivider.boxType = .separator
        topDivider.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topDivider)

        headerBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerBar)

        tabControl.segmentCount = 2
        tabControl.setLabel("Samples", forSegment: 0)
        tabControl.setLabel("Barcode Sets", forSegment: 1)
        tabControl.selectedSegment = 0
        tabControl.segmentStyle = .texturedRounded
        tabControl.controlSize = .small
        tabControl.translatesAutoresizingMaskIntoConstraints = false
        tabControl.target = self
        tabControl.action = #selector(tabChanged(_:))
        headerBar.addSubview(tabControl)

        preferredSetLabel.font = .systemFont(ofSize: 11, weight: .medium)
        preferredSetLabel.translatesAutoresizingMaskIntoConstraints = false
        headerBar.addSubview(preferredSetLabel)

        preferredSetPopup.controlSize = .small
        preferredSetPopup.translatesAutoresizingMaskIntoConstraints = false
        preferredSetPopup.target = self
        preferredSetPopup.action = #selector(preferredSetChanged(_:))
        headerBar.addSubview(preferredSetPopup)

        for button in [addButton, removeButton, importButton, exportButton, saveButton] {
            button.bezelStyle = .rounded
            button.controlSize = .small
            button.translatesAutoresizingMaskIntoConstraints = false
            headerBar.addSubview(button)
        }
        addButton.target = self
        addButton.action = #selector(addClicked(_:))
        removeButton.target = self
        removeButton.action = #selector(removeClicked(_:))
        importButton.target = self
        importButton.action = #selector(importClicked(_:))
        exportButton.target = self
        exportButton.action = #selector(exportClicked(_:))
        saveButton.target = self
        saveButton.action = #selector(saveClicked(_:))

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.autohidesScrollers = true
        addSubview(scrollView)

        tableView.headerView = NSTableHeaderView()
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.rowHeight = 24
        tableView.dataSource = self
        tableView.delegate = self
        scrollView.documentView = tableView

        statusLabel.font = .systemFont(ofSize: 11)
        statusLabel.textColor = .secondaryLabelColor
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(statusLabel)

        NSLayoutConstraint.activate([
            topDivider.topAnchor.constraint(equalTo: topAnchor),
            topDivider.leadingAnchor.constraint(equalTo: leadingAnchor),
            topDivider.trailingAnchor.constraint(equalTo: trailingAnchor),
            topDivider.heightAnchor.constraint(equalToConstant: 1),

            headerBar.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            headerBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            headerBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            headerBar.heightAnchor.constraint(equalToConstant: 28),

            tabControl.leadingAnchor.constraint(equalTo: headerBar.leadingAnchor),
            tabControl.centerYAnchor.constraint(equalTo: headerBar.centerYAnchor),

            preferredSetLabel.leadingAnchor.constraint(equalTo: tabControl.trailingAnchor, constant: 10),
            preferredSetLabel.centerYAnchor.constraint(equalTo: headerBar.centerYAnchor),

            preferredSetPopup.leadingAnchor.constraint(equalTo: preferredSetLabel.trailingAnchor, constant: 6),
            preferredSetPopup.widthAnchor.constraint(equalToConstant: 230),
            preferredSetPopup.centerYAnchor.constraint(equalTo: headerBar.centerYAnchor),

            saveButton.trailingAnchor.constraint(equalTo: headerBar.trailingAnchor),
            saveButton.centerYAnchor.constraint(equalTo: headerBar.centerYAnchor),

            exportButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -6),
            exportButton.centerYAnchor.constraint(equalTo: headerBar.centerYAnchor),

            importButton.trailingAnchor.constraint(equalTo: exportButton.leadingAnchor, constant: -6),
            importButton.centerYAnchor.constraint(equalTo: headerBar.centerYAnchor),

            removeButton.trailingAnchor.constraint(equalTo: importButton.leadingAnchor, constant: -6),
            removeButton.centerYAnchor.constraint(equalTo: headerBar.centerYAnchor),

            addButton.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -6),
            addButton.centerYAnchor.constraint(equalTo: headerBar.centerYAnchor),

            scrollView.topAnchor.constraint(equalTo: headerBar.bottomAnchor, constant: 6),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            scrollView.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: -6),

            statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            statusLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
        ])

        rebuildPreferredSetPopup()
    }

    private func rebuildPreferredSetPopup() {
        preferredSetPopup.removeAllItems()
        preferredSetIDByPopupIndex.removeAll(keepingCapacity: true)

        let allSets = IlluminaBarcodeKitRegistry.builtinKits() + customBarcodeSets
        for (index, set) in allSets.enumerated() {
            preferredSetPopup.addItem(withTitle: set.displayName)
            preferredSetIDByPopupIndex[index] = set.id
        }

        if let preferredBarcodeSetID,
           let selectionIndex = preferredSetIDByPopupIndex.first(where: { $0.value == preferredBarcodeSetID })?.key {
            preferredSetPopup.selectItem(at: selectionIndex)
        } else if !allSets.isEmpty {
            preferredSetPopup.selectItem(at: 0)
            preferredBarcodeSetID = preferredSetIDByPopupIndex[0]
        }
    }

    private func rebuildColumns() {
        for column in tableView.tableColumns.reversed() {
            tableView.removeTableColumn(column)
        }

        switch activeTab {
        case .samples:
            addColumn(id: "sampleID", title: "Sample ID", width: 140, editable: true)
            addColumn(id: "sampleName", title: "Sample Name", width: 140, editable: true)
            addColumn(id: "forwardBarcodeID", title: "5' Barcode ID", width: 120, editable: true)
            addColumn(id: "forwardSequence", title: "5' Sequence", width: 190, editable: true)
            addColumn(id: "reverseBarcodeID", title: "3' Barcode ID", width: 120, editable: true)
            addColumn(id: "reverseSequence", title: "3' Sequence", width: 190, editable: true)
            addColumn(id: "metadataCount", title: "Metadata", width: 80, editable: false)
            preferredSetLabel.isHidden = false
            preferredSetPopup.isHidden = false
            addButton.isHidden = false
            removeButton.isHidden = false

        case .barcodeSets:
            addColumn(id: "id", title: "Set ID", width: 190, editable: false)
            addColumn(id: "displayName", title: "Display Name", width: 220, editable: true)
            addColumn(id: "vendor", title: "Vendor", width: 120, editable: false)
            addColumn(id: "barcodeCount", title: "Barcodes", width: 90, editable: false)
            preferredSetLabel.isHidden = true
            preferredSetPopup.isHidden = true
            addButton.isHidden = true
            removeButton.isHidden = false
        }

        tableView.reloadData()
    }

    private func addColumn(id: String, title: String, width: CGFloat, editable: Bool) {
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(id))
        column.title = title
        column.width = width
        column.minWidth = min(width, 80)
        column.maxWidth = max(width, 800)
        if let cell = column.dataCell as? NSTextFieldCell {
            cell.isEditable = editable
            cell.lineBreakMode = .byTruncatingTail
        }
        tableView.addTableColumn(column)
    }

    public func numberOfRows(in tableView: NSTableView) -> Int {
        switch activeTab {
        case .samples:
            return sampleAssignments.count
        case .barcodeSets:
            return customBarcodeSets.count
        }
    }

    public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard let tableColumn else { return nil }
        switch activeTab {
        case .samples:
            guard row >= 0, row < sampleAssignments.count else { return nil }
            let assignment = sampleAssignments[row]
            switch tableColumn.identifier.rawValue {
            case "sampleID": return assignment.sampleID
            case "sampleName": return assignment.sampleName ?? ""
            case "forwardBarcodeID": return assignment.forwardBarcodeID ?? ""
            case "forwardSequence": return assignment.forwardSequence ?? ""
            case "reverseBarcodeID": return assignment.reverseBarcodeID ?? ""
            case "reverseSequence": return assignment.reverseSequence ?? ""
            case "metadataCount": return assignment.metadata.isEmpty ? "" : "\(assignment.metadata.count) field(s)"
            default: return nil
            }

        case .barcodeSets:
            guard row >= 0, row < customBarcodeSets.count else { return nil }
            let set = customBarcodeSets[row]
            switch tableColumn.identifier.rawValue {
            case "id": return set.id
            case "displayName": return set.displayName
            case "vendor": return set.vendor
            case "barcodeCount": return "\(set.barcodes.count)"
            default: return nil
            }
        }
    }

    public func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
        guard let tableColumn, let value = object as? String else { return }

        switch activeTab {
        case .samples:
            guard row >= 0, row < sampleAssignments.count else { return }
            let current = sampleAssignments[row]
            var sampleID = current.sampleID
            var sampleName = current.sampleName
            var forwardBarcodeID = current.forwardBarcodeID
            var forwardSequence = current.forwardSequence
            var reverseBarcodeID = current.reverseBarcodeID
            var reverseSequence = current.reverseSequence

            switch tableColumn.identifier.rawValue {
            case "sampleID":
                let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty {
                    sampleID = trimmed
                }
            case "sampleName":
                sampleName = value.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty
            case "forwardBarcodeID":
                forwardBarcodeID = value.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty
            case "forwardSequence":
                forwardSequence = value.trimmingCharacters(in: .whitespacesAndNewlines).uppercased().nilIfEmpty
            case "reverseBarcodeID":
                reverseBarcodeID = value.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty
            case "reverseSequence":
                reverseSequence = value.trimmingCharacters(in: .whitespacesAndNewlines).uppercased().nilIfEmpty
            default:
                return
            }

            sampleAssignments[row] = FASTQSampleBarcodeAssignment(
                sampleID: sampleID,
                sampleName: sampleName,
                forwardBarcodeID: forwardBarcodeID,
                forwardSequence: forwardSequence,
                reverseBarcodeID: reverseBarcodeID,
                reverseSequence: reverseSequence,
                metadata: current.metadata
            )
            statusLabel.stringValue = "Updated sample '\(sampleID)'."

        case .barcodeSets:
            guard row >= 0, row < customBarcodeSets.count else { return }
            guard tableColumn.identifier.rawValue == "displayName" else { return }
            let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }

            let current = customBarcodeSets[row]
            customBarcodeSets[row] = IlluminaBarcodeDefinition(
                id: current.id,
                displayName: trimmed,
                vendor: current.vendor,
                isDualIndexed: current.isDualIndexed,
                pairingMode: current.pairingMode,
                barcodes: current.barcodes
            )
            rebuildPreferredSetPopup()
            statusLabel.stringValue = "Renamed barcode set '\(trimmed)'."
        }
    }

    @objc private func tabChanged(_ sender: NSSegmentedControl) {
        activeTab = Tab(rawValue: sender.selectedSegment) ?? .samples
        rebuildColumns()
    }

    @objc private func preferredSetChanged(_ sender: NSPopUpButton) {
        preferredBarcodeSetID = preferredSetIDByPopupIndex[sender.indexOfSelectedItem]
    }

    @objc private func addClicked(_ sender: NSButton) {
        guard activeTab == .samples else { return }

        let nextNumber = sampleAssignments.count + 1
        let sampleID = String(format: "sample-%03d", nextNumber)
        sampleAssignments.append(
            FASTQSampleBarcodeAssignment(
                sampleID: sampleID,
                sampleName: nil,
                forwardBarcodeID: nil,
                forwardSequence: nil,
                reverseBarcodeID: nil,
                reverseSequence: nil,
                metadata: [:]
            )
        )
        tableView.reloadData()
        let newRow = sampleAssignments.count - 1
        if newRow >= 0 {
            tableView.selectRowIndexes(IndexSet(integer: newRow), byExtendingSelection: false)
            tableView.scrollRowToVisible(newRow)
        }
        statusLabel.stringValue = "Added \(sampleID)."
    }

    @objc private func removeClicked(_ sender: NSButton) {
        let row = tableView.selectedRow
        guard row >= 0 else { return }

        switch activeTab {
        case .samples:
            guard row < sampleAssignments.count else { return }
            let removed = sampleAssignments.remove(at: row)
            tableView.reloadData()
            statusLabel.stringValue = "Removed sample '\(removed.sampleID)'."
        case .barcodeSets:
            guard row < customBarcodeSets.count else { return }
            let removed = customBarcodeSets.remove(at: row)
            if preferredBarcodeSetID == removed.id {
                preferredBarcodeSetID = nil
            }
            rebuildPreferredSetPopup()
            tableView.reloadData()
            statusLabel.stringValue = "Removed custom set '\(removed.displayName)'."
        }
    }

    @objc private func importClicked(_ sender: NSButton) {
        guard let window else { return }

        let panel = NSOpenPanel()
        panel.allowedContentTypes = [
            .init(filenameExtension: "csv")!,
            .init(filenameExtension: "tsv")!,
            .init(filenameExtension: "txt")!,
        ]
        panel.allowsMultipleSelection = false
        panel.prompt = "Import"

        panel.beginSheetModal(for: window) { [weak self] response in
            guard let self, response == .OK, let url = panel.url else { return }

            switch self.activeTab {
            case .samples:
                do {
                    self.sampleAssignments = try FASTQSampleBarcodeCSV.load(from: url)
                    self.tableView.reloadData()
                    self.statusLabel.stringValue = "Imported \(self.sampleAssignments.count) sample assignment(s)."
                } catch {
                    self.statusLabel.stringValue = "Import failed: \(error.localizedDescription)"
                }

            case .barcodeSets:
                do {
                    let name = url.deletingPathExtension().lastPathComponent
                    let set = try IlluminaBarcodeKitRegistry.loadCustomKit(from: url, name: name)
                    if let idx = self.customBarcodeSets.firstIndex(where: { $0.id == set.id }) {
                        self.customBarcodeSets[idx] = set
                    } else {
                        self.customBarcodeSets.append(set)
                    }
                    self.rebuildPreferredSetPopup()
                    self.tableView.reloadData()
                    self.statusLabel.stringValue = "Imported custom barcode set '\(set.displayName)'."
                } catch {
                    self.statusLabel.stringValue = "Import failed: \(error.localizedDescription)"
                }
            }
        }
    }

    @objc private func exportClicked(_ sender: NSButton) {
        guard let window else { return }

        let panel = NSSavePanel()
        panel.allowedContentTypes = [.init(filenameExtension: "csv")!]
        panel.prompt = "Export"

        switch activeTab {
        case .samples:
            panel.nameFieldStringValue = "fastq-sample-metadata.csv"

        case .barcodeSets:
            guard tableView.selectedRow >= 0, tableView.selectedRow < customBarcodeSets.count else {
                statusLabel.stringValue = "Select a custom barcode set to export."
                return
            }
            let selected = customBarcodeSets[tableView.selectedRow]
            panel.nameFieldStringValue = "\(selected.id).csv"
        }

        panel.beginSheetModal(for: window) { [weak self] response in
            guard let self, response == .OK, let outputURL = panel.url else { return }
            do {
                let content: String
                switch self.activeTab {
                case .samples:
                    content = FASTQSampleBarcodeCSV.exportCSV(self.sampleAssignments)
                case .barcodeSets:
                    let selected = self.customBarcodeSets[self.tableView.selectedRow]
                    content = self.csvString(for: selected)
                }
                try content.write(to: outputURL, atomically: true, encoding: .utf8)
                self.statusLabel.stringValue = "Exported \(outputURL.lastPathComponent)."
            } catch {
                self.statusLabel.stringValue = "Export failed: \(error.localizedDescription)"
            }
        }
    }

    @objc private func saveClicked(_ sender: NSButton) {
        delegate?.fastqMetadataDrawerViewDidSave(self, fastqURL: fastqURL, metadata: currentMetadata())
        statusLabel.stringValue = "Saved FASTQ metadata."
    }

    private func csvString(for set: IlluminaBarcodeDefinition) -> String {
        var lines = ["id,i7_sequence,i5_sequence,sample_name"]
        lines.reserveCapacity(set.barcodes.count + 1)
        for barcode in set.barcodes {
            let row = [
                escapeCSV(barcode.id),
                escapeCSV(barcode.i7Sequence),
                escapeCSV(barcode.i5Sequence ?? ""),
                escapeCSV(barcode.sampleName ?? ""),
            ].joined(separator: ",")
            lines.append(row)
        }
        return lines.joined(separator: "\n") + "\n"
    }

    private func escapeCSV(_ value: String) -> String {
        if value.contains(",") || value.contains("\"") || value.contains("\n") {
            return "\"\(value.replacingOccurrences(of: "\"", with: "\"\""))\""
        }
        return value
    }
}

private extension String {
    var nilIfEmpty: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
