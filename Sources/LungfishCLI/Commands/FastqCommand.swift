// FastqCommand.swift - FASTQ processing CLI commands
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import ArgumentParser
import Foundation
import LungfishIO
import LungfishWorkflow

/// FASTQ processing operations
struct FastqCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "fastq",
        abstract: "FASTQ read processing and quality control",
        discussion: """
            Process FASTQ files using bundled bioinformatics tools (seqkit, fastp,
            bbtools). All tools are embedded — no external installations required.

            Operations include subsetting, quality/adapter trimming, contaminant
            filtering, error correction, primer removal, and paired-end utilities.

            Examples:
              lungfish fastq subsample --proportion 0.1 reads.fastq -o subset.fastq
              lungfish fastq quality-trim --threshold 20 reads.fastq -o trimmed.fastq
              lungfish fastq contaminant-filter --mode phix reads.fastq -o clean.fastq
              lungfish fastq error-correct reads.fastq -o corrected.fastq
            """,
        subcommands: [
            FastqSubsampleSubcommand.self,
            FastqLengthFilterSubcommand.self,
            FastqQualityTrimSubcommand.self,
            FastqAdapterTrimSubcommand.self,
            FastqFixedTrimSubcommand.self,
            FastqContaminantFilterSubcommand.self,
            FastqPrimerRemovalSubcommand.self,
            FastqErrorCorrectSubcommand.self,
            FastqMergeSubcommand.self,
            FastqRepairSubcommand.self,
            FastqDeinterleaveSubcommand.self,
            FastqInterleaveSubcommand.self,
            FastqDeduplicateSubcommand.self,
        ]
    )
}

// MARK: - Helpers

/// Builds the environment variables needed for BBTools shell scripts.
private func bbToolsEnvironment(runner: NativeToolRunner) async -> [String: String] {
    var env: [String: String] = [:]
    if let toolsDir = await runner.getToolsDirectory() {
        let existingPath = ProcessInfo.processInfo.environment["PATH"] ?? "/usr/bin:/bin:/usr/sbin:/sbin"
        let jreBinDir = toolsDir.appendingPathComponent("jre/bin")
        env["PATH"] = "\(toolsDir.path):\(jreBinDir.path):\(existingPath)"
        let javaURL = jreBinDir.appendingPathComponent("java")
        let javaHome = toolsDir.appendingPathComponent("jre")
        if FileManager.default.fileExists(atPath: javaURL.path) {
            env["JAVA_HOME"] = javaHome.path
            env["BBMAP_JAVA"] = javaURL.path
        }
    }
    return env
}

private func validateInput(_ path: String) throws -> URL {
    guard FileManager.default.fileExists(atPath: path) else {
        throw CLIError.inputFileNotFound(path: path)
    }
    return URL(fileURLWithPath: path)
}

// MARK: - Subsample

struct FastqSubsampleSubcommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "subsample",
        abstract: "Subsample reads by proportion or count"
    )

    @Argument(help: "Input FASTQ file")
    var input: String

    @Option(name: .customLong("proportion"), help: "Fraction of reads to keep (0-1)")
    var proportion: Double?

    @Option(name: .customLong("count"), help: "Number of reads to keep")
    var count: Int?

    @OptionGroup var output: OutputOptions

    func run() async throws {
        let inputURL = try validateInput(input)
        try output.validateOutput()
        let runner = NativeToolRunner.shared

        if proportion != nil && count != nil {
            throw ValidationError("Specify --proportion or --count, not both")
        }
        var args = ["sample"]
        if let proportion {
            guard proportion > 0, proportion <= 1 else {
                throw ValidationError("Proportion must be in (0, 1]")
            }
            args += ["-p", String(proportion)]
        } else if let count {
            guard count > 0 else {
                throw ValidationError("Count must be > 0")
            }
            args += ["-n", String(count)]
        } else {
            throw ValidationError("Specify --proportion or --count")
        }
        args += [inputURL.path, "-o", output.output]

        let result = try await runner.run(.seqkit, arguments: args)
        guard result.isSuccess else {
            throw CLIError.conversionFailed(reason: "seqkit sample failed: \(result.stderr)")
        }
        FileHandle.standardError.write(Data("Subsampled reads written to \(output.output)\n".utf8))
    }
}

// MARK: - Length Filter

struct FastqLengthFilterSubcommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "length-filter",
        abstract: "Filter reads by length"
    )

    @Argument(help: "Input FASTQ file")
    var input: String

    @Option(name: .customLong("min"), help: "Minimum read length")
    var minLength: Int?

    @Option(name: .customLong("max"), help: "Maximum read length")
    var maxLength: Int?

    @OptionGroup var output: OutputOptions

    func run() async throws {
        let inputURL = try validateInput(input)
        try output.validateOutput()
        guard minLength != nil || maxLength != nil else {
            throw ValidationError("Specify --min, --max, or both")
        }
        if let minLength, minLength < 0 { throw ValidationError("--min must be >= 0") }
        if let maxLength, maxLength < 0 { throw ValidationError("--max must be >= 0") }
        if let minLength, let maxLength, minLength > maxLength {
            throw ValidationError("--min (\(minLength)) must be <= --max (\(maxLength))")
        }
        let runner = NativeToolRunner.shared

        var args = ["seq"]
        if let minLength { args += ["-m", String(minLength)] }
        if let maxLength { args += ["-M", String(maxLength)] }
        args += [inputURL.path, "-o", output.output]

        let result = try await runner.run(.seqkit, arguments: args)
        guard result.isSuccess else {
            throw CLIError.conversionFailed(reason: "seqkit seq failed: \(result.stderr)")
        }
        FileHandle.standardError.write(Data("Filtered reads written to \(output.output)\n".utf8))
    }
}

// MARK: - Quality Trim

struct FastqQualityTrimSubcommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "quality-trim",
        abstract: "Trim low-quality bases using fastp"
    )

    @Argument(help: "Input FASTQ file")
    var input: String

    @Option(name: .customLong("threshold"), help: "Quality threshold (default: 20)")
    var threshold: Int = 20

    @Option(name: .customLong("window"), help: "Sliding window size (default: 4)")
    var windowSize: Int = 4

    @Option(name: .customLong("mode"), help: "Trim mode: cut-right, cut-front, cut-tail, cut-both (default: cut-right)")
    var mode: String = "cut-right"

    @OptionGroup var output: OutputOptions

    func run() async throws {
        let inputURL = try validateInput(input)
        try output.validateOutput()
        let runner = NativeToolRunner.shared

        var args = [
            "-i", inputURL.path,
            "-o", output.output,
            "-W", String(windowSize),
            "-M", String(threshold),
            "--disable_adapter_trimming",
            "--disable_quality_filtering",
            "--disable_length_filtering",
            "--json", "/dev/null",
            "--html", "/dev/null",
        ]

        switch mode {
        case "cut-right": args.append("--cut_right")
        case "cut-front": args.append("--cut_front")
        case "cut-tail": args.append("--cut_tail")
        case "cut-both":
            args.append("--cut_front")
            args.append("--cut_right")
        default:
            throw ValidationError("Invalid trim mode: \(mode). Use: cut-right, cut-front, cut-tail, cut-both")
        }

        let result = try await runner.run(.fastp, arguments: args)
        guard result.isSuccess else {
            throw CLIError.conversionFailed(reason: "fastp quality trim failed: \(result.stderr)")
        }
        FileHandle.standardError.write(Data("Quality-trimmed reads written to \(output.output)\n".utf8))
    }
}

// MARK: - Adapter Trim

struct FastqAdapterTrimSubcommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "adapter-trim",
        abstract: "Remove adapter sequences using fastp"
    )

    @Argument(help: "Input FASTQ file")
    var input: String

    @Option(name: .customLong("adapter"), help: "Adapter sequence (omit for auto-detect)")
    var adapterSequence: String?

    @OptionGroup var output: OutputOptions

    func run() async throws {
        let inputURL = try validateInput(input)
        try output.validateOutput()
        let runner = NativeToolRunner.shared

        var args = [
            "-i", inputURL.path,
            "-o", output.output,
            "--disable_quality_filtering",
            "--disable_length_filtering",
            "--json", "/dev/null",
            "--html", "/dev/null",
        ]

        if let adapterSequence {
            args += ["--adapter_sequence", adapterSequence]
        }

        let result = try await runner.run(.fastp, arguments: args)
        guard result.isSuccess else {
            throw CLIError.conversionFailed(reason: "fastp adapter trim failed: \(result.stderr)")
        }
        FileHandle.standardError.write(Data("Adapter-trimmed reads written to \(output.output)\n".utf8))
    }
}

// MARK: - Fixed Trim

struct FastqFixedTrimSubcommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "fixed-trim",
        abstract: "Trim fixed number of bases from read ends"
    )

    @Argument(help: "Input FASTQ file")
    var input: String

    @Option(name: .customLong("front"), help: "Bases to trim from 5' end (default: 0)")
    var front: Int = 0

    @Option(name: .customLong("tail"), help: "Bases to trim from 3' end (default: 0)")
    var tail: Int = 0

    @OptionGroup var output: OutputOptions

    func run() async throws {
        let inputURL = try validateInput(input)
        try output.validateOutput()
        guard front >= 0 else { throw ValidationError("--front must be >= 0") }
        guard tail >= 0 else { throw ValidationError("--tail must be >= 0") }
        guard front > 0 || tail > 0 else {
            throw ValidationError("At least one of --front or --tail must be > 0")
        }
        let runner = NativeToolRunner.shared

        var args = [
            "-i", inputURL.path,
            "-o", output.output,
            "--disable_adapter_trimming",
            "--disable_quality_filtering",
            "--disable_length_filtering",
            "--json", "/dev/null",
            "--html", "/dev/null",
        ]
        if front > 0 { args += ["--trim_front1", String(front)] }
        if tail > 0 { args += ["--trim_tail1", String(tail)] }

        let result = try await runner.run(.fastp, arguments: args)
        guard result.isSuccess else {
            throw CLIError.conversionFailed(reason: "fastp fixed trim failed: \(result.stderr)")
        }
        FileHandle.standardError.write(Data("Fixed-trimmed reads written to \(output.output)\n".utf8))
    }
}

// MARK: - Contaminant Filter

struct FastqContaminantFilterSubcommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "contaminant-filter",
        abstract: "Remove contaminant reads using bbduk"
    )

    @Argument(help: "Input FASTQ file")
    var input: String

    @Option(name: .customLong("mode"), help: "Filter mode: phix, custom (default: phix)")
    var mode: String = "phix"

    @Option(name: .customLong("ref"), help: "Reference FASTA for custom mode")
    var reference: String?

    @Option(name: .customLong("kmer"), help: "K-mer size (default: 31)")
    var kmerSize: Int = 31

    @Option(name: .customLong("hdist"), help: "Hamming distance tolerance (default: 1)")
    var hammingDistance: Int = 1

    @OptionGroup var output: OutputOptions

    func run() async throws {
        let inputURL = try validateInput(input)
        try output.validateOutput()
        guard kmerSize > 0 else { throw ValidationError("--kmer must be > 0") }
        guard hammingDistance >= 0 else { throw ValidationError("--hdist must be >= 0") }
        let runner = NativeToolRunner.shared

        var args = [
            "in=\(inputURL.path)",
            "out=\(output.output)",
            "k=\(kmerSize)",
            "hdist=\(hammingDistance)",
        ]

        switch mode {
        case "phix":
            args.append("ref=phix174_ill.ref.fa.gz")
        case "custom":
            guard let reference else {
                throw ValidationError("Custom mode requires --ref")
            }
            guard FileManager.default.fileExists(atPath: reference) else {
                throw CLIError.inputFileNotFound(path: reference)
            }
            args.append("ref=\(reference)")
        default:
            throw ValidationError("Invalid mode: \(mode). Use: phix, custom")
        }

        let env = await bbToolsEnvironment(runner: runner)
        let result = try await runner.run(.bbduk, arguments: args, environment: env, timeout: 1800)
        guard result.isSuccess else {
            throw CLIError.conversionFailed(reason: "bbduk contaminant filter failed: \(result.stderr)")
        }
        FileHandle.standardError.write(Data("Filtered reads written to \(output.output)\n".utf8))
    }
}

// MARK: - Primer Removal

struct FastqPrimerRemovalSubcommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "primer-remove",
        abstract: "Remove primer sequences using bbduk"
    )

    @Argument(help: "Input FASTQ file")
    var input: String

    @Option(name: .customLong("literal"), help: "Primer sequence (IUPAC nucleotides)")
    var literalSequence: String?

    @Option(name: .customLong("ref"), help: "Primer reference FASTA file")
    var reference: String?

    @Option(name: .customLong("kmer"), help: "K-mer size (default: 23)")
    var kmerSize: Int = 23

    @Option(name: .customLong("mink"), help: "Minimum k-mer size (default: 11)")
    var minKmer: Int = 11

    @Option(name: .customLong("hdist"), help: "Hamming distance tolerance (default: 1)")
    var hammingDistance: Int = 1

    @OptionGroup var output: OutputOptions

    func run() async throws {
        let inputURL = try validateInput(input)
        try output.validateOutput()
        guard kmerSize > 0 else { throw ValidationError("--kmer must be > 0") }
        guard minKmer > 0 else { throw ValidationError("--mink must be > 0") }
        guard minKmer <= kmerSize else {
            throw ValidationError("--mink (\(minKmer)) must be <= --kmer (\(kmerSize))")
        }
        guard hammingDistance >= 0 else { throw ValidationError("--hdist must be >= 0") }
        let runner = NativeToolRunner.shared

        var args = [
            "in=\(inputURL.path)",
            "out=\(output.output)",
            "ktrim=r",
            "k=\(kmerSize)",
            "mink=\(minKmer)",
            "hdist=\(hammingDistance)",
        ]

        if let literalSequence {
            args.append("literal=\(literalSequence)")
        } else if let reference {
            guard FileManager.default.fileExists(atPath: reference) else {
                throw CLIError.inputFileNotFound(path: reference)
            }
            args.append("ref=\(reference)")
        } else {
            throw ValidationError("Specify --literal or --ref for primer sequence")
        }

        let env = await bbToolsEnvironment(runner: runner)
        let result = try await runner.run(.bbduk, arguments: args, environment: env, timeout: 1800)
        guard result.isSuccess else {
            throw CLIError.conversionFailed(reason: "bbduk primer removal failed: \(result.stderr)")
        }
        FileHandle.standardError.write(Data("Primer-trimmed reads written to \(output.output)\n".utf8))
    }
}

// MARK: - Error Correction

struct FastqErrorCorrectSubcommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "error-correct",
        abstract: "Correct sequencing errors using tadpole"
    )

    @Argument(help: "Input FASTQ file")
    var input: String

    @Option(name: .customLong("kmer"), help: "K-mer size for correction (default: 50, max: 62)")
    var kmerSize: Int = 50

    @OptionGroup var output: OutputOptions

    func run() async throws {
        let inputURL = try validateInput(input)
        try output.validateOutput()
        guard kmerSize > 0, kmerSize <= 62 else {
            throw ValidationError("K-mer size must be between 1 and 62")
        }
        let runner = NativeToolRunner.shared

        let args = [
            "in=\(inputURL.path)",
            "out=\(output.output)",
            "mode=correct",
            "ecc=t",
            "k=\(kmerSize)",
        ]

        let env = await bbToolsEnvironment(runner: runner)
        let result = try await runner.run(.tadpole, arguments: args, environment: env, timeout: 1800)
        guard result.isSuccess else {
            throw CLIError.conversionFailed(reason: "tadpole error correction failed: \(result.stderr)")
        }
        FileHandle.standardError.write(Data("Error-corrected reads written to \(output.output)\n".utf8))
    }
}

// MARK: - PE Merge

struct FastqMergeSubcommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "merge",
        abstract: "Merge overlapping paired-end reads using bbmerge"
    )

    @Argument(help: "Input interleaved FASTQ file")
    var input: String

    @Option(name: .customLong("min-overlap"), help: "Minimum overlap (default: 12)")
    var minOverlap: Int = 12

    @Flag(name: .customLong("strict"), help: "Use strict merge mode")
    var strict: Bool = false

    @OptionGroup var output: OutputOptions

    func run() async throws {
        let inputURL = try validateInput(input)
        try output.validateOutput()
        guard minOverlap > 0 else { throw ValidationError("--min-overlap must be > 0") }
        let runner = NativeToolRunner.shared

        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("bbmerge-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let mergedURL = tempDir.appendingPathComponent("merged.fastq")
        let unmergedURL = tempDir.appendingPathComponent("unmerged.fastq")

        var args = [
            "in=\(inputURL.path)",
            "out=\(mergedURL.path)",
            "outu=\(unmergedURL.path)",
            "minoverlap=\(minOverlap)",
        ]
        if strict { args.append("strict=t") }

        let env = await bbToolsEnvironment(runner: runner)
        let result = try await runner.run(.bbmerge, arguments: args, environment: env, timeout: 1800)
        guard result.isSuccess else {
            throw CLIError.conversionFailed(reason: "bbmerge failed: \(result.stderr)")
        }

        // Concatenate merged + unmerged
        let outputURL = URL(fileURLWithPath: output.output)
        FileManager.default.createFile(atPath: outputURL.path, contents: nil)
        let outputHandle = try FileHandle(forWritingTo: outputURL)
        defer { try? outputHandle.close() }
        for url in [mergedURL, unmergedURL] {
            guard FileManager.default.fileExists(atPath: url.path) else { continue }
            let inputHandle = try FileHandle(forReadingFrom: url)
            defer { try? inputHandle.close() }
            while true {
                let chunk = inputHandle.readData(ofLength: 1_048_576)
                if chunk.isEmpty { break }
                outputHandle.write(chunk)
            }
        }

        FileHandle.standardError.write(Data("Merged reads written to \(output.output)\n".utf8))
    }
}

// MARK: - PE Repair

struct FastqRepairSubcommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "repair",
        abstract: "Repair desynchronized paired-end reads using repair.sh"
    )

    @Argument(help: "Input interleaved FASTQ file")
    var input: String

    @OptionGroup var output: OutputOptions

    func run() async throws {
        let inputURL = try validateInput(input)
        try output.validateOutput()
        let runner = NativeToolRunner.shared

        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("bbrepair-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let repairedURL = tempDir.appendingPathComponent("repaired.fastq")
        let singletonsURL = tempDir.appendingPathComponent("singletons.fastq")

        let args = [
            "in=\(inputURL.path)",
            "out=\(repairedURL.path)",
            "outs=\(singletonsURL.path)",
        ]

        let env = await bbToolsEnvironment(runner: runner)
        let result = try await runner.run(.repair, arguments: args, environment: env, timeout: 1800)
        guard result.isSuccess else {
            throw CLIError.conversionFailed(reason: "repair.sh failed: \(result.stderr)")
        }

        // Concatenate repaired + singletons
        let outputURL = URL(fileURLWithPath: output.output)
        FileManager.default.createFile(atPath: outputURL.path, contents: nil)
        let outputHandle = try FileHandle(forWritingTo: outputURL)
        defer { try? outputHandle.close() }
        for url in [repairedURL, singletonsURL] {
            guard FileManager.default.fileExists(atPath: url.path) else { continue }
            let inputHandle = try FileHandle(forReadingFrom: url)
            defer { try? inputHandle.close() }
            while true {
                let chunk = inputHandle.readData(ofLength: 1_048_576)
                if chunk.isEmpty { break }
                outputHandle.write(chunk)
            }
        }

        FileHandle.standardError.write(Data("Repaired reads written to \(output.output)\n".utf8))
    }
}

// MARK: - Deinterleave

struct FastqDeinterleaveSubcommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "deinterleave",
        abstract: "Split interleaved FASTQ into separate R1/R2 files"
    )

    @Argument(help: "Input interleaved FASTQ file")
    var input: String

    @Option(name: .customLong("out1"), help: "Output R1 file (required)")
    var out1: String

    @Option(name: .customLong("out2"), help: "Output R2 file (required)")
    var out2: String

    func run() async throws {
        let inputURL = try validateInput(input)
        let runner = NativeToolRunner.shared

        let args = [
            "in=\(inputURL.path)",
            "out1=\(out1)",
            "out2=\(out2)",
            "interleaved=t",
        ]

        let env = await bbToolsEnvironment(runner: runner)
        let result = try await runner.run(.reformat, arguments: args, environment: env, timeout: 1800)
        guard result.isSuccess else {
            throw CLIError.conversionFailed(reason: "reformat.sh deinterleave failed: \(result.stderr)")
        }
        FileHandle.standardError.write(Data("Deinterleaved: R1 → \(out1), R2 → \(out2)\n".utf8))
    }
}

// MARK: - Interleave

struct FastqInterleaveSubcommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "interleave",
        abstract: "Interleave separate R1/R2 files into one FASTQ"
    )

    @Option(name: .customLong("in1"), help: "Input R1 file (required)")
    var in1: String

    @Option(name: .customLong("in2"), help: "Input R2 file (required)")
    var in2: String

    @OptionGroup var output: OutputOptions

    func run() async throws {
        guard FileManager.default.fileExists(atPath: in1) else {
            throw CLIError.inputFileNotFound(path: in1)
        }
        guard FileManager.default.fileExists(atPath: in2) else {
            throw CLIError.inputFileNotFound(path: in2)
        }
        try output.validateOutput()
        let runner = NativeToolRunner.shared

        let args = [
            "in1=\(in1)",
            "in2=\(in2)",
            "out=\(output.output)",
        ]

        let env = await bbToolsEnvironment(runner: runner)
        let result = try await runner.run(.reformat, arguments: args, environment: env, timeout: 1800)
        guard result.isSuccess else {
            throw CLIError.conversionFailed(reason: "reformat.sh interleave failed: \(result.stderr)")
        }
        FileHandle.standardError.write(Data("Interleaved reads written to \(output.output)\n".utf8))
    }
}

// MARK: - Deduplicate

struct FastqDeduplicateSubcommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "deduplicate",
        abstract: "Remove duplicate reads using seqkit"
    )

    @Argument(help: "Input FASTQ file")
    var input: String

    @Option(name: .customLong("by"), help: "Dedup key: id, sequence (default: id)")
    var mode: String = "id"

    @OptionGroup var output: OutputOptions

    func run() async throws {
        let inputURL = try validateInput(input)
        try output.validateOutput()
        let runner = NativeToolRunner.shared

        var args = ["rmdup"]
        switch mode {
        case "id": args.append("-n")
        case "sequence": args.append("-s")
        default:
            throw ValidationError("Invalid dedup mode: \(mode). Use: id, sequence")
        }
        args += [inputURL.path, "-o", output.output]

        let result = try await runner.run(.seqkit, arguments: args)
        guard result.isSuccess else {
            throw CLIError.conversionFailed(reason: "seqkit rmdup failed: \(result.stderr)")
        }
        FileHandle.standardError.write(Data("Deduplicated reads written to \(output.output)\n".utf8))
    }
}
