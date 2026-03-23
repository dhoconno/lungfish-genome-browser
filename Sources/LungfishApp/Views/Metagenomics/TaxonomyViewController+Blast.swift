// TaxonomyViewController+Blast.swift - BLAST verification integration for taxonomy view
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import LungfishCore
import os.log

private let blastVCLogger = Logger(subsystem: LogSubsystem.app, category: "TaxonomyBlast")

// MARK: - TaxonomyViewController BLAST Extension

extension TaxonomyViewController {

    // MARK: - Public API

    /// Shows BLAST verification results in the drawer's BLAST tab.
    ///
    /// If the drawer is not yet created, it is lazily instantiated. If the drawer
    /// is not open, it is toggled open. The drawer then switches to the BLAST tab
    /// and populates the results view.
    ///
    /// - Parameter result: The BLAST verification result to display.
    func showBlastResults(_ result: BlastVerificationResult) {
        // Ensure the drawer exists
        if taxaCollectionsDrawerView == nil {
            toggleTaxaCollectionsDrawer()
        }

        // Ensure the drawer is open
        if !isTaxaCollectionsDrawerOpen {
            toggleTaxaCollectionsDrawer()
        }

        // Switch to BLAST tab and show results
        taxaCollectionsDrawerView?.showBlastResults(result)

        blastVCLogger.info(
            "Showing BLAST results for \(result.taxonName, privacy: .public): \(result.verifiedCount)/\(result.readResults.count) verified"
        )
    }

    // MARK: - Testing Accessors

    /// Returns the BLAST results drawer tab for testing.
    var testBlastResultsTab: BlastResultsDrawerTab? {
        taxaCollectionsDrawerView?.blastResultsTab
    }
}
