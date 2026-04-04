// ImportFastqCommand.swift - CLI subcommand for batch FASTQ import
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import ArgumentParser
import Foundation
import LungfishCore
import LungfishIO
import LungfishWorkflow

// MARK: - FASTQ Import Subcommand

extension ImportCommand {

    /// Import a directory of FASTQ files (or explicit file paths) into a Lungfish project.
    ///
    /// Detects R1/R2 pairs automatically, optionally applies a processing recipe,
    /// and streams structured JSON log events to stdout during import.
    ///
    /// ## Examples
    ///
    /// ```
    /// # Import all .fastq.gz files from a directory
    /// lungfish import fastq /data/sequencing_run/ --project ./MyProject.lungfish
    ///
    /// # Dry-run to preview detected pairs
    /// lungfish import fastq /data/sequencing_run/ --project ./MyProject.lungfish --dry-run
    ///
    /// # Apply vsp2 recipe with 8 threads
    /// lungfish import fastq /data/run/ --project ./MyProject.lungfish --recipe vsp2 --threads 8
    /// ```
    struct FastqSubcommand: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "fastq",
            abstract: "Batch-import FASTQ files into a Lungfish project"
        )

        @Argument(help: "Directory containing .fastq.gz files, or explicit file paths")
        var input: String

        @Option(
            name: [.customLong("project"), .customShort("p")],
            help: "Path to .lungfish project directory"
        )
        var project: String

        @Option(
            name: .customLong("recipe"),
            help: "Processing recipe: vsp2, wgs, amplicon, hifi, none (default: none)"
        )
        var recipe: String = "none"

        @Option(
            name: .customLong("quality-binning"),
            help: "Quality binning: illumina4, eightLevel, none (default: illumina4)"
        )
        var qualityBinning: String = "illumina4"

        @Option(
            name: .customLong("log-dir"),
            help: "Directory for per-sample log files"
        )
        var logDir: String?

        @Flag(
            name: .customLong("dry-run"),
            help: "List detected pairs without importing"
        )
        var dryRun: Bool = false

        @OptionGroup var globalOptions: GlobalOptions

        /// Thread count sourced from the shared `--threads` / `-t` global option.
        var threads: Int? { globalOptions.threads }

        func run() async throws {
            let formatter = TerminalFormatter(useColors: globalOptions.useColors)
            let inputURL = URL(fileURLWithPath: input)

            // MARK: Detect pairs

            let pairs: [SamplePair]
            let fm = FileManager.default
            var isDirectory: ObjCBool = false
            let exists = fm.fileExists(atPath: inputURL.path, isDirectory: &isDirectory)

            if exists && isDirectory.boolValue {
                do {
                    pairs = try FASTQBatchImporter.detectPairsFromDirectory(inputURL)
                } catch let batchError as BatchImportError {
                    print(formatter.error(batchError.errorDescription ?? batchError.localizedDescription))
                    throw ExitCode.failure
                }
            } else {
                // Treat input as a single explicit file (single-end or R1)
                guard exists else {
                    print(formatter.error("Input not found: \(input)"))
                    throw ExitCode.failure
                }
                pairs = FASTQBatchImporter.detectPairs(from: [inputURL])
            }

            // MARK: Print detected pairs

            print(formatter.header("FASTQ Import"))
            print("")
            print(formatter.info("Detected \(pairs.count) sample(s):"))
            for (i, pair) in pairs.enumerated() {
                let index = String(format: "%3d", i + 1)
                if let r2 = pair.r2 {
                    print("  \(index). \(pair.sampleName)  [paired]")
                    print("        R1: \(pair.r1.lastPathComponent)")
                    print("        R2: \(r2.lastPathComponent)")
                } else {
                    print("  \(index). \(pair.sampleName)  [single-end]")
                    print("        R1: \(pair.r1.lastPathComponent)")
                }
            }
            print("")

            // MARK: Dry-run exit

            if dryRun {
                print(formatter.info("Dry-run mode — no files were imported."))
                return
            }

            // MARK: Resolve recipe

            let resolvedRecipe: ProcessingRecipe?
            if recipe.lowercased() == "none" {
                resolvedRecipe = nil
            } else {
                do {
                    resolvedRecipe = try FASTQBatchImporter.resolveRecipe(named: recipe)
                } catch let batchError as BatchImportError {
                    print(formatter.error(batchError.errorDescription ?? batchError.localizedDescription))
                    throw ExitCode.failure
                }
            }

            // MARK: Resolve quality binning

            let binningScheme: QualityBinningScheme
            switch qualityBinning.lowercased() {
            case "illumina4":
                binningScheme = .illumina4
            case "eightlevel", "eight_level", "eight-level":
                binningScheme = .eightLevel
            case "none":
                binningScheme = .none
            default:
                print(formatter.error("Unknown quality-binning value '\(qualityBinning)'. Valid: illumina4, eightLevel, none"))
                throw ExitCode.failure
            }

            // MARK: Build config

            let projectURL = URL(fileURLWithPath: project)
            let logDirURL = logDir.map { URL(fileURLWithPath: $0) }
            let threadCount = globalOptions.threads ?? ProcessInfo.processInfo.activeProcessorCount

            let config = FASTQBatchImporter.ImportConfig(
                projectDirectory: projectURL,
                recipe: resolvedRecipe,
                qualityBinning: binningScheme,
                threads: threadCount,
                logDirectory: logDirURL
            )

            // MARK: Run import

            if !globalOptions.quiet {
                print(formatter.info("Starting import with \(threadCount) thread(s)…"))
                print("")
            }

            let result = await FASTQBatchImporter.runBatchImport(
                pairs: pairs,
                config: config,
                log: { event in
                    let json = FASTQBatchImporter.encodeLogEvent(event)
                    print(json)
                }
            )

            // MARK: Print summary

            print("")
            print(formatter.header("Import Summary"))
            print("")
            print(formatter.keyValueTable([
                ("Completed", "\(result.completed)"),
                ("Skipped",   "\(result.skipped)"),
                ("Failed",    "\(result.failed)"),
                ("Duration",  String(format: "%.1fs", result.totalDurationSeconds)),
            ]))

            if !result.errors.isEmpty {
                print("")
                print(formatter.warning("Failed samples:"))
                for (sample, error) in result.errors {
                    print(formatter.error("  \(sample): \(error)"))
                }
                throw ExitCode.failure
            }
        }
    }
}
