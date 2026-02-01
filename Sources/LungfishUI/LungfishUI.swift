// LungfishUI - Rendering and track system for Lungfish Genome Browser
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import LungfishCore
import AppKit

/// LungfishUI provides rendering and track visualization capabilities.
///
/// ## Overview
///
/// This module contains:
/// - **Rendering**: Core rendering infrastructure (ReferenceFrame, TileCache, MetalRenderer)
/// - **Tracks**: Track types (SequenceTrack, FeatureTrack, AlignmentTrack, CoverageTrack)
/// - **Renderers**: Specialized rendering components
///
/// ## Key Types
///
/// - ``ReferenceFrame``: Coordinate system following IGV's model
/// - ``Track``: Protocol for track rendering
/// - ``TileCache``: Tile-based caching for efficient rendering
///
/// ## Track Types
///
/// - ``SequenceTrack``: Reference sequence with translation frames
/// - ``FeatureTrack``: Annotation features with row packing
/// - ``AlignmentTrack``: BAM/CRAM reads with coverage
/// - ``CoverageTrack``: Signal data (BigWig)
/// - ``VariantTrack``: VCF variants
///
/// ## Example
///
/// ```swift
/// // Create a reference frame
/// let frame = ReferenceFrame(
///     chromosome: "chr1",
///     start: 0,
///     end: 10000,
///     pixelWidth: 1000
/// )
///
/// // Create a sequence track
/// let track = SequenceTrack(sequence: mySequence)
/// track.render(in: context, frame: frame, rect: rect)
/// ```
