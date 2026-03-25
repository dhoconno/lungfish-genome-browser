// TaxTriageResultViewController.swift - TaxTriage clinical triage result browser
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import LungfishCore
import LungfishIO
import LungfishWorkflow
import PDFKit
import SwiftUI
import WebKit
import os.log

private let logger = Logger(subsystem: "com.lungfish.app", category: "TaxTriageResultVC")


// MARK: - TaxTriageResultViewController

/// A full-screen clinical triage result browser for TaxTriage pipeline output.
///
/// `TaxTriageResultViewController` is the primary UI for displaying TaxTriage
/// metagenomic classification results. It replaces the normal sequence viewer
/// content area following the same child-VC pattern as ``EsVirituResultViewController``
/// and ``TaxonomyViewController``.
///
/// ## Layout
///
/// ```
/// +------------------------------------------+
/// | Summary Bar (48pt)                       |
/// +------------------------------------------+
/// |  Organism Table   |  Report/Krona Tabs   |
/// |  (sortable,       |  (PDFView or         |
/// |   flat list)      |   WKWebView)         |
/// |    (resizable NSSplitView)               |
/// +------------------------------------------+
/// | Action Bar (36pt)                        |
/// +------------------------------------------+
/// ```
///
/// ## Left Pane: Organism Table
///
/// A flat-list `NSTableView` (not outline) showing organism identifications with
/// columns for Organism name, TASS Score, Reads, Coverage, and Confidence
/// (with a color bar indicator). All columns are sortable and user-resizable.
///
/// ## Right Pane: Tab View
///
/// An `NSTabView` with two tabs:
/// - **Report**: `PDFView` (from PDFKit) showing the PDF report if available
/// - **Krona**: `WKWebView` embedding the Krona interactive HTML if available
///
/// ## Actions
///
/// The bottom action bar provides Export, Re-run, and Open Report Externally buttons.
///
/// ## Thread Safety
///
/// This class is `@MainActor` isolated and uses raw `NSSplitView` (not
/// `NSSplitViewController`) per macOS 26 deprecated API rules.
@MainActor
public final class TaxTriageResultViewController: NSViewController, NSSplitViewDelegate {

    // MARK: - Data

    /// The TaxTriage result driving this view.
    private(set) var taxTriageResult: TaxTriageResult?

    /// The TaxTriage config used for this run (for re-run and provenance).
    private(set) var taxTriageConfig: TaxTriageConfig?

    /// Parsed metrics from the TASS metrics files.
    private(set) var metrics: [TaxTriageMetric] = []

    /// Parsed organisms from the report files.
    private(set) var organisms: [TaxTriageOrganism] = []

    /// Taxonomy tree parsed from the Kraken2 kreport (for sunburst).
    private var taxonomyTree: TaxonTree?

    /// Path to the merged BAM from TaxTriage alignment output.
    private var bamURL: URL?

    /// Maps organism names → BAM reference accessions (from gcfmapping.tsv).
    private var organismToAccessions: [String: [String]] = [:]

    /// Maps accessions → reference lengths (from BAM header via samtools).
    private var accessionLengths: [String: Int] = [:]

    // MARK: - Child Views

    private let summaryBar = TaxTriageSummaryBar()
    let splitView = NSSplitView()
    private let leftTabView = NSSegmentedControl()
    private let leftPaneContainer = NSView()
    private let sunburstView = TaxonomySunburstView()
    private var miniBAMController: MiniBAMViewController?
    private let organismTableView = TaxTriageOrganismTableView()
    let actionBar = TaxTriageActionBar()

    // MARK: - Split View State

    /// Whether the initial divider position has been applied.
    private var didSetInitialSplitPosition = false

    // MARK: - Callbacks

    /// Called when the user requests BLAST verification for a selected organism.
    ///
    /// - Parameter organism: The organism to verify.
    public var onBlastVerification: ((TaxTriageOrganism) -> Void)?

    /// Called when the user wants to re-run TaxTriage with the same or different settings.
    public var onReRun: (() -> Void)?

    // MARK: - Lifecycle

    public override func loadView() {
        let container = NSView(frame: NSRect(x: 0, y: 0, width: 900, height: 700))
        view = container

        setupSummaryBar()
        setupSplitView()
        setupMiniBAMViewer()
        setupActionBar()
        layoutSubviews()
        wireCallbacks()
    }

    private func setupMiniBAMViewer() {
        let bamVC = MiniBAMViewController()
        addChild(bamVC)
        miniBAMController = bamVC
    }

    public override func viewDidLayout() {
        super.viewDidLayout()

        // Apply the initial 40/60 split once the split view has real bounds.
        if !didSetInitialSplitPosition, splitView.bounds.width > 0 {
            didSetInitialSplitPosition = true
            let position = round(splitView.bounds.width * 0.4)
            splitView.setPosition(position, ofDividerAt: 0)
        }
    }

    // MARK: - Public API

    /// Configures the view with a TaxTriage result and optional config.
    ///
    /// Parses the top_report.tsv for organism data and the kreport for the
    /// taxonomy tree. Falls back to parsing metrics/report files if the
    /// primary files aren't found.
    ///
    /// - Parameters:
    ///   - result: The TaxTriage pipeline result.
    ///   - config: The config used for this run (for provenance and re-run).
    public func configure(result: TaxTriageResult, config: TaxTriageConfig? = nil) {
        taxTriageResult = result
        taxTriageConfig = config ?? result.config

        // Strategy: find the top_report.tsv (has organism names + read counts)
        // and the kreport.txt (has full taxonomy tree for sunburst).
        let outputDir = result.outputDirectory

        // 1. Parse organisms from top_report.tsv (exclude work/ duplicates)
        var allOrganisms: [TaxTriageOrganism] = []
        let topReportFiles = result.allOutputFiles.filter {
            $0.lastPathComponent.contains("top_report.tsv")
                && !$0.path.contains("/work/")
        }
        for topReportURL in topReportFiles {
            let parsed = parseTopReport(url: topReportURL)
            allOrganisms.append(contentsOf: parsed)
        }

        // Fallback: try the old report parsing if no top_report found
        if allOrganisms.isEmpty {
            for reportURL in result.reportFiles {
                if let parsed = try? TaxTriageReportParser.parse(url: reportURL) {
                    allOrganisms.append(contentsOf: parsed)
                }
            }
        }
        organisms = allOrganisms

        // 2. Parse taxonomy tree from kreport for sunburst
        let kreportFiles = result.allOutputFiles.filter {
            $0.lastPathComponent.hasSuffix(".kraken2.report.txt")
                && !$0.path.contains("/work/")
        }
        logger.info("Found \(kreportFiles.count) kreport file(s), \(topReportFiles.count) top_report file(s)")
        if let kreportURL = kreportFiles.first {
            do {
                let tree = try KreportParser.parse(url: kreportURL)
                taxonomyTree = tree
                logger.info("Parsed kreport with \(tree.totalReads) total reads, \(tree.speciesCount) species")
            } catch {
                logger.warning("Failed to parse kreport: \(error.localizedDescription)")
            }
        }

        // 3. Parse TASS metrics if available
        var allMetrics: [TaxTriageMetric] = []
        for metricsURL in result.metricsFiles {
            if let parsed = try? TaxTriageMetricsParser.parse(url: metricsURL) {
                allMetrics.append(contentsOf: parsed)
            }
        }
        metrics = allMetrics

        // Build table rows from organisms (enriched with metrics if available)
        let mergedRows = buildTableRows(organisms: allOrganisms, metrics: allMetrics)

        // Update summary bar
        summaryBar.update(
            organismCount: mergedRows.count,
            runtime: result.runtime,
            highConfidenceCount: mergedRows.filter { $0.tassScore >= 0.8 }.count,
            sampleCount: result.config.samples.count
        )

        // Configure table
        organismTableView.rows = mergedRows

        // Configure tabs
        // Configure sunburst from kreport taxonomy tree
        configureSunburst()

        // Find the BAM file from TaxTriage output (check minimap2/ and alignment/)
        let bamFiles = result.allOutputFiles.filter {
            $0.pathExtension == "bam" && !$0.path.contains("/work/")
        }
        if let bam = bamFiles.first {
            bamURL = bam
            // Ensure a BAI index exists (TaxTriage produces CSI, we need BAI for samtools view)
            let baiPath = bam.path + ".bai"
            if !FileManager.default.fileExists(atPath: baiPath) {
                logger.info("Generating BAI index for TaxTriage BAM")
                Task.detached {
                    let proc = Process()
                    proc.executableURL = URL(fileURLWithPath: "/usr/local/bin/samtools")
                    proc.arguments = ["index", bam.path]
                    proc.standardOutput = FileHandle.nullDevice
                    proc.standardError = FileHandle.nullDevice
                    try? proc.run()
                    proc.waitUntilExit()
                }
            }
            logger.info("Found TaxTriage BAM: \(bam.lastPathComponent, privacy: .public)")
        }

        // Parse gcfmapping.tsv to build organism→accession lookup
        let gcfFiles = result.allOutputFiles.filter {
            $0.lastPathComponent.contains("gcfmapping.tsv") && !$0.path.contains("/work/")
        }
        if let gcfFile = gcfFiles.first {
            parseGCFMapping(url: gcfFile)
        }

        // Parse BAM header for reference lengths (needed for MiniBAMViewController)
        if let bam = bamURL {
            parseBamReferenceLengths(bamURL: bam)
        }

        // Set up the mini BAM viewer in the left pane
        if let bamVC = miniBAMController {
            let bamView = bamVC.view
            bamView.translatesAutoresizingMaskIntoConstraints = false
            leftPaneContainer.addSubview(bamView)

            NSLayoutConstraint.activate([
                bamView.topAnchor.constraint(equalTo: leftTabView.bottomAnchor, constant: 4),
                bamView.leadingAnchor.constraint(equalTo: leftPaneContainer.leadingAnchor),
                bamView.trailingAnchor.constraint(equalTo: leftPaneContainer.trailingAnchor),
                bamView.bottomAnchor.constraint(equalTo: leftPaneContainer.bottomAnchor),
            ])
        }

        // Update action bar
        actionBar.configure(
            organismCount: mergedRows.count,
            sampleCount: result.config.samples.count
        )

        logger.info("Configured with \(mergedRows.count) organisms, \(result.metricsFiles.count) metrics files, \(result.kronaFiles.count) Krona files")
    }

    // MARK: - Row Building

    /// Merges organism report data with TASS metrics into unified table rows.
    ///
    /// When a metric matches an organism by name, the metric's richer data
    /// (TASS score, coverage breadth/depth, abundance) is used. Organisms
    /// without matching metrics fall back to report-level data.
    private func buildTableRows(
        organisms: [TaxTriageOrganism],
        metrics: [TaxTriageMetric]
    ) -> [TaxTriageTableRow] {
        // Build lookup from organism name to metric
        let metricsByName = Dictionary(
            metrics.map { ($0.organism.lowercased(), $0) },
            uniquingKeysWith: { first, _ in first }
        )

        var rows: [TaxTriageTableRow] = []

        // Start from organisms (report data)
        for organism in organisms {
            let matchingMetric = metricsByName[organism.name.lowercased()]
            rows.append(TaxTriageTableRow(
                organism: organism.name,
                tassScore: matchingMetric?.tassScore ?? organism.score,
                reads: matchingMetric?.reads ?? organism.reads,
                coverage: matchingMetric?.coverageBreadth ?? organism.coverage,
                confidence: matchingMetric?.confidence ?? confidenceLabel(for: matchingMetric?.tassScore ?? organism.score),
                taxId: matchingMetric?.taxId ?? organism.taxId,
                rank: matchingMetric?.rank ?? organism.rank,
                abundance: matchingMetric?.abundance
            ))
        }

        // Add metrics not in organisms list
        let existingNames = Set(organisms.map { $0.name.lowercased() })
        for metric in metrics where !existingNames.contains(metric.organism.lowercased()) {
            rows.append(TaxTriageTableRow(
                organism: metric.organism,
                tassScore: metric.tassScore,
                reads: metric.reads,
                coverage: metric.coverageBreadth,
                confidence: metric.confidence ?? confidenceLabel(for: metric.tassScore),
                taxId: metric.taxId,
                rank: metric.rank,
                abundance: metric.abundance
            ))
        }

        return rows.sorted { $0.tassScore > $1.tassScore }
    }

    /// Converts a numeric score to a qualitative confidence label.
    private func confidenceLabel(for score: Double) -> String {
        if score >= 0.8 { return "high" }
        if score >= 0.4 { return "medium" }
        return "low"
    }

    // MARK: - Setup: Summary Bar

    private func setupSummaryBar() {
        summaryBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(summaryBar)
    }

    // MARK: - Setup: Split View

    /// Configures the NSSplitView with organism table (left) and tab view (right).
    ///
    /// Uses raw NSSplitView (not NSSplitViewController) per macOS 26 rules.
    private func setupSplitView() {
        splitView.translatesAutoresizingMaskIntoConstraints = false
        splitView.isVertical = true
        splitView.dividerStyle = .thin
        splitView.delegate = self

        // Left pane: tabbed container with Alignments (default) + Sunburst
        leftPaneContainer.translatesAutoresizingMaskIntoConstraints = false

        // Segmented control for switching between BAM and Sunburst
        leftTabView.segmentCount = 2
        leftTabView.setLabel("Alignments", forSegment: 0)
        leftTabView.setLabel("Taxonomy", forSegment: 1)
        leftTabView.segmentStyle = .texturedRounded
        leftTabView.selectedSegment = 0  // BAM view is default
        leftTabView.target = self
        leftTabView.action = #selector(leftTabChanged(_:))
        leftTabView.translatesAutoresizingMaskIntoConstraints = false
        leftPaneContainer.addSubview(leftTabView)

        // Sunburst (initially hidden)
        sunburstView.translatesAutoresizingMaskIntoConstraints = false
        sunburstView.isHidden = true
        leftPaneContainer.addSubview(sunburstView)

        NSLayoutConstraint.activate([
            leftTabView.topAnchor.constraint(equalTo: leftPaneContainer.topAnchor, constant: 4),
            leftTabView.centerXAnchor.constraint(equalTo: leftPaneContainer.centerXAnchor),

            sunburstView.topAnchor.constraint(equalTo: leftTabView.bottomAnchor, constant: 4),
            sunburstView.leadingAnchor.constraint(equalTo: leftPaneContainer.leadingAnchor),
            sunburstView.trailingAnchor.constraint(equalTo: leftPaneContainer.trailingAnchor),
            sunburstView.bottomAnchor.constraint(equalTo: leftPaneContainer.bottomAnchor),
        ])

        // Right pane: organism table
        let tableContainer = NSView()
        organismTableView.autoresizingMask = [.width, .height]
        tableContainer.addSubview(organismTableView)

        splitView.addArrangedSubview(leftPaneContainer)
        splitView.addArrangedSubview(tableContainer)

        splitView.setHoldingPriority(.defaultHigh, forSubviewAt: 0)
        splitView.setHoldingPriority(.defaultLow, forSubviewAt: 1)

        view.addSubview(splitView)
    }

    @objc private func leftTabChanged(_ sender: NSSegmentedControl) {
        let showBAM = sender.selectedSegment == 0
        miniBAMController?.view.isHidden = !showBAM
        sunburstView.isHidden = showBAM
    }

    /// Sets up the NSTabView with Report and Krona tabs.
    // MARK: - Top Report Parser

    /// Parses the TaxTriage top_report.tsv into TaxTriageOrganism objects.
    ///
    /// The top_report.tsv has columns:
    /// `abundance, clade_fragments_covered, number_fragments_assigned, rank, taxid, name`
    private func parseTopReport(url: URL) -> [TaxTriageOrganism] {
        guard let content = try? String(contentsOf: url, encoding: .utf8) else { return [] }

        let lines = content.components(separatedBy: .newlines)
        guard lines.count > 1 else { return [] }

        var organisms: [TaxTriageOrganism] = []

        for line in lines.dropFirst() {  // Skip header
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty else { continue }

            let cols = trimmed.components(separatedBy: "\t")
            guard cols.count >= 6 else { continue }

            let abundance = Double(cols[0]) ?? 0
            let cladeReads = Int(Double(cols[1]) ?? 0)
            let directReads = Int(Double(cols[2]) ?? 0)
            let rank = cols[3]
            let taxId = Int(cols[4])
            let name = cols[5]

            let organism = TaxTriageOrganism(
                name: name,
                score: abundance,
                reads: cladeReads,
                coverage: nil,
                taxId: taxId,
                rank: rank
            )
            organisms.append(organism)
        }

        // Sort by clade reads descending
        organisms.sort { $0.reads > $1.reads }

        logger.info("Parsed \(organisms.count) organisms from \(url.lastPathComponent)")
        return organisms
    }

    /// Parses the gcfmapping.tsv to build organism name → accession lookup.
    ///
    /// Format: accession\tGCF_ID\torganism_name\tdescription
    private func parseGCFMapping(url: URL) {
        guard let content = try? String(contentsOf: url, encoding: .utf8) else { return }

        var mapping: [String: [String]] = [:]
        for line in content.components(separatedBy: .newlines) {
            let cols = line.components(separatedBy: "\t")
            guard cols.count >= 3 else { continue }
            let accession = cols[0]
            let organismName = cols[2]
            mapping[organismName, default: []].append(accession)
        }
        organismToAccessions = mapping
        logger.info("Parsed gcfmapping: \(mapping.count) organisms → \(mapping.values.flatMap { $0 }.count) accessions")
    }

    /// Parses BAM reference lengths from samtools idxstats output.
    private func parseBamReferenceLengths(bamURL: URL) {
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: "/usr/local/bin/samtools")
        proc.arguments = ["idxstats", bamURL.path]
        let pipe = Pipe()
        proc.standardOutput = pipe
        proc.standardError = FileHandle.nullDevice

        do {
            try proc.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            proc.waitUntilExit()

            if let output = String(data: data, encoding: .utf8) {
                for line in output.components(separatedBy: .newlines) {
                    let cols = line.components(separatedBy: "\t")
                    guard cols.count >= 3 else { continue }
                    let ref = cols[0]
                    if let length = Int(cols[1]), length > 0 {
                        accessionLengths[ref] = length
                    }
                }
            }
            let refCount = self.accessionLengths.count
            logger.info("Parsed BAM references: \(refCount) contigs")
        } catch {
            logger.warning("Failed to parse BAM references: \(error.localizedDescription)")
        }
    }

    /// Configures the sunburst with the taxonomy tree from the kreport.
    private func configureSunburst() {
        if let tree = taxonomyTree {
            sunburstView.tree = tree
            sunburstView.centerNode = nil
            sunburstView.selectedNode = nil
        }
    }

    // MARK: - Setup: Action Bar

    private func setupActionBar() {
        actionBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionBar)
    }

    // MARK: - Layout

    private func layoutSubviews() {
        NSLayoutConstraint.activate([
            // Summary bar (top, below safe area)
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
        // Table selection -> action bar update + BAM viewer update
        organismTableView.onRowSelected = { [weak self] row in
            guard let self else { return }
            self.actionBar.updateSelection(
                organismName: row?.organism,
                readCount: row?.reads
            )

            // Load BAM alignments for the selected organism.
            // The BAM uses accession numbers (NC_009539.1) as reference names,
            // not organism names. Use the gcfmapping to translate.
            if let row, let bamURL = self.bamURL {
                let organismName = row.organism
                if let accessions = self.organismToAccessions[organismName],
                   let primaryAccession = accessions.first,
                   let contigLength = self.accessionLengths[primaryAccession] {
                    self.miniBAMController?.displayContig(
                        bamURL: bamURL,
                        contig: primaryAccession,
                        contigLength: contigLength
                    )
                    // Switch to Alignments tab automatically
                    self.leftTabView.selectedSegment = 0
                    self.leftTabChanged(self.leftTabView)
                } else {
                    self.miniBAMController?.clear()
                    logger.debug("No accession mapping for organism: \(organismName, privacy: .public)")
                }
            } else {
                self.miniBAMController?.clear()
            }
        }

        // Table BLAST request -> forward to host
        organismTableView.onBlastRequested = { [weak self] row in
            guard let self else { return }
            // Convert table row back to organism for the callback
            let organism = TaxTriageOrganism(
                name: row.organism,
                score: row.tassScore,
                reads: row.reads,
                coverage: row.coverage,
                taxId: row.taxId,
                rank: row.rank
            )
            self.onBlastVerification?(organism)
        }

        // Action bar export
        actionBar.onExport = { [weak self] in
            self?.showExportMenu()
        }

        // Action bar re-run
        actionBar.onReRun = { [weak self] in
            self?.onReRun?()
        }

        // Action bar provenance
        actionBar.onProvenance = { [weak self] sender in
            self?.showProvenancePopover(relativeTo: sender)
        }

        // Action bar open report externally
        actionBar.onOpenExternally = { [weak self] in
            self?.openReportExternally()
        }
    }

    // MARK: - NSSplitViewDelegate

    /// Enforces minimum widths for organism table (300px) and tab view (300px).
    public func splitView(
        _ splitView: NSSplitView,
        constrainMinCoordinate proposedMinimumPosition: CGFloat,
        ofSubviewAt dividerIndex: Int
    ) -> CGFloat {
        max(proposedMinimumPosition, 300)
    }

    public func splitView(
        _ splitView: NSSplitView,
        constrainMaxCoordinate proposedMaximumPosition: CGFloat,
        ofSubviewAt dividerIndex: Int
    ) -> CGFloat {
        min(proposedMaximumPosition, splitView.bounds.width - 300)
    }

    // MARK: - Export

    private func showExportMenu() {
        let menu = buildExportMenu()
        let anchorView = actionBar
        let point = NSPoint(x: anchorView.bounds.maxX - 100, y: anchorView.bounds.maxY)
        menu.popUp(positioning: nil, at: point, in: anchorView)
    }

    /// Builds the export context menu.
    func buildExportMenu() -> NSMenu {
        let menu = NSMenu()

        let csvItem = NSMenuItem(
            title: "Export as CSV\u{2026}",
            action: #selector(exportCSVAction(_:)),
            keyEquivalent: ""
        )
        csvItem.target = self
        menu.addItem(csvItem)

        let tsvItem = NSMenuItem(
            title: "Export as TSV\u{2026}",
            action: #selector(exportTSVAction(_:)),
            keyEquivalent: ""
        )
        tsvItem.target = self
        menu.addItem(tsvItem)

        menu.addItem(.separator())

        let copyItem = NSMenuItem(
            title: "Copy Summary",
            action: #selector(copySummaryAction(_:)),
            keyEquivalent: ""
        )
        copyItem.target = self
        menu.addItem(copyItem)

        return menu
    }

    @objc private func exportCSVAction(_ sender: Any) {
        exportDelimited(separator: ",", fileExtension: "csv", fileTypeName: "CSV")
    }

    @objc private func exportTSVAction(_ sender: Any) {
        exportDelimited(separator: "\t", fileExtension: "tsv", fileTypeName: "TSV")
    }

    @objc private func copySummaryAction(_ sender: Any) {
        guard let result = taxTriageResult else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(result.summary, forType: .string)
    }

    // MARK: - Delimited Export

    /// Exports the organism table as a delimited file via NSSavePanel.
    ///
    /// Uses `beginSheetModal` (not `runModal`) per macOS 26 rules.
    private func exportDelimited(separator: String, fileExtension: String, fileTypeName: String) {
        guard let window = view.window else {
            logger.warning("Cannot export: no window")
            return
        }

        let panel = NSSavePanel()
        panel.title = "Export TaxTriage Results as \(fileTypeName)"
        panel.allowedContentTypes = [.plainText]
        panel.canCreateDirectories = true

        let baseName = taxTriageConfig?.samples.first?.sampleId ?? "taxtriage"
        panel.nameFieldStringValue = "\(baseName)_results.\(fileExtension)"

        panel.beginSheetModal(for: window) { [weak self] response in
            guard let self, response == .OK, let url = panel.url else { return }

            let content = self.buildDelimitedExport(separator: separator)
            do {
                try content.write(to: url, atomically: true, encoding: .utf8)
                logger.info("Exported \(fileTypeName, privacy: .public) to \(url.lastPathComponent, privacy: .public)")
            } catch {
                logger.error("Export failed: \(error.localizedDescription, privacy: .public)")
            }
        }
    }

    /// Builds delimited export content from all table rows.
    func buildDelimitedExport(separator: String) -> String {
        var lines: [String] = []

        let headers = [
            "Organism", "TASS Score", "Reads", "Coverage", "Confidence",
            "Tax ID", "Rank", "Abundance",
        ]
        lines.append(headers.joined(separator: separator))

        for row in organismTableView.rows {
            var fields: [String] = []
            fields.append(escapeField(row.organism, separator: separator))
            fields.append(String(format: "%.4f", row.tassScore))
            fields.append("\(row.reads)")
            fields.append(row.coverage.map { String(format: "%.2f", $0) } ?? "")
            fields.append(row.confidence ?? "")
            fields.append(row.taxId.map { "\($0)" } ?? "")
            fields.append(row.rank ?? "")
            fields.append(row.abundance.map { String(format: "%.6f", $0) } ?? "")
            lines.append(fields.joined(separator: separator))
        }

        return lines.joined(separator: "\n") + "\n"
    }

    /// Escapes a field for CSV output.
    private func escapeField(_ value: String, separator: String) -> String {
        guard separator == "," else { return value }
        if value.contains(",") || value.contains("\"") || value.contains("\n") {
            let escaped = value.replacingOccurrences(of: "\"", with: "\"\"")
            return "\"\(escaped)\""
        }
        return value
    }

    // MARK: - Open Externally

    /// Opens the first available PDF report in the system's default PDF viewer.
    private func openReportExternally() {
        guard let result = taxTriageResult else { return }

        let pdfFiles = result.allOutputFiles.filter { $0.pathExtension.lowercased() == "pdf" }
        let reportPDFs = result.reportFiles.filter { $0.pathExtension.lowercased() == "pdf" }
        let allPDFs = pdfFiles + reportPDFs

        if let firstPDF = allPDFs.first {
            NSWorkspace.shared.open(firstPDF)
        } else if let firstReport = result.reportFiles.first {
            NSWorkspace.shared.open(firstReport)
        } else {
            // Open the output directory
            NSWorkspace.shared.open(result.outputDirectory)
        }
    }

    // MARK: - Provenance Popover

    private func showProvenancePopover(relativeTo sender: Any) {
        guard let result = taxTriageResult else { return }

        let popover = NSPopover()
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 340, height: 260)

        let provenanceView = TaxTriageProvenanceView(
            result: result,
            config: taxTriageConfig ?? result.config
        )
        popover.contentViewController = NSHostingController(rootView: provenanceView)

        let anchorView: NSView
        let anchorRect: NSRect
        if let button = sender as? NSView {
            anchorView = button
            anchorRect = button.bounds
        } else {
            anchorView = actionBar
            anchorRect = actionBar.bounds
        }

        popover.show(relativeTo: anchorRect, of: anchorView, preferredEdge: .maxY)
    }

    // MARK: - Testing Accessors

    /// Returns the summary bar for testing.
    var testSummaryBar: TaxTriageSummaryBar { summaryBar }

    /// Returns the organism table view for testing.
    var testOrganismTableView: TaxTriageOrganismTableView { organismTableView }

    /// Returns the action bar for testing.
    var testActionBar: TaxTriageActionBar { actionBar }

    /// Returns the split view for testing.
    var testSplitView: NSSplitView { splitView }

    /// Returns the sunburst view for testing.
    var testSunburstView: TaxonomySunburstView { sunburstView }

    /// Returns the current result for testing.
    var testResult: TaxTriageResult? { taxTriageResult }
}


// MARK: - TaxTriageTableRow

/// A unified table row combining organism report data with TASS metrics.
///
/// Used as the data model for ``TaxTriageOrganismTableView``.
struct TaxTriageTableRow: Equatable {

    /// Scientific name of the organism.
    let organism: String

    /// TASS confidence score (0.0 to 1.0).
    let tassScore: Double

    /// Number of reads assigned to this organism.
    let reads: Int

    /// Coverage breadth percentage (0.0 to 100.0), if available.
    let coverage: Double?

    /// Qualitative confidence label (e.g., "high", "medium", "low").
    let confidence: String?

    /// NCBI taxonomy ID, if available.
    let taxId: Int?

    /// Taxonomic rank code, if available.
    let rank: String?

    /// Relative abundance (0.0 to 1.0), if available.
    let abundance: Double?
}


// MARK: - TaxTriageOrganismTableView

/// A flat-list NSTableView showing TaxTriage organism identifications.
///
/// Columns: Organism, TASS Score, Reads, Coverage, Confidence (color bar).
/// All columns are sortable and user-resizable.
@MainActor
final class TaxTriageOrganismTableView: NSView, NSTableViewDataSource, NSTableViewDelegate {

    // MARK: - Column Identifiers

    private enum ColumnID {
        static let organism = NSUserInterfaceItemIdentifier("organism")
        static let tassScore = NSUserInterfaceItemIdentifier("tassScore")
        static let reads = NSUserInterfaceItemIdentifier("reads")
        static let coverage = NSUserInterfaceItemIdentifier("coverage")
        static let confidence = NSUserInterfaceItemIdentifier("confidence")
    }

    // MARK: - Data

    /// The rows to display, sorted by the active sort descriptor.
    var rows: [TaxTriageTableRow] = [] {
        didSet {
            sortedRows = sortRows(rows)
            tableView.reloadData()
        }
    }

    /// The currently sorted rows.
    private var sortedRows: [TaxTriageTableRow] = []

    // MARK: - Callbacks

    /// Called when a row is selected. Passes nil for deselection.
    var onRowSelected: ((TaxTriageTableRow?) -> Void)?

    /// Called when the user requests BLAST verification for a row.
    var onBlastRequested: ((TaxTriageTableRow) -> Void)?

    // MARK: - Subviews

    private let scrollView = NSScrollView()
    private let tableView = NSTableView()

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
        setupTableView()
        setupContextMenu()
    }

    // MARK: - Setup

    private func setupTableView() {
        // Organism column
        let organismCol = NSTableColumn(identifier: ColumnID.organism)
        organismCol.title = "Organism"
        organismCol.width = 180
        organismCol.minWidth = 100
        organismCol.maxWidth = 400
        organismCol.sortDescriptorPrototype = NSSortDescriptor(key: "organism", ascending: true)
        tableView.addTableColumn(organismCol)

        // TASS Score column
        let scoreCol = NSTableColumn(identifier: ColumnID.tassScore)
        scoreCol.title = "TASS Score"
        scoreCol.width = 80
        scoreCol.minWidth = 60
        scoreCol.maxWidth = 120
        scoreCol.sortDescriptorPrototype = NSSortDescriptor(key: "tassScore", ascending: false)
        tableView.addTableColumn(scoreCol)

        // Reads column
        let readsCol = NSTableColumn(identifier: ColumnID.reads)
        readsCol.title = "Reads"
        readsCol.width = 70
        readsCol.minWidth = 50
        readsCol.maxWidth = 120
        readsCol.sortDescriptorPrototype = NSSortDescriptor(key: "reads", ascending: false)
        tableView.addTableColumn(readsCol)

        // Coverage column
        let coverageCol = NSTableColumn(identifier: ColumnID.coverage)
        coverageCol.title = "Coverage"
        coverageCol.width = 70
        coverageCol.minWidth = 50
        coverageCol.maxWidth = 120
        coverageCol.sortDescriptorPrototype = NSSortDescriptor(key: "coverage", ascending: false)
        tableView.addTableColumn(coverageCol)

        // Confidence column (color bar)
        let confidenceCol = NSTableColumn(identifier: ColumnID.confidence)
        confidenceCol.title = "Confidence"
        confidenceCol.width = 80
        confidenceCol.minWidth = 60
        confidenceCol.maxWidth = 140
        confidenceCol.sortDescriptorPrototype = NSSortDescriptor(key: "confidence", ascending: false)
        tableView.addTableColumn(confidenceCol)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.allowsColumnReordering = true
        tableView.allowsColumnResizing = true
        tableView.allowsColumnSelection = false
        tableView.headerView = NSTableHeaderView()
        tableView.style = .inset
        tableView.rowHeight = 24

        scrollView.documentView = tableView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autoresizingMask = [.width, .height]

        addSubview(scrollView)

        setAccessibilityRole(.table)
        setAccessibilityLabel("TaxTriage organism identifications")
    }

    private func setupContextMenu() {
        let menu = NSMenu()

        let blastItem = NSMenuItem(
            title: "Verify with BLAST\u{2026}",
            action: #selector(contextBlastAction(_:)),
            keyEquivalent: ""
        )
        blastItem.target = self
        menu.addItem(blastItem)

        let copyItem = NSMenuItem(
            title: "Copy Organism Name",
            action: #selector(contextCopyAction(_:)),
            keyEquivalent: ""
        )
        copyItem.target = self
        menu.addItem(copyItem)

        tableView.menu = menu
    }

    @objc private func contextBlastAction(_ sender: Any) {
        let row = tableView.clickedRow
        guard row >= 0, row < sortedRows.count else { return }
        onBlastRequested?(sortedRows[row])
    }

    @objc private func contextCopyAction(_ sender: Any) {
        let row = tableView.clickedRow
        guard row >= 0, row < sortedRows.count else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(sortedRows[row].organism, forType: .string)
    }

    // MARK: - Sorting

    private func sortRows(_ rows: [TaxTriageTableRow]) -> [TaxTriageTableRow] {
        guard let descriptor = tableView.sortDescriptors.first, let key = descriptor.key else {
            return rows.sorted { $0.tassScore > $1.tassScore }
        }

        return rows.sorted { a, b in
            let result: Bool
            switch key {
            case "organism":
                result = a.organism.localizedCompare(b.organism) == .orderedAscending
            case "tassScore":
                result = a.tassScore < b.tassScore
            case "reads":
                result = a.reads < b.reads
            case "coverage":
                result = (a.coverage ?? 0) < (b.coverage ?? 0)
            case "confidence":
                result = a.tassScore < b.tassScore
            default:
                result = false
            }
            return descriptor.ascending ? result : !result
        }
    }

    // MARK: - NSTableViewDataSource

    func numberOfRows(in tableView: NSTableView) -> Int {
        sortedRows.count
    }

    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        sortedRows = sortRows(rows)
        tableView.reloadData()
    }

    // MARK: - NSTableViewDelegate

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let column = tableColumn, row < sortedRows.count else { return nil }
        let item = sortedRows[row]

        switch column.identifier {
        case ColumnID.organism:
            return makeLabelCell(text: item.organism, bold: true)

        case ColumnID.tassScore:
            return makeLabelCell(text: String(format: "%.3f", item.tassScore), monospaced: true)

        case ColumnID.reads:
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            let text = formatter.string(from: NSNumber(value: item.reads)) ?? "\(item.reads)"
            return makeLabelCell(text: text, monospaced: true)

        case ColumnID.coverage:
            if let coverage = item.coverage {
                return makeLabelCell(text: String(format: "%.1f%%", coverage), monospaced: true)
            }
            return makeLabelCell(text: "\u{2014}", dimmed: true)

        case ColumnID.confidence:
            let cell = TaxTriageConfidenceCellView()
            cell.score = item.tassScore
            cell.toolTip = item.confidence ?? confidenceTip(for: item.tassScore)
            return cell

        default:
            return nil
        }
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedRow = tableView.selectedRow
        if selectedRow >= 0, selectedRow < sortedRows.count {
            onRowSelected?(sortedRows[selectedRow])
        } else {
            onRowSelected?(nil)
        }
    }

    // MARK: - Cell Helpers

    private func makeLabelCell(
        text: String,
        bold: Bool = false,
        monospaced: Bool = false,
        dimmed: Bool = false
    ) -> NSTextField {
        let field = NSTextField(labelWithString: text)
        field.lineBreakMode = .byTruncatingTail

        if bold {
            field.font = .systemFont(ofSize: 12, weight: .medium)
        } else if monospaced {
            field.font = .monospacedDigitSystemFont(ofSize: 11, weight: .regular)
        } else {
            field.font = .systemFont(ofSize: 11, weight: .regular)
        }

        if dimmed {
            field.textColor = .tertiaryLabelColor
        }

        return field
    }

    private func confidenceTip(for score: Double) -> String {
        if score >= 0.8 { return "High confidence" }
        if score >= 0.4 { return "Moderate confidence" }
        return "Low confidence"
    }
}


// MARK: - TaxTriageSummaryBar

/// Summary card bar for TaxTriage clinical triage results.
///
/// Shows four cards: Organisms Detected, Pipeline Runtime, High Confidence, and Samples.
@MainActor
final class TaxTriageSummaryBar: GenomicSummaryCardBar {

    private var organismCount: Int = 0
    private var runtime: TimeInterval = 0
    private var highConfidenceCount: Int = 0
    private var sampleCount: Int = 0

    /// Updates the summary bar with result data.
    func update(
        organismCount: Int,
        runtime: TimeInterval,
        highConfidenceCount: Int,
        sampleCount: Int
    ) {
        self.organismCount = organismCount
        self.runtime = runtime
        self.highConfidenceCount = highConfidenceCount
        self.sampleCount = sampleCount
        needsDisplay = true
    }

    override var cards: [Card] {
        let runtimeStr: String
        if runtime >= 60 {
            runtimeStr = String(format: "%.1fm", runtime / 60)
        } else {
            runtimeStr = String(format: "%.1fs", runtime)
        }

        return [
            Card(label: "Organisms", value: "\(organismCount)"),
            Card(label: "Runtime", value: runtimeStr),
            Card(label: "High Confidence", value: "\(highConfidenceCount)"),
            Card(label: "Samples", value: "\(sampleCount)"),
        ]
    }

    override func abbreviatedLabel(for label: String) -> String {
        switch label {
        case "Organisms": return "Org."
        case "High Confidence": return "Hi-Conf"
        case "Samples": return "Samp."
        default: return super.abbreviatedLabel(for: label)
        }
    }
}


// MARK: - TaxTriageActionBar

/// A 36pt bottom bar for the TaxTriage result view with export, re-run, open externally, and provenance controls.
///
/// ## Layout
///
/// ```
/// [Export v] [Re-run] [Open Report]  |  E. coli -- 12,345 reads  | [Provenance]
/// ```
@MainActor
final class TaxTriageActionBar: NSView {

    // MARK: - Callbacks

    /// Called when the user clicks the export button.
    var onExport: (() -> Void)?

    /// Called when the user clicks the re-run button.
    var onReRun: (() -> Void)?

    /// Called when the user clicks the provenance button.
    var onProvenance: ((Any) -> Void)?

    /// Called when the user clicks the open externally button.
    var onOpenExternally: (() -> Void)?

    // MARK: - Subviews

    private let exportButton = NSButton(
        title: "Export",
        target: nil,
        action: nil
    )
    private let reRunButton = NSButton(
        title: "Re-run",
        target: nil,
        action: nil
    )
    private let openExternalButton = NSButton(
        title: "Open Report",
        target: nil,
        action: nil
    )
    private let infoLabel = NSTextField(labelWithString: "")
    private let provenanceButton = NSButton(
        title: "",
        target: nil,
        action: nil
    )
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

        // Re-run button
        reRunButton.translatesAutoresizingMaskIntoConstraints = false
        reRunButton.bezelStyle = .accessoryBarAction
        reRunButton.image = NSImage(systemSymbolName: "arrow.clockwise", accessibilityDescription: "Re-run")
        reRunButton.imagePosition = .imageLeading
        reRunButton.target = self
        reRunButton.action = #selector(reRunTapped(_:))
        reRunButton.setContentHuggingPriority(.required, for: .horizontal)
        addSubview(reRunButton)

        // Open report externally button
        openExternalButton.translatesAutoresizingMaskIntoConstraints = false
        openExternalButton.bezelStyle = .accessoryBarAction
        openExternalButton.image = NSImage(systemSymbolName: "arrow.up.forward.square", accessibilityDescription: "Open Report")
        openExternalButton.imagePosition = .imageLeading
        openExternalButton.target = self
        openExternalButton.action = #selector(openExternalTapped(_:))
        openExternalButton.setContentHuggingPriority(.required, for: .horizontal)
        addSubview(openExternalButton)

        // Info label (center)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = .systemFont(ofSize: 11, weight: .regular)
        infoLabel.textColor = .secondaryLabelColor
        infoLabel.lineBreakMode = .byTruncatingTail
        infoLabel.stringValue = "Select an organism to view details"
        addSubview(infoLabel)

        // Provenance button (right)
        provenanceButton.translatesAutoresizingMaskIntoConstraints = false
        provenanceButton.bezelStyle = .accessoryBarAction
        provenanceButton.image = NSImage(systemSymbolName: "info.circle", accessibilityDescription: "Provenance")
        provenanceButton.imagePosition = .imageOnly
        provenanceButton.target = self
        provenanceButton.action = #selector(provenanceTapped(_:))
        provenanceButton.setContentHuggingPriority(.required, for: .horizontal)
        addSubview(provenanceButton)

        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: topAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),

            exportButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            exportButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            reRunButton.leadingAnchor.constraint(equalTo: exportButton.trailingAnchor, constant: 6),
            reRunButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            openExternalButton.leadingAnchor.constraint(equalTo: reRunButton.trailingAnchor, constant: 6),
            openExternalButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            infoLabel.leadingAnchor.constraint(equalTo: openExternalButton.trailingAnchor, constant: 12),
            infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            infoLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: provenanceButton.leadingAnchor, constant: -12
            ),

            provenanceButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            provenanceButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        setAccessibilityRole(.toolbar)
        setAccessibilityLabel("TaxTriage Action Bar")
    }

    // MARK: - Public API

    /// Configures the action bar with overall result metadata.
    func configure(organismCount: Int, sampleCount: Int) {
        // Reserved for future use
    }

    /// Updates the info label with the selected organism details.
    func updateSelection(organismName: String?, readCount: Int?) {
        if let name = organismName, let count = readCount {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            let readStr = formatter.string(from: NSNumber(value: count)) ?? "\(count)"
            infoLabel.stringValue = "\(name) \u{2014} \(readStr) reads"
            infoLabel.textColor = .labelColor
        } else {
            infoLabel.stringValue = "Select an organism to view details"
            infoLabel.textColor = .secondaryLabelColor
        }
    }

    /// Returns the info label text for testing.
    var infoText: String { infoLabel.stringValue }

    // MARK: - Actions

    @objc private func exportTapped(_ sender: NSButton) {
        onExport?()
    }

    @objc private func reRunTapped(_ sender: NSButton) {
        onReRun?()
    }

    @objc private func openExternalTapped(_ sender: NSButton) {
        onOpenExternally?()
    }

    @objc private func provenanceTapped(_ sender: NSButton) {
        onProvenance?(sender)
    }
}


// MARK: - TaxTriageProvenanceView

/// SwiftUI popover showing TaxTriage pipeline provenance metadata.
struct TaxTriageProvenanceView: View {
    let result: TaxTriageResult
    let config: TaxTriageConfig

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("TaxTriage Pipeline Provenance")
                .font(.headline)

            Divider()

            provenanceRow("Samples", value: "\(config.samples.count)")
            provenanceRow("Platform", value: config.platform.displayName)
            provenanceRow("Runtime", value: String(format: "%.1f seconds", result.runtime))
            provenanceRow("Exit Code", value: "\(result.exitCode)")
            provenanceRow("Reports", value: "\(result.reportFiles.count)")
            provenanceRow("Metrics Files", value: "\(result.metricsFiles.count)")

            Divider()

            provenanceRow("Classifiers", value: config.classifiers.joined(separator: ", "))
            provenanceRow("K2 Confidence", value: String(format: "%.2f", config.k2Confidence))
            provenanceRow("Top Hits", value: "\(config.topHitsCount)")
            provenanceRow("Skip Assembly", value: config.skipAssembly ? "Yes" : "No")
            provenanceRow("Max CPUs", value: "\(config.maxCpus)")
            provenanceRow("Max Memory", value: config.maxMemory)

            if let dbPath = config.kraken2DatabasePath {
                provenanceRow("Database", value: dbPath.lastPathComponent)
            }
        }
        .padding(12)
        .frame(width: 340, alignment: .leading)
    }

    private func provenanceRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)
                .frame(width: 110, alignment: .trailing)
            Text(value)
                .font(.system(size: 11))
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}
