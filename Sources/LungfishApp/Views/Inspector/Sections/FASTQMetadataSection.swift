// FASTQMetadataSection.swift - Inspector section for FASTQ sample metadata editing
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import SwiftUI
import LungfishIO

// MARK: - FASTQMetadataSectionViewModel

/// View model for FASTQ sample metadata editing in the Inspector.
///
/// Manages loading, editing, and autosaving PHA4GE-aligned metadata for
/// individual `.lungfishfastq` bundles. Edits are autosaved with a debounce
/// interval after each keystroke.
@Observable
@MainActor
public final class FASTQMetadataSectionViewModel {

    /// The loaded metadata, if any.
    var metadata: FASTQSampleMetadata?

    /// The bundle URL currently displayed.
    var bundleURL: URL?

    /// Whether the section is expanded.
    var isExpanded: Bool = true

    /// Whether the "Recommended" disclosure group is expanded.
    var showRecommended: Bool = true

    /// Whether the "Optional" disclosure group is expanded.
    var showOptional: Bool = false

    /// Whether the "Custom Fields" disclosure group is expanded.
    var showCustomFields: Bool = false

    /// Whether the "Template Fields" disclosure group is expanded.
    var showTemplateFields: Bool = true

    /// Whether the "Notes" disclosure group is expanded.
    var showNotes: Bool = true

    /// Whether the "Attachments" disclosure group is expanded.
    var showAttachments: Bool = false

    /// Whether metadata is available (controls section visibility).
    var hasMetadata: Bool { metadata != nil }

    // MARK: - Editing State

    /// New custom field key being typed.
    var newCustomKey: String = ""

    /// New custom field value being typed.
    var newCustomValue: String = ""

    /// Snapshot of metadata at last save, for revert support.
    private var lastSavedMetadata: FASTQSampleMetadata?

    /// Debounce work item for autosave.
    private var autosaveWorkItem: DispatchWorkItem?

    /// Debounce interval in seconds.
    private let autosaveInterval: TimeInterval = 0.5

    /// Whether there are unsaved changes.
    var hasUnsavedChanges: Bool {
        guard let metadata, let lastSavedMetadata else { return false }
        return metadata != lastSavedMetadata
    }

    // MARK: - Preset Store

    /// The current preset store for field suggestions.
    var presetStore: MetadataPresetStore = MetadataPresetStore()

    // MARK: - Attachment Manager

    /// Attachment manager for the current bundle.
    var attachmentManager: BundleAttachmentManager?

    /// List of current attachment filenames.
    var attachmentFilenames: [String] = []

    // MARK: - Callbacks

    /// Callback to persist metadata changes.
    var onSave: ((_ bundleURL: URL, _ metadata: FASTQSampleMetadata) -> Void)?

    // MARK: - Methods

    /// Loads metadata from a FASTQ bundle.
    func load(from bundleURL: URL) {
        self.bundleURL = bundleURL
        let sampleName = bundleURL.deletingPathExtension().lastPathComponent

        if let csvMeta = FASTQBundleCSVMetadata.load(from: bundleURL) {
            self.metadata = FASTQSampleMetadata(from: csvMeta, fallbackName: sampleName)
        } else {
            // No metadata yet; create a default
            self.metadata = FASTQSampleMetadata(sampleName: sampleName)
        }

        self.lastSavedMetadata = self.metadata

        // Set up attachment manager
        let mgr = BundleAttachmentManager(bundleURL: bundleURL)
        self.attachmentManager = mgr
        self.attachmentFilenames = mgr.listAttachments()

        // Sync attachment list from disk into metadata
        if !attachmentFilenames.isEmpty {
            metadata?.attachments = attachmentFilenames
        }
    }

    /// Clears the metadata display.
    func clear() {
        metadata = nil
        bundleURL = nil
        lastSavedMetadata = nil
        newCustomKey = ""
        newCustomValue = ""
        attachmentManager = nil
        attachmentFilenames = []
        autosaveWorkItem?.cancel()
    }

    /// Schedules an autosave after the debounce interval.
    func scheduleAutosave() {
        autosaveWorkItem?.cancel()
        let item = DispatchWorkItem { [weak self] in
            DispatchQueue.main.async {
                MainActor.assumeIsolated {
                    self?.performSave()
                }
            }
        }
        autosaveWorkItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + autosaveInterval, execute: item)
    }

    /// Immediately saves current metadata to disk.
    func performSave() {
        guard let bundleURL, let metadata else { return }

        // Add pending custom field if non-empty
        if !newCustomKey.isEmpty {
            self.metadata?.customFields[newCustomKey] = newCustomValue
            newCustomKey = ""
            newCustomValue = ""
        }

        lastSavedMetadata = self.metadata

        // Persist
        let legacyCSV = metadata.toLegacyCSV()
        try? FASTQBundleCSVMetadata.save(legacyCSV, to: bundleURL)

        onSave?(bundleURL, metadata)
    }

    /// Reverts to the last saved state.
    func revertToLastSaved() {
        guard let lastSavedMetadata else { return }
        metadata = lastSavedMetadata
    }

    /// Clears all metadata fields except sample name, resetting to defaults.
    func clearAllMetadata() {
        guard let currentName = metadata?.sampleName else { return }
        metadata = FASTQSampleMetadata(sampleName: currentName)
        scheduleAutosave()
    }

    /// Applies metadata cloned from another sample (preserving the current sample name).
    func applyClonedMetadata(_ source: FASTQSampleMetadata) {
        guard let currentName = metadata?.sampleName else { return }
        metadata = source.cloned(withName: currentName)
        scheduleAutosave()
    }

    /// Sets the metadata template and triggers autosave.
    func setTemplate(_ template: MetadataTemplate) {
        metadata?.metadataTemplate = template
        scheduleAutosave()
    }

    /// Adds a new custom field.
    func addCustomField() {
        guard !newCustomKey.isEmpty else { return }
        metadata?.customFields[newCustomKey] = newCustomValue
        newCustomKey = ""
        newCustomValue = ""
        scheduleAutosave()
    }

    /// Removes a custom field.
    func removeCustomField(_ key: String) {
        metadata?.customFields.removeValue(forKey: key)
        scheduleAutosave()
    }

    /// Adds a file attachment to the bundle.
    func addAttachment(from sourceURL: URL) {
        guard let mgr = attachmentManager else { return }
        do {
            let filename = try mgr.addAttachment(from: sourceURL)
            metadata?.addAttachment(filename)
            attachmentFilenames = mgr.listAttachments()
            scheduleAutosave()
        } catch {
            // Attachment add failed; logged by the manager
        }
    }

    /// Removes a file attachment from the bundle.
    func removeAttachment(_ filename: String) {
        guard let mgr = attachmentManager else { return }
        do {
            try mgr.removeAttachment(filename)
            metadata?.removeAttachment(filename)
            attachmentFilenames = mgr.listAttachments()
            scheduleAutosave()
        } catch {
            // Removal failed; logged by the manager
        }
    }

    /// Opens an attachment in the default application.
    func openAttachment(_ filename: String) {
        guard let mgr = attachmentManager else { return }
        let url = mgr.urlForAttachment(filename)
        NSWorkspace.shared.open(url)
    }

    // MARK: - Legacy API (for tests)

    /// Begins editing the current metadata (legacy support).
    var isEditing: Bool { true }

    /// Returns the editing metadata (now always the live metadata).
    var editingMetadata: FASTQSampleMetadata? {
        get { metadata }
        set { metadata = newValue }
    }

    /// Saves the current edits (legacy API — calls performSave).
    func save() {
        performSave()
    }

    /// Begins editing (no-op in autosave mode, metadata is always editable).
    func beginEditing() {
        // No-op: autosave mode means always editing
    }

    /// Cancels editing (reverts to last saved in autosave mode).
    func cancelEditing() {
        revertToLastSaved()
    }
}

// MARK: - FASTQMetadataSection View

/// SwiftUI section showing FASTQ sample metadata in the Inspector's Document tab.
///
/// Displays PHA4GE-aligned fields organized by template, with autosave on edit.
/// Supports template selection, notes, attachments, and custom fields.
public struct FASTQMetadataSection: View {
    @Bindable var viewModel: FASTQMetadataSectionViewModel

    public var body: some View {
        if viewModel.hasMetadata {
            DisclosureGroup(isExpanded: $viewModel.isExpanded) {
                VStack(alignment: .leading, spacing: 8) {
                    toolbar
                    Divider()
                    editableContent
                }
            } label: {
                Label("Sample Metadata", systemImage: "tag")
                    .font(.headline)
            }
        }
    }

    // MARK: - Toolbar

    @ViewBuilder
    private var toolbar: some View {
        HStack {
            // Template picker
            Picker("Template", selection: templateBinding) {
                Text("Clinical Sample").tag(MetadataTemplate.clinical)
                Text("Wastewater").tag(MetadataTemplate.wastewater)
                Text("Air Sample").tag(MetadataTemplate.airSample)
                Text("Environmental").tag(MetadataTemplate.environmental)
                Text("Custom").tag(MetadataTemplate.custom)
            }
            .controlSize(.small)
            .frame(maxWidth: 180)

            Spacer()

            Menu {
                Button("Revert to Last Saved") {
                    viewModel.revertToLastSaved()
                }
                .disabled(!viewModel.hasUnsavedChanges)

                Button("Clear All Metadata") {
                    viewModel.clearAllMetadata()
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            .menuStyle(.borderlessButton)
            .controlSize(.small)
            .frame(width: 24)
        }
    }

    private var templateBinding: Binding<MetadataTemplate> {
        Binding(
            get: { viewModel.metadata?.metadataTemplate ?? .clinical },
            set: { viewModel.setTemplate($0) }
        )
    }

    // MARK: - Editable Content

    @ViewBuilder
    private var editableContent: some View {
        // Required fields
        editableTextField("Sample Name", text: Binding(
            get: { viewModel.metadata?.sampleName ?? "" },
            set: {
                viewModel.metadata?.sampleName = $0
                viewModel.scheduleAutosave()
            }
        ))

        Picker("Sample Role", selection: Binding(
            get: { viewModel.metadata?.sampleRole ?? .testSample },
            set: {
                viewModel.metadata?.sampleRole = $0
                viewModel.scheduleAutosave()
            }
        )) {
            ForEach(SampleRole.allCases, id: \.self) { role in
                Text(role.displayLabel).tag(role)
            }
        }
        .controlSize(.small)

        // Recommended fields
        DisclosureGroup("Recommended Fields", isExpanded: $viewModel.showRecommended) {
            VStack(alignment: .leading, spacing: 4) {
                autosaveField("Sample Type", binding: metaBinding(\.sampleType), presetKey: "sample_type")
                autosaveField("Collection Date", binding: metaBinding(\.collectionDate))
                autosaveField("Geographic Location", binding: metaBinding(\.geoLocName), presetKey: "geo_loc_name")
                autosaveField("Host", binding: metaBinding(\.host), presetKey: "host")
                autosaveField("Host Disease", binding: metaBinding(\.hostDisease))
                autosaveField("Purpose", binding: metaBinding(\.purposeOfSequencing), presetKey: "purpose_of_sequencing")
                autosaveField("Instrument", binding: metaBinding(\.sequencingInstrument))
                autosaveField("Library Strategy", binding: metaBinding(\.libraryStrategy), presetKey: "library_strategy")
                autosaveField("Collected By", binding: metaBinding(\.sampleCollectedBy))
                autosaveField("Organism", binding: metaBinding(\.organism), presetKey: "organism")
            }
        }
        .font(.caption)

        // Template-specific fields
        if let template = viewModel.metadata?.metadataTemplate,
           !template.templateFields.isEmpty {
            DisclosureGroup("Template Fields (\(template.displayLabel))", isExpanded: $viewModel.showTemplateFields) {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(template.templateFields, id: \.key) { field in
                        autosaveField(field.label, binding: customFieldBinding(field.key), presetKey: field.key)
                    }
                }
            }
            .font(.caption)
        }

        // Batch context
        DisclosureGroup("Batch Context", isExpanded: $viewModel.showOptional) {
            VStack(alignment: .leading, spacing: 4) {
                autosaveField("Patient ID", binding: metaBinding(\.patientId))
                autosaveField("Run ID", binding: metaBinding(\.runId))
                autosaveField("Batch ID", binding: metaBinding(\.batchId))
                autosaveField("Plate Position", binding: metaBinding(\.platePosition))
            }
        }
        .font(.caption)

        // Notes
        DisclosureGroup("Notes", isExpanded: $viewModel.showNotes) {
            TextEditor(text: Binding(
                get: { viewModel.metadata?.notes ?? "" },
                set: {
                    viewModel.metadata?.notes = $0.isEmpty ? nil : $0
                    viewModel.scheduleAutosave()
                }
            ))
            .font(.caption)
            .frame(minHeight: 60, maxHeight: 120)
            .border(Color.secondary.opacity(0.3))
        }
        .font(.caption)

        // Attachments
        DisclosureGroup("Attachments (\(viewModel.attachmentFilenames.count))", isExpanded: $viewModel.showAttachments) {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(viewModel.attachmentFilenames, id: \.self) { filename in
                    HStack {
                        Image(systemName: "doc")
                            .foregroundStyle(.secondary)
                        Text(filename)
                            .font(.caption)
                            .lineLimit(1)
                            .truncationMode(.middle)
                        Spacer()
                        Button {
                            viewModel.openAttachment(filename)
                        } label: {
                            Image(systemName: "arrow.up.right.square")
                        }
                        .buttonStyle(.plain)
                        .controlSize(.small)
                        .help("Open in default application")
                        Button(role: .destructive) {
                            viewModel.removeAttachment(filename)
                        } label: {
                            Image(systemName: "minus.circle")
                        }
                        .buttonStyle(.plain)
                        .controlSize(.small)
                        .help("Remove attachment")
                    }
                }

                Button("Attach File\u{2026}") {
                    let panel = NSOpenPanel()
                    panel.canChooseFiles = true
                    panel.canChooseDirectories = false
                    panel.allowsMultipleSelection = true
                    panel.beginSheetModal(for: NSApp.keyWindow ?? NSApp.mainWindow ?? NSWindow()) { response in
                        DispatchQueue.main.async {
                            MainActor.assumeIsolated {
                                if response == .OK {
                                    for url in panel.urls {
                                        viewModel.addAttachment(from: url)
                                    }
                                }
                            }
                        }
                    }
                }
                .controlSize(.small)
            }
        }
        .font(.caption)

        // Custom fields
        DisclosureGroup("Custom Fields", isExpanded: $viewModel.showCustomFields) {
            VStack(alignment: .leading, spacing: 4) {
                let customKeys = (viewModel.metadata?.customFields ?? [:]).keys
                    .filter { key in
                        // Hide template fields from custom — they have their own section
                        let templateKeys = viewModel.metadata?.metadataTemplate?.templateFields.map(\.key) ?? []
                        return !templateKeys.contains(key)
                    }
                    .sorted()

                ForEach(customKeys, id: \.self) { key in
                    HStack {
                        Text(key)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(width: 100, alignment: .trailing)
                        TextField("Value", text: Binding(
                            get: { viewModel.metadata?.customFields[key] ?? "" },
                            set: {
                                viewModel.metadata?.customFields[key] = $0
                                viewModel.scheduleAutosave()
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .controlSize(.small)
                        Button(role: .destructive) {
                            viewModel.removeCustomField(key)
                        } label: {
                            Image(systemName: "minus.circle")
                        }
                        .buttonStyle(.plain)
                        .controlSize(.small)
                    }
                }

                // Add new custom field
                HStack {
                    TextField("Key", text: $viewModel.newCustomKey)
                        .textFieldStyle(.roundedBorder)
                        .controlSize(.small)
                        .frame(width: 100)
                    TextField("Value", text: $viewModel.newCustomValue)
                        .textFieldStyle(.roundedBorder)
                        .controlSize(.small)
                    Button {
                        viewModel.addCustomField()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .buttonStyle(.plain)
                    .controlSize(.small)
                    .disabled(viewModel.newCustomKey.isEmpty)
                }
            }
        }
        .font(.caption)
    }

    // MARK: - Field Helpers

    @ViewBuilder
    private func editableTextField(_ label: String, text: Binding<String>) -> some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 100, alignment: .trailing)
            TextField(label, text: text)
                .textFieldStyle(.roundedBorder)
                .controlSize(.small)
        }
    }

    @ViewBuilder
    private func autosaveField(
        _ label: String,
        binding: Binding<String>,
        presetKey: String? = nil
    ) -> some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 100, alignment: .trailing)

            let suggestions = presetKey.flatMap { viewModel.presetStore.suggestions(for: $0) } ?? []

            if suggestions.isEmpty {
                TextField(label, text: binding)
                    .textFieldStyle(.roundedBorder)
                    .controlSize(.small)
                    .onChange(of: binding.wrappedValue) { _, _ in
                        viewModel.scheduleAutosave()
                    }
            } else {
                // Combo-style: text field with menu for suggestions
                HStack(spacing: 2) {
                    TextField(label, text: binding)
                        .textFieldStyle(.roundedBorder)
                        .controlSize(.small)
                        .onChange(of: binding.wrappedValue) { _, _ in
                            viewModel.scheduleAutosave()
                        }

                    Menu {
                        ForEach(suggestions, id: \.self) { suggestion in
                            Button(suggestion) {
                                binding.wrappedValue = suggestion
                                viewModel.scheduleAutosave()
                            }
                        }
                    } label: {
                        Image(systemName: "chevron.down")
                            .imageScale(.small)
                    }
                    .menuStyle(.borderlessButton)
                    .frame(width: 16)
                }
            }
        }
    }

    /// Creates a binding for an optional String property on metadata with autosave.
    private func metaBinding(_ keyPath: WritableKeyPath<FASTQSampleMetadata, String?>) -> Binding<String> {
        Binding(
            get: { viewModel.metadata?[keyPath: keyPath] ?? "" },
            set: { newValue in
                viewModel.metadata?[keyPath: keyPath] = newValue.isEmpty ? nil : newValue
            }
        )
    }

    /// Creates a binding for a custom field stored in customFields.
    private func customFieldBinding(_ key: String) -> Binding<String> {
        Binding(
            get: { viewModel.metadata?.customFields[key] ?? "" },
            set: { newValue in
                if newValue.isEmpty {
                    viewModel.metadata?.customFields.removeValue(forKey: key)
                } else {
                    viewModel.metadata?.customFields[key] = newValue
                }
            }
        )
    }
}
