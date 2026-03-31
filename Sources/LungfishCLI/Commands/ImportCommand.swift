// ImportCommand.swift - CLI commands for importing files into Lungfish projects
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import ArgumentParser
import Foundation
import LungfishCore
import LungfishIO
import LungfishWorkflow

/// Import files into a Lungfish project.
///
/// Provides subcommands for importing different file types (BAM, VCF, FASTA,
/// Kraken2 reports, EsViritu results, TaxTriage results, and NAO-MGS results)
/// into a Lungfish project directory. Each subcommand validates the input,
/// copies or transforms files into the project structure, and prints a summary.
///
/// ## Examples
///
/// ```
/// # Import a BAM file
/// lungfish import bam aligned.sorted.bam -o ./project/
///
/// # Import a VCF file
/// lungfish import vcf variants.vcf.gz -o ./project/
///
/// # Import a reference FASTA
/// lungfish import fasta reference.fasta -o ./project/ --name "SARS-CoV-2"
///
/// # Import Kraken2 results
/// lungfish import kraken2 results.kreport -o ./project/
///
/// # Import EsViritu results
/// lungfish import esviritu results_dir/ -o ./project/
///
/// # Import TaxTriage results
/// lungfish import taxtriage results_dir/ -o ./project/
///
/// # Import NAO-MGS results
/// lungfish import nao-mgs virus_hits_final.tsv.gz -o ./project/
/// ```
struct ImportCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "import",
        abstract: "Import files into a Lungfish project",
        discussion: """
        Import various bioinformatics file types into a Lungfish project
        directory. Each subcommand handles format-specific validation,
        file organization, and summary output.
        """,
        subcommands: [
            BAMSubcommand.self,
            VCFSubcommand.self,
            FASTASubcommand.self,
            Kraken2Subcommand.self,
            EsVirituSubcommand.self,
            TaxTriageSubcommand.self,
            NaoMgsSubcommand.self,
        ]
    )
}

// MARK: - BAM Import

extension ImportCommand {

    /// Import a BAM/CRAM alignment file into a Lungfish project.
    ///
    /// Validates that the alignment file exists, copies it to the output
    /// directory, creates an index if needed, and prints alignment statistics.
    struct BAMSubcommand: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "bam",
            abstract: "Import a BAM or CRAM alignment file"
        )

        @Argument(help: "Path to the BAM or CRAM file")
        var inputFile: String

        @Option(
            name: [.customLong("output-dir"), .customShort("o")],
            help: "Output project directory (default: current directory)"
        )
        var outputDir: String?

        @Option(
            name: .customLong("name"),
            help: "Display name for the alignment track (default: filename)"
        )
        var name: String?

        @OptionGroup var globalOptions: GlobalOptions

        func run() async throws {
            let formatter = TerminalFormatter(useColors: globalOptions.useColors)
            let inputURL = URL(fileURLWithPath: inputFile)

            guard FileManager.default.fileExists(atPath: inputURL.path) else {
                print(formatter.error("Input file not found: \(inputFile)"))
                throw ExitCode.failure
            }

            // Validate format from extension.
            var formatURL = inputURL
            if formatURL.pathExtension.lowercased() == "gz" {
                formatURL = formatURL.deletingPathExtension()
            }
            let ext = formatURL.pathExtension.lowercased()
            guard ["bam", "cram", "sam"].contains(ext) else {
                print(formatter.error("Unsupported alignment format: .\(ext). Expected .bam, .cram, or .sam"))
                throw ExitCode.failure
            }

            let outputDirectory = resolveOutputDirectory(outputDir)

            print(formatter.header("BAM/CRAM Import"))
            print("")
            print(formatter.keyValueTable([
                ("Input", inputURL.lastPathComponent),
                ("Format", ext.uppercased()),
                ("Output", outputDirectory.path),
            ]))
            print("")

            // Create output directory.
            try FileManager.default.createDirectory(
                at: outputDirectory,
                withIntermediateDirectories: true
            )

            // Copy alignment file.
            let destURL = outputDirectory.appendingPathComponent(inputURL.lastPathComponent)
            if !FileManager.default.fileExists(atPath: destURL.path) {
                if !globalOptions.quiet {
                    print(formatter.info("Copying alignment file..."))
                }
                try FileManager.default.copyItem(at: inputURL, to: destURL)
            }

            // Check for companion index file and copy if present.
            let indexCopied = copyCompanionIndex(
                for: inputURL, to: outputDirectory, formatter: formatter
            )

            // Attempt to collect statistics via samtools.
            var totalReads: Int64 = 0
            var mappedReads: Int64 = 0
            var unmappedReads: Int64 = 0
            var refContigs = 0
            var statsCollected = false

            do {
                let runner = NativeToolRunner.shared
                let idxstatsResult = try await runner.run(
                    .samtools,
                    arguments: ["idxstats", destURL.path],
                    timeout: 120
                )
                if idxstatsResult.isSuccess {
                    let lines = idxstatsResult.stdout.split(separator: "\n")
                    for line in lines {
                        let cols = line.split(separator: "\t")
                        guard cols.count >= 4 else { continue }
                        let refName = String(cols[0])
                        let mapped = Int64(cols[2]) ?? 0
                        let unmapped = Int64(cols[3]) ?? 0
                        mappedReads += mapped
                        unmappedReads += unmapped
                        if refName != "*" {
                            refContigs += 1
                        }
                    }
                    totalReads = mappedReads + unmappedReads
                    statsCollected = true
                }
            } catch {
                // samtools not available - skip stats.
                if !globalOptions.quiet {
                    print(formatter.warning("samtools not available; skipping statistics collection"))
                }
            }

            // If no index was copied and samtools is available, try creating one.
            if !indexCopied {
                do {
                    let runner = NativeToolRunner.shared
                    if !globalOptions.quiet {
                        print(formatter.info("Creating index..."))
                    }
                    let indexResult = try await runner.run(
                        .samtools,
                        arguments: ["index", destURL.path],
                        timeout: 3600
                    )
                    if indexResult.isSuccess {
                        if !globalOptions.quiet {
                            print(formatter.success("Index created"))
                        }
                    } else {
                        print(formatter.warning(
                            "Failed to create index. The file may need sorting first."
                        ))
                    }
                } catch {
                    print(formatter.warning("samtools not available; could not create index"))
                }
            }

            print("")
            print(formatter.header("Summary"))
            print("")

            if statsCollected {
                let mappedPct = totalReads > 0
                    ? String(format: "%.2f%%", Double(mappedReads) / Double(totalReads) * 100)
                    : "N/A"
                print(formatter.keyValueTable([
                    ("Total reads", formatNumber(totalReads)),
                    ("Mapped reads", "\(formatNumber(mappedReads)) (\(mappedPct))"),
                    ("Unmapped reads", formatNumber(unmappedReads)),
                    ("Reference contigs", String(refContigs)),
                ]))
            } else {
                print(formatter.keyValueTable([
                    ("File", destURL.lastPathComponent),
                    ("Index", indexCopied ? "found" : "not found"),
                ]))
            }

            print("")
            print(formatter.success("BAM import complete: \(destURL.lastPathComponent)"))
        }

        /// Copies a companion index file (.bai, .csi, .crai) if one exists next to the input.
        private func copyCompanionIndex(
            for inputURL: URL,
            to outputDirectory: URL,
            formatter: TerminalFormatter
        ) -> Bool {
            let fm = FileManager.default
            let basePath = inputURL.path

            // Common index file patterns.
            let candidates = [
                basePath + ".bai",
                basePath + ".csi",
                basePath + ".crai",
                inputURL.deletingPathExtension().path + ".bai",
            ]

            for candidatePath in candidates {
                if fm.fileExists(atPath: candidatePath) {
                    let indexURL = URL(fileURLWithPath: candidatePath)
                    let destIndex = outputDirectory.appendingPathComponent(indexURL.lastPathComponent)
                    if !fm.fileExists(atPath: destIndex.path) {
                        do {
                            try fm.copyItem(at: indexURL, to: destIndex)
                            if !globalOptions.quiet {
                                print(formatter.info("Copied index: \(indexURL.lastPathComponent)"))
                            }
                        } catch {
                            // Non-fatal; we can try creating one later.
                        }
                    }
                    return true
                }
            }
            return false
        }
    }
}

// MARK: - VCF Import

extension ImportCommand {

    /// Import a VCF variant file into a Lungfish project.
    ///
    /// Validates the VCF header, counts variants, and copies the file
    /// (and companion index) to the output directory.
    struct VCFSubcommand: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "vcf",
            abstract: "Import a VCF variant file"
        )

        @Argument(help: "Path to the VCF or VCF.GZ file")
        var inputFile: String

        @Option(
            name: [.customLong("output-dir"), .customShort("o")],
            help: "Output project directory (default: current directory)"
        )
        var outputDir: String?

        @OptionGroup var globalOptions: GlobalOptions

        func run() async throws {
            let formatter = TerminalFormatter(useColors: globalOptions.useColors)
            let inputURL = URL(fileURLWithPath: inputFile)

            guard FileManager.default.fileExists(atPath: inputURL.path) else {
                print(formatter.error("Input file not found: \(inputFile)"))
                throw ExitCode.failure
            }

            // Validate format from extension.
            var formatURL = inputURL
            if formatURL.pathExtension.lowercased() == "gz" {
                formatURL = formatURL.deletingPathExtension()
            }
            let ext = formatURL.pathExtension.lowercased()
            guard ["vcf", "bcf"].contains(ext) else {
                print(formatter.error("Unsupported variant format: .\(ext). Expected .vcf, .vcf.gz, or .bcf"))
                throw ExitCode.failure
            }

            let outputDirectory = resolveOutputDirectory(outputDir)

            print(formatter.header("VCF Import"))
            print("")

            // Parse and summarize the VCF.
            if !globalOptions.quiet {
                print(formatter.info("Reading VCF header and variants..."))
            }

            let reader = VCFReader(validateRecords: false, parseGenotypes: false)
            let summary: VCFSummary
            do {
                summary = try await reader.summarize(from: inputURL)
            } catch {
                print(formatter.error("Failed to parse VCF: \(error.localizedDescription)"))
                throw ExitCode.failure
            }

            // Create output directory and copy file.
            try FileManager.default.createDirectory(
                at: outputDirectory,
                withIntermediateDirectories: true
            )
            let destURL = outputDirectory.appendingPathComponent(inputURL.lastPathComponent)
            if !FileManager.default.fileExists(atPath: destURL.path) {
                try FileManager.default.copyItem(at: inputURL, to: destURL)
            }

            // Copy companion index (.tbi, .csi) if present.
            copyVCFIndex(for: inputURL, to: outputDirectory, formatter: formatter)

            print("")
            print(formatter.header("Summary"))
            print("")

            // Format variant type breakdown.
            let typeBreakdown = summary.variantTypes
                .sorted { $0.value > $1.value }
                .map { "\($0.key): \(formatNumber(Int64($0.value)))" }
                .joined(separator: ", ")

            print(formatter.keyValueTable([
                ("Format", summary.header.fileFormat),
                ("Variants", formatNumber(Int64(summary.variantCount))),
                ("Types", typeBreakdown.isEmpty ? "N/A" : typeBreakdown),
                ("Samples", String(summary.header.sampleNames.count)),
                ("Contigs", String(summary.chromosomes.count)),
            ]))

            if !summary.header.sampleNames.isEmpty {
                let sampleList = summary.header.sampleNames.prefix(10)
                    .joined(separator: ", ")
                let suffix = summary.header.sampleNames.count > 10
                    ? " (+\(summary.header.sampleNames.count - 10) more)" : ""
                print("")
                print("  Samples: \(sampleList)\(suffix)")
            }

            print("")
            print(formatter.success("VCF import complete: \(destURL.lastPathComponent)"))
        }

        /// Copies a companion index file (.tbi, .csi) if one exists next to the input.
        private func copyVCFIndex(
            for inputURL: URL,
            to outputDirectory: URL,
            formatter: TerminalFormatter
        ) {
            let fm = FileManager.default
            let candidates = [
                inputURL.path + ".tbi",
                inputURL.path + ".csi",
            ]

            for candidatePath in candidates {
                if fm.fileExists(atPath: candidatePath) {
                    let indexURL = URL(fileURLWithPath: candidatePath)
                    let destIndex = outputDirectory.appendingPathComponent(indexURL.lastPathComponent)
                    if !fm.fileExists(atPath: destIndex.path) {
                        do {
                            try fm.copyItem(at: indexURL, to: destIndex)
                            if !globalOptions.quiet {
                                print(formatter.info("Copied index: \(indexURL.lastPathComponent)"))
                            }
                        } catch {
                            // Non-fatal.
                        }
                    }
                }
            }
        }
    }
}

// MARK: - FASTA Import

extension ImportCommand {

    /// Import a reference FASTA file into a Lungfish project.
    ///
    /// Creates a `.lungfishref` bundle in the project's "Reference Sequences"
    /// folder containing the FASTA file and a manifest.
    struct FASTASubcommand: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "fasta",
            abstract: "Import a reference FASTA file"
        )

        @Argument(help: "Path to the FASTA file (.fasta, .fa, .fna)")
        var inputFile: String

        @Option(
            name: [.customLong("output-dir"), .customShort("o")],
            help: "Output project directory (default: current directory)"
        )
        var outputDir: String?

        @Option(
            name: .customLong("name"),
            help: "Display name for the reference (default: filename)"
        )
        var name: String?

        @OptionGroup var globalOptions: GlobalOptions

        func run() async throws {
            let formatter = TerminalFormatter(useColors: globalOptions.useColors)
            let inputURL = URL(fileURLWithPath: inputFile)

            guard FileManager.default.fileExists(atPath: inputURL.path) else {
                print(formatter.error("Input file not found: \(inputFile)"))
                throw ExitCode.failure
            }

            // Validate format from extension.
            var formatURL = inputURL
            if formatURL.pathExtension.lowercased() == "gz" {
                formatURL = formatURL.deletingPathExtension()
            }
            let ext = formatURL.pathExtension.lowercased()
            guard ["fasta", "fa", "fna", "faa", "ffn", "frn", "fas"].contains(ext) else {
                print(formatter.error(
                    "Unsupported FASTA format: .\(ext). Expected .fasta, .fa, .fna, or similar"
                ))
                throw ExitCode.failure
            }

            let outputDirectory = resolveOutputDirectory(outputDir)

            print(formatter.header("FASTA Reference Import"))
            print("")

            // Count sequences and total length by scanning the file.
            if !globalOptions.quiet {
                print(formatter.info("Scanning FASTA file..."))
            }

            var sequenceCount = 0
            var totalLength: Int64 = 0
            var sequenceNames: [String] = []

            let fileHandle = try FileHandle(forReadingFrom: inputURL)
            defer { fileHandle.closeFile() }

            // Stream the file to count sequences.
            let data = fileHandle.readDataToEndOfFile()
            if let content = String(data: data, encoding: .utf8) {
                for line in content.split(separator: "\n", omittingEmptySubsequences: false) {
                    if line.hasPrefix(">") {
                        sequenceCount += 1
                        let headerLine = String(line.dropFirst())
                        let seqName = headerLine.split(separator: " ").first
                            .map(String.init) ?? headerLine
                        sequenceNames.append(seqName)
                    } else {
                        totalLength += Int64(line.count)
                    }
                }
            }

            // Import into project's Reference Sequences folder.
            let displayName = name ?? inputURL.deletingPathExtension().lastPathComponent
            let bundleURL = try ReferenceSequenceFolder.importReference(
                from: inputURL,
                into: outputDirectory,
                displayName: displayName
            )

            print("")
            print(formatter.header("Summary"))
            print("")
            print(formatter.keyValueTable([
                ("Name", displayName),
                ("Sequences", String(sequenceCount)),
                ("Total length", formatBases(totalLength)),
                ("Bundle", bundleURL.lastPathComponent),
            ]))

            if !sequenceNames.isEmpty {
                let displayNames = sequenceNames.prefix(10)
                    .joined(separator: ", ")
                let suffix = sequenceNames.count > 10
                    ? " (+\(sequenceNames.count - 10) more)" : ""
                print("")
                print("  Sequences: \(displayNames)\(suffix)")
            }

            print("")
            print(formatter.success(
                "FASTA import complete: \(displayName) (\(sequenceCount) sequences, \(formatBases(totalLength)))"
            ))
        }
    }
}

// MARK: - Kraken2 Import

extension ImportCommand {

    /// Import Kraken2 classification results into a Lungfish project.
    ///
    /// Copies the kreport (and optionally the per-read output file) into a
    /// `classification-kraken2` subdirectory and prints a species summary.
    struct Kraken2Subcommand: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "kraken2",
            abstract: "Import Kraken2 classification results"
        )

        @Argument(help: "Path to the Kraken2 kreport file")
        var kreportFile: String

        @Option(
            name: .customLong("output"),
            help: "Path to the Kraken2 per-read output file"
        )
        var outputFile: String?

        @Option(
            name: [.customLong("output-dir"), .customShort("o")],
            help: "Output project directory (default: current directory)"
        )
        var outputDir: String?

        @OptionGroup var globalOptions: GlobalOptions

        func run() async throws {
            let formatter = TerminalFormatter(useColors: globalOptions.useColors)
            let kreportURL = URL(fileURLWithPath: kreportFile)

            guard FileManager.default.fileExists(atPath: kreportURL.path) else {
                print(formatter.error("Kreport file not found: \(kreportFile)"))
                throw ExitCode.failure
            }

            if let outputPath = outputFile {
                guard FileManager.default.fileExists(atPath: outputPath) else {
                    print(formatter.error("Output file not found: \(outputPath)"))
                    throw ExitCode.failure
                }
            }

            let outputDirectory = resolveOutputDirectory(outputDir)
            let destDir = outputDirectory.appendingPathComponent("classification-kraken2")

            print(formatter.header("Kraken2 Import"))
            print("")

            // Parse kreport for summary.
            let kreportData = try Data(contentsOf: kreportURL)
            guard let kreportContent = String(data: kreportData, encoding: .utf8) else {
                print(formatter.error("Cannot read kreport file as text"))
                throw ExitCode.failure
            }

            let parsed = parseKreport(kreportContent)

            // Create output directory and copy files.
            try FileManager.default.createDirectory(at: destDir, withIntermediateDirectories: true)

            let destKreport = destDir.appendingPathComponent(kreportURL.lastPathComponent)
            if !FileManager.default.fileExists(atPath: destKreport.path) {
                try FileManager.default.copyItem(at: kreportURL, to: destKreport)
            }

            if let outputPath = outputFile {
                let outputURL = URL(fileURLWithPath: outputPath)
                let destOutput = destDir.appendingPathComponent(outputURL.lastPathComponent)
                if !FileManager.default.fileExists(atPath: destOutput.path) {
                    try FileManager.default.copyItem(at: outputURL, to: destOutput)
                }
            }

            print(formatter.keyValueTable([
                ("Kreport", kreportURL.lastPathComponent),
                ("Total reads", formatNumber(Int64(parsed.totalReads))),
                ("Classified", formatNumber(Int64(parsed.classifiedReads))),
                ("Unclassified", formatNumber(Int64(parsed.unclassifiedReads))),
                ("Species", String(parsed.speciesEntries.count)),
            ]))
            print("")

            // Print top species.
            if !parsed.speciesEntries.isEmpty {
                print(formatter.header("Top Species"))
                print("")

                let topSpecies = parsed.speciesEntries
                    .sorted { $0.reads > $1.reads }
                    .prefix(15)

                let rows: [[String]] = topSpecies.map { entry in
                    [
                        entry.name,
                        formatNumber(Int64(entry.reads)),
                        String(format: "%.2f%%", entry.percentage),
                    ]
                }

                print(formatter.table(
                    headers: ["Species", "Reads", "Fraction"],
                    rows: Array(rows)
                ))
                print("")
            }

            print(formatter.success("Kraken2 import complete: \(destDir.lastPathComponent)"))
        }
    }
}

// MARK: - EsViritu Import

extension ImportCommand {

    /// Import EsViritu viral detection results into a Lungfish project.
    ///
    /// Copies the results directory and prints a detection summary.
    struct EsVirituSubcommand: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "esviritu",
            abstract: "Import EsViritu viral detection results"
        )

        @Argument(help: "Path to the EsViritu results directory")
        var inputPath: String

        @Option(
            name: [.customLong("output-dir"), .customShort("o")],
            help: "Output project directory (default: current directory)"
        )
        var outputDir: String?

        @OptionGroup var globalOptions: GlobalOptions

        func run() async throws {
            let formatter = TerminalFormatter(useColors: globalOptions.useColors)
            let inputURL = URL(fileURLWithPath: inputPath)

            guard FileManager.default.fileExists(atPath: inputURL.path) else {
                print(formatter.error("Input path not found: \(inputPath)"))
                throw ExitCode.failure
            }

            let outputDirectory = resolveOutputDirectory(outputDir)
            let destDir = outputDirectory.appendingPathComponent("esviritu-results")

            print(formatter.header("EsViritu Import"))
            print("")

            // Scan for detection output files.
            var isDir: ObjCBool = false
            FileManager.default.fileExists(atPath: inputURL.path, isDirectory: &isDir)

            let resultsFiles: [URL]
            if isDir.boolValue {
                resultsFiles = scanForFiles(in: inputURL, extensions: ["tsv", "csv", "txt", "json"])
            } else {
                resultsFiles = [inputURL]
            }

            // Create output directory and copy files.
            try FileManager.default.createDirectory(at: destDir, withIntermediateDirectories: true)

            for file in resultsFiles {
                let destFile = destDir.appendingPathComponent(file.lastPathComponent)
                if !FileManager.default.fileExists(atPath: destFile.path) {
                    try FileManager.default.copyItem(at: file, to: destFile)
                }
            }

            // Look for the primary detection output to parse.
            let detectionFile = resultsFiles.first { url in
                let name = url.lastPathComponent.lowercased()
                return name.contains("detection") || name.contains("result")
                    || name.contains("virus") || name.hasSuffix(".tsv")
            }

            var detectionCount = 0
            if let detFile = detectionFile,
               let content = try? String(contentsOf: detFile, encoding: .utf8) {
                // Count non-header lines as detections.
                let lines = content.split(separator: "\n")
                detectionCount = max(0, lines.count - 1)
            }

            print(formatter.keyValueTable([
                ("Source", inputURL.lastPathComponent),
                ("Files imported", String(resultsFiles.count)),
                ("Detections", detectionCount > 0 ? String(detectionCount) : "N/A"),
                ("Output", destDir.lastPathComponent),
            ]))
            print("")

            print(formatter.success("EsViritu import complete: \(resultsFiles.count) file(s)"))
        }
    }
}

// MARK: - TaxTriage Import

extension ImportCommand {

    /// Import TaxTriage classification results into a Lungfish project.
    ///
    /// Copies the results directory and prints a triage summary.
    struct TaxTriageSubcommand: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "taxtriage",
            abstract: "Import TaxTriage classification results"
        )

        @Argument(help: "Path to the TaxTriage results directory")
        var inputPath: String

        @Option(
            name: [.customLong("output-dir"), .customShort("o")],
            help: "Output project directory (default: current directory)"
        )
        var outputDir: String?

        @OptionGroup var globalOptions: GlobalOptions

        func run() async throws {
            let formatter = TerminalFormatter(useColors: globalOptions.useColors)
            let inputURL = URL(fileURLWithPath: inputPath)

            guard FileManager.default.fileExists(atPath: inputURL.path) else {
                print(formatter.error("Input path not found: \(inputPath)"))
                throw ExitCode.failure
            }

            let outputDirectory = resolveOutputDirectory(outputDir)
            let destDir = outputDirectory.appendingPathComponent("taxtriage-results")

            print(formatter.header("TaxTriage Import"))
            print("")

            // Scan for report files.
            var isDir: ObjCBool = false
            FileManager.default.fileExists(atPath: inputURL.path, isDirectory: &isDir)

            let resultsFiles: [URL]
            if isDir.boolValue {
                resultsFiles = scanForFiles(in: inputURL, extensions: [
                    "tsv", "csv", "txt", "json", "html", "kreport",
                ])
            } else {
                resultsFiles = [inputURL]
            }

            // Create output directory and copy files.
            try FileManager.default.createDirectory(at: destDir, withIntermediateDirectories: true)

            for file in resultsFiles {
                let destFile = destDir.appendingPathComponent(file.lastPathComponent)
                if !FileManager.default.fileExists(atPath: destFile.path) {
                    try FileManager.default.copyItem(at: file, to: destFile)
                }
            }

            // Look for report files to parse.
            let reportFile = resultsFiles.first { url in
                let name = url.lastPathComponent.lowercased()
                return name.contains("report") || name.contains("triage")
                    || name.contains("summary") || name.hasSuffix(".kreport")
            }

            var lineCount = 0
            if let repFile = reportFile,
               let content = try? String(contentsOf: repFile, encoding: .utf8) {
                let lines = content.split(separator: "\n")
                lineCount = max(0, lines.count - 1)
            }

            print(formatter.keyValueTable([
                ("Source", inputURL.lastPathComponent),
                ("Files imported", String(resultsFiles.count)),
                ("Report entries", lineCount > 0 ? String(lineCount) : "N/A"),
                ("Output", destDir.lastPathComponent),
            ]))
            print("")

            // List imported files.
            if !globalOptions.quiet && !resultsFiles.isEmpty {
                print(formatter.header("Imported Files"))
                for file in resultsFiles.prefix(20) {
                    print("  \(formatter.path(file.lastPathComponent))")
                }
                if resultsFiles.count > 20 {
                    print("  (+\(resultsFiles.count - 20) more)")
                }
                print("")
            }

            print(formatter.success("TaxTriage import complete: \(resultsFiles.count) file(s)"))
        }
    }
}

// MARK: - NAO-MGS Import

extension ImportCommand {

    /// Import NAO-MGS metagenomic surveillance results into a Lungfish project.
    ///
    /// Wraps the existing `NaoMgsCommand.ImportSubcommand` functionality to also
    /// be accessible via `lungfish import nao-mgs`.
    struct NaoMgsSubcommand: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "nao-mgs",
            abstract: "Import NAO-MGS metagenomic surveillance results"
        )

        @Argument(help: "Path to NAO-MGS results directory or virus_hits_final.tsv(.gz)")
        var inputPath: String

        @Option(name: .customLong("sample-name"), help: "Override sample name")
        var sampleName: String?

        @Option(
            name: [.customLong("output-dir"), .customShort("o")],
            help: "Output directory for converted files (default: current directory)"
        )
        var outputDir: String?

        @Flag(name: .customLong("sam"), help: "Convert virus hits to SAM format")
        var convertToSAM: Bool = false

        @OptionGroup var globalOptions: GlobalOptions

        func run() async throws {
            let formatter = TerminalFormatter(useColors: globalOptions.useColors)
            let parser = NaoMgsResultParser()

            let inputURL = URL(fileURLWithPath: inputPath)
            guard FileManager.default.fileExists(atPath: inputURL.path) else {
                print(formatter.error("Input not found: \(inputPath)"))
                throw ExitCode.failure
            }

            var isDir: ObjCBool = false
            FileManager.default.fileExists(atPath: inputURL.path, isDirectory: &isDir)

            let result: NaoMgsResult
            if isDir.boolValue {
                result = try await parser.loadResults(from: inputURL, sampleName: sampleName)
            } else {
                let hits = try await parser.parseVirusHits(at: inputURL)
                let resolvedName = sampleName ?? hits.first?.sample ?? inputURL
                    .deletingPathExtension().deletingPathExtension().lastPathComponent
                let summaries = parser.aggregateByTaxon(hits)
                result = NaoMgsResult(
                    virusHits: hits,
                    taxonSummaries: summaries,
                    totalHitReads: hits.count,
                    sampleName: resolvedName,
                    sourceDirectory: inputURL.deletingLastPathComponent(),
                    virusHitsFile: inputURL
                )
            }

            print(formatter.header("NAO-MGS Import"))
            print("")
            print(formatter.keyValueTable([
                ("Sample", result.sampleName),
                ("Source", result.virusHitsFile.lastPathComponent),
                ("Total hits", String(result.totalHitReads)),
                ("Distinct taxa", String(result.taxonSummaries.count)),
            ]))
            print("")

            // Print top taxa.
            if !result.taxonSummaries.isEmpty {
                printNaoMgsTaxonSummary(
                    result.taxonSummaries.prefix(15),
                    formatter: formatter
                )
            }

            // Resolve output directory.
            let outputDirectory: URL
            if let dir = outputDir {
                outputDirectory = URL(fileURLWithPath: dir)
            } else {
                outputDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            }

            try FileManager.default.createDirectory(
                at: outputDirectory,
                withIntermediateDirectories: true
            )

            // Convert to SAM if requested.
            if convertToSAM {
                let samURL = outputDirectory.appendingPathComponent(
                    "\(result.sampleName)_nao-mgs.sam"
                )
                try parser.convertToSAM(hits: result.virusHits, outputURL: samURL)
                print(formatter.success("SAM file written to \(samURL.path)"))
            }

            // Write summary JSON.
            let jsonURL = outputDirectory.appendingPathComponent(
                "\(result.sampleName)_nao-mgs_summary.json"
            )
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let jsonData = try encoder.encode(result.taxonSummaries)
            try jsonData.write(to: jsonURL, options: .atomic)

            print(formatter.success("Summary written to \(jsonURL.path)"))
            print("")
            print(formatter.success(
                "Imported \(result.totalHitReads) virus hits from \(result.sampleName)"
            ))
        }
    }
}

// MARK: - Kreport Parsing

/// Parsed entry from a Kraken2 kreport file.
private struct KreportEntry {
    let percentage: Double
    let reads: Int
    let name: String
    let rank: String
}

/// Parsed summary from a Kraken2 kreport file.
private struct KreportSummary {
    let totalReads: Int
    let classifiedReads: Int
    let unclassifiedReads: Int
    let speciesEntries: [KreportEntry]
}

/// Parses a Kraken2 kreport file.
///
/// kreport format columns:
/// 1. % of reads at or below this node
/// 2. Number of reads at or below this node
/// 3. Number of reads assigned directly to this node
/// 4. Rank code (U, R, D, P, C, O, F, G, S, etc.)
/// 5. NCBI taxonomy ID
/// 6. Scientific name (indented)
private func parseKreport(_ content: String) -> KreportSummary {
    var totalReads = 0
    var unclassifiedReads = 0
    var classifiedReads = 0
    var speciesEntries: [KreportEntry] = []

    let lines = content.split(separator: "\n")
    for line in lines {
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        let cols = trimmed.split(separator: "\t")
        guard cols.count >= 6 else { continue }

        let percentage = Double(cols[0].trimmingCharacters(in: .whitespaces)) ?? 0
        let cumulativeReads = Int(cols[1].trimmingCharacters(in: .whitespaces)) ?? 0
        let rank = String(cols[3].trimmingCharacters(in: .whitespaces))
        let name = String(cols[5].trimmingCharacters(in: .whitespaces))

        if rank == "U" {
            unclassifiedReads = cumulativeReads
        } else if rank == "R" {
            // Root-level entry gives us total classified.
            totalReads = cumulativeReads + unclassifiedReads
            classifiedReads = cumulativeReads
        }

        if rank == "S" {
            speciesEntries.append(KreportEntry(
                percentage: percentage,
                reads: cumulativeReads,
                name: name,
                rank: rank
            ))
        }
    }

    // If we never saw root, estimate from unclassified percentage.
    if totalReads == 0 && unclassifiedReads > 0 {
        totalReads = unclassifiedReads
        classifiedReads = 0
    }

    return KreportSummary(
        totalReads: totalReads,
        classifiedReads: classifiedReads,
        unclassifiedReads: unclassifiedReads,
        speciesEntries: speciesEntries
    )
}

// MARK: - NAO-MGS Taxon Summary Printer

/// Prints a formatted NAO-MGS taxon summary table.
///
/// Extracted as a free function to avoid `@MainActor`/`@Sendable` issues.
private func printNaoMgsTaxonSummary(
    _ summaries: some Collection<NaoMgsTaxonSummary>,
    formatter: TerminalFormatter
) {
    guard !summaries.isEmpty else { return }

    print(formatter.header("Top Viral Taxa"))
    print("")

    let rows: [[String]] = summaries.map { summary in
        [
            String(summary.taxId),
            String(summary.name.prefix(50)),
            String(summary.hitCount),
            String(format: "%.1f%%", summary.avgIdentity),
            String(format: "%.1f", summary.avgBitScore),
            String(summary.accessions.count),
        ]
    }

    print(formatter.table(
        headers: ["TaxID", "Organism", "Hits", "Avg %ID", "Avg Score", "Refs"],
        rows: rows
    ))
    print("")
}

// MARK: - Shared Helpers

/// Resolves the output directory from an optional path string.
///
/// Returns the provided path as a URL, or defaults to the current working
/// directory if no path was specified.
private func resolveOutputDirectory(_ outputDir: String?) -> URL {
    if let dir = outputDir {
        return URL(fileURLWithPath: dir)
    }
    return URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
}

/// Formats a number with thousands separators.
private func formatNumber(_ value: Int64) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = ","
    return formatter.string(from: NSNumber(value: value)) ?? String(value)
}

/// Formats a base count with appropriate unit suffix (bp, kb, Mb, Gb).
private func formatBases(_ bases: Int64) -> String {
    if bases < 1_000 {
        return "\(bases) bp"
    } else if bases < 1_000_000 {
        return String(format: "%.1f kb", Double(bases) / 1_000)
    } else if bases < 1_000_000_000 {
        return String(format: "%.1f Mb", Double(bases) / 1_000_000)
    } else {
        return String(format: "%.2f Gb", Double(bases) / 1_000_000_000)
    }
}

/// Scans a directory for files matching the given extensions.
private func scanForFiles(in directory: URL, extensions: [String]) -> [URL] {
    let fm = FileManager.default
    guard let contents = try? fm.contentsOfDirectory(
        at: directory,
        includingPropertiesForKeys: [.isRegularFileKey],
        options: [.skipsHiddenFiles]
    ) else { return [] }

    let lowercasedExts = Set(extensions.map { $0.lowercased() })
    return contents.filter { url in
        var ext = url.pathExtension.lowercased()
        // Handle double extensions like .tsv.gz.
        if ext == "gz" {
            ext = url.deletingPathExtension().pathExtension.lowercased()
        }
        return lowercasedExts.contains(ext) || lowercasedExts.contains(url.pathExtension.lowercased())
    }.sorted { $0.lastPathComponent < $1.lastPathComponent }
}
