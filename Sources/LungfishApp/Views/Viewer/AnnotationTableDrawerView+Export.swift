// AnnotationTableDrawerView+Export.swift - CSV/TSV table export
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import SwiftUI
import UniformTypeIdentifiers
import os.log

private let exportLogger = Logger(subsystem: "com.lungfish.app", category: "TableExport")

extension AnnotationTableDrawerView {

    // MARK: - Export Action

    /// Exports the currently visible table contents as CSV or TSV.
    @objc func exportTableContents(_ sender: Any?) {
        let panel = NSSavePanel()
        panel.title = "Export Table"
        panel.nameFieldStringValue = defaultExportFilename()
        panel.allowedContentTypes = [.commaSeparatedText, .tabSeparatedText]
        panel.canCreateDirectories = true

        guard let window = self.window else { return }
        panel.beginSheetModal(for: window) { [weak self] response in
            guard response == .OK, let url = panel.url, let self else { return }

            let delimiter: String
            if url.pathExtension.lowercased() == "tsv" || url.pathExtension.lowercased() == "txt" {
                delimiter = "\t"
            } else {
                delimiter = ","
            }

            do {
                let content = self.buildExportContent(delimiter: delimiter)
                try content.write(to: url, atomically: true, encoding: .utf8)
                exportLogger.info("Exported \(self.exportRowCount()) rows to \(url.lastPathComponent)")
            } catch {
                exportLogger.error("Export failed: \(error)")
                let alert = NSAlert()
                alert.messageText = "Export Failed"
                alert.informativeText = error.localizedDescription
                alert.alertStyle = .warning
                alert.beginSheetModal(for: window)
            }
        }
    }

    // MARK: - Export Helpers

    /// Builds the full CSV/TSV string from the currently visible table.
    private func buildExportContent(delimiter: String) -> String {
        let columns = tableView.tableColumns
        var lines: [String] = []

        // Header row
        let headers = columns.map { escapeField($0.title, delimiter: delimiter) }
        lines.append(headers.joined(separator: delimiter))

        // Data rows
        let rowCount = exportRowCount()
        for row in 0..<rowCount {
            let fields = columns.map { col -> String in
                let value = cellValueString(for: col.identifier, row: row)
                return escapeField(value, delimiter: delimiter)
            }
            lines.append(fields.joined(separator: delimiter))
        }

        return lines.joined(separator: "\n") + "\n"
    }

    /// Extracts the display string for a given column/row, matching what the table shows.
    func cellValueString(for identifier: NSUserInterfaceItemIdentifier, row: Int) -> String {
        if activeTab == .samples {
            return sampleCellValueString(for: identifier, row: row)
        }
        if activeTab == .variants && activeVariantSubtab == .genotypes {
            return genotypeCellValueString(for: identifier, row: row)
        }

        guard row < displayedAnnotations.count else { return "" }
        let annotation = displayedAnnotations[row]

        switch identifier {
        // Annotation columns
        case Self.nameColumn:
            return annotation.name
        case Self.typeColumn:
            return annotation.type
        case Self.chromosomeColumn:
            return annotation.chromosome
        case Self.startColumn:
            return numberFormatter.string(from: NSNumber(value: annotation.start)) ?? "\(annotation.start)"
        case Self.endColumn:
            return numberFormatter.string(from: NSNumber(value: annotation.end)) ?? "\(annotation.end)"
        case Self.sizeColumn:
            return formatSize(annotation.end - annotation.start)
        case Self.strandColumn:
            return annotation.strand

        // Variant columns
        case Self.variantIdColumn:
            return annotation.name
        case Self.variantTypeColumn:
            return annotation.type
        case Self.variantChromColumn:
            return annotation.chromosome
        case Self.positionColumn:
            let displayPos = annotation.start + 1
            return numberFormatter.string(from: NSNumber(value: displayPos)) ?? "\(displayPos)"
        case Self.refColumn:
            return annotation.ref ?? ""
        case Self.altColumn:
            return annotation.alt ?? ""
        case Self.qualityColumn:
            if let q = annotation.quality {
                return q < 0 ? "." : String(format: "%.1f", q)
            }
            return "."
        case Self.filterColumn:
            return annotation.filter ?? "."
        case Self.samplesColumn:
            return "\(annotation.sampleCount ?? 0)"
        case Self.sourceColumn:
            return annotation.sourceFile ?? ""

        default:
            // Dynamic INFO columns
            if identifier.rawValue.hasPrefix("info_") {
                let infoKey = String(identifier.rawValue.dropFirst(5))
                return annotation.infoDict?[infoKey] ?? ""
            }
            return ""
        }
    }

    /// Extracts the display string for a sample table cell.
    private func sampleCellValueString(for identifier: NSUserInterfaceItemIdentifier, row: Int) -> String {
        guard row < displayedSamples.count else { return "" }
        let sample = displayedSamples[row]

        switch identifier {
        case Self.sampleVisibleColumn:
            return sample.isVisible ? "Yes" : "No"
        case Self.sampleNameColumn:
            return sample.name
        case Self.sampleSourceColumn:
            return sample.sourceFile
        default:
            if identifier.rawValue.hasPrefix("meta_") {
                let field = String(identifier.rawValue.dropFirst(5))
                return sample.metadata[field] ?? ""
            }
            return ""
        }
    }

    /// Returns the row count for the currently active data source.
    private func exportRowCount() -> Int {
        if activeTab == .samples { return displayedSamples.count }
        if activeTab == .variants && activeVariantSubtab == .genotypes { return displayedGenotypes.count }
        return displayedAnnotations.count
    }

    /// Generates a default filename based on the active tab.
    private func defaultExportFilename() -> String {
        switch activeTab {
        case .annotations: return "annotations.csv"
        case .variants:
            return activeVariantSubtab == .genotypes ? "genotypes.csv" : "variants.csv"
        case .samples: return "samples.csv"
        }
    }

    /// Escapes a field value for CSV/TSV output.
    /// Wraps in quotes if the field contains the delimiter, quotes, or newlines.
    private func escapeField(_ value: String, delimiter: String) -> String {
        if value.contains(delimiter) || value.contains("\"") || value.contains("\n") {
            return "\"" + value.replacingOccurrences(of: "\"", with: "\"\"") + "\""
        }
        return value
    }

    // MARK: - Column Configuration Popover

    /// Shows the column configuration popover anchored to the gear button.
    @objc func showColumnConfig(_ sender: Any?) {
        // Close existing popover if shown
        if let existing = columnConfigPopover, existing.isShown {
            existing.performClose(sender)
            return
        }

        let tabName = (activeTab == .variants && activeVariantSubtab == .genotypes)
            ? "variantGenotypes" : activeTab.prefsKey
        let currentColumns = buildColumnPreferenceList()

        let configView = ColumnConfigurationView(
            columns: currentColumns,
            tabName: tabName
        ) { [weak self] updatedColumns in
            guard let self else { return }
            DispatchQueue.main.async {
                MainActor.assumeIsolated {
                    self.applyColumnPreferences(updatedColumns)
                }
            }
        }

        let popover = NSPopover()
        popover.behavior = .transient
        popover.animates = true
        popover.contentViewController = NSHostingController(rootView: configView)
        popover.show(relativeTo: columnConfigButton.bounds, of: columnConfigButton, preferredEdge: .maxY)
        columnConfigPopover = popover
    }

    /// Builds the current column preference list from the table's visible columns.
    private func buildColumnPreferenceList() -> [ColumnPreference] {
        let tabName = (activeTab == .variants && activeVariantSubtab == .genotypes)
            ? "variantGenotypes" : activeTab.prefsKey

        // Try loading saved preferences first
        if let saved = ColumnPrefsKey.load(tab: tabName) {
            // Merge: keep saved prefs but add any new columns discovered since last save
            let savedIds = Set(saved.columns.map(\.id))
            var columns = saved.columns
            let nextOrder = (columns.map(\.order).max() ?? -1) + 1

            // Check current table for any columns not in saved prefs (new INFO/meta columns)
            for (i, col) in tableView.tableColumns.enumerated() {
                let colId = col.identifier.rawValue
                if !savedIds.contains(colId) {
                    columns.append(ColumnPreference(
                        id: colId,
                        title: col.title,
                        isVisible: true,
                        order: nextOrder + i
                    ))
                }
            }
            return columns.sorted { $0.order < $1.order }
        }

        // No saved prefs — build from current table columns
        return tableView.tableColumns.enumerated().map { (i, col) in
            ColumnPreference(
                id: col.identifier.rawValue,
                title: col.title,
                isVisible: true,
                order: i
            )
        }
    }

    /// Applies column visibility and ordering from preferences.
    private func applyColumnPreferences(_ prefs: [ColumnPreference]) {
        let visiblePrefs = prefs.filter(\.isVisible).sorted { $0.order < $1.order }
        let visibleIds = Set(visiblePrefs.map(\.id))

        // Remove columns that should be hidden
        for col in tableView.tableColumns.reversed() {
            if !visibleIds.contains(col.identifier.rawValue) {
                tableView.removeTableColumn(col)
            }
        }

        // Reorder remaining columns to match preference order (re-query live on each iteration)
        for (targetIndex, pref) in visiblePrefs.enumerated() {
            guard let colIndex = tableView.tableColumns.firstIndex(where: { $0.identifier.rawValue == pref.id }) else {
                continue
            }
            if colIndex != targetIndex && targetIndex < tableView.tableColumns.count {
                tableView.moveColumn(colIndex, toColumn: targetIndex)
            }
        }
    }
}
