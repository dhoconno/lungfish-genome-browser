// RowPacker.swift - Feature packing algorithm
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Owner: Track Rendering Engineer (Role 04)
// Reference: IGV's FeaturePacker pattern

import Foundation
import LungfishCore

/// Result of packing a feature into a row.
public struct PackedFeature<T>: Sendable where T: Sendable {
    /// The original feature
    public let feature: T

    /// Row index (0-based)
    public let row: Int

    /// Screen start position
    public let screenStart: CGFloat

    /// Screen end position
    public let screenEnd: CGFloat

    /// Creates a packed feature.
    public init(feature: T, row: Int, screenStart: CGFloat, screenEnd: CGFloat) {
        self.feature = feature
        self.row = row
        self.screenStart = screenStart
        self.screenEnd = screenEnd
    }
}

/// Protocol for features that can be packed into rows.
public protocol Packable: Sendable {
    /// Start position in base pairs
    var start: Int { get }

    /// End position in base pairs
    var end: Int { get }
}

/// Extension to make SequenceAnnotation packable
extension SequenceAnnotation: Packable {
    public var start: Int {
        intervals.first?.start ?? 0
    }

    public var end: Int {
        intervals.last?.end ?? 0
    }
}

/// Packs features into rows to avoid visual overlap.
///
/// Uses a first-fit algorithm to assign features to rows:
/// 1. Sort features by start position
/// 2. For each feature, find the first row where it fits
/// 3. If no row fits, create a new row
///
/// ## Example
/// ```swift
/// let packer = RowPacker<SequenceAnnotation>(minGap: 5)
/// let packedFeatures = packer.pack(features, in: frame)
///
/// for packed in packedFeatures {
///     let y = baseY + CGFloat(packed.row) * rowHeight
///     drawFeature(packed.feature, at: y)
/// }
/// ```
public struct RowPacker<T: Packable> {

    // MARK: - Configuration

    /// Minimum gap between features in the same row (pixels)
    public var minGap: CGFloat

    /// Maximum number of rows before collapsing
    public var maxRows: Int

    // MARK: - Initialization

    /// Creates a row packer.
    ///
    /// - Parameters:
    ///   - minGap: Minimum gap between features in pixels (default: 5)
    ///   - maxRows: Maximum rows before collapsing (default: 100)
    public init(minGap: CGFloat = 5, maxRows: Int = 100) {
        self.minGap = minGap
        self.maxRows = maxRows
    }

    // MARK: - Packing

    /// Packs features into rows.
    ///
    /// - Parameters:
    ///   - features: Features to pack
    ///   - frame: Reference frame for coordinate conversion
    /// - Returns: Array of packed features with row assignments
    @MainActor
    public func pack(_ features: [T], in frame: ReferenceFrame) -> [PackedFeature<T>] {
        // Filter to visible features and sort by start
        let visibleFeatures = features
            .filter { frame.isVisible(start: Double($0.start), end: Double($0.end)) }
            .sorted { $0.start < $1.start }

        guard !visibleFeatures.isEmpty else { return [] }

        // Track the rightmost position in each row
        var rowEnds: [CGFloat] = []
        var result: [PackedFeature<T>] = []

        for feature in visibleFeatures {
            let screenStart = frame.screenPosition(for: Double(feature.start))
            let screenEnd = frame.screenPosition(for: Double(feature.end))

            // Find first available row
            var assignedRow = -1
            for (rowIndex, rowEnd) in rowEnds.enumerated() {
                if screenStart >= rowEnd + minGap {
                    assignedRow = rowIndex
                    break
                }
            }

            // Create new row if needed
            if assignedRow == -1 {
                if rowEnds.count < maxRows {
                    assignedRow = rowEnds.count
                    rowEnds.append(0)
                } else {
                    // Overflow - pack into last row
                    assignedRow = maxRows - 1
                }
            }

            // Update row end position
            rowEnds[assignedRow] = screenEnd

            result.append(PackedFeature(
                feature: feature,
                row: assignedRow,
                screenStart: screenStart,
                screenEnd: screenEnd
            ))
        }

        return result
    }

    /// Packs features and returns the number of rows used.
    ///
    /// - Parameters:
    ///   - features: Features to pack
    ///   - frame: Reference frame for coordinate conversion
    /// - Returns: Tuple of (packed features, row count)
    @MainActor
    public func packWithRowCount(_ features: [T], in frame: ReferenceFrame) -> (features: [PackedFeature<T>], rowCount: Int) {
        let packed = pack(features, in: frame)
        let rowCount = (packed.map { $0.row }.max() ?? -1) + 1
        return (packed, rowCount)
    }
}

// MARK: - Density Calculation

/// Calculates feature density for collapsed view.
public struct FeatureDensityCalculator {

    /// Calculates density histogram for features.
    ///
    /// - Parameters:
    ///   - features: Features to analyze
    ///   - frame: Reference frame
    ///   - binCount: Number of bins across the view
    /// - Returns: Array of density values (features per bin)
    @MainActor
    public static func calculateDensity<T: Packable>(
        for features: [T],
        in frame: ReferenceFrame,
        binCount: Int = 100
    ) -> [Int] {
        var density = [Int](repeating: 0, count: binCount)

        let startBP = Int(frame.origin)
        let endBP = Int(frame.end)
        let binSize = Double(endBP - startBP) / Double(binCount)

        for feature in features {
            // Check if feature overlaps view
            guard feature.end > startBP && feature.start < endBP else { continue }

            // Find bins that this feature covers
            let featureStart = max(0, Int(Double(feature.start - startBP) / binSize))
            let featureEnd = min(binCount - 1, Int(Double(feature.end - startBP) / binSize))

            for bin in featureStart...featureEnd {
                density[bin] += 1
            }
        }

        return density
    }
}

// MARK: - Interval Tree (Future Optimization)

/// Placeholder for interval tree optimization.
/// Will be implemented if performance requires it.
public struct IntervalTree<T> {
    // TODO: Implement for O(log n) feature lookup
}
