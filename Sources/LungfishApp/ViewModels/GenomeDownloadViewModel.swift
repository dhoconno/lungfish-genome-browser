// GenomeDownloadViewModel.swift - Genome assembly download and bundle building
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Owner: NCBI Integration Lead (Role 12)

import Foundation
import LungfishCore
import LungfishIO
import LungfishWorkflow
import os.log

/// Logger for genome download operations.
private let logger = Logger(subsystem: "com.lungfish.browser", category: "GenomeDownload")

// MARK: - GenomeDownloadViewModel

/// Downloads NCBI genome assemblies (FASTA + GFF3) and builds `.lungfishref` bundles.
///
/// This implementation avoids `@MainActor` isolation so it can run from `Task.detached`
/// contexts without cooperative executor scheduling issues. It follows the same pattern as
/// ``GenBankBundleDownloadViewModel``: direct `NativeToolRunner` usage for all tool
/// invocations, with progress reported via a `@Sendable` callback.
///
/// ## Usage
/// ```swift
/// let viewModel = GenomeDownloadViewModel()
/// let bundleURL = try await viewModel.downloadAndBuild(
///     assembly: assemblySummary,
///     outputDirectory: downloadsDir
/// ) { progress, message in
///     print("\(Int(progress * 100))%: \(message)")
/// }
/// ```
public final class GenomeDownloadViewModel: @unchecked Sendable {

    private let ncbiService: NCBIService
    private let toolRunner: NativeToolRunner
    private let annotationConverter: AnnotationConverter

    // MARK: - Initialization

    public init(
        ncbiService: NCBIService = NCBIService(),
        toolRunner: NativeToolRunner = .shared,
        annotationConverter: AnnotationConverter = AnnotationConverter()
    ) {
        self.ncbiService = ncbiService
        self.toolRunner = toolRunner
        self.annotationConverter = annotationConverter
    }

    // MARK: - Tool Validation

    /// Validates that required native tools are available.
    public func validateTools() async throws {
        try await BundleBuildHelpers.validateTools(using: toolRunner)
    }

    // MARK: - Public API

    /// Downloads FASTA and GFF3 files for an assembly and builds a `.lungfishref` bundle.
    ///
    /// Pipeline:
    /// 1. Validate tools (bgzip, samtools)
    /// 2. Get FASTA + GFF3 file info from NCBI FTP
    /// 3. Download FASTA (compressed .fna.gz) with progress
    /// 4. Download GFF3 (optional, may not exist)
    /// 5. Decompress FASTA (bgzip -d), re-compress with bgzip for random access
    /// 6. Index FASTA (samtools faidx)
    /// 7. Convert GFF3 → BED12 → SQLite DB → BigBed
    /// 8. Write manifest.json
    ///
    /// - Parameters:
    ///   - assembly: The NCBI assembly summary describing the genome.
    ///   - outputDirectory: Where to create the `.lungfishref` bundle.
    ///   - progressHandler: Called with (0.0–1.0, message) during the pipeline.
    /// - Returns: URL of the completed `.lungfishref` bundle.
    public func downloadAndBuild(
        assembly: NCBIAssemblySummary,
        outputDirectory: URL,
        progressHandler: (@Sendable (Double, String) -> Void)? = nil
    ) async throws -> URL {
        let fileManager = FileManager.default
        let accession = assembly.assemblyAccession ?? assembly.uid
        let organismName = assembly.organism ?? assembly.speciesName ?? "Unknown"
        let assemblyName = assembly.assemblyName ?? accession

        logger.info("downloadAndBuild: Starting pipeline for \(accession, privacy: .public) (\(organismName, privacy: .public))")

        // Pre-flight: verify tools
        progressHandler?(0.01, "Checking tools...")
        try await validateTools()

        // Create temp working directory
        let tempDir = fileManager.temporaryDirectory
            .appendingPathComponent("lungfish-genome-\(UUID().uuidString)", isDirectory: true)
        try fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? fileManager.removeItem(at: tempDir) }

        // Step 1: Get FASTA file info
        progressHandler?(0.02, "Locating genome FASTA...")
        logger.info("downloadAndBuild: Getting FASTA file info for \(accession, privacy: .public)")

        let fastaFileInfo = try await ncbiService.getGenomeFileInfo(for: assembly)
        let fastaSizeStr = fastaFileInfo.estimatedSize.map { BundleBuildHelpers.formatBytes($0) } ?? "unknown size"
        logger.info("downloadAndBuild: FASTA file found: \(fastaFileInfo.filename, privacy: .public) (\(fastaSizeStr, privacy: .public))")

        // Step 2: Get GFF3 annotation file info (may not exist)
        progressHandler?(0.03, "Checking for GFF3 annotations...")
        let gffFileInfo = try await ncbiService.getAnnotationFileInfo(for: assembly)
        if let gffInfo = gffFileInfo {
            let gffSizeStr = gffInfo.estimatedSize.map { BundleBuildHelpers.formatBytes($0) } ?? "unknown size"
            logger.info("downloadAndBuild: GFF3 file found: \(gffInfo.filename, privacy: .public) (\(gffSizeStr, privacy: .public))")
        } else {
            logger.info("downloadAndBuild: No GFF3 annotations available for \(accession, privacy: .public)")
        }

        // Step 3: Download FASTA with progress tracking (5%–45%)
        progressHandler?(0.05, "Downloading FASTA (\(fastaSizeStr))...")
        logger.info("downloadAndBuild: Downloading FASTA to temp directory")

        let fastaDestination = tempDir.appendingPathComponent(fastaFileInfo.filename)
        let fastaExpectedBytes = fastaFileInfo.estimatedSize

        _ = try await ncbiService.downloadGenomeFile(
            fastaFileInfo,
            to: fastaDestination
        ) { bytesDownloaded, expectedTotal in
            let total = expectedTotal ?? fastaExpectedBytes
            let fraction: Double
            if let total, total > 0 {
                fraction = Double(bytesDownloaded) / Double(total)
            } else {
                fraction = 0.5
            }
            let overallProgress = 0.05 + (fraction * 0.40)
            let downloadedStr = BundleBuildHelpers.formatBytes(bytesDownloaded)
            let totalStr = total.map { BundleBuildHelpers.formatBytes($0) } ?? "?"
            progressHandler?(overallProgress, "Downloading FASTA: \(downloadedStr) / \(totalStr)")
        }
        logger.info("downloadAndBuild: FASTA download complete")

        // Step 4: Download GFF3 (45%–55%, optional)
        var gffDestination: URL?
        if let gffInfo = gffFileInfo {
            progressHandler?(0.45, "Downloading GFF3 annotations...")
            logger.info("downloadAndBuild: Downloading GFF3 to temp directory")

            let gffDest = tempDir.appendingPathComponent(gffInfo.filename)
            let gffExpectedBytes = gffInfo.estimatedSize

            do {
                _ = try await ncbiService.downloadGenomeFile(
                    gffInfo,
                    to: gffDest
                ) { bytesDownloaded, expectedTotal in
                    let total = expectedTotal ?? gffExpectedBytes
                    let fraction: Double
                    if let total, total > 0 {
                        fraction = Double(bytesDownloaded) / Double(total)
                    } else {
                        fraction = 0.5
                    }
                    let overallProgress = 0.45 + (fraction * 0.10)
                    let downloadedStr = BundleBuildHelpers.formatBytes(bytesDownloaded)
                    let totalStr = total.map { BundleBuildHelpers.formatBytes($0) } ?? "?"
                    progressHandler?(overallProgress, "Downloading GFF3: \(downloadedStr) / \(totalStr)")
                }
                gffDestination = gffDest
                logger.info("downloadAndBuild: GFF3 download complete")
            } catch {
                // GFF3 download failure is non-fatal
                logger.warning("downloadAndBuild: GFF3 download failed (non-fatal): \(error.localizedDescription)")
            }
        }

        // Step 5: Build bundle structure
        progressHandler?(0.55, "Creating bundle...")

        let bundleName = BundleBuildHelpers.sanitizedFilename("\(organismName) - \(assemblyName)")
        let bundleURL = BundleBuildHelpers.makeUniqueBundleURL(baseName: bundleName, in: outputDirectory)
        let genomeDir = bundleURL.appendingPathComponent("genome", isDirectory: true)
        let annotationsDir = bundleURL.appendingPathComponent("annotations", isDirectory: true)
        try fileManager.createDirectory(at: genomeDir, withIntermediateDirectories: true)
        try fileManager.createDirectory(at: annotationsDir, withIntermediateDirectories: true)

        // Step 6: Decompress downloaded FASTA (.fna.gz → .fna) and re-compress with bgzip
        // NCBI genome files are standard gzip; we need bgzip format for random access.
        progressHandler?(0.56, "Decompressing FASTA...")
        logger.info("downloadAndBuild: Decompressing downloaded FASTA")

        // Decompress the downloaded .fna.gz
        let decompressResult = try await toolRunner.bgzipDecompress(inputPath: fastaDestination)
        guard decompressResult.isSuccess else {
            throw BundleBuildError.compressionFailed("bgzip decompress failed: \(decompressResult.combinedOutput)")
        }

        // The decompressed file has the .gz extension removed
        var decompressedFASTA = fastaDestination
        if decompressedFASTA.pathExtension.lowercased() == "gz" {
            decompressedFASTA = decompressedFASTA.deletingPathExtension()
        }

        // Copy decompressed FASTA to bundle
        let plainFASTA = genomeDir.appendingPathComponent("sequence.fa")
        try fileManager.moveItem(at: decompressedFASTA, to: plainFASTA)

        // bgzip compress for random access
        progressHandler?(0.62, "Compressing FASTA (bgzip)...")
        logger.info("downloadAndBuild: bgzip compressing FASTA")

        let bgzipResult = try await toolRunner.bgzipCompress(inputPath: plainFASTA, keepOriginal: false)
        guard bgzipResult.isSuccess else {
            throw BundleBuildError.compressionFailed("bgzip failed: \(bgzipResult.combinedOutput)")
        }

        let compressedFASTA = genomeDir.appendingPathComponent("sequence.fa.gz")
        logger.info("downloadAndBuild: FASTA compressed successfully")

        // Step 7: Index FASTA (samtools faidx)
        progressHandler?(0.70, "Indexing FASTA (samtools faidx)...")
        logger.info("downloadAndBuild: Creating FASTA index")

        let faiResult = try await toolRunner.indexFASTA(fastaPath: compressedFASTA)
        guard faiResult.isSuccess else {
            throw BundleBuildError.indexingFailed("samtools faidx failed: \(faiResult.combinedOutput)")
        }

        let faiURL = compressedFASTA.appendingPathExtension("fai")
        let gziURL = compressedFASTA.appendingPathExtension("gzi")
        let chromosomes = try BundleBuildHelpers.parseFai(at: faiURL)
        let totalLength = chromosomes.reduce(Int64(0)) { $0 + $1.length }
        logger.info("downloadAndBuild: Indexed \(chromosomes.count) chromosomes, total \(totalLength) bp")

        // Step 8: Process GFF3 annotations (if available)
        let chromosomeSizes = chromosomes.map { ($0.name, $0.length) }
        var annotationTracks: [AnnotationTrackInfo] = []

        if let gffURL = gffDestination {
            progressHandler?(0.75, "Converting annotations...")
            logger.info("downloadAndBuild: Converting GFF3 annotations")

            do {
                // Decompress GFF3 if gzipped
                var gffInput = gffURL
                if gffInput.pathExtension.lowercased() == "gz" {
                    let gffDecompressResult = try await toolRunner.bgzipDecompress(inputPath: gffInput)
                    if gffDecompressResult.isSuccess {
                        gffInput = gffInput.deletingPathExtension()
                    } else {
                        logger.warning("downloadAndBuild: GFF3 decompress failed, trying as-is")
                    }
                }

                // GFF3 → BED12
                let bedURL = tempDir.appendingPathComponent("annotations.bed")
                let options = AnnotationConverter.ConversionOptions(bedFormat: .bed12)
                _ = try await annotationConverter.convertToBED(
                    from: gffInput,
                    format: .gff3,
                    output: bedURL,
                    options: options
                )

                // Clip BED coordinates to chromosome boundaries
                BundleBuildHelpers.clipBEDCoordinates(bedURL: bedURL, chromosomeSizes: chromosomeSizes)

                progressHandler?(0.82, "Creating annotation database...")

                // Create SQLite annotation database BEFORE stripping extra columns
                let dbURL = annotationsDir.appendingPathComponent("ncbi_genes.db")
                let dbRecordCount = try AnnotationDatabase.createFromBED(bedURL: bedURL, outputURL: dbURL)
                logger.info("downloadAndBuild: Created annotation database with \(dbRecordCount) records")

                // Strip extra columns (13+) for bedToBigBed
                BundleBuildHelpers.stripExtraBEDColumns(bedURL: bedURL, keepColumns: 12)

                progressHandler?(0.87, "Converting to BigBed...")

                // Write chrom.sizes for bedToBigBed
                let chromSizesURL = tempDir.appendingPathComponent("chrom.sizes")
                try BundleBuildHelpers.writeChromSizes(chromosomes, to: chromSizesURL)

                let bigBedURL = annotationsDir.appendingPathComponent("ncbi_genes.bb")
                let hasBedToBigBed = await toolRunner.isToolAvailable(.bedToBigBed)
                var usedBigBed = false

                if hasBedToBigBed {
                    let bigBedResult = try await toolRunner.convertBEDtoBigBed(
                        bedPath: bedURL,
                        chromSizesPath: chromSizesURL,
                        outputPath: bigBedURL
                    )
                    if bigBedResult.isSuccess {
                        usedBigBed = true
                    } else {
                        logger.warning("downloadAndBuild: bedToBigBed failed, keeping BED: \(bigBedResult.combinedOutput, privacy: .public)")
                    }
                }

                let annotationPath: String
                if usedBigBed {
                    annotationPath = "annotations/ncbi_genes.bb"
                } else {
                    let fallbackBedURL = annotationsDir.appendingPathComponent("ncbi_genes.bed")
                    try fileManager.copyItem(at: bedURL, to: fallbackBedURL)
                    annotationPath = "annotations/ncbi_genes.bed"
                }

                annotationTracks.append(
                    AnnotationTrackInfo(
                        id: "ncbi_genes",
                        name: "Gene Annotations",
                        description: "GFF3 annotations from NCBI for \(assemblyName)",
                        path: annotationPath,
                        databasePath: dbRecordCount > 0 ? "annotations/ncbi_genes.db" : nil,
                        annotationType: .gene,
                        featureCount: dbRecordCount,
                        source: "NCBI",
                        version: nil
                    )
                )
            } catch {
                logger.warning("downloadAndBuild: Annotation conversion failed (continuing without): \(error.localizedDescription, privacy: .public)")
            }
        }

        // Step 9: Write manifest
        progressHandler?(0.93, "Writing bundle manifest...")

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

        let genomeInfo = GenomeInfo(
            path: "genome/sequence.fa.gz",
            indexPath: "genome/sequence.fa.gz.fai",
            gzipIndexPath: fileManager.fileExists(atPath: gziURL.path) ? "genome/sequence.fa.gz.gzi" : nil,
            totalLength: totalLength,
            chromosomes: chromosomes,
            md5Checksum: nil
        )

        let bundleIdentifier = "org.ncbi.assembly.\(accession.lowercased().replacingOccurrences(of: ".", with: "-"))"

        // Convert assembly summary to metadata groups for rich metadata storage
        let metadataGroups = assembly.toMetadataGroups()

        let manifest = BundleManifest(
            name: "\(organismName) - \(assemblyName)",
            identifier: bundleIdentifier,
            description: "\(organismName) genome assembly \(assemblyName)",
            source: sourceInfo,
            genome: genomeInfo,
            annotations: annotationTracks,
            variants: [],
            tracks: [],
            metadata: metadataGroups.isEmpty ? nil : metadataGroups
        )

        let validationErrors = manifest.validate()
        if !validationErrors.isEmpty {
            throw BundleBuildError.validationFailed(validationErrors.map { $0.localizedDescription })
        }

        try manifest.save(to: bundleURL)

        progressHandler?(1.0, "Bundle ready: \(bundleURL.lastPathComponent)")
        logger.info("downloadAndBuild: Pipeline complete. Bundle at \(bundleURL.path, privacy: .public)")
        return bundleURL
    }
}
