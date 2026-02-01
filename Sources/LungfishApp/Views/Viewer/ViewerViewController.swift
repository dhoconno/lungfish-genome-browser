// ViewerViewController.swift - Main sequence/track viewer
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import LungfishCore
import UniformTypeIdentifiers
import os.log

// MARK: - Logging

/// Logger for viewer operations
private let logger = Logger(subsystem: "com.lungfish.browser", category: "ViewerViewController")

// MARK: - Base Colors (IGV Standard)

/// Standard IGV-like base colors for DNA visualization
/// Reference: IGV's SequenceTrack.java
public enum BaseColors {
    /// A = Green (#00CC00)
    public static let A = NSColor(calibratedRed: 0.0, green: 0.8, blue: 0.0, alpha: 1.0)
    /// T = Red (#CC0000)
    public static let T = NSColor(calibratedRed: 0.8, green: 0.0, blue: 0.0, alpha: 1.0)
    /// C = Blue (#0000CC)
    public static let C = NSColor(calibratedRed: 0.0, green: 0.0, blue: 0.8, alpha: 1.0)
    /// G = Orange/Yellow (#FFB300)
    public static let G = NSColor(calibratedRed: 1.0, green: 0.7, blue: 0.0, alpha: 1.0)
    /// N = Gray (#888888)
    public static let N = NSColor(calibratedRed: 0.53, green: 0.53, blue: 0.53, alpha: 1.0)
    /// U = Red (RNA, same as T)
    public static let U = T

    /// Returns the color for a given base character
    public static func color(for base: Character) -> NSColor {
        switch base.uppercased().first {
        case "A": return A
        case "T": return T
        case "C": return C
        case "G": return G
        case "U": return U
        case "N": return N
        default: return N
        }
    }

    /// Dictionary mapping base characters to colors
    public static let colorMap: [Character: NSColor] = [
        "A": A, "a": A,
        "T": T, "t": T,
        "C": C, "c": C,
        "G": G, "g": G,
        "U": U, "u": U,
        "N": N, "n": N,
    ]
}

/// Controller for the main viewer panel containing sequence and track display.
@MainActor
public class ViewerViewController: NSViewController {

    // MARK: - UI Components

    /// The custom view for rendering sequences and tracks
    private var viewerView: SequenceViewerView!

    /// Header view for track labels
    private var headerView: TrackHeaderView!

    /// Coordinate ruler at the top
    private var rulerView: CoordinateRulerView!

    /// Status bar at the bottom
    private var statusBar: ViewerStatusBar!

    /// Progress indicator overlay
    private var progressOverlay: ProgressOverlayView!

    // MARK: - State

    /// Current reference frame for coordinate mapping
    public var referenceFrame: ReferenceFrame?

    /// Currently displayed document
    public private(set) var currentDocument: LoadedDocument?

    /// Track height constant
    private let sequenceTrackY: CGFloat = 8
    private let sequenceTrackHeight: CGFloat = 24

    // MARK: - Lifecycle

    public override func loadView() {
        let containerView = NSView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.wantsLayer = true

        // Create ruler view
        rulerView = CoordinateRulerView()
        rulerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(rulerView)

        // Create track header view
        headerView = TrackHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.trackY = sequenceTrackY
        headerView.trackHeight = sequenceTrackHeight
        containerView.addSubview(headerView)

        // Create main viewer view
        viewerView = SequenceViewerView()
        viewerView.translatesAutoresizingMaskIntoConstraints = false
        viewerView.viewController = self
        viewerView.trackY = sequenceTrackY
        viewerView.trackHeight = sequenceTrackHeight
        containerView.addSubview(viewerView)

        // Create status bar
        statusBar = ViewerStatusBar()
        statusBar.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(statusBar)

        // Create progress overlay (initially hidden)
        progressOverlay = ProgressOverlayView()
        progressOverlay.translatesAutoresizingMaskIntoConstraints = false
        progressOverlay.isHidden = true
        containerView.addSubview(progressOverlay)

        // Layout
        let headerWidth: CGFloat = 100
        let rulerHeight: CGFloat = 28
        let statusHeight: CGFloat = 24

        NSLayoutConstraint.activate([
            // Ruler spans full width above content
            rulerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            rulerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: headerWidth),
            rulerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            rulerView.heightAnchor.constraint(equalToConstant: rulerHeight),

            // Header on the left
            headerView.topAnchor.constraint(equalTo: rulerView.bottomAnchor),
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerView.widthAnchor.constraint(equalToConstant: headerWidth),
            headerView.bottomAnchor.constraint(equalTo: statusBar.topAnchor),

            // Viewer fills the main area
            viewerView.topAnchor.constraint(equalTo: rulerView.bottomAnchor),
            viewerView.leadingAnchor.constraint(equalTo: headerView.trailingAnchor),
            viewerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            viewerView.bottomAnchor.constraint(equalTo: statusBar.topAnchor),

            // Status bar at the bottom
            statusBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            statusBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            statusBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: statusHeight),

            // Progress overlay covers the viewer area
            progressOverlay.topAnchor.constraint(equalTo: rulerView.bottomAnchor),
            progressOverlay.leadingAnchor.constraint(equalTo: headerView.trailingAnchor),
            progressOverlay.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            progressOverlay.bottomAnchor.constraint(equalTo: statusBar.topAnchor),
        ])

        self.view = containerView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        logger.info("viewDidLoad: ViewerViewController loaded")

        // Set background color
        view.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor

        // Create initial reference frame
        referenceFrame = ReferenceFrame(
            chromosome: "chr1",
            start: 0,
            end: 10000,
            pixelWidth: Int(view.bounds.width)
        )
        logger.debug("viewDidLoad: Created initial referenceFrame with width=\(Int(self.view.bounds.width))")

        // Set up accessibility
        setupAccessibility()
        logger.info("viewDidLoad: Setup complete")
    }

    private func setupAccessibility() {
        view.setAccessibilityElement(true)
        view.setAccessibilityRole(.group)
        view.setAccessibilityLabel("Sequence viewer")
        view.setAccessibilityIdentifier("sequence-viewer-container")

        viewerView.setAccessibilityElement(true)
        viewerView.setAccessibilityRole(.group)
        viewerView.setAccessibilityLabel("Sequence display area")
        viewerView.setAccessibilityIdentifier("sequence-viewer")
    }

    // MARK: - Progress Indicator

    /// Shows the progress overlay with a message
    public func showProgress(_ message: String) {
        logger.info("showProgress: '\(message, privacy: .public)'")
        progressOverlay.message = message
        progressOverlay.isHidden = false
        progressOverlay.startAnimating()
    }

    /// Hides the progress overlay
    public func hideProgress() {
        logger.info("hideProgress: Hiding progress overlay")
        progressOverlay.stopAnimating()
        progressOverlay.isHidden = true
    }

    // MARK: - Document Display

    /// Displays a loaded document in the viewer.
    public func displayDocument(_ document: LoadedDocument) {
        logger.info("displayDocument: Starting to display '\(document.name, privacy: .public)'")
        logger.info("displayDocument: Document has \(document.sequences.count) sequences, \(document.annotations.count) annotations")
        // Debug output to stderr for immediate visibility
        fputs("DEBUG: displayDocument called for '\(document.name)' with \(document.sequences.count) sequences\n", stderr)

        currentDocument = document

        // Update reference frame based on first sequence
        if let firstSequence = document.sequences.first {
            let length = firstSequence.length
            logger.info("displayDocument: First sequence '\(firstSequence.name, privacy: .public)' has length \(length)")
            fputs("DEBUG: First sequence '\(firstSequence.name)' length=\(length)\n", stderr)

            referenceFrame = ReferenceFrame(
                chromosome: firstSequence.name,
                start: 0,
                end: Double(min(length, 10000)),  // Start zoomed in
                pixelWidth: max(1, Int(viewerView.bounds.width))
            )
            logger.debug("displayDocument: Created referenceFrame start=0 end=\(min(length, 10000)) width=\(Int(self.viewerView.bounds.width))")

            // Pass data to viewer
            logger.info("displayDocument: Setting sequence on viewerView...")
            fputs("DEBUG: About to call viewerView.setSequence\n", stderr)
            viewerView.setSequence(firstSequence)
            viewerView.setAnnotations(document.annotations)
            fputs("DEBUG: setSequence completed, viewerView.sequence is \(viewerView.sequence == nil ? "nil" : "SET")\n", stderr)
            logger.info("displayDocument: Sequence and annotations set on viewerView")

            // Update header with track names
            let trackNames = [firstSequence.name] + (document.annotations.isEmpty ? [] : ["Annotations"])
            headerView.setTrackNames(trackNames)
            logger.debug("displayDocument: Set track names: \(trackNames, privacy: .public)")

            // Update ruler
            rulerView.referenceFrame = referenceFrame
            logger.debug("displayDocument: Updated ruler reference frame")
        } else {
            logger.warning("displayDocument: No sequences in document!")
        }

        // Trigger redraw
        logger.info("displayDocument: Triggering redraw of all views...")
        viewerView.setNeedsDisplay(viewerView.bounds)
        rulerView.setNeedsDisplay(rulerView.bounds)
        headerView.setNeedsDisplay(headerView.bounds)
        updateStatusBar()
        logger.info("displayDocument: Completed displaying document")
    }

    // MARK: - Public API

    /// Zooms in on the current view
    public func zoomIn() {
        referenceFrame?.zoomIn(factor: 2.0)
        viewerView.setNeedsDisplay(viewerView.bounds)
        rulerView.setNeedsDisplay(rulerView.bounds)
        updateStatusBar()
    }

    /// Zooms out from the current view
    public func zoomOut() {
        referenceFrame?.zoomOut(factor: 2.0)
        viewerView.setNeedsDisplay(viewerView.bounds)
        rulerView.setNeedsDisplay(rulerView.bounds)
        updateStatusBar()
    }

    /// Zooms to fit the entire sequence
    public func zoomToFit() {
        guard let sequence = viewerView.sequence else { return }
        referenceFrame?.start = 0
        referenceFrame?.end = Double(sequence.length)
        viewerView.setNeedsDisplay(viewerView.bounds)
        rulerView.setNeedsDisplay(rulerView.bounds)
        updateStatusBar()
    }

    /// Navigates to a specific genomic region
    public func navigate(to region: GenomicRegion) {
        referenceFrame = ReferenceFrame(
            chromosome: region.chromosome,
            start: Double(region.start),
            end: Double(region.end),
            pixelWidth: Int(view.bounds.width)
        )
        viewerView.setNeedsDisplay(viewerView.bounds)
        rulerView.setNeedsDisplay(rulerView.bounds)
        updateStatusBar()
    }

    private func updateStatusBar() {
        guard let frame = referenceFrame else { return }
        statusBar.update(
            position: "\(frame.chromosome):\(Int(frame.start))-\(Int(frame.end))",
            selection: nil,
            scale: frame.scale
        )
    }

    /// Handles file drop from the viewer view
    func handleFileDrop(_ urls: [URL]) {
        logger.info("handleFileDrop: Received \(urls.count) URLs")
        for (index, url) in urls.enumerated() {
            logger.info("handleFileDrop: URL[\(index)] = '\(url.path, privacy: .public)'")
        }

        // Process files sequentially
        guard let firstURL = urls.first else {
            logger.warning("handleFileDrop: No URLs to process")
            return
        }

        logger.info("handleFileDrop: Processing '\(firstURL.lastPathComponent, privacy: .public)'")

        // Show progress immediately
        showProgress("Loading \(firstURL.lastPathComponent)...")
        logger.info("handleFileDrop: Progress shown, starting detached task")

        // Use Task.detached to break out of the main actor context during drag handling
        // This ensures the task starts on a background executor, avoiding run loop issues
        Task.detached {
            logger.info("handleFileDrop: Detached task started for '\(firstURL.lastPathComponent, privacy: .public)'")

            do {
                logger.info("handleFileDrop: Calling DocumentManager.shared.loadDocument...")
                let document = try await DocumentManager.shared.loadDocument(at: firstURL)

                // Update UI on main actor
                await MainActor.run { [weak self] in
                    guard let self = self else {
                        logger.error("handleFileDrop: self is nil when updating UI")
                        return
                    }
                    logger.info("handleFileDrop: Document loaded: '\(document.name, privacy: .public)' with \(document.sequences.count) sequences")
                    self.hideProgress()
                    logger.info("handleFileDrop: Calling displayDocument...")
                    self.displayDocument(document)
                    logger.info("handleFileDrop: displayDocument completed")
                }
            } catch {
                logger.error("handleFileDrop: Load failed: \(error.localizedDescription, privacy: .public)")

                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    self.hideProgress()
                    let alert = NSAlert()
                    alert.messageText = "Failed to Open File"
                    alert.informativeText = error.localizedDescription
                    alert.alertStyle = .warning
                    alert.addButton(withTitle: "OK")
                    alert.runModal()
                }
            }
        }
        logger.info("handleFileDrop: Detached task created")
    }
}

// MARK: - ProgressOverlayView

/// A translucent overlay showing a spinner and message during loading.
public class ProgressOverlayView: NSView {

    private var spinner: NSProgressIndicator!
    private var messageLabel: NSTextField!

    public var message: String = "Loading..." {
        didSet {
            messageLabel?.stringValue = message
        }
    }

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.windowBackgroundColor.withAlphaComponent(0.85).cgColor

        // Spinner
        spinner = NSProgressIndicator()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.style = .spinning
        spinner.controlSize = .regular
        spinner.isIndeterminate = true
        addSubview(spinner)

        // Message label
        messageLabel = NSTextField(labelWithString: message)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = NSFont.systemFont(ofSize: 13, weight: .medium)
        messageLabel.textColor = .secondaryLabelColor
        messageLabel.alignment = .center
        addSubview(messageLabel)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12),

            messageLabel.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 12),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -40),
        ])
    }

    public func startAnimating() {
        spinner.startAnimation(nil)
    }

    public func stopAnimating() {
        spinner.stopAnimation(nil)
    }
}

// MARK: - SequenceViewerView

/// The main view for rendering sequence and track data.
public class SequenceViewerView: NSView {

    /// Reference to the parent controller
    weak var viewController: ViewerViewController?

    /// The sequence being displayed
    private(set) var sequence: Sequence?

    /// Annotations to overlay
    private var annotations: [SequenceAnnotation] = []

    /// Whether drag is active (for highlighting)
    private var isDragActive = false

    /// Track positioning (shared with header)
    var trackY: CGFloat = 8
    var trackHeight: CGFloat = 24

    /// Whether to show complement strand
    var showComplementStrand: Bool = false

    // MARK: - Zoom Thresholds (bp/pixel)

    /// Below this threshold: show individual base letters
    private let showLettersThreshold: Double = 10.0

    /// Below this threshold: show colored bars (between letters and density)
    private let showBarsThreshold: Double = 100.0

    // MARK: - Initialization

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupDragAndDrop()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDragAndDrop()
    }

    private func setupDragAndDrop() {
        // Register for file drops
        logger.info("SequenceViewerView.setupDragAndDrop: Registering for file URL drag type")
        registerForDraggedTypes([.fileURL])
        logger.info("SequenceViewerView.setupDragAndDrop: Registration complete")
    }

    // MARK: - Data Setters

    func setSequence(_ seq: Sequence) {
        logger.info("SequenceViewerView.setSequence: Setting sequence '\(seq.name, privacy: .public)' length=\(seq.length)")
        self.sequence = seq
        logger.info("SequenceViewerView.setSequence: self.sequence is now \(self.sequence == nil ? "nil" : "SET", privacy: .public)")
        setNeedsDisplay(bounds)
        logger.info("SequenceViewerView.setSequence: Requested display refresh, bounds=\(self.bounds.width, privacy: .public)x\(self.bounds.height, privacy: .public)")
    }

    func setAnnotations(_ annots: [SequenceAnnotation]) {
        logger.info("SequenceViewerView.setAnnotations: Setting \(annots.count) annotations")
        self.annotations = annots
        setNeedsDisplay(bounds)
        logger.debug("SequenceViewerView.setAnnotations: Requested display refresh")
    }

    // MARK: - Drawing

    public override var isFlipped: Bool { true }

    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard let context = NSGraphicsContext.current?.cgContext else {
            logger.warning("SequenceViewerView.draw: No graphics context available")
            return
        }

        // Background
        if isDragActive {
            // Highlight when dragging
            context.setFillColor(NSColor.selectedContentBackgroundColor.withAlphaComponent(0.1).cgColor)
        } else {
            context.setFillColor(NSColor.textBackgroundColor.cgColor)
        }
        context.fill(bounds)

        // Draw drag border if active
        if isDragActive {
            context.setStrokeColor(NSColor.selectedContentBackgroundColor.cgColor)
            context.setLineWidth(3)
            context.stroke(bounds.insetBy(dx: 1.5, dy: 1.5))
        }

        // If we have a sequence, render it
        if let seq = sequence, let frame = viewController?.referenceFrame {
            fputs("DEBUG draw: Drawing sequence '\(seq.name)' frame=\(frame.start)-\(frame.end)\n", stderr)
            logger.info("SequenceViewerView.draw: Drawing sequence '\(seq.name, privacy: .public)' in bounds \(self.bounds.width)x\(self.bounds.height)")
            drawSequence(seq, frame: frame, context: context)
        } else {
            // Placeholder message
            let hasSeq = sequence != nil
            let hasFrame = viewController?.referenceFrame != nil
            fputs("DEBUG draw: Placeholder - sequence=\(hasSeq) frame=\(hasFrame)\n", stderr)
            let hasVC = viewController != nil
            logger.info("SequenceViewerView.draw: Drawing placeholder (sequence=\(hasSeq), frame=\(hasFrame), viewController=\(hasVC))")
            drawPlaceholder(context: context)
        }
    }

    private func drawPlaceholder(context: CGContext) {
        let message = "Sequence Viewer\n\nDrop files here or use File > Open"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 16),
            .foregroundColor: NSColor.secondaryLabelColor,
            .paragraphStyle: paragraphStyle,
        ]

        let size = (message as NSString).size(withAttributes: attributes)
        let rect = NSRect(
            x: (bounds.width - size.width) / 2,
            y: (bounds.height - size.height) / 2,
            width: size.width,
            height: size.height
        )

        (message as NSString).draw(in: rect, withAttributes: attributes)
    }

    private func drawSequence(_ seq: Sequence, frame: ReferenceFrame, context: CGContext) {
        let scale = frame.scale  // bp/pixel

        // Decide rendering mode based on zoom level (scale = bp/pixel)
        if scale < showLettersThreshold {
            // High zoom: show individual bases with letters
            drawBaseLevelSequence(seq, frame: frame, context: context)
        } else if scale < showBarsThreshold {
            // Medium zoom: show colored bars without letters
            drawBlockLevelSequence(seq, frame: frame, context: context)
        } else {
            // Low zoom: show GC content / density overview
            drawOverviewSequence(seq, frame: frame, context: context)
        }

        // Draw sequence info header
        drawSequenceInfo(seq, frame: frame, context: context)
    }

    private func drawBaseLevelSequence(_ seq: Sequence, frame: ReferenceFrame, context: CGContext) {
        let startBase = max(0, Int(frame.start))
        let endBase = min(seq.length, Int(frame.end) + 1)

        let visibleBases = frame.end - frame.start
        let pixelsPerBase = bounds.width / CGFloat(max(1, visibleBases))

        // Font sizing based on available space
        let fontSize = min(pixelsPerBase * 0.75, trackHeight * 0.8)
        let showLetters = pixelsPerBase >= 8 && fontSize >= 6
        let font = NSFont.monospacedSystemFont(ofSize: max(6, fontSize), weight: .bold)

        for i in startBase..<endBase {
            let x = CGFloat(i - startBase) * pixelsPerBase
            let baseChar = seq[i]

            // Draw background color using IGV standard colors
            let color = BaseColors.color(for: baseChar)
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: x, y: trackY, width: max(1, pixelsPerBase - 0.5), height: trackHeight))

            // Draw letter if space permits
            if showLetters {
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: NSColor.white,
                ]
                let str = String(baseChar).uppercased()
                let strSize = (str as NSString).size(withAttributes: attributes)
                let strX = x + (pixelsPerBase - strSize.width) / 2
                let strY = trackY + (trackHeight - strSize.height) / 2
                (str as NSString).draw(at: CGPoint(x: strX, y: strY), withAttributes: attributes)
            }
        }
    }

    private func drawBlockLevelSequence(_ seq: Sequence, frame: ReferenceFrame, context: CGContext) {
        let startBase = max(0, Int(frame.start))
        let endBase = min(seq.length, Int(frame.end) + 1)

        let visibleBases = frame.end - frame.start
        let pixelsPerBase = bounds.width / CGFloat(max(1, visibleBases))

        // Aggregate bases into bins for colored bar display
        let basesPerBin = max(1, Int(frame.scale))

        for binStart in stride(from: startBase, to: endBase, by: basesPerBin) {
            let binEnd = min(binStart + basesPerBin, endBase)
            let x = CGFloat(binStart - startBase) * pixelsPerBase
            let width = CGFloat(binEnd - binStart) * pixelsPerBase

            // Find dominant base in this bin
            var counts: [Character: Int] = ["A": 0, "T": 0, "C": 0, "G": 0, "N": 0]
            for i in binStart..<binEnd {
                let base = Character(seq[i].uppercased())
                counts[base, default: 0] += 1
            }
            let dominantBase = counts.max(by: { $0.value < $1.value })?.key ?? "N"
            let color = BaseColors.color(for: dominantBase)

            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: x, y: trackY, width: max(1, width), height: trackHeight))
        }
    }

    private func drawOverviewSequence(_ seq: Sequence, frame: ReferenceFrame, context: CGContext) {
        let startBase = max(0, Int(frame.start))
        let endBase = min(seq.length, Int(frame.end) + 1)

        let visibleBases = frame.end - frame.start
        let pixelsPerBase = bounds.width / CGFloat(max(1, visibleBases))

        // Calculate bin size for density display (2 pixels per bin minimum)
        let binSize = max(1, Int(frame.scale * 2))

        // GC content color gradient
        let lowGCColor = NSColor(calibratedRed: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)
        let highGCColor = NSColor(calibratedRed: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)

        for binStart in stride(from: startBase, to: endBase, by: binSize) {
            let binEnd = min(binStart + binSize, endBase)
            let x = CGFloat(binStart - startBase) * pixelsPerBase
            let width = CGFloat(binEnd - binStart) * pixelsPerBase

            // Calculate GC content for this bin
            var gcCount = 0
            var totalCount = 0
            for i in binStart..<binEnd {
                let base = seq[i].uppercased().first ?? "N"
                if base == "G" || base == "C" {
                    gcCount += 1
                }
                totalCount += 1
            }
            let gcContent = totalCount > 0 ? CGFloat(gcCount) / CGFloat(totalCount) : 0.5

            // Interpolate color based on GC content
            let color = interpolateColor(from: lowGCColor, to: highGCColor, factor: gcContent)
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: x, y: trackY, width: max(1, width), height: trackHeight))
        }

        // Draw GC legend
        drawGCLegend(context: context)
    }

    private func interpolateColor(from: NSColor, to: NSColor, factor: CGFloat) -> NSColor {
        let f = max(0, min(1, factor))
        let fromComponents = from.cgColor.components ?? [0, 0, 0, 1]
        let toComponents = to.cgColor.components ?? [0, 0, 0, 1]

        let r = fromComponents[0] + (toComponents[0] - fromComponents[0]) * f
        let g = fromComponents[1] + (toComponents[1] - fromComponents[1]) * f
        let b = fromComponents[2] + (toComponents[2] - fromComponents[2]) * f

        return NSColor(calibratedRed: r, green: g, blue: b, alpha: 1.0)
    }

    private func drawGCLegend(context: CGContext) {
        let legendWidth: CGFloat = 60
        let legendHeight: CGFloat = 10
        let legendX = bounds.maxX - legendWidth - 8
        let legendY = trackY

        // Draw gradient
        let lowGCColor = NSColor(calibratedRed: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)
        let highGCColor = NSColor(calibratedRed: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)

        for i in 0..<Int(legendWidth) {
            let factor = CGFloat(i) / legendWidth
            let color = interpolateColor(from: lowGCColor, to: highGCColor, factor: factor)
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: legendX + CGFloat(i), y: legendY, width: 1, height: legendHeight))
        }

        // Draw labels
        let labelFont = NSFont.systemFont(ofSize: 8)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: labelFont,
            .foregroundColor: NSColor.secondaryLabelColor
        ]
        ("AT" as NSString).draw(at: CGPoint(x: legendX - 14, y: legendY), withAttributes: attributes)
        ("GC" as NSString).draw(at: CGPoint(x: legendX + legendWidth + 2, y: legendY), withAttributes: attributes)
    }

    private func drawSequenceInfo(_ seq: Sequence, frame: ReferenceFrame, context: CGContext) {
        // Draw info below the sequence track
        let info = "\(seq.name) | \(seq.length.formatted()) bp | \(seq.alphabet)"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 11, weight: .regular),
            .foregroundColor: NSColor.secondaryLabelColor,
        ]
        let infoY = trackY + trackHeight + 8
        (info as NSString).draw(at: CGPoint(x: 4, y: infoY), withAttributes: attributes)
    }

    // MARK: - Drag and Drop

    public override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        logger.info("SequenceViewerView.draggingEntered: Drag entered view")
        let canAccept = canAcceptDrag(sender)
        logger.info("SequenceViewerView.draggingEntered: canAcceptDrag = \(canAccept)")
        if canAccept {
            isDragActive = true
            setNeedsDisplay(bounds)
            return .copy
        }
        return []
    }

    public override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        return canAcceptDrag(sender) ? .copy : []
    }

    public override func draggingExited(_ sender: NSDraggingInfo?) {
        logger.info("SequenceViewerView.draggingExited: Drag exited view")
        isDragActive = false
        setNeedsDisplay(bounds)
    }

    public override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let canAccept = canAcceptDrag(sender)
        logger.info("SequenceViewerView.prepareForDragOperation: Preparing, canAccept = \(canAccept)")
        return canAccept
    }

    public override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        logger.info("SequenceViewerView.performDragOperation: Starting drop operation")
        isDragActive = false

        guard let urls = getURLsFromDrag(sender) else {
            logger.warning("SequenceViewerView.performDragOperation: No URLs from drag")
            return false
        }

        logger.info("SequenceViewerView.performDragOperation: Got \(urls.count) URLs from drag")
        for (index, url) in urls.enumerated() {
            logger.info("SequenceViewerView.performDragOperation: URL[\(index)] = '\(url.path, privacy: .public)'")
        }

        // Filter to supported file types
        let supportedURLs = urls.filter { url in
            let detected = DocumentType.detect(from: url)
            logger.info("SequenceViewerView.performDragOperation: '\(url.lastPathComponent, privacy: .public)' -> type=\(detected?.rawValue ?? "nil", privacy: .public)")
            return detected != nil
        }

        logger.info("SequenceViewerView.performDragOperation: \(supportedURLs.count) supported URLs after filtering")

        guard !supportedURLs.isEmpty else {
            logger.warning("SequenceViewerView.performDragOperation: No supported file types found")
            return false
        }

        // Hand off to view controller
        if let vc = viewController {
            logger.info("SequenceViewerView.performDragOperation: Handing off to viewController.handleFileDrop")
            vc.handleFileDrop(supportedURLs)
        } else {
            logger.error("SequenceViewerView.performDragOperation: viewController is nil!")
            return false
        }
        return true
    }

    public override func concludeDragOperation(_ sender: NSDraggingInfo?) {
        logger.info("SequenceViewerView.concludeDragOperation: Drag operation concluded")
        isDragActive = false
        setNeedsDisplay(bounds)
    }

    private func canAcceptDrag(_ sender: NSDraggingInfo) -> Bool {
        guard let urls = getURLsFromDrag(sender) else {
            logger.debug("SequenceViewerView.canAcceptDrag: No URLs in pasteboard")
            return false
        }
        let hasSupported = urls.contains { DocumentType.detect(from: $0) != nil }
        logger.debug("SequenceViewerView.canAcceptDrag: hasSupported = \(hasSupported)")
        return hasSupported
    }

    private func getURLsFromDrag(_ sender: NSDraggingInfo) -> [URL]? {
        let pasteboard = sender.draggingPasteboard
        let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: [
            .urlReadingFileURLsOnly: true
        ]) as? [URL]
        logger.debug("SequenceViewerView.getURLsFromDrag: Got \(urls?.count ?? 0) URLs from pasteboard")
        return urls
    }

    // MARK: - Keyboard

    public override var acceptsFirstResponder: Bool { true }

    public override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 123: // Left arrow
            viewController?.referenceFrame?.start -= 100
            viewController?.referenceFrame?.end -= 100
            setNeedsDisplay(bounds)
        case 124: // Right arrow
            viewController?.referenceFrame?.start += 100
            viewController?.referenceFrame?.end += 100
            setNeedsDisplay(bounds)
        case 126: // Up arrow
            viewController?.zoomIn()
        case 125: // Down arrow
            viewController?.zoomOut()
        default:
            super.keyDown(with: event)
        }
    }
}

// MARK: - TrackHeaderView

/// View for displaying track labels and controls.
public class TrackHeaderView: NSView {

    private var trackNames: [String] = []

    /// Track positioning (should match viewer)
    var trackY: CGFloat = 8
    var trackHeight: CGFloat = 24

    public override var isFlipped: Bool { true }

    func setTrackNames(_ names: [String]) {
        self.trackNames = names
        setNeedsDisplay(bounds)
    }

    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard let context = NSGraphicsContext.current?.cgContext else { return }

        // Background - use same color as viewer when empty
        if trackNames.isEmpty {
            context.setFillColor(NSColor.textBackgroundColor.cgColor)
        } else {
            context.setFillColor(NSColor.windowBackgroundColor.cgColor)
        }
        context.fill(bounds)

        // Only draw right border when we have tracks
        if !trackNames.isEmpty {
            context.setStrokeColor(NSColor.separatorColor.cgColor)
            context.setLineWidth(1)
            context.move(to: CGPoint(x: bounds.maxX - 0.5, y: 0))
            context.addLine(to: CGPoint(x: bounds.maxX - 0.5, y: bounds.maxY))
            context.strokePath()

            // Track labels - aligned with viewer tracks
            let labelFont = NSFont.systemFont(ofSize: 11, weight: .medium)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: labelFont,
                .foregroundColor: NSColor.labelColor,
            ]

            for (index, label) in trackNames.enumerated() {
                // Calculate Y to center label in track row
                let rowY = trackY + CGFloat(index) * (trackHeight + 40)  // 40px gap between tracks
                let labelSize = (label as NSString).size(withAttributes: attributes)
                let labelY = rowY + (trackHeight - labelSize.height) / 2

                // Truncate long names
                let maxWidth = bounds.width - 16
                let truncatedLabel = truncateLabel(label, maxWidth: maxWidth, attributes: attributes)

                (truncatedLabel as NSString).draw(at: CGPoint(x: 8, y: labelY), withAttributes: attributes)
            }
        }
    }

    private func truncateLabel(_ label: String, maxWidth: CGFloat, attributes: [NSAttributedString.Key: Any]) -> String {
        let size = (label as NSString).size(withAttributes: attributes)
        if size.width <= maxWidth {
            return label
        }

        var truncated = label
        while truncated.count > 3 {
            truncated = String(truncated.dropLast())
            let testLabel = truncated + "..."
            let testSize = (testLabel as NSString).size(withAttributes: attributes)
            if testSize.width <= maxWidth {
                return testLabel
            }
        }
        return "..."
    }
}

// MARK: - CoordinateRulerView

/// View for displaying genomic coordinate ruler.
public class CoordinateRulerView: NSView {

    var referenceFrame: ReferenceFrame?

    public override var isFlipped: Bool { true }

    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard let context = NSGraphicsContext.current?.cgContext else { return }

        // Background
        context.setFillColor(NSColor.windowBackgroundColor.cgColor)
        context.fill(bounds)

        // Bottom border
        context.setStrokeColor(NSColor.separatorColor.cgColor)
        context.setLineWidth(1)
        context.move(to: CGPoint(x: 0, y: bounds.maxY - 0.5))
        context.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY - 0.5))
        context.strokePath()

        // Draw ruler with coordinates
        if let frame = referenceFrame {
            drawRuler(frame: frame, context: context)
        } else {
            drawPlaceholderRuler(context: context)
        }
    }

    private func drawRuler(frame: ReferenceFrame, context: CGContext) {
        let visibleRange = frame.end - frame.start
        guard visibleRange > 0 else { return }

        let pixelsPerBase = bounds.width / CGFloat(visibleRange)

        // Calculate tick interval based on zoom
        let tickInterval: Double
        if visibleRange < 100 {
            tickInterval = 10
        } else if visibleRange < 1000 {
            tickInterval = 100
        } else if visibleRange < 10000 {
            tickInterval = 1000
        } else {
            tickInterval = 10000
        }

        let font = NSFont.monospacedSystemFont(ofSize: 10, weight: .regular)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: NSColor.secondaryLabelColor,
        ]

        context.setStrokeColor(NSColor.tertiaryLabelColor.cgColor)

        var pos = (frame.start / tickInterval).rounded(.up) * tickInterval
        while pos < frame.end {
            let x = CGFloat((pos - frame.start) * Double(pixelsPerBase))

            // Draw tick
            context.move(to: CGPoint(x: x, y: bounds.maxY - 6))
            context.addLine(to: CGPoint(x: x, y: bounds.maxY))
            context.strokePath()

            // Draw label
            let label = formatPosition(Int(pos))
            let labelSize = (label as NSString).size(withAttributes: attributes)
            if x - labelSize.width / 2 > 0 && x + labelSize.width / 2 < bounds.width {
                (label as NSString).draw(at: CGPoint(x: x - labelSize.width / 2, y: 6), withAttributes: attributes)
            }

            pos += tickInterval
        }
    }

    private func drawPlaceholderRuler(context: CGContext) {
        let tickInterval: CGFloat = 100
        context.setStrokeColor(NSColor.tertiaryLabelColor.cgColor)

        for x in stride(from: CGFloat(0), to: bounds.width, by: tickInterval) {
            context.move(to: CGPoint(x: x, y: bounds.maxY - 6))
            context.addLine(to: CGPoint(x: x, y: bounds.maxY))
            context.strokePath()
        }
    }

    private func formatPosition(_ pos: Int) -> String {
        if pos >= 1_000_000 {
            return String(format: "%.1fM", Double(pos) / 1_000_000)
        } else if pos >= 1_000 {
            return String(format: "%.1fK", Double(pos) / 1_000)
        } else {
            return "\(pos)"
        }
    }
}

// MARK: - ViewerStatusBar

/// Status bar showing current position and selection info.
public class ViewerStatusBar: NSView {

    private var positionLabel: NSTextField!
    private var selectionLabel: NSTextField!
    private var scaleLabel: NSTextField!

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        wantsLayer = true

        positionLabel = createLabel()
        positionLabel.stringValue = "No sequence loaded"
        addSubview(positionLabel)

        selectionLabel = createLabel()
        selectionLabel.stringValue = ""
        addSubview(selectionLabel)

        scaleLabel = createLabel()
        scaleLabel.stringValue = ""
        scaleLabel.alignment = .right
        addSubview(scaleLabel)

        NSLayoutConstraint.activate([
            positionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            positionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            positionLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300),

            selectionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            selectionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            scaleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            scaleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            scaleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
        ])

        // Accessibility
        positionLabel.setAccessibilityIdentifier("position-label")
        selectionLabel.setAccessibilityIdentifier("selection-label")
        scaleLabel.setAccessibilityIdentifier("scale-label")
    }

    private func createLabel() -> NSTextField {
        let label = NSTextField(labelWithString: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = NSFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .secondaryLabelColor
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }

    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard let context = NSGraphicsContext.current?.cgContext else { return }

        // Background
        context.setFillColor(NSColor.windowBackgroundColor.cgColor)
        context.fill(bounds)

        // Top border
        context.setStrokeColor(NSColor.separatorColor.cgColor)
        context.setLineWidth(1)
        context.move(to: CGPoint(x: 0, y: 0.5))
        context.addLine(to: CGPoint(x: bounds.maxX, y: 0.5))
        context.strokePath()
    }

    public func update(position: String?, selection: String?, scale: Double) {
        positionLabel.stringValue = position ?? "No sequence loaded"
        selectionLabel.stringValue = selection ?? ""
        scaleLabel.stringValue = String(format: "%.1f bp/px", scale)
    }
}

// MARK: - ReferenceFrame

/// Coordinate system for genomic visualization (following IGV pattern).
public class ReferenceFrame {
    /// Chromosome/sequence name
    public var chromosome: String

    /// Start position in base pairs
    public var start: Double

    /// End position in base pairs
    public var end: Double

    /// Width of the view in pixels
    public var pixelWidth: Int

    /// Base pairs per pixel
    public var scale: Double {
        (end - start) / Double(max(1, pixelWidth))
    }

    public init(chromosome: String, start: Double, end: Double, pixelWidth: Int) {
        self.chromosome = chromosome
        self.start = start
        self.end = end
        self.pixelWidth = max(1, pixelWidth)
    }

    /// Converts a screen X coordinate to genomic position
    public func genomicPosition(for screenX: CGFloat) -> Double {
        start + Double(screenX) * scale
    }

    /// Converts a genomic position to screen X coordinate
    public func screenPosition(for genomicPos: Double) -> CGFloat {
        CGFloat((genomicPos - start) / scale)
    }

    /// Zooms in by the specified factor
    public func zoomIn(factor: Double) {
        let center = (start + end) / 2
        let halfWidth = (end - start) / (2 * factor)
        start = max(0, center - halfWidth)
        end = center + halfWidth
    }

    /// Zooms out by the specified factor
    public func zoomOut(factor: Double) {
        let center = (start + end) / 2
        let halfWidth = (end - start) * factor / 2
        start = max(0, center - halfWidth)
        end = center + halfWidth
    }
}
