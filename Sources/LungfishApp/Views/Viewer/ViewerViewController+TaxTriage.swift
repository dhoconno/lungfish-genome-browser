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

    /// Displays the TaxTriage clinical triage browser backed by a pre-built SQLite database.
    ///
    /// Creates a ``TaxTriageResultViewController``, adds it as a child filling the content area,
    /// and calls ``TaxTriageResultViewController/configureFromDatabase(_:)`` to load rows
    /// directly from the database rather than parsing per-sample files.
    ///
    /// - Parameters:
    ///   - db: The opened TaxTriage SQLite database.
    ///   - resultURL: The batch result root directory (used for display context).
    func displayTaxTriageFromDatabase(db: TaxTriageDatabase, resultURL: URL) {
        hideQuickLookPreview()
        hideFASTQDatasetView()
        hideVCFDatasetView()
        hideFASTACollectionView()
        hideTaxonomyView()
        hideEsVirituView()
        hideTaxTriageView()
        hideNaoMgsView()
        hideNvdView()
        contentMode = .metagenomics

        let controller = TaxTriageResultViewController()
        addChild(controller)

        annotationDrawerView?.isHidden = true
        fastqMetadataDrawerView?.isHidden = true

        // Force loadView() so all subviews exist, then configure BEFORE adding
        // to the view hierarchy to avoid a one-frame bounce.
        let ttView = controller.view
        controller.configureFromDatabase(db, resultURL: resultURL)
        ttView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ttView)

        NSLayoutConstraint.activate([
            ttView.topAnchor.constraint(equalTo: view.topAnchor),
            ttView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ttView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ttView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        taxTriageViewController = controller

        enhancedRulerView.isHidden = true
        viewerView.isHidden = true
        headerView.isHidden = true
        statusBar.isHidden = true
        geneTabBarView.isHidden = true

        taxTriageLogger.info("displayTaxTriageFromDatabase: Showing DB-backed browser for '\(resultURL.lastPathComponent, privacy: .public)'")
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
