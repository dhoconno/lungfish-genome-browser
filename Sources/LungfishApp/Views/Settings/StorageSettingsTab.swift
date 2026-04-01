// StorageSettingsTab.swift - Storage preferences tab
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import SwiftUI
import LungfishCore

/// Storage preferences: database storage location.
///
/// Allows the user to choose a custom directory for Kraken2 metagenomics
/// databases. Changes are persisted to UserDefaults and communicated to
/// ``MetagenomicsDatabaseRegistry`` via notification.
struct StorageSettingsTab: View {

    @State private var settings = AppSettings.shared
    @State private var displayPath: String = ""
    @State private var isDefault: Bool = true
    @State private var showingMigrateAlert: Bool = false
    @State private var pendingNewURL: URL?

    var body: some View {
        Form {
            Section("Database Storage") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Kraken2 and other metagenomics databases are stored at this location.")
                        .font(.callout)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 8) {
                        Image(systemName: "folder")
                            .foregroundStyle(.secondary)
                        Text(displayPath)
                            .font(.system(.body, design: .monospaced))
                            .lineLimit(2)
                            .truncationMode(.middle)
                            .textSelection(.enabled)
                        Spacer()
                    }
                    .padding(8)
                    .background(Color(nsColor: .controlBackgroundColor))
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                    HStack(spacing: 12) {
                        Button("Choose...") {
                            chooseDirectory()
                        }

                        Button("Reveal in Finder") {
                            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: displayPath)
                        }
                        .disabled(!FileManager.default.fileExists(atPath: displayPath))

                        Spacer()

                        Button("Default") {
                            resetToDefault()
                        }
                        .disabled(isDefault)
                    }

                    if !isDefault {
                        HStack(spacing: 4) {
                            Image(systemName: "info.circle")
                                .foregroundStyle(.blue)
                                .font(.caption)
                            Text("Custom location. Click Default to restore ~/.lungfish/databases/")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Section("About Database Storage") {
                VStack(alignment: .leading, spacing: 6) {
                    Label("Databases can be several gigabytes in size", systemImage: "internaldrive")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    Label("Choose an external drive or NAS for large collections", systemImage: "externaldrive")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    Label("The manifest file tracks installed databases", systemImage: "doc.text")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            }

            HStack {
                Spacer()
                Button("Restore Defaults") {
                    resetToDefault()
                    settings.resetSection(.storage)
                }
            }
        }
        .formStyle(.grouped)
        .onAppear {
            refreshDisplay()
        }
        .alert(
            "Move Existing Databases?",
            isPresented: $showingMigrateAlert,
            presenting: pendingNewURL
        ) { newURL in
            Button("Move Databases") {
                applyNewLocation(newURL, migrate: true)
            }
            Button("Use Empty Location") {
                applyNewLocation(newURL, migrate: false)
            }
            Button("Cancel", role: .cancel) {
                pendingNewURL = nil
            }
        } message: { _ in
            Text("Would you like to move existing databases to the new location, or start fresh?")
        }
    }

    // MARK: - Actions

    private func chooseDirectory() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        panel.allowsMultipleSelection = false
        panel.prompt = "Choose"
        panel.message = "Select a directory for database storage"

        panel.begin { response in
            guard response == .OK, let url = panel.url else { return }

            // Check if there are existing databases at the current location.
            let currentPath = settings.databaseStorageURL
            let kraken2Dir = currentPath.appendingPathComponent("kraken2")
            if FileManager.default.fileExists(atPath: kraken2Dir.path) {
                pendingNewURL = url
                showingMigrateAlert = true
            } else {
                applyNewLocation(url, migrate: false)
            }
        }
    }

    private func applyNewLocation(_ url: URL, migrate: Bool) {
        settings.databaseStorageURL = url
        // The MetagenomicsDatabaseRegistry will pick up the change via notification
        // or the next time it reads UserDefaults.
        refreshDisplay()
        pendingNewURL = nil
    }

    private func resetToDefault() {
        UserDefaults.standard.removeObject(forKey: AppSettings.databaseStorageLocationKey)
        NotificationCenter.default.post(name: .databaseStorageLocationChanged, object: nil)
        refreshDisplay()
    }

    private func refreshDisplay() {
        displayPath = settings.databaseStorageURL.path
        isDefault = settings.isDatabaseStorageDefault
    }
}
