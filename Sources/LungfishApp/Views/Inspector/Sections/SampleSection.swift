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

    /// Per-sample metadata dictionaries.
    var sampleMetadata: [String: [String: String]] = [:]

    /// Source filenames keyed by sample name.
    var sourceFiles: [String: String] = [:]

    /// Whether variant data is available (controls section visibility).
    var hasVariantData: Bool = false

    /// Whether the section is expanded.
    var isExpanded: Bool = true

    /// The sample currently being edited (nil means none).
    var editingSample: String?

    /// Key-value pairs being edited for the current sample.
    var editingMetadata: [(key: String, value: String)] = []

    /// New key name being typed in the metadata editor.
    var newMetadataKey: String = ""

    /// New value being typed in the metadata editor.
    var newMetadataValue: String = ""

    /// Callback to persist metadata changes to the database.
    var onSaveMetadata: ((_ sampleName: String, _ metadata: [String: String]) -> Void)?

    /// Callback to import metadata from a file.
    var onImportMetadata: (() -> Void)?

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
    func update(
        sampleCount: Int,
        sampleNames: [String],
        metadataFields: [String],
        sampleMetadata: [String: [String: String]] = [:],
        sourceFiles: [String: String] = [:]
    ) {
        self.sampleCount = sampleCount
        self.sampleNames = sampleNames
        self.metadataFields = metadataFields
        self.sampleMetadata = sampleMetadata
        self.sourceFiles = sourceFiles
        self.hasVariantData = sampleCount > 0
    }

    /// Clears all sample data (e.g., when bundle is unloaded).
    func clear() {
        sampleCount = 0
        sampleNames = []
        metadataFields = []
        sampleMetadata = [:]
        sourceFiles = [:]
        hasVariantData = false
        displayState = SampleDisplayState()
        editingSample = nil
    }

    /// Begins editing metadata for a sample.
    func beginEditingMetadata(for sampleName: String) {
        editingSample = sampleName
        let metadata = sampleMetadata[sampleName] ?? [:]
        editingMetadata = metadata.sorted(by: { $0.key < $1.key }).map { (key: $0.key, value: $0.value) }
        newMetadataKey = ""
        newMetadataValue = ""
    }

    /// Saves the current metadata edits.
    func saveMetadataEdits() {
        guard let sampleName = editingSample else { return }
        var metadata: [String: String] = [:]
        for pair in editingMetadata where !pair.key.isEmpty {
            metadata[pair.key] = pair.value
        }
        sampleMetadata[sampleName] = metadata
        onSaveMetadata?(sampleName, metadata)
        editingSample = nil

        // Update metadata fields
        var allFields = Set<String>()
        for (_, meta) in sampleMetadata {
            allFields.formUnion(meta.keys)
        }
        metadataFields = allFields.sorted()
    }

    /// Cancels metadata editing.
    func cancelMetadataEdits() {
        editingSample = nil
        editingMetadata = []
    }

    /// Adds a new key-value pair to the editing metadata.
    func addMetadataField() {
        guard !newMetadataKey.isEmpty else { return }
        editingMetadata.append((key: newMetadataKey, value: newMetadataValue))
        newMetadataKey = ""
        newMetadataValue = ""
    }

    /// Removes a metadata field at the given index.
    func removeMetadataField(at index: Int) {
        guard index < editingMetadata.count else { return }
        editingMetadata.remove(at: index)
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
                    if !viewModel.sampleNames.isEmpty {
                        Divider()
                        sampleMetadataSection
                    }
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

    // MARK: - Sample Metadata Section

    @ViewBuilder
    private var sampleMetadataSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Sample Metadata")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                if viewModel.onImportMetadata != nil {
                    Button {
                        viewModel.onImportMetadata?()
                    } label: {
                        Label("Import...", systemImage: "square.and.arrow.down")
                    }
                    .buttonStyle(.borderless)
                    .font(.caption)
                }
            }

            ForEach(viewModel.sampleNames.prefix(50), id: \.self) { name in
                sampleMetadataRow(name)
            }
            if viewModel.sampleNames.count > 50 {
                Text("... and \(viewModel.sampleNames.count - 50) more samples")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
    }

    @ViewBuilder
    private func sampleMetadataRow(_ name: String) -> some View {
        let isEditing = viewModel.editingSample == name
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(name)
                    .font(.system(.caption, design: .monospaced))
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .truncationMode(.middle)
                Spacer()
                Button {
                    if isEditing {
                        viewModel.saveMetadataEdits()
                    } else {
                        viewModel.beginEditingMetadata(for: name)
                    }
                } label: {
                    Image(systemName: isEditing ? "checkmark.circle" : "pencil")
                        .font(.caption)
                }
                .buttonStyle(.borderless)
                if isEditing {
                    Button {
                        viewModel.cancelMetadataEdits()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.caption)
                    }
                    .buttonStyle(.borderless)
                }
            }

            // Source file
            if let sourceFile = viewModel.sourceFiles[name] {
                HStack(spacing: 4) {
                    Text("Source:")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                    Text(sourceFile)
                        .font(.system(.caption2, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
            }

            if isEditing {
                metadataEditor
            } else {
                // Display existing metadata
                let metadata = viewModel.sampleMetadata[name] ?? [:]
                if !metadata.isEmpty {
                    ForEach(metadata.keys.sorted(), id: \.self) { key in
                        HStack(spacing: 4) {
                            Text("\(key):")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                            Text(metadata[key] ?? "")
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 2)
    }

    @ViewBuilder
    private var metadataEditor: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Existing fields
            ForEach(Array(viewModel.editingMetadata.enumerated()), id: \.offset) { index, pair in
                HStack(spacing: 4) {
                    TextField("Key", text: Binding(
                        get: { viewModel.editingMetadata[index].key },
                        set: { viewModel.editingMetadata[index].key = $0 }
                    ))
                    .font(.system(.caption, design: .monospaced))
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 80)

                    TextField("Value", text: Binding(
                        get: { viewModel.editingMetadata[index].value },
                        set: { viewModel.editingMetadata[index].value = $0 }
                    ))
                    .font(.system(.caption, design: .monospaced))
                    .textFieldStyle(.roundedBorder)

                    Button {
                        viewModel.removeMetadataField(at: index)
                    } label: {
                        Image(systemName: "minus.circle")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    .buttonStyle(.borderless)
                }
            }

            // Add new field
            HStack(spacing: 4) {
                TextField("New key", text: $viewModel.newMetadataKey)
                    .font(.system(.caption, design: .monospaced))
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 80)

                TextField("New value", text: $viewModel.newMetadataValue)
                    .font(.system(.caption, design: .monospaced))
                    .textFieldStyle(.roundedBorder)

                Button {
                    viewModel.addMetadataField()
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.caption)
                }
                .buttonStyle(.borderless)
                .disabled(viewModel.newMetadataKey.isEmpty)
            }
        }
        .padding(.leading, 8)
    }
}
