// FASTQMetadataStore.swift - Sidecar JSON metadata persistence for FASTQ files
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import LungfishCore
import os.log

private let logger = Logger(subsystem: "com.lungfish.io", category: "FASTQMetadataStore")

// MARK: - Persisted FASTQ Metadata

/// Metadata persisted alongside a FASTQ file as a sidecar JSON.
///
/// File convention: `SRR12345.fastq.gz.lungfish-meta.json`
///
/// Contains cached statistics (to avoid re-computing on reload),
/// download provenance, and SRA/ENA metadata when available.
public struct PersistedFASTQMetadata: Codable, Sendable {

    /// Cached dataset statistics (avoids re-streaming the FASTQ).
    public var computedStatistics: FASTQDatasetStatistics?

    /// SRA run info (from NCBI SRA search).
    public var sraRunInfo: SRARunInfo?

    /// ENA read record (from ENA Portal API).
    public var enaReadRecord: ENAReadRecord?

    /// Date the FASTQ was downloaded.
    public var downloadDate: Date?

    /// Source URL or identifier for the download.
    public var downloadSource: String?

    /// Ingestion pipeline metadata (clumpify/compress/index status).
    public var ingestion: IngestionMetadata?

    public init(
        computedStatistics: FASTQDatasetStatistics? = nil,
        sraRunInfo: SRARunInfo? = nil,
        enaReadRecord: ENAReadRecord? = nil,
        downloadDate: Date? = nil,
        downloadSource: String? = nil,
        ingestion: IngestionMetadata? = nil
    ) {
        self.computedStatistics = computedStatistics
        self.sraRunInfo = sraRunInfo
        self.enaReadRecord = enaReadRecord
        self.downloadDate = downloadDate
        self.downloadSource = downloadSource
        self.ingestion = ingestion
    }
}

// MARK: - FASTQMetadataStore

/// Reads and writes sidecar metadata JSON files alongside FASTQ files.
///
/// ```swift
/// // Save after computing statistics
/// let metadata = PersistedFASTQMetadata(
///     computedStatistics: stats,
///     enaReadRecord: enaRecord
/// )
/// FASTQMetadataStore.save(metadata, for: fastqURL)
///
/// // Load on next open
/// if let cached = FASTQMetadataStore.load(for: fastqURL) {
///     // Use cached.computedStatistics instead of re-computing
/// }
/// ```
public enum FASTQMetadataStore {

    /// Returns the sidecar metadata URL for a given FASTQ file.
    ///
    /// Example: `/path/to/SRR123.fastq.gz` → `/path/to/SRR123.fastq.gz.lungfish-meta.json`
    public static func metadataURL(for fastqURL: URL) -> URL {
        fastqURL.appendingPathExtension("lungfish-meta.json")
    }

    /// Loads persisted metadata from the sidecar JSON, if it exists.
    ///
    /// - Parameter fastqURL: The URL of the FASTQ file.
    /// - Returns: The persisted metadata, or nil if no sidecar exists.
    public static func load(for fastqURL: URL) -> PersistedFASTQMetadata? {
        let url = metadataURL(for: fastqURL)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let metadata = try decoder.decode(PersistedFASTQMetadata.self, from: data)
            logger.info("Loaded FASTQ metadata from \(url.lastPathComponent)")
            return metadata
        } catch {
            logger.warning("Failed to load FASTQ metadata: \(error)")
            return nil
        }
    }

    /// Saves metadata to the sidecar JSON file.
    ///
    /// - Parameters:
    ///   - metadata: The metadata to persist.
    ///   - fastqURL: The URL of the FASTQ file.
    public static func save(_ metadata: PersistedFASTQMetadata, for fastqURL: URL) {
        let url = metadataURL(for: fastqURL)

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(metadata)
            try data.write(to: url, options: .atomic)
            logger.info("Saved FASTQ metadata to \(url.lastPathComponent)")
        } catch {
            logger.warning("Failed to save FASTQ metadata: \(error)")
        }
    }

    /// Deletes the sidecar metadata file if it exists.
    ///
    /// - Parameter fastqURL: The URL of the FASTQ file.
    public static func delete(for fastqURL: URL) {
        let url = metadataURL(for: fastqURL)
        try? FileManager.default.removeItem(at: url)
    }
}

// MARK: - Ingestion Metadata

/// Records the state of the FASTQ ingestion pipeline.
public struct IngestionMetadata: Codable, Sendable {

    /// Pairing mode of the FASTQ data.
    public enum PairingMode: String, Codable, Sendable {
        case singleEnd = "single_end"
        case pairedEnd = "paired_end"
        case interleaved = "interleaved"
    }

    /// Whether the file has been clumpified (k-mer sorted for compression).
    public var isClumpified: Bool

    /// Whether the file is gzip-compressed.
    public var isCompressed: Bool

    /// Whether the file has been indexed (samtools fqidx).
    public var isIndexed: Bool

    /// Pairing mode (single-end, paired-end, or interleaved).
    public var pairingMode: PairingMode

    /// Quality binning scheme applied (e.g. "illumina4", "eightLevel", "none").
    /// Nil for files ingested before quality binning was added.
    public var qualityBinning: String?

    /// Original filenames before ingestion (e.g. ["SRR123_1.fastq", "SRR123_2.fastq"]).
    public var originalFilenames: [String]

    /// Date the ingestion pipeline completed.
    public var ingestionDate: Date?

    /// Size of the file before clumpification/compression (bytes).
    public var originalSizeBytes: Int64?

    public init(
        isClumpified: Bool = false,
        isCompressed: Bool = false,
        isIndexed: Bool = false,
        pairingMode: PairingMode = .singleEnd,
        qualityBinning: String? = nil,
        originalFilenames: [String] = [],
        ingestionDate: Date? = nil,
        originalSizeBytes: Int64? = nil
    ) {
        self.isClumpified = isClumpified
        self.isCompressed = isCompressed
        self.isIndexed = isIndexed
        self.pairingMode = pairingMode
        self.qualityBinning = qualityBinning
        self.originalFilenames = originalFilenames
        self.ingestionDate = ingestionDate
        self.originalSizeBytes = originalSizeBytes
    }
}
