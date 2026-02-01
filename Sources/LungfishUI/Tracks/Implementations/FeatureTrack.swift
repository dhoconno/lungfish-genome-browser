// FeatureTrack.swift - Annotation/feature track
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Owner: Track Rendering Engineer (Role 04)
// Reference: IGV's FeatureTrack

import Foundation
import AppKit
import LungfishCore

/// Track for displaying genomic features/annotations.
///
/// Renders features from GFF, BED, or other annotation formats.
/// Features are packed into rows to avoid overlap.
///
/// Supports:
/// - Multiple display modes (collapsed, squished, expanded)
/// - Color coding by feature type
/// - Strand arrows
/// - Labels at high zoom
@MainActor
public final class FeatureTrack: Track {

    // MARK: - Track Identity

    public let id: UUID
    public var name: String
    public var height: CGFloat
    public var isVisible: Bool = true
    public var displayMode: DisplayMode = .auto
    public var isSelected: Bool = false
    public var order: Int = 0

    // MARK: - Data Source

    public var dataSource: (any TrackDataSource)?

    /// Annotations to display
    private var annotations: [SequenceAnnotation] = []

    /// Cached packed features
    private var packedFeatures: [PackedFeature<SequenceAnnotation>] = []
    private var packedRowCount: Int = 0
    private var lastPackedFrame: ReferenceFrame?

    // MARK: - Configuration

    /// Row packer for layout
    private let packer = RowPacker<SequenceAnnotation>(minGap: 5)

    /// Minimum feature width in pixels
    public var minFeatureWidth: CGFloat = 1

    /// Whether to show feature labels
    public var showLabels: Bool = true

    /// Minimum width to show labels
    public var minLabelWidth: CGFloat = 50

    /// Feature colors by type
    public var colorByType: [AnnotationType: NSColor] = [
        .gene: NSColor(red: 0.0, green: 0.4, blue: 0.8, alpha: 1.0),
        .cds: NSColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1.0),
        .exon: NSColor(red: 0.6, green: 0.4, blue: 0.8, alpha: 1.0),
        .region: NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0),
    ]

    /// Default feature color
    public var defaultColor = NSColor(red: 0.3, green: 0.5, blue: 0.7, alpha: 1.0)

    // MARK: - Initialization

    /// Creates a feature track.
    ///
    /// - Parameters:
    ///   - name: Display name for the track
    ///   - annotations: Initial annotations
    ///   - height: Track height in points
    public init(name: String = "Features", annotations: [SequenceAnnotation] = [], height: CGFloat = 60) {
        self.id = UUID()
        self.name = name
        self.annotations = annotations
        self.height = height
    }

    /// Sets the annotations to display.
    public func setAnnotations(_ annotations: [SequenceAnnotation]) {
        self.annotations = annotations
        invalidateCache()
    }

    /// Adds annotations to the track.
    public func addAnnotations(_ newAnnotations: [SequenceAnnotation]) {
        self.annotations.append(contentsOf: newAnnotations)
        invalidateCache()
    }

    private func invalidateCache() {
        packedFeatures = []
        packedRowCount = 0
        lastPackedFrame = nil
    }

    // MARK: - Track Protocol

    public func isReady(for frame: ReferenceFrame) -> Bool {
        // Check if we need to repack
        if let lastFrame = lastPackedFrame {
            return lastFrame == frame
        }
        return false
    }

    public func load(for frame: ReferenceFrame) async throws {
        // Pack features for this frame
        let result = packer.packWithRowCount(annotations, in: frame)
        packedFeatures = result.features
        packedRowCount = result.rowCount
        lastPackedFrame = frame
    }

    public func render(context: RenderContext, rect: CGRect) {
        let frame = context.frame

        // Background
        context.fill(rect, with: .textBackgroundColor)

        guard !annotations.isEmpty else {
            drawPlaceholder(context: context, rect: rect, message: "No features loaded")
            return
        }

        // Repack if needed
        if lastPackedFrame != frame {
            let result = packer.packWithRowCount(annotations, in: frame)
            packedFeatures = result.features
            packedRowCount = result.rowCount
            lastPackedFrame = frame
        }

        // Resolve display mode
        let resolvedMode = displayMode.resolve(featureCount: packedFeatures.count, trackHeight: rect.height)

        // Render based on mode
        switch resolvedMode {
        case .collapsed:
            renderCollapsed(context: context, rect: rect)
        case .squished:
            renderPacked(context: context, rect: rect, rowHeight: DisplayMode.squished.rowHeight, showLabels: false)
        case .expanded:
            renderPacked(context: context, rect: rect, rowHeight: DisplayMode.expanded.rowHeight, showLabels: true)
        case .auto:
            renderPacked(context: context, rect: rect, rowHeight: DisplayMode.expanded.rowHeight, showLabels: true)
        }

        // Draw track label
        drawTrackLabel(context: context, rect: rect)
    }

    // MARK: - Rendering Methods

    private func renderCollapsed(context: RenderContext, rect: CGRect) {
        let frame = context.frame
        let graphics = context.graphics

        // Calculate density
        let density = FeatureDensityCalculator.calculateDensity(for: annotations, in: frame, binCount: Int(rect.width))
        let maxDensity = density.max() ?? 1

        // Draw density bars
        let barWidth: CGFloat = 1
        for (index, count) in density.enumerated() {
            let x = rect.minX + CGFloat(index) * barWidth
            let proportion = CGFloat(count) / CGFloat(maxDensity)
            let barHeight = rect.height * proportion

            graphics.setFillColor(defaultColor.withAlphaComponent(0.7).cgColor)
            graphics.fill(CGRect(x: x, y: rect.maxY - barHeight, width: barWidth, height: barHeight))
        }
    }

    private func renderPacked(context: RenderContext, rect: CGRect, rowHeight: CGFloat, showLabels: Bool) {
        let graphics = context.graphics

        for packed in packedFeatures {
            let feature = packed.feature
            let row = packed.row

            // Calculate Y position
            let y = rect.minY + CGFloat(row) * rowHeight + 2

            // Skip if outside visible area
            if y + rowHeight < rect.minY || y > rect.maxY {
                continue
            }

            // Calculate feature rect
            let featureWidth = max(minFeatureWidth, packed.screenEnd - packed.screenStart)
            let featureRect = CGRect(
                x: packed.screenStart,
                y: y,
                width: featureWidth,
                height: rowHeight - 4
            )

            // Get color
            let color: NSColor
            if let typeColor = colorByType[feature.type] {
                color = typeColor
            } else if let featureColor = feature.color {
                color = featureColor.toNSColor()
            } else {
                color = defaultColor
            }

            // Draw feature body
            graphics.setFillColor(color.cgColor)
            drawFeatureShape(context: context, feature: feature, rect: featureRect)

            // Draw strand arrow if room
            if feature.strand != .unknown && featureRect.width > 10 {
                drawStrandArrow(context: context, rect: featureRect, strand: feature.strand, color: color)
            }

            // Draw label if room
            if showLabels && featureRect.width >= minLabelWidth {
                drawFeatureLabel(context: context, feature: feature, rect: featureRect)
            }
        }
    }

    private func drawFeatureShape(context: RenderContext, feature: SequenceAnnotation, rect: CGRect) {
        let graphics = context.graphics

        // For multi-interval features (like genes with exons), draw connected boxes
        if feature.intervals.count > 1 {
            // Draw thin line connecting all intervals
            let lineY = rect.midY
            graphics.setStrokeColor(NSColor.secondaryLabelColor.cgColor)
            graphics.setLineWidth(1)
            graphics.move(to: CGPoint(x: rect.minX, y: lineY))
            graphics.addLine(to: CGPoint(x: rect.maxX, y: lineY))
            graphics.strokePath()

            // Draw each interval as a box
            for interval in feature.intervals {
                let intervalStart = context.frame.screenPosition(for: Double(interval.start))
                let intervalEnd = context.frame.screenPosition(for: Double(interval.end))
                let intervalRect = CGRect(
                    x: intervalStart,
                    y: rect.minY,
                    width: max(1, intervalEnd - intervalStart),
                    height: rect.height
                )
                graphics.fill(intervalRect)
            }
        } else {
            // Simple single-interval feature
            graphics.fill(rect)
        }
    }

    private func drawStrandArrow(context: RenderContext, rect: CGRect, strand: Strand, color: NSColor) {
        let graphics = context.graphics
        let arrowSize: CGFloat = 6

        graphics.setFillColor(color.darker(by: 0.2).cgColor)

        let midY = rect.midY

        if strand == .forward {
            // Right-pointing arrow
            let arrowX = rect.maxX - arrowSize
            let path = CGMutablePath()
            path.move(to: CGPoint(x: arrowX, y: midY - arrowSize / 2))
            path.addLine(to: CGPoint(x: arrowX + arrowSize, y: midY))
            path.addLine(to: CGPoint(x: arrowX, y: midY + arrowSize / 2))
            path.closeSubpath()
            graphics.addPath(path)
            graphics.fillPath()
        } else if strand == .reverse {
            // Left-pointing arrow
            let arrowX = rect.minX + arrowSize
            let path = CGMutablePath()
            path.move(to: CGPoint(x: arrowX, y: midY - arrowSize / 2))
            path.addLine(to: CGPoint(x: arrowX - arrowSize, y: midY))
            path.addLine(to: CGPoint(x: arrowX, y: midY + arrowSize / 2))
            path.closeSubpath()
            graphics.addPath(path)
            graphics.fillPath()
        }
    }

    private func drawFeatureLabel(context: RenderContext, feature: SequenceAnnotation, rect: CGRect) {
        let label = feature.name
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 10),
            .foregroundColor: NSColor.labelColor
        ]

        let size = label.size(withAttributes: attributes)

        // Center label in feature
        let x = rect.minX + (rect.width - size.width) / 2
        let y = rect.minY + (rect.height - size.height) / 2

        // Only draw if it fits
        if size.width < rect.width - 4 {
            label.draw(at: CGPoint(x: x, y: y), withAttributes: attributes)
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
        // Find feature at position
        for packed in packedFeatures {
            if position >= Double(packed.feature.start) && position <= Double(packed.feature.end) {
                let feature = packed.feature
                var text = "\(feature.name)\n"
                text += "Type: \(feature.type)\n"
                text += "Position: \(feature.start)-\(feature.end)"
                if feature.strand != .unknown {
                    text += "\nStrand: \(feature.strand == .forward ? "+" : "-")"
                }
                return text
            }
        }
        return nil
    }

    public func handleClick(at position: Double, y: CGFloat, modifiers: NSEvent.ModifierFlags) -> Bool {
        // Could implement selection here
        return false
    }

    public func contextMenu(at position: Double, y: CGFloat) -> NSMenu? {
        let menu = NSMenu()
        menu.addItem(withTitle: "Copy Feature Info", action: nil, keyEquivalent: "")
        menu.addItem(withTitle: "Zoom to Feature", action: nil, keyEquivalent: "")
        return menu
    }
}

// MARK: - AnnotationColor Extension

extension AnnotationColor {
    /// Converts to NSColor for rendering.
    func toNSColor() -> NSColor {
        NSColor(
            red: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            alpha: CGFloat(alpha)
        )
    }
}

// MARK: - NSColor Extension

extension NSColor {
    /// Returns a darker version of the color.
    func darker(by amount: CGFloat) -> NSColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        return NSColor(
            hue: hue,
            saturation: saturation,
            brightness: max(0, brightness - amount),
            alpha: alpha
        )
    }
}
