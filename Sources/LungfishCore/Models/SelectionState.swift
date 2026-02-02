// SelectionState.swift - Selection state for genomic regions and annotations
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation

/// Represents the current selection state in the genome browser.
///
/// The selection state can represent three distinct states:
/// - No selection
/// - A genomic region selection (chromosome coordinates)
/// - An annotation selection (a specific feature)
///
/// This type is thread-safe and can be safely passed across actor boundaries.
///
/// ## Example
/// ```swift
/// // No selection
/// let empty = SelectionState.none
///
/// // Region selection
/// let region = SelectionState.region(chromosome: "chr1", start: 1000, end: 2000)
///
/// // Annotation selection
/// let annotation = SequenceAnnotation(type: .gene, name: "BRCA1", start: 0, end: 100)
/// let selected = SelectionState.annotation(annotation)
/// ```
public enum SelectionState: Sendable {
    /// No selection active
    case none

    /// A genomic region is selected
    ///
    /// - Parameters:
    ///   - chromosome: The chromosome or sequence name
    ///   - start: Start position (0-based, inclusive)
    ///   - end: End position (0-based, exclusive)
    case region(chromosome: String, start: Int, end: Int)

    /// An annotation is selected
    ///
    /// - Parameter annotation: The selected annotation
    case annotation(SequenceAnnotation)
}

// MARK: - Equatable

extension SelectionState: Equatable {
    public static func == (lhs: SelectionState, rhs: SelectionState) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case let (.region(lhsChrom, lhsStart, lhsEnd), .region(rhsChrom, rhsStart, rhsEnd)):
            return lhsChrom == rhsChrom && lhsStart == rhsStart && lhsEnd == rhsEnd
        case let (.annotation(lhsAnnotation), .annotation(rhsAnnotation)):
            // Compare annotations by their unique identifier
            return lhsAnnotation.id == rhsAnnotation.id
        default:
            return false
        }
    }
}

// MARK: - Computed Properties

extension SelectionState {
    /// Whether any selection is active
    public var hasSelection: Bool {
        switch self {
        case .none:
            return false
        case .region, .annotation:
            return true
        }
    }

    /// Whether the selection is a region
    public var isRegionSelection: Bool {
        if case .region = self {
            return true
        }
        return false
    }

    /// Whether the selection is an annotation
    public var isAnnotationSelection: Bool {
        if case .annotation = self {
            return true
        }
        return false
    }

    /// Returns the selected annotation, if any
    public var selectedAnnotation: SequenceAnnotation? {
        if case .annotation(let annotation) = self {
            return annotation
        }
        return nil
    }

    /// Returns the selected region as a GenomicRegion, if applicable
    ///
    /// For region selections, returns the region directly.
    /// For annotation selections, returns nil (annotations don't store chromosome context).
    public var selectedRegion: GenomicRegion? {
        switch self {
        case .none:
            return nil
        case .region(let chromosome, let start, let end):
            return GenomicRegion(chromosome: chromosome, start: start, end: end)
        case .annotation:
            // Annotations don't store chromosome, so we can't create a full GenomicRegion
            // This would need chromosome context from elsewhere
            return nil
        }
    }

    /// The length of the selection in bases, if applicable
    public var selectionLength: Int? {
        switch self {
        case .none:
            return nil
        case .region(_, let start, let end):
            return end - start
        case .annotation(let annotation):
            return annotation.totalLength
        }
    }
}

// MARK: - CustomStringConvertible

extension SelectionState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "No selection"
        case .region(let chromosome, let start, let end):
            return "Region: \(chromosome):\(start)-\(end)"
        case .annotation(let annotation):
            return "Annotation: \(annotation.name) (\(annotation.type.rawValue))"
        }
    }
}
