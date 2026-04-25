// PrimerSchemeInspectorView.swift - Read-only inspector pane for a .lungfishprimers bundle
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import SwiftUI
import LungfishIO

/// Read-only inspector pane shown when the user selects a `.lungfishprimers`
/// bundle in the project sidebar. Surfaces the manifest's headline metadata,
/// the primer/amplicon counts, and the declared reference accessions so the
/// user can eyeball a scheme before applying it to a BAM.
struct PrimerSchemeInspectorView: View {
    let bundle: PrimerSchemeBundle

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(bundle.manifest.displayName)
                .font(.title2)
                .fixedSize(horizontal: false, vertical: true)

            if let description = bundle.manifest.description {
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Divider()

            countsRow
            referenceRow

            if let organism = bundle.manifest.organism {
                captionRow(label: "Organism", value: organism)
            }
            if let source = bundle.manifest.source {
                captionRow(label: "Source", value: source)
            }
            if let version = bundle.manifest.version {
                captionRow(label: "Version", value: version)
            }

            if let attachments = bundle.manifest.attachments, !attachments.isEmpty {
                Divider()
                Text("Attachments")
                    .font(.subheadline)
                ForEach(attachments, id: \.path) { attachment in
                    captionRow(label: attachment.path, value: attachment.description ?? "")
                }
            }

            Spacer()
        }
        .padding(16)
    }

    private var countsRow: some View {
        HStack(spacing: 16) {
            metric(value: "\(bundle.manifest.primerCount)", label: "Primers")
            metric(value: "\(bundle.manifest.ampliconCount)", label: "Amplicons")
        }
    }

    private var referenceRow: some View {
        VStack(alignment: .leading, spacing: 4) {
            captionRow(label: "Reference", value: bundle.manifest.canonicalAccession)
            if !bundle.manifest.equivalentAccessions.isEmpty {
                captionRow(
                    label: "Equivalent",
                    value: bundle.manifest.equivalentAccessions.joined(separator: ", ")
                )
            }
        }
    }

    private func metric(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.title3)
                .monospacedDigit()
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func captionRow(label: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 110, alignment: .trailing)
            Text(value)
                .font(.caption)
                .textSelection(.enabled)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
    }
}
