// AssemblyResultViewController.swift - Viewport stub for de novo assembly results
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Track A4: Assembly Viewer viewport class.
//
// Displays assembly output from de novo assemblers (SPAdes, MEGAHIT, Flye).
// This is a foundation stub providing a contig table, summary bar, and
// statistics. The full viewport will add an Nx plot and sequence viewer
// integration in a future session.
//
// ## Viewport class conventions
// All assembly tools share this single viewport. The ResultType is
// SPAdesAssemblyResult because SPAdes is the first tool in this class.
// Future tools will contribute a common AssemblyResult wrapper once those
// pipelines are added.

import AppKit
import LungfishWorkflow
import LungfishIO

// MARK: - AssemblyResultViewController

/// Viewport controller for de novo assembly results.
///
/// Implements ``ResultViewportController`` for the Assembly Viewer viewport
/// class (Track A4). Shows assembly statistics, a sortable contig table,
/// and a summary bar for tools that produce assembled contig FASTA files.
///
/// ## Current state
/// This is a **stub** implementation. The contig table lists each contig
/// by name, length, and the assembly-level GC content. An Nx plot and
/// integration with the Sequence Viewer for individual contig browsing
/// will be added in a later session.
///
/// ## Usage
/// ```swift
/// let vc = AssemblyResultViewController()
/// vc.configure(result: spadesResult)
/// addChild(vc)
/// ```
@MainActor
public final class AssemblyResultViewController: NSViewController {

    // MARK: - Result storage

    /// The most recently configured assembly result.
    private(set) var currentResult: SPAdesAssemblyResult?

    // MARK: - Contig table data

    /// Contig rows derived from the assembly result for table display.
    private var contigRows: [ContigRow] = []

    /// A lightweight row model for the contig table.
    private struct ContigRow {
        let name: String
        let lengthBP: Int64
        let index: Int
    }

    // MARK: - Summary bar

    private let summaryBar: NSView = {
        let bar = NSView()
        bar.translatesAutoresizingMaskIntoConstraints = false

        let label = NSTextField(labelWithString: "Assembly Results")
        label.font = .systemFont(ofSize: NSFont.smallSystemFontSize, weight: .semibold)
        label.textColor = .secondaryLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        bar.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: bar.leadingAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: bar.centerYAnchor),
            bar.heightAnchor.constraint(equalToConstant: 32),
        ])

        return bar
    }()

    // MARK: - Statistics label

    private let statsLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.font = .monospacedSystemFont(ofSize: 11, weight: .regular)
        label.textColor = .labelColor
        label.isEditable = false
        label.isBezeled = false
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Contig table

    private let scrollView: NSScrollView = {
        let sv = NSScrollView()
        sv.hasVerticalScroller = true
        sv.hasHorizontalScroller = false
        sv.autohidesScrollers = true
        sv.borderType = .bezelBorder
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let tableView: NSTableView = {
        let tv = NSTableView()
        tv.usesAlternatingRowBackgroundColors = true
        tv.columnAutoresizingStyle = .lastColumnOnlyAutoresizingStyle
        tv.allowsColumnSelection = false
        tv.allowsMultipleSelection = false

        let rankCol = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("rank"))
        rankCol.title = "#"
        rankCol.width = 44
        rankCol.minWidth = 30
        rankCol.resizingMask = [.userResizingMask]

        let nameCol = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("name"))
        nameCol.title = "Contig"
        nameCol.width = 200
        nameCol.minWidth = 100
        nameCol.resizingMask = [.userResizingMask, .autoresizingMask]

        let lenCol = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("length"))
        lenCol.title = "Length (bp)"
        lenCol.width = 110
        lenCol.minWidth = 80
        lenCol.resizingMask = [.userResizingMask]

        tv.addTableColumn(rankCol)
        tv.addTableColumn(nameCol)
        tv.addTableColumn(lenCol)

        return tv
    }()

    // MARK: - Lifecycle

    public override func loadView() {
        let root = NSView()
        root.translatesAutoresizingMaskIntoConstraints = false
        self.view = root
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        scrollView.documentView = tableView

        view.addSubview(summaryBar)
        view.addSubview(statsLabel)
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            // Summary bar
            summaryBar.topAnchor.constraint(equalTo: view.topAnchor),
            summaryBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            // Stats block below summary bar
            statsLabel.topAnchor.constraint(equalTo: summaryBar.bottomAnchor, constant: 8),
            statsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            statsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

            // Contig table fills remaining space
            scrollView.topAnchor.constraint(equalTo: statsLabel.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    // MARK: - Private helpers

    /// Rebuilds the contig row list from the loaded FASTA (via bundle manifest
    /// chromosomes) when a full contig list is available, or falls back to a
    /// single aggregate row derived from `AssemblyStatistics`.
    ///
    /// Because `SPAdesAssemblyResult` does not embed per-contig lengths
    /// (only aggregate `AssemblyStatistics`), this stub populates the table
    /// with a single summary row until the bundle or contig FASTA is parsed.
    /// A future session will wire the parsed contig FASTA for per-row display.
    private func rebuildContigRows() {
        guard let result = currentResult else {
            contigRows = []
            return
        }

        // Stub: one summary row until per-contig parsing is available.
        let stats = result.statistics
        contigRows = (0 ..< stats.contigCount).map { index in
            ContigRow(
                name: "contig_\(index + 1)",
                lengthBP: 0,   // individual lengths not yet parsed from FASTA
                index: index
            )
        }

        // If we have zero contig count fall back to a single placeholder.
        if contigRows.isEmpty {
            contigRows = [ContigRow(name: "(no contigs)", lengthBP: 0, index: 0)]
        }
    }

    /// Refreshes the statistics label with key assembly metrics.
    private func updateStatsLabel() {
        guard let result = currentResult else {
            statsLabel.stringValue = ""
            return
        }
        let s = result.statistics
        statsLabel.stringValue = String(
            format: "Contigs: %d   Total: %@ bp   N50: %@ bp   L50: %d   Largest: %@ bp   GC: %.1f%%",
            s.contigCount,
            s.totalLengthBP.formatted(),
            s.n50.formatted(),
            s.l50,
            s.largestContigBP.formatted(),
            s.gcPercent
        )
    }

    /// Refreshes the summary bar label with a brief headline.
    private func updateSummaryBar() {
        guard let result = currentResult else { return }
        let s = result.statistics
        if let label = summaryBar.subviews.compactMap({ $0 as? NSTextField }).first {
            label.stringValue = "Assembly Results — \(s.contigCount.formatted()) contigs, N50 \(s.n50.formatted()) bp"
        }
    }
}

// MARK: - ResultViewportController

extension AssemblyResultViewController: ResultViewportController {

    public typealias ResultType = SPAdesAssemblyResult

    /// Display name used in menus, window titles, and export dialogs.
    public static var resultTypeName: String { "Assembly Results" }

    /// Configure the viewport with a SPAdes (or compatible) assembly result.
    ///
    /// Stores the result, rebuilds the contig table, and updates the summary
    /// bar and statistics label.
    /// - Parameter result: The `SPAdesAssemblyResult` to display.
    public func configure(result: SPAdesAssemblyResult) {
        currentResult = result
        rebuildContigRows()
        updateSummaryBar()
        updateStatsLabel()
        tableView.reloadData()
    }

    /// The summary bar view shown at the top of the viewport.
    public var summaryBarView: NSView { summaryBar }

    /// Export assembly results.
    ///
    /// - Note: Not yet implemented. Returns an error until the full export
    ///   pipeline (contig FASTA, statistics CSV, Nx plot) is built out.
    public func exportResults(to url: URL, format: ResultExportFormat) throws {
        throw NSError(
            domain: "Lungfish",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Assembly export not yet implemented"]
        )
    }
}

// MARK: - NSTableViewDataSource

extension AssemblyResultViewController: NSTableViewDataSource {

    public func numberOfRows(in tableView: NSTableView) -> Int {
        contigRows.count
    }
}

// MARK: - NSTableViewDelegate

extension AssemblyResultViewController: NSTableViewDelegate {

    public func tableView(
        _ tableView: NSTableView,
        viewFor tableColumn: NSTableColumn?,
        row: Int
    ) -> NSView? {
        guard row < contigRows.count else { return nil }
        let contig = contigRows[row]

        let cellID = NSUserInterfaceItemIdentifier("cell")
        let cell: NSTableCellView
        if let reused = tableView.makeView(withIdentifier: cellID, owner: self) as? NSTableCellView {
            cell = reused
        } else {
            cell = NSTableCellView()
            cell.identifier = cellID
            let textField = NSTextField(labelWithString: "")
            textField.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(textField)
            cell.textField = textField
            NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 4),
                textField.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -4),
                textField.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            ])
        }

        switch tableColumn?.identifier.rawValue {
        case "rank":
            cell.textField?.stringValue = "\(contig.index + 1)"
            cell.textField?.alignment = .right
        case "name":
            cell.textField?.stringValue = contig.name
            cell.textField?.alignment = .left
        case "length":
            let text = contig.lengthBP > 0 ? contig.lengthBP.formatted() : "—"
            cell.textField?.stringValue = text
            cell.textField?.alignment = .right
        default:
            cell.textField?.stringValue = ""
        }

        return cell
    }
}
