// BlastResultsDrawerTab.swift - BLAST verification results drawer tab
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import LungfishCore
import LungfishIO
import os.log

private let blastLogger = Logger(subsystem: LogSubsystem.app, category: "BlastResultsDrawer")

// MARK: - UI Helpers for BlastVerdict

extension BlastVerdict {

    /// SF Symbol name for this verdict's icon in the results table.
    var sfSymbolName: String {
        switch self {
        case .verified:   return "checkmark.circle.fill"
        case .ambiguous:  return "exclamationmark.triangle.fill"
        case .unverified: return "xmark.circle.fill"
        case .error:      return "exclamationmark.octagon.fill"
        }
    }

    /// Display color for this verdict's icon.
    var displayColor: NSColor {
        switch self {
        case .verified:   return .systemGreen
        case .ambiguous:  return .systemYellow
        case .unverified: return .systemRed
        case .error:      return .systemGray
        }
    }

    /// Accessibility description for VoiceOver.
    var accessibilityDescription: String {
        switch self {
        case .verified:   return "Verified"
        case .ambiguous:  return "Ambiguous"
        case .unverified: return "Unverified"
        case .error:      return "Error"
        }
    }
}

// MARK: - UI Helpers for BlastVerificationResult.Confidence

extension BlastVerificationResult.Confidence {

    /// Background tint color for the summary bar (alpha 0.15).
    var tintColor: NSColor {
        switch self {
        case .high:     return NSColor.systemGreen.withAlphaComponent(0.15)
        case .moderate: return NSColor.systemYellow.withAlphaComponent(0.15)
        case .low:      return NSColor.systemOrange.withAlphaComponent(0.15)
        case .suspect:  return NSColor.systemRed.withAlphaComponent(0.15)
        }
    }

    /// Foreground accent color for confidence indicators.
    var accentColor: NSColor {
        switch self {
        case .high:     return .systemGreen
        case .moderate: return .systemYellow
        case .low:      return .systemOrange
        case .suspect:  return .systemRed
        }
    }

    /// Human-readable display label.
    var displayLabel: String {
        switch self {
        case .high:     return "High"
        case .moderate: return "Mixed"
        case .low:      return "Low"
        case .suspect:  return "Very Low"
        }
    }
}

// MARK: - NCBI URL Helper

extension BlastVerificationResult {

    /// URL to open the BLAST results in the NCBI web interface.
    var ncbiResultsURL: URL? {
        URL(string: "https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Get&RID=\(rid)&FORMAT_TYPE=HTML")
    }

    /// Verification rate as a percentage (0 to 100).
    var verificationPercentage: Int {
        Int(round(verificationRate * 100))
    }
}

// MARK: - BLAST Job Phase

/// The current phase of a BLAST verification job.
///
/// Displayed in the loading state to give the user context on what the
/// app is doing while waiting for NCBI BLAST.
public enum BlastJobPhase: Int, Sendable {
    /// Submitting reads to the NCBI BLAST API.
    case submitting = 1
    /// Waiting for NCBI BLAST to process the job.
    case waiting = 2
    /// Parsing the returned BLAST results.
    case parsing = 3

    /// Human-readable label for this phase.
    public var label: String {
        switch self {
        case .submitting: return "Submitting reads to NCBI BLAST..."
        case .waiting:    return "Waiting for NCBI BLAST results..."
        case .parsing:    return "Parsing BLAST results..."
        }
    }

    /// Total number of phases.
    public static let totalPhases = 3
}

// MARK: - BlastResultsDrawerTab Column Identifiers

private extension NSUserInterfaceItemIdentifier {
    static let blastStatus = NSUserInterfaceItemIdentifier("blastStatus")
    static let blastReadId = NSUserInterfaceItemIdentifier("blastReadId")
    static let blastTopHit = NSUserInterfaceItemIdentifier("blastTopHit")
    static let blastIdentity = NSUserInterfaceItemIdentifier("blastIdentity")
    static let blastEValue = NSUserInterfaceItemIdentifier("blastEValue")
}

// MARK: - BlastResultsDrawerTab

/// An NSView-based tab for the bottom drawer showing BLAST verification results.
///
/// ## Layout
///
/// ```
/// +------------------------------------------------------------------+
/// | BLAST Verification Results                                        |
/// +------------------------------------------------------------------+
/// | Summary: 18 of 20 reads verified (90%)  [filled/empty dots] High  |
/// +------------------------------------------------------------------+
/// | Status | Read ID       | Top Hit        | Identity | E-value     |
/// | CK     | read_12345    | Oxbow virus    | 98.5%    | 1e-45       |
/// | CK     | read_67890    | Oxbow virus    | 96.2%    | 3e-38       |
/// | WN     | read_11111    | Bunyaviridae   | 82.1%    | 2e-12       |
/// | XM     | read_22222    | (no hit)       | -        | -           |
/// +------------------------------------------------------------------+
/// | [Open in NCBI BLAST]                         [Re-run BLAST]       |
/// +------------------------------------------------------------------+
/// ```
///
/// ## States
///
/// The view has three states:
/// - **Empty**: No BLAST results yet. Shows a centered icon and instructional text.
/// - **Loading**: A BLAST job is in progress. Shows a spinner, phase label, and progress.
/// - **Results**: BLAST verification results are available. Shows summary bar and table.
///
/// ## Thread Safety
///
/// This class is `@MainActor` isolated. All data source and delegate methods
/// run on the main thread.
@MainActor
public final class BlastResultsDrawerTab: NSView {

    // MARK: - State

    /// The current display state of the BLAST results tab.
    enum DisplayState {
        case empty
        case loading(phase: BlastJobPhase, requestId: String?)
        case results(BlastVerificationResult)
    }

    /// The current display state.
    private(set) var displayState: DisplayState = .empty

    /// Sorted read results for the table (when in results state).
    private var sortedResults: [BlastReadResult] = []

    /// The current sort descriptor key path and direction.
    private var sortKey: NSUserInterfaceItemIdentifier = .blastStatus
    private var sortAscending: Bool = true

    // MARK: - Callbacks

    /// Called when the user clicks "Open in NCBI BLAST".
    var onOpenInBrowser: ((URL) -> Void)?

    /// Called when the user clicks "Re-run BLAST".
    var onRerunBlast: (() -> Void)?

    /// Called when the user clicks "Cancel" during loading.
    var onCancelBlast: (() -> Void)?

    // MARK: - Subviews: Empty State

    private let emptyStateContainer = NSView()
    private let emptyStateIcon = NSImageView()
    private let emptyStateTitleLabel = NSTextField(labelWithString: "No BLAST Verifications")
    private let emptyStateDetailLabel = NSTextField(wrappingLabelWithString: "")

    // MARK: - Subviews: Loading State

    private let loadingStateContainer = NSView()
    private let loadingSpinner = NSProgressIndicator()
    private let loadingPhaseLabel = NSTextField(labelWithString: "")
    private let loadingPhaseNumberLabel = NSTextField(labelWithString: "")
    private let loadingProgressBar = NSProgressIndicator()
    private let loadingDetailLabel = NSTextField(labelWithString: "")
    private let loadingCancelButton = NSButton()

    // MARK: - Subviews: Results State

    private let resultsContainer = NSView()
    let summaryBar = NSView()
    private let summaryIcon = NSImageView()
    let summaryLabel = NSTextField(labelWithString: "")
    let confidenceLabel = NSTextField(labelWithString: "")
    let confidenceDots = NSTextField(labelWithString: "")
    private let resultsScrollView = NSScrollView()
    let resultsTableView = NSTableView()
    private let actionBar = NSView()
    let openInBlastButton = NSButton()
    let rerunBlastButton = NSButton()

    // MARK: - Initialization

    public override init(frame: NSRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        setupEmptyState()
        setupLoadingState()
        setupResultsState()
        showState(.empty)

        setAccessibilityRole(.group)
        setAccessibilityLabel("BLAST Verification Results")
    }

    // MARK: - Public API

    /// Shows the empty state with instructional text.
    func showEmpty() {
        displayState = .empty
        showState(.empty)
    }

    /// Shows the loading state with the given phase and optional request ID.
    ///
    /// - Parameters:
    ///   - phase: The current BLAST job phase.
    ///   - requestId: The NCBI BLAST request ID, if available.
    func showLoading(phase: BlastJobPhase, requestId: String?) {
        displayState = .loading(phase: phase, requestId: requestId)

        loadingPhaseLabel.stringValue = phase.label
        loadingPhaseNumberLabel.stringValue = "Phase \(phase.rawValue) of \(BlastJobPhase.totalPhases)"

        if let rid = requestId {
            loadingDetailLabel.stringValue = "Request ID: \(rid)"
        } else {
            loadingDetailLabel.stringValue = ""
        }

        // Phase 2 (waiting) uses indeterminate progress
        loadingProgressBar.isIndeterminate = (phase == .waiting)
        if phase == .waiting {
            loadingProgressBar.startAnimation(nil)
        } else {
            loadingProgressBar.stopAnimation(nil)
            loadingProgressBar.doubleValue = phase == .submitting ? 30.0 : 90.0
        }

        showState(.loading(phase: phase, requestId: requestId))
    }

    /// Shows BLAST verification results.
    ///
    /// Populates the summary bar and results table with data from the
    /// verification result.
    ///
    /// - Parameter result: The BLAST verification result to display.
    func showResults(_ result: BlastVerificationResult) {
        displayState = .results(result)

        // Update summary bar
        let verified = result.verifiedCount
        let total = result.totalReads
        let pct = result.verificationPercentage
        summaryLabel.stringValue = "\(verified) of \(total) reads verified (\(pct)%)"

        let confidence = result.confidence
        confidenceLabel.stringValue = confidence.displayLabel
        confidenceLabel.textColor = confidence.accentColor
        confidenceDots.stringValue = buildConfidenceDots(verified: verified, total: total)
        confidenceDots.textColor = confidence.accentColor
        summaryBar.layer?.backgroundColor = confidence.tintColor.cgColor

        let summaryIconImage = NSImage(
            systemSymbolName: verified > 0 ? "checkmark.circle.fill" : "xmark.circle.fill",
            accessibilityDescription: confidence.displayLabel
        )
        summaryIcon.image = summaryIconImage
        summaryIcon.contentTintColor = confidence.accentColor

        // Enable/disable "Open in BLAST" based on request ID
        openInBlastButton.isEnabled = !result.rid.isEmpty

        // Sort and reload table
        sortedResults = result.readResults
        applySortDescriptors()
        resultsTableView.reloadData()

        showState(.results(result))

        blastLogger.info(
            "Showing BLAST results: \(verified)/\(total) verified for \(result.taxonName, privacy: .public)"
        )
    }

    /// Returns the current result, if in the results state.
    var currentResult: BlastVerificationResult? {
        if case .results(let result) = displayState { return result }
        return nil
    }

    // MARK: - State Switching

    /// Shows or hides the appropriate container for the given state.
    private func showState(_ state: DisplayState) {
        emptyStateContainer.isHidden = true
        loadingStateContainer.isHidden = true
        resultsContainer.isHidden = true

        switch state {
        case .empty:
            emptyStateContainer.isHidden = false
        case .loading:
            loadingStateContainer.isHidden = false
            loadingSpinner.startAnimation(nil)
        case .results:
            resultsContainer.isHidden = false
            loadingSpinner.stopAnimation(nil)
        }
    }

    // MARK: - Setup: Empty State

    private func setupEmptyState() {
        emptyStateContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emptyStateContainer)

        let icon = NSImage(
            systemSymbolName: "bolt.badge.checkmark",
            accessibilityDescription: "BLAST verification"
        )
        emptyStateIcon.image = icon
        emptyStateIcon.translatesAutoresizingMaskIntoConstraints = false
        emptyStateIcon.contentTintColor = .tertiaryLabelColor
        emptyStateIcon.symbolConfiguration = NSImage.SymbolConfiguration(pointSize: 32, weight: .light)
        emptyStateContainer.addSubview(emptyStateIcon)

        emptyStateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateTitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        emptyStateTitleLabel.textColor = .secondaryLabelColor
        emptyStateTitleLabel.alignment = .center
        emptyStateContainer.addSubview(emptyStateTitleLabel)

        emptyStateDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateDetailLabel.stringValue =
            "Right-click a taxon and choose \"BLAST Matching Reads...\" to verify its classification against the NCBI database."
        emptyStateDetailLabel.font = .systemFont(ofSize: 12)
        emptyStateDetailLabel.textColor = .tertiaryLabelColor
        emptyStateDetailLabel.alignment = .center
        emptyStateDetailLabel.maximumNumberOfLines = 3
        emptyStateDetailLabel.preferredMaxLayoutWidth = 400
        emptyStateContainer.addSubview(emptyStateDetailLabel)

        NSLayoutConstraint.activate([
            emptyStateContainer.topAnchor.constraint(equalTo: topAnchor),
            emptyStateContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyStateContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyStateContainer.bottomAnchor.constraint(equalTo: bottomAnchor),

            emptyStateIcon.centerXAnchor.constraint(equalTo: emptyStateContainer.centerXAnchor),
            emptyStateIcon.centerYAnchor.constraint(equalTo: emptyStateContainer.centerYAnchor, constant: -30),
            emptyStateIcon.widthAnchor.constraint(equalToConstant: 40),
            emptyStateIcon.heightAnchor.constraint(equalToConstant: 40),

            emptyStateTitleLabel.topAnchor.constraint(equalTo: emptyStateIcon.bottomAnchor, constant: 8),
            emptyStateTitleLabel.centerXAnchor.constraint(equalTo: emptyStateContainer.centerXAnchor),

            emptyStateDetailLabel.topAnchor.constraint(equalTo: emptyStateTitleLabel.bottomAnchor, constant: 4),
            emptyStateDetailLabel.centerXAnchor.constraint(equalTo: emptyStateContainer.centerXAnchor),
            emptyStateDetailLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 400),
        ])
    }

    // MARK: - Setup: Loading State

    private func setupLoadingState() {
        loadingStateContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingStateContainer)

        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        loadingSpinner.style = .spinning
        loadingSpinner.controlSize = .regular
        loadingStateContainer.addSubview(loadingSpinner)

        loadingPhaseLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingPhaseLabel.font = .systemFont(ofSize: 13, weight: .medium)
        loadingPhaseLabel.textColor = .labelColor
        loadingPhaseLabel.alignment = .center
        loadingStateContainer.addSubview(loadingPhaseLabel)

        loadingPhaseNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingPhaseNumberLabel.font = .systemFont(ofSize: 11)
        loadingPhaseNumberLabel.textColor = .secondaryLabelColor
        loadingPhaseNumberLabel.alignment = .center
        loadingStateContainer.addSubview(loadingPhaseNumberLabel)

        loadingProgressBar.translatesAutoresizingMaskIntoConstraints = false
        loadingProgressBar.style = .bar
        loadingProgressBar.minValue = 0
        loadingProgressBar.maxValue = 100
        loadingProgressBar.isIndeterminate = false
        loadingStateContainer.addSubview(loadingProgressBar)

        loadingDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingDetailLabel.font = .monospacedSystemFont(ofSize: 10, weight: .regular)
        loadingDetailLabel.textColor = .tertiaryLabelColor
        loadingDetailLabel.alignment = .center
        loadingStateContainer.addSubview(loadingDetailLabel)

        loadingCancelButton.translatesAutoresizingMaskIntoConstraints = false
        loadingCancelButton.title = "Cancel"
        loadingCancelButton.bezelStyle = .rounded
        loadingCancelButton.controlSize = .regular
        loadingCancelButton.target = self
        loadingCancelButton.action = #selector(cancelButtonClicked(_:))
        loadingStateContainer.addSubview(loadingCancelButton)

        NSLayoutConstraint.activate([
            loadingStateContainer.topAnchor.constraint(equalTo: topAnchor),
            loadingStateContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingStateContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingStateContainer.bottomAnchor.constraint(equalTo: bottomAnchor),

            loadingSpinner.centerXAnchor.constraint(equalTo: loadingStateContainer.centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: loadingStateContainer.centerYAnchor, constant: -40),

            loadingPhaseLabel.topAnchor.constraint(equalTo: loadingSpinner.bottomAnchor, constant: 12),
            loadingPhaseLabel.centerXAnchor.constraint(equalTo: loadingStateContainer.centerXAnchor),

            loadingPhaseNumberLabel.topAnchor.constraint(equalTo: loadingPhaseLabel.bottomAnchor, constant: 4),
            loadingPhaseNumberLabel.centerXAnchor.constraint(equalTo: loadingStateContainer.centerXAnchor),

            loadingProgressBar.topAnchor.constraint(equalTo: loadingPhaseNumberLabel.bottomAnchor, constant: 8),
            loadingProgressBar.centerXAnchor.constraint(equalTo: loadingStateContainer.centerXAnchor),
            loadingProgressBar.widthAnchor.constraint(equalToConstant: 240),

            loadingDetailLabel.topAnchor.constraint(equalTo: loadingProgressBar.bottomAnchor, constant: 8),
            loadingDetailLabel.centerXAnchor.constraint(equalTo: loadingStateContainer.centerXAnchor),

            loadingCancelButton.topAnchor.constraint(equalTo: loadingDetailLabel.bottomAnchor, constant: 12),
            loadingCancelButton.centerXAnchor.constraint(equalTo: loadingStateContainer.centerXAnchor),
        ])
    }

    // MARK: - Setup: Results State

    private func setupResultsState() {
        resultsContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(resultsContainer)

        setupSummaryBar()
        setupResultsTable()
        setupActionBar()

        NSLayoutConstraint.activate([
            resultsContainer.topAnchor.constraint(equalTo: topAnchor),
            resultsContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            resultsContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            resultsContainer.bottomAnchor.constraint(equalTo: bottomAnchor),

            // Summary bar at top (36pt)
            summaryBar.topAnchor.constraint(equalTo: resultsContainer.topAnchor),
            summaryBar.leadingAnchor.constraint(equalTo: resultsContainer.leadingAnchor),
            summaryBar.trailingAnchor.constraint(equalTo: resultsContainer.trailingAnchor),
            summaryBar.heightAnchor.constraint(equalToConstant: 36),

            // Results table (fills middle)
            resultsScrollView.topAnchor.constraint(equalTo: summaryBar.bottomAnchor),
            resultsScrollView.leadingAnchor.constraint(equalTo: resultsContainer.leadingAnchor),
            resultsScrollView.trailingAnchor.constraint(equalTo: resultsContainer.trailingAnchor),
            resultsScrollView.bottomAnchor.constraint(equalTo: actionBar.topAnchor),

            // Action bar at bottom (32pt)
            actionBar.leadingAnchor.constraint(equalTo: resultsContainer.leadingAnchor),
            actionBar.trailingAnchor.constraint(equalTo: resultsContainer.trailingAnchor),
            actionBar.bottomAnchor.constraint(equalTo: resultsContainer.bottomAnchor),
            actionBar.heightAnchor.constraint(equalToConstant: 32),
        ])
    }

    // MARK: - Setup: Summary Bar

    private func setupSummaryBar() {
        summaryBar.translatesAutoresizingMaskIntoConstraints = false
        resultsContainer.addSubview(summaryBar)

        summaryIcon.translatesAutoresizingMaskIntoConstraints = false
        summaryIcon.contentTintColor = .systemGreen
        summaryIcon.setContentHuggingPriority(.required, for: .horizontal)
        summaryBar.addSubview(summaryIcon)

        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.font = .systemFont(ofSize: 12, weight: .medium)
        summaryLabel.textColor = .labelColor
        summaryLabel.lineBreakMode = .byTruncatingTail
        summaryBar.addSubview(summaryLabel)

        confidenceDots.translatesAutoresizingMaskIntoConstraints = false
        confidenceDots.font = .systemFont(ofSize: 10)
        confidenceDots.alignment = .center
        confidenceDots.setContentHuggingPriority(.required, for: .horizontal)
        summaryBar.addSubview(confidenceDots)

        confidenceLabel.translatesAutoresizingMaskIntoConstraints = false
        confidenceLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        confidenceLabel.alignment = .right
        confidenceLabel.setContentHuggingPriority(.required, for: .horizontal)
        summaryBar.addSubview(confidenceLabel)

        NSLayoutConstraint.activate([
            summaryIcon.leadingAnchor.constraint(equalTo: summaryBar.leadingAnchor, constant: 12),
            summaryIcon.centerYAnchor.constraint(equalTo: summaryBar.centerYAnchor),
            summaryIcon.widthAnchor.constraint(equalToConstant: 16),
            summaryIcon.heightAnchor.constraint(equalToConstant: 16),

            summaryLabel.leadingAnchor.constraint(equalTo: summaryIcon.trailingAnchor, constant: 8),
            summaryLabel.centerYAnchor.constraint(equalTo: summaryBar.centerYAnchor),

            confidenceDots.leadingAnchor.constraint(greaterThanOrEqualTo: summaryLabel.trailingAnchor, constant: 8),
            confidenceDots.centerYAnchor.constraint(equalTo: summaryBar.centerYAnchor),

            confidenceLabel.leadingAnchor.constraint(equalTo: confidenceDots.trailingAnchor, constant: 8),
            confidenceLabel.trailingAnchor.constraint(equalTo: summaryBar.trailingAnchor, constant: -12),
            confidenceLabel.centerYAnchor.constraint(equalTo: summaryBar.centerYAnchor),
        ])

        summaryBar.setAccessibilityRole(.group)
        summaryBar.setAccessibilityLabel("BLAST verification summary")
    }

    // MARK: - Setup: Results Table

    private func setupResultsTable() {
        resultsScrollView.translatesAutoresizingMaskIntoConstraints = false
        resultsScrollView.hasVerticalScroller = true
        resultsScrollView.hasHorizontalScroller = false
        resultsScrollView.autohidesScrollers = true
        resultsScrollView.borderType = .noBorder
        resultsContainer.addSubview(resultsScrollView)

        resultsTableView.rowHeight = 24
        resultsTableView.intercellSpacing = NSSize(width: 4, height: 0)
        resultsTableView.usesAlternatingRowBackgroundColors = true
        resultsTableView.allowsMultipleSelection = false
        resultsTableView.allowsColumnReordering = false

        // Status column (24pt, icon)
        let statusColumn = NSTableColumn(identifier: .blastStatus)
        statusColumn.title = ""
        statusColumn.width = 24
        statusColumn.minWidth = 24
        statusColumn.maxWidth = 24
        statusColumn.sortDescriptorPrototype = NSSortDescriptor(key: "status", ascending: true)
        resultsTableView.addTableColumn(statusColumn)

        // Read ID column (flexible)
        let readIdColumn = NSTableColumn(identifier: .blastReadId)
        readIdColumn.title = "Read ID"
        readIdColumn.minWidth = 120
        readIdColumn.resizingMask = .autoresizingMask
        readIdColumn.sortDescriptorPrototype = NSSortDescriptor(key: "readId", ascending: true)
        resultsTableView.addTableColumn(readIdColumn)

        // Top Hit column (flexible)
        let topHitColumn = NSTableColumn(identifier: .blastTopHit)
        topHitColumn.title = "Top Hit"
        topHitColumn.minWidth = 100
        topHitColumn.resizingMask = .autoresizingMask
        topHitColumn.sortDescriptorPrototype = NSSortDescriptor(key: "topHit", ascending: true)
        resultsTableView.addTableColumn(topHitColumn)

        // Identity column (60pt, right-aligned monospaced)
        let identityColumn = NSTableColumn(identifier: .blastIdentity)
        identityColumn.title = "Identity"
        identityColumn.width = 60
        identityColumn.minWidth = 50
        identityColumn.maxWidth = 80
        identityColumn.sortDescriptorPrototype = NSSortDescriptor(key: "identity", ascending: false)
        resultsTableView.addTableColumn(identityColumn)

        // E-value column (60pt, right-aligned)
        let eValueColumn = NSTableColumn(identifier: .blastEValue)
        eValueColumn.title = "E-value"
        eValueColumn.width = 60
        eValueColumn.minWidth = 50
        eValueColumn.maxWidth = 80
        eValueColumn.sortDescriptorPrototype = NSSortDescriptor(key: "eValue", ascending: true)
        resultsTableView.addTableColumn(eValueColumn)

        resultsTableView.dataSource = self
        resultsTableView.delegate = self

        resultsScrollView.documentView = resultsTableView

        resultsTableView.setAccessibilityLabel("BLAST Results Table")
    }

    // MARK: - Setup: Action Bar

    private func setupActionBar() {
        actionBar.translatesAutoresizingMaskIntoConstraints = false
        resultsContainer.addSubview(actionBar)

        // Separator line at top of action bar
        let separator = NSView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        actionBar.addSubview(separator)

        openInBlastButton.translatesAutoresizingMaskIntoConstraints = false
        openInBlastButton.title = "Open in NCBI BLAST"
        openInBlastButton.bezelStyle = .accessoryBarAction
        openInBlastButton.controlSize = .small
        openInBlastButton.font = .systemFont(ofSize: 11)
        openInBlastButton.target = self
        openInBlastButton.action = #selector(openInBlastClicked(_:))
        openInBlastButton.setAccessibilityLabel("Open results in NCBI BLAST website")
        actionBar.addSubview(openInBlastButton)

        rerunBlastButton.translatesAutoresizingMaskIntoConstraints = false
        rerunBlastButton.title = "Re-run BLAST"
        rerunBlastButton.bezelStyle = .accessoryBarAction
        rerunBlastButton.controlSize = .small
        rerunBlastButton.font = .systemFont(ofSize: 11)
        rerunBlastButton.target = self
        rerunBlastButton.action = #selector(rerunBlastClicked(_:))
        rerunBlastButton.setAccessibilityLabel("Re-run BLAST verification")
        actionBar.addSubview(rerunBlastButton)

        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: actionBar.topAnchor),
            separator.leadingAnchor.constraint(equalTo: actionBar.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: actionBar.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),

            openInBlastButton.leadingAnchor.constraint(equalTo: actionBar.leadingAnchor, constant: 12),
            openInBlastButton.centerYAnchor.constraint(equalTo: actionBar.centerYAnchor),

            rerunBlastButton.trailingAnchor.constraint(equalTo: actionBar.trailingAnchor, constant: -12),
            rerunBlastButton.centerYAnchor.constraint(equalTo: actionBar.centerYAnchor),
        ])
    }

    // MARK: - Confidence Dots

    /// Builds a string of filled and empty circle characters representing the
    /// verification rate.
    ///
    /// - Parameters:
    ///   - verified: Number of verified reads.
    ///   - total: Total number of reads.
    /// - Returns: A string like "●●●●●●●●●○○" with 10 characters total.
    func buildConfidenceDots(verified: Int, total: Int) -> String {
        guard total > 0 else { return String(repeating: "\u{25CB}", count: 10) }
        let filledCount = Int(round(Double(verified) / Double(total) * 10.0))
        let filled = String(repeating: "\u{25CF}", count: filledCount)
        let empty = String(repeating: "\u{25CB}", count: 10 - filledCount)
        return filled + empty
    }

    // MARK: - Sorting

    /// Sorts the results based on the current sort key and direction.
    private func applySortDescriptors() {
        sortedResults.sort { lhs, rhs in
            let result: Bool
            switch sortKey {
            case .blastStatus:
                result = lhs.verdict.rawValue < rhs.verdict.rawValue
            case .blastReadId:
                result = lhs.id.localizedStandardCompare(rhs.id) == .orderedAscending
            case .blastTopHit:
                let lhsOrg = lhs.topHitOrganism ?? ""
                let rhsOrg = rhs.topHitOrganism ?? ""
                result = lhsOrg.localizedStandardCompare(rhsOrg) == .orderedAscending
            case .blastIdentity:
                result = (lhs.percentIdentity ?? -1) < (rhs.percentIdentity ?? -1)
            case .blastEValue:
                result = (lhs.eValue ?? Double.infinity) < (rhs.eValue ?? Double.infinity)
            default:
                result = false
            }
            return sortAscending ? result : !result
        }
    }

    // MARK: - E-Value Formatting

    /// Formats an E-value for display in the table.
    ///
    /// Very small values use scientific notation (e.g., "1e-45").
    /// Zero is displayed as "0.0".
    ///
    /// - Parameter eValue: The E-value to format, or `nil`.
    /// - Returns: A formatted string, or "--" if `nil`.
    static func formatEValue(_ eValue: Double?) -> String {
        guard let eValue else { return "--" }
        if eValue == 0.0 { return "0.0" }
        if eValue < 0.001 {
            let exponent = Int(floor(log10(eValue)))
            let mantissa = eValue / pow(10, Double(exponent))
            if abs(mantissa - 1.0) < 0.05 {
                return "1e\(exponent)"
            }
            return String(format: "%.0fe%d", mantissa, exponent)
        }
        return String(format: "%.1e", eValue)
    }

    // MARK: - Actions

    @objc private func openInBlastClicked(_ sender: NSButton) {
        if case .results(let result) = displayState, let url = result.ncbiResultsURL {
            blastLogger.info("Opening BLAST results in browser: \(url.absoluteString, privacy: .public)")
            onOpenInBrowser?(url)
        }
    }

    @objc private func rerunBlastClicked(_ sender: NSButton) {
        blastLogger.info("Re-run BLAST requested")
        onRerunBlast?()
    }

    @objc private func cancelButtonClicked(_ sender: NSButton) {
        blastLogger.info("BLAST job cancel requested")
        onCancelBlast?()
    }
}

// MARK: - NSTableViewDataSource

extension BlastResultsDrawerTab: NSTableViewDataSource {

    public func numberOfRows(in tableView: NSTableView) -> Int {
        sortedResults.count
    }

    public func tableView(
        _ tableView: NSTableView,
        sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]
    ) {
        guard let descriptor = tableView.sortDescriptors.first,
              let key = descriptor.key else { return }

        // Map sort descriptor keys to column identifiers
        let columnId: NSUserInterfaceItemIdentifier
        switch key {
        case "status":   columnId = .blastStatus
        case "readId":   columnId = .blastReadId
        case "topHit":   columnId = .blastTopHit
        case "identity": columnId = .blastIdentity
        case "eValue":   columnId = .blastEValue
        default: return
        }

        sortKey = columnId
        sortAscending = descriptor.ascending
        applySortDescriptors()
        tableView.reloadData()
    }
}

// MARK: - NSTableViewDelegate

extension BlastResultsDrawerTab: NSTableViewDelegate {

    public func tableView(
        _ tableView: NSTableView,
        viewFor tableColumn: NSTableColumn?,
        row: Int
    ) -> NSView? {
        guard let columnId = tableColumn?.identifier,
              row >= 0, row < sortedResults.count else { return nil }

        let readResult = sortedResults[row]

        switch columnId {
        case .blastStatus:
            return makeStatusCell(for: readResult)
        case .blastReadId:
            return makeTextCell(readResult.id, font: .monospacedSystemFont(ofSize: 11, weight: .regular))
        case .blastTopHit:
            return makeTextCell(readResult.topHitOrganism ?? "No significant hit", font: .systemFont(ofSize: 11))
        case .blastIdentity:
            let text: String
            if let pct = readResult.percentIdentity {
                text = String(format: "%.1f%%", pct)
            } else {
                text = "--"
            }
            return makeTextCell(text, font: .monospacedDigitSystemFont(ofSize: 11, weight: .regular), alignment: .right)
        case .blastEValue:
            return makeTextCell(
                Self.formatEValue(readResult.eValue),
                font: .monospacedDigitSystemFont(ofSize: 11, weight: .regular),
                alignment: .right
            )
        default:
            return nil
        }
    }

    // MARK: - Cell Factories

    /// Creates a status icon cell for a read result.
    private func makeStatusCell(for result: BlastReadResult) -> NSView {
        let cell = NSTableCellView()
        let image = NSImage(
            systemSymbolName: result.verdict.sfSymbolName,
            accessibilityDescription: result.verdict.accessibilityDescription
        )
        let imageView = NSImageView(image: image ?? NSImage())
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentTintColor = result.verdict.displayColor
        cell.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 14),
            imageView.heightAnchor.constraint(equalToConstant: 14),
        ])

        return cell
    }

    /// Creates a text cell with the given string, font, and alignment.
    private func makeTextCell(
        _ text: String,
        font: NSFont,
        alignment: NSTextAlignment = .left
    ) -> NSView {
        let cell = NSTableCellView()
        let label = NSTextField(labelWithString: text)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = .labelColor
        label.alignment = alignment
        label.lineBreakMode = .byTruncatingTail
        label.toolTip = text
        cell.addSubview(label)
        cell.textField = label

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 2),
            label.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -2),
            label.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
        ])

        return cell
    }
}
