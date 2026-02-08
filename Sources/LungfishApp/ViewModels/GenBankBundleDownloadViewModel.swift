// GenBankBundleDownloadViewModel.swift - NCBI GenBank download and bundle building
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import LungfishCore
import LungfishIO
import LungfishWorkflow
import os.log

private let genBankDownloadLogger = Logger(subsystem: "com.lungfish.browser", category: "GenBankBundleDownload")

/// Builds NCBI GenBank nucleotide downloads into `.lungfishref` bundles.
///
/// This implementation avoids MainActor-only bundle builders so it can run safely
/// while the NCBI browser sheet is open.
public final class GenBankBundleDownloadViewModel: @unchecked Sendable {

    private let ncbiService: NCBIService
    private let toolRunner: NativeToolRunner
    private let annotationConverter: AnnotationConverter

    public init(
        ncbiService: NCBIService = NCBIService(),
        toolRunner: NativeToolRunner = .shared,
        annotationConverter: AnnotationConverter = AnnotationConverter()
    ) {
        self.ncbiService = ncbiService
        self.toolRunner = toolRunner
        self.annotationConverter = annotationConverter
    }

    /// Validates that required tools are available before attempting a download.
    ///
    /// - Throws: `BundleBuildError.missingTools` if essential tools are missing.
    public func validateTools() async throws {
        try await BundleBuildHelpers.validateTools(using: toolRunner)
    }

    public func downloadAndBuild(
        accession: String,
        outputDirectory: URL,
        progressHandler: (@Sendable (Double, String) -> Void)? = nil
    ) async throws -> URL {
        let fileManager = FileManager.default

        // Pre-flight: verify tools are available
        progressHandler?(0.01, "Checking tools...")
        try await validateTools()

        let tempDir = fileManager.temporaryDirectory
            .appendingPathComponent("lungfish-genbank-\(UUID().uuidString)", isDirectory: true)
        try fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? fileManager.removeItem(at: tempDir) }

        progressHandler?(0.02, "Resolving accession \(accession)...")
        genBankDownloadLogger.info("downloadAndBuild: Fetching raw GenBank for \(accession, privacy: .public)")

        let (genBankContent, resolvedAccession) = try await ncbiService.fetchRawGenBank(accession: accession)
        let genBankURL = tempDir.appendingPathComponent("\(resolvedAccession).gb")
        try genBankContent.write(to: genBankURL, atomically: true, encoding: .utf8)

        progressHandler?(0.12, "Parsing GenBank record \(resolvedAccession)...")

        let reader = try GenBankReader(url: genBankURL)
        let records = try await reader.readAll()
        guard let record = records.first else {
            throw DatabaseServiceError.parseError(message: "No sequence records found in GenBank response")
        }

        let bundleURL = BundleBuildHelpers.makeUniqueBundleURL(
            baseName: BundleBuildHelpers.sanitizedFilename(resolvedAccession),
            in: outputDirectory
        )
        let genomeDir = bundleURL.appendingPathComponent("genome", isDirectory: true)
        let annotationsDir = bundleURL.appendingPathComponent("annotations", isDirectory: true)
        try fileManager.createDirectory(at: genomeDir, withIntermediateDirectories: true)
        try fileManager.createDirectory(at: annotationsDir, withIntermediateDirectories: true)

        progressHandler?(0.25, "Writing FASTA...")

        let plainFASTA = genomeDir.appendingPathComponent("sequence.fa")
        try FASTAWriter(url: plainFASTA).write([record.sequence])

        progressHandler?(0.35, "Compressing FASTA (bgzip)...")

        let bgzipResult = try await toolRunner.bgzipCompress(inputPath: plainFASTA, keepOriginal: false)
        guard bgzipResult.isSuccess else {
            throw BundleBuildError.compressionFailed(bgzipResult.combinedOutput)
        }

        let compressedFASTA = genomeDir.appendingPathComponent("sequence.fa.gz")

        progressHandler?(0.45, "Indexing FASTA (samtools faidx)...")

        let faiResult = try await toolRunner.indexFASTA(fastaPath: compressedFASTA)
        guard faiResult.isSuccess else {
            throw BundleBuildError.indexingFailed(faiResult.combinedOutput)
        }

        let faiURL = compressedFASTA.appendingPathExtension("fai")
        let gziURL = compressedFASTA.appendingPathExtension("gzi")

        let chromosomes = try BundleBuildHelpers.parseFai(at: faiURL)
        let totalLength = chromosomes.reduce(Int64(0)) { $0 + $1.length }

        // Build chromosome sizes for annotation coordinate clipping
        let chromosomeSizes = chromosomes.map { ($0.name, $0.length) }
        let chromSizesURL = tempDir.appendingPathComponent("chrom.sizes")
        try BundleBuildHelpers.writeChromSizes(chromosomes, to: chromSizesURL)

        var annotationTracks: [AnnotationTrackInfo] = []
        if !record.annotations.isEmpty {
            progressHandler?(0.55, "Converting annotations...")

            do {
                let gffURL = tempDir.appendingPathComponent("annotations.gff3")
                try await GFF3Writer.write(record.annotations, to: gffURL, source: "NCBI")

                // Use BED12 format so feature type lands in column 12 (matches NativeBundleBuilder)
                let bedURL = tempDir.appendingPathComponent("annotations.bed")
                let options = AnnotationConverter.ConversionOptions(bedFormat: .bed12)
                _ = try await annotationConverter.convertToBED(
                    from: gffURL,
                    format: .gff3,
                    output: bedURL,
                    options: options
                )

                // Clip BED coordinates to chromosome boundaries (required for bedToBigBed)
                BundleBuildHelpers.clipBEDCoordinates(bedURL: bedURL, chromosomeSizes: chromosomeSizes)

                progressHandler?(0.65, "Creating annotation database...")

                // Create SQLite annotation database BEFORE stripping extra columns
                let dbURL = annotationsDir.appendingPathComponent("ncbi_genbank_annotations.db")
                let dbRecordCount = try AnnotationDatabase.createFromBED(bedURL: bedURL, outputURL: dbURL)
                genBankDownloadLogger.info("downloadAndBuild: Created annotation database with \(dbRecordCount) records")

                // Strip extra columns (13+) for bedToBigBed — it only handles standard BED12.
                BundleBuildHelpers.stripExtraBEDColumns(bedURL: bedURL, keepColumns: 12)

                progressHandler?(0.72, "Converting to BigBed...")

                let bigBedURL = annotationsDir.appendingPathComponent("ncbi_genbank_annotations.bb")
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
                        genBankDownloadLogger.warning("downloadAndBuild: bedToBigBed failed, keeping BED: \(bigBedResult.combinedOutput, privacy: .public)")
                    }
                } else {
                    genBankDownloadLogger.warning("downloadAndBuild: bedToBigBed unavailable, keeping BED")
                }

                // Use BigBed if available, otherwise copy BED as fallback
                let annotationPath: String
                if usedBigBed {
                    annotationPath = "annotations/ncbi_genbank_annotations.bb"
                    try? fileManager.removeItem(at: bedURL)
                } else {
                    let fallbackBedURL = annotationsDir.appendingPathComponent("ncbi_genbank_annotations.bed")
                    try fileManager.copyItem(at: bedURL, to: fallbackBedURL)
                    annotationPath = "annotations/ncbi_genbank_annotations.bed"
                }

                annotationTracks.append(
                    AnnotationTrackInfo(
                        id: "ncbi_genbank_annotations",
                        name: "NCBI GenBank Annotations",
                        description: "Converted from GenBank FEATURES",
                        path: annotationPath,
                        databasePath: dbRecordCount > 0 ? "annotations/ncbi_genbank_annotations.db" : nil,
                        annotationType: .gene,
                        featureCount: record.annotations.count,
                        source: "NCBI",
                        version: nil
                    )
                )
            } catch {
                genBankDownloadLogger.warning("downloadAndBuild: Annotation conversion failed (continuing without annotations): \(error.localizedDescription, privacy: .public)")
            }
        }

        progressHandler?(0.85, "Writing bundle manifest...")

        let genomeInfo = GenomeInfo(
            path: "genome/sequence.fa.gz",
            indexPath: "genome/sequence.fa.gz.fai",
            gzipIndexPath: fileManager.fileExists(atPath: gziURL.path) ? "genome/sequence.fa.gz.gzi" : nil,
            totalLength: totalLength,
            chromosomes: chromosomes,
            md5Checksum: nil
        )

        let sourceInfo = SourceInfo(
            organism: record.sequence.description ?? record.definition ?? "Unknown",
            commonName: nil,
            taxonomyId: nil,
            assembly: record.sequence.name,
            assemblyAccession: resolvedAccession,
            database: "NCBI",
            sourceURL: URL(string: "https://www.ncbi.nlm.nih.gov/nuccore/\(resolvedAccession)"),
            downloadDate: Date(),
            notes: "Downloaded from NCBI GenBank and converted to Lungfish reference bundle"
        )

        let bundleIdentifier = "org.ncbi.genbank.\(resolvedAccession.lowercased().replacingOccurrences(of: ".", with: "-"))"

        let manifest = BundleManifest(
            name: resolvedAccession,
            identifier: bundleIdentifier,
            description: record.definition,
            source: sourceInfo,
            genome: genomeInfo,
            annotations: annotationTracks,
            variants: [],
            tracks: []
        )

        let validationErrors = manifest.validate()
        if !validationErrors.isEmpty {
            throw BundleBuildError.validationFailed(validationErrors.map { $0.localizedDescription })
        }

        try manifest.save(to: bundleURL)

        progressHandler?(1.0, "Bundle ready: \(bundleURL.lastPathComponent)")
        genBankDownloadLogger.info("downloadAndBuild: Bundle complete at \(bundleURL.path, privacy: .public)")
        return bundleURL
    }
}
