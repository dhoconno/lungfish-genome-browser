// ReadTrackRenderer.swift - Renders aligned reads at three zoom tiers
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import LungfishCore

// MARK: - ReadTrackRenderer

/// Renders aligned sequencing reads at three zoom-dependent tiers.
///
/// ## Zoom Tiers
///
/// | Tier | Scale (bp/px) | Rendering |
/// |------|---------------|-----------|
/// | Coverage | > 10 | Forward/reverse stacked area chart |
/// | Packed | 0.5 - 10 | Colored bars with strand indicators |
/// | Base | < 0.5 | Geneious-style dots for matches, letters for mismatches |
///
/// ## Design Notes
///
/// Follows the `VariantTrackRenderer` pattern: a `@MainActor` enum with static
/// methods for testability and reuse. The renderer does not maintain state;
/// all data is passed as parameters.
@MainActor
public enum ReadTrackRenderer {

    // MARK: - Layout Constants

    /// Height of a single read in packed mode.
    static let packedReadHeight: CGFloat = 6

    /// Height of a single read in base mode.
    static let baseReadHeight: CGFloat = 14

    /// Vertical gap between read rows.
    static let rowGap: CGFloat = 1

    /// Height of the coverage track.
    static let coverageTrackHeight: CGFloat = 60

    /// Maximum number of read rows to render.
    static let maxReadRows: Int = 75

    /// Minimum pixels per read to render individually.
    static let minReadPixels: CGFloat = 2

    /// Zoom tier thresholds.
    static let coverageThresholdBpPerPx: Double = 10
    static let baseThresholdBpPerPx: Double = 0.5

    // MARK: - Colors

    /// Forward read fill color.
    static let forwardReadColor = NSColor(red: 0.69, green: 0.77, blue: 0.87, alpha: 1.0).cgColor
    /// Forward read stroke color.
    static let forwardReadStroke = NSColor(red: 0.55, green: 0.65, blue: 0.77, alpha: 1.0).cgColor
    /// Reverse read fill color.
    static let reverseReadColor = NSColor(red: 0.87, green: 0.69, blue: 0.69, alpha: 1.0).cgColor
    /// Reverse read stroke color.
    static let reverseReadStroke = NSColor(red: 0.77, green: 0.55, blue: 0.55, alpha: 1.0).cgColor

    /// Forward coverage area fill.
    static let forwardCoverageColor = NSColor(red: 0.42, green: 0.60, blue: 0.77, alpha: 0.7).cgColor
    /// Reverse coverage area fill.
    static let reverseCoverageColor = NSColor(red: 0.77, green: 0.42, blue: 0.42, alpha: 0.7).cgColor

    /// Base colors for mismatches (matches BaseColors used in sequence track).
    static let baseA = NSColor(red: 0, green: 0.8, blue: 0, alpha: 1.0).cgColor
    static let baseT = NSColor(red: 0.8, green: 0, blue: 0, alpha: 1.0).cgColor
    static let baseC = NSColor(red: 0, green: 0, blue: 0.8, alpha: 1.0).cgColor
    static let baseG = NSColor(red: 1.0, green: 0.7, blue: 0, alpha: 1.0).cgColor
    static let baseN = NSColor.gray.cgColor
    /// Match dot color.
    static let matchDotColor = NSColor(white: 0.67, alpha: 0.6).cgColor
    /// Insertion indicator color (magenta).
    static let insertionColor = NSColor(red: 0.8, green: 0, blue: 0.8, alpha: 1.0).cgColor
    /// Deletion line color.
    static let deletionColor = NSColor.gray.cgColor

    // MARK: - Zoom Tier Detection

    /// Returns the appropriate zoom tier for the current scale.
    public static func zoomTier(scale: Double) -> ZoomTier {
        if scale > coverageThresholdBpPerPx {
            return .coverage
        } else if scale > baseThresholdBpPerPx {
            return .packed
        } else {
            return .base
        }
    }

    /// Zoom tier for read rendering.
    public enum ZoomTier {
        case coverage
        case packed
        case base
    }

    // MARK: - Coverage Rendering (Tier 1)

    /// Draws a forward/reverse stacked coverage area chart.
    ///
    /// - Parameters:
    ///   - reads: All reads in the visible region
    ///   - frame: Current reference frame for coordinate mapping
    ///   - context: CoreGraphics context to draw into
    ///   - rect: Drawing rectangle for the coverage track
    public static func drawCoverage(
        reads: [AlignedRead],
        frame: ReferenceFrame,
        context: CGContext,
        rect: CGRect
    ) {
        let pixelWidth = Int(rect.width)
        guard pixelWidth > 0 else { return }

        // Bin reads by pixel column
        var forwardBins = [Int](repeating: 0, count: pixelWidth)
        var reverseBins = [Int](repeating: 0, count: pixelWidth)

        for read in reads {
            let startPx = max(0, Int(frame.genomicToPixel(Double(read.position)) - rect.minX))
            let endPx = min(pixelWidth - 1, Int(frame.genomicToPixel(Double(read.alignmentEnd)) - rect.minX))
            guard startPx <= endPx else { continue }

            if read.isReverse {
                for i in startPx...endPx { reverseBins[i] += 1 }
            } else {
                for i in startPx...endPx { forwardBins[i] += 1 }
            }
        }

        // Find max coverage for Y-axis scaling
        let maxCoverage = max(1, (0..<pixelWidth).map { forwardBins[$0] + reverseBins[$0] }.max() ?? 1)
        let yScale = (rect.height - 16) / CGFloat(maxCoverage) // Leave room for label

        // Draw forward coverage (bottom up)
        context.saveGState()
        context.setFillColor(forwardCoverageColor)
        let forwardPath = CGMutablePath()
        forwardPath.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        for px in 0..<pixelWidth {
            let h = CGFloat(forwardBins[px]) * yScale
            forwardPath.addLine(to: CGPoint(x: rect.minX + CGFloat(px), y: rect.maxY - h))
        }
        forwardPath.addLine(to: CGPoint(x: rect.minX + CGFloat(pixelWidth - 1), y: rect.maxY))
        forwardPath.closeSubpath()
        context.addPath(forwardPath)
        context.fillPath()

        // Draw reverse coverage (stacked on top of forward)
        context.setFillColor(reverseCoverageColor)
        let reversePath = CGMutablePath()
        reversePath.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        for px in 0..<pixelWidth {
            let fwdH = CGFloat(forwardBins[px]) * yScale
            let revH = CGFloat(reverseBins[px]) * yScale
            reversePath.addLine(to: CGPoint(x: rect.minX + CGFloat(px), y: rect.maxY - fwdH - revH))
        }
        // Go back along forward line
        for px in stride(from: pixelWidth - 1, through: 0, by: -1) {
            let fwdH = CGFloat(forwardBins[px]) * yScale
            reversePath.addLine(to: CGPoint(x: rect.minX + CGFloat(px), y: rect.maxY - fwdH))
        }
        reversePath.closeSubpath()
        context.addPath(reversePath)
        context.fillPath()

        // Draw coverage outline
        context.setStrokeColor(NSColor(white: 0.33, alpha: 1).cgColor)
        context.setLineWidth(0.5)
        let outlinePath = CGMutablePath()
        outlinePath.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        for px in 0..<pixelWidth {
            let totalH = CGFloat(forwardBins[px] + reverseBins[px]) * yScale
            outlinePath.addLine(to: CGPoint(x: rect.minX + CGFloat(px), y: rect.maxY - totalH))
        }
        context.addPath(outlinePath)
        context.strokePath()

        // Max coverage label
        if maxCoverage > 0 {
            let label = "max: \(maxCoverage)x" as NSString
            let attrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.monospacedDigitSystemFont(ofSize: 9, weight: .regular),
                .foregroundColor: NSColor.secondaryLabelColor
            ]
            let size = label.size(withAttributes: attrs)
            label.draw(at: CGPoint(x: rect.maxX - size.width - 4, y: rect.minY + 2), withAttributes: attrs)
        }

        context.restoreGState()
    }

    // MARK: - Packed Read Rendering (Tier 2)

    /// Packs reads into non-overlapping rows using greedy first-fit algorithm.
    ///
    /// - Parameters:
    ///   - reads: Reads to pack
    ///   - frame: Reference frame for coordinate mapping
    ///   - maxRows: Maximum number of rows
    /// - Returns: Array of (row, read) pairs and the overflow count
    public static func packReads(
        _ reads: [AlignedRead],
        frame: ReferenceFrame,
        maxRows: Int = 75
    ) -> (packed: [(row: Int, read: AlignedRead)], overflow: Int) {
        // Sort by start position
        let sorted = reads.sorted { $0.position < $1.position }

        var rowEndPixels = [CGFloat](repeating: -1, count: maxRows)
        var packed: [(Int, AlignedRead)] = []
        var overflow = 0

        for read in sorted {
            let startPx = frame.genomicToPixel(Double(read.position))
            let endPx = frame.genomicToPixel(Double(read.alignmentEnd))
            guard endPx - startPx >= minReadPixels else { continue }

            // Find first available row
            var placed = false
            for row in 0..<maxRows {
                if startPx >= rowEndPixels[row] + 2 { // 2px gap
                    packed.append((row, read))
                    rowEndPixels[row] = endPx
                    placed = true
                    break
                }
            }
            if !placed {
                overflow += 1
            }
        }

        return (packed, overflow)
    }

    /// Draws packed reads as colored bars with strand indicators.
    ///
    /// - Parameters:
    ///   - packedReads: Pre-packed reads with row assignments
    ///   - overflow: Number of reads that didn't fit
    ///   - frame: Reference frame for coordinate mapping
    ///   - context: CoreGraphics context
    ///   - rect: Drawing rectangle
    public static func drawPackedReads(
        packedReads: [(row: Int, read: AlignedRead)],
        overflow: Int,
        frame: ReferenceFrame,
        context: CGContext,
        rect: CGRect
    ) {
        context.saveGState()

        for (row, read) in packedReads {
            let startPx = frame.genomicToPixel(Double(read.position))
            let endPx = frame.genomicToPixel(Double(read.alignmentEnd))
            let y = rect.minY + CGFloat(row) * (packedReadHeight + rowGap)
            let readWidth = endPx - startPx

            guard y + packedReadHeight <= rect.maxY else { continue }
            guard readWidth >= minReadPixels else { continue }

            // Read color based on strand and MAPQ
            let fillColor = read.isReverse ? reverseReadColor : forwardReadColor
            let strokeColor = read.isReverse ? reverseReadStroke : forwardReadStroke

            // MAPQ-based opacity
            let alpha = mapqAlpha(read.mapq)

            // Draw read rectangle with pointed end for strand
            let readRect = CGRect(x: startPx, y: y, width: readWidth, height: packedReadHeight)

            if readWidth > 6 {
                // Draw with pointed end
                let path = CGMutablePath()
                let arrowInset: CGFloat = min(3, readWidth * 0.15)

                if read.isReverse {
                    // Arrow pointing left
                    path.move(to: CGPoint(x: readRect.minX + arrowInset, y: readRect.minY))
                    path.addLine(to: CGPoint(x: readRect.maxX, y: readRect.minY))
                    path.addLine(to: CGPoint(x: readRect.maxX, y: readRect.maxY))
                    path.addLine(to: CGPoint(x: readRect.minX + arrowInset, y: readRect.maxY))
                    path.addLine(to: CGPoint(x: readRect.minX, y: readRect.midY))
                } else {
                    // Arrow pointing right
                    path.move(to: CGPoint(x: readRect.minX, y: readRect.minY))
                    path.addLine(to: CGPoint(x: readRect.maxX - arrowInset, y: readRect.minY))
                    path.addLine(to: CGPoint(x: readRect.maxX, y: readRect.midY))
                    path.addLine(to: CGPoint(x: readRect.maxX - arrowInset, y: readRect.maxY))
                    path.addLine(to: CGPoint(x: readRect.minX, y: readRect.maxY))
                }
                path.closeSubpath()

                context.setFillColor(fillColor.copy(alpha: alpha)!)
                context.addPath(path)
                context.fillPath()

                context.setStrokeColor(strokeColor.copy(alpha: alpha)!)
                context.setLineWidth(0.5)
                context.addPath(path)
                context.strokePath()
            } else {
                // Too small for arrow, just fill rectangle
                context.setFillColor(fillColor.copy(alpha: alpha)!)
                context.fill(readRect)
            }

            // Draw deletion lines
            drawDeletions(read: read, frame: frame, context: context, y: y + packedReadHeight / 2, readHeight: packedReadHeight)

            // Draw insertion ticks
            drawInsertionTicks(read: read, frame: frame, context: context, y: y, readHeight: packedReadHeight)
        }

        // Draw overflow indicator
        if overflow > 0 {
            drawOverflowIndicator(context: context, rect: rect, overflow: overflow)
        }

        context.restoreGState()
    }

    // MARK: - Base-Level Rendering (Tier 3)

    /// Draws reads with base-level detail: dots for matches, colored letters for mismatches.
    ///
    /// - Parameters:
    ///   - packedReads: Pre-packed reads with row assignments
    ///   - overflow: Number of reads that didn't fit
    ///   - frame: Reference frame for coordinate mapping
    ///   - referenceSequence: The reference sequence for match/mismatch detection
    ///   - referenceStart: 0-based start position of the reference sequence
    ///   - context: CoreGraphics context
    ///   - rect: Drawing rectangle
    public static func drawBaseReads(
        packedReads: [(row: Int, read: AlignedRead)],
        overflow: Int,
        frame: ReferenceFrame,
        referenceSequence: String?,
        referenceStart: Int,
        context: CGContext,
        rect: CGRect
    ) {
        context.saveGState()

        let pixelsPerBase = 1.0 / frame.scale
        let fontSize = min(12, CGFloat(pixelsPerBase) * 0.85)
        let font = CTFontCreateWithName("Menlo" as CFString, fontSize, nil)

        for (row, read) in packedReads {
            let y = rect.minY + CGFloat(row) * (baseReadHeight + rowGap)
            guard y + baseReadHeight <= rect.maxY else { continue }

            let alpha = mapqAlpha(read.mapq)

            // Draw read background
            let startPx = frame.genomicToPixel(Double(read.position))
            let endPx = frame.genomicToPixel(Double(read.alignmentEnd))
            let bgColor = read.isReverse
                ? NSColor(red: 0.97, green: 0.94, blue: 0.94, alpha: alpha * 0.5).cgColor
                : NSColor(red: 0.94, green: 0.96, blue: 0.97, alpha: alpha * 0.5).cgColor
            context.setFillColor(bgColor)
            context.fill(CGRect(x: startPx, y: y, width: endPx - startPx, height: baseReadHeight))

            // Draw bases
            drawReadBases(
                read: read,
                frame: frame,
                referenceSequence: referenceSequence,
                referenceStart: referenceStart,
                context: context,
                y: y,
                readHeight: baseReadHeight,
                font: font,
                fontSize: fontSize,
                alpha: alpha
            )

            // Draw insertion markers
            drawInsertionMarkers(read: read, frame: frame, context: context, y: y, readHeight: baseReadHeight)

            // Draw deletion lines
            drawDeletions(read: read, frame: frame, context: context, y: y + baseReadHeight / 2, readHeight: baseReadHeight)
        }

        // Draw overflow indicator
        if overflow > 0 {
            drawOverflowIndicator(context: context, rect: rect, overflow: overflow)
        }

        context.restoreGState()
    }

    // MARK: - Private Drawing Helpers

    /// Draws individual bases for a read with match/mismatch coloring.
    private static func drawReadBases(
        read: AlignedRead,
        frame: ReferenceFrame,
        referenceSequence: String?,
        referenceStart: Int,
        context: CGContext,
        y: CGFloat,
        readHeight: CGFloat,
        font: CTFont,
        fontSize: CGFloat,
        alpha: CGFloat
    ) {
        let pixelsPerBase = 1.0 / frame.scale
        let refChars = referenceSequence.map { Array($0.uppercased()) }

        read.forEachAlignedBase { readBase, refPos, op in
            let x = frame.genomicToPixel(Double(refPos))
            let cellWidth = CGFloat(pixelsPerBase)

            // Determine if match or mismatch
            let readChar = Character(String(readBase).uppercased())
            let isMatch: Bool
            if let refChars, refPos >= referenceStart,
               (refPos - referenceStart) < refChars.count {
                let refChar = refChars[refPos - referenceStart]
                isMatch = (readChar == Character(String(refChar)))
            } else {
                // No reference available, treat as match (show dot)
                isMatch = true
            }

            // Determine display character and color
            let displayChar: String
            let color: CGColor

            if op == .softClip {
                displayChar = String(readBase).lowercased()
                color = colorForBase(readChar).copy(alpha: alpha * 0.4)!
            } else if isMatch {
                displayChar = "."
                color = matchDotColor.copy(alpha: alpha)!
            } else {
                displayChar = String(readChar)
                color = colorForBase(readChar).copy(alpha: alpha)!
            }

            // Apply base quality modulation if available
            // (quality modulation is already baked into alpha via mapqAlpha)

            // Draw the character
            let attrs: [NSAttributedString.Key: Any] = [
                .font: font as Any,
                .foregroundColor: NSColor(cgColor: color) ?? NSColor.gray
            ]
            let str = displayChar as NSString
            let size = str.size(withAttributes: attrs)
            let drawX = x + (cellWidth - size.width) / 2
            let drawY = y + (readHeight - size.height) / 2
            str.draw(at: CGPoint(x: drawX, y: drawY), withAttributes: attrs)
        }
    }

    /// Draws deletion connecting lines for a read.
    private static func drawDeletions(
        read: AlignedRead,
        frame: ReferenceFrame,
        context: CGContext,
        y: CGFloat,
        readHeight: CGFloat
    ) {
        var refPos = read.position
        for op in read.cigar {
            if op.op == .deletion {
                let startPx = frame.genomicToPixel(Double(refPos))
                let endPx = frame.genomicToPixel(Double(refPos + op.length))
                context.setStrokeColor(deletionColor)
                context.setLineWidth(1)
                context.setLineDash(phase: 0, lengths: [2, 2])
                context.move(to: CGPoint(x: startPx, y: y))
                context.addLine(to: CGPoint(x: endPx, y: y))
                context.strokePath()
                context.setLineDash(phase: 0, lengths: [])
            }
            if op.consumesReference {
                refPos += op.length
            }
        }
    }

    /// Draws small insertion ticks (for packed mode).
    private static func drawInsertionTicks(
        read: AlignedRead,
        frame: ReferenceFrame,
        context: CGContext,
        y: CGFloat,
        readHeight: CGFloat
    ) {
        for ins in read.insertions {
            let x = frame.genomicToPixel(Double(ins.position))
            context.setFillColor(insertionColor)
            context.fill(CGRect(x: x - 0.5, y: y - 1, width: 1, height: readHeight + 2))
        }
    }

    /// Draws insertion markers with triangle indicators (for base mode).
    private static func drawInsertionMarkers(
        read: AlignedRead,
        frame: ReferenceFrame,
        context: CGContext,
        y: CGFloat,
        readHeight: CGFloat
    ) {
        for ins in read.insertions {
            let x = frame.genomicToPixel(Double(ins.position))
            // Vertical line
            context.setFillColor(insertionColor)
            context.fill(CGRect(x: x - 0.5, y: y, width: 1, height: readHeight))

            // Small triangle pointing down
            let trianglePath = CGMutablePath()
            trianglePath.move(to: CGPoint(x: x - 2, y: y))
            trianglePath.addLine(to: CGPoint(x: x + 2, y: y))
            trianglePath.addLine(to: CGPoint(x: x, y: y + 4))
            trianglePath.closeSubpath()
            context.addPath(trianglePath)
            context.fillPath()

            // Insertion length label if > 1 base
            if ins.bases.count > 1 {
                let label = "I\(ins.bases.count)" as NSString
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: NSFont.monospacedDigitSystemFont(ofSize: 7, weight: .medium),
                    .foregroundColor: NSColor(cgColor: insertionColor) ?? NSColor.magenta
                ]
                label.draw(at: CGPoint(x: x + 2, y: y), withAttributes: attrs)
            }
        }
    }

    /// Draws the overflow indicator bar at the bottom of the track.
    private static func drawOverflowIndicator(
        context: CGContext,
        rect: CGRect,
        overflow: Int
    ) {
        let barHeight: CGFloat = 16
        let barRect = CGRect(x: rect.minX, y: rect.maxY - barHeight, width: rect.width, height: barHeight)

        // Gradient background
        context.setFillColor(NSColor(white: 0.88, alpha: 0.9).cgColor)
        context.fill(barRect)

        // Text
        let text = "+\(overflow) reads not shown (max \(maxReadRows) rows)" as NSString
        let attrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 9),
            .foregroundColor: NSColor.secondaryLabelColor
        ]
        let size = text.size(withAttributes: attrs)
        text.draw(
            at: CGPoint(x: barRect.midX - size.width / 2, y: barRect.minY + (barHeight - size.height) / 2),
            withAttributes: attrs
        )
    }

    // MARK: - Utility

    /// Returns alpha value for a given mapping quality.
    private static func mapqAlpha(_ mapq: UInt8) -> CGFloat {
        switch mapq {
        case 40...255: return 1.0
        case 20..<40:  return 0.7
        case 10..<20:  return 0.45
        case 1..<10:   return 0.25
        default:       return 0.15
        }
    }

    /// Returns the color for a nucleotide base.
    private static func colorForBase(_ base: Character) -> CGColor {
        switch base {
        case "A", "a": return baseA
        case "T", "t": return baseT
        case "C", "c": return baseC
        case "G", "g": return baseG
        default:        return baseN
        }
    }

    /// Calculates the total height needed for packed reads.
    ///
    /// - Parameters:
    ///   - rowCount: Number of rows used
    ///   - tier: Current zoom tier
    /// - Returns: Total height in pixels
    public static func totalHeight(rowCount: Int, tier: ZoomTier) -> CGFloat {
        switch tier {
        case .coverage:
            return coverageTrackHeight
        case .packed:
            return CGFloat(rowCount) * (packedReadHeight + rowGap)
        case .base:
            return CGFloat(rowCount) * (baseReadHeight + rowGap)
        }
    }
}

// MARK: - ReferenceFrame Extension

extension ReferenceFrame {

    /// Converts a genomic position to a pixel X coordinate.
    func genomicToPixel(_ position: Double) -> CGFloat {
        CGFloat((position - start) / scale)
    }
}
