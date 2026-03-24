// ViewerViewController+EsViritu.swift - EsViritu result display for ViewerViewController
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// This extension adds EsViritu viral detection result display to ViewerViewController,
// following the same child-VC pattern as displayTaxonomyResult / displayFASTACollection.

import AppKit
import LungfishCore
import LungfishIO
import LungfishWorkflow
import SwiftUI
import os.log

/// Logger for EsViritu display operations.
private let esVirituLogger = Logger(subsystem: LogSubsystem.app, category: "ViewerEsViritu")


// MARK: - ViewerViewController EsViritu Display Extension

extension ViewerViewController {

    /// Displays the EsViritu viral detection browser in place of the normal sequence viewer.
    ///
    /// Hides all other overlay views (FASTQ, VCF, FASTA, taxonomy, QuickLook) and the
    /// normal viewer components, then adds ``EsVirituResultViewController`` as a child
    /// view controller filling the content area.
    ///
    /// Wires callbacks for BLAST verification, read extraction, and re-run.
    ///
    /// Follows the exact same child-VC pattern as ``displayTaxonomyResult(_:)``.
    ///
    /// - Parameters:
    ///   - result: The parsed EsViritu result to display.
    ///   - config: The config used for this run (optional, for provenance/re-run).
    public func displayEsVirituResult(_ result: LungfishIO.EsVirituResult, config: EsVirituConfig? = nil) {
        hideQuickLookPreview()
        hideFASTQDatasetView()
        hideVCFDatasetView()
        hideFASTACollectionView()
        hideTaxonomyView()
        hideEsVirituView()

        let controller = EsVirituResultViewController()
        addChild(controller)

        // Hide annotation drawer and FASTQ metadata drawer
        annotationDrawerView?.isHidden = true
        fastqMetadataDrawerView?.isHidden = true

        let esView = controller.view
        esView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(esView)

        NSLayoutConstraint.activate([
            esView.topAnchor.constraint(equalTo: view.topAnchor),
            esView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            esView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            esView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        controller.configure(result: result, config: config)

        // Wire BLAST verification callback
        controller.onBlastVerification = { detection in
            esVirituLogger.info("BLAST verification requested for \(detection.name, privacy: .public) (\(detection.accession, privacy: .public))")
            // Open NCBI BLAST web page with the accession as a query
            let encodedAccession = detection.accession
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? detection.accession
            if let url = URL(string: "https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastSearch&QUERY=\(encodedAccession)") {
                NSWorkspace.shared.open(url)
            }
        }

        // Wire read extraction callback
        controller.onExtractReads = { detection in
            esVirituLogger.info("Read extraction requested for \(detection.name, privacy: .public) (\(detection.accession, privacy: .public), \(detection.readCount) reads)")
            // TODO: Wire to extraction pipeline when available
        }

        // Wire assembly read extraction callback
        controller.onExtractAssemblyReads = { assembly in
            esVirituLogger.info("Assembly read extraction requested for \(assembly.name, privacy: .public) (\(assembly.assembly, privacy: .public), \(assembly.totalReads) reads)")
            // TODO: Wire to extraction pipeline when available
        }

        // Wire re-run callback
        controller.onReRun = { [weak self] in
            guard let self, let window = self.view.window else { return }
            esVirituLogger.info("Re-run requested")

            // Present the wizard sheet with the original input files
            let inputFiles = config?.inputFiles ?? []
            guard !inputFiles.isEmpty else {
                esVirituLogger.warning("Cannot re-run: no input files in config")
                return
            }

            let wizardSheet = EsVirituWizardSheet(
                inputFiles: inputFiles,
                onRun: { [weak window] newConfig in
                    guard let window else { return }
                    if let sheetWindow = window.attachedSheet {
                        window.endSheet(sheetWindow)
                    }
                    esVirituLogger.info("Re-run with new config: \(newConfig.sampleName, privacy: .public)")
                    // TODO: Wire to pipeline execution when available
                },
                onCancel: { [weak window] in
                    guard let window else { return }
                    if let sheetWindow = window.attachedSheet {
                        window.endSheet(sheetWindow)
                    }
                }
            )

            let sheetWindow = NSPanel(
                contentRect: NSRect(x: 0, y: 0, width: 520, height: 480),
                styleMask: [.titled],
                backing: .buffered,
                defer: false
            )
            sheetWindow.contentViewController = NSHostingController(rootView: wizardSheet)
            window.beginSheet(sheetWindow)
        }

        esVirituViewController = controller

        // Hide normal genomic viewer components
        enhancedRulerView.isHidden = true
        viewerView.isHidden = true
        headerView.isHidden = true
        statusBar.isHidden = true
        geneTabBarView.isHidden = true

        esVirituLogger.info("displayEsVirituResult: Showing browser with \(result.detections.count) detections, \(result.assemblies.count) assemblies")
    }

    /// Removes the EsViritu result browser and restores normal viewer components.
    public func hideEsVirituView() {
        guard let controller = esVirituViewController else { return }
        controller.view.removeFromSuperview()
        controller.removeFromParent()
        esVirituViewController = nil

        // Restore normal viewer components
        enhancedRulerView.isHidden = false
        viewerView.isHidden = false
        statusBar.isHidden = false
        annotationDrawerView?.isHidden = false
    }
}
