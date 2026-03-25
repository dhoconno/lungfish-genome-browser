// ViewerViewController+TaxTriage.swift - TaxTriage result display for ViewerViewController
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// This extension adds TaxTriage clinical triage result display to ViewerViewController,
// following the same child-VC pattern as displayEsVirituResult / displayTaxonomyResult.

import AppKit
import LungfishCore
import LungfishIO
import LungfishWorkflow
import SwiftUI
import os.log

/// Logger for TaxTriage display operations.
private let taxTriageLogger = Logger(subsystem: "com.lungfish.app", category: "ViewerTaxTriage")


// MARK: - ViewerViewController TaxTriage Display Extension

extension ViewerViewController {

    /// Displays the TaxTriage clinical triage browser in place of the normal sequence viewer.
    ///
    /// Hides all other overlay views (FASTQ, VCF, FASTA, taxonomy, EsViritu, QuickLook)
    /// and the normal viewer components, then adds ``TaxTriageResultViewController`` as a
    /// child view controller filling the content area.
    ///
    /// Wires callbacks for BLAST verification and re-run.
    ///
    /// Follows the exact same child-VC pattern as ``displayEsVirituResult(_:config:)``.
    ///
    /// - Parameters:
    ///   - result: The TaxTriage pipeline result to display.
    ///   - config: The config used for this run (optional, for provenance/re-run).
    public func displayTaxTriageResult(_ result: TaxTriageResult, config: TaxTriageConfig? = nil) {
        hideQuickLookPreview()
        hideFASTQDatasetView()
        hideVCFDatasetView()
        hideFASTACollectionView()
        hideTaxonomyView()
        hideEsVirituView()
        hideTaxTriageView()

        let controller = TaxTriageResultViewController()
        addChild(controller)

        // Hide annotation drawer and FASTQ metadata drawer
        annotationDrawerView?.isHidden = true
        fastqMetadataDrawerView?.isHidden = true

        let ttView = controller.view
        ttView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ttView)

        NSLayoutConstraint.activate([
            ttView.topAnchor.constraint(equalTo: view.topAnchor),
            ttView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ttView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ttView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        controller.configure(result: result, config: config)

        // Wire BLAST verification callback — uses native BlastService when
        // the organism has a taxId (from TaxTriage TASS metrics), falling back
        // to NCBI BLAST web when taxId is unavailable.
        let capturedConfig = config
        controller.onBlastVerification = { organism in
            let orgName = organism.name
            taxTriageLogger.info("BLAST verification requested for \(orgName, privacy: .public)")

            // TaxTriage provides taxIds in its metrics output. If we have one,
            // use the Kraken2-style BLAST pipeline (extract reads from FASTQ by
            // taxId, subsample, submit to NCBI BLAST REST API).
            if let taxId = organism.taxId, taxId > 0,
               let sourceFile = capturedConfig?.samples.first?.fastq1 {

                let opID = OperationCenter.shared.start(
                    title: "BLAST \(orgName)",
                    detail: "Preparing BLAST verification\u{2026}",
                    operationType: .blastVerification
                )

                nonisolated(unsafe) let capturedSourceFile = sourceFile

                let task = Task.detached {
                    do {
                        let blastService = BlastService.shared

                        // TaxTriage uses Kraken2 internally — check for a
                        // classification.kraken file in the output directory
                        let outputDir = capturedConfig?.outputDirectory
                        let krakenFile = outputDir?
                            .appendingPathComponent("classification")
                            .appendingPathComponent("classification.kraken")

                        let request: BlastVerificationRequest

                        if let krakenFile, FileManager.default.fileExists(atPath: krakenFile.path) {
                            // Use the Kraken2 output for read ID extraction
                            request = try await blastService.buildVerificationRequest(
                                taxonName: orgName,
                                taxId: taxId,
                                targetTaxIds: Set([taxId]),
                                classificationOutputURL: krakenFile,
                                sourceURL: capturedSourceFile,
                                readCount: 20
                            )
                        } else {
                            // No Kraken2 output available — open web fallback
                            let encodedName = orgName
                                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? orgName
                            if let url = URL(string: "https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastSearch&QUERY=\(encodedName)") {
                                DispatchQueue.main.async {
                                    MainActor.assumeIsolated {
                                        NSWorkspace.shared.open(url)
                                        OperationCenter.shared.complete(
                                            id: opID,
                                            detail: "Opened NCBI BLAST in browser"
                                        )
                                    }
                                }
                            }
                            return
                        }

                        DispatchQueue.main.async {
                            MainActor.assumeIsolated {
                                OperationCenter.shared.update(
                                    id: opID,
                                    progress: 0.1,
                                    detail: "Submitting \(request.sequences.count) reads to NCBI BLAST\u{2026}"
                                )
                            }
                        }

                        let blastResult = try await blastService.verify(
                            request: request,
                            progress: { fraction, message in
                                DispatchQueue.main.async {
                                    MainActor.assumeIsolated {
                                        OperationCenter.shared.update(
                                            id: opID,
                                            progress: fraction,
                                            detail: message
                                        )
                                    }
                                }
                            }
                        )

                        DispatchQueue.main.async {
                            MainActor.assumeIsolated {
                                OperationCenter.shared.complete(
                                    id: opID,
                                    detail: "\(blastResult.verifiedCount)/\(blastResult.readResults.count) verified"
                                )
                            }
                        }
                    } catch {
                        let errorDesc = error.localizedDescription
                        DispatchQueue.main.async {
                            MainActor.assumeIsolated {
                                OperationCenter.shared.fail(id: opID, detail: errorDesc)
                            }
                        }
                    }
                }

                OperationCenter.shared.setCancelCallback(for: opID) { task.cancel() }
            } else {
                // No taxId — fall back to NCBI BLAST web
                let encodedName = orgName
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? orgName
                if let url = URL(string: "https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastSearch&QUERY=\(encodedName)") {
                    NSWorkspace.shared.open(url)
                }
            }
        }

        // Wire re-run callback
        controller.onReRun = { [weak self] in
            guard let self, let window = self.view.window else { return }
            taxTriageLogger.info("Re-run requested")

            let initialFiles = config?.samples.flatMap { $0.allFiles } ?? []
            guard !initialFiles.isEmpty else {
                taxTriageLogger.warning("Cannot re-run: no input files in config")
                return
            }

            let wizardSheet = TaxTriageWizardSheet(
                initialFiles: initialFiles,
                onRun: { [weak window] newConfig in
                    guard let window else { return }
                    if let sheetWindow = window.attachedSheet {
                        window.endSheet(sheetWindow)
                    }
                    let sampleCount = newConfig.samples.count
                    taxTriageLogger.info("Re-run with \(sampleCount) samples")
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
                contentRect: NSRect(x: 0, y: 0, width: 560, height: 600),
                styleMask: [.titled],
                backing: .buffered,
                defer: false
            )
            sheetWindow.contentViewController = NSHostingController(rootView: wizardSheet)
            window.beginSheet(sheetWindow)
        }

        taxTriageViewController = controller

        // Hide normal genomic viewer components
        enhancedRulerView.isHidden = true
        viewerView.isHidden = true
        headerView.isHidden = true
        statusBar.isHidden = true
        geneTabBarView.isHidden = true

        let reportCount = result.reportFiles.count
        let metricsCount = result.metricsFiles.count
        taxTriageLogger.info("displayTaxTriageResult: Showing browser with \(reportCount) reports, \(metricsCount) metrics files")
    }

    /// Removes the TaxTriage result browser and restores normal viewer components.
    public func hideTaxTriageView() {
        guard let controller = taxTriageViewController else { return }
        controller.view.removeFromSuperview()
        controller.removeFromParent()
        taxTriageViewController = nil

        // Restore normal viewer components
        enhancedRulerView.isHidden = false
        viewerView.isHidden = false
        headerView.isHidden = false
        statusBar.isHidden = false
        geneTabBarView.isHidden = (geneTabBarView.selectedGeneRegion == nil)
        annotationDrawerView?.isHidden = false
        fastqMetadataDrawerView?.isHidden = false
    }
}
