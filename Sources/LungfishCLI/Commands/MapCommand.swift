// MapCommand.swift - CLI command for minimap2 read mapping
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import ArgumentParser
import Foundation
import LungfishWorkflow
import LungfishCore

/// Map reads to a reference genome with minimap2.
///
/// This subcommand checks that minimap2 is installed via the Alignment
/// plugin pack, configures the mapping pipeline, and runs minimap2
/// followed by samtools sort and index to produce a sorted BAM.
///
/// ## Examples
///
/// ```
/// # Illumina paired-end mapping
/// lungfish map R1.fastq.gz R2.fastq.gz --reference genome.fasta --paired
///
/// # Nanopore long reads
/// lungfish map reads.fastq --reference ref.fa --preset map-ont
///
/// # PacBio HiFi with custom output directory
/// lungfish map ccs.fastq.gz --reference ref.fasta --preset map-hifi \
///     --output-dir results/ --sample-name MySample
///
/// # Illumina with 4 threads and secondary alignments
/// lungfish map R1.fq R2.fq --reference ref.fa --paired --threads 4 --secondary
/// ```
struct MapCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "map",
        abstract: "Map reads to a reference genome with minimap2",
        discussion: """
        Align sequencing reads to a reference genome using minimap2.
        Produces a coordinate-sorted, indexed BAM file. minimap2 must
        be installed via the Alignment plugin pack (Plugin Manager or
        `lungfish conda install alignment`).

        The output is a sorted BAM + BAI pair suitable for visualization
        in Lungfish or import into any BAM-compatible tool.
        """
    )

    // MARK: - Arguments

    @Argument(help: "Input FASTQ file(s). Provide two files for paired-end.")
    var fastqFiles: [String]

    @Option(
        name: .customLong("reference"),
        help: "Reference FASTA file to align against"
    )
    var reference: String

    @Option(
        name: .customLong("preset"),
        help: "Alignment preset: sr, map-ont, map-hifi, map-pb, asm5, asm20, splice, splice:hq (default: sr)"
    )
    var preset: String = "sr"

    @Option(
        name: [.customLong("output-dir"), .customShort("o")],
        help: "Output directory (default: mapping-<id> next to input)"
    )
    var outputDir: String?

    @Option(
        name: .customLong("sample-name"),
        help: "Sample name for BAM read group (default: derived from first input filename)"
    )
    var sampleName: String?

    @Flag(
        name: .customLong("paired"),
        help: "Input files are paired-end reads"
    )
    var pairedEnd: Bool = false

    @Option(
        name: .customLong("threads"),
        help: "Number of threads (default: all available cores)"
    )
    var threads: Int = ProcessInfo.processInfo.processorCount

    @Flag(
        name: .customLong("secondary"),
        help: "Include secondary alignments"
    )
    var secondary: Bool = false

    @Flag(
        name: .customLong("no-supplementary"),
        help: "Exclude supplementary (chimeric) alignments"
    )
    var noSupplementary: Bool = false

    @Option(
        name: .customLong("min-mapq"),
        help: "Minimum mapping quality to retain (default: 0)"
    )
    var minMapQ: Int = 0

    // Advanced scoring overrides
    @Option(name: .customLong("match-score"), help: "Match score (-A)")
    var matchScore: Int?

    @Option(name: .customLong("mismatch-penalty"), help: "Mismatch penalty (-B)")
    var mismatchPenalty: Int?

    @Option(name: .customLong("gap-open"), help: "Gap open penalty (-O), e.g. '4' or '4,24'")
    var gapOpen: String?

    @Option(name: .customLong("gap-ext"), help: "Gap extension penalty (-E), e.g. '2' or '2,1'")
    var gapExt: String?

    @Option(name: .customLong("seed-length"), help: "Minimum seed length (-k)")
    var seedLength: Int?

    @Option(name: .customLong("bandwidth"), help: "Chaining/alignment bandwidth (-r)")
    var bandwidth: Int?

    @OptionGroup var globalOptions: GlobalOptions

    // MARK: - Execution

    func run() async throws {
        let formatter = TerminalFormatter(useColors: globalOptions.useColors)

        // Validate input files exist.
        let inputURLs = fastqFiles.map { URL(fileURLWithPath: $0) }
        for url in inputURLs {
            guard FileManager.default.fileExists(atPath: url.path) else {
                print(formatter.error("Input file not found: \(url.path)"))
                throw ExitCode.failure
            }
        }

        // Validate paired-end consistency.
        if pairedEnd && inputURLs.count != 2 {
            print(formatter.error("Paired-end mode requires exactly 2 input files, got \(inputURLs.count)"))
            throw ExitCode.failure
        }

        // Validate reference exists.
        let referenceURL = URL(fileURLWithPath: reference)
        guard FileManager.default.fileExists(atPath: referenceURL.path) else {
            print(formatter.error("Reference file not found: \(reference)"))
            throw ExitCode.failure
        }

        // Resolve preset.
        guard let minimap2Preset = Minimap2Preset(rawValue: preset) else {
            let valid = Minimap2Preset.allCases.map(\.rawValue).joined(separator: ", ")
            print(formatter.error("Invalid preset '\(preset)'. Valid presets: \(valid)"))
            throw ExitCode.failure
        }

        // Resolve output directory.
        let outputDirectory: URL
        if let dir = outputDir {
            outputDirectory = URL(fileURLWithPath: dir)
        } else {
            let runToken = String(UUID().uuidString.prefix(8))
            outputDirectory = inputURLs.first!.deletingLastPathComponent()
                .appendingPathComponent("mapping-\(runToken)")
        }

        // Derive sample name from first input filename if not provided.
        let effectiveSampleName: String
        if let name = sampleName {
            effectiveSampleName = name
        } else {
            var name = inputURLs.first!.deletingPathExtension().lastPathComponent
            // Strip .gz, .fastq etc.
            if name.lowercased().hasSuffix(".gz") {
                name = URL(fileURLWithPath: name).deletingPathExtension().lastPathComponent
            }
            if name.lowercased().hasSuffix(".fastq") || name.lowercased().hasSuffix(".fq") {
                name = URL(fileURLWithPath: name).deletingPathExtension().lastPathComponent
            }
            // Strip _R1, _1 suffixes for paired-end
            if pairedEnd {
                let suffixes = ["_R1", "_1", "_R1_001", ".R1"]
                for suffix in suffixes where name.hasSuffix(suffix) {
                    name = String(name.dropLast(suffix.count))
                    break
                }
            }
            effectiveSampleName = name
        }

        // Build config.
        let config = Minimap2Config(
            inputFiles: inputURLs,
            referenceURL: referenceURL,
            preset: minimap2Preset,
            threads: threads,
            includeSecondary: secondary,
            includeSupplementary: !noSupplementary,
            minMappingQuality: minMapQ,
            isPairedEnd: pairedEnd,
            outputDirectory: outputDirectory,
            sampleName: effectiveSampleName,
            matchScore: matchScore,
            mismatchPenalty: mismatchPenalty,
            gapOpenPenalty: gapOpen,
            gapExtensionPenalty: gapExt,
            seedLength: seedLength,
            bandwidth: bandwidth
        )

        // Print configuration.
        print(formatter.header("minimap2 Read Mapping"))
        print("")
        print(formatter.keyValueTable([
            ("Input files", inputURLs.map(\.lastPathComponent).joined(separator: ", ")),
            ("Paired-end", pairedEnd ? "yes" : "no"),
            ("Reference", referenceURL.lastPathComponent),
            ("Preset", "\(minimap2Preset.rawValue) (\(minimap2Preset.displayName))"),
            ("Threads", String(threads)),
            ("Secondary", secondary ? "yes" : "no"),
            ("Supplementary", noSupplementary ? "no" : "yes"),
            ("Min MAPQ", String(minMapQ)),
            ("Sample name", effectiveSampleName),
            ("Output", outputDirectory.path),
        ]))
        print("")

        // Run pipeline.
        let pipeline = Minimap2Pipeline()

        let result = try await pipeline.run(config: config) { fraction, message in
            if !globalOptions.quiet {
                print("\r\(formatter.info(message))", terminator: "")
                fflush(stdout)
            }
        }

        // Clear progress line.
        print("")
        print("")

        // Print results.
        let mappingPct = result.totalReads > 0
            ? String(format: "%.2f%%", Double(result.mappedReads) / Double(result.totalReads) * 100)
            : "N/A"

        print(formatter.header("Results"))
        print("")
        print(formatter.keyValueTable([
            ("Total reads", String(result.totalReads)),
            ("Mapped reads", "\(result.mappedReads) (\(mappingPct))"),
            ("Unmapped reads", String(result.unmappedReads)),
            ("Runtime", String(format: "%.1fs", result.wallClockSeconds)),
        ]))
        print("")

        print(formatter.header("Output Files"))
        print("  BAM:   \(formatter.path(result.bamURL.path))")
        print("  Index: \(formatter.path(result.baiURL.path))")
        print("")
        print(formatter.success(
            "Read mapping completed in \(String(format: "%.1f", result.wallClockSeconds))s"
        ))
    }
}

// MARK: - Minimap2Preset + ExpressibleByArgument

extension Minimap2Preset: ExpressibleByArgument {
    /// Allows ArgumentParser to parse preset values from the command line.
    public init?(argument: String) {
        self.init(rawValue: argument)
    }
}
