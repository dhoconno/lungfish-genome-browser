// CompositionCommand.swift - Detailed sequence composition analysis
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import ArgumentParser
import Foundation
import LungfishCore
import LungfishIO

/// Calculate detailed sequence composition
struct CompositionSubcommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "composition",
        abstract: "Calculate detailed nucleotide/amino acid composition",
        discussion: """
            Calculate detailed composition statistics including:
            - Per-base/residue counts and percentages
            - Purine/pyrimidine ratios (nucleotides)
            - GC/AT skew (nucleotides)
            - Codon usage table (nucleotides, --codons)
            - Dinucleotide frequencies (nucleotides, --dinucleotides)

            This is the CLI equivalent of the Sequence Statistics plugin.

            Examples:
              lungfish analyze composition genome.fasta
              lungfish analyze composition coding.fasta --codons
              lungfish analyze composition genome.fasta --dinucleotides
              lungfish analyze composition protein.faa --alphabet protein
            """
    )

    @Argument(help: "Input file path")
    var input: String

    @Flag(
        name: .customLong("codons"),
        help: "Show codon usage table (nucleotide sequences only)"
    )
    var showCodons: Bool = false

    @Flag(
        name: .customLong("dinucleotides"),
        help: "Show dinucleotide frequencies (nucleotide sequences only)"
    )
    var showDinucleotides: Bool = false

    @Option(
        name: .customLong("alphabet"),
        help: "Sequence alphabet: dna, rna, protein (default: auto-detect from file extension)"
    )
    var alphabetOverride: String?

    @OptionGroup var globalOptions: GlobalOptions

    func run() async throws {
        let formatter = TerminalFormatter(useColors: globalOptions.useColors)

        // Validate input
        guard FileManager.default.fileExists(atPath: input) else {
            throw CLIError.inputFileNotFound(path: input)
        }

        let inputURL = URL(fileURLWithPath: input)

        // Detect format
        var detectURL = inputURL
        if detectURL.pathExtension.lowercased() == "gz" {
            detectURL = detectURL.deletingPathExtension()
        }
        let ext = detectURL.pathExtension.lowercased()

        // Determine alphabet
        let alphabet: SequenceAlphabet
        if let override = alphabetOverride {
            switch override.lowercased() {
            case "dna": alphabet = .dna
            case "rna": alphabet = .rna
            case "protein": alphabet = .protein
            default:
                throw CLIError.conversionFailed(
                    reason: "Unknown alphabet '\(override)'. Use: dna, rna, protein"
                )
            }
        } else {
            // Infer from extension
            switch ext {
            case "faa": alphabet = .protein
            default: alphabet = .dna
            }
        }

        let isNucleotide = alphabet == .dna || alphabet == .rna

        // Read sequences
        let sequences: [Sequence]
        switch ext {
        case "fa", "fasta", "fna", "faa":
            let reader = try FASTAReader(url: inputURL)
            sequences = try await reader.readAll(alphabet: alphabet)
        case "fastq", "fq":
            let reader = FASTQReader()
            let fastqRecords = try await reader.readAll(from: inputURL)
            sequences = try fastqRecords.map { record in
                try Sequence(
                    name: record.identifier,
                    description: record.description,
                    alphabet: alphabet,
                    bases: record.sequence
                )
            }
        case "gb", "gbk", "genbank":
            let reader = try GenBankReader(url: inputURL)
            let records = try await reader.readAll()
            sequences = records.map { $0.sequence }
        default:
            throw CLIError.formatDetectionFailed(path: input)
        }

        guard !sequences.isEmpty else {
            throw CLIError.conversionFailed(reason: "No sequences found in input file")
        }

        if !globalOptions.quiet {
            print(formatter.info(
                "Analyzing composition of \(sequences.count) sequence(s) from \(inputURL.lastPathComponent)..."
            ))
        }

        // Concatenate all sequences for aggregate stats
        let concatenated = sequences.map { $0.asString().uppercased() }.joined()

        // Build composition data
        let compositionData = buildComposition(
            concatenated,
            isNucleotide: isNucleotide,
            alphabetName: alphabet.rawValue,
            showCodons: showCodons,
            showDinucleotides: showDinucleotides
        )

        // Output
        switch globalOptions.outputFormat {
        case .json:
            let handler = JSONOutputHandler()
            handler.writeData(compositionData, label: nil)

        case .tsv:
            // Base composition as TSV
            print("residue\tcount\tpercentage")
            for entry in compositionData.baseComposition {
                print("\(entry.residue)\t\(entry.count)\t\(String(format: "%.4f", entry.percentage))")
            }

            if let codons = compositionData.codonUsage {
                print("\ncodon\tamino_acid\tcount\tfrequency")
                for entry in codons {
                    print("\(entry.codon)\t\(entry.aminoAcid)\t\(entry.count)\t\(String(format: "%.4f", entry.frequency))")
                }
            }

            if let dinucs = compositionData.dinucleotideFrequencies {
                print("\ndinucleotide\tcount\tfrequency")
                for entry in dinucs {
                    print("\(entry.dinucleotide)\t\(entry.count)\t\(String(format: "%.4f", entry.frequency))")
                }
            }

        case .text:
            print(formatter.header("Sequence Composition"))
            print(formatter.keyValueTable([
                ("File", inputURL.lastPathComponent),
                ("Sequences", "\(sequences.count)"),
                ("Total length", "\(concatenated.count) \(isNucleotide ? "bp" : "aa")"),
                ("Alphabet", alphabet.rawValue),
            ]))

            // Base composition table
            print("\n" + formatter.header("Base Composition"))
            let compHeaders = ["Residue", "Count", "Percentage"]
            let compRows = compositionData.baseComposition.map { entry -> [String] in
                [entry.residue, "\(entry.count)", String(format: "%.2f%%", entry.percentage * 100)]
            }
            print(formatter.table(headers: compHeaders, rows: compRows))

            // Nucleotide-specific stats
            if isNucleotide {
                if let nucStats = compositionData.nucleotideStats {
                    print("\n" + formatter.header("Nucleotide Statistics"))
                    var pairs: [(String, String)] = [
                        ("Purines (A+G)", String(format: "%d (%.1f%%)", nucStats.purines, nucStats.purinePercent * 100)),
                        ("Pyrimidines (C+T)", String(format: "%d (%.1f%%)", nucStats.pyrimidines, nucStats.pyrimidinePercent * 100)),
                    ]
                    if let gcSkew = nucStats.gcSkew {
                        pairs.append(("GC Skew", String(format: "%.4f", gcSkew)))
                    }
                    if let atSkew = nucStats.atSkew {
                        pairs.append(("AT Skew", String(format: "%.4f", atSkew)))
                    }
                    print(formatter.keyValueTable(pairs))
                }
            }

            // Codon usage
            if let codons = compositionData.codonUsage {
                print("\n" + formatter.header("Codon Usage (Frame +1)"))
                let codonHeaders = ["Codon", "AA", "Count", "Frequency"]
                let codonRows = codons.map { entry -> [String] in
                    [entry.codon, entry.aminoAcid, "\(entry.count)", String(format: "%.2f%%", entry.frequency * 100)]
                }
                print(formatter.table(headers: codonHeaders, rows: codonRows))
            }

            // Dinucleotide frequencies
            if let dinucs = compositionData.dinucleotideFrequencies {
                print("\n" + formatter.header("Dinucleotide Frequencies"))
                let dinucHeaders = ["Dinucleotide", "Count", "Frequency"]
                let dinucRows = dinucs.map { entry -> [String] in
                    [entry.dinucleotide, "\(entry.count)", String(format: "%.2f%%", entry.frequency * 100)]
                }
                print(formatter.table(headers: dinucHeaders, rows: dinucRows))
            }
        }
    }

    // MARK: - Composition Analysis

    private func buildComposition(
        _ sequence: String,
        isNucleotide: Bool,
        alphabetName: String,
        showCodons: Bool,
        showDinucleotides: Bool
    ) -> CompositionData {
        let total = Double(sequence.count)

        // Base composition
        var counts: [Character: Int] = [:]
        for char in sequence {
            counts[char, default: 0] += 1
        }
        let baseComposition = counts.keys.sorted().map { char -> BaseCompositionEntry in
            let count = counts[char]!
            return BaseCompositionEntry(
                residue: String(char),
                count: count,
                percentage: Double(count) / total
            )
        }

        // Nucleotide-specific statistics
        var nucStats: NucleotideStatsData?
        if isNucleotide {
            let purines = (counts["A"] ?? 0) + (counts["G"] ?? 0)
            let pyrimidines = (counts["C"] ?? 0) + (counts["T"] ?? 0) + (counts["U"] ?? 0)

            let g = Double(counts["G"] ?? 0)
            let c = Double(counts["C"] ?? 0)
            let a = Double(counts["A"] ?? 0)
            let t = Double((counts["T"] ?? 0) + (counts["U"] ?? 0))

            let gcSkew: Double? = (g + c > 0) ? (g - c) / (g + c) : nil
            let atSkew: Double? = (a + t > 0) ? (a - t) / (a + t) : nil

            nucStats = NucleotideStatsData(
                purines: purines,
                purinePercent: Double(purines) / total,
                pyrimidines: pyrimidines,
                pyrimidinePercent: Double(pyrimidines) / total,
                gcSkew: gcSkew,
                atSkew: atSkew
            )
        }

        // Codon usage
        var codonUsage: [CodonUsageEntry]?
        if showCodons && isNucleotide && sequence.count >= 3 {
            var codonCounts: [String: Int] = [:]
            let chars = Array(sequence)
            for i in stride(from: 0, to: chars.count - 2, by: 3) {
                let codon = String(chars[i..<(i + 3)])
                if codon.allSatisfy({ "ATCGU".contains($0) }) {
                    codonCounts[codon, default: 0] += 1
                }
            }

            let totalCodons = Double(codonCounts.values.reduce(0, +))
            codonUsage = codonCounts.sorted { $0.key < $1.key }.map { codon, count in
                let aa = String(CodonTable.standard.translate(codon))
                return CodonUsageEntry(
                    codon: codon,
                    aminoAcid: aa,
                    count: count,
                    frequency: Double(count) / max(totalCodons, 1)
                )
            }
        }

        // Dinucleotide frequencies
        var dinucFreqs: [DinucleotideEntry]?
        if showDinucleotides && isNucleotide && sequence.count >= 2 {
            var dinucCounts: [String: Int] = [:]
            let chars = Array(sequence)
            for i in 0..<(chars.count - 1) {
                let dinuc = String(chars[i..<(i + 2)])
                if dinuc.allSatisfy({ "ATCGU".contains($0) }) {
                    dinucCounts[dinuc, default: 0] += 1
                }
            }

            let totalDinucs = Double(dinucCounts.values.reduce(0, +))
            dinucFreqs = dinucCounts.sorted { $0.key < $1.key }.map { dinuc, count in
                DinucleotideEntry(
                    dinucleotide: dinuc,
                    count: count,
                    frequency: Double(count) / max(totalDinucs, 1)
                )
            }
        }

        return CompositionData(
            totalLength: sequence.count,
            alphabet: alphabetName,
            baseComposition: baseComposition,
            nucleotideStats: nucStats,
            codonUsage: codonUsage,
            dinucleotideFrequencies: dinucFreqs
        )
    }
}

// MARK: - Composition Result Types

/// Composition analysis result
struct CompositionData: Codable {
    let totalLength: Int
    let alphabet: String
    let baseComposition: [BaseCompositionEntry]
    let nucleotideStats: NucleotideStatsData?
    let codonUsage: [CodonUsageEntry]?
    let dinucleotideFrequencies: [DinucleotideEntry]?
}

/// Single base/residue composition entry
struct BaseCompositionEntry: Codable {
    let residue: String
    let count: Int
    let percentage: Double
}

/// Nucleotide-specific statistics
struct NucleotideStatsData: Codable {
    let purines: Int
    let purinePercent: Double
    let pyrimidines: Int
    let pyrimidinePercent: Double
    let gcSkew: Double?
    let atSkew: Double?
}

/// Codon usage entry
struct CodonUsageEntry: Codable {
    let codon: String
    let aminoAcid: String
    let count: Int
    let frequency: Double
}

/// Dinucleotide frequency entry
struct DinucleotideEntry: Codable {
    let dinucleotide: String
    let count: Int
    let frequency: Double
}
