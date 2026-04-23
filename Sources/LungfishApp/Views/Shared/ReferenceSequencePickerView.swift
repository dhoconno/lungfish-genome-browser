// ReferenceSequencePickerView.swift - Reusable reference FASTA picker
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import SwiftUI
import UniformTypeIdentifiers
import LungfishIO

// MARK: - DiscoveredReference

/// A reference discovered during project scanning, with its resolved FASTA URL.
private struct DiscoveredReference: Identifiable {
    let id: String  // display name
    let name: String
    let bundleURL: URL
    let fastaURL: URL
}

// MARK: - ReferenceSequencePickerView

/// A reusable SwiftUI component for selecting a reference FASTA sequence.
///
/// Scans the entire project for `.lungfishref` bundles — both simple reference
/// bundles (with `ReferenceSequenceManifest`) and full genome bundles (with
/// `BundleManifest` and FASTA in `genome/` subdirectory). Also supports
/// browsing the filesystem for standalone FASTA files (including `.fa.gz`).
struct ReferenceSequencePickerView: View {

    /// The project directory URL. When `nil`, only filesystem browsing is available.
    let projectURL: URL?

    /// Binding to the selected reference FASTA URL.
    @Binding var selectedReferenceURL: URL?

    /// All reference bundles discovered in the project.
    @State private var discoveredRefs: [DiscoveredReference] = []

    /// The display name of the currently selected reference.
    @State private var selectedRefName: String = ""

    /// Whether a FASTA import is in progress.
    @State private var isImporting: Bool = false

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Reference")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)

            if discoveredRefs.isEmpty && selectedReferenceURL == nil {
                Text("No references found in project.")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            } else {
                Picker("", selection: $selectedRefName) {
                    ForEach(discoveredRefs) { ref in
                        Text(ref.name).tag(ref.name)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
            }

            Button("Browse\u{2026}") {
                browseForReference()
            }
            .controlSize(.small)

            if isImporting {
                HStack(spacing: 4) {
                    ProgressView().controlSize(.mini)
                    Text("Importing reference\u{2026}")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .task { loadReferences() }
        .onChange(of: selectedRefName) { _, newName in
            if let ref = discoveredRefs.first(where: { $0.name == newName }) {
                selectedReferenceURL = ref.fastaURL
            }
        }
    }

    // MARK: - Reference Loading

    private func loadReferences() {
        guard let projectURL else { return }

        let refs = ReferenceSequenceScanner.scanAll(in: projectURL).map { candidate in
            DiscoveredReference(
                id: candidate.id,
                name: candidate.displayName,
                bundleURL: candidate.sourceBundleURL ?? candidate.fastaURL.deletingLastPathComponent(),
                fastaURL: candidate.fastaURL
            )
        }

        discoveredRefs = refs.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }

        // Auto-select first if nothing selected
        if selectedReferenceURL == nil, let first = discoveredRefs.first {
            selectedRefName = first.name
            selectedReferenceURL = first.fastaURL
        } else if let current = selectedReferenceURL,
                  let match = discoveredRefs.first(where: { $0.fastaURL.path == current.path }) {
            selectedRefName = match.name
        }
    }

    // MARK: - Browse

    private func browseForReference() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.message = "Select a reference FASTA file"

        // Accept ALL FASTA variants including gzipped
        var types: [UTType] = []
        for ext in ["fasta", "fa", "fna", "gz", "fasta.gz"] {
            if let t = UTType(filenameExtension: ext) { types.append(t) }
        }
        // Also add .gzip type explicitly
        types.append(.gzip)
        if !types.isEmpty {
            panel.allowedContentTypes = types
        }

        guard let window = NSApp.keyWindow ?? NSApp.mainWindow else { return }
        panel.beginSheetModal(for: window) { response in
            guard response == .OK, let url = panel.url else { return }
            // Use the file directly — no import needed for Browse
            selectedReferenceURL = url
            // Add to picker as an ad-hoc entry
            let adHoc = DiscoveredReference(
                id: url.path,
                name: url.deletingPathExtension().lastPathComponent,
                bundleURL: url.deletingLastPathComponent(),
                fastaURL: url
            )
            if !discoveredRefs.contains(where: { $0.id == adHoc.id }) {
                discoveredRefs.append(adHoc)
            }
            selectedRefName = adHoc.name
        }
    }
}
