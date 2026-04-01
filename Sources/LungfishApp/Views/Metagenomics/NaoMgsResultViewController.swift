// NaoMgsResultViewController.swift - NAO-MGS metagenomic surveillance result viewer
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import LungfishCore
import LungfishIO
import SwiftUI
import os.log

private let logger = Logger(subsystem: LogSubsystem.app, category: "NaoMgsResultVC")

// MARK: - NaoMgsResultViewController

/// A full-screen NAO-MGS metagenomic surveillance result browser.
///
/// `NaoMgsResultViewController` is the primary UI for displaying imported
/// NAO-MGS workflow results (`virus_hits_final.tsv`). It replaces the normal
/// sequence viewer content area following the same child-VC pattern as
/// ``TaxonomyViewController`` and ``EsVirituResultViewController``.
///
/// ## Layout
///
/// ```
/// +--------------------------------------------------+
/// | Summary Bar (48pt)                                |
/// +--------------------------------------------------+
/// |  Detail Pane       |  Taxonomy Table              |
/// |  (miniBAM viewer,  |                              |
/// |   accession info,  |  - Taxid 130309              |
/// |   metrics)         |    125,727 hits              |
/// |                    |  - Taxid 28284               |
/// |                    |    36,577 hits               |
/// |                    |  ...                         |
/// +--------------------------------------------------+
/// | Action Bar (36pt)                                 |
/// +--------------------------------------------------+
/// ```
///
/// ## MiniBAM Alignment Viewer
///
/// When a taxon is selected and BAM data is available, the detail pane shows
/// a scrollable list of miniBAM panels for the top accessions by unique read count.
///
/// ## Thread Safety
///
/// This class is `@MainActor` isolated and uses raw `NSSplitView` (not
/// `NSSplitViewController`) per macOS 26 deprecated API rules.
@MainActor
public final class NaoMgsResultViewController: NSViewController, NSSplitViewDelegate {

    // MARK: - Data

    /// The NAO-MGS result driving this view.
    private(set) var naoMgsResult: NaoMgsResult?

    /// Hits grouped by taxonomy ID for efficient lookup.
    private var hitsByTaxon: [Int: [NaoMgsVirusHit]] = [:]

    /// Currently selected taxon summary.
    private var selectedTaxonSummary: NaoMgsTaxonSummary?

    /// Currently selected accession within the detail pane.
    private var selectedAccession: String?

    /// URL of the NAO-MGS bundle directory.
    private var bundleURL: URL?

    /// URL to the sorted BAM file for alignment display.
    private var bamURL: URL?

    /// URL to the BAM index (.bai) file.
    private var bamIndexURL: URL?

    // MARK: - Child Views

    private let summaryBar = NaoMgsSummaryBar()
    let splitView = NSSplitView()
    private let taxonomyTableScrollView = NSScrollView()
    private let taxonomyTableView = NSTableView()
    private let taxonomyFilterBar = NSStackView()
    private let sampleFilterField = NSSearchField()
    private let taxonFilterField = NSSearchField()
    private let hitsFilterField = NSTextField()
    private let uniqueReadsFilterField = NSTextField()
    private let refsFilterField = NSTextField()
    private let detailScrollView = NSScrollView()
    private let detailContentView = FlippedNaoMgsContentView()
    let actionBar = NaoMgsActionBar()

    // MARK: - MiniBAM

    /// Embedded miniBAM controllers currently shown in the detail pane.
    private var miniBAMControllers: [MiniBAMViewController] = []

    /// Per-accession preferred miniBAM heights.
    private var miniBAMPreferredHeights: [String: CGFloat] = [:]

    private let miniBAMDefaultHeight: CGFloat = 220
    private let miniBAMMinHeight: CGFloat = 140
    private let miniBAMMaxHeight: CGFloat = 900
    /// Number of accession miniBAM panels to show per selected taxon.
    private let miniBAMDisplayLimit: Int = 10

    /// Taxonomy row sample labels derived from raw hits (supports multi-sample bundles).
    private var sampleNamesByTaxId: [Int: String] = [:]

    // MARK: - Split View State

    /// The left (detail) pane container in the split view.
    private var detailContainer: NaoMgsDetailContainer?

    /// Whether the initial divider position has been applied.
    private var didSetInitialSplitPosition = false

    /// Active bottom constraint for the split view. Re-pinned when BLAST drawer opens.
    private var splitViewBottomConstraint: NSLayoutConstraint?

    /// Bottom BLAST results drawer shown after in-app verification.
    private var blastDrawerView: BlastResultsDrawerTab?
    private var blastDrawerBottomConstraint: NSLayoutConstraint?
    private var isBlastDrawerOpen = false

    // MARK: - Selection Sync

    /// Prevents infinite feedback loops when syncing selection between views.
    private var suppressSelectionSync = false

    // MARK: - Callbacks

    /// Called when the user confirms BLAST verification for a taxon.
    public var onBlastVerification: ((NaoMgsTaxonSummary, Int, [NaoMgsVirusHit]) -> Void)?

    /// Called when the user wants to export results.
    public var onExport: (() -> Void)?

    /// Called when the user selects a taxon and wants to view it on NCBI.
    public var onViewOnNCBI: ((NaoMgsTaxonSummary) -> Void)?

    // MARK: - Lifecycle

    public override func loadView() {
        let container = NSView(frame: NSRect(x: 0, y: 0, width: 900, height: 700))
        view = container

        setupSummaryBar()
        setupSplitView()
        setupActionBar()
        layoutSubviews()
        wireCallbacks()
    }

    public override func viewDidLayout() {
        super.viewDidLayout()
        applySplitPositionIfNeeded(force: false)
    }

    // MARK: - Public API

    /// Configures the view with a parsed NAO-MGS result.
    public func configure(result: NaoMgsResult, bundleURL: URL? = nil) {
        naoMgsResult = result
        hitsByTaxon = NaoMgsDataConverter.groupByTaxon(result.virusHits)
        sampleNamesByTaxId = Self.buildSampleNamesByTaxId(
            hitsByTaxon: hitsByTaxon,
            fallbackSampleName: result.sampleName
        )
        self.bundleURL = bundleURL

        // Discover BAM file in bundle
        if let bundleURL {
            discoverBAMFile(in: bundleURL, sampleName: result.sampleName)
        }

        // Update summary bar
        summaryBar.update(result: result)

        // Reload taxonomy table with current filter state.
        applyTaxonomyFilters()

        // Update action bar
        actionBar.configure(
            totalHits: result.totalHitReads,
            taxonCount: result.taxonSummaries.count
        )

        // Auto-select top taxon so miniBAM panels are visible immediately.
        if result.taxonSummaries.isEmpty {
            showOverview()
        } else {
            selectTaxonById(displayedSummaries.first?.taxId ?? result.taxonSummaries[0].taxId)
        }

        // Force the split view to re-apply its 40/60 position now that we have content.
        // If bounds are not available yet, this remains deferred to viewDidLayout.
        applySplitPositionIfNeeded(force: true)

        logger.info("Configured NAO-MGS viewer with \(result.totalHitReads) hits, \(result.taxonSummaries.count) taxa, sample=\(result.sampleName, privacy: .public), bam=\(self.bamURL != nil)")
    }

    // MARK: - BAM Discovery

    /// Searches for the sorted BAM file and its index in the bundle directory.
    private func discoverBAMFile(in bundleURL: URL, sampleName: String) {
        let fm = FileManager.default

        // Try standard naming convention: {sample}.sorted.bam
        let standardBAM = bundleURL.appendingPathComponent("\(sampleName).sorted.bam")
        if fm.fileExists(atPath: standardBAM.path) {
            bamURL = standardBAM
            // Look for index
            let bai = bundleURL.appendingPathComponent("\(sampleName).sorted.bam.bai")
            let csi = bundleURL.appendingPathComponent("\(sampleName).sorted.bam.csi")
            if fm.fileExists(atPath: bai.path) {
                bamIndexURL = bai
            } else if fm.fileExists(atPath: csi.path) {
                bamIndexURL = csi
            }
            return
        }

        // Fallback: scan for any .sorted.bam file
        if let contents = try? fm.contentsOfDirectory(at: bundleURL, includingPropertiesForKeys: nil) {
            for file in contents where file.pathExtension == "bam" && file.lastPathComponent.contains("sorted") {
                bamURL = file
                let bai = file.appendingPathExtension("bai")
                let csi = file.deletingPathExtension().appendingPathExtension("csi")
                if fm.fileExists(atPath: bai.path) {
                    bamIndexURL = bai
                } else if fm.fileExists(atPath: csi.path) {
                    bamIndexURL = csi
                }
                break
            }
        }
    }

    // MARK: - Detail Pane Content

    /// Shows the overview when no taxon is selected.
    private func showOverview() {
        selectedTaxonSummary = nil
        selectedAccession = nil

        rebuildDetailContent()
        actionBar.updateSelection(nil)
    }

    /// Shows the detail pane for the selected taxon.
    private func showTaxonDetail(_ summary: NaoMgsTaxonSummary) {
        selectedTaxonSummary = summary
        selectedAccession = nil
        rebuildDetailContent()
        actionBar.updateSelection(summary)
    }

    /// Stores accession selection from legacy list/table widgets.
    private func switchToAccession(_ accession: String) {
        selectedAccession = accession
    }

    // MARK: - Detail Content Rebuild

    private func rebuildDetailContent() {
        teardownEmbeddedMiniBAMControllers()
        for subview in detailContentView.subviews {
            subview.removeFromSuperview()
        }
        // Reset any active constraints on the content view
        detailContentView.removeConstraints(detailContentView.constraints)

        if let summary = selectedTaxonSummary {
            buildTaxonDetailContent(summary)
        } else {
            buildOverviewContent()
        }

        // Use a deferred layout pass so the scroll view has real bounds.
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.resizeDetailContentToFit()
        }
    }

    /// Sizes the detail content view to match the scroll view width and fit content height.
    private func resizeDetailContentToFit() {
        let clipWidth = detailScrollView.contentView.bounds.width
        guard clipWidth > 0 else { return }

        // Set width to match clip view, then let Auto Layout compute height.
        detailContentView.frame.size.width = clipWidth
        detailContentView.layoutSubtreeIfNeeded()

        let fittingSize = detailContentView.fittingSize
        detailContentView.frame = NSRect(
            x: 0, y: 0,
            width: clipWidth,
            height: max(fittingSize.height, 400)
        )

        detailScrollView.contentView.scroll(to: .zero)
        detailScrollView.reflectScrolledClipView(detailScrollView.contentView)
    }

    // MARK: - Overview Content

    private func buildOverviewContent() {
        guard let result = naoMgsResult else { return }

        let titleLabel = NSTextField(labelWithString: "NAO-MGS Results Overview")
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailContentView.addSubview(titleLabel)

        let subtitleLabel = NSTextField(labelWithString: "Select a taxon in the table to view alignments and statistics.")
        subtitleLabel.font = .systemFont(ofSize: 11)
        subtitleLabel.textColor = .secondaryLabelColor
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailContentView.addSubview(subtitleLabel)

        // Quick stats using hosting view
        let statsView = NaoMgsOverviewView(
            taxonSummaries: result.taxonSummaries,
            totalHitReads: result.totalHitReads,
            sampleName: result.sampleName,
            onTaxonSelected: { [weak self] taxId in
                self?.selectTaxonById(taxId)
            }
        )
        let hostingView = NSHostingView(rootView: statsView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        detailContentView.addSubview(hostingView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: detailContentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor, constant: -16),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor, constant: -16),

            hostingView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            hostingView.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor),
            hostingView.bottomAnchor.constraint(lessThanOrEqualTo: detailContentView.bottomAnchor, constant: -16),
        ])
    }

    // MARK: - Taxon Detail Content

    private func buildTaxonDetailContent(_ summary: NaoMgsTaxonSummary) {
        let hits = hitsByTaxon[summary.taxId] ?? []
        let accessionSummaries = NaoMgsDataConverter.buildAccessionSummaries(hits: hits)

        // 2. Taxon name header
        let nameLabel = NSTextField(labelWithString: summary.name.isEmpty ? "Taxid \(summary.taxId)" : summary.name)
        nameLabel.font = .systemFont(ofSize: 14, weight: .bold)
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        detailContentView.addSubview(nameLabel)

        let subtitleLabel = NSTextField(
            labelWithString: "Taxid: \(summary.taxId)  \u{2022}  \(summary.uniqueReadCount) unique / \(summary.hitCount) total reads  \u{2022}  \(summary.accessions.count) accessions"
        )
        subtitleLabel.font = .systemFont(ofSize: 10)
        subtitleLabel.textColor = .secondaryLabelColor
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailContentView.addSubview(subtitleLabel)

        // 3. Metrics row
        let metricsView = buildMetricsView(for: summary)
        detailContentView.addSubview(metricsView)

        // 4. Scrollable list of miniBAM panels for top accessions
        let miniBAMListView = buildMiniBAMList(accessionSummaries: accessionSummaries)
        detailContentView.addSubview(miniBAMListView)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: detailContentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor, constant: -16),

            subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor, constant: -16),

            metricsView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            metricsView.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor, constant: 16),
            metricsView.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor, constant: -16),

            miniBAMListView.topAnchor.constraint(equalTo: metricsView.bottomAnchor, constant: 12),
            miniBAMListView.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor, constant: 8),
            miniBAMListView.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor, constant: -8),
            miniBAMListView.bottomAnchor.constraint(lessThanOrEqualTo: detailContentView.bottomAnchor, constant: -8),
        ])
    }

    private func buildMiniBAMList(accessionSummaries: [NaoMgsAccessionSummary]) -> NSView {
        let container = NSView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let totalCount = accessionSummaries.count
        let displayedAccessions = Array(accessionSummaries.prefix(miniBAMDisplayLimit))
        let shownCount = displayedAccessions.count
        let scopeLabel = totalCount <= miniBAMDisplayLimit ? "All" : "Top \(miniBAMDisplayLimit)"

        let headerLabel = NSTextField(
            labelWithString: "miniBAM Panels (\(scopeLabel): \(shownCount) of \(totalCount) accessions)"
        )
        headerLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(headerLabel)

        let noteLabel = NSTextField(
            labelWithString: "Top references by unique read count. Drag a panel handle downward to make it taller."
        )
        noteLabel.font = .systemFont(ofSize: 10)
        noteLabel.textColor = .secondaryLabelColor
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(noteLabel)

        let stack = NSStackView()
        stack.orientation = .vertical
        stack.alignment = .leading
        stack.distribution = .gravityAreas
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: container.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            headerLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),

            noteLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 2),
            noteLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            noteLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),

            stack.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        guard let bamURL else {
            let emptyLabel = NSTextField(labelWithString: "No BAM file found in this bundle.")
            emptyLabel.font = .systemFont(ofSize: 11)
            emptyLabel.textColor = .secondaryLabelColor
            stack.addArrangedSubview(emptyLabel)
            return container
        }

        for accessionSummary in displayedAccessions {
            let card = NSView()
            card.wantsLayer = true
            card.layer?.cornerRadius = 6
            card.layer?.borderWidth = 1
            card.layer?.borderColor = NSColor.separatorColor.cgColor
            card.layer?.backgroundColor = NSColor.controlBackgroundColor.withAlphaComponent(0.45).cgColor
            card.translatesAutoresizingMaskIntoConstraints = false

            let uniqueReadCount = NumberFormatter.localizedString(
                from: NSNumber(value: accessionSummary.uniqueReadCount),
                number: .decimal
            )
            let readCount = NumberFormatter.localizedString(
                from: NSNumber(value: accessionSummary.readCount),
                number: .decimal
            )
            let coveragePct = String(format: "%.0f%%", accessionSummary.coverageFraction * 100)
            let titleLabel = NSTextField(
                labelWithString: "\(accessionSummary.accession)  •  \(uniqueReadCount) unique / \(readCount) total reads  •  \(coveragePct) covered"
            )
            titleLabel.font = .monospacedSystemFont(ofSize: 11, weight: .medium)
            titleLabel.lineBreakMode = .byTruncatingTail
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            card.addSubview(titleLabel)

            let miniBAM = MiniBAMViewController()
            miniBAM.subjectNoun = "reference"
            miniBAM.showsPCRDuplicates = false
            miniBAM.keyboardShortcutsEnabled = true
            addChild(miniBAM)
            miniBAMControllers.append(miniBAM)

            let bamView = miniBAM.view
            bamView.translatesAutoresizingMaskIntoConstraints = false
            card.addSubview(bamView)

            let preferredHeight = miniBAMPreferredHeights[accessionSummary.accession] ?? miniBAMDefaultHeight
            let heightConstraint = bamView.heightAnchor.constraint(equalToConstant: preferredHeight)
            miniBAM.onResizeBy = { [weak self] deltaY in
                self?.adjustMiniBAMHeight(
                    accession: accessionSummary.accession,
                    constraint: heightConstraint,
                    by: deltaY
                )
            }

            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 6),
                titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 8),
                titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -8),

                bamView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
                bamView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 4),
                bamView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -4),
                bamView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -4),
                heightConstraint,
            ])

            miniBAM.displayContig(
                bamURL: bamURL,
                contig: accessionSummary.accession,
                contigLength: max(accessionSummary.estimatedRefLength, 1),
                indexURL: bamIndexURL,
                maxReads: max(1, accessionSummary.readCount)
            )

            stack.addArrangedSubview(card)
            card.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        }

        return container
    }

    private func adjustMiniBAMHeight(
        accession: String,
        constraint: NSLayoutConstraint,
        by deltaY: CGFloat
    ) {
        let current = miniBAMPreferredHeights[accession] ?? miniBAMDefaultHeight
        let next = min(max(miniBAMMinHeight, current + deltaY), miniBAMMaxHeight)
        miniBAMPreferredHeights[accession] = next
        constraint.constant = next
        detailContentView.layoutSubtreeIfNeeded()
    }

    private func teardownEmbeddedMiniBAMControllers() {
        for controller in miniBAMControllers {
            controller.view.removeFromSuperview()
            controller.removeFromParent()
        }
        miniBAMControllers.removeAll()
    }

    private func buildMetricsView(for summary: NaoMgsTaxonSummary) -> NSView {
        let container = NSStackView()
        container.orientation = .horizontal
        container.alignment = .top
        container.distribution = .fillEqually
        container.spacing = 8
        container.translatesAutoresizingMaskIntoConstraints = false

        let metrics: [(String, String)] = [
            ("Avg Identity", String(format: "%.1f%%", summary.avgIdentity)),
            ("Avg Bit Score", String(format: "%.0f", summary.avgBitScore)),
            ("Avg Edit Dist", String(format: "%.1f", summary.avgEditDistance)),
            ("Unique Reads", naoMgsFormatCount(summary.uniqueReadCount)),
            ("Accessions", "\(summary.accessions.count)"),
        ]

        for (label, value) in metrics {
            let pill = makeMetricPill(label: label, value: value)
            container.addArrangedSubview(pill)
        }

        return container
    }

    private func makeMetricPill(label: String, value: String) -> NSView {
        let pill = NSView()
        pill.translatesAutoresizingMaskIntoConstraints = false

        let labelField = NSTextField(labelWithString: label)
        labelField.font = .systemFont(ofSize: 9, weight: .medium)
        labelField.textColor = .tertiaryLabelColor
        labelField.alignment = .center
        labelField.translatesAutoresizingMaskIntoConstraints = false

        let valueField = NSTextField(labelWithString: value)
        valueField.font = .monospacedDigitSystemFont(ofSize: 12, weight: .semibold)
        valueField.textColor = .labelColor
        valueField.alignment = .center
        valueField.translatesAutoresizingMaskIntoConstraints = false

        pill.addSubview(labelField)
        pill.addSubview(valueField)

        NSLayoutConstraint.activate([
            labelField.topAnchor.constraint(equalTo: pill.topAnchor),
            labelField.leadingAnchor.constraint(equalTo: pill.leadingAnchor),
            labelField.trailingAnchor.constraint(equalTo: pill.trailingAnchor),
            valueField.topAnchor.constraint(equalTo: labelField.bottomAnchor, constant: 2),
            valueField.leadingAnchor.constraint(equalTo: pill.leadingAnchor),
            valueField.trailingAnchor.constraint(equalTo: pill.trailingAnchor),
            valueField.bottomAnchor.constraint(equalTo: pill.bottomAnchor),
        ])

        return pill
    }

    private func buildAccessionList(accessionSummaries: [NaoMgsAccessionSummary]) -> NSView {
        let container = NSView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let headerLabel = NSTextField(labelWithString: "Reference Accessions (\(accessionSummaries.count))")
        headerLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(headerLabel)

        // Create accession table
        let tableScrollView = NSScrollView()
        tableScrollView.translatesAutoresizingMaskIntoConstraints = false
        tableScrollView.hasVerticalScroller = true
        tableScrollView.autohidesScrollers = true

        let accessionTable = NSTableView()
        accessionTable.headerView = nil
        accessionTable.rowHeight = 20
        accessionTable.style = .plain
        accessionTable.usesAlternatingRowBackgroundColors = false

        let accColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("accession"))
        accColumn.title = "Accession"
        accessionTable.addTableColumn(accColumn)

        // Use tags to identify this table vs the taxonomy table
        accessionTable.tag = 999

        // Store summaries for the data source
        let wrapper = AccessionDataWrapper(summaries: accessionSummaries, selected: selectedAccession)
        accessionTable.dataSource = wrapper
        accessionTable.delegate = wrapper
        objc_setAssociatedObject(container, &accessionDataKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        wrapper.onSelect = { [weak self] accession in
            self?.selectedAccession = accession
            self?.switchToAccession(accession)
        }

        // Right-click context menu for copying accession
        let menu = NSMenu(title: "Accession Actions")
        wrapper.contextMenu = menu
        wrapper.populateMenu = { [weak self] menu, accession in
            menu.removeAllItems()
            let copyItem = NSMenuItem(title: "Copy Accession", action: #selector(self?.contextCopyAccession(_:)), keyEquivalent: "")
            copyItem.target = self
            copyItem.representedObject = accession
            menu.addItem(copyItem)

            let viewNCBI = NSMenuItem(title: "View on NCBI", action: #selector(self?.contextViewAccessionOnNCBI(_:)), keyEquivalent: "")
            viewNCBI.target = self
            viewNCBI.representedObject = accession
            menu.addItem(viewNCBI)
        }
        accessionTable.menu = menu

        tableScrollView.documentView = accessionTable

        container.addSubview(tableScrollView)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: container.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            tableScrollView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 4),
            tableScrollView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            tableScrollView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            tableScrollView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            tableScrollView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        return container
    }

    // MARK: - Taxon Selection

    /// Selects a taxon by its taxonomy ID, updating both the table and detail pane.
    private func selectTaxonById(_ taxId: Int) {
        guard naoMgsResult != nil else { return }
        let summaries = displayedSummaries
        guard let index = summaries.firstIndex(where: { $0.taxId == taxId }) else { return }

        suppressSelectionSync = true
        taxonomyTableView.selectRowIndexes(IndexSet(integer: index), byExtendingSelection: false)
        taxonomyTableView.scrollRowToVisible(index)
        suppressSelectionSync = false

        showTaxonDetail(summaries[index])
    }

    // MARK: - Setup: Summary Bar

    private func setupSummaryBar() {
        summaryBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(summaryBar)
    }

    // MARK: - Setup: Split View

    /// Configures the NSSplitView with detail pane (left) and taxonomy table (right).
    ///
    /// Uses raw NSSplitView (not NSSplitViewController) per macOS 26 rules.
    private func setupSplitView() {
        splitView.translatesAutoresizingMaskIntoConstraints = false
        splitView.isVertical = true
        splitView.dividerStyle = .thin
        splitView.delegate = self

        // Left pane: detail (miniBAM + metrics + accessions).
        // The detail pane is a self-contained NSView that uses an internal scroll view.
        let detail = NaoMgsDetailContainer(scrollView: detailScrollView, contentView: detailContentView)
        detailContainer = detail

        // Right pane: taxonomy table
        let tableContainer = NSView()
        setupTaxonomyTable()
        setupTaxonomyFilterBar(in: tableContainer)

        splitView.addArrangedSubview(detail)
        splitView.addArrangedSubview(tableContainer)

        // Table pane resizes first; detail pane holds width firmly.
        splitView.setHoldingPriority(.defaultHigh, forSubviewAt: 0)
        splitView.setHoldingPriority(.defaultLow, forSubviewAt: 1)

        // Force initial layout so both panes are visible.
        splitView.adjustSubviews()

        view.addSubview(splitView)
    }

    /// Configures the taxonomy table with columns for taxon data.
    private func setupTaxonomyTable() {
        taxonomyTableView.headerView = NSTableHeaderView()
        taxonomyTableView.usesAlternatingRowBackgroundColors = true
        taxonomyTableView.allowsMultipleSelection = false
        taxonomyTableView.allowsColumnReordering = true
        taxonomyTableView.allowsColumnResizing = true
        taxonomyTableView.style = .inset
        taxonomyTableView.intercellSpacing = NSSize(width: 8, height: 2)
        taxonomyTableView.rowHeight = 22

        // Columns
        let sampleColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("sample"))
        sampleColumn.title = "Sample"
        sampleColumn.width = 130
        sampleColumn.minWidth = 90
        sampleColumn.sortDescriptorPrototype = NSSortDescriptor(key: "sample", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        taxonomyTableView.addTableColumn(sampleColumn)

        let nameColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("name"))
        nameColumn.title = "Taxon"
        nameColumn.width = 210
        nameColumn.minWidth = 120
        nameColumn.sortDescriptorPrototype = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        taxonomyTableView.addTableColumn(nameColumn)

        let hitsColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("hits"))
        hitsColumn.title = "Hits"
        hitsColumn.width = 64
        hitsColumn.minWidth = 48
        hitsColumn.sortDescriptorPrototype = NSSortDescriptor(key: "hits", ascending: false)
        taxonomyTableView.addTableColumn(hitsColumn)

        let uniqueColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("unique"))
        uniqueColumn.title = "Unique Reads"
        uniqueColumn.width = 96
        uniqueColumn.minWidth = 72
        uniqueColumn.sortDescriptorPrototype = NSSortDescriptor(key: "unique", ascending: false)
        taxonomyTableView.addTableColumn(uniqueColumn)

        let refsColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("refs"))
        refsColumn.title = "Refs"
        refsColumn.width = 52
        refsColumn.minWidth = 40
        refsColumn.sortDescriptorPrototype = NSSortDescriptor(key: "refs", ascending: false)
        taxonomyTableView.addTableColumn(refsColumn)

        taxonomyTableView.dataSource = self
        taxonomyTableView.delegate = self
        taxonomyTableView.menu = buildContextMenu()

        // Sort by hits descending initially
        taxonomyTableView.sortDescriptors = [
            NSSortDescriptor(key: "hits", ascending: false)
        ]

        // Scroll view setup
        taxonomyTableScrollView.documentView = taxonomyTableView
        taxonomyTableScrollView.hasVerticalScroller = true
        taxonomyTableScrollView.hasHorizontalScroller = false
        taxonomyTableScrollView.autohidesScrollers = true
        taxonomyTableScrollView.drawsBackground = true

        taxonomyTableView.setAccessibilityLabel("NAO-MGS Taxonomy Table")
    }

    private func setupTaxonomyFilterBar(in container: NSView) {
        container.translatesAutoresizingMaskIntoConstraints = false

        taxonomyFilterBar.translatesAutoresizingMaskIntoConstraints = false
        taxonomyFilterBar.orientation = .horizontal
        taxonomyFilterBar.alignment = .centerY
        taxonomyFilterBar.spacing = 6
        container.addSubview(taxonomyFilterBar)

        configureFilterField(sampleFilterField, placeholder: "Sample", width: 130, numeric: false)
        configureFilterField(taxonFilterField, placeholder: "Taxon", width: 180, numeric: false)
        configureFilterField(hitsFilterField, placeholder: "Min Hits", width: 70, numeric: true)
        configureFilterField(uniqueReadsFilterField, placeholder: "Min Unique", width: 82, numeric: true)
        configureFilterField(refsFilterField, placeholder: "Min Refs", width: 70, numeric: true)

        taxonomyFilterBar.addArrangedSubview(sampleFilterField)
        taxonomyFilterBar.addArrangedSubview(taxonFilterField)
        taxonomyFilterBar.addArrangedSubview(hitsFilterField)
        taxonomyFilterBar.addArrangedSubview(uniqueReadsFilterField)
        taxonomyFilterBar.addArrangedSubview(refsFilterField)

        taxonomyTableScrollView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(taxonomyTableScrollView)

        NSLayoutConstraint.activate([
            taxonomyFilterBar.topAnchor.constraint(equalTo: container.topAnchor, constant: 6),
            taxonomyFilterBar.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 6),
            taxonomyFilterBar.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -6),

            taxonomyTableScrollView.topAnchor.constraint(equalTo: taxonomyFilterBar.bottomAnchor, constant: 6),
            taxonomyTableScrollView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            taxonomyTableScrollView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            taxonomyTableScrollView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
    }

    private func configureFilterField(
        _ field: NSTextField,
        placeholder: String,
        width: CGFloat,
        numeric: Bool
    ) {
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholderString = placeholder
        field.font = .systemFont(ofSize: 11)
        field.controlSize = .small
        field.delegate = self
        field.target = self
        field.action = #selector(taxonomyFilterChanged(_:))
        if numeric {
            field.alignment = .right
        }
        field.widthAnchor.constraint(equalToConstant: width).isActive = true
    }

    @objc private func taxonomyFilterChanged(_ sender: Any?) {
        applyTaxonomyFilters()
    }

    // MARK: - Setup: Action Bar

    private func setupActionBar() {
        actionBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionBar)
    }

    // MARK: - Layout

    private func layoutSubviews() {
        NSLayoutConstraint.activate([
            // Summary bar (top)
            summaryBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            summaryBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            summaryBar.heightAnchor.constraint(equalToConstant: 48),

            // Action bar (bottom, fixed height)
            actionBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            actionBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            actionBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            actionBar.heightAnchor.constraint(equalToConstant: 36),

            // Split view (fills remaining space)
            splitView.topAnchor.constraint(equalTo: summaryBar.bottomAnchor),
            splitView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            splitView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        let bottomConstraint = splitView.bottomAnchor.constraint(equalTo: actionBar.topAnchor)
        bottomConstraint.isActive = true
        splitViewBottomConstraint = bottomConstraint
    }

    private func applySplitPositionIfNeeded(force: Bool) {
        guard splitView.arrangedSubviews.count >= 2 else { return }
        guard splitView.bounds.width > 0 else {
            if force {
                didSetInitialSplitPosition = false
            }
            return
        }

        guard force || !didSetInitialSplitPosition else { return }

        // Detail pane on left gets 40%, taxonomy table on right gets 60%.
        let position = round(splitView.bounds.width * 0.4)
        splitView.setPosition(position, ofDividerAt: 0)
        didSetInitialSplitPosition = true
        resizeDetailContentToFit()
    }

    // MARK: - Callback Wiring

    private func wireCallbacks() {
        actionBar.onExport = { [weak self] in
            self?.exportResults()
        }
    }

    // MARK: - BLAST Drawer

    public func showBlastLoading(phase: BlastJobPhase, requestId: String?) {
        let drawer = ensureBlastDrawer()
        drawer.showLoading(phase: phase, requestId: requestId)
        openBlastDrawerIfNeeded()
    }

    public func showBlastResults(_ result: BlastVerificationResult) {
        let drawer = ensureBlastDrawer()
        drawer.showResults(result)
        openBlastDrawerIfNeeded()
    }

    public func showBlastFailure(_ message: String) {
        let drawer = ensureBlastDrawer()
        drawer.showFailure(message: message)
        openBlastDrawerIfNeeded()
    }

    private func ensureBlastDrawer() -> BlastResultsDrawerTab {
        if let blastDrawerView {
            return blastDrawerView
        }

        let drawer = BlastResultsDrawerTab()
        drawer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drawer)

        let bottomConstraint = drawer.bottomAnchor.constraint(equalTo: actionBar.topAnchor, constant: 220)

        NSLayoutConstraint.activate([
            drawer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            drawer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            drawer.heightAnchor.constraint(equalToConstant: 220),
            bottomConstraint,
        ])

        splitViewBottomConstraint?.isActive = false
        let newSplitBottom = splitView.bottomAnchor.constraint(equalTo: drawer.topAnchor)
        newSplitBottom.isActive = true
        splitViewBottomConstraint = newSplitBottom

        blastDrawerView = drawer
        blastDrawerBottomConstraint = bottomConstraint
        view.layoutSubtreeIfNeeded()

        return drawer
    }

    private func openBlastDrawerIfNeeded() {
        guard !isBlastDrawerOpen else { return }
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            context.allowsImplicitAnimation = true
            blastDrawerBottomConstraint?.animator().constant = 0
            view.layoutSubtreeIfNeeded()
        }
        isBlastDrawerOpen = true
    }

    // MARK: - Context Menu

    private func buildContextMenu() -> NSMenu {
        let menu = NSMenu(title: "Taxon Actions")
        menu.delegate = self
        return menu
    }

    private struct BlastMenuSelection {
        let summary: NaoMgsTaxonSummary
        let count: Int
        let uniqueHits: [NaoMgsVirusHit]
    }

    /// Deduplicates hits using the same accession/start/end/strand heuristic used
    /// for NAO duplicate estimation, keeping one representative hit per group.
    private func uniqueHitsForBLAST(taxId: Int) -> [NaoMgsVirusHit] {
        let hits = hitsByTaxon[taxId] ?? []
        guard !hits.isEmpty else { return [] }

        var unique: [NaoMgsVirusHit] = []
        unique.reserveCapacity(hits.count)
        var seenKeys: Set<String> = []

        // Prefer higher-confidence representatives when duplicate groups exist.
        let orderedHits = hits.sorted {
            if $0.editDistance != $1.editDistance {
                return $0.editDistance < $1.editDistance
            }
            return $0.bitScore > $1.bitScore
        }

        for hit in orderedHits {
            let strand = hit.isReverseComplement ? "R" : "F"
            let readLength = hit.queryLength > 0 ? hit.queryLength : max(0, hit.readSequence.count)
            let inferredRefEnd = max(hit.refEnd, hit.refStart + max(1, readLength))
            let key = "\(hit.subjectSeqId)|\(hit.refStart)|\(inferredRefEnd)|\(strand)"
            if seenKeys.insert(key).inserted {
                unique.append(hit)
            }
        }

        return unique
    }

    private func addBlastItem(
        to menu: NSMenu,
        summary: NaoMgsTaxonSummary,
        count: Int,
        uniqueHits: [NaoMgsVirusHit]
    ) {
        let item = NSMenuItem(
            title: "BLAST \(count) reads",
            action: #selector(contextBlastVerify(_:)),
            keyEquivalent: ""
        )
        item.target = self
        item.representedObject = BlastMenuSelection(summary: summary, count: count, uniqueHits: uniqueHits)
        menu.addItem(item)
    }

    private func populateContextMenu(_ menu: NSMenu, for summary: NaoMgsTaxonSummary) {
        menu.removeAllItems()

        let uniqueHits = uniqueHitsForBLAST(taxId: summary.taxId)
        let blastCandidates: [NaoMgsVirusHit]
        if uniqueHits.isEmpty {
            logger.error("Expected >=1 unique hit for taxon \(summary.taxId), falling back to raw hits")
            blastCandidates = hitsByTaxon[summary.taxId] ?? []
        } else {
            blastCandidates = uniqueHits
        }
        let uniqueCount = blastCandidates.count

        // BLAST options based on unique-read count:
        // >50: offer 20 and 50
        // 21...50: offer 20 and X
        // <=20: offer X
        if uniqueCount > 50 {
            addBlastItem(to: menu, summary: summary, count: 20, uniqueHits: blastCandidates)
            addBlastItem(to: menu, summary: summary, count: 50, uniqueHits: blastCandidates)
        } else if uniqueCount > 20 {
            addBlastItem(to: menu, summary: summary, count: 20, uniqueHits: blastCandidates)
            addBlastItem(to: menu, summary: summary, count: uniqueCount, uniqueHits: blastCandidates)
        } else if uniqueCount > 0 {
            addBlastItem(to: menu, summary: summary, count: uniqueCount, uniqueHits: blastCandidates)
        }

        menu.addItem(NSMenuItem.separator())

        // Copy Taxon ID
        let copyTaxId = NSMenuItem(title: "Copy Taxon ID", action: #selector(contextCopyTaxonId(_:)), keyEquivalent: "")
        copyTaxId.target = self
        copyTaxId.representedObject = summary
        menu.addItem(copyTaxId)

        // Copy accessions
        if !summary.accessions.isEmpty {
            let copyAccessions = NSMenuItem(title: "Copy Accessions", action: #selector(contextCopyAccessions(_:)), keyEquivalent: "")
            copyAccessions.target = self
            copyAccessions.representedObject = summary
            menu.addItem(copyAccessions)
        }

        menu.addItem(NSMenuItem.separator())

        // View on NCBI
        let viewNCBI = NSMenuItem(title: "View on NCBI", action: #selector(contextViewOnNCBI(_:)), keyEquivalent: "")
        viewNCBI.target = self
        viewNCBI.representedObject = summary
        menu.addItem(viewNCBI)

        let viewTaxonomy = NSMenuItem(title: "View Taxonomy on NCBI", action: #selector(contextViewTaxonomyOnNCBI(_:)), keyEquivalent: "")
        viewTaxonomy.target = self
        viewTaxonomy.representedObject = summary
        menu.addItem(viewTaxonomy)

        let searchPubMed = NSMenuItem(title: "Search PubMed", action: #selector(contextSearchPubMed(_:)), keyEquivalent: "")
        searchPubMed.target = self
        searchPubMed.representedObject = summary
        menu.addItem(searchPubMed)
    }

    // MARK: - Context Menu Actions

    @objc private func contextBlastVerify(_ sender: NSMenuItem) {
        guard let selection = sender.representedObject as? BlastMenuSelection else { return }
        let selectedReads = NaoMgsDataConverter.selectBlastReads(
            hits: selection.uniqueHits,
            count: selection.count
        )
        logger.info(
            "BLAST verify taxon \(selection.summary.taxId): \(selectedReads.count) reads selected from \(selection.uniqueHits.count) unique reads"
        )
        onBlastVerification?(selection.summary, selectedReads.count, selectedReads)
    }

    @objc private func contextCopyTaxonId(_ sender: NSMenuItem) {
        guard let summary = sender.representedObject as? NaoMgsTaxonSummary else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("\(summary.taxId)", forType: .string)
    }

    @objc private func contextCopyAccessions(_ sender: NSMenuItem) {
        guard let summary = sender.representedObject as? NaoMgsTaxonSummary else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(summary.accessions.joined(separator: "\n"), forType: .string)
    }

    @objc func contextCopyAccession(_ sender: NSMenuItem) {
        guard let accession = sender.representedObject as? String else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(accession, forType: .string)
    }

    @objc func contextViewAccessionOnNCBI(_ sender: NSMenuItem) {
        guard let accession = sender.representedObject as? String else { return }
        let url = URL(string: "https://www.ncbi.nlm.nih.gov/nuccore/\(accession)")!
        NSWorkspace.shared.open(url)
    }

    @objc private func contextViewOnNCBI(_ sender: NSMenuItem) {
        guard let summary = sender.representedObject as? NaoMgsTaxonSummary else { return }
        let url = URL(string: "https://www.ncbi.nlm.nih.gov/nuccore/?term=txid\(summary.taxId)[Organism:exp]")!
        NSWorkspace.shared.open(url)
    }

    @objc private func contextViewTaxonomyOnNCBI(_ sender: NSMenuItem) {
        guard let summary = sender.representedObject as? NaoMgsTaxonSummary else { return }
        let url = URL(string: "https://www.ncbi.nlm.nih.gov/datasets/taxonomy/\(summary.taxId)/")!
        NSWorkspace.shared.open(url)
    }

    @objc private func contextSearchPubMed(_ sender: NSMenuItem) {
        guard let summary = sender.representedObject as? NaoMgsTaxonSummary else { return }
        let encodedName = summary.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? summary.name
        let url = URL(string: "https://pubmed.ncbi.nlm.nih.gov/?term=\(encodedName)")!
        NSWorkspace.shared.open(url)
    }

    // MARK: - NSSplitViewDelegate

    public func splitView(
        _ splitView: NSSplitView,
        constrainMinCoordinate proposedMinimumPosition: CGFloat,
        ofSubviewAt dividerIndex: Int
    ) -> CGFloat {
        max(proposedMinimumPosition, 250)
    }

    public func splitView(
        _ splitView: NSSplitView,
        constrainMaxCoordinate proposedMaximumPosition: CGFloat,
        ofSubviewAt dividerIndex: Int
    ) -> CGFloat {
        min(proposedMaximumPosition, splitView.bounds.width - 300)
    }

    // MARK: - Export

    public func exportResults() {
        guard let result = naoMgsResult, let window = view.window else { return }

        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.tabSeparatedText]
        savePanel.nameFieldStringValue = "\(result.sampleName)_naomgs_summary.tsv"
        savePanel.title = "Export NAO-MGS Summary"

        savePanel.beginSheetModal(for: window) { [weak self] response in
            guard response == .OK, let url = savePanel.url,
                  let self, let result = self.naoMgsResult else { return }

            var lines: [String] = []
            lines.append("taxon_id\tname\thit_count\tunique_read_count\tpcr_duplicate_count\tavg_identity\tavg_bit_score\tavg_edit_distance\taccessions")

            for summary in result.taxonSummaries {
                let accStr = summary.accessions.joined(separator: ",")
                lines.append("\(summary.taxId)\t\(summary.name)\t\(summary.hitCount)\t\(summary.uniqueReadCount)\t\(summary.pcrDuplicateCount)\t\(String(format: "%.2f", summary.avgIdentity))\t\(String(format: "%.1f", summary.avgBitScore))\t\(String(format: "%.1f", summary.avgEditDistance))\t\(accStr)")
            }

            let content = lines.joined(separator: "\n") + "\n"
            do {
                try content.write(to: url, atomically: true, encoding: .utf8)
                logger.info("Exported NAO-MGS summary to \(url.lastPathComponent, privacy: .public)")
            } catch {
                logger.error("Failed to export NAO-MGS summary: \(error.localizedDescription, privacy: .public)")
            }
        }
    }

    // MARK: - Filtered / Sorted Data

    private static func buildSampleNamesByTaxId(
        hitsByTaxon: [Int: [NaoMgsVirusHit]],
        fallbackSampleName: String
    ) -> [Int: String] {
        hitsByTaxon.mapValues { taxHits in
            let names = Array(Set(taxHits.map(\.sample).filter { !$0.isEmpty })).sorted()
            if names.isEmpty {
                return fallbackSampleName
            }
            return names.joined(separator: ", ")
        }
    }

    private func sampleLabel(forTaxId taxId: Int) -> String {
        sampleNamesByTaxId[taxId] ?? naoMgsResult?.sampleName ?? "—"
    }

    private func parseMinFilter(_ rawValue: String) -> Int? {
        let trimmed = rawValue
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        let lower = trimmed.lowercased()
        if lower.hasSuffix("k"), let value = Double(lower.dropLast()) {
            return Int(value * 1_000)
        }
        if lower.hasSuffix("m"), let value = Double(lower.dropLast()) {
            return Int(value * 1_000_000)
        }
        return Int(lower)
    }

    private var displayedSummaries: [NaoMgsTaxonSummary] {
        guard let result = naoMgsResult else { return [] }
        var summaries = result.taxonSummaries

        let sampleFilter = sampleFilterField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        if !sampleFilter.isEmpty {
            summaries = summaries.filter { sampleLabel(forTaxId: $0.taxId).localizedCaseInsensitiveContains(sampleFilter) }
        }

        let taxonFilter = taxonFilterField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        if !taxonFilter.isEmpty {
            summaries = summaries.filter {
                ($0.name.isEmpty ? "Taxid \($0.taxId)" : $0.name)
                    .localizedCaseInsensitiveContains(taxonFilter)
            }
        }

        if let minHits = parseMinFilter(hitsFilterField.stringValue) {
            summaries = summaries.filter { $0.hitCount >= minHits }
        }
        if let minUnique = parseMinFilter(uniqueReadsFilterField.stringValue) {
            summaries = summaries.filter { $0.uniqueReadCount >= minUnique }
        }
        if let minRefs = parseMinFilter(refsFilterField.stringValue) {
            summaries = summaries.filter { $0.accessions.count >= minRefs }
        }

        if let sortDescriptor = taxonomyTableView.sortDescriptors.first {
            switch sortDescriptor.key {
            case "sample":
                summaries.sort {
                    let lhs = sampleLabel(forTaxId: $0.taxId)
                    let rhs = sampleLabel(forTaxId: $1.taxId)
                    let compare = lhs.localizedCaseInsensitiveCompare(rhs)
                    return sortDescriptor.ascending ? compare == .orderedAscending : compare == .orderedDescending
                }
            case "name":
                summaries.sort {
                    let compare = $0.name.localizedCaseInsensitiveCompare($1.name)
                    return sortDescriptor.ascending ? compare == .orderedAscending : compare == .orderedDescending
                }
            case "hits":
                summaries.sort {
                    sortDescriptor.ascending ? $0.hitCount < $1.hitCount : $0.hitCount > $1.hitCount
                }
            case "unique":
                summaries.sort {
                    sortDescriptor.ascending
                        ? $0.uniqueReadCount < $1.uniqueReadCount
                        : $0.uniqueReadCount > $1.uniqueReadCount
                }
            case "refs":
                summaries.sort {
                    sortDescriptor.ascending
                        ? $0.accessions.count < $1.accessions.count
                        : $0.accessions.count > $1.accessions.count
                }
            default:
                break
            }
        }

        return summaries
    }

    private func applyTaxonomyFilters() {
        let selectedTaxId = selectedTaxonSummary?.taxId
        taxonomyTableView.reloadData()

        guard !displayedSummaries.isEmpty else {
            suppressSelectionSync = true
            taxonomyTableView.deselectAll(nil)
            suppressSelectionSync = false
            showOverview()
            return
        }

        if let selectedTaxId,
           let idx = displayedSummaries.firstIndex(where: { $0.taxId == selectedTaxId }) {
            suppressSelectionSync = true
            taxonomyTableView.selectRowIndexes(IndexSet(integer: idx), byExtendingSelection: false)
            suppressSelectionSync = false
            return
        }

        suppressSelectionSync = true
        taxonomyTableView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
        suppressSelectionSync = false
        showTaxonDetail(displayedSummaries[0])
    }
}

// MARK: - FlippedNaoMgsContentView

/// Flipped container so Auto Layout `topAnchor` maps to visual top.
private final class FlippedNaoMgsContentView: NSView {
    override var isFlipped: Bool { true }
}

// MARK: - NaoMgsDetailContainer

/// A self-contained detail pane container that manages a scroll view filling its bounds.
///
/// This is added directly as an NSSplitView arranged subview. NSSplitView
/// manages its frame via frame-based layout. The container fills itself
/// with the scroll view using autoresizing masks.
private final class NaoMgsDetailContainer: NSView {

    let scrollView: NSScrollView
    let contentView: FlippedNaoMgsContentView

    init(scrollView: NSScrollView, contentView: FlippedNaoMgsContentView) {
        self.scrollView = scrollView
        self.contentView = contentView
        super.init(frame: .zero)

        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.drawsBackground = false
        scrollView.documentView = contentView
        scrollView.autoresizingMask = [.width, .height]
        addSubview(scrollView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    override var isFlipped: Bool { true }

    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        scrollView.frame = bounds
    }
}

// MARK: - NSTableViewDataSource

extension NaoMgsResultViewController: NSTableViewDataSource {

    public func numberOfRows(in tableView: NSTableView) -> Int {
        displayedSummaries.count
    }

    public func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        applyTaxonomyFilters()
    }
}

// MARK: - NSTableViewDelegate

extension NaoMgsResultViewController: NSTableViewDelegate {

    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let summaries = displayedSummaries
        guard row < summaries.count else { return nil }

        let summary = summaries[row]
        let identifier = tableColumn?.identifier ?? NSUserInterfaceItemIdentifier("default")

        let cellView = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView
            ?? makeCellView(identifier: identifier)

        switch identifier.rawValue {
        case "sample":
            cellView.textField?.stringValue = sampleLabel(forTaxId: summary.taxId)
            cellView.textField?.font = .systemFont(ofSize: 11)
            cellView.textField?.lineBreakMode = .byTruncatingTail
            cellView.textField?.alignment = .left
        case "name":
            cellView.textField?.stringValue = summary.name.isEmpty ? "Taxid \(summary.taxId)" : summary.name
            cellView.textField?.font = .systemFont(ofSize: 11)
            cellView.textField?.lineBreakMode = .byTruncatingTail
            cellView.textField?.alignment = .left
        case "hits":
            cellView.textField?.stringValue = naoMgsFormatCount(summary.hitCount)
            cellView.textField?.font = .monospacedDigitSystemFont(ofSize: 11, weight: .medium)
            cellView.textField?.alignment = .right
        case "unique":
            cellView.textField?.stringValue = naoMgsFormatCount(summary.uniqueReadCount)
            cellView.textField?.font = .monospacedDigitSystemFont(ofSize: 11, weight: .regular)
            cellView.textField?.alignment = .right
        case "refs":
            cellView.textField?.stringValue = "\(summary.accessions.count)"
            cellView.textField?.font = .monospacedDigitSystemFont(ofSize: 11, weight: .regular)
            cellView.textField?.alignment = .right
        default:
            cellView.textField?.stringValue = ""
        }

        return cellView
    }

    public func tableViewSelectionDidChange(_ notification: Notification) {
        guard !suppressSelectionSync else { return }

        let row = taxonomyTableView.selectedRow
        let summaries = displayedSummaries

        if row >= 0, row < summaries.count {
            showTaxonDetail(summaries[row])
        } else {
            showOverview()
        }
    }

    private func makeCellView(identifier: NSUserInterfaceItemIdentifier) -> NSTableCellView {
        let cell = NSTableCellView()
        cell.identifier = identifier

        let textField = NSTextField(labelWithString: "")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.lineBreakMode = .byTruncatingTail
        textField.cell?.truncatesLastVisibleLine = true
        cell.addSubview(textField)
        cell.textField = textField

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 2),
            textField.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -2),
            textField.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
        ])

        return cell
    }
}

/// Formats a count with K/M suffixes for the taxonomy table.
private func naoMgsFormatCount(_ count: Int) -> String {
    if count >= 1_000_000 { return String(format: "%.1fM", Double(count) / 1_000_000) }
    if count >= 1_000 { return String(format: "%.1fK", Double(count) / 1_000) }
    return "\(count)"
}

// MARK: - NSMenuDelegate

extension NaoMgsResultViewController: NSMenuDelegate {

    public func menuNeedsUpdate(_ menu: NSMenu) {
        let clickedRow = taxonomyTableView.clickedRow
        let summaries = displayedSummaries

        guard clickedRow >= 0, clickedRow < summaries.count else {
            menu.removeAllItems()
            return
        }

        populateContextMenu(menu, for: summaries[clickedRow])
    }
}

extension NaoMgsResultViewController: NSTextFieldDelegate {
    public func controlTextDidChange(_ obj: Notification) {
        applyTaxonomyFilters()
    }
}

// MARK: - NaoMgsSummaryBar

@MainActor
final class NaoMgsSummaryBar: GenomicSummaryCardBar {

    private var totalHits: Int = 0
    private var taxonCount: Int = 0
    private var topTaxonName: String = ""
    private var sampleName: String = ""

    func update(result: NaoMgsResult) {
        totalHits = result.totalHitReads
        taxonCount = result.taxonSummaries.count
        let firstName = result.taxonSummaries.first?.name ?? ""
        topTaxonName = firstName.isEmpty
            ? (result.taxonSummaries.first.map { "Taxid \($0.taxId)" } ?? "\u{2014}")
            : firstName
        sampleName = result.sampleName
        needsDisplay = true
    }

    override var cards: [Card] {
        [
            Card(label: "Virus Hits", value: GenomicSummaryCardBar.formatCount(totalHits)),
            Card(label: "Unique Taxa", value: "\(taxonCount)"),
            Card(label: "Top Taxon", value: topTaxonName),
            Card(label: "Sample", value: sampleName),
        ]
    }

    override func abbreviatedLabel(for label: String) -> String {
        switch label {
        case "Virus Hits": return "Hits"
        case "Unique Taxa": return "Taxa"
        case "Top Taxon": return "Top"
        default: return super.abbreviatedLabel(for: label)
        }
    }
}

// MARK: - NaoMgsActionBar

@MainActor
final class NaoMgsActionBar: NSView {

    var onExport: (() -> Void)?

    private var totalHits: Int = 0

    private let exportButton = NSButton(title: "Export", target: nil, action: nil)
    let infoLabel = NSTextField(labelWithString: "")
    private let separator = NSBox()

    override init(frame: NSRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        separator.boxType = .separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)

        exportButton.translatesAutoresizingMaskIntoConstraints = false
        exportButton.bezelStyle = .accessoryBarAction
        exportButton.image = NSImage(systemSymbolName: "square.and.arrow.up", accessibilityDescription: "Export")
        exportButton.imagePosition = .imageLeading
        exportButton.target = self
        exportButton.action = #selector(exportTapped(_:))
        exportButton.setContentHuggingPriority(.required, for: .horizontal)
        addSubview(exportButton)

        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = .systemFont(ofSize: 11, weight: .regular)
        infoLabel.textColor = .secondaryLabelColor
        infoLabel.lineBreakMode = .byTruncatingTail
        infoLabel.stringValue = "Select a taxon to view details"
        addSubview(infoLabel)

        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: topAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),

            exportButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            exportButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            infoLabel.leadingAnchor.constraint(equalTo: exportButton.trailingAnchor, constant: 12),
            infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            infoLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -12),
        ])

        setAccessibilityRole(.toolbar)
        setAccessibilityLabel("NAO-MGS Action Bar")
    }

    func configure(totalHits: Int, taxonCount: Int) {
        self.totalHits = totalHits
    }

    func updateSelection(_ summary: NaoMgsTaxonSummary?) {
        if let summary {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            let readStr = formatter.string(from: NSNumber(value: summary.hitCount)) ?? "\(summary.hitCount)"

            let pct = totalHits > 0
                ? Double(summary.hitCount) / Double(totalHits) * 100
                : 0
            let pctStr = String(format: "%.1f%%", pct)

            infoLabel.stringValue = "\(summary.name) \u{2014} \(readStr) hits (\(pctStr))"
            infoLabel.textColor = .labelColor
        } else {
            infoLabel.stringValue = "Select a taxon to view details"
            infoLabel.textColor = .secondaryLabelColor
        }
    }

    var infoText: String {
        infoLabel.stringValue
    }

    @objc private func exportTapped(_ sender: NSButton) {
        onExport?()
    }
}

// MARK: - AccessionDataWrapper

/// Lightweight data source for the accession table in the detail pane.
///
/// Stored as an associated object on the container view to keep it alive.
nonisolated(unsafe) private var accessionDataKey: UInt8 = 0

@MainActor
private final class AccessionDataWrapper: NSObject, NSTableViewDataSource, NSTableViewDelegate {

    let summaries: [NaoMgsAccessionSummary]
    var selectedAccession: String?
    var onSelect: ((String) -> Void)?
    var contextMenu: NSMenu?
    var populateMenu: ((NSMenu, String) -> Void)?

    init(summaries: [NaoMgsAccessionSummary], selected: String?) {
        self.summaries = summaries
        self.selectedAccession = selected
        super.init()
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        summaries.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard row < summaries.count else { return nil }
        let summary = summaries[row]

        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("accRow"), owner: nil) as? NSTableCellView ?? {
            let c = NSTableCellView()
            c.identifier = NSUserInterfaceItemIdentifier("accRow")
            let tf = NSTextField(labelWithString: "")
            tf.translatesAutoresizingMaskIntoConstraints = false
            tf.lineBreakMode = .byTruncatingTail
            c.addSubview(tf)
            c.textField = tf
            NSLayoutConstraint.activate([
                tf.leadingAnchor.constraint(equalTo: c.leadingAnchor, constant: 2),
                tf.trailingAnchor.constraint(equalTo: c.trailingAnchor, constant: -2),
                tf.centerYAnchor.constraint(equalTo: c.centerYAnchor),
            ])
            return c
        }()

        let coveragePct = String(format: "%.0f%%", summary.coverageFraction * 100)
        cell.textField?.stringValue = "\(summary.accession)  \(naoMgsFormatCount(summary.readCount)) reads  \(coveragePct)"
        cell.textField?.font = .monospacedSystemFont(ofSize: 10, weight: .regular)

        if summary.accession == selectedAccession {
            cell.textField?.textColor = .controlAccentColor
        } else {
            cell.textField?.textColor = .labelColor
        }

        return cell
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let tableView = notification.object as? NSTableView else { return }
        let row = tableView.selectedRow
        guard row >= 0, row < summaries.count else { return }
        let accession = summaries[row].accession
        selectedAccession = accession
        onSelect?(accession)
    }

    func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
        []
    }
}
