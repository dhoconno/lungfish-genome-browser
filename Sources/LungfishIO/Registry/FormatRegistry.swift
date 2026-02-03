// FormatRegistry.swift - Central registry for file format handlers
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Part of the Format Registry system (DESIGN-003)

import Foundation
import LungfishCore

/// Central registry for all file format importers and exporters.
///
/// FormatRegistry is the single point of truth for:
/// - Available file formats and their metadata
/// - Format detection from file extensions and magic bytes
/// - Importer/exporter lookup
/// - Format capability queries
///
/// ## Thread Safety
/// FormatRegistry is implemented as an actor and is thread-safe.
///
/// ## Usage
/// ```swift
/// // Register a custom format
/// await FormatRegistry.shared.register(importer: MyCustomImporter())
///
/// // Detect format from file
/// let format = await FormatRegistry.shared.detectFormat(url: fileURL)
///
/// // Import a file
/// if let importer = await FormatRegistry.shared.importer(for: fileURL) {
///     let document = try await importer.importDocument(from: fileURL)
/// }
///
/// // Get all formats supporting specific capabilities
/// let formats = await FormatRegistry.shared.formats(supporting: .nucleotideSequence)
/// ```
public actor FormatRegistry {

    // MARK: - Singleton

    /// Shared registry instance
    public static let shared = FormatRegistry()

    // MARK: - Storage

    /// Registered format descriptors by identifier
    private var descriptors: [FormatIdentifier: FormatDescriptor]

    /// Registered importers by format identifier
    private var importers: [FormatIdentifier: any FormatImporter] = [:]

    /// Registered exporters by format identifier
    private var exporters: [FormatIdentifier: any FormatExporter] = [:]

    /// Extension to format identifier mapping for quick lookup
    private var extensionMap: [String: FormatIdentifier]

    /// MIME type to format identifier mapping
    private var mimeTypeMap: [String: FormatIdentifier]

    // MARK: - Initialization

    /// Creates a new format registry with built-in formats
    private init() {
        // Initialize with built-in format descriptors
        let builtInDescriptors = Self.createBuiltInDescriptors()

        self.descriptors = builtInDescriptors

        // Build extension and MIME type maps
        var extMap: [String: FormatIdentifier] = [:]
        var mimeMap: [String: FormatIdentifier] = [:]

        for descriptor in builtInDescriptors.values {
            for ext in descriptor.extensions {
                extMap[ext.lowercased()] = descriptor.identifier
            }
            for mimeType in descriptor.mimeTypes {
                mimeMap[mimeType.lowercased()] = descriptor.identifier
            }
        }

        self.extensionMap = extMap
        self.mimeTypeMap = mimeMap
    }

    // MARK: - Registration

    /// Register a format descriptor
    ///
    /// - Parameter descriptor: The format descriptor to register
    public func register(descriptor: FormatDescriptor) {
        descriptors[descriptor.identifier] = descriptor

        // Update extension map
        for ext in descriptor.extensions {
            extensionMap[ext.lowercased()] = descriptor.identifier
        }

        // Update MIME type map
        for mimeType in descriptor.mimeTypes {
            mimeTypeMap[mimeType.lowercased()] = descriptor.identifier
        }
    }

    /// Register an importer
    ///
    /// - Parameter importer: The format importer to register
    public func register(importer: any FormatImporter) {
        importers[importer.descriptor.identifier] = importer

        // Also register the descriptor if not already registered
        if descriptors[importer.descriptor.identifier] == nil {
            register(descriptor: importer.descriptor)
        }
    }

    /// Register an exporter
    ///
    /// - Parameter exporter: The format exporter to register
    public func register(exporter: any FormatExporter) {
        exporters[exporter.descriptor.identifier] = exporter

        // Also register the descriptor if not already registered
        if descriptors[exporter.descriptor.identifier] == nil {
            register(descriptor: exporter.descriptor)
        }
    }

    // MARK: - Lookup

    /// Get the format descriptor for an identifier
    ///
    /// - Parameter identifier: The format identifier
    /// - Returns: The format descriptor, or nil if not found
    public func descriptor(for identifier: FormatIdentifier) -> FormatDescriptor? {
        descriptors[identifier]
    }

    /// Get the importer for a format identifier
    ///
    /// - Parameter identifier: The format identifier
    /// - Returns: The importer, or nil if not available
    public func importer(for identifier: FormatIdentifier) -> (any FormatImporter)? {
        importers[identifier]
    }

    /// Get the importer for a file URL
    ///
    /// - Parameter url: The file URL
    /// - Returns: The importer, or nil if format not recognized
    public func importer(for url: URL) async -> (any FormatImporter)? {
        guard let format = await detectFormat(url: url) else {
            return nil
        }
        return importers[format]
    }

    /// Get the exporter for a format identifier
    ///
    /// - Parameter identifier: The format identifier
    /// - Returns: The exporter, or nil if not available
    public func exporter(for identifier: FormatIdentifier) -> (any FormatExporter)? {
        exporters[identifier]
    }

    /// Get all exporters that can handle a document
    ///
    /// - Parameter document: The document to export
    /// - Returns: Array of compatible exporters
    public func exporters(for document: LoadedDocument) -> [any FormatExporter] {
        exporters.values.filter { $0.canExport(document: document) }
    }

    /// Get all registered format identifiers
    public var registeredFormats: [FormatIdentifier] {
        Array(descriptors.keys)
    }

    /// Get all format descriptors
    public var allDescriptors: [FormatDescriptor] {
        Array(descriptors.values)
    }

    /// Get all formats that support specific capabilities
    ///
    /// - Parameter capabilities: Required capabilities
    /// - Returns: Format identifiers that provide all specified capabilities
    public func formats(supporting capabilities: DocumentCapability) -> [FormatIdentifier] {
        descriptors.values
            .filter { $0.capabilities.contains(capabilities) }
            .map(\.identifier)
    }

    /// Get all readable formats (have importers)
    public var readableFormats: [FormatIdentifier] {
        Array(importers.keys)
    }

    /// Get all writable formats (have exporters)
    public var writableFormats: [FormatIdentifier] {
        Array(exporters.keys)
    }

    // MARK: - Format Detection

    /// Detect the format of a file
    ///
    /// Detection priority:
    /// 1. File extension (including compound like .fa.gz)
    /// 2. Magic bytes
    /// 3. Content sniffing via importers
    ///
    /// - Parameter url: The file URL to detect
    /// - Returns: The detected format identifier, or nil if unknown
    public func detectFormat(url: URL) async -> FormatIdentifier? {
        // 1. Try by extension first (fastest)
        let ext = url.pathExtension.lowercased()

        // Handle compound extensions like .fa.gz
        let baseURL = url.deletingPathExtension()
        let compoundExt = baseURL.pathExtension.lowercased()

        if let format = extensionMap[ext] {
            return format
        }

        if !compoundExt.isEmpty, let format = extensionMap[compoundExt] {
            return format
        }

        // 2. Try magic bytes detection
        if let data = try? Data(contentsOf: url, options: .mappedIfSafe) {
            let header = data.prefix(32)

            for descriptor in descriptors.values {
                if let magic = descriptor.magicBytes,
                   !magic.isEmpty,
                   header.starts(with: magic) {
                    return descriptor.identifier
                }
            }
        }

        // 3. Try content sniffing via importers
        for (identifier, importer) in importers {
            if await importer.canImport(url: url) {
                return identifier
            }
        }

        return nil
    }

    /// Detect format from MIME type
    ///
    /// - Parameter mimeType: The MIME type string
    /// - Returns: The format identifier, or nil if not found
    public func formatForMimeType(_ mimeType: String) -> FormatIdentifier? {
        mimeTypeMap[mimeType.lowercased()]
    }

    // MARK: - Convenience Import/Export

    /// Import a document, auto-detecting format
    ///
    /// - Parameter url: The file URL to import
    /// - Returns: The loaded document
    /// - Throws: ImportError if format unknown or import fails
    public func importDocument(from url: URL) async throws -> LoadedDocument {
        guard let format = await detectFormat(url: url) else {
            throw ImportError.unknownFormat(url)
        }

        guard let importer = importers[format] else {
            throw ImportError.noImporterAvailable(format)
        }

        return try await importer.importDocument(from: url)
    }

    /// Import a document with progress reporting
    ///
    /// - Parameters:
    ///   - url: The file URL to import
    ///   - progress: Callback for progress updates
    /// - Returns: The loaded document
    /// - Throws: ImportError if format unknown or import fails
    public func importDocument(
        from url: URL,
        progress: @escaping @Sendable (Double) -> Void
    ) async throws -> LoadedDocument {
        guard let format = await detectFormat(url: url) else {
            throw ImportError.unknownFormat(url)
        }

        guard let importer = importers[format] else {
            throw ImportError.noImporterAvailable(format)
        }

        return try await importer.importDocument(from: url, progress: progress)
    }

    /// Export a document to a specific format
    ///
    /// - Parameters:
    ///   - document: The document to export
    ///   - url: The destination file URL
    ///   - format: The target format
    /// - Throws: ExportError if format not available or export fails
    public func exportDocument(
        _ document: LoadedDocument,
        to url: URL,
        format: FormatIdentifier
    ) async throws {
        guard let exporter = exporters[format] else {
            throw ExportError.noExporterAvailable(format)
        }

        guard exporter.canExport(document: document) else {
            throw ExportError.incompatibleDocument(
                format: format,
                reason: "Document does not meet format requirements"
            )
        }

        try await exporter.export(document: document, to: url)
    }

    // MARK: - Built-in Formats

    /// Creates all built-in format descriptors (static helper for init)
    private static func createBuiltInDescriptors() -> [FormatIdentifier: FormatDescriptor] {
        var result: [FormatIdentifier: FormatDescriptor] = [:]

        // FASTA
        let fasta = FormatDescriptor(
            identifier: .fasta,
            displayName: "FASTA",
            formatDescription: "Simple sequence format",
            extensions: ["fa", "fasta", "fna", "faa", "ffn", "frn"],
            mimeTypes: ["text/x-fasta"],
            capabilities: .nucleotideSequence,
            canRead: true,
            canWrite: true
        )
        result[fasta.identifier] = fasta

        // FASTQ
        let fastq = FormatDescriptor(
            identifier: .fastq,
            displayName: "FASTQ",
            formatDescription: "Sequence with quality scores",
            extensions: ["fq", "fastq"],
            mimeTypes: ["text/x-fastq"],
            capabilities: [.nucleotideSequence, .qualityScores],
            canRead: true,
            canWrite: true
        )
        result[fastq.identifier] = fastq

        // GenBank
        let genbank = FormatDescriptor(
            identifier: .genbank,
            displayName: "GenBank",
            formatDescription: "Annotated sequence format",
            extensions: ["gb", "gbk", "genbank", "gbff"],
            mimeTypes: ["text/x-genbank"],
            capabilities: [.nucleotideSequence, .annotations, .richMetadata],
            canRead: true,
            canWrite: true
        )
        result[genbank.identifier] = genbank

        // GFF3
        let gff3 = FormatDescriptor(
            identifier: .gff3,
            displayName: "GFF3",
            formatDescription: "General Feature Format version 3",
            extensions: ["gff", "gff3"],
            mimeTypes: ["text/x-gff3"],
            capabilities: .annotations,
            canRead: true,
            canWrite: true
        )
        result[gff3.identifier] = gff3

        // BED
        let bed = FormatDescriptor(
            identifier: .bed,
            displayName: "BED",
            formatDescription: "Browser Extensible Data format",
            extensions: ["bed"],
            mimeTypes: ["text/x-bed"],
            capabilities: .annotations,
            canRead: true,
            canWrite: true
        )
        result[bed.identifier] = bed

        // VCF
        let vcf = FormatDescriptor(
            identifier: .vcf,
            displayName: "VCF",
            formatDescription: "Variant Call Format",
            extensions: ["vcf"],
            mimeTypes: ["text/x-vcf"],
            capabilities: .variants,
            canRead: true,
            canWrite: true
        )
        result[vcf.identifier] = vcf

        // SAM
        let sam = FormatDescriptor(
            identifier: .sam,
            displayName: "SAM",
            formatDescription: "Sequence Alignment Map (text)",
            extensions: ["sam"],
            mimeTypes: ["text/x-sam"],
            capabilities: [.nucleotideSequence, .qualityScores, .alignment],
            isBinary: false,
            canRead: true,
            canWrite: true
        )
        result[sam.identifier] = sam

        // BAM
        let bam = FormatDescriptor(
            identifier: .bam,
            displayName: "BAM",
            formatDescription: "Binary Alignment Map",
            extensions: ["bam"],
            mimeTypes: ["application/x-bam"],
            magicBytes: Data([0x1f, 0x8b, 0x08]), // gzip magic (BAM is bgzf compressed)
            capabilities: [.nucleotideSequence, .qualityScores, .alignment],
            supportsCompression: false, // Already compressed
            requiresIndex: true,
            indexFormat: .bai,
            isBinary: true,
            canRead: true,
            canWrite: false
        )
        result[bam.identifier] = bam

        // BigWig
        let bigwig = FormatDescriptor(
            identifier: .bigwig,
            displayName: "BigWig",
            formatDescription: "Binary coverage/signal format",
            extensions: ["bw", "bigwig"],
            magicBytes: Data([0x26, 0xfc, 0x8f, 0x88]), // BigWig magic (little-endian)
            capabilities: .coverage,
            supportsCompression: false,
            isBinary: true,
            canRead: true,
            canWrite: false
        )
        result[bigwig.identifier] = bigwig

        // BigBed
        let bigbed = FormatDescriptor(
            identifier: .bigbed,
            displayName: "BigBed",
            formatDescription: "Binary annotation format",
            extensions: ["bb", "bigbed"],
            magicBytes: Data([0x26, 0xfc, 0x8f, 0x87]), // BigBed magic (little-endian)
            capabilities: .annotations,
            supportsCompression: false,
            isBinary: true,
            canRead: true,
            canWrite: false
        )
        result[bigbed.identifier] = bigbed

        return result
    }
}

// MARK: - FormatRegistryError

/// Errors from FormatRegistry operations
public enum FormatRegistryError: Error, LocalizedError, Sendable {

    /// Unknown file format
    case unknownFormat(URL)

    /// No importer available for format
    case noImporterAvailable(FormatIdentifier)

    /// No exporter available for format
    case noExporterAvailable(FormatIdentifier)

    /// Document is incompatible with format
    case incompatibleDocument(format: FormatIdentifier, required: DocumentCapability, provided: DocumentCapability)

    public var errorDescription: String? {
        switch self {
        case .unknownFormat(let url):
            return "Unknown file format: \(url.lastPathComponent)"
        case .noImporterAvailable(let format):
            return "No importer available for format: \(format.id)"
        case .noExporterAvailable(let format):
            return "No exporter available for format: \(format.id)"
        case .incompatibleDocument(let format, let required, _):
            return "Document is incompatible with \(format.id) format (requires: \(required))"
        }
    }
}
