// Track.swift - Track protocol for genomic data visualization
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Owner: Track Rendering Engineer (Role 04)
// Reference: IGV's Track.java interface

import Foundation
import AppKit
import LungfishCore

// MARK: - Track Protocol

/// Protocol for genomic data tracks.
///
/// Tracks are the primary visualization unit for genomic data. Each track
/// displays a specific type of data (sequences, features, alignments, coverage)
/// and handles its own data loading and rendering.
///
/// ## Track Lifecycle
/// 1. `isReady(for:)` - Check if data is loaded for the current view
/// 2. `load(for:)` - Load data for the current view (async)
/// 3. `render(context:rect:)` - Render the track content
///
/// ## Example Implementation
/// ```swift
/// class FeatureTrack: Track {
///     func render(context: RenderContext, rect: CGRect) {
///         for feature in visibleFeatures {
///             let featureRect = context.frame.screenRect(
///                 for: Double(feature.start),
///                 end: Double(feature.end),
///                 y: rect.minY,
///                 height: displayMode.featureHeight
///             )
///             context.fill(featureRect, with: feature.color)
///         }
///     }
/// }
/// ```
public protocol Track: AnyObject, Identifiable, Sendable where ID == UUID {

    // MARK: - Identity

    /// Unique identifier for the track
    var id: UUID { get }

    /// Display name of the track
    var name: String { get set }

    // MARK: - Display Properties

    /// Current height of the track in points
    var height: CGFloat { get set }

    /// Whether the track is visible
    var isVisible: Bool { get set }

    /// Current display mode
    var displayMode: DisplayMode { get set }

    /// Whether the track is currently selected
    var isSelected: Bool { get set }

    /// Order index for track sorting
    var order: Int { get set }

    // MARK: - Data Loading

    /// Data source for this track
    var dataSource: (any TrackDataSource)? { get }

    /// Checks if the track has data loaded for the given reference frame.
    ///
    /// - Parameter frame: The reference frame to check
    /// - Returns: True if data is ready to render
    func isReady(for frame: ReferenceFrame) -> Bool

    /// Loads data for the given reference frame.
    ///
    /// This method is called when the view changes and new data is needed.
    /// Implementations should load data asynchronously and cache results.
    ///
    /// - Parameter frame: The reference frame to load data for
    func load(for frame: ReferenceFrame) async throws

    // MARK: - Rendering

    /// Renders the track content.
    ///
    /// - Parameters:
    ///   - context: The render context with graphics state
    ///   - rect: The rectangle to render into
    func render(context: RenderContext, rect: CGRect)

    // MARK: - Interaction

    /// Returns tooltip text for a position.
    ///
    /// - Parameters:
    ///   - position: Genomic position in base pairs
    ///   - y: Y coordinate within the track
    /// - Returns: Tooltip text, or nil if no content at position
    func tooltipText(at position: Double, y: CGFloat) -> String?

    /// Handles a click at a position.
    ///
    /// - Parameters:
    ///   - position: Genomic position in base pairs
    ///   - y: Y coordinate within the track
    ///   - modifiers: Keyboard modifiers
    /// - Returns: True if the click was handled
    func handleClick(at position: Double, y: CGFloat, modifiers: NSEvent.ModifierFlags) -> Bool

    /// Returns the menu for a right-click at a position.
    ///
    /// - Parameters:
    ///   - position: Genomic position in base pairs
    ///   - y: Y coordinate within the track
    /// - Returns: Context menu, or nil for default menu
    func contextMenu(at position: Double, y: CGFloat) -> NSMenu?
}

// MARK: - Default Implementations

public extension Track {

    func tooltipText(at position: Double, y: CGFloat) -> String? {
        nil
    }

    func handleClick(at position: Double, y: CGFloat, modifiers: NSEvent.ModifierFlags) -> Bool {
        false
    }

    func contextMenu(at position: Double, y: CGFloat) -> NSMenu? {
        nil
    }
}

// MARK: - TrackDataSource Protocol

/// Protocol for track data sources.
///
/// Data sources provide the underlying data for tracks. They handle
/// data loading, caching, and region queries.
public protocol TrackDataSource: Sendable {

    /// The type of data this source provides
    associatedtype DataType

    /// Queries data for a genomic region.
    ///
    /// - Parameters:
    ///   - chromosome: Chromosome name
    ///   - start: Start position in base pairs
    ///   - end: End position in base pairs
    /// - Returns: Data for the region
    func query(chromosome: String, start: Int, end: Int) async throws -> DataType

    /// Checks if data is available for a region.
    ///
    /// - Parameters:
    ///   - chromosome: Chromosome name
    ///   - start: Start position in base pairs
    ///   - end: End position in base pairs
    /// - Returns: True if data is available
    func hasData(chromosome: String, start: Int, end: Int) -> Bool
}

// MARK: - RenderContext

/// Context for track rendering operations.
///
/// Provides access to the graphics context, reference frame, and
/// common rendering utilities.
@MainActor
public final class RenderContext {

    /// The Core Graphics context for drawing
    public let graphics: CGContext

    /// The current reference frame
    public let frame: ReferenceFrame

    /// The visible region in genomic coordinates
    public var visibleRegion: GenomicRegion {
        GenomicRegion(
            chromosome: frame.chromosome,
            start: Int(max(0, frame.origin)),
            end: Int(ceil(frame.end))
        )
    }

    /// Scale factor for retina displays
    public let scaleFactor: CGFloat

    /// Whether dark mode is active
    public let isDarkMode: Bool

    /// Creates a render context.
    ///
    /// - Parameters:
    ///   - graphics: Core Graphics context
    ///   - frame: Reference frame for coordinate conversion
    ///   - scaleFactor: Display scale factor (default 2.0 for retina)
    ///   - isDarkMode: Whether dark mode is active
    public init(
        graphics: CGContext,
        frame: ReferenceFrame,
        scaleFactor: CGFloat = 2.0,
        isDarkMode: Bool = false
    ) {
        self.graphics = graphics
        self.frame = frame
        self.scaleFactor = scaleFactor
        self.isDarkMode = isDarkMode
    }

    // MARK: - Drawing Utilities

    /// Fills a rectangle with a color.
    public func fill(_ rect: CGRect, with color: NSColor) {
        graphics.setFillColor(color.cgColor)
        graphics.fill(rect)
    }

    /// Strokes a rectangle with a color.
    public func stroke(_ rect: CGRect, with color: NSColor, lineWidth: CGFloat = 1) {
        graphics.setStrokeColor(color.cgColor)
        graphics.setLineWidth(lineWidth)
        graphics.stroke(rect)
    }

    /// Draws text at a position.
    public func drawText(
        _ text: String,
        at point: CGPoint,
        font: NSFont = .systemFont(ofSize: 11),
        color: NSColor = .labelColor
    ) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color
        ]
        (text as NSString).draw(at: point, withAttributes: attributes)
    }

    /// Draws a line between two points.
    public func drawLine(from start: CGPoint, to end: CGPoint, color: NSColor, lineWidth: CGFloat = 1) {
        graphics.setStrokeColor(color.cgColor)
        graphics.setLineWidth(lineWidth)
        graphics.move(to: start)
        graphics.addLine(to: end)
        graphics.strokePath()
    }
}

// MARK: - TrackType

/// Types of tracks available in the system.
public enum TrackType: String, CaseIterable, Codable, Sendable {

    /// Reference sequence track
    case sequence

    /// Feature/annotation track (GFF, BED)
    case feature

    /// Gene model track with exon/intron structure
    case gene

    /// Alignment/read track (BAM, CRAM)
    case alignment

    /// Coverage/signal track (BigWig)
    case coverage

    /// Variant track (VCF)
    case variant

    /// Custom track type
    case custom

    /// Display name for the track type
    public var displayName: String {
        switch self {
        case .sequence:
            return "Sequence"
        case .feature:
            return "Features"
        case .gene:
            return "Genes"
        case .alignment:
            return "Alignments"
        case .coverage:
            return "Coverage"
        case .variant:
            return "Variants"
        case .custom:
            return "Custom"
        }
    }

    /// SF Symbol for this track type
    public var symbolName: String {
        switch self {
        case .sequence:
            return "text.alignleft"
        case .feature:
            return "rectangle.split.3x1.fill"
        case .gene:
            return "arrow.left.and.right"
        case .alignment:
            return "align.horizontal.left.fill"
        case .coverage:
            return "chart.xyaxis.line"
        case .variant:
            return "diamond.fill"
        case .custom:
            return "square.grid.2x2"
        }
    }

    /// Default height for this track type
    public var defaultHeight: CGFloat {
        switch self {
        case .sequence:
            return 50
        case .feature:
            return 60
        case .gene:
            return 80
        case .alignment:
            return 150
        case .coverage:
            return 60
        case .variant:
            return 40
        case .custom:
            return 60
        }
    }
}

// MARK: - TrackConfiguration

/// Configuration options for a track.
public struct TrackConfiguration: Codable, Sendable {

    /// Track name
    public var name: String

    /// Track height
    public var height: CGFloat

    /// Display mode
    public var displayMode: DisplayMode

    /// Whether the track is visible
    public var isVisible: Bool

    /// Track order
    public var order: Int

    /// Custom color (optional)
    public var color: String?

    /// Additional options as key-value pairs
    public var options: [String: String]

    public init(
        name: String,
        height: CGFloat = 60,
        displayMode: DisplayMode = .auto,
        isVisible: Bool = true,
        order: Int = 0,
        color: String? = nil,
        options: [String: String] = [:]
    ) {
        self.name = name
        self.height = height
        self.displayMode = displayMode
        self.isVisible = isVisible
        self.order = order
        self.color = color
        self.options = options
    }
}
