// ReferenceFrame.swift - Coordinate system for genomic visualization
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Owner: Track Rendering Engineer (Role 04)
// Reference: IGV's ReferenceFrame.java

import Foundation
import Observation
import LungfishCore

/// Coordinate system for genomic visualization, following IGV's ReferenceFrame pattern.
///
/// The reference frame maps between genomic coordinates (base pairs) and screen
/// coordinates (pixels). It maintains the current view state including chromosome,
/// visible range, and zoom level.
///
/// ## Key Parameters (from IGV)
/// - `binsPerTile = 700` - Pixels per rendering tile
/// - `maxZoom = 23` - Maximum zoom levels
/// - `minBP = 40` - Minimum visible base pairs
///
/// ## Usage
/// ```swift
/// let frame = ReferenceFrame(
///     chromosome: "chr1",
///     chromosomeLength: 248956422,
///     widthInPixels: 1000
/// )
///
/// // Navigate to region
/// frame.jumpTo(start: 1000000, end: 1100000)
///
/// // Convert coordinates
/// let screenX = frame.screenPosition(for: 1050000)
/// let genomicPos = frame.genomicPosition(for: screenX)
/// ```
/// Coordinate system for genomic visualization.
///
/// Note: This class uses @Observable but is not Sendable as it contains
/// mutable state. Use @MainActor isolation for thread safety.
@Observable
@MainActor
public final class ReferenceFrame {

    // MARK: - IGV Constants

    /// Pixels per rendering tile (from IGV ReferenceFrame.java line 40)
    public static let binsPerTile: Int = 700

    /// Maximum zoom level (from IGV ReferenceFrame.java line 60)
    public static let maxZoom: Int = 23

    /// Minimum visible base pairs (from IGV ReferenceFrame.java line 65)
    public static let minBP: Int = 40

    // MARK: - State

    /// Chromosome or sequence name
    public private(set) var chromosome: String

    /// Total length of the chromosome in base pairs
    public private(set) var chromosomeLength: Int

    /// Start position of the visible window (origin) in base pairs
    public private(set) var origin: Double

    /// End position of the visible window in base pairs
    public var end: Double {
        origin + Double(widthInPixels) * scale
    }

    /// Width of the view in pixels
    public private(set) var widthInPixels: Int

    /// Base pairs per pixel (scale factor)
    public private(set) var scale: Double

    /// Current zoom level (0 = fully zoomed out, maxZoom = maximum zoom)
    public var zoom: Int {
        calculateZoom()
    }

    /// Visible window length in base pairs
    public var windowLength: Double {
        Double(widthInPixels) * scale
    }

    // MARK: - Initialization

    /// Creates a reference frame for a chromosome.
    ///
    /// - Parameters:
    ///   - chromosome: Name of the chromosome or sequence
    ///   - chromosomeLength: Total length in base pairs
    ///   - widthInPixels: Width of the view in pixels
    public init(chromosome: String, chromosomeLength: Int, widthInPixels: Int) {
        let width = max(1, widthInPixels)
        self.chromosome = chromosome
        self.chromosomeLength = chromosomeLength
        self.widthInPixels = width
        self.origin = 0
        self.scale = Double(chromosomeLength) / Double(width)
    }

    /// Creates a reference frame with explicit start/end positions.
    ///
    /// - Parameters:
    ///   - chromosome: Name of the chromosome or sequence
    ///   - start: Start position in base pairs
    ///   - end: End position in base pairs
    ///   - chromosomeLength: Total length (defaults to end if not provided)
    ///   - widthInPixels: Width of the view in pixels
    public init(
        chromosome: String,
        start: Double,
        end: Double,
        chromosomeLength: Int? = nil,
        widthInPixels: Int
    ) {
        let width = max(1, widthInPixels)
        self.chromosome = chromosome
        self.chromosomeLength = chromosomeLength ?? Int(ceil(end))
        self.widthInPixels = width
        self.origin = start
        self.scale = (end - start) / Double(width)
    }

    // MARK: - Coordinate Conversion

    /// Converts a screen X coordinate to a genomic position.
    ///
    /// - Parameter screenX: X coordinate in pixels from the left edge
    /// - Returns: Genomic position in base pairs
    public func genomicPosition(for screenX: CGFloat) -> Double {
        origin + Double(screenX) * scale
    }

    /// Converts a genomic position to a screen X coordinate.
    ///
    /// - Parameter genomicPos: Position in base pairs
    /// - Returns: X coordinate in pixels from the left edge
    public func screenPosition(for genomicPos: Double) -> CGFloat {
        CGFloat((genomicPos - origin) / scale)
    }

    /// Converts a genomic range to a screen rectangle.
    ///
    /// - Parameters:
    ///   - start: Start position in base pairs
    ///   - end: End position in base pairs
    ///   - y: Y coordinate for the rectangle
    ///   - height: Height of the rectangle
    /// - Returns: Screen rectangle
    public func screenRect(
        for start: Double,
        end: Double,
        y: CGFloat,
        height: CGFloat
    ) -> CGRect {
        let x1 = screenPosition(for: start)
        let x2 = screenPosition(for: end)
        return CGRect(x: x1, y: y, width: x2 - x1, height: height)
    }

    // MARK: - Navigation

    /// Jumps to a specific genomic region.
    ///
    /// - Parameters:
    ///   - start: Start position in base pairs
    ///   - end: End position in base pairs
    public func jumpTo(start: Double, end: Double) {
        let clampedStart = max(0, start)
        let clampedEnd = min(Double(chromosomeLength), end)

        guard clampedEnd > clampedStart else { return }

        self.origin = clampedStart
        self.scale = (clampedEnd - clampedStart) / Double(widthInPixels)
    }

    /// Jumps to a genomic region.
    ///
    /// - Parameter region: The genomic region to display
    public func jumpTo(region: GenomicRegion) {
        jumpTo(start: Double(region.start), end: Double(region.end))
    }

    /// Centers the view on a specific position.
    ///
    /// - Parameter position: Position in base pairs to center on
    public func centerOn(position: Double) {
        let halfWidth = windowLength / 2
        let newStart = position - halfWidth
        let newEnd = position + halfWidth
        jumpTo(start: newStart, end: newEnd)
    }

    /// Pans the view by a number of pixels.
    ///
    /// - Parameter deltaPixels: Number of pixels to pan (positive = right)
    public func pan(by deltaPixels: CGFloat) {
        let deltaBP = Double(deltaPixels) * scale
        let newOrigin = origin + deltaBP

        // Clamp to chromosome bounds
        let maxOrigin = Double(chromosomeLength) - windowLength
        self.origin = max(0, min(maxOrigin, newOrigin))
    }

    // MARK: - Zoom

    /// Zooms in by a factor, centered on the current view.
    ///
    /// - Parameter factor: Zoom factor (2.0 = double zoom)
    public func zoomIn(factor: Double = 2.0) {
        zoomBy(factor: factor)
    }

    /// Zooms out by a factor, centered on the current view.
    ///
    /// - Parameter factor: Zoom factor (2.0 = half zoom)
    public func zoomOut(factor: Double = 2.0) {
        zoomBy(factor: 1.0 / factor)
    }

    /// Zooms centered on a specific screen position.
    ///
    /// - Parameters:
    ///   - factor: Zoom factor (> 1 = zoom in, < 1 = zoom out)
    ///   - screenX: Screen X coordinate to center zoom on
    public func zoom(by factor: Double, centeredAt screenX: CGFloat) {
        let centerBP = genomicPosition(for: screenX)
        let newScale = scale / factor

        // Enforce minimum visible range
        let minScale = Double(Self.minBP) / Double(widthInPixels)
        let maxScale = Double(chromosomeLength) / Double(widthInPixels)
        let clampedScale = max(minScale, min(maxScale, newScale))

        self.scale = clampedScale

        // Adjust origin to keep centerBP at the same screen position
        let newOrigin = centerBP - Double(screenX) * clampedScale
        let maxOrigin = Double(chromosomeLength) - windowLength
        self.origin = max(0, min(maxOrigin, newOrigin))
    }

    /// Zooms to fit the entire chromosome.
    public func zoomToFit() {
        self.origin = 0
        self.scale = Double(chromosomeLength) / Double(widthInPixels)
    }

    /// Zooms to a specific zoom level.
    ///
    /// - Parameter level: Target zoom level (0 to maxZoom)
    public func setZoom(level: Int) {
        let clampedLevel = max(0, min(Self.maxZoom, level))
        let center = origin + windowLength / 2

        // Calculate scale for zoom level (from IGV)
        // Higher zoom = more detail = smaller scale
        let newScale = Double(chromosomeLength) /
            (Double(widthInPixels) * pow(2.0, Double(clampedLevel)))

        let minScale = Double(Self.minBP) / Double(widthInPixels)
        self.scale = max(minScale, newScale)

        // Re-center
        centerOn(position: center)
    }

    private func zoomBy(factor: Double) {
        let center = origin + windowLength / 2
        let newWindowLength = windowLength / factor

        // Enforce minimum visible range
        let minWindow = Double(Self.minBP)
        let maxWindow = Double(chromosomeLength)
        let clampedWindow = max(minWindow, min(maxWindow, newWindowLength))

        self.scale = clampedWindow / Double(widthInPixels)
        centerOn(position: center)
    }

    /// Calculates the current zoom level based on visible range.
    ///
    /// Based on IGV's ReferenceFrame.java calculateZoom() method.
    private func calculateZoom() -> Int {
        let windowLen = ceil(end) - origin

        if windowLen >= Double(chromosomeLength) {
            return 0
        }

        // From IGV: zoom = log2((chrLength / windowLength) * (width / binsPerTile))
        let ratio = (Double(chromosomeLength) / windowLen) *
            (Double(widthInPixels) / Double(Self.binsPerTile))
        let exactZoom = log2(ratio)

        return min(Self.maxZoom, max(0, Int(ceil(exactZoom))))
    }

    // MARK: - View Updates

    /// Updates the view width when the window resizes.
    ///
    /// - Parameter newWidth: New width in pixels
    public func updateWidth(_ newWidth: Int) {
        guard newWidth > 0 else { return }

        // Maintain the same genomic range, adjust scale
        let currentWindow = windowLength
        self.widthInPixels = newWidth
        self.scale = currentWindow / Double(newWidth)
    }

    /// Updates the chromosome context.
    ///
    /// - Parameters:
    ///   - chromosome: New chromosome name
    ///   - length: New chromosome length
    public func setChromosome(_ chromosome: String, length: Int) {
        self.chromosome = chromosome
        self.chromosomeLength = length
        zoomToFit()
    }

    // MARK: - Tile Calculation

    /// Returns the tile indices visible in the current view.
    ///
    /// - Returns: Range of tile indices
    public func visibleTileIndices() -> Range<Int> {
        let startTile = Int(floor(origin / Double(Self.binsPerTile) / scale))
        let endTile = Int(ceil(end / Double(Self.binsPerTile) / scale))
        return startTile..<(endTile + 1)
    }

    /// Returns the genomic range covered by a tile.
    ///
    /// - Parameter tileIndex: Index of the tile
    /// - Returns: Genomic range in base pairs
    public func rangeForTile(_ tileIndex: Int) -> Range<Int> {
        let tileWidth = Double(Self.binsPerTile) * scale
        let start = Int(Double(tileIndex) * tileWidth)
        let end = Int(Double(tileIndex + 1) * tileWidth)
        return start..<min(end, chromosomeLength)
    }

    // MARK: - Visibility Checks

    /// Checks if a genomic range is visible in the current view.
    ///
    /// - Parameters:
    ///   - start: Start position in base pairs
    ///   - end: End position in base pairs
    /// - Returns: True if any part of the range is visible
    public func isVisible(start: Double, end: Double) -> Bool {
        end > origin && start < self.end
    }

    /// Checks if a genomic region is visible.
    ///
    /// - Parameter region: The genomic region to check
    /// - Returns: True if any part of the region is visible
    public func isVisible(region: GenomicRegion) -> Bool {
        region.chromosome == chromosome &&
        isVisible(start: Double(region.start), end: Double(region.end))
    }
}

// MARK: - Equatable

extension ReferenceFrame: Equatable {
    public static func == (lhs: ReferenceFrame, rhs: ReferenceFrame) -> Bool {
        lhs.chromosome == rhs.chromosome &&
        lhs.origin == rhs.origin &&
        lhs.scale == rhs.scale &&
        lhs.widthInPixels == rhs.widthInPixels
    }
}

// MARK: - CustomStringConvertible

extension ReferenceFrame: CustomStringConvertible {
    public var description: String {
        let startStr = formatPosition(Int(origin))
        let endStr = formatPosition(Int(end))
        return "\(chromosome):\(startStr)-\(endStr) (\(String(format: "%.2f", scale)) bp/px, zoom \(zoom))"
    }

    private func formatPosition(_ position: Int) -> String {
        if position >= 1_000_000 {
            return String(format: "%.2fMb", Double(position) / 1_000_000)
        } else if position >= 1_000 {
            return String(format: "%.2fKb", Double(position) / 1_000)
        } else {
            return "\(position)"
        }
    }
}
