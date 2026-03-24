// EsVirituDetailPane.swift - Context-sensitive detail pane for EsViritu results
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import LungfishIO
import os.log

private let logger = Logger(subsystem: LogSubsystem.app, category: "EsVirituDetail")

// MARK: - EsVirituDetailPane

/// A context-sensitive detail pane for the EsViritu result viewer.
///
/// Shows different content depending on whether a virus is selected:
///
/// - **No selection (overview)**: Summary statistics with a mini bar chart
///   of the top detected viruses by read count.
/// - **Virus selected**: Full-width genome coverage plot rendered with
///   CoreGraphics, plus key metrics (reads, RPKMF, identity, Pi) and
///   a "View in BAM Viewer" button if BAM data is available.
///
/// ## CoreGraphics Coverage Plot
///
/// The coverage plot renders 100-window coverage data as an area chart:
/// - X axis: genome position (0% to 100%)
/// - Y axis: mean coverage depth (log scale)
/// - Filled area with gradient from accent color
/// - Annotated with max coverage point
/// - Per-segment sub-plots for segmented viruses
@MainActor
public final class EsVirituDetailPane: NSView {

    // MARK: - State

    private enum DisplayMode {
        case overview
        case virusDetail
    }

    private var displayMode: DisplayMode = .overview

    // Overview data
    private var overviewResult: LungfishIO.EsVirituResult?

    // Virus detail data
    private var selectedAssembly: ViralAssembly?
    private var selectedCoverageWindows: [String: [ViralCoverageWindow]] = [:]
    private var bamAvailable: Bool = false
    private var currentBAMURL: URL?

    /// The mini BAM view controller (child VC managed by the parent result VC).
    /// Set by the parent so we can embed the BAM pileup in the detail pane.
    public var miniBAMViewController: MiniBAMViewController?

    /// Called when the user clicks "View in BAM Viewer" for detailed inspection.
    public var onViewBAM: ((String) -> Void)?  // accession

    /// Called when the user selects a virus and BAM is available — triggers
    /// automatic alignment loading in the detail pane.
    public var onLoadAlignments: ((URL, String) -> Void)?  // bamURL, accession

    // MARK: - Subviews

    private let scrollView = NSScrollView()
    private let contentView = NSView()

    // Overview subviews
    private let overviewTitleLabel = NSTextField(labelWithString: "")
    private let topVirusesView = TopVirusBarChartView()

    // Detail subviews
    private let virusNameLabel = NSTextField(labelWithString: "")
    private let metricsGrid = NSGridView()
    private let coveragePlotView = CoverageAreaChartView()
    private let bamButton = NSButton(title: "View Alignments", target: nil, action: nil)

    // MARK: - Init

    public override init(frame: NSRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.drawsBackground = false
        addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.documentView = contentView

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        setupOverviewSubviews()
        setupDetailSubviews()
    }

    // MARK: - Setup

    private func setupOverviewSubviews() {
        overviewTitleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        overviewTitleLabel.textColor = .labelColor
        overviewTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        topVirusesView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupDetailSubviews() {
        virusNameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        virusNameLabel.textColor = .labelColor
        virusNameLabel.lineBreakMode = .byTruncatingTail
        virusNameLabel.translatesAutoresizingMaskIntoConstraints = false

        coveragePlotView.translatesAutoresizingMaskIntoConstraints = false

        bamButton.bezelStyle = .rounded
        bamButton.controlSize = .regular
        bamButton.image = NSImage(systemSymbolName: "eye", accessibilityDescription: "View")
        bamButton.imagePosition = .imageLeading
        bamButton.target = self
        bamButton.action = #selector(viewBAMClicked)
        bamButton.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Public API

    /// Shows the overview state with a bar chart of top viruses.
    public func configureOverview(
        result: LungfishIO.EsVirituResult,
        coverageWindows: [String: [ViralCoverageWindow]],
        bamURL: URL?
    ) {
        overviewResult = result
        bamAvailable = bamURL != nil
        displayMode = .overview
        rebuildContent()
    }

    /// Shows detailed coverage and metrics for a selected virus.
    public func showVirusDetail(
        assembly: ViralAssembly,
        coverageWindows: [String: [ViralCoverageWindow]],
        bamURL: URL?
    ) {
        selectedAssembly = assembly
        selectedCoverageWindows = coverageWindows
        bamAvailable = bamURL != nil
        currentBAMURL = bamURL
        displayMode = .virusDetail
        rebuildContent()

        // Automatically load BAM pileup for the selected virus
        if let bamURL, let primaryContig = assembly.contigs.first {
            miniBAMViewController?.displayContig(
                bamURL: bamURL,
                contig: primaryContig.accession,
                contigLength: primaryContig.length
            )
        } else {
            miniBAMViewController?.clear()
        }
    }

    // MARK: - Content Rebuild

    private func rebuildContent() {
        // Remove all subviews from content
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }

        switch displayMode {
        case .overview:
            buildOverviewContent()
        case .virusDetail:
            buildDetailContent()
        }
    }

    // MARK: - Overview Content

    private func buildOverviewContent() {
        guard let result = overviewResult else { return }

        overviewTitleLabel.stringValue = "Detected Viruses Overview"
        contentView.addSubview(overviewTitleLabel)

        // Summary labels
        let summaryText = NSTextField(labelWithString: """
        \(result.assemblies.count) assemblies detected
        \(result.detectedFamilyCount) viral families
        \(result.detectedSpeciesCount) species
        """)
        summaryText.font = .systemFont(ofSize: 12)
        summaryText.textColor = .secondaryLabelColor
        summaryText.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(summaryText)

        // Top viruses bar chart
        topVirusesView.configure(assemblies: result.assemblies)
        contentView.addSubview(topVirusesView)

        NSLayoutConstraint.activate([
            overviewTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            overviewTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            overviewTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            summaryText.topAnchor.constraint(equalTo: overviewTitleLabel.bottomAnchor, constant: 8),
            summaryText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            summaryText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            topVirusesView.topAnchor.constraint(equalTo: summaryText.bottomAnchor, constant: 16),
            topVirusesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            topVirusesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            topVirusesView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            topVirusesView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),

            // Content view width tracks scroll view
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    // MARK: - Detail Content

    private func buildDetailContent() {
        guard let assembly = selectedAssembly else { return }

        // Confidence badge + Virus name
        let headerStack = NSView()
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        let badgeView = makeConfidenceBadge(for: assembly)
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        headerStack.addSubview(badgeView)

        virusNameLabel.stringValue = assembly.name
        headerStack.addSubview(virusNameLabel)

        // Family badge
        let familyLabel = NSTextField(labelWithString: assembly.family ?? "")
        familyLabel.font = .systemFont(ofSize: 11)
        familyLabel.textColor = .secondaryLabelColor
        familyLabel.translatesAutoresizingMaskIntoConstraints = false
        headerStack.addSubview(familyLabel)

        NSLayoutConstraint.activate([
            badgeView.leadingAnchor.constraint(equalTo: headerStack.leadingAnchor),
            badgeView.topAnchor.constraint(equalTo: headerStack.topAnchor, constant: 2),
            badgeView.widthAnchor.constraint(equalToConstant: 18),
            badgeView.heightAnchor.constraint(equalToConstant: 18),

            virusNameLabel.leadingAnchor.constraint(equalTo: badgeView.trailingAnchor, constant: 6),
            virusNameLabel.topAnchor.constraint(equalTo: headerStack.topAnchor),
            virusNameLabel.trailingAnchor.constraint(equalTo: headerStack.trailingAnchor),

            familyLabel.leadingAnchor.constraint(equalTo: virusNameLabel.leadingAnchor),
            familyLabel.topAnchor.constraint(equalTo: virusNameLabel.bottomAnchor, constant: 2),
            familyLabel.bottomAnchor.constraint(equalTo: headerStack.bottomAnchor),
        ])
        contentView.addSubview(headerStack)

        // Metrics row
        let metricsView = buildMetricsView(for: assembly)
        contentView.addSubview(metricsView)

        // Segment completeness strip (only for segmented viruses with >1 contig)
        var segmentStripView: SegmentCompletenessView?
        if assembly.contigs.count > 1,
           assembly.contigs.contains(where: { $0.segment != nil }) {
            let strip = SegmentCompletenessView()
            strip.configure(assembly: assembly)
            strip.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(strip)
            segmentStripView = strip
        }

        // Coverage plot for each contig/segment
        coveragePlotView.configure(
            assembly: assembly,
            coverageWindows: selectedCoverageWindows
        )
        contentView.addSubview(coveragePlotView)

        // BAM pileup section (shown when BAM is available)
        var bamContainerView: NSView?
        if bamAvailable, let miniBAM = miniBAMViewController {
            // Section header
            let bamHeader = NSTextField(labelWithString: "Read Alignments")
            bamHeader.font = .systemFont(ofSize: 12, weight: .semibold)
            bamHeader.textColor = .labelColor
            bamHeader.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(bamHeader)

            // Embed the mini BAM view
            let bamView = miniBAM.view
            bamView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(bamView)

            let container = NSView()
            container.translatesAutoresizingMaskIntoConstraints = false
            bamContainerView = bamHeader  // Use header as the anchor for constraints

            NSLayoutConstraint.activate([
                bamHeader.topAnchor.constraint(equalTo: coveragePlotView.bottomAnchor, constant: 16),
                bamHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                bamHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

                bamView.topAnchor.constraint(equalTo: bamHeader.bottomAnchor, constant: 4),
                bamView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
                bamView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
                bamView.heightAnchor.constraint(greaterThanOrEqualToConstant: 250),
            ])
        }

        // The view chain anchors from: header → metrics → [segment strip] → coverage → [BAM label]
        let coverageTopAnchor: NSLayoutYAxisAnchor
        if let strip = segmentStripView {
            coverageTopAnchor = strip.bottomAnchor
        } else {
            coverageTopAnchor = metricsView.bottomAnchor
        }

        var constraints = [
            headerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            metricsView.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 12),
            metricsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            metricsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            coveragePlotView.topAnchor.constraint(equalTo: coverageTopAnchor, constant: 16),
            coveragePlotView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coveragePlotView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            coveragePlotView.heightAnchor.constraint(equalToConstant: 160),

            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ]

        // Segment strip constraints (between metrics and coverage)
        if let strip = segmentStripView {
            constraints += [
                strip.topAnchor.constraint(equalTo: metricsView.bottomAnchor, constant: 12),
                strip.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                strip.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            ]
        }

        if bamAvailable, let miniBAM = miniBAMViewController {
            // The BAM view's bottom provides the content bottom
            constraints.append(
                miniBAM.view.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
            )
        } else {
            constraints.append(
                coveragePlotView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
            )
        }

        NSLayoutConstraint.activate(constraints)
    }

    private func buildMetricsView(for assembly: ViralAssembly) -> NSView {
        let container = NSView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let metrics: [(String, String)] = [
            ("Reads", formatNumber(assembly.totalReads)),
            ("RPKMF", String(format: "%.1f", assembly.rpkmf)),
            ("Coverage", String(format: "%.1f%%", assembly.meanCoverage * 100)),
            ("Identity", String(format: "%.1f%%", assembly.avgReadIdentity * 100)),
            ("Family", assembly.family ?? "Unknown"),
        ]

        var previousView: NSView?
        for (label, value) in metrics {
            let metricView = makeMetricPill(label: label, value: value)
            container.addSubview(metricView)

            metricView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
            metricView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true

            if let prev = previousView {
                metricView.leadingAnchor.constraint(equalTo: prev.trailingAnchor, constant: 8).isActive = true
            } else {
                metricView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            }
            previousView = metricView
        }

        return container
    }

    private func makeMetricPill(label: String, value: String) -> NSView {
        let pill = NSView()
        pill.translatesAutoresizingMaskIntoConstraints = false

        let labelField = NSTextField(labelWithString: label)
        labelField.font = .systemFont(ofSize: 9, weight: .medium)
        labelField.textColor = .tertiaryLabelColor
        labelField.translatesAutoresizingMaskIntoConstraints = false

        let valueField = NSTextField(labelWithString: value)
        valueField.font = .monospacedDigitSystemFont(ofSize: 12, weight: .semibold)
        valueField.textColor = .labelColor
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

    private func formatNumber(_ n: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: n)) ?? "\(n)"
    }

    // MARK: - Confidence Badge

    /// Creates a confidence badge icon for the given assembly.
    ///
    /// Confidence tiers (from EsViritu research):
    /// - **High** (green ✓): ≥500 reads, ≥95% identity, ≥50% breadth
    /// - **Medium** (yellow △): ≥100 reads, OR 90-95% identity
    /// - **Low** (red !): <100 reads, OR <90% identity, OR <10% breadth
    private func makeConfidenceBadge(for assembly: ViralAssembly) -> NSView {
        let imageView = NSImageView()
        imageView.imageScaling = .scaleProportionallyDown

        let reads = assembly.totalReads
        let identity = assembly.avgReadIdentity
        let breadth = assembly.meanCoverage  // Using coverage as a proxy for breadth

        if reads >= 500 && identity >= 0.95 && breadth >= 0.5 {
            // High confidence
            imageView.image = NSImage(systemSymbolName: "checkmark.circle.fill", accessibilityDescription: "High confidence")
            imageView.contentTintColor = .systemGreen
        } else if reads >= 100 || identity >= 0.90 {
            // Medium confidence
            imageView.image = NSImage(systemSymbolName: "exclamationmark.triangle.fill", accessibilityDescription: "Medium confidence")
            imageView.contentTintColor = .systemYellow
        } else {
            // Low confidence
            imageView.image = NSImage(systemSymbolName: "exclamationmark.circle.fill", accessibilityDescription: "Low confidence")
            imageView.contentTintColor = .systemRed
        }

        return imageView
    }

    // MARK: - Actions

    @objc private func viewBAMClicked() {
        guard let assembly = selectedAssembly else { return }
        let primaryAccession = assembly.contigs.first?.accession ?? assembly.assembly
        onViewBAM?(primaryAccession)
    }
}

// MARK: - TopVirusBarChartView

/// A horizontal bar chart showing the top detected viruses by read count.
///
/// Renders up to 15 bars using CoreGraphics with the phylum-based color
/// palette from ``TaxonomyPhylumPalette``.
@MainActor
final class TopVirusBarChartView: NSView {

    private var assemblies: [ViralAssembly] = []
    private let maxBars = 15

    func configure(assemblies: [ViralAssembly]) {
        self.assemblies = Array(assemblies.sorted { $0.totalReads > $1.totalReads }.prefix(maxBars))
        needsDisplay = true
    }

    override func draw(_ dirtyRect: NSRect) {
        guard !assemblies.isEmpty else { return }

        let maxReads = assemblies.map(\.totalReads).max() ?? 1
        let barHeight: CGFloat = 18
        let gap: CGFloat = 3
        let labelWidth: CGFloat = min(bounds.width * 0.45, 160)
        let barAreaWidth = bounds.width - labelWidth - 8

        for (i, assembly) in assemblies.enumerated() {
            let y = bounds.height - CGFloat(i + 1) * (barHeight + gap)
            guard y >= 0 else { break }

            // Bar
            let barWidth = barAreaWidth * CGFloat(assembly.totalReads) / CGFloat(max(1, maxReads))
            let barRect = NSRect(x: labelWidth + 4, y: y, width: max(2, barWidth), height: barHeight)
            let color = NSColor.controlAccentColor.withAlphaComponent(0.7)
            color.setFill()
            NSBezierPath(roundedRect: barRect, xRadius: 3, yRadius: 3).fill()

            // Read count on bar
            let countStr = "\(assembly.totalReads)" as NSString
            let countAttrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.monospacedDigitSystemFont(ofSize: 10, weight: .medium),
                .foregroundColor: NSColor.white,
            ]
            let countSize = countStr.size(withAttributes: countAttrs)
            if countSize.width + 6 < barWidth {
                countStr.draw(
                    at: NSPoint(x: labelWidth + 8, y: y + (barHeight - countSize.height) / 2),
                    withAttributes: countAttrs
                )
            }

            // Label
            let name = (assembly.species ?? assembly.name) as NSString
            let nameAttrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 11),
                .foregroundColor: NSColor.labelColor,
            ]
            let nameRect = NSRect(x: 4, y: y, width: labelWidth - 4, height: barHeight)
            name.draw(with: nameRect, options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin], attributes: nameAttrs)
        }
    }

    override var intrinsicContentSize: NSSize {
        let h = CGFloat(min(assemblies.count, maxBars)) * 21 + 4
        return NSSize(width: NSView.noIntrinsicMetric, height: max(100, h))
    }
}

// MARK: - CoverageAreaChartView

/// A CoreGraphics area chart showing genome coverage depth across 100 windows.
///
/// For segmented viruses, draws one sub-chart per segment with labels.
/// Uses a gradient fill from accent color (bottom) to transparent (top).
@MainActor
final class CoverageAreaChartView: NSView {

    private var segments: [(accession: String, segment: String?, windows: [ViralCoverageWindow])] = []

    func configure(assembly: ViralAssembly, coverageWindows: [String: [ViralCoverageWindow]]) {
        segments = assembly.contigs.compactMap { contig in
            guard let windows = coverageWindows[contig.accession], !windows.isEmpty else { return nil }
            let sorted = windows.sorted { $0.windowIndex < $1.windowIndex }
            return (accession: contig.accession, segment: contig.segment, windows: sorted)
        }
        needsDisplay = true
    }

    override func draw(_ dirtyRect: NSRect) {
        guard !segments.isEmpty else {
            drawEmptyState()
            return
        }

        let segmentCount = segments.count
        let segmentHeight = (bounds.height - 4) / CGFloat(max(1, segmentCount))

        for (i, seg) in segments.enumerated() {
            let y = bounds.height - CGFloat(i + 1) * segmentHeight
            let rect = NSRect(x: 0, y: y + 2, width: bounds.width, height: segmentHeight - 4)
            drawCoverageChart(windows: seg.windows, in: rect, label: seg.segment)
        }
    }

    private func drawCoverageChart(windows: [ViralCoverageWindow], in rect: NSRect, label: String?) {
        guard !windows.isEmpty else { return }

        let maxCov = windows.map(\.averageCoverage).max() ?? 1
        let n = windows.count

        // Build path
        let path = NSBezierPath()
        path.move(to: NSPoint(x: rect.minX, y: rect.minY))

        for (i, w) in windows.enumerated() {
            let x = rect.minX + rect.width * CGFloat(i) / CGFloat(max(1, n - 1))
            let normalizedCov = maxCov > 0 ? CGFloat(w.averageCoverage / maxCov) : 0
            let y = rect.minY + rect.height * normalizedCov
            path.line(to: NSPoint(x: x, y: y))
        }

        path.line(to: NSPoint(x: rect.maxX, y: rect.minY))
        path.close()

        // Fill with gradient
        let accentColor = NSColor.controlAccentColor
        accentColor.withAlphaComponent(0.3).setFill()
        path.fill()

        // Stroke the top edge
        let strokePath = NSBezierPath()
        for (i, w) in windows.enumerated() {
            let x = rect.minX + rect.width * CGFloat(i) / CGFloat(max(1, n - 1))
            let normalizedCov = maxCov > 0 ? CGFloat(w.averageCoverage / maxCov) : 0
            let y = rect.minY + rect.height * normalizedCov
            if i == 0 {
                strokePath.move(to: NSPoint(x: x, y: y))
            } else {
                strokePath.line(to: NSPoint(x: x, y: y))
            }
        }
        accentColor.withAlphaComponent(0.8).setStroke()
        strokePath.lineWidth = 1.5
        strokePath.stroke()

        // Max coverage annotation
        if let maxWindow = windows.max(by: { $0.averageCoverage < $1.averageCoverage }) {
            let maxIdx = windows.firstIndex(where: { $0.windowIndex == maxWindow.windowIndex }) ?? 0
            let x = rect.minX + rect.width * CGFloat(maxIdx) / CGFloat(max(1, n - 1))
            let normalizedCov = maxCov > 0 ? CGFloat(maxWindow.averageCoverage / maxCov) : 0
            let y = rect.minY + rect.height * normalizedCov

            // Draw dot at max
            let dotRect = NSRect(x: x - 3, y: y - 3, width: 6, height: 6)
            accentColor.setFill()
            NSBezierPath(ovalIn: dotRect).fill()

            // Label
            let maxLabel = String(format: "%.0fx", maxWindow.averageCoverage) as NSString
            let attrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.monospacedDigitSystemFont(ofSize: 9, weight: .medium),
                .foregroundColor: accentColor,
            ]
            maxLabel.draw(at: NSPoint(x: x + 5, y: y - 4), withAttributes: attrs)
        }

        // Segment label
        if let label {
            let segLabel = "Seg \(label)" as NSString
            let attrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 9, weight: .medium),
                .foregroundColor: NSColor.tertiaryLabelColor,
            ]
            segLabel.draw(at: NSPoint(x: rect.minX + 4, y: rect.maxY - 12), withAttributes: attrs)
        }
    }

    private func drawEmptyState() {
        let text = "No coverage data" as NSString
        let attrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 12),
            .foregroundColor: NSColor.tertiaryLabelColor,
        ]
        let size = text.size(withAttributes: attrs)
        text.draw(
            at: NSPoint(x: (bounds.width - size.width) / 2, y: (bounds.height - size.height) / 2),
            withAttributes: attrs
        )
    }
}
