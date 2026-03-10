// ViewerViewController+FASTQDrawer.swift - FASTQ metadata drawer integration
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import LungfishIO
import LungfishWorkflow
import os.log

private let fastqDrawerLogger = Logger(subsystem: "com.lungfish.browser", category: "ViewerFASTQDrawer")
private let fastqDrawerHeight: CGFloat = 240

extension ViewerViewController: FASTQMetadataDrawerViewDelegate {

    public func toggleFASTQMetadataDrawer() {
        guard isDisplayingFASTQDataset else { return }

        if fastqMetadataDrawerView == nil {
            configureFASTQMetadataDrawer()
        }

        guard let bottomConstraint = fastqMetadataDrawerBottomConstraint else { return }
        let isOpen = isFASTQMetadataDrawerOpen
        let currentHeight = fastqMetadataDrawerHeightConstraint?.constant ?? fastqDrawerHeight
        let target: CGFloat = isOpen ? currentHeight : 0

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            context.allowsImplicitAnimation = true
            bottomConstraint.animator().constant = target
            view.layoutSubtreeIfNeeded()
        }

        isFASTQMetadataDrawerOpen = !isOpen
        if isFASTQMetadataDrawerOpen {
            refreshFASTQMetadataDrawerContent()
        }
        fastqDrawerLogger.info("toggleFASTQMetadataDrawer: open=\(self.isFASTQMetadataDrawerOpen)")
    }

    func configureFASTQMetadataDrawer() {
        guard fastqMetadataDrawerView == nil else { return }

        let drawer = FASTQMetadataDrawerView(delegate: self)
        drawer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drawer)

        let persistedHeight = UserDefaults.standard.double(forKey: "fastqMetadataDrawerHeight")
        let drawerHeight = persistedHeight > 0 ? CGFloat(persistedHeight) : fastqDrawerHeight
        let bottomConstraint = drawer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: drawerHeight)
        let heightConstraint = drawer.heightAnchor.constraint(equalToConstant: drawerHeight)

        NSLayoutConstraint.activate([
            drawer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            drawer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heightConstraint,
            bottomConstraint,
        ])

        fastqMetadataDrawerView = drawer
        fastqMetadataDrawerBottomConstraint = bottomConstraint
        fastqMetadataDrawerHeightConstraint = heightConstraint
        isFASTQMetadataDrawerOpen = false

        if let dashboardView = fastqDashboardView {
            fastqDashboardBottomConstraint?.isActive = false
            let replacement = dashboardView.bottomAnchor.constraint(equalTo: drawer.topAnchor)
            replacement.isActive = true
            fastqDashboardBottomConstraint = replacement
        }

        refreshFASTQMetadataDrawerContent()
    }

    func teardownFASTQMetadataDrawer() {
        fastqMetadataDrawerView?.removeFromSuperview()
        fastqMetadataDrawerView = nil
        fastqMetadataDrawerBottomConstraint = nil
        fastqMetadataDrawerHeightConstraint = nil
        isFASTQMetadataDrawerOpen = false
    }

    func refreshFASTQMetadataDrawerContent() {
        guard let drawer = fastqMetadataDrawerView else { return }
        let metadata = currentFASTQDatasetURL.flatMap { FASTQMetadataStore.load(for: $0)?.demultiplexMetadata }
        drawer.configure(fastqURL: currentFASTQDatasetURL, metadata: metadata)
    }

    public func fastqMetadataDrawerViewDidSave(
        _ drawer: FASTQMetadataDrawerView,
        fastqURL: URL?,
        metadata: FASTQDemultiplexMetadata
    ) {
        guard let targetURL = fastqURL ?? currentFASTQDatasetURL else { return }

        var persisted = FASTQMetadataStore.load(for: targetURL) ?? PersistedFASTQMetadata()
        persisted.demultiplexMetadata = metadata
        FASTQMetadataStore.save(persisted, for: targetURL)
        refreshFASTQDemultiplexMetadata()
        syncDemuxConfigToController()
        fastqDrawerLogger.info("Saved FASTQ demultiplex metadata for \(targetURL.lastPathComponent, privacy: .public)")
    }

    /// Syncs the drawer's first demux step to the operations panel as the current config.
    func syncDemuxConfigToController() {
        guard let drawer = fastqMetadataDrawerView else { return }
        let plan = drawer.currentDemuxPlan()
        let firstStep = plan.steps.sorted(by: { $0.ordinal < $1.ordinal }).first
        fastqDatasetController?.currentDemuxConfig = firstStep
    }

    /// Opens the metadata drawer and selects the Demux Setup tab.
    func openDemuxSetupDrawer() {
        if fastqMetadataDrawerView == nil {
            configureFASTQMetadataDrawer()
        }
        if !isFASTQMetadataDrawerOpen {
            toggleFASTQMetadataDrawer()
        }
        fastqMetadataDrawerView?.selectDemuxSetupTab()
    }
}

extension ViewerViewController {
    private static var fastqMetadataDrawerViewKey: UInt8 = 0
    private static var fastqMetadataDrawerBottomKey: UInt8 = 0
    private static var fastqMetadataDrawerHeightKey: UInt8 = 0
    private static var fastqMetadataDrawerOpenKey: UInt8 = 0
    private static var fastqDashboardViewKey: UInt8 = 0
    private static var fastqDashboardBottomKey: UInt8 = 0
    private static var currentFASTQDatasetURLKey: UInt8 = 0

    var fastqMetadataDrawerView: FASTQMetadataDrawerView? {
        get { objc_getAssociatedObject(self, &Self.fastqMetadataDrawerViewKey) as? FASTQMetadataDrawerView }
        set { objc_setAssociatedObject(self, &Self.fastqMetadataDrawerViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var fastqMetadataDrawerBottomConstraint: NSLayoutConstraint? {
        get { objc_getAssociatedObject(self, &Self.fastqMetadataDrawerBottomKey) as? NSLayoutConstraint }
        set { objc_setAssociatedObject(self, &Self.fastqMetadataDrawerBottomKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var fastqMetadataDrawerHeightConstraint: NSLayoutConstraint? {
        get { objc_getAssociatedObject(self, &Self.fastqMetadataDrawerHeightKey) as? NSLayoutConstraint }
        set { objc_setAssociatedObject(self, &Self.fastqMetadataDrawerHeightKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var isFASTQMetadataDrawerOpen: Bool {
        get { (objc_getAssociatedObject(self, &Self.fastqMetadataDrawerOpenKey) as? NSNumber)?.boolValue ?? false }
        set { objc_setAssociatedObject(self, &Self.fastqMetadataDrawerOpenKey, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var fastqDashboardView: NSView? {
        get { objc_getAssociatedObject(self, &Self.fastqDashboardViewKey) as? NSView }
        set { objc_setAssociatedObject(self, &Self.fastqDashboardViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var fastqDashboardBottomConstraint: NSLayoutConstraint? {
        get { objc_getAssociatedObject(self, &Self.fastqDashboardBottomKey) as? NSLayoutConstraint }
        set { objc_setAssociatedObject(self, &Self.fastqDashboardBottomKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var currentFASTQDatasetURL: URL? {
        get { objc_getAssociatedObject(self, &Self.currentFASTQDatasetURLKey) as? URL }
        set { objc_setAssociatedObject(self, &Self.currentFASTQDatasetURLKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
