// GenotypeStatusFlagSection.swift - Inspector Selection tab section for analyst status flag + comments
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import SwiftUI
import LungfishKit
import LungfishCore
import LungfishIO

/// Inspector Selection tab section that pairs a four-status segmented control with a
/// chronological comment list for the currently selected sample/call.
///
/// Inputs:
/// - `status`: binding over the analyst's status flag for the selected target (Unflagged
///   / Needs Review / Reviewed / Confirmed). Persists to `sampleStatusFlags` or
///   `callStatusFlags` at the caller's discretion.
/// - `comments`: chronologically-ordered `CellComment` records for the selection. The
///   pipeline's auto-comment is expected to be pinned at the bottom by the caller.
/// - `onAddComment`: invoked with the text the analyst entered in the new-comment field
///   when they tap Add.
struct GenotypeStatusFlagSection: View {
    private let typographyModel = ContentTypographyModel.shared
    private var contentBodyFont: Font { typographyModel.font(for: .body) }
    private var contentHeadingFont: Font { typographyModel.font(for: .emphasizedBody) }

    @Binding var status: GenotypeAnnotationSidecar.StatusValue
    let comments: [GenotypeAnnotationSidecar.CellComment]
    var onAddComment: (String) -> Void

    @State private var isExpanded = true
    @State private var newCommentText: String = ""

    var body: some View {
        DisclosureGroup("Status & Comments", isExpanded: $isExpanded) {
            VStack(alignment: .leading, spacing: 10) {
                statusRow
                Divider()
                commentsList
                Divider()
                addCommentRow
            }
            .padding(.top, 4)
        }
        .font(contentHeadingFont)
    }

    // MARK: - Sub-views

    private var statusRow: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Status")
                .font(contentBodyFont)
                .foregroundStyle(.secondary)
                .frame(maxWidth: 118, alignment: .trailing)
                        .fixedSize(horizontal: false, vertical: true)
            Picker("", selection: $status) {
                ForEach(GenotypeAnnotationSidecar.StatusValue.allCases, id: \.self) { value in
                    Text(displayName(for: value)).tag(value)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .font(contentBodyFont)
            .controlSize(.regular)
            .accessibilityIdentifier("genotypeStatusFlagPicker")
        }
    }

    @ViewBuilder
    private var commentsList: some View {
        if comments.isEmpty {
            HStack(alignment: .firstTextBaseline) {
                Text("Comments")
                    .font(contentBodyFont)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: 118, alignment: .trailing)
                        .fixedSize(horizontal: false, vertical: true)
                Text("No comments yet.")
                    .font(contentBodyFont)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        } else {
            VStack(alignment: .leading, spacing: 6) {
                Text("Comments")
                    .font(contentBodyFont)
                    .foregroundStyle(.secondary)
                ForEach(Array(comments.enumerated()), id: \.offset) { _, comment in
                    commentRow(comment)
                }
            }
            .accessibilityIdentifier("genotypeCommentsList")
        }
    }

    private func commentRow(_ comment: GenotypeAnnotationSidecar.CellComment) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(comment.author)
                    .font(contentHeadingFont)
                    .foregroundStyle(.primary)
                Text(comment.timestamp)
                    .font(contentBodyFont)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            Text(comment.body)
                .font(contentBodyFont)
                .foregroundStyle(.primary)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(Color.secondary.opacity(0.06))
        )
    }

    private var addCommentRow: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Add")
                .font(contentBodyFont)
                .foregroundStyle(.secondary)
                .frame(maxWidth: 118, alignment: .trailing)
                        .fixedSize(horizontal: false, vertical: true)
            TextField("New comment", text: $newCommentText)
                .textFieldStyle(.roundedBorder)
                .font(contentBodyFont)
                .controlSize(.regular)
                .accessibilityIdentifier("genotypeAddCommentField")
                .onSubmit(addComment)
            Button("Add", action: addComment)
                .controlSize(.regular)
                .disabled(trimmed.isEmpty)
                .accessibilityIdentifier("genotypeAddCommentButton")
        }
    }

    // MARK: - Helpers

    private var trimmed: String {
        newCommentText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func addComment() {
        let body = trimmed
        guard !body.isEmpty else { return }
        onAddComment(body)
        newCommentText = ""
    }

    private func displayName(for value: GenotypeAnnotationSidecar.StatusValue) -> String {
        switch value {
        case .unflagged: return "Unflagged"
        case .needsReview: return "Needs Review"
        case .reviewed: return "Reviewed"
        case .confirmed: return "Confirmed"
        }
    }
}

#if DEBUG
private struct GenotypeStatusFlagSectionPreviewHost: View {
    @State private var status: GenotypeAnnotationSidecar.StatusValue = .needsReview

    let comments: [GenotypeAnnotationSidecar.CellComment]

    var body: some View {
        GenotypeStatusFlagSection(
            status: $status,
            comments: comments,
            onAddComment: { _ in }
        )
        .padding()
    }
}

#Preview("Status & Comments - With Comments") {
    GenotypeStatusFlagSectionPreviewHost(
        comments: [
            .init(
                sample: "H22C112", locus: "MHC-A", slot: .h2,
                body: "Cross-checked diagnostic reads against re-runs.",
                author: "dho", timestamp: "2026-05-22T16:02:11Z"
            ),
            .init(
                sample: "H22C112", locus: "MHC-A", slot: .h2,
                body: "Called M2A from 02_M2_G_02_06_156bp 198 reads (auto)",
                author: "pipeline", timestamp: "2026-05-22T15:45:01Z"
            ),
        ]
    )
    .frame(width: 360, height: 360)
}

#Preview("Status & Comments - Empty") {
    GenotypeStatusFlagSectionPreviewHost(comments: [])
        .frame(width: 360, height: 240)
}
#endif
