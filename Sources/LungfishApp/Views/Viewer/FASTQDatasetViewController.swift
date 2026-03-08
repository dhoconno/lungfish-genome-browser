// FASTQDatasetViewController.swift - FASTQ dataset statistics dashboard
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import LungfishIO

// MARK: - FASTQDatasetViewController

/// Dashboard view controller for FASTQ dataset files.
///
/// Replaces the reference sequence viewer when a FASTQ file is loaded.
/// Displays:
/// - Summary bar with key statistics (reads, bases, quality, GC content)
/// - Tabbed chart area (length histogram + optional quality charts)
/// - Optional on-demand quality report generation
@MainActor
public final class FASTQDatasetViewController: NSViewController {

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
    private var fastqURL: URL?
    private var activeChartTab: ChartTab = .lengthDistribution
    private var qualityReportTask: Task<Void, Never>?

    /// Called after quality report generation updates the dataset statistics.
    public var onStatisticsUpdated: ((FASTQDatasetStatistics) -> Void)?

    // MARK: - UI Components

    private let summaryBar = FASTQSummaryBar()
    private let controlsRow = NSView()
    private let tabBar = NSSegmentedControl()
    private let computeQualityButton = NSButton(title: "Compute Quality Report", target: nil, action: nil)
    private let qualityStatusBadge = NSTextField(labelWithString: "")
    private let progressIndicator = NSProgressIndicator()
    private let progressLabel = NSTextField(labelWithString: "")

    private let chartContainer = NSView()
    private let lengthHistogramView = FASTQHistogramChartView()
    private let qualityBoxplotView = FASTQQualityBoxplotView()
    private let qualityScoreHistogramView = FASTQHistogramChartView()

    deinit {
        qualityReportTask?.cancel()
    }

    // MARK: - Lifecycle

    public override func loadView() {
        let container = NSView(frame: NSRect(x: 0, y: 0, width: 800, height: 600))
        container.wantsLayer = true
        view = container

        setupSummaryBar()
        setupControlsRow()
        setupChartContainer()
        layoutSubviews()
    }

    // MARK: - Public API

    /// Configure the dashboard with statistics.
    ///
    /// `records` is ignored for now because per-read table display is disabled.
    public func configure(
        statistics: FASTQDatasetStatistics,
        records: [FASTQRecord],
        fastqURL: URL? = nil
    ) {
        _ = records
        self.statistics = statistics
        self.fastqURL = fastqURL
        self.activeChartTab = .lengthDistribution

        summaryBar.update(with: statistics)
        updateCharts()
        updateQualityControls()
    }

    // MARK: - Setup

    private func setupSummaryBar() {
        summaryBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(summaryBar)
    }

    private func setupControlsRow() {
        controlsRow.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controlsRow)

        tabBar.segmentCount = ChartTab.allCases.count
        for tab in ChartTab.allCases {
            tabBar.setLabel(tab.title, forSegment: tab.rawValue)
            tabBar.setWidth(0, forSegment: tab.rawValue)
        }
        tabBar.selectedSegment = ChartTab.lengthDistribution.rawValue
        tabBar.segmentStyle = .texturedRounded
        tabBar.target = self
        tabBar.action = #selector(chartTabChanged(_:))
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        controlsRow.addSubview(tabBar)

        computeQualityButton.bezelStyle = .rounded
        computeQualityButton.target = self
        computeQualityButton.action = #selector(computeQualityReportClicked(_:))
        computeQualityButton.translatesAutoresizingMaskIntoConstraints = false
        controlsRow.addSubview(computeQualityButton)

        qualityStatusBadge.font = .systemFont(ofSize: 11, weight: .semibold)
        qualityStatusBadge.alignment = .center
        qualityStatusBadge.wantsLayer = true
        qualityStatusBadge.layer?.cornerRadius = 6
        qualityStatusBadge.lineBreakMode = .byTruncatingTail
        qualityStatusBadge.translatesAutoresizingMaskIntoConstraints = false
        controlsRow.addSubview(qualityStatusBadge)

        progressIndicator.style = .spinning
        progressIndicator.controlSize = .small
        progressIndicator.isDisplayedWhenStopped = false
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        controlsRow.addSubview(progressIndicator)

        progressLabel.font = .systemFont(ofSize: 11)
        progressLabel.textColor = .secondaryLabelColor
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.isHidden = true
        controlsRow.addSubview(progressLabel)

        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: controlsRow.leadingAnchor, constant: 8),
            tabBar.centerYAnchor.constraint(equalTo: controlsRow.centerYAnchor),

            qualityStatusBadge.trailingAnchor.constraint(equalTo: computeQualityButton.leadingAnchor, constant: -8),
            qualityStatusBadge.centerYAnchor.constraint(equalTo: controlsRow.centerYAnchor),
            qualityStatusBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 118),
            qualityStatusBadge.heightAnchor.constraint(equalToConstant: 20),

            computeQualityButton.trailingAnchor.constraint(equalTo: controlsRow.trailingAnchor, constant: -8),
            computeQualityButton.centerYAnchor.constraint(equalTo: controlsRow.centerYAnchor),

            progressLabel.trailingAnchor.constraint(equalTo: controlsRow.trailingAnchor, constant: -8),
            progressLabel.centerYAnchor.constraint(equalTo: controlsRow.centerYAnchor),

            progressIndicator.trailingAnchor.constraint(equalTo: progressLabel.leadingAnchor, constant: -6),
            progressIndicator.centerYAnchor.constraint(equalTo: controlsRow.centerYAnchor),
        ])
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

        qualityBoxplotView.isHidden = true
        qualityScoreHistogramView.isHidden = true
    }

    private func layoutSubviews() {
        NSLayoutConstraint.activate([
            summaryBar.topAnchor.constraint(equalTo: view.topAnchor),
            summaryBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            summaryBar.heightAnchor.constraint(equalToConstant: 48),

            controlsRow.topAnchor.constraint(equalTo: summaryBar.bottomAnchor, constant: 4),
            controlsRow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlsRow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlsRow.heightAnchor.constraint(equalToConstant: 30),

            chartContainer.topAnchor.constraint(equalTo: controlsRow.bottomAnchor, constant: 4),
            chartContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chartContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chartContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    // MARK: - Chart Updates

    private func updateCharts() {
        guard let stats = statistics else { return }

        let lengthBins = stats.readLengthHistogram
            .sorted { $0.key < $1.key }
            .map { (key: $0.key, value: $0.value) }

        lengthHistogramView.update(with: .init(
            title: "Read Length Distribution",
            xLabel: "Read Length (bp)",
            yLabel: "Count",
            bins: lengthBins,
            barColor: .systemBlue
        ))

        let qBins = stats.qualityScoreHistogram.sorted { $0.key < $1.key }
            .map { (key: Int($0.key), value: $0.value) }

        qualityScoreHistogramView.update(with: .init(
            title: "Quality Score Distribution",
            xLabel: "Quality Score (Phred)",
            yLabel: "Base Count",
            bins: qBins,
            barColor: .systemGreen
        ))

        qualityBoxplotView.update(with: stats.perPositionQuality)
        applyChartVisibility()
    }

    private func applyChartVisibility() {
        lengthHistogramView.isHidden = activeChartTab != .lengthDistribution
        qualityBoxplotView.isHidden = activeChartTab != .qualityPerPosition
        qualityScoreHistogramView.isHidden = activeChartTab != .qualityScoreDistribution
    }

    private func updateQualityControls() {
        let hasQualityReport = hasQualityData

        tabBar.selectedSegment = activeChartTab.rawValue
        tabBar.setEnabled(true, forSegment: ChartTab.lengthDistribution.rawValue)
        tabBar.setEnabled(hasQualityReport, forSegment: ChartTab.qualityPerPosition.rawValue)
        tabBar.setEnabled(hasQualityReport, forSegment: ChartTab.qualityScoreDistribution.rawValue)

        if hasQualityReport {
            qualityStatusBadge.stringValue = "Quality Report: Cached"
            qualityStatusBadge.textColor = .systemGreen
            qualityStatusBadge.layer?.backgroundColor = NSColor.systemGreen.withAlphaComponent(0.12).cgColor
            qualityStatusBadge.layer?.borderColor = NSColor.systemGreen.withAlphaComponent(0.35).cgColor
            qualityStatusBadge.layer?.borderWidth = 1
        } else {
            qualityStatusBadge.stringValue = "Quality Report: Not Computed"
            qualityStatusBadge.textColor = .secondaryLabelColor
            qualityStatusBadge.layer?.backgroundColor = NSColor.tertiaryLabelColor.withAlphaComponent(0.12).cgColor
            qualityStatusBadge.layer?.borderColor = NSColor.tertiaryLabelColor.withAlphaComponent(0.25).cgColor
            qualityStatusBadge.layer?.borderWidth = 1
        }

        if !hasQualityReport,
           activeChartTab != .lengthDistribution {
            activeChartTab = .lengthDistribution
            tabBar.selectedSegment = activeChartTab.rawValue
            applyChartVisibility()
        }

        let canCompute = fastqURL != nil && !hasQualityReport && qualityReportTask == nil
        computeQualityButton.isHidden = !canCompute
    }

    private var hasQualityData: Bool {
        guard let stats = statistics else { return false }
        return !stats.perPositionQuality.isEmpty && !stats.qualityScoreHistogram.isEmpty
    }

    // MARK: - Actions

    @objc private func chartTabChanged(_ sender: NSSegmentedControl) {
        guard let tab = ChartTab(rawValue: sender.selectedSegment) else { return }
        if (tab == .qualityPerPosition || tab == .qualityScoreDistribution), !hasQualityData {
            sender.selectedSegment = ChartTab.lengthDistribution.rawValue
            activeChartTab = .lengthDistribution
        } else {
            activeChartTab = tab
        }
        applyChartVisibility()
    }

    @objc private func computeQualityReportClicked(_ sender: NSButton) {
        guard let url = fastqURL else { return }
        guard qualityReportTask == nil else { return }

        sender.isEnabled = false
        progressIndicator.startAnimation(nil)
        progressLabel.isHidden = false
        progressLabel.stringValue = "Computing quality report..."

        qualityReportTask = Task.detached(priority: .userInitiated) { [weak self] in
            do {
                let reader = FASTQReader(validateSequence: false)
                let (fullStats, _) = try await reader.computeStatistics(
                    from: url,
                    sampleLimit: 0
                )

                var metadata = FASTQMetadataStore.load(for: url) ?? PersistedFASTQMetadata()
                metadata.computedStatistics = fullStats
                FASTQMetadataStore.save(metadata, for: url)

                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.qualityReportTask = nil
                    self.statistics = fullStats
                    self.summaryBar.update(with: fullStats)
                    self.updateCharts()
                    self.updateQualityControls()
                    self.progressIndicator.stopAnimation(nil)
                    self.progressLabel.isHidden = true
                    self.computeQualityButton.isEnabled = true
                    self.onStatisticsUpdated?(fullStats)
                }
            } catch {
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.qualityReportTask = nil
                    self.progressIndicator.stopAnimation(nil)
                    self.progressLabel.isHidden = true
                    self.computeQualityButton.isEnabled = true

                    let alert = NSAlert()
                    alert.messageText = "Quality Report Failed"
                    alert.informativeText = error.localizedDescription
                    alert.alertStyle = .warning
                    alert.addButton(withTitle: "OK")
                    alert.runModal()
                }
            }
        }
    }
}
