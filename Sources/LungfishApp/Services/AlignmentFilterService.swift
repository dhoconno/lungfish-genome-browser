// AlignmentFilterService.swift - Bundle-centric filtered BAM derivation service
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import LungfishCore
import LungfishIO
import LungfishWorkflow
import os.log

private let alignmentFilterLogger = Logger(subsystem: LogSubsystem.app, category: "AlignmentFilterService")

/// Injectable BAM importer used by alignment derivation services.
public protocol AlignmentBAMImporting: Sendable {
    func importBAM(
        bamURL: URL,
        bundleURL: URL,
        name: String?,
        progressHandler: (@Sendable (Double, String) -> Void)?
    ) async throws -> BAMImportService.ImportResult
}

/// BAMImportService-backed importer used in production code.
public struct AlignmentBAMImporter: AlignmentBAMImporting, Sendable {
    public init() {}

    public func importBAM(
        bamURL: URL,
        bundleURL: URL,
        name: String?,
        progressHandler: (@Sendable (Double, String) -> Void)?
    ) async throws -> BAMImportService.ImportResult {
        try await BAMImportService.importBAM(
            bamURL: bamURL,
            bundleURL: bundleURL,
            name: name,
            progressHandler: progressHandler
        )
    }
}

/// Errors thrown while deriving a filtered BAM from a bundle alignment track.
public enum AlignmentFilterServiceError: Error, LocalizedError, Sendable, Equatable {
    case sourceTrackNotFound(String)
    case missingRequiredSAMTags([String], sourceTrackID: String)
    case invalidCountOutput(String)
    case samtoolsFailed(String)

    public var errorDescription: String? {
        switch self {
        case .sourceTrackNotFound(let trackID):
            return "Could not find alignment track '\(trackID)' in the bundle."
        case .missingRequiredSAMTags(let tags, let sourceTrackID):
            return "Alignment track '\(sourceTrackID)' is missing required SAM tags: \(tags.joined(separator: ", "))"
        case .invalidCountOutput(let output):
            return "samtools returned an invalid alignment count: \(output)"
        case .samtoolsFailed(let message):
            return "samtools BAM filtering failed: \(message)"
        }
    }
}

/// Result of deriving a filtered BAM and importing it back into the source bundle.
public struct AlignmentFilterServiceResult: Sendable {
    public let importResult: BAMImportService.ImportResult
    public let commandHistory: [AlignmentCommandExecutionRecord]

    public init(
        importResult: BAMImportService.ImportResult,
        commandHistory: [AlignmentCommandExecutionRecord]
    ) {
        self.importResult = importResult
        self.commandHistory = commandHistory
    }
}

/// Shared service for deriving filtered BAM tracks from bundle alignments.
public final class AlignmentFilterService: @unchecked Sendable {
    private let samtoolsRunner: any AlignmentSamtoolsRunning
    private let markdupPipeline: any AlignmentMarkdupPipelining
    private let bamImporter: any AlignmentBAMImporting

    public init(
        samtoolsRunner: any AlignmentSamtoolsRunning = NativeToolSamtoolsRunner.shared,
        markdupPipeline: (any AlignmentMarkdupPipelining)? = nil,
        bamImporter: any AlignmentBAMImporting = AlignmentBAMImporter()
    ) {
        self.samtoolsRunner = samtoolsRunner
        self.markdupPipeline = markdupPipeline ?? AlignmentMarkdupPipeline(samtoolsRunner: samtoolsRunner)
        self.bamImporter = bamImporter
    }

    public func deriveFilteredAlignment(
        bundleURL: URL,
        sourceTrackID: String,
        outputTrackName: String,
        filterRequest: AlignmentFilterRequest,
        progressHandler: (@Sendable (Double, String) -> Void)? = nil
    ) async throws -> AlignmentFilterServiceResult {
        let bundle = try await ReferenceBundle(url: bundleURL)
        guard let sourceTrack = bundle.alignmentTrack(id: sourceTrackID) else {
            throw AlignmentFilterServiceError.sourceTrackNotFound(sourceTrackID)
        }

        let sourceAlignmentPath = try bundle.resolveAlignmentPath(sourceTrack)
        let sourceIndexPath = try bundle.resolveAlignmentIndexPath(sourceTrack)
        let referenceFastaPath = bundle.referenceFASTAPath()
        let plan = try AlignmentFilterCommandBuilder.build(from: filterRequest)

        progressHandler?(0.05, "Checking required SAM tags...")
        try await preflightRequiredTags(
            plan.requiredSAMTags,
            plan: plan,
            inputPath: sourceAlignmentPath,
            sourceTrackID: sourceTrackID
        )

        let outputRoot = bundleURL.appendingPathComponent("alignments/filtered", isDirectory: true)
        try FileManager.default.createDirectory(at: outputRoot, withIntermediateDirectories: true)

        let workDir = outputRoot.appendingPathComponent(".filter-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: workDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: workDir) }

        let sortedOutputURL = workDir.appendingPathComponent("\(sourceTrackID).filtered.sorted.bam")
        let unsortedOutputURL = workDir.appendingPathComponent("\(sourceTrackID).filtered.unsorted.bam")
        var currentInputURL = URL(fileURLWithPath: sourceAlignmentPath)
        var commandHistory: [AlignmentCommandExecutionRecord] = []

        for step in plan.preprocessingSteps {
            switch step {
            case .samtoolsMarkdup(let removeDuplicates):
                let markdupOutputURL = workDir.appendingPathComponent("\(sourceTrackID).preprocessed.markdup.bam")
                progressHandler?(0.18, "Running duplicate preprocessing...")
                let result = try await markdupPipeline.run(
                    inputURL: currentInputURL,
                    outputURL: markdupOutputURL,
                    removeDuplicates: removeDuplicates,
                    referenceFastaPath: referenceFastaPath,
                    progressHandler: progressHandler
                )
                currentInputURL = result.outputURL
                commandHistory += result.commandHistory
            }
        }

        progressHandler?(0.55, "Filtering alignments...")
        let baseViewArgs = plan.commandArguments(appendingInputPath: currentInputURL.path)
        let viewArgs = insertingOutputPath(
            unsortedOutputURL.path,
            into: baseViewArgs,
            trailingArgumentCount: plan.trailingArguments.count
        )
        _ = try await runSamtoolsOrThrow(arguments: viewArgs, timeout: 3600)
        commandHistory.append(
            AlignmentCommandExecutionRecord(
                arguments: viewArgs,
                inputFile: currentInputURL.path,
                outputFile: unsortedOutputURL.path
            )
        )

        progressHandler?(0.72, "Sorting filtered BAM...")
        var sortArgs = ["sort", "-o", sortedOutputURL.path]
        if let referenceFastaPath {
            sortArgs += ["--reference", referenceFastaPath]
        }
        sortArgs.append(unsortedOutputURL.path)
        _ = try await runSamtoolsOrThrow(arguments: sortArgs, timeout: 3600)
        commandHistory.append(
            AlignmentCommandExecutionRecord(
                arguments: sortArgs,
                inputFile: unsortedOutputURL.path,
                outputFile: sortedOutputURL.path
            )
        )

        progressHandler?(0.84, "Indexing filtered BAM...")
        let indexArgs = ["index", sortedOutputURL.path]
        _ = try await runSamtoolsOrThrow(arguments: indexArgs, timeout: 3600)
        commandHistory.append(
            AlignmentCommandExecutionRecord(
                arguments: indexArgs,
                inputFile: sortedOutputURL.path,
                outputFile: sortedOutputURL.path + ".bai"
            )
        )

        progressHandler?(0.9, "Importing derived BAM...")
        let importResult = try await bamImporter.importBAM(
            bamURL: sortedOutputURL,
            bundleURL: bundleURL,
            name: outputTrackName,
            progressHandler: progressHandler
        )
        let relocatedImportResult = try relocateImportedTrackIntoFilteredStorage(
            importResult: importResult,
            bundleURL: bundleURL
        )

        try appendDerivationMetadata(
            importResult: relocatedImportResult,
            bundleURL: bundleURL,
            sourceTrack: sourceTrack,
            sourceAlignmentPath: sourceAlignmentPath,
            sourceIndexPath: sourceIndexPath,
            filterRequest: filterRequest,
            preprocessingSteps: plan.preprocessingSteps,
            commandHistory: commandHistory
        )

        alignmentFilterLogger.info("Derived filtered BAM track from \(sourceTrackID, privacy: .public)")
        progressHandler?(1.0, "Filtered alignment imported.")
        return AlignmentFilterServiceResult(importResult: relocatedImportResult, commandHistory: commandHistory)
    }

    private func preflightRequiredTags(
        _ requiredSAMTags: [String],
        plan: AlignmentFilterCommandPlan,
        inputPath: String,
        sourceTrackID: String
    ) async throws {
        guard !requiredSAMTags.isEmpty else { return }

        let totalCount = try await alignmentCount(
            arguments: preflightCountArguments(for: plan, inputPath: inputPath, requiredTag: nil)
        )
        guard totalCount > 0 else { return }

        var missingTags: [String] = []
        for tag in requiredSAMTags.sorted() {
            let taggedCount = try await alignmentCount(
                arguments: preflightCountArguments(for: plan, inputPath: inputPath, requiredTag: tag)
            )
            if taggedCount != totalCount {
                missingTags.append(tag)
            }
        }

        if !missingTags.isEmpty {
            throw AlignmentFilterServiceError.missingRequiredSAMTags(missingTags, sourceTrackID: sourceTrackID)
        }
    }

    private func alignmentCount(arguments: [String]) async throws -> Int {
        let result = try await runSamtoolsOrThrow(arguments: arguments, timeout: 300)
        guard let count = Int(result.stdout.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) else {
            throw AlignmentFilterServiceError.invalidCountOutput(result.stdout)
        }
        return count
    }

    private func runSamtoolsOrThrow(arguments: [String], timeout: TimeInterval) async throws -> NativeToolResult {
        let result = try await samtoolsRunner.runSamtools(arguments: arguments, timeout: timeout)
        guard result.isSuccess else {
            throw AlignmentFilterServiceError.samtoolsFailed(
                result.stderr.isEmpty ? "samtools exited with \(result.exitCode)" : result.stderr
            )
        }
        return result
    }

    private func preflightCountArguments(
        for plan: AlignmentFilterCommandPlan,
        inputPath: String,
        requiredTag: String?
    ) -> [String] {
        var arguments = plan.commandArguments(appendingInputPath: inputPath)

        if let binaryIndex = arguments.firstIndex(of: "-b") {
            arguments.remove(at: binaryIndex)
        }

        if let identityExpression = plan.identityFilterExpression,
           let expressionIndex = arguments.firstIndex(of: "-e"),
           expressionIndex + 1 < arguments.count,
           arguments[expressionIndex + 1] == identityExpression {
            arguments.removeSubrange(expressionIndex...(expressionIndex + 1))
        }

        arguments.insert("-c", at: 1)

        if let requiredTag {
            let inputIndex = max(1, arguments.count - plan.trailingArguments.count - 1)
            arguments.insert(contentsOf: ["-e", "exists([\(requiredTag)])"], at: inputIndex)
        }

        return arguments
    }

    private func insertingOutputPath(
        _ outputPath: String,
        into arguments: [String],
        trailingArgumentCount: Int
    ) -> [String] {
        guard !arguments.isEmpty else { return arguments }
        var rewritten = arguments
        let inputIndex = max(1, rewritten.count - trailingArgumentCount - 1)
        rewritten.insert(contentsOf: ["-o", outputPath], at: inputIndex)
        return rewritten
    }

    private func relocateImportedTrackIntoFilteredStorage(
        importResult: BAMImportService.ImportResult,
        bundleURL: URL
    ) throws -> BAMImportService.ImportResult {
        let trackInfo = importResult.trackInfo
        guard !trackInfo.sourcePath.hasPrefix("alignments/filtered/") else {
            return importResult
        }

        let filteredDirectoryURL = bundleURL.appendingPathComponent("alignments/filtered", isDirectory: true)
        try FileManager.default.createDirectory(at: filteredDirectoryURL, withIntermediateDirectories: true)

        let sourceURL = resolveBundlePath(trackInfo.sourcePath, bundleURL: bundleURL)
        let indexURL = resolveBundlePath(trackInfo.indexPath, bundleURL: bundleURL)
        let destinationSourceRelativePath = "alignments/filtered/\(sourceURL.lastPathComponent)"
        let destinationIndexRelativePath = "alignments/filtered/\(indexURL.lastPathComponent)"
        let destinationSourceURL = bundleURL.appendingPathComponent(destinationSourceRelativePath)
        let destinationIndexURL = bundleURL.appendingPathComponent(destinationIndexRelativePath)

        try replaceItemIfPresent(at: destinationSourceURL)
        try replaceItemIfPresent(at: destinationIndexURL)
        try FileManager.default.moveItem(at: sourceURL, to: destinationSourceURL)
        try FileManager.default.moveItem(at: indexURL, to: destinationIndexURL)

        var destinationMetadataRelativePath: String?
        if let metadataDBPath = trackInfo.metadataDBPath {
            let metadataDBURL = resolveBundlePath(metadataDBPath, bundleURL: bundleURL)
            let relocatedMetadataRelativePath = "alignments/filtered/\(metadataDBURL.lastPathComponent)"
            let relocatedMetadataURL = bundleURL.appendingPathComponent(relocatedMetadataRelativePath)
            try replaceItemIfPresent(at: relocatedMetadataURL)
            try FileManager.default.moveItem(at: metadataDBURL, to: relocatedMetadataURL)

            let metadataDB = try AlignmentMetadataDatabase.openForUpdate(at: relocatedMetadataURL)
            metadataDB.setFileInfo("source_path", value: destinationSourceURL.path)
            metadataDB.setFileInfo("source_path_in_bundle", value: destinationSourceRelativePath)
            metadataDB.setFileInfo("file_name", value: destinationSourceURL.lastPathComponent)
            destinationMetadataRelativePath = relocatedMetadataRelativePath
        }

        let relocatedTrackInfo = AlignmentTrackInfo(
            id: trackInfo.id,
            name: trackInfo.name,
            description: trackInfo.description,
            format: trackInfo.format,
            sourcePath: destinationSourceRelativePath,
            sourceBookmark: trackInfo.sourceBookmark,
            indexPath: destinationIndexRelativePath,
            indexBookmark: trackInfo.indexBookmark,
            metadataDBPath: destinationMetadataRelativePath,
            checksumSHA256: trackInfo.checksumSHA256,
            fileSizeBytes: trackInfo.fileSizeBytes,
            addedDate: trackInfo.addedDate,
            mappedReadCount: trackInfo.mappedReadCount,
            unmappedReadCount: trackInfo.unmappedReadCount,
            sampleNames: trackInfo.sampleNames
        )

        let manifest = try BundleManifest.load(from: bundleURL)
        let updatedManifest = manifest
            .removingAlignmentTrack(id: trackInfo.id)
            .addingAlignmentTrack(relocatedTrackInfo)
        try updatedManifest.save(to: bundleURL)

        return BAMImportService.ImportResult(
            trackInfo: relocatedTrackInfo,
            mappedReads: importResult.mappedReads,
            unmappedReads: importResult.unmappedReads,
            sampleNames: importResult.sampleNames,
            indexWasCreated: importResult.indexWasCreated,
            wasSorted: importResult.wasSorted
        )
    }

    private func resolveBundlePath(_ path: String, bundleURL: URL) -> URL {
        if path.hasPrefix("/") {
            return URL(fileURLWithPath: path)
        }
        return bundleURL.appendingPathComponent(path)
    }

    private func replaceItemIfPresent(at url: URL) throws {
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }

    private func appendDerivationMetadata(
        importResult: BAMImportService.ImportResult,
        bundleURL: URL,
        sourceTrack: AlignmentTrackInfo,
        sourceAlignmentPath: String,
        sourceIndexPath: String,
        filterRequest: AlignmentFilterRequest,
        preprocessingSteps: [AlignmentFilterPreprocessingStep],
        commandHistory: [AlignmentCommandExecutionRecord]
    ) throws {
        guard let metadataDBPath = importResult.trackInfo.metadataDBPath else { return }

        let metadataDBURL = bundleURL.appendingPathComponent(metadataDBPath)
        guard FileManager.default.fileExists(atPath: metadataDBURL.path) else { return }
        let metadataDB = try AlignmentMetadataDatabase.openForUpdate(at: metadataDBURL)

        metadataDB.setFileInfo("derivation_kind", value: "filtered_alignment")
        metadataDB.setFileInfo("derivation_source_track_id", value: sourceTrack.id)
        metadataDB.setFileInfo("derivation_source_track_name", value: sourceTrack.name)
        metadataDB.setFileInfo("derivation_source_manifest_path", value: sourceTrack.sourcePath)
        metadataDB.setFileInfo("derivation_source_alignment_path", value: sourceAlignmentPath)
        metadataDB.setFileInfo("derivation_source_alignment_index_path", value: sourceIndexPath)
        metadataDB.setFileInfo("derivation_duplicate_mode", value: filterRequest.duplicateMode?.rawValue ?? "none")
        metadataDB.setFileInfo(
            "derivation_preprocessing",
            value: preprocessingSteps.map(preprocessingDescription).joined(separator: " -> ")
        )
        metadataDB.setFileInfo(
            "derivation_command_chain",
            value: commandHistory.map(\.commandLine).joined(separator: " | ")
        )

        var parentStep: Int?
        for command in commandHistory {
            parentStep = metadataDB.addProvenanceRecord(
                tool: command.tool,
                subcommand: command.subcommand,
                command: command.commandLine,
                inputFile: command.inputFile,
                outputFile: command.outputFile,
                exitCode: 0,
                parentStep: parentStep
            )
        }
    }

    private func preprocessingDescription(_ step: AlignmentFilterPreprocessingStep) -> String {
        switch step {
        case .samtoolsMarkdup(let removeDuplicates):
            return "samtools markdup(removeDuplicates=\(removeDuplicates))"
        }
    }
}
