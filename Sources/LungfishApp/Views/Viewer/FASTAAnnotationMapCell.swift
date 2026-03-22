// FASTAAnnotationMapCell.swift - Mini map cell showing annotation positions
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import LungfishCore

/// A custom cell view that draws a proportional mini-map of annotation positions
/// along a sequence.
///
/// Each annotation is rendered as a thin colored rectangle at its proportional
/// position within the sequence, giving a quick visual overview of feature
/// distribution. Annotation colors are derived from ``AnnotationType/defaultColor``.
@MainActor
final class FASTAAnnotationMapCell: NSView {

    // MARK: - State

    private var sequenceLength: Int = 0
    private var annotations: [SequenceAnnotation] = []

    // MARK: - Configuration

    /// Configures the cell with sequence length and its annotations.
    ///
    /// - Parameters:
    ///   - sequenceLength: Total length of the parent sequence in bases.
    ///   - annotations: Annotations belonging to this sequence.
    func configure(sequenceLength: Int, annotations: [SequenceAnnotation]) {
        self.sequenceLength = sequenceLength
        self.annotations = annotations
        needsDisplay = true
    }

    // MARK: - Drawing

    override func draw(_ dirtyRect: NSRect) {
        guard let ctx = NSGraphicsContext.current?.cgContext else { return }

        let inset: CGFloat = 2
        let barRect = bounds.insetBy(dx: inset, dy: 4)
        guard barRect.width > 0, barRect.height > 0 else { return }

        // Background bar
        ctx.setFillColor(NSColor.separatorColor.withAlphaComponent(0.25).cgColor)
        let bgPath = CGPath(roundedRect: barRect, cornerWidth: 2, cornerHeight: 2, transform: nil)
        ctx.addPath(bgPath)
        ctx.fillPath()

        guard sequenceLength > 0 else { return }

        // Clip to the bar bounds for annotation marks
        ctx.saveGState()
        ctx.clip(to: barRect)

        let scale = barRect.width / CGFloat(sequenceLength)

        for annotation in annotations {
            let region = annotation.boundingRegion
            let x = barRect.minX + CGFloat(region.start) * scale
            let width = max(1, CGFloat(region.end - region.start) * scale)

            let color = annotationNSColor(for: annotation.type)
            ctx.setFillColor(color.withAlphaComponent(0.85).cgColor)
            ctx.fill(CGRect(x: x, y: barRect.minY, width: width, height: barRect.height))
        }

        ctx.restoreGState()
    }

    // MARK: - Color Mapping

    /// Converts an ``AnnotationType``'s default color to an NSColor.
    private func annotationNSColor(for type: AnnotationType) -> NSColor {
        let c = type.defaultColor
        return NSColor(
            calibratedRed: c.red,
            green: c.green,
            blue: c.blue,
            alpha: c.alpha
        )
    }
}
