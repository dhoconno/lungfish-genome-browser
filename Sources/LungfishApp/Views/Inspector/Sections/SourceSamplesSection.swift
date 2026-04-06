// SourceSamplesSection.swift - Inspector section listing source samples for a batch operation
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import SwiftUI

// MARK: - SourceSamplesSection

/// Inspector section listing the source FASTQ samples that contributed to a batch operation.
///
/// Linked samples (those whose bundle URL was resolved) are rendered as clickable buttons
/// that invoke `onNavigateToBundle` to navigate the sidebar to that bundle.
/// Unlinked samples (bundle URL could not be resolved) are shown in secondary color.
struct SourceSamplesSection: View {
    let samples: [(sampleId: String, bundleURL: URL?)]
    var onNavigateToBundle: ((URL) -> Void)?

    @State private var isExpanded = true

    var body: some View {
        DisclosureGroup("Source Samples", isExpanded: $isExpanded) {
            if samples.isEmpty {
                Text("No source samples recorded.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 4)
            } else {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(samples, id: \.sampleId) { entry in
                        sampleRow(entry)
                    }
                }
                .padding(.top, 4)
            }
        }
        .font(.caption.weight(.semibold))
    }

    @ViewBuilder
    private func sampleRow(_ entry: (sampleId: String, bundleURL: URL?)) -> some View {
        if let bundleURL = entry.bundleURL {
            Button(entry.sampleId) {
                onNavigateToBundle?(bundleURL)
            }
            .buttonStyle(.link)
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
            .help("Navigate to \(bundleURL.lastPathComponent)")
        } else {
            Text(entry.sampleId)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Source Samples") {
    ScrollView {
        SourceSamplesSection(
            samples: [
                (sampleId: "SampleA", bundleURL: URL(fileURLWithPath: "/tmp/SampleA.lungfishfastq")),
                (sampleId: "SampleB", bundleURL: URL(fileURLWithPath: "/tmp/SampleB.lungfishfastq")),
                (sampleId: "SampleC-unlinked", bundleURL: nil),
            ],
            onNavigateToBundle: { url in
                print("Navigate to: \(url)")
            }
        )
        .padding()
    }
    .frame(width: 280, height: 200)
}

#Preview("Source Samples - Empty") {
    ScrollView {
        SourceSamplesSection(samples: [])
            .padding()
    }
    .frame(width: 280, height: 100)
}
#endif
