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
/// |  Taxonomy Table    |   Detail Pane               |
/// |                    |                              |
/// |  - Taxid 130309    |   Coverage Plot             |
/// |    125,727 hits    |   [================------]  |
/// |  - Taxid 28284     |                              |
/// |    36,577 hits     |   Edit Distance Histogram   |
/// |  - Taxid 1891713   |   [|||||||]                 |
/// |    7,086 hits      |                              |
/// |  ...               |   Fragment Length Dist       |
/// |                    |   [   ||||   ]              |
/// |                    |                              |
/// |                    |   Top Accessions:           |
/// |                    |   KU162869.1 (36,577 reads) |
/// +--------------------------------------------------+
/// | Action Bar (36pt)                                 |
/// +--------------------------------------------------+
/// ```
///
/// ## BLAST Verification
///
/// The taxonomy table has a right-click context menu with BLAST verification
/// options. Reads are selected using a coverage-stratified algorithm (see
/// ``NaoMgsDataConverter/selectBlastReads(hits:count:referenceLength:)``)
/// that draws from all genome quartiles for thorough verification.
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

    // MARK: - Child Views

    private let summaryBar = NaoMgsSummaryBar()
    let splitView = NSSplitView()
    private let taxonomyTableScrollView = NSScrollView()
    private let taxonomyTableView = NSTableView()
    private var detailHostingView: NSHostingView<AnyView>?
    let actionBar = NaoMgsActionBar()

    // MARK: - Split View State

    /// Whether the initial divider position has been applied.
    private var didSetInitialSplitPosition = false

    // MARK: - Selection Sync

    /// Prevents infinite feedback loops when syncing selection between views.
    private var suppressSelectionSync = false

    // MARK: - Callbacks

    /// Called when the user confirms BLAST verification for a taxon.
    ///
    /// - Parameters:
    ///   - summary: The taxon summary to verify.
    ///   - readCount: Number of reads to submit to BLAST.
    ///   - reads: The actual read sequences selected for BLAST.
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

        showOverview()
    }

    public override func viewDidLayout() {
        super.viewDidLayout()

        // Apply the initial 35/65 split once the split view has real bounds.
        // NSSplitView.setPosition is a no-op when bounds are zero, so we
        // must wait until after the first layout pass.
        if !didSetInitialSplitPosition, splitView.bounds.width > 0 {
            didSetInitialSplitPosition = true
            let position = round(splitView.bounds.width * 0.35)
            splitView.setPosition(position, ofDividerAt: 0)
        }
    }

    // MARK: - Public API

    /// Configures the view with a parsed NAO-MGS result.
    ///
    /// Populates the summary bar, taxonomy table, and detail pane with data
    /// from the result. The taxonomy table is sorted by hit count descending.
    ///
    /// - Parameter result: The parsed NAO-MGS result to display.
    public func configure(result: NaoMgsResult) {
        naoMgsResult = result
        hitsByTaxon = NaoMgsDataConverter.groupByTaxon(result.virusHits)

        // Update summary bar
        summaryBar.update(result: result)

        // Reload taxonomy table
        taxonomyTableView.reloadData()

        // Update action bar
        actionBar.configure(
            totalHits: result.totalHitReads,
            taxonCount: result.taxonSummaries.count
        )

        // Show overview in detail pane
        showOverview()

        logger.info("Configured NAO-MGS viewer with \(result.totalHitReads) hits, \(result.taxonSummaries.count) taxa, sample=\(result.sampleName, privacy: .public)")
    }

    // MARK: - Detail Pane Content

    /// Shows the overview when no taxon is selected.
    private func showOverview() {
        guard let result = naoMgsResult else { return }

        let overviewView = NaoMgsOverviewView(
            taxonSummaries: result.taxonSummaries,
            totalHitReads: result.totalHitReads,
            sampleName: result.sampleName,
            onTaxonSelected: { [weak self] taxId in
                self?.selectTaxonById(taxId)
            }
        )

        updateDetailPane(AnyView(overviewView))
        actionBar.updateSelection(nil)
    }

    /// Shows the detail pane for the selected taxon.
    ///
    /// - Parameter summary: The taxon summary to display details for.
    private func showTaxonDetail(_ summary: NaoMgsTaxonSummary) {
        selectedTaxonSummary = summary
        let hits = hitsByTaxon[summary.taxId] ?? []

        let accessionSummaries = NaoMgsDataConverter.buildAccessionSummaries(hits: hits)
        let editDistData = NaoMgsDataConverter.editDistanceDistribution(hits)
        let fragLenData = NaoMgsDataConverter.fragmentLengthDistribution(hits)

        // Use a local binding wrapper for the selected accession
        let detailView = NaoMgsDetailPaneWrapper(
            taxonSummary: summary,
            hits: hits,
            accessionSummaries: accessionSummaries,
            editDistanceData: editDistData,
            fragmentLengthData: fragLenData,
            onAccessionDoubleClicked: { [weak self] accession in
                self?.selectedAccession = accession
                logger.info("Double-clicked accession \(accession, privacy: .public) for pileup view")
            }
        )

        updateDetailPane(AnyView(detailView))
        actionBar.updateSelection(summary)
    }

    /// Replaces the detail pane content with the given SwiftUI view.
    private func updateDetailPane(_ view: AnyView) {
        if let existing = detailHostingView {
            existing.rootView = view
        } else {
            let hosting = NSHostingView(rootView: view)
            hosting.autoresizingMask = [.width, .height]
            detailHostingView = hosting

            // Add to the second split view pane
            if splitView.arrangedSubviews.count > 1 {
                let detailContainer = splitView.arrangedSubviews[1]
                hosting.frame = detailContainer.bounds
                detailContainer.addSubview(hosting)
            }
        }
    }

    // MARK: - Taxon Selection

    /// Selects a taxon by its taxonomy ID, updating both the table and detail pane.
    ///
    /// - Parameter taxId: The NCBI taxonomy ID to select.
    private func selectTaxonById(_ taxId: Int) {
        guard let result = naoMgsResult,
              let index = result.taxonSummaries.firstIndex(where: { $0.taxId == taxId }) else {
            return
        }

        suppressSelectionSync = true
        taxonomyTableView.selectRowIndexes(IndexSet(integer: index), byExtendingSelection: false)
        taxonomyTableView.scrollRowToVisible(index)
        suppressSelectionSync = false

        showTaxonDetail(result.taxonSummaries[index])
    }

    // MARK: - Setup: Summary Bar

    private func setupSummaryBar() {
        summaryBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(summaryBar)
    }

    // MARK: - Setup: Split View

    /// Configures the NSSplitView with taxonomy table (left) and detail pane (right).
    ///
    /// Uses raw NSSplitView (not NSSplitViewController) per macOS 26 rules.
    /// Delegate methods are safe on raw NSSplitView instances.
    ///
    /// **Important**: NSSplitView manages its arranged subview frames directly
    /// using frame-based layout. The container views must keep
    /// `translatesAutoresizingMaskIntoConstraints = true` (the default) so that
    /// NSSplitView's frame assignments are not overridden by Auto Layout.
    private func setupSplitView() {
        splitView.translatesAutoresizingMaskIntoConstraints = false
        splitView.isVertical = true
        splitView.dividerStyle = .thin
        splitView.delegate = self

        // Left pane: taxonomy table
        let tableContainer = NSView()
        setupTaxonomyTable()
        taxonomyTableScrollView.autoresizingMask = [.width, .height]
        tableContainer.addSubview(taxonomyTableScrollView)

        // Right pane: detail hosting view
        let detailContainer = NSView()

        splitView.addArrangedSubview(tableContainer)
        splitView.addArrangedSubview(detailContainer)

        // Table pane holds width more firmly (detail pane is preferred for resize)
        splitView.setHoldingPriority(.defaultHigh, forSubviewAt: 0)
        splitView.setHoldingPriority(.defaultLow, forSubviewAt: 1)

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
        let taxIdColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("taxId"))
        taxIdColumn.title = "Taxon ID"
        taxIdColumn.width = 72
        taxIdColumn.minWidth = 56
        taxIdColumn.sortDescriptorPrototype = NSSortDescriptor(key: "taxId", ascending: true)
        taxonomyTableView.addTableColumn(taxIdColumn)

        let nameColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("name"))
        nameColumn.title = "Name"
        nameColumn.width = 160
        nameColumn.minWidth = 80
        nameColumn.sortDescriptorPrototype = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        taxonomyTableView.addTableColumn(nameColumn)

        let hitsColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("hits"))
        hitsColumn.title = "Hits"
        hitsColumn.width = 64
        hitsColumn.minWidth = 48
        hitsColumn.sortDescriptorPrototype = NSSortDescriptor(key: "hits", ascending: false)
        taxonomyTableView.addTableColumn(hitsColumn)

        let accessionsColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("accessions"))
        accessionsColumn.title = "Accessions"
        accessionsColumn.width = 56
        accessionsColumn.minWidth = 40
        accessionsColumn.sortDescriptorPrototype = NSSortDescriptor(key: "accessions", ascending: false)
        taxonomyTableView.addTableColumn(accessionsColumn)

        let editDistColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("editDist"))
        editDistColumn.title = "Avg Edit Dist"
        editDistColumn.width = 80
        editDistColumn.minWidth = 60
        editDistColumn.sortDescriptorPrototype = NSSortDescriptor(key: "editDist", ascending: true)
        taxonomyTableView.addTableColumn(editDistColumn)

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
            splitView.bottomAnchor.constraint(equalTo: actionBar.topAnchor),
        ])
    }

    // MARK: - Callback Wiring

    private func wireCallbacks() {
        actionBar.onExport = { [weak self] in
            self?.exportResults()
        }
    }

    // MARK: - Context Menu

    /// Builds the right-click context menu for the taxonomy table.
    ///
    /// Provides BLAST verification at various read counts, Copy Taxon ID,
    /// and View on NCBI options.
    private func buildContextMenu() -> NSMenu {
        let menu = NSMenu(title: "Taxon Actions")
        menu.delegate = self
        return menu
    }

    /// Populates the context menu items for the clicked row.
    private func populateContextMenu(_ menu: NSMenu, for summary: NaoMgsTaxonSummary) {
        menu.removeAllItems()

        let hitCount = summary.hitCount

        // BLAST verification options
        let defaultCount = min(20, hitCount)
        let blast20 = NSMenuItem(
            title: "BLAST Verify (\(defaultCount) reads)",
            action: #selector(contextBlastVerify(_:)),
            keyEquivalent: ""
        )
        blast20.target = self
        blast20.representedObject = (summary, defaultCount)
        menu.addItem(blast20)

        if hitCount > 20 {
            let blast50 = NSMenuItem(
                title: "BLAST Verify (\(min(50, hitCount)) reads)",
                action: #selector(contextBlastVerify(_:)),
                keyEquivalent: ""
            )
            blast50.target = self
            blast50.representedObject = (summary, min(50, hitCount))
            menu.addItem(blast50)
        }

        if hitCount > 50 {
            let blastAll = NSMenuItem(
                title: "BLAST Verify (all \(hitCount))",
                action: #selector(contextBlastVerify(_:)),
                keyEquivalent: ""
            )
            blastAll.target = self
            blastAll.representedObject = (summary, hitCount)
            menu.addItem(blastAll)
        }

        menu.addItem(NSMenuItem.separator())

        // Copy Taxon ID
        let copyTaxId = NSMenuItem(
            title: "Copy Taxon ID",
            action: #selector(contextCopyTaxonId(_:)),
            keyEquivalent: ""
        )
        copyTaxId.target = self
        copyTaxId.representedObject = summary
        menu.addItem(copyTaxId)

        // View on NCBI
        let viewNCBI = NSMenuItem(
            title: "View on NCBI",
            action: #selector(contextViewOnNCBI(_:)),
            keyEquivalent: ""
        )
        viewNCBI.target = self
        viewNCBI.representedObject = summary
        menu.addItem(viewNCBI)

        // View on NCBI Taxonomy
        let viewTaxonomy = NSMenuItem(
            title: "View Taxonomy on NCBI",
            action: #selector(contextViewTaxonomyOnNCBI(_:)),
            keyEquivalent: ""
        )
        viewTaxonomy.target = self
        viewTaxonomy.representedObject = summary
        menu.addItem(viewTaxonomy)

        // Search PubMed
        let searchPubMed = NSMenuItem(
            title: "Search PubMed",
            action: #selector(contextSearchPubMed(_:)),
            keyEquivalent: ""
        )
        searchPubMed.target = self
        searchPubMed.representedObject = summary
        menu.addItem(searchPubMed)
    }

    // MARK: - Context Menu Actions

    /// Initiates BLAST verification with coverage-stratified read selection.
    @objc private func contextBlastVerify(_ sender: NSMenuItem) {
        guard let (summary, count) = sender.representedObject as? (NaoMgsTaxonSummary, Int) else { return }

        let hits = hitsByTaxon[summary.taxId] ?? []
        let selectedReads = NaoMgsDataConverter.selectBlastReads(hits: hits, count: count)

        logger.info("BLAST verify taxon \(summary.taxId): \(selectedReads.count) reads selected from \(hits.count) total")

        onBlastVerification?(summary, selectedReads.count, selectedReads)
    }

    /// Copies the taxonomy ID to the system pasteboard.
    @objc private func contextCopyTaxonId(_ sender: NSMenuItem) {
        guard let summary = sender.representedObject as? NaoMgsTaxonSummary else { return }
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString("\(summary.taxId)", forType: .string)
        logger.info("Copied taxon ID \(summary.taxId) to pasteboard")
    }

    /// Opens the NCBI nucleotide page for the taxon.
    @objc private func contextViewOnNCBI(_ sender: NSMenuItem) {
        guard let summary = sender.representedObject as? NaoMgsTaxonSummary else { return }
        let url = URL(string: "https://www.ncbi.nlm.nih.gov/nuccore/?term=txid\(summary.taxId)[Organism:exp]")!
        NSWorkspace.shared.open(url)
    }

    /// Opens the NCBI Taxonomy page for the taxon.
    @objc private func contextViewTaxonomyOnNCBI(_ sender: NSMenuItem) {
        guard let summary = sender.representedObject as? NaoMgsTaxonSummary else { return }
        let url = URL(string: "https://www.ncbi.nlm.nih.gov/datasets/taxonomy/\(summary.taxId)/")!
        NSWorkspace.shared.open(url)
    }

    /// Searches PubMed for the taxon name.
    @objc private func contextSearchPubMed(_ sender: NSMenuItem) {
        guard let summary = sender.representedObject as? NaoMgsTaxonSummary else { return }
        let encodedName = summary.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? summary.name
        let url = URL(string: "https://pubmed.ncbi.nlm.nih.gov/?term=\(encodedName)")!
        NSWorkspace.shared.open(url)
    }

    // MARK: - BLAST Popover

    /// Shows the BLAST configuration popover for the given taxon.
    ///
    /// - Parameters:
    ///   - summary: The taxon to verify.
    ///   - anchorView: The view to anchor the popover to.
    private func showBlastConfigPopover(for summary: NaoMgsTaxonSummary, relativeTo anchorView: NSView) {
        let popover = NSPopover()
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 280, height: 160)

        let configView = BlastConfigPopoverView(
            taxonName: summary.name,
            readsClade: summary.hitCount
        ) { [weak self, weak popover] readCount in
            popover?.performClose(nil)
            guard let self else { return }
            let hits = self.hitsByTaxon[summary.taxId] ?? []
            let selectedReads = NaoMgsDataConverter.selectBlastReads(hits: hits, count: readCount)
            self.onBlastVerification?(summary, selectedReads.count, selectedReads)
        }

        popover.contentViewController = NSHostingController(rootView: configView)

        let anchorRect = NSRect(
            x: anchorView.bounds.midX - 1,
            y: anchorView.bounds.midY - 1,
            width: 2,
            height: 2
        )
        popover.show(relativeTo: anchorRect, of: anchorView, preferredEdge: .maxY)
    }

    // MARK: - NSSplitViewDelegate

    public func splitView(_ splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofDividerAt dividerIndex: Int) -> CGFloat {
        // Minimum left pane width of 200pt
        return max(proposedMinimumPosition, 200)
    }

    public func splitView(_ splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofDividerAt dividerIndex: Int) -> CGFloat {
        // Maximum left pane width: view width - 300pt
        return min(proposedMaximumPosition, splitView.bounds.width - 300)
    }

    // MARK: - Export

    /// Exports the NAO-MGS results as a TSV file.
    ///
    /// Shows an NSSavePanel and writes the taxonomy summary table.
    /// Uses `beginSheetModal` (not `runModal`) per macOS 26 rules.
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
            lines.append("taxon_id\tname\thit_count\tavg_identity\tavg_bit_score\tavg_edit_distance\taccessions")

            for summary in result.taxonSummaries {
                let accStr = summary.accessions.joined(separator: ",")
                lines.append("\(summary.taxId)\t\(summary.name)\t\(summary.hitCount)\t\(String(format: "%.2f", summary.avgIdentity))\t\(String(format: "%.1f", summary.avgBitScore))\t\(String(format: "%.1f", summary.avgEditDistance))\t\(accStr)")
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

    // MARK: - Sorted Data

    /// The current sort-applied list of taxon summaries for the table.
    private var sortedSummaries: [NaoMgsTaxonSummary] {
        guard let result = naoMgsResult else { return [] }
        var summaries = result.taxonSummaries

        if let sortDescriptor = taxonomyTableView.sortDescriptors.first {
            switch sortDescriptor.key {
            case "taxId":
                summaries.sort {
                    sortDescriptor.ascending ? $0.taxId < $1.taxId : $0.taxId > $1.taxId
                }
            case "name":
                summaries.sort {
                    let result = $0.name.localizedCaseInsensitiveCompare($1.name)
                    return sortDescriptor.ascending ? result == .orderedAscending : result == .orderedDescending
                }
            case "hits":
                summaries.sort {
                    sortDescriptor.ascending ? $0.hitCount < $1.hitCount : $0.hitCount > $1.hitCount
                }
            case "accessions":
                summaries.sort {
                    sortDescriptor.ascending
                        ? $0.accessions.count < $1.accessions.count
                        : $0.accessions.count > $1.accessions.count
                }
            case "editDist":
                summaries.sort {
                    sortDescriptor.ascending
                        ? $0.avgEditDistance < $1.avgEditDistance
                        : $0.avgEditDistance > $1.avgEditDistance
                }
            default:
                break
            }
        }

        return summaries
    }
}

// MARK: - NSTableViewDataSource

extension NaoMgsResultViewController: NSTableViewDataSource {

    public func numberOfRows(in tableView: NSTableView) -> Int {
        sortedSummaries.count
    }

    public func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        tableView.reloadData()
    }
}

// MARK: - NSTableViewDelegate

extension NaoMgsResultViewController: NSTableViewDelegate {

    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let summaries = sortedSummaries
        guard row < summaries.count else { return nil }

        let summary = summaries[row]
        let identifier = tableColumn?.identifier ?? NSUserInterfaceItemIdentifier("default")

        let cellView = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView
            ?? makeCellView(identifier: identifier)

        switch identifier.rawValue {
        case "taxId":
            cellView.textField?.stringValue = "\(summary.taxId)"
            cellView.textField?.font = .monospacedDigitSystemFont(ofSize: 11, weight: .regular)
            cellView.textField?.alignment = .right
        case "name":
            cellView.textField?.stringValue = summary.name
            cellView.textField?.font = .systemFont(ofSize: 11)
            cellView.textField?.lineBreakMode = .byTruncatingTail
        case "hits":
            cellView.textField?.stringValue = naoMgsFormatCount(summary.hitCount)
            cellView.textField?.font = .monospacedDigitSystemFont(ofSize: 11, weight: .medium)
            cellView.textField?.alignment = .right
        case "accessions":
            cellView.textField?.stringValue = "\(summary.accessions.count)"
            cellView.textField?.font = .monospacedDigitSystemFont(ofSize: 11, weight: .regular)
            cellView.textField?.alignment = .right
        case "editDist":
            cellView.textField?.stringValue = String(format: "%.1f", summary.avgEditDistance)
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
        let summaries = sortedSummaries

        if row >= 0, row < summaries.count {
            showTaxonDetail(summaries[row])
        } else {
            showOverview()
        }
    }

    /// Creates a reusable cell view with a text field.
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
///
/// Module-level free function to avoid `@MainActor` isolation issues in
/// `@Sendable` closures (see project memory: "Free Functions vs Instance Methods").
private func naoMgsFormatCount(_ count: Int) -> String {
    if count >= 1_000_000 { return String(format: "%.1fM", Double(count) / 1_000_000) }
    if count >= 1_000 { return String(format: "%.1fK", Double(count) / 1_000) }
    return "\(count)"
}

// MARK: - NSMenuDelegate

extension NaoMgsResultViewController: NSMenuDelegate {

    public func menuNeedsUpdate(_ menu: NSMenu) {
        let clickedRow = taxonomyTableView.clickedRow
        let summaries = sortedSummaries

        guard clickedRow >= 0, clickedRow < summaries.count else {
            menu.removeAllItems()
            return
        }

        populateContextMenu(menu, for: summaries[clickedRow])
    }
}

// MARK: - NaoMgsSummaryBar

/// Summary card bar displaying key statistics from the NAO-MGS result.
///
/// Shows four cards: Total Virus Hits, Unique Taxa, Top Taxon, and Sample.
/// Subclasses ``GenomicSummaryCardBar`` for consistent rendering.
@MainActor
final class NaoMgsSummaryBar: GenomicSummaryCardBar {

    private var totalHits: Int = 0
    private var taxonCount: Int = 0
    private var topTaxonName: String = ""
    private var sampleName: String = ""

    /// Updates the summary bar with NAO-MGS result data.
    ///
    /// - Parameter result: The parsed NAO-MGS result.
    func update(result: NaoMgsResult) {
        totalHits = result.totalHitReads
        taxonCount = result.taxonSummaries.count
        topTaxonName = result.taxonSummaries.first?.name ?? "\u{2014}"
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

/// A 36pt bottom bar for the NAO-MGS result view with export and selection info.
///
/// ## Layout
///
/// ```
/// [Export]  |  Vaccinia virus -- 125,727 hits (79.2%)  |
/// ```
@MainActor
final class NaoMgsActionBar: NSView {

    // MARK: - Callbacks

    /// Called when the user clicks the export button.
    var onExport: (() -> Void)?

    // MARK: - State

    private var totalHits: Int = 0

    // MARK: - Subviews

    private let exportButton = NSButton(title: "Export", target: nil, action: nil)
    private let infoLabel = NSTextField(labelWithString: "")
    private let separator = NSBox()

    // MARK: - Initialization

    override init(frame: NSRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        // Separator at top
        separator.boxType = .separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)

        // Export button (left)
        exportButton.translatesAutoresizingMaskIntoConstraints = false
        exportButton.bezelStyle = .accessoryBarAction
        exportButton.image = NSImage(systemSymbolName: "square.and.arrow.up", accessibilityDescription: "Export")
        exportButton.imagePosition = .imageLeading
        exportButton.target = self
        exportButton.action = #selector(exportTapped(_:))
        exportButton.setContentHuggingPriority(.required, for: .horizontal)
        addSubview(exportButton)

        // Info label (center)
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

    // MARK: - Public API

    /// Configures the action bar with result totals.
    ///
    /// - Parameters:
    ///   - totalHits: Total virus hit reads.
    ///   - taxonCount: Number of unique taxa.
    func configure(totalHits: Int, taxonCount: Int) {
        self.totalHits = totalHits
    }

    /// Updates the action bar to reflect the given selected taxon.
    ///
    /// - Parameter summary: The selected taxon, or `nil` to clear.
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

    /// Returns the current info label text (for testing).
    var infoText: String {
        infoLabel.stringValue
    }

    // MARK: - Actions

    @objc private func exportTapped(_ sender: NSButton) {
        onExport?()
    }
}

// MARK: - NaoMgsDetailPaneWrapper

/// A SwiftUI wrapper that manages the selected accession binding internally.
///
/// This avoids the need to pass a `@Binding` from the AppKit view controller
/// into the SwiftUI hosting view, which would require an observable object.
private struct NaoMgsDetailPaneWrapper: View {

    let taxonSummary: NaoMgsTaxonSummary
    let hits: [NaoMgsVirusHit]
    let accessionSummaries: [NaoMgsAccessionSummary]
    let editDistanceData: [(distance: Int, count: Int)]
    let fragmentLengthData: [(length: Int, count: Int)]
    var onAccessionDoubleClicked: ((String) -> Void)?

    @State private var selectedAccession: String?

    var body: some View {
        NaoMgsDetailPaneView(
            taxonSummary: taxonSummary,
            hits: hits,
            accessionSummaries: accessionSummaries,
            editDistanceData: editDistanceData,
            fragmentLengthData: fragmentLengthData,
            selectedAccession: $selectedAccession,
            onAccessionDoubleClicked: onAccessionDoubleClicked
        )
    }
}
