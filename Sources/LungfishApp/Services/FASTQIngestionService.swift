// FASTQIngestionService.swift - App-level FASTQ ingestion with OperationCenter
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import LungfishIO
import LungfishWorkflow
import os.log

private let logger = Logger(subsystem: "com.lungfish.browser", category: "FASTQIngestionService")

// MARK: - FASTQIngestionService

/// App-level service that runs the FASTQ ingestion pipeline (clumpify → compress → index)
/// and reports progress via OperationCenter.
///
/// Call `ingestIfNeeded` from any FASTQ import path (SRA download, drag-drop, file import).
/// The service checks the sidecar metadata to skip already-ingested files.
@MainActor
public enum FASTQIngestionService {

    /// Ingests a FASTQ file if it hasn't already been processed.
    ///
    /// Runs clumpify → compress → index in the background via OperationCenter.
    /// The processed file replaces the original. Metadata sidecar is updated.
    ///
    /// - Parameters:
    ///   - url: URL of the FASTQ file to ingest
    ///   - pairingMode: Pairing mode (single-end, paired-end, interleaved)
    ///   - pairedFile: For paired-end, the second file (R2). The first is `url` (R1).
    ///   - existingMetadata: Existing metadata to preserve (SRA info, download date, etc.)
    public static func ingestIfNeeded(
        url: URL,
        pairingMode: FASTQIngestionConfig.PairingMode = .singleEnd,
        pairedFile: URL? = nil,
        existingMetadata: PersistedFASTQMetadata? = nil
    ) {
        // Skip if already ingested
        if let existing = existingMetadata ?? FASTQMetadataStore.load(for: url),
           let ingestion = existing.ingestion,
           ingestion.isClumpified && ingestion.isCompressed {
            logger.info("Skipping ingestion for \(url.lastPathComponent) — already processed")
            return
        }

        let inputFiles: [URL]
        if let pairedFile, pairingMode == .pairedEnd {
            inputFiles = [url, pairedFile]
        } else {
            inputFiles = [url]
        }

        let outputDir = url.deletingLastPathComponent()
        let config = FASTQIngestionConfig(
            inputFiles: inputFiles,
            pairingMode: pairingMode,
            outputDirectory: outputDir,
            threads: min(ProcessInfo.processInfo.processorCount, 8),
            deleteOriginals: true
        )

        let baseName = FASTQIngestionPipeline.deriveBaseName(from: url)
        let title = "FASTQ Ingestion: \(baseName)"

        let task = Task.detached {
            await Self.runIngestion(
                config: config,
                title: title,
                existingMetadata: existingMetadata
            )
        }

        _ = OperationCenter.shared.start(
            title: title,
            detail: "Preparing...",
            operationType: .ingestion,
            onCancel: { task.cancel() }
        )
    }

    // MARK: - Pipeline Runner

    private static func runIngestion(
        config: FASTQIngestionConfig,
        title: String,
        existingMetadata: PersistedFASTQMetadata?
    ) async {
        // Find operation ID
        let operationID: UUID? = await MainActor.run {
            OperationCenter.shared.items.first(where: {
                $0.title == title && $0.state == .running
            })?.id
        }

        guard let opID = operationID else {
            logger.error("Ingestion operation not found in OperationCenter")
            return
        }

        do {
            let pipeline = FASTQIngestionPipeline()
            let result = try await pipeline.run(config: config) { fraction, message in
                DispatchQueue.main.async {
                    MainActor.assumeIsolated {
                        OperationCenter.shared.update(
                            id: opID,
                            progress: fraction,
                            detail: message
                        )
                    }
                }
            }

            // Update metadata sidecar
            let pairingMode: IngestionMetadata.PairingMode = {
                switch result.pairingMode {
                case .singleEnd: return .singleEnd
                case .pairedEnd: return .interleaved  // paired-end becomes interleaved after clumpify
                case .interleaved: return .interleaved
                }
            }()

            let ingestion = IngestionMetadata(
                isClumpified: result.wasClumpified,
                isCompressed: true,
                isIndexed: result.indexFile != nil,
                pairingMode: pairingMode,
                qualityBinning: result.qualityBinning.rawValue,
                originalFilenames: result.originalFilenames,
                ingestionDate: Date(),
                originalSizeBytes: result.originalSizeBytes
            )

            var metadata = existingMetadata ?? PersistedFASTQMetadata()
            metadata.ingestion = ingestion
            FASTQMetadataStore.save(metadata, for: result.outputFile)

            let savedStr = ByteCountFormatter.string(
                fromByteCount: result.originalSizeBytes - result.finalSizeBytes,
                countStyle: .file
            )
            let detail = result.wasClumpified
                ? "Clumpified and compressed (saved \(savedStr))"
                : "Compressed (saved \(savedStr))"

            await MainActor.run {
                OperationCenter.shared.complete(id: opID, detail: detail, bundleURLs: [])
            }

            logger.info("Ingestion complete: \(result.outputFile.lastPathComponent)")

        } catch is CancellationError {
            await MainActor.run {
                OperationCenter.shared.fail(id: opID, detail: "Cancelled")
            }
        } catch {
            logger.error("Ingestion failed: \(error)")
            await MainActor.run {
                OperationCenter.shared.fail(id: opID, detail: "\(error)")
            }
        }
    }
}
