// ReferenceSequencePickerView.swift - Reusable reference FASTA picker
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import SwiftUI
import UniformTypeIdentifiers
import LungfishIO

// MARK: - ReferenceSequencePickerView

/// A reusable SwiftUI component for selecting a reference FASTA sequence.
///
/// Lists all `.lungfishref` bundles in the project's Reference Sequences folder
/// via ``ReferenceSequenceFolder/listReferences(in:)``. Includes a "Browse..."
/// button that opens an `NSOpenPanel` (presented as a sheet, never modal) for
/// selecting a FASTA from the filesystem. When a filesystem FASTA is selected,
/// it is auto-imported into the project's Reference Sequences folder.
///
/// ## Usage
///
/// ```swift
/// @State private var referenceURL: URL?
///
/// ReferenceSequencePickerView(
///     projectURL: myProjectURL,
///     selectedReferenceURL: $referenceURL
/// )
/// ```
///
/// ## Threading
///
/// All UI updates use `DispatchQueue.main.async { MainActor.assumeIsolated { } }`
/// per the project convention for background-to-main dispatch in Swift 6.2.
struct ReferenceSequencePickerView: View {

    /// The project directory URL. When `nil`, only filesystem browsing is available.
    let projectURL: URL?

    /// Binding to the selected reference FASTA URL within a `.lungfishref` bundle.
    @Binding var selectedReferenceURL: URL?

    /// All reference bundles discovered in the project.
    @State private var projectReferences: [(url: URL, manifest: ReferenceSequenceManifest)] = []

    /// The display name of the currently selected reference (used as picker tag).
    @State private var selectedReferenceName: String = ""

    /// Whether a FASTA import is in progress.
    @State private var isImporting: Bool = false

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Reference Sequence")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                if projectReferences.isEmpty && selectedReferenceURL == nil {
                    Text("No references in project")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Picker("", selection: $selectedReferenceName) {
                        ForEach(projectReferences, id: \.manifest.name) { ref in
                            Text(ref.manifest.name).tag(ref.manifest.name)
                        }
                        // Show externally selected file if not yet in project
                        if let url = selectedReferenceURL,
                           !projectReferences.contains(where: { $0.manifest.name == selectedReferenceName }) {
                            Text(url.lastPathComponent).tag(url.lastPathComponent)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                }

                Button("Browse\u{2026}") {
                    browseForReference()
                }
                .controlSize(.small)
            }

            if isImporting {
                HStack(spacing: 4) {
                    ProgressView()
                        .controlSize(.mini)
                    Text("Importing reference\u{2026}")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .task { loadReferences() }
        .onChange(of: selectedReferenceName) { _, newName in
            syncSelectionFromName(newName)
        }
    }

    // MARK: - Reference Loading

    /// Scans the entire project for `.lungfishref` bundles and populates the picker.
    ///
    /// Searches both the dedicated "Reference Sequences" folder AND the entire
    /// project tree (Downloads, project root, etc.) so that genome bundles
    /// downloaded from NCBI or imported via other paths are discoverable.
    private func loadReferences() {
        guard let projectURL else { return }

        // Start with the dedicated Reference Sequences folder
        var allRefs = ReferenceSequenceFolder.listReferences(in: projectURL)
        let knownPaths = Set(allRefs.map(\.url.path))

        // Also scan the entire project recursively for .lungfishref bundles
        let fm = FileManager.default
        if let enumerator = fm.enumerator(
            at: projectURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        ) {
            for case let url as URL in enumerator {
                if url.pathExtension == "lungfishref" && !knownPaths.contains(url.path) {
                    // Try to read manifest
                    let manifestURL = url.appendingPathComponent("manifest.json")
                    if let data = try? Data(contentsOf: manifestURL),
                       let manifest = try? {
                           let decoder = JSONDecoder()
                           decoder.dateDecodingStrategy = .iso8601
                           return try decoder.decode(ReferenceSequenceManifest.self, from: data)
                       }() {
                        allRefs.append((url, manifest))
                    } else {
                        // No manifest — check if there's a FASTA inside and create a synthetic manifest
                        let fastaExtensions = ["fasta", "fa", "fna"]
                        if let contents = try? fm.contentsOfDirectory(at: url, includingPropertiesForKeys: nil),
                           let fastaFile = contents.first(where: { fastaExtensions.contains($0.pathExtension.lowercased()) }) {
                            let syntheticManifest = ReferenceSequenceManifest(
                                name: url.deletingPathExtension().lastPathComponent,
                                createdAt: Date(),
                                sourceFilename: fastaFile.lastPathComponent,
                                fastaFilename: fastaFile.lastPathComponent
                            )
                            allRefs.append((url, syntheticManifest))
                        }
                    }
                    enumerator.skipDescendants() // Don't recurse into .lungfishref bundles
                }
            }
        }

        projectReferences = allRefs.sorted { $0.manifest.name < $1.manifest.name }

        // Auto-select the first reference if nothing is selected yet
        if selectedReferenceURL == nil, let first = projectReferences.first {
            selectedReferenceName = first.manifest.name
            selectedReferenceURL = ReferenceSequenceFolder.fastaURL(in: first.url)
        } else if let current = selectedReferenceURL {
            // Restore picker selection to match the current URL
            if let match = projectReferences.first(where: {
                ReferenceSequenceFolder.fastaURL(in: $0.url)?.path == current.path
            }) {
                selectedReferenceName = match.manifest.name
            }
        }
    }

    /// Updates the bound URL when the picker selection changes.
    private func syncSelectionFromName(_ name: String) {
        if let ref = projectReferences.first(where: { $0.manifest.name == name }) {
            selectedReferenceURL = ReferenceSequenceFolder.fastaURL(in: ref.url)
        }
    }

    // MARK: - Browse

    /// Opens an NSOpenPanel as a sheet to browse for a FASTA file.
    ///
    /// Uses `beginSheetModal` per macOS 26 rules (never `runModal()`).
    /// When a file is selected it is auto-imported into the project via
    /// ``ReferenceSequenceFolder/importReference(from:into:displayName:)``.
    private func browseForReference() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.message = "Select a reference FASTA file"

        // Build allowed content types for FASTA files
        var types: [UTType] = []
        if let fasta = UTType(filenameExtension: "fasta") { types.append(fasta) }
        if let fa = UTType(filenameExtension: "fa") { types.append(fa) }
        if let fna = UTType(filenameExtension: "fna") { types.append(fna) }
        if let gz = UTType(filenameExtension: "gz") { types.append(gz) }
        if !types.isEmpty {
            panel.allowedContentTypes = types
        }

        guard let window = NSApp.keyWindow else { return }
        panel.beginSheetModal(for: window) { response in
            guard response == .OK, let url = panel.url else { return }
            handleSelectedFASTA(url)
        }
    }

    /// Imports a user-selected FASTA into the project and updates the picker.
    private func handleSelectedFASTA(_ url: URL) {
        guard let projectURL else {
            // No project -- use the file directly without importing
            selectedReferenceURL = url
            selectedReferenceName = url.lastPathComponent
            return
        }

        isImporting = true
        Task.detached {
            let importedBundleURL = try? ReferenceSequenceFolder.importReference(
                from: url,
                into: projectURL
            )
            DispatchQueue.main.async { MainActor.assumeIsolated {
                isImporting = false
                loadReferences()
                if let bundleURL = importedBundleURL,
                   let fastaURL = ReferenceSequenceFolder.fastaURL(in: bundleURL) {
                    selectedReferenceURL = fastaURL
                    if let ref = projectReferences.first(where: {
                        ReferenceSequenceFolder.fastaURL(in: $0.url)?.path == fastaURL.path
                    }) {
                        selectedReferenceName = ref.manifest.name
                    }
                }
            }}
        }
    }
}
