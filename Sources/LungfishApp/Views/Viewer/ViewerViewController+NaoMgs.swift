// ViewerViewController+NaoMgs.swift - NAO-MGS result display extension
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import LungfishIO

// MARK: - ViewerViewController NAO-MGS Display Extension

extension ViewerViewController {

    /// Displays the NAO-MGS result viewer in place of the normal sequence viewer.
    ///
    /// Hides all other overlay views (FASTQ, VCF, FASTA, QuickLook, other
    /// metagenomics viewers) and adds the pre-configured
    /// `NaoMgsResultViewController` as a child view controller filling the
    /// content area.
    ///
    /// Follows the exact same child-VC pattern as ``displayTaxonomyResult(_:)``.
    ///
    /// - Parameter controller: A pre-configured `NaoMgsResultViewController`.
    public func displayNaoMgsResult(_ controller: NaoMgsResultViewController) {
        hideQuickLookPreview()
        hideFASTQDatasetView()
        hideVCFDatasetView()
        hideFASTACollectionView()
        hideTaxonomyView()
        hideEsVirituView()
        hideTaxTriageView()
        hideNaoMgsView()
        contentMode = .metagenomics

        addChild(controller)

        // Hide normal genomic viewer components (same pattern as Taxonomy/EsViritu/TaxTriage).
        enhancedRulerView.isHidden = true
        viewerView.isHidden = true
        headerView.isHidden = true
        statusBar.isHidden = true
        geneTabBarView.isHidden = true
        annotationDrawerView?.isHidden = true
        fastqMetadataDrawerView?.isHidden = true

        let resultView = controller.view
        resultView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultView)

        NSLayoutConstraint.activate([
            resultView.topAnchor.constraint(equalTo: view.topAnchor),
            resultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    /// Hides the NAO-MGS result viewer if one is displayed and restores normal viewer components.
    public func hideNaoMgsView() {
        for child in children where child is NaoMgsResultViewController {
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        // Restore normal viewer components (only if no other metagenomics viewer is active).
        // hideTaxonomyView / hideEsVirituView / hideTaxTriageView each restore these too,
        // so this guard prevents double-restore when switching between metagenomics results.
        guard taxonomyViewController == nil,
              esVirituViewController == nil,
              taxTriageViewController == nil else { return }

        enhancedRulerView.isHidden = false
        viewerView.isHidden = false
        headerView.isHidden = false
        statusBar.isHidden = false
        geneTabBarView.isHidden = (geneTabBarView.selectedGeneRegion == nil)
        annotationDrawerView?.isHidden = false
        fastqMetadataDrawerView?.isHidden = false
    }
}
