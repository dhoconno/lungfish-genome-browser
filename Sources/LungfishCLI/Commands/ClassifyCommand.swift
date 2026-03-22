// ClassifyCommand.swift - CLI command for Kraken2 classification
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import ArgumentParser
import Foundation
import LungfishWorkflow
import LungfishIO
import LungfishCore

/// Run Kraken2 taxonomic classification on FASTQ files.
///
/// This subcommand resolves the database from the metagenomics registry,
/// configures the classification pipeline, and runs Kraken2. Optionally
/// chains Bracken for abundance profiling.
///
/// ## Examples
///
/// ```
/// # Classify with balanced preset
/// lungfish conda classify sample.fastq --db Viral --preset balanced
///
/// # Paired-end classification with profiling
/// lungfish conda classify R1.fastq R2.fastq --db Standard-8 --paired --profile
///
/// # Precise classification with 8 threads
/// lungfish conda classify reads.fastq --db PlusPF --preset precise --threads 8
/// ```
struct ClassifyCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "classify",
        abstract: "Run Kraken2 taxonomic classification on FASTQ files",
        discussion: """
        Classify metagenomic reads using Kraken2 with an installed database.
        Databases are managed via `lungfish conda db` or downloaded from the
        built-in catalog. Results include a kreport file, per-read output,
        and an optional Bracken abundance profile.
        """
    )

    // MARK: - Arguments

    @Argument(help: "Input FASTQ file(s). Provide two files for paired-end.")
    var fastqFiles: [String]

    @Option(name: .customLong("db"), help: "Database name (e.g., 'Viral', 'Standard-8')")
    var databaseName: String

    @Option(name: .customLong("preset"), help: "Sensitivity preset: sensitive, balanced, precise (default: balanced)")
    var preset: ClassificationPresetArgument = .balanced

    @Option(name: [.customLong("output-dir"), .customShort("o")], help: "Output directory (default: current directory)")
    var outputDir: String?

    @Flag(name: .customLong("paired"), help: "Input files are paired-end reads")
    var pairedEnd: Bool = false

    @Flag(name: .customLong("profile"), help: "Run Bracken abundance profiling after classification")
    var profile: Bool = false

    @Option(name: .customLong("confidence"), help: "Override confidence threshold (0.0-1.0)")
    var confidence: Double?

    @Option(name: .customLong("min-hit-groups"), help: "Override minimum hit groups")
    var minHitGroups: Int?

    @Option(name: .customLong("threads"), help: "Number of threads (default: 4)")
    var threads: Int = 4

    @Flag(name: .customLong("memory-mapping"), help: "Use memory-mapped I/O (slower, less RAM)")
    var memoryMapping: Bool = false

    @Flag(name: .customLong("quick"), help: "Use Kraken2 quick mode")
    var quickMode: Bool = false

    @Option(name: .customLong("bracken-read-length"), help: "Read length for Bracken -r flag (default: 150)")
    var brackenReadLength: Int = 150

    @Option(name: .customLong("bracken-level"), help: "Bracken taxonomic level: D,P,C,O,F,G,S (default: S)")
    var brackenLevel: String = "S"

    @Option(name: .customLong("bracken-threshold"), help: "Bracken minimum read threshold (default: 10)")
    var brackenThreshold: Int = 10

    @OptionGroup var globalOptions: GlobalOptions

    // MARK: - Execution

    func run() async throws {
        let formatter = TerminalFormatter(useColors: globalOptions.useColors)

        // Resolve input files.
        let inputURLs = fastqFiles.map { URL(fileURLWithPath: $0) }
        for url in inputURLs {
            guard FileManager.default.fileExists(atPath: url.path) else {
                print(formatter.error("Input file not found: \(url.path)"))
                throw ExitCode.failure
            }
        }

        // Resolve database from registry.
        let registry = MetagenomicsDatabaseRegistry.shared
        guard let dbInfo = try await registry.database(named: databaseName) else {
            print(formatter.error("Database '\(databaseName)' not found in registry"))
            print(formatter.info("Available databases:"))
            let available = try await registry.availableDatabases()
            for db in available where db.isDownloaded {
                print("  \(db.name) [\(db.status.rawValue)]")
            }
            throw ExitCode.failure
        }

        guard let dbPath = dbInfo.path, dbInfo.status == .ready else {
            print(formatter.error("Database '\(databaseName)' is not ready (status: \(dbInfo.status.rawValue))"))
            if !dbInfo.isDownloaded {
                print(formatter.info("Download it first: the database has not been installed"))
            }
            throw ExitCode.failure
        }

        // Resolve output directory.
        let outputDirectory: URL
        if let dir = outputDir {
            outputDirectory = URL(fileURLWithPath: dir)
        } else {
            outputDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
                .appendingPathComponent("classification-\(databaseName.lowercased())")
        }

        // Build config from preset, then apply overrides.
        var config = ClassificationConfig.fromPreset(
            preset.toPreset(),
            inputFiles: inputURLs,
            isPairedEnd: pairedEnd,
            databaseName: databaseName,
            databasePath: dbPath,
            threads: threads,
            memoryMapping: memoryMapping,
            quickMode: quickMode,
            outputDirectory: outputDirectory
        )

        // Apply explicit overrides if provided.
        if let conf = confidence {
            config.confidence = conf
        }
        if let mhg = minHitGroups {
            config.minimumHitGroups = mhg
        }

        // Print configuration.
        print(formatter.header("Kraken2 Classification"))
        print("")
        print(formatter.keyValueTable([
            ("Input files", inputURLs.map(\.lastPathComponent).joined(separator: ", ")),
            ("Paired-end", pairedEnd ? "yes" : "no"),
            ("Database", databaseName),
            ("Preset", preset.rawValue),
            ("Confidence", String(format: "%.2f", config.confidence)),
            ("Min hit groups", String(config.minimumHitGroups)),
            ("Threads", String(config.threads)),
            ("Memory mapping", config.memoryMapping ? "yes" : "no"),
            ("Bracken profiling", profile ? "yes" : "no"),
            ("Output", outputDirectory.path),
        ]))
        print("")

        // Run pipeline.
        let pipeline = ClassificationPipeline.shared

        let result: ClassificationResult
        if profile {
            let rank = TaxonomicRank(code: brackenLevel)
            result = try await pipeline.profile(
                config: config,
                brackenReadLength: brackenReadLength,
                brackenLevel: rank,
                brackenThreshold: brackenThreshold
            ) { fraction, message in
                if !globalOptions.quiet {
                    print("\r\(formatter.info(message))", terminator: "")
                }
            }
        } else {
            result = try await pipeline.classify(config: config) { fraction, message in
                if !globalOptions.quiet {
                    print("\r\(formatter.info(message))", terminator: "")
                }
            }
        }

        // Clear progress line.
        print("")
        print("")

        // Print summary.
        print(formatter.header("Results"))
        print("")
        print(result.summary)
        print("")

        // Print top species.
        let topSpecies = result.tree.nodes(at: .species)
            .sorted { $0.readsClade > $1.readsClade }
            .prefix(10)

        if !topSpecies.isEmpty {
            print(formatter.header("Top Species"))
            print("")
            let rows = topSpecies.map { node -> [String] in
                let pct = String(format: "%.2f%%", node.fractionClade * 100)
                let reads = String(node.readsClade)
                let bracken = node.brackenReads.map { String($0) } ?? "-"
                return [node.name, reads, bracken, pct]
            }
            print(formatter.table(
                headers: ["Species", "Reads", "Bracken", "Fraction"],
                rows: Array(rows)
            ))
            print("")
        }

        // Print output file paths.
        print(formatter.header("Output Files"))
        print("  Report:  \(formatter.path(result.reportURL.path))")
        print("  Output:  \(formatter.path(result.outputURL.path))")
        if let bracken = result.brackenURL {
            print("  Bracken: \(formatter.path(bracken.path))")
        }
        print("")
        print(formatter.success("Classification completed in \(String(format: "%.1f", result.runtime))s"))
    }
}

// MARK: - ClassificationPresetArgument

/// ArgumentParser-compatible wrapper for ``ClassificationConfig/Preset``.
enum ClassificationPresetArgument: String, ExpressibleByArgument, CaseIterable {
    case sensitive
    case balanced
    case precise

    /// Converts to the workflow module's preset type.
    func toPreset() -> ClassificationConfig.Preset {
        switch self {
        case .sensitive: return .sensitive
        case .balanced: return .balanced
        case .precise: return .precise
        }
    }
}
