// FormatDescriptor.swift - Metadata describing a file format
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Part of the Format Registry system (DESIGN-003)

import Foundation
import LungfishCore

/// Describes a file format's properties and capabilities.
///
/// FormatDescriptor provides comprehensive metadata about a file format including:
/// - Human-readable name and description
/// - File extensions and MIME types
/// - Magic bytes for format detection
/// - Capabilities that documents in this format provide
/// - Compression support
/// - Index requirements
///
/// ## Usage
/// ```swift
/// let fastaDescriptor = FormatDescriptor(
///     identifier: .fasta,
///     displayName: "FASTA",
///     formatDescription: "Simple sequence format",
///     extensions: ["fa", "fasta", "fna"],
///     capabilities: .nucleotideSequence
/// )
/// ```
public struct FormatDescriptor: Sendable {

    // MARK: - Properties

    /// Unique identifier for this format
    public let identifier: FormatIdentifier

    /// Human-readable display name (e.g., "FASTA", "GenBank")
    public let displayName: String

    /// Brief description of the format
    public let formatDescription: String

    /// File extensions associated with this format (without leading dot)
    public let extensions: Set<String>

    /// MIME types for this format
    public let mimeTypes: Set<String>

    /// Magic bytes for format detection (first N bytes of file)
    ///
    /// If non-nil, files starting with these bytes are assumed to be this format.
    /// Used for binary formats like BAM, BigWig, etc.
    public let magicBytes: Data?

    /// Capabilities that documents in this format provide
    ///
    /// This describes what data the format can contain, such as nucleotide
    /// sequences, quality scores, annotations, etc.
    public let capabilities: DocumentCapability

    /// Whether this format supports compression
    public let supportsCompression: Bool

    /// Compression types supported by this format
    public let supportedCompression: Set<CompressionType>

    /// Whether this format requires an external index for random access
    public let requiresIndex: Bool

    /// Associated index format if applicable (e.g., .bai for .bam)
    public let indexFormat: FormatIdentifier?

    /// Whether this format is binary (vs text-based)
    public let isBinary: Bool

    /// Whether we can read/import this format
    public let canRead: Bool

    /// Whether we can write/export this format
    public let canWrite: Bool

    /// SF Symbol name for UI display
    public let iconName: String

    /// Whether this format supports QuickLook preview
    public let supportsQuickLook: Bool

    /// UI category for sidebar grouping and display
    public let uiCategory: UICategory

    // MARK: - Initialization

    /// Creates a format descriptor with all properties.
    ///
    /// - Parameters:
    ///   - identifier: Unique identifier for this format
    ///   - displayName: Human-readable name
    ///   - formatDescription: Brief description of the format
    ///   - extensions: File extensions (without leading dot)
    ///   - mimeTypes: MIME types for this format
    ///   - magicBytes: Magic bytes for format detection
    ///   - capabilities: Capabilities documents in this format provide
    ///   - supportsCompression: Whether the format can be compressed
    ///   - supportedCompression: Types of compression supported
    ///   - requiresIndex: Whether an index is required for random access
    ///   - indexFormat: Associated index format identifier
    ///   - isBinary: Whether the format is binary
    ///   - canRead: Whether we support reading this format
    ///   - canWrite: Whether we support writing this format
    ///   - iconName: SF Symbol name for UI display (defaults to category icon)
    ///   - supportsQuickLook: Whether this format supports QuickLook preview
    ///   - uiCategory: UI category for sidebar grouping
    public init(
        identifier: FormatIdentifier,
        displayName: String,
        formatDescription: String,
        extensions: Set<String>,
        mimeTypes: Set<String> = [],
        magicBytes: Data? = nil,
        capabilities: DocumentCapability,
        supportsCompression: Bool = true,
        supportedCompression: Set<CompressionType> = [.gzip],
        requiresIndex: Bool = false,
        indexFormat: FormatIdentifier? = nil,
        isBinary: Bool = false,
        canRead: Bool = true,
        canWrite: Bool = true,
        iconName: String? = nil,
        supportsQuickLook: Bool = false,
        uiCategory: UICategory = .unknown
    ) {
        self.identifier = identifier
        self.displayName = displayName
        self.formatDescription = formatDescription
        self.extensions = Set(extensions.map { $0.lowercased() })
        self.mimeTypes = mimeTypes
        self.magicBytes = magicBytes
        self.capabilities = capabilities
        self.supportsCompression = supportsCompression
        self.supportedCompression = supportedCompression
        self.requiresIndex = requiresIndex
        self.indexFormat = indexFormat
        self.isBinary = isBinary
        self.canRead = canRead
        self.canWrite = canWrite
        self.iconName = iconName ?? uiCategory.iconName
        self.supportsQuickLook = supportsQuickLook
        self.uiCategory = uiCategory
    }

    // MARK: - Convenience Methods

    /// Checks if this format can be detected by magic bytes
    public var hasMagicBytes: Bool {
        magicBytes != nil && !(magicBytes?.isEmpty ?? true)
    }

    /// Checks if a URL's extension matches this format
    ///
    /// - Parameter url: The file URL to check
    /// - Returns: true if the extension matches
    public func matchesExtension(_ url: URL) -> Bool {
        let ext = url.pathExtension.lowercased()
        if extensions.contains(ext) {
            return true
        }

        // Check compound extensions like .fa.gz
        let compoundExt = url.deletingPathExtension().pathExtension.lowercased()
        if !compoundExt.isEmpty {
            return extensions.contains(compoundExt)
        }

        return false
    }

    /// Gets the primary (first) extension for this format
    public var primaryExtension: String {
        extensions.sorted().first ?? identifier.id
    }
}

// MARK: - UICategory

/// UI category for format grouping in sidebar and other views.
public enum UICategory: String, Sendable, CaseIterable, Codable {
    /// Sequence data (FASTA, FASTQ, GenBank)
    case sequence

    /// Annotation data (GFF3, GTF, BED)
    case annotation

    /// Alignment data (BAM, SAM, CRAM)
    case alignment

    /// Variant data (VCF, BCF)
    case variant

    /// Coverage/signal data (BigWig, bedGraph)
    case coverage

    /// Index files (FAI, BAI, TBI)
    case index

    /// Document files (PDF, text, markdown)
    case document

    /// Image files (PNG, JPEG, TIFF)
    case image

    /// Compressed archives
    case compressed

    /// Reference genome bundles (.lungfishref)
    case referenceBundle

    /// Unknown or unrecognized format
    case unknown

    /// Human-readable display name
    public var displayName: String {
        switch self {
        case .sequence: return "Sequence"
        case .annotation: return "Annotation"
        case .alignment: return "Alignment"
        case .variant: return "Variant"
        case .coverage: return "Coverage"
        case .index: return "Index"
        case .document: return "Document"
        case .image: return "Image"
        case .compressed: return "Compressed"
        case .referenceBundle: return "Reference Bundle"
        case .unknown: return "Other"
        }
    }

    /// SF Symbol icon name for this category
    public var iconName: String {
        switch self {
        case .sequence: return "doc.text"
        case .annotation: return "list.bullet.rectangle"
        case .alignment: return "chart.bar"
        case .variant: return "chart.bar.xaxis"
        case .coverage: return "waveform.path.ecg"
        case .index: return "doc.badge.gearshape"
        case .document: return "doc.richtext"
        case .image: return "photo"
        case .compressed: return "archivebox"
        case .referenceBundle: return "cylinder.split.1x2"
        case .unknown: return "doc.questionmark"
        }
    }

    /// Whether files in this category are genomics formats
    public var isGenomicsCategory: Bool {
        switch self {
        case .sequence, .annotation, .alignment, .variant, .coverage, .index, .referenceBundle:
            return true
        case .document, .image, .compressed, .unknown:
            return false
        }
    }
}

// MARK: - CompressionType

/// Supported compression types for genomic files
public enum CompressionType: String, Sendable, CaseIterable, Codable {
    /// No compression
    case none

    /// Standard gzip compression (.gz)
    case gzip

    /// Block-gzip compression used by BAM/tabix (.bgz)
    case bgzf

    /// Zstandard compression (.zst)
    case zstd

    /// bzip2 compression (.bz2)
    case bzip2

    /// XZ/LZMA compression (.xz)
    case xz

    /// File extension for this compression type
    public var fileExtension: String? {
        switch self {
        case .none: return nil
        case .gzip: return "gz"
        case .bgzf: return "bgz"
        case .zstd: return "zst"
        case .bzip2: return "bz2"
        case .xz: return "xz"
        }
    }

    /// Detects compression type from file extension
    ///
    /// - Parameter url: File URL to check
    /// - Returns: Detected compression type
    public static func detect(from url: URL) -> CompressionType {
        switch url.pathExtension.lowercased() {
        case "gz": return .gzip
        case "bgz": return .bgzf
        case "zst", "zstd": return .zstd
        case "bz2": return .bzip2
        case "xz": return .xz
        default: return .none
        }
    }
}

// MARK: - CustomStringConvertible

extension FormatDescriptor: CustomStringConvertible {
    public var description: String {
        "\(displayName) (\(extensions.sorted().joined(separator: ", ")))"
    }
}
