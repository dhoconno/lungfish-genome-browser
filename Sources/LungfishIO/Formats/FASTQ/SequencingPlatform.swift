// SequencingPlatform.swift - Sequencing platform identification and capabilities
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation

/// Identifies the sequencing platform that generated a FASTQ dataset.
///
/// Used to select platform-appropriate adapter contexts, error rates,
/// and demultiplexing strategies.
public enum SequencingPlatform: String, Codable, Sendable, CaseIterable {
    case illumina
    case oxfordNanopore
    case pacbio
    case element
    case ultima
    case mgi
    case unknown

    /// Human-readable display name.
    public var displayName: String {
        switch self {
        case .illumina:       return "Illumina"
        case .oxfordNanopore: return "Oxford Nanopore"
        case .pacbio:         return "PacBio"
        case .element:        return "Element Biosciences"
        case .ultima:         return "Ultima Genomics"
        case .mgi:            return "MGI / DNBSEQ"
        case .unknown:        return "Unknown"
        }
    }

    /// Whether reads can appear in either orientation (forward or reverse complement).
    ///
    /// Long-read platforms (ONT, PacBio) sequence both strands randomly;
    /// short-read platforms always read from a defined primer.
    public var readsCanBeReverseComplemented: Bool {
        switch self {
        case .oxfordNanopore, .pacbio: return true
        default: return false
        }
    }

    /// Whether this platform demultiplexes via separate index reads
    /// (i.e., demux is done before the user receives FASTQ files).
    ///
    /// When true, the app only needs to trim residual adapter read-through,
    /// not perform barcode-based demultiplexing.
    public var indexesInSeparateReads: Bool {
        switch self {
        case .illumina, .element, .ultima, .mgi: return true
        case .oxfordNanopore, .pacbio: return false
        default: return false
        }
    }

    /// Whether poly-G trimming may be needed (two-color SBS platforms).
    ///
    /// On NextSeq/NovaSeq (Illumina) and AVITI (Element), no-signal clusters
    /// produce runs of G at read ends.
    public var mayNeedPolyGTrimming: Bool {
        switch self {
        case .illumina, .element: return true
        default: return false
        }
    }

    /// Default poly-G trim quality threshold for two-color platforms.
    ///
    /// cutadapt `--nextseq-trim=N` uses this quality score to trim trailing
    /// poly-G artifacts. Only meaningful when `mayNeedPolyGTrimming` is true.
    /// Returns nil for platforms that don't need poly-G trimming.
    public var defaultPolyGTrimQuality: Int? {
        mayNeedPolyGTrimming ? 20 : nil
    }

    /// Recommended cutadapt error rate for this platform.
    ///
    /// ONT has higher error rates at read ends / adapter junctions (~5-10%),
    /// but 0.20 is overly permissive and risks false barcode matches.
    /// 0.15 balances sensitivity with specificity for noisy long reads.
    /// PacBio HiFi and short-read platforms are Q30+ (~0.1% error).
    public var recommendedErrorRate: Double {
        switch self {
        case .oxfordNanopore: return 0.15
        default:              return 0.10
        }
    }

    /// Recommended minimum overlap for cutadapt barcode matching.
    ///
    /// Short-read platforms use 5 bp minimum to reduce spurious matches
    /// while retaining sensitivity for standard 6-8 bp index sequences.
    public var recommendedMinimumOverlap: Int {
        switch self {
        case .oxfordNanopore: return 20
        case .pacbio:         return 14
        default:              return 5
        }
    }

    /// Maps legacy vendor strings to platform enum values.
    public init(vendor: String) {
        switch vendor.lowercased().replacingOccurrences(of: "_", with: "-") {
        case "illumina":
            self = .illumina
        case "oxford-nanopore", "oxfordnanopore", "ont":
            self = .oxfordNanopore
        case "pacbio", "pacific-biosciences":
            self = .pacbio
        case "element", "element-biosciences":
            self = .element
        case "ultima", "ultima-genomics":
            self = .ultima
        case "mgi", "bgi", "dnbseq", "mgi-tech":
            self = .mgi
        default:
            self = .unknown
        }
    }
}
