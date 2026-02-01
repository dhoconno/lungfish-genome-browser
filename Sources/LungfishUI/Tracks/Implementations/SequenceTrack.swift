// SequenceTrack.swift - Reference sequence track
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Owner: Track Rendering Engineer (Role 04)

import Foundation
import AppKit
import LungfishCore

/// Track for displaying reference sequence data.
///
/// Renders DNA/RNA bases with color coding:
/// - A: Green
/// - C: Blue
/// - G: Orange/Black
/// - T: Red
/// - N: Gray
///
/// At low zoom levels, shows a density representation.
/// At high zoom levels (< ~10 bp/pixel), shows individual bases.
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

    // MARK: - Configuration

    /// Minimum scale (bp/pixel) to show individual bases
    public var baseDisplayThreshold: Double = 10.0

    /// Whether to show translation frames
    public var showTranslation: Bool = false

    /// Which translation frames to show (1, 2, 3, -1, -2, -3)
    public var translationFrames: [Int] = [1, 2, 3]

    // MARK: - Base Colors

    /// Colors for DNA bases (following IGV convention)
    public static let baseColors: [Character: NSColor] = [
        "A": NSColor(red: 0.0, green: 0.7, blue: 0.0, alpha: 1.0),   // Green
        "C": NSColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0),   // Blue
        "G": NSColor(red: 0.85, green: 0.55, blue: 0.0, alpha: 1.0), // Orange
        "T": NSColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0),   // Red
        "U": NSColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0),   // Red (RNA)
        "N": NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0),   // Gray
    ]

    /// Default color for unknown bases
    public static let unknownColor = NSColor.gray

    // MARK: - Initialization

    /// Creates a sequence track.
    ///
    /// - Parameters:
    ///   - name: Display name for the track
    ///   - sequence: The sequence to display
    ///   - height: Track height in points
    public init(name: String = "Sequence", sequence: Sequence? = nil, height: CGFloat = 50) {
        self.id = UUID()
        self.name = name
        self.sequence = sequence
        self.height = height
    }

    /// Sets the sequence to display.
    public func setSequence(_ sequence: Sequence) {
        self.sequence = sequence
        self.cachedSequence = nil
        self.cachedRange = nil
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
    }

    public func render(context: RenderContext, rect: CGRect) {
        let frame = context.frame

        // Background
        context.fill(rect, with: .textBackgroundColor)

        guard let seq = sequence else {
            drawPlaceholder(context: context, rect: rect, message: "No sequence loaded")
            return
        }

        // Determine rendering mode based on scale
        if frame.scale > baseDisplayThreshold {
            // Low zoom - draw density bars
            renderDensityBars(context: context, rect: rect, sequence: seq)
        } else {
            // High zoom - draw individual bases
            renderBases(context: context, rect: rect, sequence: seq)
        }

        // Draw track label
        drawTrackLabel(context: context, rect: rect)
    }

    // MARK: - Rendering Methods

    private func renderDensityBars(context: RenderContext, rect: CGRect, sequence: Sequence) {
        let frame = context.frame
        let graphics = context.graphics

        // Calculate bin size based on scale
        let binSize = Int(frame.scale * 2) // 2 pixels per bin
        guard binSize > 0 else { return }

        let startBP = Int(max(0, frame.origin))
        let endBP = Int(min(Double(sequence.length), frame.end))

        // Draw colored bars for each bin
        var x = frame.screenPosition(for: Double(startBP))

        for binStart in stride(from: startBP, to: endBP, by: binSize) {
            let binEnd = min(binStart + binSize, endBP)
            let subseq = sequence[binStart..<binEnd]

            // Count base composition
            var counts: [Character: Int] = ["A": 0, "C": 0, "G": 0, "T": 0]
            for char in subseq.uppercased() {
                counts[char, default: 0] += 1
            }

            let total = max(1, subseq.count)
            let barWidth = frame.screenPosition(for: Double(binEnd)) - x

            // Stack bars proportionally
            var y = rect.minY
            for (base, count) in counts.sorted(by: { $0.key < $1.key }) {
                let proportion = CGFloat(count) / CGFloat(total)
                let barHeight = rect.height * proportion

                if barHeight > 0.5 {
                    let color = Self.baseColors[base] ?? Self.unknownColor
                    graphics.setFillColor(color.cgColor)
                    graphics.fill(CGRect(x: x, y: y, width: barWidth, height: barHeight))
                }

                y += barHeight
            }

            x += barWidth
        }
    }

    private func renderBases(context: RenderContext, rect: CGRect, sequence: Sequence) {
        let frame = context.frame
        let graphics = context.graphics

        let startBP = Int(max(0, frame.origin))
        let endBP = Int(min(Double(sequence.length), frame.end))

        // Calculate base width in pixels
        let baseWidth = 1.0 / frame.scale

        // Only draw if bases are visible
        guard baseWidth >= 1 else {
            renderDensityBars(context: context, rect: rect, sequence: sequence)
            return
        }

        // Get sequence for visible range
        let subseq = cachedSequence ?? sequence[startBP..<endBP]

        // Font for base letters
        let fontSize = min(baseWidth * 0.8, rect.height * 0.7)
        let font = NSFont.monospacedSystemFont(ofSize: fontSize, weight: .medium)
        let showLetters = baseWidth >= 8 // Only show letters if wide enough

        for (index, char) in subseq.uppercased().enumerated() {
            let genomicPos = startBP + index
            let x = frame.screenPosition(for: Double(genomicPos))
            let color = Self.baseColors[char] ?? Self.unknownColor

            // Draw colored rectangle
            let baseRect = CGRect(x: x, y: rect.minY + 2, width: baseWidth - 1, height: rect.height - 4)
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
                let textY = rect.minY + (rect.height - size.height) / 2
                str.draw(at: CGPoint(x: textX, y: textY), withAttributes: attributes)
            }
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

    // MARK: - Interaction

    public func tooltipText(at position: Double, y: CGFloat) -> String? {
        guard let seq = sequence else { return nil }

        let pos = Int(position)
        guard pos >= 0 && pos < seq.length else { return nil }

        let base = seq.base(at: pos)
        return "\(name)\nPosition: \(pos + 1)\nBase: \(base)"
    }

    public func handleClick(at position: Double, y: CGFloat, modifiers: NSEvent.ModifierFlags) -> Bool {
        // Could implement selection here
        return false
    }

    public func contextMenu(at position: Double, y: CGFloat) -> NSMenu? {
        let menu = NSMenu()
        menu.addItem(withTitle: "Copy Sequence", action: nil, keyEquivalent: "")
        menu.addItem(withTitle: "Show Translation", action: nil, keyEquivalent: "")
        return menu
    }
}

// MARK: - Sequence Extension

extension LungfishCore.Sequence {
    /// Returns a base at a specific position.
    func base(at index: Int) -> Character {
        let sub = self[index..<(index + 1)]
        return sub.first ?? "N"
    }
}
