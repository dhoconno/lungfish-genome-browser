// ClassificationPipeline.swift - Kraken2 classification and Bracken profiling orchestrator
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import LungfishCore
import LungfishIO
import os.log

private let logger = Logger(subsystem: LogSubsystem.workflow, category: "ClassificationPipeline")

// MARK: - ClassificationPipelineError

/// Errors produced during classification pipeline execution.
public enum ClassificationPipelineError: Error, LocalizedError, Sendable {

    /// Kraken2 exited with a non-zero status.
    case kraken2Failed(exitCode: Int32, stderr: String)

    /// Bracken exited with a non-zero status.
    case brackenFailed(exitCode: Int32, stderr: String)

    /// The kraken2 tool is not installed in the conda environment.
    case kraken2NotInstalled

    /// The bracken tool is not installed in the conda environment.
    case brackenNotInstalled

    /// The kreport output file was not produced by kraken2.
    case kreportNotProduced(URL)

    /// Could not determine the kraken2 version.
    case versionDetectionFailed

    /// The pipeline was cancelled.
    case cancelled

    public var errorDescription: String? {
        switch self {
        case .kraken2Failed(let code, let stderr):
            return "kraken2 failed with exit code \(code): \(stderr)"
        case .brackenFailed(let code, let stderr):
            return "bracken failed with exit code \(code): \(stderr)"
        case .kraken2NotInstalled:
            return "kraken2 is not installed. Run: lungfish conda install --pack metagenomics"
        case .brackenNotInstalled:
            return "bracken is not installed. Run: lungfish conda install --pack metagenomics"
        case .kreportNotProduced(let url):
            return "kraken2 did not produce a report file at \(url.path)"
        case .versionDetectionFailed:
            return "Could not determine kraken2 version"
        case .cancelled:
            return "Classification pipeline was cancelled"
        }
    }
}

// MARK: - ClassificationPipeline

/// Actor that orchestrates Kraken2 classification and optional Bracken profiling.
///
/// The pipeline performs these steps:
///
/// 1. **Validate** the configuration (database exists, input files present).
/// 2. **Detect** kraken2 version for provenance recording.
/// 3. **Run kraken2** with the configured arguments.
/// 4. **Parse** the kreport output into a ``TaxonTree``.
/// 5. **(Optional) Run Bracken** to re-estimate abundances.
/// 6. **Record provenance** via ``ProvenanceRecorder``.
///
/// ## Progress
///
/// Progress is reported via a `@Sendable (Double, String) -> Void` callback:
///
/// | Range      | Phase |
/// |-----------|-------|
/// | 0.0 -- 0.10 | Validation and setup |
/// | 0.10 -- 0.30 | Version detection |
/// | 0.30 -- 0.80 | Kraken2 execution |
/// | 0.80 -- 0.90 | Report parsing |
/// | 0.90 -- 0.95 | Bracken execution (if profiling) |
/// | 0.95 -- 1.00 | Provenance recording and cleanup |
///
/// ## Conda Environment
///
/// The pipeline expects kraken2 and bracken to be installed in conda
/// environments named `kraken2` and `bracken` respectively (matching the
/// metagenomics plugin pack layout).
///
/// ## Usage
///
/// ```swift
/// let pipeline = ClassificationPipeline()
/// let config = ClassificationConfig.fromPreset(
///     .balanced,
///     inputFiles: [fastqURL],
///     isPairedEnd: false,
///     databaseName: "Viral",
///     databasePath: viralDBPath,
///     outputDirectory: outputDir
/// )
/// let result = try await pipeline.classify(config: config) { progress, message in
///     print("\(Int(progress * 100))% \(message)")
/// }
/// ```
public actor ClassificationPipeline {

    /// The conda environment name where kraken2 is installed.
    public static let kraken2Environment = "kraken2"

    /// The conda environment name where bracken is installed.
    public static let brackenEnvironment = "bracken"

    /// Shared instance for convenience.
    public static let shared = ClassificationPipeline()

    /// The conda manager used for tool execution.
    private let condaManager: CondaManager

    /// Creates a classification pipeline.
    ///
    /// - Parameter condaManager: The conda manager to use (default: shared).
    public init(condaManager: CondaManager = .shared) {
        self.condaManager = condaManager
    }

    // MARK: - Classification

    /// Runs Kraken2 classification on the configured input files.
    ///
    /// - Parameters:
    ///   - config: The classification configuration.
    ///   - progress: Optional progress callback.
    /// - Returns: A ``ClassificationResult`` with the parsed taxonomy tree.
    /// - Throws: ``ClassificationConfigError`` for invalid config,
    ///   ``ClassificationPipelineError`` for execution failures.
    public func classify(
        config: ClassificationConfig,
        progress: (@Sendable (Double, String) -> Void)? = nil
    ) async throws -> ClassificationResult {
        try await runPipeline(
            config: config,
            runBracken: false,
            brackenReadLength: 150,
            brackenLevel: .species,
            brackenThreshold: 10,
            progress: progress
        )
    }

    /// Runs Kraken2 classification followed by Bracken abundance profiling.
    ///
    /// Bracken re-estimates abundance at the specified taxonomic level by
    /// redistributing reads from higher levels. The result tree will have
    /// ``TaxonNode/brackenReads`` and ``TaxonNode/brackenFraction`` populated
    /// on matched nodes.
    ///
    /// - Parameters:
    ///   - config: The classification configuration.
    ///   - brackenReadLength: Read length for Bracken's `-r` flag (default: 150).
    ///   - brackenLevel: Taxonomic level for abundance estimation (default: species).
    ///   - brackenThreshold: Minimum read count threshold for Bracken (default: 10).
    ///   - progress: Optional progress callback.
    /// - Returns: A ``ClassificationResult`` with Bracken-augmented tree.
    /// - Throws: ``ClassificationConfigError`` or ``ClassificationPipelineError``.
    public func profile(
        config: ClassificationConfig,
        brackenReadLength: Int = 150,
        brackenLevel: TaxonomicRank = .species,
        brackenThreshold: Int = 10,
        progress: (@Sendable (Double, String) -> Void)? = nil
    ) async throws -> ClassificationResult {
        try await runPipeline(
            config: config,
            runBracken: true,
            brackenReadLength: brackenReadLength,
            brackenLevel: brackenLevel,
            brackenThreshold: brackenThreshold,
            progress: progress
        )
    }

    // MARK: - Private Pipeline

    /// Core pipeline implementation shared by `classify` and `profile`.
    private func runPipeline(
        config: ClassificationConfig,
        runBracken: Bool,
        brackenReadLength: Int,
        brackenLevel: TaxonomicRank,
        brackenThreshold: Int,
        progress: (@Sendable (Double, String) -> Void)?
    ) async throws -> ClassificationResult {
        let startTime = Date()

        // Phase 1: Validation (0.0 -- 0.10)
        progress?(0.0, "Validating configuration...")
        try config.validate()

        // Create output directory if needed.
        let fm = FileManager.default
        if !fm.fileExists(atPath: config.outputDirectory.path) {
            do {
                try fm.createDirectory(
                    at: config.outputDirectory,
                    withIntermediateDirectories: true
                )
            } catch {
                throw ClassificationConfigError.outputDirectoryCreationFailed(
                    config.outputDirectory, error
                )
            }
        }

        progress?(0.10, "Detecting kraken2 version...")

        // Phase 2: Version detection (0.10 -- 0.30)
        let toolVersion = await detectKraken2Version()
        logger.info("Detected kraken2 version: \(toolVersion, privacy: .public)")
        progress?(0.30, "Running kraken2...")

        // Begin provenance recording.
        let provenanceRecorder = ProvenanceRecorder.shared
        let runID = await provenanceRecorder.beginRun(
            name: runBracken ? "Metagenomics Profiling" : "Metagenomics Classification",
            parameters: [
                "database": .string(config.databaseName),
                "confidence": .number(config.confidence),
                "minimumHitGroups": .integer(config.minimumHitGroups),
                "threads": .integer(config.threads),
                "pairedEnd": .boolean(config.isPairedEnd),
                "memoryMapping": .boolean(config.memoryMapping),
            ]
        )

        // Phase 3: Run kraken2 (0.30 -- 0.80)
        let kraken2Args = config.kraken2Arguments()
        let kraken2Command = ["kraken2"] + kraken2Args

        logger.info("Running: kraken2 \(kraken2Args.joined(separator: " "), privacy: .public)")

        let kraken2Start = Date()
        let kraken2Result: (stdout: String, stderr: String, exitCode: Int32)
        do {
            kraken2Result = try await condaManager.runTool(
                name: "kraken2",
                arguments: kraken2Args,
                environment: Self.kraken2Environment,
                timeout: 7200 // 2 hour timeout for large datasets
            )
        } catch let error as CondaError {
            await provenanceRecorder.completeRun(runID, status: .failed)
            if case .toolNotFound = error {
                throw ClassificationPipelineError.kraken2NotInstalled
            }
            throw error
        }

        let kraken2WallTime = Date().timeIntervalSince(kraken2Start)

        // Record kraken2 provenance step.
        let inputRecords = config.inputFiles.map { url in
            FileRecord(path: url.path, format: .fastq, role: .input)
        }
        let kraken2Outputs = [
            FileRecord(path: config.reportURL.path, format: .text, role: .report),
            FileRecord(path: config.outputURL.path, format: .text, role: .output),
        ]
        let kraken2StepID = await provenanceRecorder.recordStep(
            runID: runID,
            toolName: "kraken2",
            toolVersion: toolVersion,
            command: kraken2Command,
            inputs: inputRecords,
            outputs: kraken2Outputs,
            exitCode: kraken2Result.exitCode,
            wallTime: kraken2WallTime,
            stderr: kraken2Result.stderr
        )

        if kraken2Result.exitCode != 0 {
            await provenanceRecorder.completeRun(runID, status: .failed)
            throw ClassificationPipelineError.kraken2Failed(
                exitCode: kraken2Result.exitCode,
                stderr: kraken2Result.stderr
            )
        }

        progress?(0.80, "Parsing classification report...")

        // Phase 4: Parse kreport (0.80 -- 0.90)
        guard fm.fileExists(atPath: config.reportURL.path) else {
            await provenanceRecorder.completeRun(runID, status: .failed)
            throw ClassificationPipelineError.kreportNotProduced(config.reportURL)
        }

        var tree = try KreportParser.parse(url: config.reportURL)

        let totalReads = tree.totalReads
        let speciesCount = tree.speciesCount
        logger.info("Parsed kreport: \(totalReads, privacy: .public) total reads, \(speciesCount, privacy: .public) species")

        progress?(0.90, runBracken ? "Running Bracken profiling..." : "Recording provenance...")

        // Phase 5: Optional Bracken (0.90 -- 0.95)
        var brackenOutputURL: URL?
        if runBracken {
            let levelCode = brackenLevelCode(for: brackenLevel)
            let brackenArgs = [
                "-d", config.databasePath.path,
                "-i", config.reportURL.path,
                "-o", config.brackenURL.path,
                "-r", String(brackenReadLength),
                "-l", levelCode,
                "-t", String(brackenThreshold),
            ]
            let brackenCommand = ["bracken"] + brackenArgs

            logger.info("Running: bracken \(brackenArgs.joined(separator: " "), privacy: .public)")

            let brackenStart = Date()
            let brackenResult: (stdout: String, stderr: String, exitCode: Int32)
            do {
                brackenResult = try await condaManager.runTool(
                    name: "bracken",
                    arguments: brackenArgs,
                    environment: Self.brackenEnvironment,
                    timeout: 3600
                )
            } catch let error as CondaError {
                await provenanceRecorder.completeRun(runID, status: .failed)
                if case .toolNotFound = error {
                    throw ClassificationPipelineError.brackenNotInstalled
                }
                throw error
            }

            let brackenWallTime = Date().timeIntervalSince(brackenStart)

            // Record bracken provenance step with dependency on kraken2.
            let brackenInputs = [
                FileRecord(path: config.reportURL.path, format: .text, role: .input),
            ]
            let brackenOutputRecords = [
                FileRecord(path: config.brackenURL.path, format: .text, role: .output),
            ]
            let dependsOn: [UUID] = kraken2StepID.map { [$0] } ?? []
            await provenanceRecorder.recordStep(
                runID: runID,
                toolName: "bracken",
                toolVersion: toolVersion, // bracken version typically matches the install
                command: brackenCommand,
                inputs: brackenInputs,
                outputs: brackenOutputRecords,
                exitCode: brackenResult.exitCode,
                wallTime: brackenWallTime,
                stderr: brackenResult.stderr,
                dependsOn: dependsOn
            )

            if brackenResult.exitCode != 0 {
                // Bracken failure is non-fatal -- log warning but continue with kraken2-only results.
                let exitCode = brackenResult.exitCode
                let stderrText = brackenResult.stderr
                logger.warning("Bracken failed (exit \(exitCode, privacy: .public)): \(stderrText, privacy: .public)")
            } else if fm.fileExists(atPath: config.brackenURL.path) {
                // Merge bracken results into the tree.
                try BrackenParser.mergeBracken(url: config.brackenURL, into: &tree)
                brackenOutputURL = config.brackenURL
                logger.info("Bracken profiling merged successfully")
            }
        }

        progress?(0.95, "Saving provenance...")

        // Phase 6: Complete provenance (0.95 -- 1.0)
        await provenanceRecorder.completeRun(runID, status: .completed)

        do {
            try await provenanceRecorder.save(runID: runID, to: config.outputDirectory)
        } catch {
            // Provenance save failure is non-fatal.
            logger.warning("Failed to save provenance: \(error.localizedDescription, privacy: .public)")
        }

        let totalRuntime = Date().timeIntervalSince(startTime)

        let result = ClassificationResult(
            config: config,
            tree: tree,
            reportURL: config.reportURL,
            outputURL: config.outputURL,
            brackenURL: brackenOutputURL,
            runtime: totalRuntime,
            toolVersion: toolVersion,
            provenanceId: runID
        )

        progress?(1.0, "Classification complete")

        let runtimeStr = String(format: "%.1f", totalRuntime)
        logger.info("Pipeline complete: \(totalReads, privacy: .public) reads, \(speciesCount, privacy: .public) species, \(runtimeStr, privacy: .public)s")

        return result
    }

    // MARK: - Helpers

    /// Detects the kraken2 version by running `kraken2 --version`.
    ///
    /// - Returns: The version string, or "unknown" if detection fails.
    private func detectKraken2Version() async -> String {
        do {
            let result = try await condaManager.runTool(
                name: "kraken2",
                arguments: ["--version"],
                environment: Self.kraken2Environment,
                timeout: 30
            )
            // kraken2 --version outputs something like "Kraken version 2.1.3"
            let versionLine = result.stdout.trimmingCharacters(in: .whitespacesAndNewlines)
            if let range = versionLine.range(of: #"\d+\.\d+(\.\d+)?"#, options: .regularExpression) {
                return String(versionLine[range])
            }
            // Fall back to full output if regex fails.
            return versionLine.isEmpty ? "unknown" : versionLine
        } catch {
            logger.debug("kraken2 --version failed: \(error.localizedDescription, privacy: .public)")
            return "unknown"
        }
    }

    /// Maps a ``TaxonomicRank`` to the Bracken `-l` flag letter.
    ///
    /// - Parameter rank: The taxonomic rank.
    /// - Returns: A single-letter code string.
    private func brackenLevelCode(for rank: TaxonomicRank) -> String {
        switch rank {
        case .domain: return "D"
        case .phylum: return "P"
        case .class: return "C"
        case .order: return "O"
        case .family: return "F"
        case .genus: return "G"
        case .species: return "S"
        default: return "S" // Default to species
        }
    }
}
