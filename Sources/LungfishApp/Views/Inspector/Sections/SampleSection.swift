// SampleSection.swift - Inspector section for sample display controls
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import SwiftUI
import LungfishCore

// MARK: - SampleSectionViewModel

/// View model for the sample display controls inspector section.
///
/// Manages genotype row visibility, row height mode, and sample
/// sort/filter state. Changes are propagated via notification to the viewer.
@Observable
@MainActor
public final class SampleSectionViewModel {

    // MARK: - Properties

    /// Current sample display state (row visibility, height, sort, filter).
    var displayState: SampleDisplayState = SampleDisplayState()

    /// Total number of samples in the variant database.
    var sampleCount: Int = 0

    /// All sample names from the VCF.
    var sampleNames: [String] = []

    /// Available metadata field names for sorting/filtering.
    var metadataFields: [String] = []

    /// Whether variant data is available (controls section visibility).
    var hasVariantData: Bool = false

    /// Whether the section is expanded.
    var isExpanded: Bool = true

    // MARK: - Callbacks

    /// Called when sample display state changes.
    var onDisplayStateChanged: ((SampleDisplayState) -> Void)?

    // MARK: - Computed Properties

    /// Number of currently visible samples.
    var visibleSampleCount: Int {
        sampleNames.filter { !displayState.hiddenSamples.contains($0) }.count
    }

    /// Whether any samples are hidden.
    var hasHiddenSamples: Bool {
        !displayState.hiddenSamples.isEmpty
    }

    // MARK: - Methods

    /// Updates the section with sample data from a variant database.
    func update(sampleCount: Int, sampleNames: [String], metadataFields: [String]) {
        self.sampleCount = sampleCount
        self.sampleNames = sampleNames
        self.metadataFields = metadataFields
        self.hasVariantData = sampleCount > 0
    }

    /// Clears all sample data (e.g., when bundle is unloaded).
    func clear() {
        sampleCount = 0
        sampleNames = []
        metadataFields = []
        hasVariantData = false
        displayState = SampleDisplayState()
    }

    /// Toggles genotype row visibility and notifies listeners.
    func toggleGenotypeRows() {
        displayState.showGenotypeRows.toggle()
        notifyStateChanged()
    }

    /// Sets the row height mode and notifies listeners.
    func setRowHeightMode(_ mode: RowHeightMode) {
        displayState.rowHeightMode = mode
        notifyStateChanged()
    }

    /// Toggles visibility of a specific sample.
    func toggleSampleVisibility(_ name: String) {
        if displayState.hiddenSamples.contains(name) {
            displayState.hiddenSamples.remove(name)
        } else {
            displayState.hiddenSamples.insert(name)
        }
        notifyStateChanged()
    }

    /// Shows all samples.
    func showAllSamples() {
        displayState.hiddenSamples.removeAll()
        notifyStateChanged()
    }

    /// Hides all samples.
    func hideAllSamples() {
        displayState.hiddenSamples = Set(sampleNames)
        notifyStateChanged()
    }

    /// Adds a sort field.
    func addSortField(_ field: String, ascending: Bool = true) {
        // Remove existing sort on same field
        displayState.sortFields.removeAll { $0.field == field }
        displayState.sortFields.append(SortField(field: field, ascending: ascending))
        notifyStateChanged()
    }

    /// Removes a sort field.
    func removeSortField(at index: Int) {
        guard index < displayState.sortFields.count else { return }
        displayState.sortFields.remove(at: index)
        notifyStateChanged()
    }

    /// Clears all sort fields.
    func clearSortFields() {
        displayState.sortFields.removeAll()
        notifyStateChanged()
    }

    /// Adds a sample filter.
    func addFilter(field: String, op: FilterOp, value: String) {
        let filter = SampleFilter(field: field, op: op, value: value)
        displayState.filters.append(filter)
        notifyStateChanged()
    }

    /// Removes a filter at the given index.
    func removeFilter(at index: Int) {
        guard index < displayState.filters.count else { return }
        displayState.filters.remove(at: index)
        notifyStateChanged()
    }

    /// Clears all filters.
    func clearFilters() {
        displayState.filters.removeAll()
        notifyStateChanged()
    }

    /// Resets display state to defaults.
    func resetToDefaults() {
        displayState = SampleDisplayState()
        notifyStateChanged()
    }

    /// Notifies listeners of display state changes.
    private func notifyStateChanged() {
        if let onDisplayStateChanged {
            onDisplayStateChanged(displayState)
            return
        }

        NotificationCenter.default.post(
            name: .sampleDisplayStateChanged,
            object: self,
            userInfo: [
                NotificationUserInfoKey.sampleDisplayState: displayState
            ]
        )
    }
}

// MARK: - SampleSection View

/// SwiftUI section showing sample display controls when variant data is available.
///
/// Provides controls for genotype row visibility, row height mode,
/// sample visibility toggles, and sort/filter configuration.
public struct SampleSection: View {
    @Bindable var viewModel: SampleSectionViewModel

    public var body: some View {
        if viewModel.hasVariantData {
            DisclosureGroup(isExpanded: $viewModel.isExpanded) {
                VStack(alignment: .leading, spacing: 8) {
                    sampleSummary
                    Divider()
                    genotypeRowControls
                    Divider()
                    sampleVisibilitySection
                }
            } label: {
                Label("Sample Display", systemImage: "person.3")
                    .font(.headline)
            }
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var sampleSummary: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Samples")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(width: 60, alignment: .trailing)
                Text("\(viewModel.sampleCount)")
                    .font(.system(.body, design: .monospaced))
            }
            if viewModel.hasHiddenSamples {
                HStack {
                    Text("Visible")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(width: 60, alignment: .trailing)
                    Text("\(viewModel.visibleSampleCount) of \(viewModel.sampleCount)")
                        .font(.system(.body, design: .monospaced))
                }
            }
        }
    }

    @ViewBuilder
    private var genotypeRowControls: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle(isOn: Binding(
                get: { viewModel.displayState.showGenotypeRows },
                set: { _ in viewModel.toggleGenotypeRows() }
            )) {
                Text("Show Genotype Rows")
            }
            .toggleStyle(.switch)
            .controlSize(.small)

            if viewModel.displayState.showGenotypeRows {
                HStack {
                    Text("Row Height")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Picker("", selection: Binding(
                        get: { viewModel.displayState.rowHeightMode },
                        set: { viewModel.setRowHeightMode($0) }
                    )) {
                        Text("Auto").tag(RowHeightMode.automatic)
                        Text("Squished").tag(RowHeightMode.squished)
                        Text("Expanded").tag(RowHeightMode.expanded)
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 160)
                }
            }
        }
    }

    @ViewBuilder
    private var sampleVisibilitySection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Sample Visibility")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Button {
                    viewModel.showAllSamples()
                } label: {
                    Label("All", systemImage: "eye")
                }
                .buttonStyle(.borderless)
                .font(.caption)

                Button {
                    viewModel.hideAllSamples()
                } label: {
                    Label("None", systemImage: "eye.slash")
                }
                .buttonStyle(.borderless)
                .font(.caption)
            }

            if viewModel.sampleNames.count <= 50 {
                // Show individual toggles for small sample counts
                ForEach(viewModel.sampleNames, id: \.self) { name in
                    sampleToggle(name)
                }
            } else {
                // For large sample counts, show summary
                Text("\(viewModel.visibleSampleCount) of \(viewModel.sampleCount) samples visible")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if viewModel.hasHiddenSamples {
                    Button("Reset Visibility") {
                        viewModel.showAllSamples()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
        }
    }

    @ViewBuilder
    private func sampleToggle(_ name: String) -> some View {
        let isVisible = !viewModel.displayState.hiddenSamples.contains(name)
        HStack {
            Image(systemName: isVisible ? "eye" : "eye.slash")
                .font(.caption)
                .foregroundStyle(isVisible ? .primary : .secondary)
                .frame(width: 16)
            Text(name)
                .font(.system(.caption, design: .monospaced))
                .lineLimit(1)
                .truncationMode(.middle)
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.toggleSampleVisibility(name)
        }
    }
}
