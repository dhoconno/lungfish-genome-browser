// ColumnConfigurationPopover.swift - Column visibility and ordering configuration
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import SwiftUI
import os.log

private let columnLogger = Logger(subsystem: "com.lungfish.app", category: "ColumnConfig")

// MARK: - Column Preference Model

/// A single column's visibility and display order preference.
public struct ColumnPreference: Codable, Sendable, Identifiable, Equatable {
    public var id: String  // Column identifier rawValue
    public var title: String
    public var isVisible: Bool
    public var order: Int

    public init(id: String, title: String, isVisible: Bool, order: Int) {
        self.id = id
        self.title = title
        self.isVisible = isVisible
        self.order = order
    }
}

/// Column preferences for a single tab.
public struct TabColumnPreferences: Codable, Sendable, Equatable {
    public var columns: [ColumnPreference]

    public init(columns: [ColumnPreference]) {
        self.columns = columns
    }

    /// Returns visible columns sorted by order.
    public var visibleColumns: [ColumnPreference] {
        columns.filter(\.isVisible).sorted { $0.order < $1.order }
    }

    /// Resets all columns to visible and restores default order.
    public mutating func resetToDefaults() {
        for i in columns.indices {
            columns[i].isVisible = true
            columns[i].order = i
        }
    }
}

// MARK: - Persistence Key

/// Keys for UserDefaults persistence of column preferences.
enum ColumnPrefsKey {
    static func key(for tabName: String) -> String {
        "ColumnPreferences_\(tabName)"
    }

    static func save(_ prefs: TabColumnPreferences, tab: String) {
        do {
            let data = try JSONEncoder().encode(prefs)
            UserDefaults.standard.set(data, forKey: key(for: tab))
        } catch {
            columnLogger.warning("Failed to save column prefs for \(tab): \(error)")
        }
    }

    static func load(tab: String) -> TabColumnPreferences? {
        guard let data = UserDefaults.standard.data(forKey: key(for: tab)) else { return nil }
        do {
            return try JSONDecoder().decode(TabColumnPreferences.self, from: data)
        } catch {
            columnLogger.warning("Failed to load column prefs for \(tab): \(error)")
            return nil
        }
    }
}

// MARK: - SwiftUI View

/// SwiftUI view for the column configuration popover.
///
/// Shows a list of columns with visibility toggles and drag-to-reorder.
/// Presented inside an NSPopover anchored to the gear button.
struct ColumnConfigurationView: View {
    @State var columns: [ColumnPreference]
    let tabName: String
    let onColumnsChanged: ([ColumnPreference]) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("Columns")
                    .font(.headline)
                Spacer()
                Button("Reset") {
                    resetToDefaults()
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)
            .padding(.bottom, 6)

            Divider()

            // Column list with toggles and reorder
            List {
                ForEach($columns) { $column in
                    HStack(spacing: 8) {
                        Toggle("", isOn: $column.isVisible)
                            .toggleStyle(.checkbox)
                            .labelsHidden()
                            .onChange(of: column.isVisible) { _, _ in
                                applyChanges()
                            }
                        Text(column.title.isEmpty ? "(visibility)" : column.title)
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle(.tertiary)
                            .font(.caption)
                    }
                    .padding(.vertical, 1)
                }
                .onMove(perform: moveColumns)
            }
            .listStyle(.plain)
            .frame(minHeight: 120)
        }
        .frame(width: 220, height: min(CGFloat(columns.count) * 28 + 60, 400))
    }

    private func moveColumns(from source: IndexSet, to destination: Int) {
        columns.move(fromOffsets: source, toOffset: destination)
        // Reassign order indices
        for i in columns.indices {
            columns[i].order = i
        }
        applyChanges()
    }

    private func resetToDefaults() {
        for i in columns.indices {
            columns[i].isVisible = true
            columns[i].order = i
        }
        applyChanges()
    }

    private func applyChanges() {
        let prefs = TabColumnPreferences(columns: columns)
        ColumnPrefsKey.save(prefs, tab: tabName)
        onColumnsChanged(columns)
    }
}
