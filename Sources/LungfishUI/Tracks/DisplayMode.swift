// DisplayMode.swift - Track display mode enumeration
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Owner: Track Rendering Engineer (Role 04)
// Reference: IGV's Track.java DisplayMode enum

import Foundation

/// Display mode for track rendering, following IGV's pattern.
///
/// Display modes control how features are rendered within a track:
/// - **collapsed**: All features on a single row, overlapping allowed
/// - **squished**: Features packed into rows with reduced height
/// - **expanded**: Features packed into rows with full height
/// - **auto**: Automatically choose based on feature density
///
/// ## Row Heights (from IGV)
/// - Collapsed: 25 points
/// - Squished: 12 points
/// - Expanded: 35 points
public enum DisplayMode: String, CaseIterable, Codable, Sendable {

    /// All features on a single row
    case collapsed

    /// Features packed with reduced height
    case squished

    /// Features packed with full height
    case expanded

    /// Automatically choose based on density
    case auto

    // MARK: - Row Heights (from IGV FeatureTrack.java)

    /// Default row height for this display mode
    public var rowHeight: CGFloat {
        switch self {
        case .collapsed:
            return 25
        case .squished:
            return 12
        case .expanded:
            return 35
        case .auto:
            return 25  // Default to collapsed height
        }
    }

    /// Minimum track height for this display mode
    public var minimumTrackHeight: CGFloat {
        switch self {
        case .collapsed:
            return 25
        case .squished:
            return 15
        case .expanded:
            return 40
        case .auto:
            return 25
        }
    }

    /// Default track height for this display mode
    public var defaultTrackHeight: CGFloat {
        switch self {
        case .collapsed:
            return 40
        case .squished:
            return 60
        case .expanded:
            return 100
        case .auto:
            return 60
        }
    }

    /// Maximum rows to display before switching to density view
    public var maxRows: Int {
        switch self {
        case .collapsed:
            return 1
        case .squished:
            return 50
        case .expanded:
            return 25
        case .auto:
            return 25
        }
    }

    // MARK: - Display Properties

    /// Human-readable name for UI display
    public var displayName: String {
        switch self {
        case .collapsed:
            return "Collapsed"
        case .squished:
            return "Squished"
        case .expanded:
            return "Expanded"
        case .auto:
            return "Auto"
        }
    }

    /// SF Symbol for this display mode
    public var symbolName: String {
        switch self {
        case .collapsed:
            return "rectangle.compress.vertical"
        case .squished:
            return "rectangle.split.3x1"
        case .expanded:
            return "rectangle.expand.vertical"
        case .auto:
            return "wand.and.stars"
        }
    }

    /// Keyboard shortcut character for this mode
    public var shortcutCharacter: Character? {
        switch self {
        case .collapsed:
            return "1"
        case .squished:
            return "2"
        case .expanded:
            return "3"
        case .auto:
            return "0"
        }
    }

    // MARK: - Feature Rendering

    /// Whether labels should be shown in this mode
    public var showLabels: Bool {
        switch self {
        case .collapsed:
            return false
        case .squished:
            return false
        case .expanded:
            return true
        case .auto:
            return true
        }
    }

    /// Whether strand arrows should be shown
    public var showStrandArrows: Bool {
        switch self {
        case .collapsed:
            return false
        case .squished:
            return true
        case .expanded:
            return true
        case .auto:
            return true
        }
    }

    /// Feature height within a row (excluding padding)
    public var featureHeight: CGFloat {
        switch self {
        case .collapsed:
            return 20
        case .squished:
            return 8
        case .expanded:
            return 28
        case .auto:
            return 20
        }
    }

    /// Vertical padding between rows
    public var rowPadding: CGFloat {
        switch self {
        case .collapsed:
            return 2
        case .squished:
            return 2
        case .expanded:
            return 4
        case .auto:
            return 2
        }
    }

    // MARK: - Auto Mode Resolution

    /// Resolves auto mode to a concrete mode based on feature count.
    ///
    /// - Parameters:
    ///   - featureCount: Number of visible features
    ///   - trackHeight: Available track height
    /// - Returns: Resolved display mode (never auto)
    public func resolve(featureCount: Int, trackHeight: CGFloat) -> DisplayMode {
        guard self == .auto else { return self }

        // Heuristics based on IGV behavior
        if featureCount == 0 {
            return .expanded
        }

        let maxExpandedRows = Int(trackHeight / DisplayMode.expanded.rowHeight)
        let maxSquishedRows = Int(trackHeight / DisplayMode.squished.rowHeight)

        if featureCount <= maxExpandedRows {
            return .expanded
        } else if featureCount <= maxSquishedRows {
            return .squished
        } else {
            return .collapsed
        }
    }
}

// MARK: - Identifiable

extension DisplayMode: Identifiable {
    public var id: String { rawValue }
}
