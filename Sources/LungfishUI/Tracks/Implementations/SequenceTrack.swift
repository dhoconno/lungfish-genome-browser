// SequenceTrack.swift - Reference sequence track with multi-level rendering
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Owner: Sequence Viewer Specialist (Role 03)
// Reference: IGV's SequenceTrack.java

import Foundation
import AppKit
import LungfishCore

/// Track for displaying reference sequence data with zoom-dependent rendering.
///
/// Implements three rendering levels based on zoom:
/// - **High zoom** (< 10 bp/pixel): Individual base letters with colored backgrounds
/// - **Medium zoom** (10-100 bp/pixel): Colored bars without letters
/// - **Low zoom** (> 100 bp/pixel): GC content / nucleotide density visualization
///
/// Base colors follow IGV convention:
/// - A = Green (#00CC00)
/// - T = Red (#CC0000)
/// - C = Blue (#0000CC)
/// - G = Orange/Yellow (#FFB300)
/// - N = Gray (#888888)
@MainActor
public final class SequenceTrack: Track {

    // MARK: - Track Identity

    public let id: UUID
    public var name: String
    public var height: CGFloat
    public var isVisible: Bool = true
    public var displayMode: DisplayMode = .expanded
    public var isSelected: Bool = false
    public var order: Int = 0

    // MARK: - Data Source

    public var dataSource: (any TrackDataSource)?

    /// The sequence being displayed
    private var sequence: Sequence?

    /// Cached sequence string for current view
    private var cachedSequence: String?
    private var cachedRange: Range<Int>?

    /// Tile cache for pre-rendered sequence tiles
    private let tileCache: TileCache<SequenceTileContent>

    // MARK: - Rendering Configuration

    /// Zoom thresholds for rendering mode transitions (bp/pixel)
    public struct ZoomThresholds {
        /// Below this: show individual base letters
        public var showLetters: Double = 10.0
        /// Below this: show colored bars (between showLetters and showDensity)
        public var showBars: Double = 100.0
        /// Above showBars: show GC content / density visualization
    }

    /// Current zoom thresholds
    public var zoomThresholds = ZoomThresholds()

    /// Whether to show the complement strand
    public var showComplementStrand: Bool = false

    /// Whether to show strand direction labels (5'->3', 3'->5')
    public var showStrandLabels: Bool = true

    /// Whether to show translation frames
    public var showTranslation: Bool = false

    /// Which translation frames to show (1, 2, 3, -1, -2, -3)
    public var translationFrames: [Int] = [1, 2, 3]

    // MARK: - Base Colors (IGV Standard)

    /// Colors for DNA bases following IGV convention
    public static let baseColors: [Character: NSColor] = [
        "A": NSColor(calibratedRed: 0.0, green: 0.8, blue: 0.0, alpha: 1.0),    // Green #00CC00
        "C": NSColor(calibratedRed: 0.0, green: 0.0, blue: 0.8, alpha: 1.0),    // Blue #0000CC
        "G": NSColor(calibratedRed: 1.0, green: 0.7, blue: 0.0, alpha: 1.0),    // Orange/Yellow #FFB300
        "T": NSColor(calibratedRed: 0.8, green: 0.0, blue: 0.0, alpha: 1.0),    // Red #CC0000
        "U": NSColor(calibratedRed: 0.8, green: 0.0, blue: 0.0, alpha: 1.0),    // Red (RNA)
        "N": NSColor(calibratedRed: 0.53, green: 0.53, blue: 0.53, alpha: 1.0), // Gray #888888
    ]

    /// Precise hex colors for IGV compatibility
    public static let baseColorsHex: [Character: String] = [
        "A": "#00CC00",
        "C": "#0000CC",
        "G": "#FFB300",
        "T": "#CC0000",
        "U": "#CC0000",
        "N": "#888888",
    ]

    /// Default color for unknown bases
    public static let unknownColor = NSColor(calibratedRed: 0.53, green: 0.53, blue: 0.53, alpha: 1.0)

    /// GC content color gradient (low GC = blue, high GC = red)
    public static let gcLowColor = NSColor(calibratedRed: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)
    public static let gcHighColor = NSColor(calibratedRed: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)

    // MARK: - Initialization

    /// Creates a sequence track.
    ///
    /// - Parameters:
    ///   - name: Display name for the track
    ///   - sequence: The sequence to display
    ///   - height: Track height in points
    ///   - cacheCapacity: Number of tiles to cache (default 200)
    public init(
        name: String = "Sequence",
        sequence: Sequence? = nil,
        height: CGFloat = 50,
        cacheCapacity: Int = 200
    ) {
        self.id = UUID()
        self.name = name
        self.sequence = sequence
        self.height = height
        self.tileCache = TileCache(capacity: cacheCapacity)
    }

    /// Sets the sequence to display.
    public func setSequence(_ sequence: Sequence) {
        self.sequence = sequence
        self.cachedSequence = nil
        self.cachedRange = nil
        // Clear cache when sequence changes
        Task {
            await tileCache.clear()
        }
    }

    /// Returns the current sequence.
    public var currentSequence: Sequence? {
        sequence
    }

    // MARK: - Track Protocol

    public func isReady(for frame: ReferenceFrame) -> Bool {
        guard let seq = sequence else { return false }

        // Check if we have cached data for this range
        let start = Int(max(0, frame.origin))
        let end = Int(min(Double(seq.length), frame.end))

        if let cached = cachedRange, cached == start..<end {
            return true
        }

        return false
    }

    public func load(for frame: ReferenceFrame) async throws {
        guard let seq = sequence else { return }

        let start = Int(max(0, frame.origin))
        let end = Int(min(Double(seq.length), frame.end))
        let range = start..<end

        // Extract subsequence for the visible range
        cachedSequence = seq[range]
        cachedRange = range

        // Prefetch tiles for smooth scrolling
        await prefetchTiles(for: frame)
    }

    public func render(context: RenderContext, rect: CGRect) {
        let frame = context.frame

        // Background
        context.fill(rect, with: .textBackgroundColor)

        guard let seq = sequence else {
            drawPlaceholder(context: context, rect: rect, message: "No sequence loaded")
            return
        }

        // Determine rendering mode based on scale (bp/pixel)
        let scale = frame.scale

        if scale < zoomThresholds.showLetters {
            // High zoom: show individual base letters
            renderBasesWithLetters(context: context, rect: rect, sequence: seq)
        } else if scale < zoomThresholds.showBars {
            // Medium zoom: show colored bars without letters
            renderColoredBars(context: context, rect: rect, sequence: seq)
        } else {
            // Low zoom: show GC content / density visualization
            renderDensityVisualization(context: context, rect: rect, sequence: seq)
        }

        // Draw strand labels if enabled
        if showStrandLabels {
            drawStrandLabels(context: context, rect: rect)
        }

        // Draw track label
        drawTrackLabel(context: context, rect: rect)
    }

    // MARK: - High Zoom Rendering (< 10 bp/pixel)

    private func renderBasesWithLetters(context: RenderContext, rect: CGRect, sequence: Sequence) {
        let frame = context.frame
        let graphics = context.graphics

        let startBP = Int(max(0, frame.origin))
        let endBP = Int(min(Double(sequence.length), frame.end))

        // Calculate base width in pixels
        let baseWidth = 1.0 / frame.scale

        // Only render if bases are reasonably visible
        guard baseWidth >= 1 else {
            renderColoredBars(context: context, rect: rect, sequence: sequence)
            return
        }

        // Get sequence for visible range
        let subseq = cachedSequence ?? sequence[startBP..<endBP]

        // Calculate rendering area for forward strand
        let forwardY = showComplementStrand ? rect.minY + 2 : rect.minY + 2
        let strandHeight = showComplementStrand ? (rect.height - 4) / 2 - 2 : rect.height - 4

        // Font sizing based on available space
        let fontSize = min(baseWidth * 0.75, strandHeight * 0.8)
        let showLetters = baseWidth >= 8 && fontSize >= 6
        let font = NSFont.monospacedSystemFont(ofSize: max(6, fontSize), weight: .bold)

        // Draw forward strand (5' -> 3')
        for (index, char) in subseq.uppercased().enumerated() {
            let genomicPos = startBP + index
            let x = frame.screenPosition(for: Double(genomicPos))
            let color = Self.baseColors[char] ?? Self.unknownColor

            // Draw colored rectangle
            let baseRect = CGRect(
                x: x,
                y: forwardY,
                width: max(1, baseWidth - 0.5),
                height: strandHeight
            )
            graphics.setFillColor(color.cgColor)
            graphics.fill(baseRect)

            // Draw letter if space permits
            if showLetters {
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: NSColor.white
                ]
                let str = String(char)
                let size = str.size(withAttributes: attributes)
                let textX = x + (baseWidth - size.width) / 2
                let textY = forwardY + (strandHeight - size.height) / 2
                str.draw(at: CGPoint(x: textX, y: textY), withAttributes: attributes)
            }
        }

        // Draw complement strand if enabled (3' -> 5')
        if showComplementStrand {
            let complementY = forwardY + strandHeight + 4
            drawComplementStrand(
                context: context,
                sequence: subseq,
                startBP: startBP,
                baseWidth: baseWidth,
                y: complementY,
                height: strandHeight,
                showLetters: showLetters,
                font: font
            )
        }
    }

    private func drawComplementStrand(
        context: RenderContext,
        sequence: String,
        startBP: Int,
        baseWidth: CGFloat,
        y: CGFloat,
        height: CGFloat,
        showLetters: Bool,
        font: NSFont
    ) {
        let frame = context.frame
        let graphics = context.graphics

        for (index, char) in sequence.uppercased().enumerated() {
            let genomicPos = startBP + index
            let x = frame.screenPosition(for: Double(genomicPos))
            let complement = complementBase(char)
            let color = Self.baseColors[complement] ?? Self.unknownColor

            // Draw colored rectangle
            let baseRect = CGRect(
                x: x,
                y: y,
                width: max(1, baseWidth - 0.5),
                height: height
            )
            graphics.setFillColor(color.cgColor)
            graphics.fill(baseRect)

            // Draw letter if space permits
            if showLetters {
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: NSColor.white
                ]
                let str = String(complement)
                let size = str.size(withAttributes: attributes)
                let textX = x + (baseWidth - size.width) / 2
                let textY = y + (height - size.height) / 2
                str.draw(at: CGPoint(x: textX, y: textY), withAttributes: attributes)
            }
        }
    }

    // MARK: - Medium Zoom Rendering (10-100 bp/pixel)

    private func renderColoredBars(context: RenderContext, rect: CGRect, sequence: Sequence) {
        let frame = context.frame
        let graphics = context.graphics

        let startBP = Int(max(0, frame.origin))
        let endBP = Int(min(Double(sequence.length), frame.end))

        // Calculate bar width (1 pixel per bar minimum, aggregate bases as needed)
        let barsPerPixel = max(1, Int(frame.scale))
        let barWidth: CGFloat = 1.0 / frame.scale * CGFloat(barsPerPixel)

        // Rendering area
        let forwardY = showComplementStrand ? rect.minY + 2 : rect.minY + 2
        let strandHeight = showComplementStrand ? (rect.height - 4) / 2 - 2 : rect.height - 4

        var x = frame.screenPosition(for: Double(startBP))

        for binStart in stride(from: startBP, to: endBP, by: barsPerPixel) {
            let binEnd = min(binStart + barsPerPixel, endBP)
            let subseq = sequence[binStart..<binEnd]

            // Find dominant base in this bin
            let dominantBase = findDominantBase(in: subseq)
            let color = Self.baseColors[dominantBase] ?? Self.unknownColor

            let actualBarWidth = frame.screenPosition(for: Double(binEnd)) - x

            // Draw forward strand bar
            let barRect = CGRect(x: x, y: forwardY, width: max(1, actualBarWidth), height: strandHeight)
            graphics.setFillColor(color.cgColor)
            graphics.fill(barRect)

            // Draw complement strand if enabled
            if showComplementStrand {
                let complementY = forwardY + strandHeight + 4
                let complementBase = self.complementBase(dominantBase)
                let complementColor = Self.baseColors[complementBase] ?? Self.unknownColor
                let complementRect = CGRect(x: x, y: complementY, width: max(1, actualBarWidth), height: strandHeight)
                graphics.setFillColor(complementColor.cgColor)
                graphics.fill(complementRect)
            }

            x += actualBarWidth
        }
    }

    private func findDominantBase(in sequence: String) -> Character {
        var counts: [Character: Int] = ["A": 0, "C": 0, "G": 0, "T": 0, "N": 0]
        for char in sequence.uppercased() {
            counts[char, default: 0] += 1
        }
        return counts.max(by: { $0.value < $1.value })?.key ?? "N"
    }

    // MARK: - Low Zoom Rendering (> 100 bp/pixel)

    private func renderDensityVisualization(context: RenderContext, rect: CGRect, sequence: Sequence) {
        let frame = context.frame
        let graphics = context.graphics

        let startBP = Int(max(0, frame.origin))
        let endBP = Int(min(Double(sequence.length), frame.end))

        // Calculate bin size for density calculation (2 pixels per bin minimum)
        let binSize = max(1, Int(frame.scale * 2))
        guard binSize > 0 else { return }

        // Track area
        let trackY = rect.minY + 4
        let trackHeight = rect.height - 8

        var x = frame.screenPosition(for: Double(startBP))

        for binStart in stride(from: startBP, to: endBP, by: binSize) {
            let binEnd = min(binStart + binSize, endBP)
            let subseq = sequence[binStart..<binEnd]

            // Calculate GC content
            let gcContent = calculateGCContent(subseq)

            // Interpolate color based on GC content
            let color = interpolateColor(from: Self.gcLowColor, to: Self.gcHighColor, factor: gcContent)

            let barWidth = frame.screenPosition(for: Double(binEnd)) - x

            // Draw density bar with height proportional to sequence coverage
            let barRect = CGRect(x: x, y: trackY, width: max(1, barWidth), height: trackHeight)
            graphics.setFillColor(color.cgColor)
            graphics.fill(barRect)

            // Draw composition stacked bars
            drawCompositionBars(
                graphics: graphics,
                subseq: subseq,
                x: x,
                width: barWidth,
                y: trackY,
                height: trackHeight
            )

            x += barWidth
        }

        // Draw GC content legend
        drawGCLegend(context: context, rect: rect)
    }

    private func calculateGCContent(_ sequence: String) -> CGFloat {
        guard !sequence.isEmpty else { return 0.5 }
        let gcCount = sequence.uppercased().filter { $0 == "G" || $0 == "C" }.count
        return CGFloat(gcCount) / CGFloat(sequence.count)
    }

    private func drawCompositionBars(
        graphics: CGContext,
        subseq: String,
        x: CGFloat,
        width: CGFloat,
        y: CGFloat,
        height: CGFloat
    ) {
        guard !subseq.isEmpty else { return }

        // Count base composition
        var counts: [Character: Int] = ["A": 0, "C": 0, "G": 0, "T": 0]
        for char in subseq.uppercased() {
            counts[char, default: 0] += 1
        }

        let total = CGFloat(subseq.count)
        var currentY = y

        // Draw stacked bars in A, C, G, T order
        for base in ["A", "C", "G", "T"] as [Character] {
            let count = counts[base] ?? 0
            let proportion = CGFloat(count) / total
            let barHeight = height * proportion

            if barHeight > 0.5 {
                let color = Self.baseColors[base] ?? Self.unknownColor
                graphics.setFillColor(color.cgColor)
                graphics.fill(CGRect(x: x, y: currentY, width: max(1, width), height: barHeight))
            }

            currentY += barHeight
        }
    }

    private func drawGCLegend(context: RenderContext, rect: CGRect) {
        let legendWidth: CGFloat = 60
        let legendHeight: CGFloat = 10
        let legendX = rect.maxX - legendWidth - 8
        let legendY = rect.minY + 4

        let graphics = context.graphics

        // Draw gradient
        let gradientRect = CGRect(x: legendX, y: legendY, width: legendWidth, height: legendHeight)
        for i in 0..<Int(legendWidth) {
            let factor = CGFloat(i) / legendWidth
            let color = interpolateColor(from: Self.gcLowColor, to: Self.gcHighColor, factor: factor)
            graphics.setFillColor(color.cgColor)
            graphics.fill(CGRect(x: legendX + CGFloat(i), y: legendY, width: 1, height: legendHeight))
        }

        // Draw labels
        let labelFont = NSFont.systemFont(ofSize: 8)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: labelFont,
            .foregroundColor: NSColor.secondaryLabelColor
        ]
        "AT".draw(at: CGPoint(x: legendX - 14, y: legendY), withAttributes: attributes)
        "GC".draw(at: CGPoint(x: legendX + legendWidth + 2, y: legendY), withAttributes: attributes)
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

    // MARK: - Strand Labels

    private func drawStrandLabels(context: RenderContext, rect: CGRect) {
        let labelFont = NSFont.systemFont(ofSize: 9, weight: .medium)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: labelFont,
            .foregroundColor: NSColor.secondaryLabelColor
        ]

        let forwardLabel = "5'\u{2192}3'"
        let forwardY = showComplementStrand ? rect.minY + 2 : rect.minY + rect.height / 2 - 6

        forwardLabel.draw(at: CGPoint(x: rect.maxX - 40, y: forwardY), withAttributes: attributes)

        if showComplementStrand {
            let complementLabel = "3'\u{2192}5'"
            let complementY = rect.minY + rect.height / 2 + 2
            complementLabel.draw(at: CGPoint(x: rect.maxX - 40, y: complementY), withAttributes: attributes)
        }
    }

    // MARK: - Helper Methods

    private func complementBase(_ base: Character) -> Character {
        switch base {
        case "A", "a": return "T"
        case "T", "t": return "A"
        case "C", "c": return "G"
        case "G", "g": return "C"
        case "U", "u": return "A"
        default: return "N"
        }
    }

    private func drawPlaceholder(context: RenderContext, rect: CGRect, message: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 12),
            .foregroundColor: NSColor.secondaryLabelColor
        ]
        let size = message.size(withAttributes: attributes)
        let x = rect.midX - size.width / 2
        let y = rect.midY - size.height / 2
        message.draw(at: CGPoint(x: x, y: y), withAttributes: attributes)
    }

    private func drawTrackLabel(context: RenderContext, rect: CGRect) {
        let label = name
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 10, weight: .medium),
            .foregroundColor: NSColor.secondaryLabelColor
        ]
        label.draw(at: CGPoint(x: rect.minX + 4, y: rect.minY + 2), withAttributes: attributes)
    }

    // MARK: - Tile Caching

    private func prefetchTiles(for frame: ReferenceFrame) async {
        guard let seq = sequence else { return }

        let visibleTiles = frame.visibleTileIndices()

        // Prefetch one tile on each side for smooth scrolling
        let prefetchStart = max(0, visibleTiles.lowerBound - 1)
        let prefetchEnd = visibleTiles.upperBound + 1

        await tileCache.prefetch(
            trackId: id,
            chromosome: frame.chromosome,
            tileRange: prefetchStart..<prefetchEnd,
            zoom: frame.zoom
        ) { [weak self] key in
            guard let self = self else {
                throw TileCacheError.trackNotFound
            }
            return try await self.generateTile(for: key, sequence: seq, frame: frame)
        }
    }

    private func generateTile(
        for key: TileKey,
        sequence: Sequence,
        frame: ReferenceFrame
    ) async throws -> Tile<SequenceTileContent> {
        let range = frame.rangeForTile(key.tileIndex)
        let clampedRange = max(0, range.lowerBound)..<min(sequence.length, range.upperBound)

        let subseq = sequence[clampedRange]
        let gcContent = calculateGCContent(subseq)

        let content = SequenceTileContent(
            sequence: subseq,
            gcContent: Float(gcContent),
            dominantBase: findDominantBase(in: subseq)
        )

        return Tile(
            key: key,
            startBP: clampedRange.lowerBound,
            endBP: clampedRange.upperBound,
            content: content
        )
    }

    // MARK: - Interaction

    public func tooltipText(at position: Double, y: CGFloat) -> String? {
        guard let seq = sequence else { return nil }

        let pos = Int(position)
        guard pos >= 0 && pos < seq.length else { return nil }

        let base = seq[pos]
        let complement = complementBase(base)

        var tooltip = "\(name)\nPosition: \(pos + 1)\nBase: \(base)"
        if showComplementStrand {
            tooltip += "\nComplement: \(complement)"
        }

        // Calculate local GC content (surrounding 100bp window)
        let windowStart = max(0, pos - 50)
        let windowEnd = min(seq.length, pos + 50)
        let windowSeq = seq[windowStart..<windowEnd]
        let gcContent = calculateGCContent(windowSeq)
        tooltip += String(format: "\nGC Content: %.1f%%", gcContent * 100)

        return tooltip
    }

    public func handleClick(at position: Double, y: CGFloat, modifiers: NSEvent.ModifierFlags) -> Bool {
        // Could implement selection here
        return false
    }

    public func contextMenu(at position: Double, y: CGFloat) -> NSMenu? {
        let menu = NSMenu()

        menu.addItem(withTitle: "Copy Sequence", action: nil, keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())

        let complementItem = NSMenuItem(
            title: showComplementStrand ? "Hide Complement Strand" : "Show Complement Strand",
            action: nil,
            keyEquivalent: ""
        )
        menu.addItem(complementItem)

        let strandLabelsItem = NSMenuItem(
            title: showStrandLabels ? "Hide Strand Labels" : "Show Strand Labels",
            action: nil,
            keyEquivalent: ""
        )
        menu.addItem(strandLabelsItem)

        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Show Translation", action: nil, keyEquivalent: "")

        return menu
    }
}

// MARK: - SequenceTileContent

/// Content stored in a sequence tile cache entry.
public struct SequenceTileContent: Sendable {
    /// The sequence string for this tile
    public let sequence: String

    /// Pre-computed GC content (0.0 - 1.0)
    public let gcContent: Float

    /// The dominant base in this tile
    public let dominantBase: Character
}

// MARK: - TileCacheError

/// Errors that can occur during tile caching.
public enum TileCacheError: Error {
    case trackNotFound
    case sequenceNotLoaded
    case invalidRange
}

// MARK: - Sequence Extension

extension LungfishCore.Sequence {
    /// Returns a base at a specific position.
    func base(at index: Int) -> Character {
        let sub = self[index..<(index + 1)]
        return sub.first ?? "N"
    }
}
