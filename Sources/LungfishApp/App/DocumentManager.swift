// DocumentManager.swift - Central document state management
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import AppKit
import LungfishCore
import LungfishIO
import os.log

// MARK: - Logging

/// Logger for document operations
private let logger = Logger(subsystem: "com.lungfish.browser", category: "DocumentManager")

// MARK: - Document State

/// Represents a loaded document with its associated data.
@MainActor
public class LoadedDocument: ObservableObject, Identifiable {
    public let id = UUID()
    public let url: URL
    public let name: String
    public let type: DocumentType

    /// The loaded sequences
    @Published public var sequences: [Sequence] = []

    /// The loaded annotations
    @Published public var annotations: [SequenceAnnotation] = []

    public init(url: URL, type: DocumentType) {
        self.url = url
        self.name = url.lastPathComponent
        self.type = type
        logger.info("Created LoadedDocument: \(self.name, privacy: .public) type=\(type.rawValue, privacy: .public)")
    }
}

/// Types of documents the app can handle.
public enum DocumentType: String, CaseIterable {
    case fasta
    case fastq
    case genbank
    case gff3
    case bed
    case vcf
    case bam

    /// File extensions for this document type.
    public var extensions: [String] {
        switch self {
        case .fasta: return ["fa", "fasta", "fna", "fas"]
        case .fastq: return ["fq", "fastq"]
        case .genbank: return ["gb", "gbk", "genbank"]
        case .gff3: return ["gff", "gff3"]
        case .bed: return ["bed"]
        case .vcf: return ["vcf"]
        case .bam: return ["bam", "cram", "sam"]
        }
    }

    /// Detect document type from file extension.
    public static func detect(from url: URL) -> DocumentType? {
        let ext = url.pathExtension.lowercased()
        let detected = DocumentType.allCases.first { $0.extensions.contains(ext) }
        logger.debug("DocumentType.detect: extension='\(ext, privacy: .public)' -> \(detected?.rawValue ?? "nil", privacy: .public)")
        return detected
    }
}

// MARK: - Document Manager

/// Manages loaded documents and notifies observers of changes.
@MainActor
public class DocumentManager: ObservableObject {

    /// Shared instance
    public static let shared = DocumentManager()

    /// Currently loaded documents
    @Published public private(set) var documents: [LoadedDocument] = []

    /// Currently active/selected document
    @Published public var activeDocument: LoadedDocument?

    /// Notification posted when a document is loaded
    public static let documentLoadedNotification = Notification.Name("DocumentManagerDocumentLoaded")

    /// Notification posted when active document changes
    public static let activeDocumentChangedNotification = Notification.Name("DocumentManagerActiveDocumentChanged")

    private init() {
        logger.info("DocumentManager initialized")
    }

    // MARK: - Document Loading

    /// Loads a document from the given URL.
    ///
    /// - Parameter url: The file URL to load
    /// - Returns: The loaded document, or nil if loading failed
    /// - Throws: Error if the file cannot be read or parsed
    @discardableResult
    public func loadDocument(at url: URL) async throws -> LoadedDocument {
        logger.info("loadDocument: Starting load for \(url.path, privacy: .public)")

        // Check if file exists
        let fileExists = FileManager.default.fileExists(atPath: url.path)
        logger.info("loadDocument: File exists = \(fileExists)")

        if !fileExists {
            logger.error("loadDocument: File not found at \(url.path, privacy: .public)")
            throw DocumentLoadError.fileNotFound(url)
        }

        // Check file readability
        let isReadable = FileManager.default.isReadableFile(atPath: url.path)
        logger.info("loadDocument: File readable = \(isReadable)")

        if !isReadable {
            logger.error("loadDocument: File not readable at \(url.path, privacy: .public)")
            throw DocumentLoadError.accessDenied(url)
        }

        // Detect document type
        guard let type = DocumentType.detect(from: url) else {
            logger.error("loadDocument: Unsupported format for extension '\(url.pathExtension, privacy: .public)'")
            throw DocumentLoadError.unsupportedFormat(url.pathExtension)
        }

        logger.info("loadDocument: Detected type = \(type.rawValue, privacy: .public)")

        let document = LoadedDocument(url: url, type: type)

        // Load based on type
        do {
            switch type {
            case .fasta:
                logger.info("loadDocument: Loading FASTA...")
                try await loadFASTA(into: document)
            case .fastq:
                logger.info("loadDocument: Loading FASTQ...")
                try await loadFASTQ(into: document)
            case .genbank:
                logger.warning("loadDocument: GenBank not yet supported")
                throw DocumentLoadError.unsupportedFormat("GenBank support coming soon")
            case .gff3:
                logger.info("loadDocument: Loading GFF3...")
                try await loadGFF3(into: document)
            case .bed:
                logger.info("loadDocument: Loading BED...")
                try await loadBED(into: document)
            case .vcf:
                logger.info("loadDocument: Loading VCF...")
                try await loadVCF(into: document)
            case .bam:
                logger.warning("loadDocument: BAM/CRAM not yet supported")
                throw DocumentLoadError.unsupportedFormat("BAM/CRAM support coming soon")
            }
        } catch {
            logger.error("loadDocument: Load failed with error: \(error.localizedDescription, privacy: .public)")
            throw error
        }

        logger.info("loadDocument: Loaded \(document.sequences.count) sequences, \(document.annotations.count) annotations")

        // Add to documents list
        documents.append(document)
        logger.info("loadDocument: Added to documents list (total: \(self.documents.count))")

        // Set as active
        activeDocument = document
        logger.info("loadDocument: Set as active document")

        // Post notifications
        NotificationCenter.default.post(
            name: Self.documentLoadedNotification,
            object: self,
            userInfo: ["document": document]
        )
        logger.info("loadDocument: Posted documentLoadedNotification")

        logger.info("loadDocument: Successfully completed loading \(document.name, privacy: .public)")
        return document
    }

    /// Closes a document.
    public func closeDocument(_ document: LoadedDocument) {
        logger.info("closeDocument: Closing \(document.name, privacy: .public)")
        documents.removeAll { $0.id == document.id }
        if activeDocument?.id == document.id {
            activeDocument = documents.first
        }
    }

    /// Sets the active document.
    public func setActiveDocument(_ document: LoadedDocument?) {
        logger.info("setActiveDocument: \(document?.name ?? "nil", privacy: .public)")
        activeDocument = document
        NotificationCenter.default.post(
            name: Self.activeDocumentChangedNotification,
            object: self,
            userInfo: document.map { ["document": $0] }
        )
    }

    /// Registers a pre-loaded document with the document manager.
    /// Used when documents are loaded synchronously outside the normal async flow.
    public func registerDocument(_ document: LoadedDocument) {
        // Check if already registered
        if documents.contains(where: { $0.url == document.url }) {
            logger.debug("registerDocument: Document already registered: \(document.name, privacy: .public)")
            return
        }

        logger.info("registerDocument: Registering \(document.name, privacy: .public)")
        documents.append(document)
    }

    // MARK: - Project Folder Loading

    /// Notification posted when a project folder is loaded
    public static let projectLoadedNotification = Notification.Name("DocumentManagerProjectLoaded")

    /// Loads all supported documents from a folder recursively.
    ///
    /// - Parameter folderURL: The folder URL to scan
    /// - Returns: Array of loaded documents
    /// - Throws: Error if folder cannot be accessed
    public func loadProjectFolder(at folderURL: URL) async throws -> [LoadedDocument] {
        logger.info("loadProjectFolder: Scanning \(folderURL.path, privacy: .public)")

        let fileManager = FileManager.default

        // Verify folder exists and is a directory
        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: folderURL.path, isDirectory: &isDirectory),
              isDirectory.boolValue else {
            logger.error("loadProjectFolder: Not a valid directory: \(folderURL.path, privacy: .public)")
            throw DocumentLoadError.fileNotFound(folderURL)
        }

        var loadedDocuments: [LoadedDocument] = []

        // Enumerate all files recursively
        guard let enumerator = fileManager.enumerator(
            at: folderURL,
            includingPropertiesForKeys: [.isRegularFileKey, .isDirectoryKey],
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
        ) else {
            logger.error("loadProjectFolder: Failed to create enumerator for \(folderURL.path, privacy: .public)")
            throw DocumentLoadError.accessDenied(folderURL)
        }

        var filesToLoad: [URL] = []

        for case let fileURL as URL in enumerator {
            // Check if it's a regular file with supported extension
            if let type = DocumentType.detect(from: fileURL) {
                logger.debug("loadProjectFolder: Found supported file \(fileURL.lastPathComponent, privacy: .public) (\(type.rawValue, privacy: .public))")
                filesToLoad.append(fileURL)
            }
        }

        logger.info("loadProjectFolder: Found \(filesToLoad.count) supported files")

        // Load each file
        for fileURL in filesToLoad {
            do {
                let document = try await loadDocument(at: fileURL)
                loadedDocuments.append(document)
                logger.debug("loadProjectFolder: Loaded \(fileURL.lastPathComponent, privacy: .public)")
            } catch {
                // Log warning but continue with other files
                logger.warning("loadProjectFolder: Skipped \(fileURL.lastPathComponent, privacy: .public): \(error.localizedDescription, privacy: .public)")
            }
        }

        logger.info("loadProjectFolder: Successfully loaded \(loadedDocuments.count) documents")

        // Post notification for project loaded
        NotificationCenter.default.post(
            name: Self.projectLoadedNotification,
            object: self,
            userInfo: [
                "folderURL": folderURL,
                "documents": loadedDocuments
            ]
        )

        return loadedDocuments
    }

    // MARK: - Private Loading Methods

    private func loadFASTA(into document: LoadedDocument) async throws {
        logger.info("loadFASTA: Creating FASTAReader for \(document.url.path, privacy: .public)")

        let reader = try FASTAReader(url: document.url)
        logger.info("loadFASTA: FASTAReader created, calling readAll()")

        let sequences = try await reader.readAll()
        logger.info("loadFASTA: Read \(sequences.count) sequences")

        for (index, seq) in sequences.enumerated() {
            logger.debug("loadFASTA: Sequence[\(index)]: name='\(seq.name, privacy: .public)' length=\(seq.length)")
        }

        document.sequences = sequences
        logger.info("loadFASTA: Assigned sequences to document")
    }

    private func loadFASTQ(into document: LoadedDocument) async throws {
        logger.info("loadFASTQ: Creating FASTQReader for \(document.url.path, privacy: .public)")

        let reader = FASTQReader()
        var sequences: [Sequence] = []
        var count = 0

        logger.info("loadFASTQ: Starting to read records...")

        for try await record in reader.records(from: document.url) {
            // Convert FASTQRecord to Sequence
            let sequence = try Sequence(
                name: record.identifier,
                description: record.description,
                alphabet: .dna,
                bases: record.sequence
            )
            sequences.append(sequence)

            count += 1
            if count % 1000 == 0 {
                logger.debug("loadFASTQ: Read \(count) records so far...")
            }

            // Limit for memory
            if count >= 10000 {
                logger.info("loadFASTQ: Reached 10000 record limit")
                break
            }
        }

        logger.info("loadFASTQ: Read \(sequences.count) sequences total")
        document.sequences = sequences
    }

    private func loadGFF3(into document: LoadedDocument) async throws {
        logger.info("loadGFF3: Creating GFF3Reader for \(document.url.path, privacy: .public)")

        let reader = GFF3Reader()
        let annotations = try await reader.readAsAnnotations(from: document.url)

        logger.info("loadGFF3: Read \(annotations.count) annotations")
        document.annotations = annotations
    }

    private func loadBED(into document: LoadedDocument) async throws {
        logger.info("loadBED: Creating BEDReader for \(document.url.path, privacy: .public)")

        let reader = BEDReader()
        let annotations = try await reader.readAsAnnotations(from: document.url)

        logger.info("loadBED: Read \(annotations.count) annotations")
        document.annotations = annotations
    }

    private func loadVCF(into document: LoadedDocument) async throws {
        logger.info("loadVCF: Creating VCFReader for \(document.url.path, privacy: .public)")

        let reader = VCFReader()
        let variants = try await reader.readAll(from: document.url)

        logger.info("loadVCF: Read \(variants.count) variants")
        document.annotations = variants.map { $0.toAnnotation() }
    }
}

// MARK: - Errors

/// Errors that can occur during document loading.
public enum DocumentLoadError: Error, LocalizedError {
    case unsupportedFormat(String)
    case fileNotFound(URL)
    case parseError(String)
    case accessDenied(URL)

    public var errorDescription: String? {
        switch self {
        case .unsupportedFormat(let ext):
            return "Unsupported file format: \(ext)"
        case .fileNotFound(let url):
            return "File not found: \(url.lastPathComponent)"
        case .parseError(let message):
            return "Parse error: \(message)"
        case .accessDenied(let url):
            return "Access denied: \(url.lastPathComponent)"
        }
    }
}

// MARK: - Drag and Drop Types

/// UTTypes supported for drag and drop
extension DocumentManager {
    /// All supported file extensions for drag and drop
    public static var supportedExtensions: [String] {
        DocumentType.allCases.flatMap { $0.extensions }
    }

    /// NSPasteboard types for drag and drop
    public static var pasteboardTypes: [NSPasteboard.PasteboardType] {
        [.fileURL, .URL]
    }
}
