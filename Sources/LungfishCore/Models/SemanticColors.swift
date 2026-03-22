// SemanticColors.swift - Centralized semantic color definitions
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit

/// Centralized semantic color definitions for the Lungfish application.
///
/// All UI components should reference these canonical colors instead of
/// defining their own RGB literals. This eliminates the drift that occurs
/// when base colors or status colors are duplicated across files.
///
/// ## DNA Base Colors
///
/// The base colors follow the **IGV standard** (IGV's `SequenceTrack.java`):
///
/// | Base | Color       | RGB                  | Hex      |
/// |------|-------------|----------------------|----------|
/// | A    | Green       | (0.0, 0.8, 0.0)     | #00CC00  |
/// | T    | Red         | (0.8, 0.0, 0.0)     | #CC0000  |
/// | G    | Orange/Gold | (1.0, 0.7, 0.0)     | #FFB300  |
/// | C    | Blue        | (0.0, 0.0, 0.8)     | #0000CC  |
/// | N    | Gray        | (0.53, 0.53, 0.53)  | #888888  |
/// | U    | Red (=T)    | (0.8, 0.0, 0.0)     | #CC0000  |
///
/// These are mid-saturation colors that read well on both light and dark
/// backgrounds without overpowering surrounding UI elements.
///
/// ## Status Colors
///
/// Status colors use `NSColor.system*` variants, which adapt automatically
/// to light/dark mode and increased-contrast accessibility settings.
///
/// ## Quality Score Colors
///
/// Quality thresholds follow standard Phred conventions:
/// - Q >= 30: High quality (green)
/// - Q 20-29: Medium quality (yellow)
/// - Q 10-19: Low quality (orange)
/// - Q < 10:  Very low quality (red)
///
/// ## Usage
///
/// ```swift
/// // DNA bases
/// let color = SemanticColors.DNA.color(for: "A")
///
/// // Status indicators
/// view.layer?.backgroundColor = SemanticColors.Status.success.cgColor
///
/// // Quality overlays
/// let qColor = SemanticColors.Quality.color(for: phredScore)
/// ```
public enum SemanticColors: Sendable {

    // MARK: - DNA Base Colors

    /// Standard IGV-convention DNA base colors.
    ///
    /// These are the canonical color definitions used throughout the
    /// application for nucleotide rendering. `ReadTrackRenderer`,
    /// `BaseColors`, `FASTQPalette`, and `SequenceAppearance.default`
    /// should all derive from these values.
    public enum DNA: Sendable {

        /// Adenine -- green (#00CC00).
        public static let baseA = NSColor(srgbRed: 0.0, green: 0.8, blue: 0.0, alpha: 1.0)

        /// Thymine -- red (#CC0000).
        public static let baseT = NSColor(srgbRed: 0.8, green: 0.0, blue: 0.0, alpha: 1.0)

        /// Guanine -- orange/gold (#FFB300).
        public static let baseG = NSColor(srgbRed: 1.0, green: 0.7, blue: 0.0, alpha: 1.0)

        /// Cytosine -- blue (#0000CC).
        public static let baseC = NSColor(srgbRed: 0.0, green: 0.0, blue: 0.8, alpha: 1.0)

        /// Unknown/ambiguous base -- gray (#888888).
        public static let baseN = NSColor(srgbRed: 0.53, green: 0.53, blue: 0.53, alpha: 1.0)

        /// Uracil (RNA) -- same as thymine.
        public static let baseU = baseT

        /// Returns the canonical color for a given base character.
        ///
        /// Handles both upper- and lowercase input. Returns `baseN` for
        /// unrecognized characters.
        ///
        /// - Parameter base: A nucleotide character (A, T, G, C, U, N).
        /// - Returns: The corresponding `NSColor`.
        public static func color(for base: Character) -> NSColor {
            switch base {
            case "A", "a": return baseA
            case "T", "t": return baseT
            case "G", "g": return baseG
            case "C", "c": return baseC
            case "U", "u": return baseU
            case "N", "n": return baseN
            default:       return baseN
            }
        }

        /// Pre-built dictionary mapping base characters to colors.
        ///
        /// Useful for tight rendering loops where dictionary lookup is
        /// preferable to a switch statement.
        public static let colorMap: [Character: NSColor] = [
            "A": baseA, "a": baseA,
            "T": baseT, "t": baseT,
            "C": baseC, "c": baseC,
            "G": baseG, "g": baseG,
            "U": baseU, "u": baseU,
            "N": baseN, "n": baseN,
        ]

        /// The default hex strings for `SequenceAppearance`.
        ///
        /// These map to the same RGB values as the `NSColor` properties
        /// above, expressed as hex for Codable persistence.
        public static let defaultHexColors: [String: String] = [
            "A": "#00CC00",
            "T": "#CC0000",
            "G": "#FFB300",
            "C": "#0000CC",
            "N": "#888888",
            "U": "#CC0000",
        ]
    }

    // MARK: - Status Colors

    /// Semantic status indicator colors.
    ///
    /// These use `NSColor.system*` variants which automatically adapt
    /// to light mode, dark mode, and increased-contrast accessibility.
    public enum Status: Sendable {

        /// Operation succeeded, item passed validation.
        public static let success: NSColor = .systemGreen

        /// Operation failed, item rejected.
        public static let failure: NSColor = .systemRed

        /// Non-critical issue, needs attention.
        public static let warning: NSColor = .systemOrange

        /// Informational, neutral emphasis.
        public static let info: NSColor = .systemBlue
    }

    // MARK: - Quality Score Colors

    /// Phred quality score visualization colors.
    ///
    /// Follows the standard Q-score thresholds used in FASTQ analysis.
    public enum Quality: Sendable {

        /// Q >= 30 -- high quality.
        public static let high: NSColor = .systemGreen

        /// Q 20-29 -- medium quality.
        public static let medium: NSColor = .systemYellow

        /// Q 10-19 -- low quality.
        public static let low: NSColor = .systemOrange

        /// Q < 10 -- very low quality.
        public static let veryLow: NSColor = .systemRed

        /// Returns the appropriate color for a Phred quality score.
        ///
        /// - Parameter score: The Phred quality score (integer).
        /// - Returns: A quality-tier `NSColor`.
        public static func color(for score: Int) -> NSColor {
            if score >= 30 { return high }
            if score >= 20 { return medium }
            if score >= 10 { return low }
            return veryLow
        }
    }

    // MARK: - Annotation Type Colors

    /// Standard colors for genomic annotation feature types.
    ///
    /// These follow common genome browser conventions (UCSC, Ensembl).
    public enum Annotation: Sendable {

        /// Gene features.
        public static let gene = NSColor(srgbRed: 0.2, green: 0.6, blue: 0.2, alpha: 1.0)

        /// Coding sequence (CDS) features.
        public static let cds = NSColor(srgbRed: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)

        /// Exon features.
        public static let exon = NSColor(srgbRed: 0.6, green: 0.3, blue: 0.8, alpha: 1.0)

        /// mRNA features.
        public static let mRNA = NSColor(srgbRed: 0.8, green: 0.4, blue: 0.2, alpha: 1.0)

        /// Transcript features.
        public static let transcript = NSColor(srgbRed: 0.7, green: 0.5, blue: 0.3, alpha: 1.0)

        /// Miscellaneous features.
        public static let miscFeature = NSColor(srgbRed: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)

        /// Region features.
        public static let region = NSColor(srgbRed: 0.4, green: 0.7, blue: 0.7, alpha: 1.0)

        /// Primer features.
        public static let primer = NSColor(srgbRed: 0.2, green: 0.8, blue: 0.2, alpha: 1.0)

        /// Restriction site features.
        public static let restrictionSite = NSColor(srgbRed: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
    }
}
