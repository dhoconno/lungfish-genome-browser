// LungfishColors.swift - Brand color definitions for Lungfish
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import SwiftUI
import AppKit

// MARK: - SwiftUI Color Extensions

extension Color {
    /// Lungfish Orange — the primary brand accent color.
    ///
    /// Use this for tool icons, card icon backgrounds, branded UI elements,
    /// and any place where the app's identity should be visible. Do NOT use
    /// `Color.accentColor` for branded elements — that follows the user's
    /// system-wide accent preference.
    ///
    /// System controls (buttons, checkboxes, segmented controls) should
    /// continue to use `.borderedProminent` / `Color.accentColor` to
    /// respect macOS HIG and user preferences.
    ///
    /// - Light mode: `#D47B3A` (RGB 212, 123, 58)
    /// - Dark mode: `#E8A06A` (RGB 232, 160, 106)
    static let lungfishOrange = Color("LungfishOrange", bundle: .main)

    /// Fallback Lungfish Orange that works without an Asset Catalog entry.
    /// Uses adaptive NSColor for automatic light/dark mode switching.
    static let lungfishOrangeFallback = Color(nsColor: .lungfishOrange)
}

// MARK: - NSColor Extensions

extension NSColor {
    /// Lungfish Orange — the primary brand accent color for AppKit usage.
    ///
    /// Automatically adapts between light mode (#D47B3A) and dark mode (#E8A06A).
    static let lungfishOrange: NSColor = NSColor(name: "LungfishOrange") { appearance in
        if appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua {
            // Dark mode: lighter orange for contrast
            return NSColor(red: 0.910, green: 0.627, blue: 0.416, alpha: 1.0)
        } else {
            // Light mode: standard Lungfish Orange
            return NSColor(red: 0.831, green: 0.482, blue: 0.227, alpha: 1.0)
        }
    }
}
