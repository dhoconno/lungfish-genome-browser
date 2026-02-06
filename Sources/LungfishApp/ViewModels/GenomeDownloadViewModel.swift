// GenomeDownloadViewModel.swift - Genome assembly download and bundle building
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Owner: NCBI Integration Lead (Role 12)

import Foundation
import LungfishCore
import LungfishWorkflow
import os.log

/// Logger for genome download operations.
private let logger = Logger(subsystem: "com.lungfish.browser", category: "GenomeDownload")

// MARK: - GenomeDownloadViewModel

/// Manages genome assembly download and reference bundle building.
///
/// This view model orchestrates the full pipeline of downloading a genome assembly
/// from NCBI (FASTA + GFF3 annotations) and building a `.lungfishref` bundle that
/// can be loaded directly into the genome browser.
///
/// ## Usage
/// ```swift
/// let viewModel = GenomeDownloadViewModel()
/// let bundleURL = try await viewModel.downloadAndBuild(
///     assembly: assemblySummary,
///     outputDirectory: downloadsDir
/// )
/// ```
@Observable
@MainActor
public final class GenomeDownloadViewModel {

    // MARK: - State

    /// Represents the current state of the download and build pipeline.
    public enum State: Sendable {
        /// No operation in progress.
        case idle
        /// Downloading genome files from NCBI.
        case downloading(progress: Double, message: String)
        /// Building the .lungfishref bundle from downloaded files.
        case building(progress: Double, message: String)
        /// Pipeline completed successfully.
        case complete(bundleURL: URL)
        /// Pipeline failed with an error.
        case error(String)
    }

    // MARK: - Properties

    /// The current state of the download/build pipeline.
    public private(set) var state: State = .idle

    /// The NCBI service used for downloads.
    private let ncbiService: NCBIService

    /// The native bundle builder used for creating .lungfishref bundles.
    private let bundleBuilder: NativeBundleBuilder

    // MARK: - Initialization

    /// Creates a new genome download view model.
    ///
    /// - Parameters:
    ///   - ncbiService: The NCBI service to use for API calls and downloads.
    ///   - bundleBuilder: The bundle builder to use for creating reference bundles.
    public init(
        ncbiService: NCBIService = NCBIService(),
        bundleBuilder: NativeBundleBuilder = NativeBundleBuilder()
    ) {
        self.ncbiService = ncbiService
        self.bundleBuilder = bundleBuilder
    }

    // MARK: - Public API

    /// Downloads FASTA and GFF3 files for an assembly and builds a `.lungfishref` bundle.
    ///
    /// This method performs the complete pipeline:
    /// 1. Retrieves FASTA file info from NCBI
    /// 2. Retrieves GFF3 annotation file info (optional, may not exist)
    /// 3. Downloads FASTA to a temporary directory with progress tracking
    /// 4. Downloads GFF3 to a temporary directory (skipped if unavailable)
    /// 5. Builds a `BuildConfiguration` and invokes `NativeBundleBuilder`
    /// 6. Returns the URL of the completed `.lungfishref` bundle
    ///
    /// - Parameters:
    ///   - assembly: The NCBI assembly summary describing the genome to download.
    ///   - outputDirectory: The directory where the `.lungfishref` bundle will be created.
    /// - Returns: The URL of the completed `.lungfishref` bundle.
    /// - Throws: `DatabaseServiceError` if downloads fail, or `BundleBuildError` if bundle
    ///   creation fails.
    public func downloadAndBuild(
        assembly: NCBIAssemblySummary,
        outputDirectory: URL
    ) async throws -> URL {
        let accession = assembly.assemblyAccession ?? assembly.uid
        let organismName = assembly.organism ?? assembly.speciesName ?? "Unknown"
        let assemblyName = assembly.assemblyName ?? accession

        logger.info("downloadAndBuild: Starting pipeline for \(accession, privacy: .public) (\(organismName, privacy: .public))")

        // Create a temporary working directory for intermediate files
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("lungfish-genome-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        defer {
            // Clean up temporary files after completion
            try? FileManager.default.removeItem(at: tempDir)
        }

        do {
            // Step 1: Get FASTA file info
            state = .downloading(progress: 0.0, message: "Locating genome FASTA...")
            logger.info("downloadAndBuild: Getting FASTA file info for \(accession, privacy: .public)")

            let fastaFileInfo = try await ncbiService.getGenomeFileInfo(for: assembly)
            let fastaSizeStr = fastaFileInfo.estimatedSize.map { formatBytes($0) } ?? "unknown size"
            logger.info("downloadAndBuild: FASTA file found: \(fastaFileInfo.filename, privacy: .public) (\(fastaSizeStr, privacy: .public))")

            // Step 2: Get GFF3 annotation file info (may not exist)
            state = .downloading(progress: 0.02, message: "Checking for GFF3 annotations...")
            logger.info("downloadAndBuild: Checking for GFF3 annotations for \(accession, privacy: .public)")

            let gffFileInfo = try await ncbiService.getAnnotationFileInfo(for: assembly)
            if let gffInfo = gffFileInfo {
                let gffSizeStr = gffInfo.estimatedSize.map { formatBytes($0) } ?? "unknown size"
                logger.info("downloadAndBuild: GFF3 file found: \(gffInfo.filename, privacy: .public) (\(gffSizeStr, privacy: .public))")
            } else {
                logger.info("downloadAndBuild: No GFF3 annotations available for \(accession, privacy: .public)")
            }

            // Step 3: Download FASTA with progress tracking
            state = .downloading(progress: 0.05, message: "Downloading FASTA (\(fastaSizeStr))...")
            logger.info("downloadAndBuild: Downloading FASTA to temp directory")

            let fastaDestination = tempDir.appendingPathComponent(fastaFileInfo.filename)
            let fastaExpectedBytes = fastaFileInfo.estimatedSize

            _ = try await ncbiService.downloadGenomeFile(
                fastaFileInfo,
                to: fastaDestination
            ) { [weak self] bytesDownloaded, expectedTotal in
                let total = expectedTotal ?? fastaExpectedBytes
                let fraction: Double
                if let total, total > 0 {
                    fraction = Double(bytesDownloaded) / Double(total)
                } else {
                    fraction = 0.5
                }
                // Map FASTA download to 5%-55% of total progress
                let overallProgress = 0.05 + (fraction * 0.50)
                let downloadedStr = formatBytes(bytesDownloaded)
                let totalStr = total.map { formatBytes($0) } ?? "?"
                Task { @MainActor [weak self] in
                    self?.state = .downloading(
                        progress: overallProgress,
                        message: "Downloading FASTA: \(downloadedStr) / \(totalStr)"
                    )
                }
            }

            logger.info("downloadAndBuild: FASTA download complete")

            // Step 4: Download GFF3 with progress tracking (skip if not found)
            var gffDestination: URL?
            if let gffInfo = gffFileInfo {
                state = .downloading(progress: 0.55, message: "Downloading GFF3 annotations...")
                logger.info("downloadAndBuild: Downloading GFF3 to temp directory")

                let gffDest = tempDir.appendingPathComponent(gffInfo.filename)
                let gffExpectedBytes = gffInfo.estimatedSize

                do {
                    _ = try await ncbiService.downloadGenomeFile(
                        gffInfo,
                        to: gffDest
                    ) { [weak self] bytesDownloaded, expectedTotal in
                        let total = expectedTotal ?? gffExpectedBytes
                        let fraction: Double
                        if let total, total > 0 {
                            fraction = Double(bytesDownloaded) / Double(total)
                        } else {
                            fraction = 0.5
                        }
                        // Map GFF3 download to 55%-75% of total progress
                        let overallProgress = 0.55 + (fraction * 0.20)
                        let downloadedStr = formatBytes(bytesDownloaded)
                        let totalStr = total.map { formatBytes($0) } ?? "?"
                        Task { @MainActor [weak self] in
                            self?.state = .downloading(
                                progress: overallProgress,
                                message: "Downloading GFF3: \(downloadedStr) / \(totalStr)"
                            )
                        }
                    }

                    gffDestination = gffDest
                    logger.info("downloadAndBuild: GFF3 download complete")
                } catch {
                    // GFF3 download failure is non-fatal
                    logger.warning("downloadAndBuild: GFF3 download failed (non-fatal): \(error.localizedDescription)")
                }
            }

            // Step 5: Build the .lungfishref bundle
            state = .building(progress: 0.75, message: "Building reference bundle...")
            logger.info("downloadAndBuild: Building .lungfishref bundle")

            // Construct annotation inputs from downloaded GFF3
            var annotationInputs: [AnnotationInput] = []
            if let gffURL = gffDestination {
                annotationInputs.append(
                    AnnotationInput(
                        url: gffURL,
                        name: "Gene Annotations",
                        description: "GFF3 annotations from NCBI for \(assemblyName)",
                        id: "ncbi_genes",
                        annotationType: .gene
                    )
                )
            }

            // Build the source metadata
            let sourceInfo = SourceInfo(
                organism: organismName,
                commonName: nil,
                taxonomyId: assembly.taxid,
                assembly: assemblyName,
                assemblyAccession: assembly.assemblyAccession,
                database: "NCBI",
                sourceURL: URL(string: "https://www.ncbi.nlm.nih.gov/assembly/\(accession)"),
                downloadDate: Date(),
                notes: "Downloaded via Lungfish Genome Browser"
            )

            // Create the build configuration
            let bundleIdentifier = "org.ncbi.assembly.\(accession.lowercased().replacingOccurrences(of: ".", with: "-"))"
            let configuration = BuildConfiguration(
                name: "\(organismName) - \(assemblyName)",
                identifier: bundleIdentifier,
                fastaURL: fastaDestination,
                annotationFiles: annotationInputs,
                variantFiles: [],
                signalFiles: [],
                outputDirectory: outputDirectory,
                source: sourceInfo,
                compressFASTA: true
            )

            let bundleURL = try await bundleBuilder.build(
                configuration: configuration
            ) { [weak self] step, progress, message in
                // Map bundle build progress to 75%-100% of total progress
                let overallProgress = 0.75 + (progress * 0.25)
                Task { @MainActor [weak self] in
                    self?.state = .building(
                        progress: overallProgress,
                        message: message
                    )
                }
            }

            // Step 6: Complete
            state = .complete(bundleURL: bundleURL)
            logger.info("downloadAndBuild: Pipeline complete. Bundle at \(bundleURL.path, privacy: .public)")

            return bundleURL

        } catch {
            let errorMessage = error.localizedDescription
            state = .error(errorMessage)
            logger.error("downloadAndBuild: Pipeline failed: \(errorMessage, privacy: .public)")
            throw error
        }
    }

    /// Resets the view model state back to idle.
    public func reset() {
        state = .idle
    }

}

/// Formats a byte count as a human-readable string (module-level helper for closures).
private func formatBytes(_ bytes: Int64) -> String {
    let formatter = ByteCountFormatter()
    formatter.countStyle = .file
    return formatter.string(fromByteCount: bytes)
}
