// BatchProcessingEngine.swift - Batch processing across demultiplexed barcodes
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import LungfishIO
import os.log

private let logger = Logger(subsystem: "com.lungfish.browser", category: "BatchProcessingEngine")

// MARK: - Batch Processing Error

public enum BatchProcessingError: Error, LocalizedError {
    case noBarcodes
    case recipeEmpty
    case cancelled
    case barcodeNotFound(String)
    case stepFailed(barcode: String, stepIndex: Int, underlying: Error)
    case unsupportedStepInRecipe(String)

    public var errorDescription: String? {
        switch self {
        case .noBarcodes:
            return "No barcode bundles found in the demux group."
        case .recipeEmpty:
            return "The processing recipe contains no steps."
        case .cancelled:
            return "Batch processing was cancelled."
        case .barcodeNotFound(let label):
            return "Barcode bundle not found: \(label)"
        case .stepFailed(let barcode, let stepIndex, let underlying):
            return "Step \(stepIndex) failed for barcode \(barcode): \(underlying)"
        case .unsupportedStepInRecipe(let kind):
            return "Operation '\(kind)' is not supported as a batch recipe step."
        }
    }
}

// MARK: - Batch Progress

/// Progress tracking for a batch processing run.
public struct BatchProgress: Sendable {
    public let totalBarcodes: Int
    public let completedBarcodes: Int
    public let currentBarcode: String?
    public let currentStep: Int?
    public let totalSteps: Int
    public let message: String

    public var overallFraction: Double {
        guard totalBarcodes > 0, totalSteps > 0 else { return 0 }
        let stepsPerBarcode = totalSteps
        let totalWork = totalBarcodes * stepsPerBarcode
        let completedWork = completedBarcodes * stepsPerBarcode + (currentStep ?? 0)
        return Double(completedWork) / Double(totalWork)
    }
}

// MARK: - Batch Processing Engine

/// Processes all barcodes in a demux group through a recipe pipeline.
///
/// Executes steps sequentially per barcode, with bounded concurrency across
/// barcodes. Each barcode's output feeds into the next step as input.
///
/// ```
/// multiplexed-demux/
/// ├── batch-runs/
/// │   └── {batch-name}/
/// │       ├── batch.manifest.json
/// │       ├── recipe.json
/// │       ├── comparison.json
/// │       └── bc01/
/// │           ├── step-1-qtrim-Q20/
/// │           │   └── bc01-trimmed.lungfishfastq/
/// │           └── step-2-adapter-trim/
/// ```
public actor BatchProcessingEngine {

    private let derivativeService: FASTQDerivativeService
    private let maxConcurrency: Int

    /// Active cancellation flag.
    private var isCancelled = false

    public init(
        derivativeService: FASTQDerivativeService,
        maxConcurrency: Int = 4
    ) {
        self.derivativeService = derivativeService
        self.maxConcurrency = max(1, maxConcurrency)
    }

    /// Cancels the current batch processing run.
    public func cancel() {
        isCancelled = true
    }

    /// Executes a recipe across all barcode bundles in a demux group.
    ///
    /// - Parameters:
    ///   - demuxGroupURL: URL to the demux group directory (e.g., `multiplexed-demux/`).
    ///   - manifest: The demultiplex manifest from the parent bundle.
    ///   - recipe: The processing recipe to apply.
    ///   - batchName: Human-readable name for this batch run.
    ///   - progress: Callback for progress updates.
    /// - Returns: The completed `BatchManifest` with timing info.
    public func executeBatch(
        demuxGroupURL: URL,
        manifest: DemultiplexManifest,
        recipe: ProcessingRecipe,
        batchName: String,
        progress: (@Sendable (BatchProgress) -> Void)? = nil
    ) async throws -> BatchManifest {
        guard !manifest.barcodes.isEmpty else { throw BatchProcessingError.noBarcodes }
        guard !recipe.steps.isEmpty else { throw BatchProcessingError.recipeEmpty }

        isCancelled = false

        // Create batch run directory
        let batchRunsDir = demuxGroupURL.appendingPathComponent("batch-runs", isDirectory: true)
        let batchDir = batchRunsDir.appendingPathComponent(batchName, isDirectory: true)
        try FileManager.default.createDirectory(at: batchDir, withIntermediateDirectories: true)

        // Save recipe snapshot
        try recipe.save(to: batchDir.appendingPathComponent("recipe.json"))

        // Build barcode labels
        let barcodeLabels = manifest.barcodes.map { $0.displayName }

        var batchManifest = BatchManifest(
            recipeName: recipe.name,
            recipeID: recipe.id,
            batchName: batchName,
            barcodeCount: manifest.barcodes.count,
            stepCount: recipe.steps.count,
            barcodeLabels: barcodeLabels
        )

        // Process barcodes with bounded concurrency
        let results = try await withThrowingTaskGroup(of: (Int, BarcodeSummary).self) { group in
            var activeTasks = 0
            var barcodeIndex = 0
            var collectedResults: [(Int, BarcodeSummary)] = []

            while barcodeIndex < manifest.barcodes.count || activeTasks > 0 {
                // Launch tasks up to concurrency limit
                while activeTasks < maxConcurrency && barcodeIndex < manifest.barcodes.count {
                    guard !isCancelled else { throw BatchProcessingError.cancelled }

                    let barcode = manifest.barcodes[barcodeIndex]
                    let idx = barcodeIndex
                    barcodeIndex += 1
                    activeTasks += 1

                    group.addTask { [self] in
                        let summary = try await self.processBarcode(
                            barcode: barcode,
                            barcodeIndex: idx,
                            demuxGroupURL: demuxGroupURL,
                            batchDir: batchDir,
                            recipe: recipe,
                            totalBarcodes: manifest.barcodes.count,
                            progress: progress
                        )
                        return (idx, summary)
                    }
                }

                // Wait for one task to complete
                if let result = try await group.next() {
                    collectedResults.append(result)
                    activeTasks -= 1

                    progress?(BatchProgress(
                        totalBarcodes: manifest.barcodes.count,
                        completedBarcodes: collectedResults.count,
                        currentBarcode: nil,
                        currentStep: nil,
                        totalSteps: recipe.steps.count,
                        message: "Completed \(collectedResults.count)/\(manifest.barcodes.count) barcodes"
                    ))
                }
            }

            return collectedResults
        }

        // Sort results by original index
        let sortedSummaries = results.sorted(by: { $0.0 < $1.0 }).map(\.1)

        // Build step definitions for the comparison manifest
        let stepDefs = recipe.steps.enumerated().map { index, step in
            StepDefinition(
                index: index,
                operationKind: step.kind.rawValue,
                shortLabel: step.shortLabel,
                displaySummary: step.displaySummary
            )
        }

        // Generate comparison manifest
        let comparison = BatchComparisonManifest(
            batchID: batchManifest.batchID,
            recipeName: recipe.name,
            steps: stepDefs,
            barcodes: sortedSummaries
        )
        try comparison.save(to: batchDir)

        // Finalize batch manifest
        batchManifest.completedAt = Date()
        try batchManifest.save(to: batchDir)

        logger.info("Batch '\(batchName)' completed: \(manifest.barcodes.count) barcodes × \(recipe.steps.count) steps")

        return batchManifest
    }

    // MARK: - Per-Barcode Processing

    /// Processes a single barcode through all recipe steps sequentially.
    private func processBarcode(
        barcode: BarcodeResult,
        barcodeIndex: Int,
        demuxGroupURL: URL,
        batchDir: URL,
        recipe: ProcessingRecipe,
        totalBarcodes: Int,
        progress: (@Sendable (BatchProgress) -> Void)?
    ) async throws -> BarcodeSummary {
        let barcodeDir = batchDir.appendingPathComponent(barcode.displayName, isDirectory: true)
        try FileManager.default.createDirectory(at: barcodeDir, withIntermediateDirectories: true)

        // Resolve the barcode's source bundle
        let sourceBundleURL = demuxGroupURL.appendingPathComponent(barcode.bundleRelativePath)
        guard FileManager.default.fileExists(atPath: sourceBundleURL.path) else {
            throw BatchProcessingError.barcodeNotFound(barcode.displayName)
        }

        // Load input statistics for retention calculations
        let inputStats = loadBundleStatistics(from: sourceBundleURL)
        let inputMetrics = StepMetrics(
            readCount: inputStats?.readCount ?? barcode.readCount,
            baseCount: inputStats?.baseCount ?? barcode.baseCount,
            meanReadLength: inputStats?.meanReadLength ?? (barcode.meanReadLength ?? 0),
            medianReadLength: inputStats?.medianReadLength ?? 0,
            n50ReadLength: inputStats?.n50ReadLength ?? 0,
            meanQuality: inputStats?.meanQuality ?? (barcode.meanQuality ?? 0),
            q20Percentage: inputStats?.q20Percentage ?? 0,
            q30Percentage: inputStats?.q30Percentage ?? 0,
            gcContent: inputStats?.gcContent ?? 0
        )

        var currentInputURL = sourceBundleURL
        var stepResults: [StepResult] = []
        let rawReadCount = inputMetrics.readCount

        for (stepIndex, step) in recipe.steps.enumerated() {
            guard !isCancelled else { throw BatchProcessingError.cancelled }

            progress?(BatchProgress(
                totalBarcodes: totalBarcodes,
                completedBarcodes: barcodeIndex,
                currentBarcode: barcode.displayName,
                currentStep: stepIndex,
                totalSteps: recipe.steps.count,
                message: "\(barcode.displayName): \(step.shortLabel) (\(stepIndex + 1)/\(recipe.steps.count))"
            ))

            let stepDir = barcodeDir.appendingPathComponent(
                "step-\(stepIndex + 1)-\(step.shortLabel)",
                isDirectory: true
            )
            try FileManager.default.createDirectory(at: stepDir, withIntermediateDirectories: true)

            do {
                let request = try convertStepToRequest(step)
                let outputURL = try await derivativeService.createDerivative(
                    from: currentInputURL,
                    request: request,
                    progress: { message in
                        progress?(BatchProgress(
                            totalBarcodes: totalBarcodes,
                            completedBarcodes: barcodeIndex,
                            currentBarcode: barcode.displayName,
                            currentStep: stepIndex,
                            totalSteps: recipe.steps.count,
                            message: "\(barcode.displayName): \(message)"
                        ))
                    }
                )

                // Move output bundle into step directory (atomic replace)
                let destURL = stepDir.appendingPathComponent(outputURL.lastPathComponent)
                if FileManager.default.fileExists(atPath: destURL.path) {
                    _ = try FileManager.default.replaceItemAt(destURL, withItemAt: outputURL)
                } else {
                    try FileManager.default.moveItem(at: outputURL, to: destURL)
                }

                // Load output statistics
                let outputStats = loadBundleStatistics(from: destURL)
                let previousReadCount = stepResults.last?.metrics.readCount ?? rawReadCount
                let outputMetrics: StepMetrics
                if let stats = outputStats {
                    outputMetrics = StepMetrics(
                        from: stats,
                        inputReadCount: previousReadCount,
                        rawInputReadCount: rawReadCount
                    )
                } else {
                    outputMetrics = .empty
                }

                stepResults.append(StepResult(
                    stepIndex: stepIndex,
                    status: .completed,
                    metrics: outputMetrics,
                    bundleRelativePath: destURL.lastPathComponent
                ))

                currentInputURL = destURL

            } catch {
                logger.warning("Step \(stepIndex) failed for \(barcode.displayName): \(error)")

                stepResults.append(StepResult(
                    stepIndex: stepIndex,
                    status: .failed,
                    metrics: .empty,
                    errorMessage: error.localizedDescription
                ))

                // Skip remaining steps for this barcode on failure
                for remainingIndex in (stepIndex + 1)..<recipe.steps.count {
                    stepResults.append(StepResult(
                        stepIndex: remainingIndex,
                        status: .skipped,
                        metrics: .empty
                    ))
                }
                break
            }
        }

        return BarcodeSummary(
            label: barcode.displayName,
            inputMetrics: inputMetrics,
            stepResults: stepResults
        )
    }

    // MARK: - Helpers

    /// Converts a recipe step (FASTQDerivativeOperation) into a service request.
    private func convertStepToRequest(_ step: FASTQDerivativeOperation) throws -> FASTQDerivativeRequest {
        switch step.kind {
        case .subsampleProportion:
            return .subsampleProportion(step.proportion ?? 0.1)
        case .subsampleCount:
            return .subsampleCount(step.count ?? 1000)
        case .lengthFilter:
            return .lengthFilter(min: step.minLength, max: step.maxLength)
        case .searchText:
            return .searchText(
                query: step.query ?? "",
                field: step.searchField ?? .id,
                regex: step.useRegex ?? false
            )
        case .searchMotif:
            return .searchMotif(pattern: step.query ?? "", regex: step.useRegex ?? false)
        case .deduplicate:
            return .deduplicate(
                mode: step.deduplicateMode ?? .identifier,
                pairedAware: step.pairedAware ?? false
            )
        case .qualityTrim:
            return .qualityTrim(
                threshold: step.qualityThreshold ?? 20,
                windowSize: step.windowSize ?? 4,
                mode: step.qualityTrimMode ?? .cutRight
            )
        case .adapterTrim:
            return .adapterTrim(
                mode: step.adapterMode ?? .autoDetect,
                sequence: step.adapterSequence,
                sequenceR2: step.adapterSequenceR2,
                fastaFilename: step.adapterFastaFilename
            )
        case .fixedTrim:
            return .fixedTrim(
                from5Prime: step.trimFrom5Prime ?? 0,
                from3Prime: step.trimFrom3Prime ?? 0
            )
        case .contaminantFilter:
            return .contaminantFilter(
                mode: step.contaminantFilterMode ?? .phix,
                referenceFasta: step.contaminantReferenceFasta,
                kmerSize: step.contaminantKmerSize ?? 31,
                hammingDistance: step.contaminantHammingDistance ?? 1
            )
        case .pairedEndMerge:
            return .pairedEndMerge(
                strictness: step.mergeStrictness ?? .normal,
                minOverlap: step.mergeMinOverlap ?? 12
            )
        case .pairedEndRepair:
            return .pairedEndRepair
        case .primerRemoval:
            return .primerRemoval(
                source: step.primerSource ?? .literal,
                literalSequence: step.primerLiteralSequence,
                referenceFasta: step.primerReferenceFasta,
                kmerSize: step.primerKmerSize ?? 23,
                minKmer: step.primerMinKmer ?? 11,
                hammingDistance: step.primerHammingDistance ?? 1
            )
        case .errorCorrection:
            return .errorCorrection(kmerSize: step.errorCorrectionKmerSize ?? 50)
        case .interleaveReformat:
            return .interleaveReformat(direction: step.interleaveDirection ?? .interleave)
        case .demultiplex:
            // Demultiplexing is not a derivative request — it's handled separately.
            // This case should never be in a recipe's steps array.
            throw BatchProcessingError.unsupportedStepInRecipe(step.kind.rawValue)
        case .orient:
            // Orientation is not yet supported in batch recipes.
            throw BatchProcessingError.unsupportedStepInRecipe(step.kind.rawValue)
        }
    }

    /// Loads cached statistics from a bundle's metadata.
    private func loadBundleStatistics(from bundleURL: URL) -> FASTQDatasetStatistics? {
        // Try derived manifest first
        if let derived = FASTQBundle.loadDerivedManifest(in: bundleURL) {
            return derived.cachedStatistics
        }
        // Try persisted metadata from the primary FASTQ in the bundle
        if let fastqURL = FASTQBundle.resolvePrimaryFASTQURL(for: bundleURL),
           let metadata = FASTQMetadataStore.load(for: fastqURL) {
            return metadata.computedStatistics
        }
        return nil
    }
}
