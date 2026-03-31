// ImportCenterView.swift - SwiftUI view for the Import Center
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import SwiftUI

/// Main SwiftUI view for the Import Center window.
///
/// Displays four tabs controlled by the toolbar segmented control:
/// - **Alignments**: BAM/CRAM alignment imports.
/// - **Variants**: VCF variant file imports.
/// - **Classification Results**: NAO-MGS, Kraken2, EsViritu, TaxTriage.
/// - **References**: Reference FASTA imports.
struct ImportCenterView: View {

    /// The shared view model, owned by ``ImportCenterWindowController``.
    @Bindable var viewModel: ImportCenterViewModel

    var body: some View {
        Group {
            if viewModel.filteredCards.isEmpty {
                emptyState
            } else {
                cardList
            }
        }
        .frame(minWidth: 600, minHeight: 350)
    }

    // MARK: - Card List

    private var cardList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                // Tab header
                tabHeader
                    .padding(.top, 8)

                ForEach(viewModel.filteredCards) { card in
                    ImportCardView(card: card) {
                        viewModel.performImport(for: card)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }

    private var tabHeader: some View {
        HStack(spacing: 10) {
            Image(systemName: viewModel.selectedTab.sfSymbol)
                .font(.title2)
                .foregroundStyle(Color.accentColor)

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.selectedTab.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(tabSubtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.horizontal, 4)
    }

    private var tabSubtitle: String {
        switch viewModel.selectedTab {
        case .alignments:
            return "Import aligned reads for visualization"
        case .variants:
            return "Import variant calls for annotation"
        case .classificationResults:
            return "Import metagenomic classification results"
        case .references:
            return "Import reference genome sequences"
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)
            Text("No Matching Import Types")
                .font(.title2)
                .fontWeight(.medium)
            Text("Try a different search term or select another category.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .font(.body)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Import Card View

/// A single import type card with icon, title, description, and Import button.
///
/// Follows the visual design of Pack cards in the Plugin Manager:
/// a rounded-rect card with an icon on the left, text in the center,
/// and an action button on the right.
private struct ImportCardView: View {

    let card: ImportCardInfo
    let onImport: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            // Icon
            Image(systemName: card.sfSymbol)
                .font(.system(size: 28))
                .foregroundStyle(Color.accentColor)
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.accentColor.opacity(0.1))
                )

            // Text content
            VStack(alignment: .leading, spacing: 4) {
                Text(card.title)
                    .font(.headline)

                Text(card.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                if let hint = card.fileHint {
                    Text(hint)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .padding(.top, 2)
                }
            }

            Spacer(minLength: 12)

            // Import button
            Button("Import\u{2026}") {
                onImport()
            }
            .controlSize(.regular)
            .buttonStyle(.borderedProminent)
            .padding(.top, 4)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.background)
                .shadow(color: .black.opacity(0.06), radius: 3, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.separator, lineWidth: 0.5)
        )
    }
}
