// PrimerSchemePickerView.swift - Menu picker for primer scheme bundles
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import SwiftUI
import LungfishIO

/// A standard menu picker for the single primer scheme choice, with built-in
/// and project-local sections plus an explicit file chooser button.
struct PrimerSchemePickerView: View {
    let builtIn: [PrimerSchemeBundle]
    let projectLocal: [PrimerSchemeBundle]
    @Binding var selectedSchemeID: String?
    let onBrowse: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Picker("Primer Scheme", selection: $selectedSchemeID) {
                Text("Choose a primer scheme").tag(String?.none)
                if !builtIn.isEmpty {
                    Section("Built-in") {
                        ForEach(builtIn, id: \.manifest.name) { scheme in
                            Text(scheme.manifest.displayName).tag(Optional(scheme.manifest.name))
                        }
                    }
                }
                if !projectLocal.isEmpty {
                    Section("In This Project") {
                        ForEach(projectLocal, id: \.manifest.name) { scheme in
                            Text(scheme.manifest.displayName).tag(Optional(scheme.manifest.name))
                        }
                    }
                }
            }
            .pickerStyle(.menu)
            .accessibilityIdentifier("primer-scheme-picker")

            HStack {
                Button(action: onBrowse) {
                    Label("Choose Scheme…", systemImage: "folder")
                }
                .accessibilityIdentifier("primer-scheme-browse-button")

                if let selectedScheme {
                    Text(selectedScheme.manifest.displayName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
    }

    private var selectedScheme: PrimerSchemeBundle? {
        guard let selectedSchemeID else { return nil }
        return (builtIn + projectLocal).first { $0.manifest.name == selectedSchemeID }
    }
}
