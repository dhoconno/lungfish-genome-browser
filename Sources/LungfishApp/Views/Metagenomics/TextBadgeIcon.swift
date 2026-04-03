// TextBadgeIcon.swift — Renders multi-letter badge icons for sidebar and import UI
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit

/// Renders a small rounded-rectangle badge with centered text.
///
/// Used for classifier sidebar icons ("Nao", "Nvd") where single-letter
/// SF Symbols are unavailable or ambiguous.
enum TextBadgeIcon {

    /// The default Lungfish Orange fill color for badge icons.
    static let defaultFillColor = NSColor(
        calibratedRed: 212 / 255.0,
        green: 123 / 255.0,
        blue: 58 / 255.0,
        alpha: 1.0
    )

    /// Renders a badge icon with the given text.
    ///
    /// - Parameters:
    ///   - text: The badge label (e.g. "Nao", "Nvd"). Keep to 2-4 characters.
    ///   - size: The image size in points.
    ///   - fillColor: Background fill color. Defaults to Lungfish Orange.
    ///   - textColor: Text color. Defaults to white.
    /// - Returns: An `NSImage` containing the rendered badge.
    static func image(
        text: String,
        size: NSSize,
        fillColor: NSColor = defaultFillColor,
        textColor: NSColor = .white
    ) -> NSImage {
        NSImage(size: size, flipped: false) { rect in
            let cornerRadius = rect.height * 0.2

            // Background pill
            let path = NSBezierPath(roundedRect: rect.insetBy(dx: 0.5, dy: 0.5),
                                     xRadius: cornerRadius, yRadius: cornerRadius)
            fillColor.setFill()
            path.fill()

            // Text
            let fontSize = rect.height * 0.48
            let font = NSFont.systemFont(ofSize: fontSize, weight: .bold)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: textColor,
            ]
            let attrString = NSAttributedString(string: text, attributes: attributes)
            let textSize = attrString.size()
            let textOrigin = NSPoint(
                x: rect.midX - textSize.width / 2,
                y: rect.midY - textSize.height / 2
            )
            attrString.draw(at: textOrigin)

            return true
        }
    }
}
