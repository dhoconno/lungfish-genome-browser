// FASTQDatasetViewController.swift - FASTQ dataset statistics dashboard
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import LungfishIO
import os.log

private let logger = Logger(subsystem: "com.lungfish.browser", category: "FASTQDataset")

// MARK: - FASTQDatasetViewController

/// Dashboard view controller for FASTQ dataset files.
///
/// Replaces the reference sequence viewer when a FASTQ file is loaded.
/// Displays:
/// - Summary bar with key statistics (reads, bases, quality, GC content)
/// - Tabbed chart area (length histogram, quality boxplot, Q-score histogram)
/// - Searchable/sortable read table
@MainActor
public final class FASTQDatasetViewController: NSViewController,
    NSTableViewDataSource, NSTableViewDelegate, NSSearchFieldDelegate {

    // MARK: - Chart Tabs

    private enum ChartTab: Int, CaseIterable {
        case lengthDistribution = 0
        case qualityPerPosition = 1
        case qualityScoreDistribution = 2

        var title: String {
            switch self {
            case .lengthDistribution: return "Length Distribution"
            case .qualityPerPosition: return "Quality / Position"
            case .qualityScoreDistribution: return "Q Score Distribution"
            }
        }
    }

    // MARK: - Properties

    private var statistics: FASTQDatasetStatistics?
    private var allRecords: [FASTQRecord] = []
    private var displayedRecords: [FASTQRecord] = []
    private var filterText: String = ""

    private var sortKey: String = ""
    private var sortAscending: Bool = true

    private var activeChartTab: ChartTab = .lengthDistribution

    // MARK: - UI Components

    private let summaryBar = FASTQSummaryBar()
    private let tabBar = NSSegmentedControl()
    private let chartContainer = NSView()
    private let lengthHistogramView = FASTQHistogramChartView()
    private let qualityBoxplotView = FASTQQualityBoxplotView()
    private let qualityScoreHistogramView = FASTQHistogramChartView()

    private let searchBar = NSView()
    private let searchField = NSSearchField()
    private let countLabel = NSTextField(labelWithString: "")
    private let scrollView = NSScrollView()
    private let tableView = NSTableView()

    // MARK: - Lifecycle

    public override func loadView() {
        let container = NSView(frame: NSRect(x: 0, y: 0, width: 800, height: 600))
        container.wantsLayer = true
        view = container

        setupSummaryBar()
        setupTabBar()
        setupChartContainer()
        setupSearchBar()
        setupTableView()
        layoutSubviews()
    }

    // MARK: - Public API

    /// Configure the dashboard with statistics and sample records.
    public func configure(
        statistics: FASTQDatasetStatistics,
        records: [FASTQRecord]
    ) {
        self.statistics = statistics
        self.allRecords = records
        self.displayedRecords = records

        summaryBar.update(with: statistics)
        updateCharts()
        updateCountLabel()
        tableView.reloadData()
    }

    // MARK: - Setup

    private func setupSummaryBar() {
        summaryBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(summaryBar)
    }

    private func setupTabBar() {
        tabBar.segmentCount = ChartTab.allCases.count
        for tab in ChartTab.allCases {
            tabBar.setLabel(tab.title, forSegment: tab.rawValue)
            tabBar.setWidth(0, forSegment: tab.rawValue)  // auto-width
        }
        tabBar.selectedSegment = 0
        tabBar.segmentStyle = .texturedRounded
        tabBar.target = self
        tabBar.action = #selector(chartTabChanged(_:))
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBar)
    }

    private func setupChartContainer() {
        chartContainer.translatesAutoresizingMaskIntoConstraints = false
        chartContainer.wantsLayer = true
        view.addSubview(chartContainer)

        for chartView in [lengthHistogramView, qualityBoxplotView, qualityScoreHistogramView] as [NSView] {
            chartView.translatesAutoresizingMaskIntoConstraints = false
            chartContainer.addSubview(chartView)
            NSLayoutConstraint.activate([
                chartView.topAnchor.constraint(equalTo: chartContainer.topAnchor),
                chartView.leadingAnchor.constraint(equalTo: chartContainer.leadingAnchor),
                chartView.trailingAnchor.constraint(equalTo: chartContainer.trailingAnchor),
                chartView.bottomAnchor.constraint(equalTo: chartContainer.bottomAnchor),
            ])
        }

        // Start with length distribution visible
        qualityBoxplotView.isHidden = true
        qualityScoreHistogramView.isHidden = true
    }

    private func setupSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        searchField.placeholderString = "Filter reads by name..."
        searchField.delegate = self
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.sendsSearchStringImmediately = true
        searchBar.addSubview(searchField)

        countLabel.font = .monospacedDigitSystemFont(ofSize: 11, weight: .regular)
        countLabel.textColor = .secondaryLabelColor
        countLabel.alignment = .right
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.addSubview(countLabel)

        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: 8),
            searchField.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            searchField.widthAnchor.constraint(lessThanOrEqualToConstant: 300),

            countLabel.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -8),
            countLabel.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            countLabel.leadingAnchor.constraint(greaterThanOrEqualTo: searchField.trailingAnchor, constant: 8),
        ])
    }

    private func setupTableView() {
        let columns: [(id: String, title: String, width: CGFloat)] = [
            ("index", "#", 50),
            ("name", "Read Name", 250),
            ("length", "Length", 70),
            ("meanQ", "Mean Q", 70),
            ("gc", "GC%", 60),
            ("description", "Description", 200),
        ]

        for col in columns {
            let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(col.id))
            column.title = col.title
            column.width = col.width
            column.minWidth = 40
            column.sortDescriptorPrototype = NSSortDescriptor(key: col.id, ascending: true)
            tableView.addTableColumn(column)
        }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.rowHeight = 20
        tableView.allowsMultipleSelection = false
        tableView.headerView = NSTableHeaderView()
        tableView.style = .plain

        scrollView.documentView = tableView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
    }

    private func layoutSubviews() {
        NSLayoutConstraint.activate([
            // Summary bar
            summaryBar.topAnchor.constraint(equalTo: view.topAnchor),
            summaryBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            summaryBar.heightAnchor.constraint(equalToConstant: 48),

            // Tab bar
            tabBar.topAnchor.constraint(equalTo: summaryBar.bottomAnchor, constant: 4),
            tabBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Chart container
            chartContainer.topAnchor.constraint(equalTo: tabBar.bottomAnchor, constant: 4),
            chartContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chartContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chartContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),

            // Search bar
            searchBar.topAnchor.constraint(equalTo: chartContainer.bottomAnchor, constant: 2),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 32),

            // Table
            scrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        // Chart container takes roughly 40% of available space
        let chartHeightConstraint = chartContainer.heightAnchor.constraint(
            equalTo: view.heightAnchor, multiplier: 0.4
        )
        chartHeightConstraint.priority = .defaultHigh
        chartHeightConstraint.isActive = true
    }

    // MARK: - Chart Updates

    private func updateCharts() {
        guard let stats = statistics else { return }

        // Read Length Histogram
        let lengthBins = stats.readLengthHistogram.sorted { $0.key < $1.key }
            .map { (key: $0.key, value: $0.value) }
        lengthHistogramView.update(with: .init(
            title: "Read Length Distribution",
            xLabel: "Read Length (bp)",
            yLabel: "Count",
            bins: lengthBins,
            barColor: .systemBlue
        ))

        // Quality Score Histogram
        let qBins = stats.qualityScoreHistogram.sorted { $0.key < $1.key }
            .map { (key: Int($0.key), value: $0.value) }
        qualityScoreHistogramView.update(with: .init(
            title: "Quality Score Distribution",
            xLabel: "Quality Score (Phred)",
            yLabel: "Base Count",
            bins: qBins,
            barColor: .systemGreen
        ))

        // Per-Position Quality Boxplot
        qualityBoxplotView.update(with: stats.perPositionQuality)
    }

    @objc private func chartTabChanged(_ sender: NSSegmentedControl) {
        guard let tab = ChartTab(rawValue: sender.selectedSegment) else { return }
        activeChartTab = tab

        lengthHistogramView.isHidden = tab != .lengthDistribution
        qualityBoxplotView.isHidden = tab != .qualityPerPosition
        qualityScoreHistogramView.isHidden = tab != .qualityScoreDistribution
    }

    // MARK: - Filtering

    private func applyFilter() {
        let trimmed = filterText.trimmingCharacters(in: .whitespaces).lowercased()
        if trimmed.isEmpty {
            displayedRecords = allRecords
        } else {
            displayedRecords = allRecords.filter {
                $0.identifier.lowercased().contains(trimmed)
            }
        }
        applySortOrder()
        updateCountLabel()
        tableView.reloadData()
    }

    private func updateCountLabel() {
        let total = allRecords.count
        let shown = displayedRecords.count
        if shown == total {
            if let stats = statistics {
                countLabel.stringValue = "\(formatCount(stats.readCount)) reads total (\(formatCount(total)) in table)"
            } else {
                countLabel.stringValue = "\(formatCount(total)) reads"
            }
        } else {
            countLabel.stringValue = "\(formatCount(shown)) of \(formatCount(total)) reads"
        }
    }

    private func formatCount(_ count: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: count)) ?? "\(count)"
    }

    // MARK: - Sorting

    private func applySortOrder() {
        guard !sortKey.isEmpty else { return }
        displayedRecords.sort { a, b in
            let result: Bool
            switch sortKey {
            case "name":
                result = a.identifier < b.identifier
            case "length":
                result = a.length < b.length
            case "meanQ":
                result = a.quality.meanQuality < b.quality.meanQuality
            case "gc":
                result = gcFraction(a) < gcFraction(b)
            default:
                return false
            }
            return sortAscending ? result : !result
        }
    }

    private func gcFraction(_ record: FASTQRecord) -> Double {
        guard !record.sequence.isEmpty else { return 0 }
        var gc = 0
        for byte in record.sequence.utf8 {
            let upper = byte & 0xDF
            if upper == 0x47 || upper == 0x43 { gc += 1 }
        }
        return Double(gc) / Double(record.sequence.utf8.count)
    }

    // MARK: - NSSearchFieldDelegate

    public func controlTextDidChange(_ obj: Notification) {
        guard let field = obj.object as? NSSearchField, field === searchField else { return }
        filterText = field.stringValue
        applyFilter()
    }

    // MARK: - NSTableViewDataSource

    public func numberOfRows(in tableView: NSTableView) -> Int {
        displayedRecords.count
    }

    public func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        guard let descriptor = tableView.sortDescriptors.first,
              let key = descriptor.key else { return }
        sortKey = key
        sortAscending = descriptor.ascending
        applySortOrder()
        tableView.reloadData()
    }

    // MARK: - NSTableViewDelegate

    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard row < displayedRecords.count,
              let identifier = tableColumn?.identifier else { return nil }
        let record = displayedRecords[row]

        let cell = reuseOrCreate(identifier: identifier, in: tableView)
        let textField = cell.textField ?? {
            let tf = NSTextField(labelWithString: "")
            tf.translatesAutoresizingMaskIntoConstraints = false
            tf.lineBreakMode = .byTruncatingTail
            cell.addSubview(tf)
            cell.textField = tf
            NSLayoutConstraint.activate([
                tf.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 4),
                tf.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -4),
                tf.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            ])
            return tf
        }()

        textField.font = .monospacedDigitSystemFont(ofSize: 11, weight: .regular)
        textField.textColor = .labelColor

        switch identifier.rawValue {
        case "index":
            // Show the original index in the full dataset
            if let originalIndex = allRecords.firstIndex(where: { $0.identifier == record.identifier }) {
                textField.stringValue = "\(originalIndex + 1)"
            } else {
                textField.stringValue = "\(row + 1)"
            }
            textField.alignment = .right
            textField.textColor = .secondaryLabelColor

        case "name":
            textField.stringValue = record.identifier
            textField.font = .monospacedSystemFont(ofSize: 11, weight: .regular)

        case "length":
            textField.stringValue = "\(record.length)"
            textField.alignment = .right

        case "meanQ":
            let mq = record.quality.meanQuality
            textField.stringValue = String(format: "%.1f", mq)
            textField.alignment = .right
            // Color-code: green >= 30, yellow 20-30, red < 20
            if mq >= 30 {
                textField.textColor = .systemGreen
            } else if mq >= 20 {
                textField.textColor = .systemOrange
            } else {
                textField.textColor = .systemRed
            }

        case "gc":
            let gc = gcFraction(record) * 100
            textField.stringValue = String(format: "%.1f", gc)
            textField.alignment = .right

        case "description":
            textField.stringValue = record.description ?? ""
            textField.textColor = .secondaryLabelColor

        default:
            textField.stringValue = ""
        }

        return cell
    }

    private func reuseOrCreate(identifier: NSUserInterfaceItemIdentifier, in tableView: NSTableView) -> NSTableCellView {
        if let existing = tableView.makeView(withIdentifier: identifier, owner: nil) as? NSTableCellView {
            return existing
        }
        let cell = NSTableCellView()
        cell.identifier = identifier
        return cell
    }
}
