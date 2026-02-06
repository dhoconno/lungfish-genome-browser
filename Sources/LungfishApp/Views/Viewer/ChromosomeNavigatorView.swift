// ChromosomeNavigatorView.swift - Chromosome list navigator for reference bundles
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import LungfishCore
import os.log

/// Logger for chromosome navigator operations
private let logger = Logger(subsystem: "com.lungfish.browser", category: "ChromosomeNavigator")

// MARK: - ChromosomeNavigatorDelegate

/// Delegate protocol for chromosome selection events.
///
/// Implement this protocol to receive callbacks when the user selects a chromosome
/// from the navigator list. The delegate is called synchronously from the table
/// view selection handler.
@MainActor
protocol ChromosomeNavigatorDelegate: AnyObject {
    /// Called when a chromosome is selected in the navigator.
    ///
    /// - Parameters:
    ///   - navigator: The navigator view that sent the event
    ///   - chromosome: The selected chromosome information
    func chromosomeNavigator(_ navigator: ChromosomeNavigatorView, didSelectChromosome chromosome: ChromosomeInfo)
}

// MARK: - ChromosomeNavigatorView

/// A panel view that displays a list of chromosomes from a reference bundle manifest.
///
/// The navigator shows each chromosome's name and formatted length (e.g., "1.2 Mb")
/// in a single-column `NSTableView`. Clicking a row notifies the delegate to navigate
/// the viewer to that chromosome. The currently displayed chromosome is highlighted.
///
/// ## Usage
///
/// ```swift
/// let navigator = ChromosomeNavigatorView()
/// navigator.delegate = self
/// navigator.chromosomes = manifest.genome.chromosomes
/// navigator.selectedChromosomeIndex = 0
/// ```
///
/// ## Keyboard Navigation
///
/// The table view supports standard up/down arrow key navigation. Pressing Return
/// on a selected row also triggers the delegate callback.
@MainActor
public class ChromosomeNavigatorView: NSView, NSTableViewDataSource, NSTableViewDelegate {

    // MARK: - Properties

    /// Delegate that receives chromosome selection events.
    weak var delegate: ChromosomeNavigatorDelegate?

    /// The chromosomes to display in the list.
    var chromosomes: [ChromosomeInfo] = [] {
        didSet {
            tableView.reloadData()
            logger.debug("ChromosomeNavigatorView: Reloaded with \(self.chromosomes.count) chromosomes")
        }
    }

    /// Index of the currently selected chromosome.
    var selectedChromosomeIndex: Int = 0 {
        didSet {
            guard selectedChromosomeIndex >= 0,
                  selectedChromosomeIndex < chromosomes.count else { return }
            tableView.selectRowIndexes(IndexSet(integer: selectedChromosomeIndex), byExtendingSelection: false)
            tableView.scrollRowToVisible(selectedChromosomeIndex)
        }
    }

    // MARK: - UI Components

    private let scrollView = NSScrollView()
    private let tableView = NSTableView()
    private let headerLabel = NSTextField(labelWithString: "Chromosomes")

    /// Reuse identifier for table cells.
    private static let cellIdentifier = NSUserInterfaceItemIdentifier("ChromosomeCell")

    /// Column identifier for the main column.
    private static let columnIdentifier = NSUserInterfaceItemIdentifier("ChromosomeColumn")

    // MARK: - Initialization

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup

    private func setupView() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor

        // Header label
        headerLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        headerLabel.textColor = .secondaryLabelColor
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerLabel)

        // Configure table view
        let column = NSTableColumn(identifier: Self.columnIdentifier)
        column.title = "Chromosome"
        column.resizingMask = .autoresizingMask
        tableView.addTableColumn(column)

        tableView.headerView = nil
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 28
        tableView.intercellSpacing = NSSize(width: 0, height: 1)
        tableView.selectionHighlightStyle = .regular
        tableView.allowsMultipleSelection = false
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.style = .sourceList
        tableView.target = self
        tableView.doubleAction = #selector(tableViewDoubleClicked(_:))

        // Configure scroll view
        scrollView.documentView = tableView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.drawsBackground = false
        addSubview(scrollView)

        // Layout constraints
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            scrollView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 4),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        // Accessibility
        setAccessibilityElement(true)
        setAccessibilityRole(.group)
        setAccessibilityLabel("Chromosome navigator")
        setAccessibilityIdentifier("chromosome-navigator")

        tableView.setAccessibilityElement(true)
        tableView.setAccessibilityRole(.table)
        tableView.setAccessibilityLabel("Chromosome list")

        logger.info("ChromosomeNavigatorView: Setup complete")
    }

    // MARK: - Actions

    @objc private func tableViewDoubleClicked(_ sender: Any) {
        let row = tableView.clickedRow
        guard row >= 0, row < chromosomes.count else { return }

        let chromosome = chromosomes[row]
        logger.info("ChromosomeNavigatorView: Double-clicked chromosome '\(chromosome.name, privacy: .public)'")
        delegate?.chromosomeNavigator(self, didSelectChromosome: chromosome)
    }

    // MARK: - NSTableViewDataSource

    public func numberOfRows(in tableView: NSTableView) -> Int {
        chromosomes.count
    }

    // MARK: - NSTableViewDelegate

    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard row < chromosomes.count else { return nil }

        let chromosome = chromosomes[row]

        // Reuse or create cell view
        let cellView: ChromosomeCellView
        if let existing = tableView.makeView(withIdentifier: Self.cellIdentifier, owner: nil) as? ChromosomeCellView {
            cellView = existing
        } else {
            cellView = ChromosomeCellView()
            cellView.identifier = Self.cellIdentifier
        }

        cellView.configure(with: chromosome)
        return cellView
    }

    public func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        28
    }

    public func tableViewSelectionDidChange(_ notification: Notification) {
        let row = tableView.selectedRow
        guard row >= 0, row < chromosomes.count else { return }

        selectedChromosomeIndex = row
        let chromosome = chromosomes[row]
        logger.info("ChromosomeNavigatorView: Selected chromosome '\(chromosome.name, privacy: .public)' at index \(row)")
        delegate?.chromosomeNavigator(self, didSelectChromosome: chromosome)
    }

    // MARK: - Public API

    /// Selects a chromosome by name, scrolling it into view.
    ///
    /// - Parameter name: The chromosome name to select
    /// - Returns: `true` if the chromosome was found and selected, `false` otherwise
    @discardableResult
    func selectChromosome(named name: String) -> Bool {
        guard let index = chromosomes.firstIndex(where: { $0.name == name }) else {
            logger.debug("ChromosomeNavigatorView: Chromosome '\(name, privacy: .public)' not found")
            return false
        }
        selectedChromosomeIndex = index
        return true
    }
}

// MARK: - ChromosomeCellView

/// Custom cell view for a chromosome row in the navigator.
///
/// Displays the chromosome name on the left and a formatted length on the right.
/// The length is formatted as human-readable units (bp, Kb, Mb, Gb).
private class ChromosomeCellView: NSTableCellView {

    private let nameLabel = NSTextField(labelWithString: "")
    private let lengthLabel = NSTextField(labelWithString: "")

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    private func setupCell() {
        nameLabel.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        nameLabel.textColor = .labelColor
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)

        lengthLabel.font = .monospacedSystemFont(ofSize: 10, weight: .regular)
        lengthLabel.textColor = .secondaryLabelColor
        lengthLabel.alignment = .right
        lengthLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lengthLabel)

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: lengthLabel.leadingAnchor, constant: -4),

            lengthLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            lengthLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            lengthLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
        ])
    }

    /// Configures the cell with chromosome information.
    ///
    /// - Parameter chromosome: The chromosome info to display
    func configure(with chromosome: ChromosomeInfo) {
        nameLabel.stringValue = chromosome.name
        lengthLabel.stringValue = Self.formatLength(chromosome.length)

        // Accessibility
        setAccessibilityLabel("\(chromosome.name), \(Self.formatLength(chromosome.length))")
    }

    /// Formats a base pair count into a human-readable string.
    ///
    /// - Parameter length: Length in base pairs
    /// - Returns: Formatted string (e.g., "1.2 Mb", "345 Kb", "89 bp")
    static func formatLength(_ length: Int64) -> String {
        switch length {
        case 0..<1_000:
            return "\(length) bp"
        case 1_000..<1_000_000:
            return String(format: "%.1f Kb", Double(length) / 1_000.0)
        case 1_000_000..<1_000_000_000:
            return String(format: "%.1f Mb", Double(length) / 1_000_000.0)
        default:
            return String(format: "%.2f Gb", Double(length) / 1_000_000_000.0)
        }
    }
}
