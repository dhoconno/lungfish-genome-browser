// ImportCenterViewModel.swift - View model for the Import Center
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import AppKit
import UniformTypeIdentifiers
import LungfishCore
import os.log

/// Logger for the Import Center view model.
private let logger = Logger(subsystem: LogSubsystem.app, category: "ImportCenterVM")

/// Describes a single importable data type shown as a card in the Import Center.
struct ImportCardInfo: Identifiable, Sendable {
    let id: String
    let title: String
    let description: String
    let sfSymbol: String
    let fileHint: String?
    let tab: ImportCenterViewModel.Tab
    let importKind: ImportKind

    /// The kind of import action to perform when the user clicks "Import...".
    enum ImportKind: Sendable {
        /// Open a file panel with the given UTTypes and forward to the app delegate.
        case filePanel(allowedTypes: [UTType], action: ImportAction)
        /// Open a custom wizard sheet (e.g. NAO-MGS).
        case wizardSheet(action: ImportAction)
    }

    /// Identifies which import action to dispatch.
    enum ImportAction: Sendable {
        case bam
        case vcf
        case fasta
        case naoMgs
        case kraken2
        case esViritu
        case taxTriage
    }
}

/// View model for the Import Center window.
///
/// Manages tab state, search filtering, and the static catalog of
/// importable data types. All state is ``@MainActor``-isolated and
/// uses ``@Observable`` for automatic SwiftUI invalidation.
@MainActor
@Observable
final class ImportCenterViewModel {

    // MARK: - Tab

    /// The four sections of the Import Center.
    enum Tab: Int, CaseIterable, Hashable, Sendable {
        case alignments
        case variants
        case classificationResults
        case references

        /// Human-readable tab title for the segmented control.
        var title: String {
            switch self {
            case .alignments:            return "Alignments"
            case .variants:              return "Variants"
            case .classificationResults: return "Classification"
            case .references:            return "References"
            }
        }

        /// SF Symbol for the tab.
        var sfSymbol: String {
            switch self {
            case .alignments:            return "arrow.left.arrow.right"
            case .variants:              return "diamond.fill"
            case .classificationResults: return "chart.bar.doc.horizontal"
            case .references:            return "doc.text"
            }
        }

        /// Maps to the segmented control index.
        var segmentIndex: Int { rawValue }

        /// Creates a tab from a segmented control index.
        static func from(segmentIndex: Int) -> Tab {
            Tab(rawValue: segmentIndex) ?? .classificationResults
        }
    }

    // MARK: - State

    /// Currently selected tab.
    var selectedTab: Tab = .classificationResults

    /// Search text from the toolbar search field.
    var searchText: String = ""

    // MARK: - Card Catalog

    /// All importable data type cards, organized by tab.
    let allCards: [ImportCardInfo] = [
        // Alignments
        ImportCardInfo(
            id: "bam-cram",
            title: "BAM/CRAM Alignments",
            description: "Import aligned reads from BAM or CRAM files into the current dataset for alignment visualization.",
            sfSymbol: "arrow.left.arrow.right",
            fileHint: ".bam, .cram",
            tab: .alignments,
            importKind: .filePanel(
                allowedTypes: [
                    UTType(filenameExtension: "bam") ?? .data,
                    UTType(filenameExtension: "cram") ?? .data,
                ],
                action: .bam
            )
        ),

        // Variants
        ImportCardInfo(
            id: "vcf",
            title: "VCF Variants",
            description: "Import variant calls from VCF files. Supports plain text and gzipped VCF with tabix indices.",
            sfSymbol: "diamond.fill",
            fileHint: ".vcf, .vcf.gz",
            tab: .variants,
            importKind: .filePanel(
                allowedTypes: [
                    UTType(filenameExtension: "vcf") ?? .data,
                    UTType(filenameExtension: "gz") ?? .data,
                ],
                action: .vcf
            )
        ),

        // Classification Results
        ImportCardInfo(
            id: "nao-mgs",
            title: "NAO-MGS Results",
            description: "Import NAO metagenomic surveillance results. Parses virus_hits_final.tsv.gz or _virus_hits.tsv.gz files for taxonomic visualization.",
            sfSymbol: "n.circle",
            fileHint: "virus_hits_final.tsv.gz or _virus_hits.tsv.gz",
            tab: .classificationResults,
            importKind: .wizardSheet(action: .naoMgs)
        ),
        ImportCardInfo(
            id: "kraken2",
            title: "Kraken2 Results",
            description: "Import Kraken2 classification reports and Bracken abundance profiles for taxonomic composition analysis.",
            sfSymbol: "k.circle",
            fileHint: ".kreport, .kreport2, .bracken",
            tab: .classificationResults,
            importKind: .filePanel(
                allowedTypes: [
                    UTType(filenameExtension: "kreport") ?? .data,
                    UTType(filenameExtension: "kreport2") ?? .data,
                    UTType(filenameExtension: "bracken") ?? .data,
                    UTType(filenameExtension: "txt") ?? .data,
                ],
                action: .kraken2
            )
        ),
        ImportCardInfo(
            id: "esviritu",
            title: "EsViritu Results",
            description: "Import EsViritu viral detection results for rapid virome characterization and visualization.",
            sfSymbol: "e.circle",
            fileHint: "EsViritu output directory",
            tab: .classificationResults,
            importKind: .filePanel(
                allowedTypes: [
                    UTType(filenameExtension: "tsv") ?? .data,
                    UTType(filenameExtension: "txt") ?? .data,
                ],
                action: .esViritu
            )
        ),
        ImportCardInfo(
            id: "taxtriage",
            title: "TaxTriage Results",
            description: "Import TaxTriage clinical triage reports for pathogen identification and abundance profiling.",
            sfSymbol: "t.circle",
            fileHint: "TaxTriage output directory",
            tab: .classificationResults,
            importKind: .filePanel(
                allowedTypes: [
                    UTType(filenameExtension: "tsv") ?? .data,
                    UTType(filenameExtension: "csv") ?? .data,
                    UTType(filenameExtension: "txt") ?? .data,
                ],
                action: .taxTriage
            )
        ),

        // References
        ImportCardInfo(
            id: "fasta",
            title: "Reference FASTA",
            description: "Import a reference genome FASTA file. Supports plain text and gzipped FASTA with .fai indices.",
            sfSymbol: "doc.text",
            fileHint: ".fasta, .fa, .fna, .fasta.gz",
            tab: .references,
            importKind: .filePanel(
                allowedTypes: [
                    UTType(filenameExtension: "fasta") ?? .data,
                    UTType(filenameExtension: "fa") ?? .data,
                    UTType(filenameExtension: "fna") ?? .data,
                    UTType(filenameExtension: "gz") ?? .data,
                ],
                action: .fasta
            )
        ),
    ]

    /// Cards filtered by the selected tab and search text.
    var filteredCards: [ImportCardInfo] {
        let tabCards = allCards.filter { $0.tab == selectedTab }
        if searchText.isEmpty {
            return tabCards
        }
        let query = searchText.lowercased()
        return tabCards.filter { card in
            card.title.lowercased().contains(query)
            || card.description.lowercased().contains(query)
            || (card.fileHint?.lowercased().contains(query) ?? false)
        }
    }

    // MARK: - Import Actions

    /// Performs the import action for a given card.
    ///
    /// For file-panel imports, opens an NSOpenPanel with the appropriate
    /// type filters and forwards selected URLs to the app delegate.
    /// For wizard-sheet imports, opens the appropriate wizard.
    func performImport(for card: ImportCardInfo) {
        switch card.importKind {
        case .filePanel(let allowedTypes, let action):
            openFilePanel(allowedTypes: allowedTypes, action: action)
        case .wizardSheet(let action):
            openWizardSheet(action: action)
        }
    }

    // MARK: - File Panel

    private func openFilePanel(allowedTypes: [UTType], action: ImportCardInfo.ImportAction) {
        guard let window = NSApp.mainWindow ?? NSApp.keyWindow else {
            logger.warning("No window available for file panel")
            return
        }

        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = (action == .esViritu || action == .taxTriage)
        panel.allowsMultipleSelection = true
        panel.allowedContentTypes = allowedTypes
        panel.message = panelMessage(for: action)

        panel.beginSheetModal(for: window) { [weak self] response in
            guard response == .OK, !panel.urls.isEmpty else { return }
            self?.dispatchFileImport(urls: panel.urls, action: action)
        }
    }

    private func panelMessage(for action: ImportCardInfo.ImportAction) -> String {
        switch action {
        case .bam:      return "Select BAM or CRAM alignment files to import"
        case .vcf:      return "Select VCF variant files to import"
        case .fasta:    return "Select reference FASTA files to import"
        case .kraken2:  return "Select Kraken2 report files to import"
        case .esViritu: return "Select EsViritu result files or directory"
        case .taxTriage: return "Select TaxTriage result files or directory"
        case .naoMgs:   return "Select NAO-MGS results"
        }
    }

    /// Dispatches imported file URLs to the appropriate app delegate method.
    private func dispatchFileImport(urls: [URL], action: ImportCardInfo.ImportAction) {
        guard let appDelegate = NSApp.delegate as? AppDelegate else {
            logger.error("Cannot access AppDelegate for import dispatch")
            return
        }

        // Close Import Center so it doesn't obscure the main window
        ImportCenterWindowController.close()

        switch action {
        case .bam:
            for url in urls {
                appDelegate.importBAMFromURL(url)
            }
        case .vcf:
            for url in urls {
                appDelegate.importVCFFromURL(url)
            }
        case .fasta:
            for url in urls {
                appDelegate.importFASTAFromURL(url)
            }
        case .kraken2:
            for url in urls {
                appDelegate.importKraken2ResultFromURL(url)
            }
        case .esViritu:
            for url in urls {
                appDelegate.importEsVirituResultFromURL(url)
            }
        case .taxTriage:
            for url in urls {
                appDelegate.importTaxTriageResultFromURL(url)
            }
        case .naoMgs:
            break // Handled by wizard sheet path
        }

        logger.info("Dispatched \(urls.count) file(s) for \(String(describing: action)) import")
    }

    // MARK: - Wizard Sheets

    private func openWizardSheet(action: ImportCardInfo.ImportAction) {
        guard let appDelegate = NSApp.delegate as? AppDelegate else {
            logger.error("Cannot access AppDelegate for wizard sheet")
            return
        }

        // Close the Import Center window so the wizard sheet isn't hidden behind it
        ImportCenterWindowController.close()

        switch action {
        case .naoMgs:
            appDelegate.launchNaoMgsImport(nil)
        case .kraken2:
            appDelegate.launchKraken2Classification(nil)
        case .esViritu:
            appDelegate.launchEsVirituDetection(nil)
        case .taxTriage:
            appDelegate.launchTaxTriage(nil)
        default:
            logger.warning("No wizard sheet defined for action: \(String(describing: action))")
        }
    }
}
