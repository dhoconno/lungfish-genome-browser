// BuiltInTools.swift - Predefined tool definitions for common bioinformatics tools
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import LungfishCore
import LungfishIO

// MARK: - Built-in Tool Definitions

/// Collection of predefined tool definitions for common bioinformatics tools.
///
/// These definitions enable automatic input validation and format conversion
/// suggestions when building workflows.
///
/// ## Overview
///
/// BuiltInTools provides definitions for common bioinformatics workflows:
/// - **Alignment**: BWA, Bowtie2
/// - **Assembly**: SPAdes
/// - **Utilities**: samtools sort/index
/// - **Analysis**: BLAST, variant calling
/// - **QC**: FastQC
///
/// ## Example
/// ```swift
/// // Validate inputs for BWA alignment
/// let result = BuiltInTools.bwaAligner.validate(inputs: myDocuments)
/// if result.isValid {
///     // Proceed with alignment
/// }
///
/// // Find all alignment tools
/// let aligners = BuiltInTools.allTools.filter { $0.category == .alignment }
/// ```
public enum BuiltInTools {

    // MARK: - Alignment Tools

    /// BWA MEM aligner for read alignment.
    ///
    /// BWA-MEM is designed for aligning sequence reads against a large reference
    /// genome such as human. It automatically chooses between local and end-to-end
    /// alignments, supports split alignment of a single read, and works well with
    /// reads from 70bp to a few megabases.
    ///
    /// **Input Requirements:**
    /// - Reads: FASTQ with quality scores (1-2 files for single/paired-end)
    /// - Reference: Indexed FASTA reference genome
    ///
    /// **Output:**
    /// - SAM/BAM file with aligned reads
    public static let bwaAligner = BWAAligner()

    /// SPAdes genome assembler.
    ///
    /// SPAdes (St. Petersburg genome assembler) is designed for both
    /// single-cell and standard bacterial/archaea genome assemblies.
    /// It can handle Illumina, IonTorrent, and PacBio reads.
    ///
    /// **Input Requirements:**
    /// - Sequencing reads (FASTQ) with quality scores
    /// - Supports single-end, paired-end, and mate-pair libraries
    ///
    /// **Output:**
    /// - Assembly contigs and scaffolds in FASTA format
    public static let spadesAssembler = SPAdesAssembler()

    /// Samtools sort for sorting alignment files.
    ///
    /// Sorts alignments by leftmost coordinates, or by read name when
    /// `-n` is used. This is often required before downstream analysis
    /// like variant calling.
    ///
    /// **Input Requirements:**
    /// - SAM or BAM file with aligned reads
    ///
    /// **Output:**
    /// - Sorted BAM file
    public static let samtoolsSort = SamtoolsSort()

    // MARK: - Additional Common Tools

    /// Samtools index for creating BAM index files.
    public static let samtoolsIndex = GenericToolDefinition(
        identifier: "samtools-index",
        name: "Samtools Index",
        description: "Creates index for coordinate-sorted BAM/CRAM files",
        category: .utility,
        inputSignatures: [
            InputSignature(
                requiredCapabilities: [.alignment, .sorted],
                minimumCount: 1,
                maximumCount: 1,
                preferredFormat: .bam,
                inputDescription: "Coordinate-sorted BAM or CRAM file"
            )
        ],
        outputCapabilities: [.alignment, .sorted, .indexed],
        requiresExternalBinary: true,
        externalBinaryName: "samtools"
    )

    /// BLAST nucleotide search.
    public static let blastn = GenericToolDefinition(
        identifier: "blastn",
        name: "BLAST Nucleotide Search",
        description: "Searches nucleotide databases using a nucleotide query",
        category: .sequenceAnalysis,
        inputSignatures: [
            InputSignature(
                requiredCapabilities: .nucleotideSequence,
                minimumCount: 1,
                maximumCount: nil,
                preferredFormat: .fasta,
                inputDescription: "Query nucleotide sequences"
            )
        ],
        outputCapabilities: [],  // BLAST output is a report, not a document
        requiresExternalBinary: true,
        externalBinaryName: "blastn"
    )

    /// bcftools variant calling.
    public static let bcftoolsCall = GenericToolDefinition(
        identifier: "bcftools-call",
        name: "Variant Calling",
        description: "Calls SNPs and indels from aligned reads",
        category: .variantCalling,
        inputSignatures: [
            InputSignature(
                requiredCapabilities: [.alignment, .sorted, .indexed],
                optionalCapabilities: .pairedReads,
                minimumCount: 1,
                maximumCount: 1,
                preferredFormat: .bam,
                inputDescription: "Sorted, indexed BAM file"
            )
        ],
        outputCapabilities: .variants,
        requiresExternalBinary: true,
        externalBinaryName: "bcftools"
    )

    /// FastQC quality control.
    public static let fastqc = GenericToolDefinition(
        identifier: "fastqc",
        name: "FastQC",
        description: "Quality control checks on raw sequence data",
        category: .qualityControl,
        inputSignatures: [
            InputSignature(
                requiredCapabilities: [.nucleotideSequence, .qualityScores],
                minimumCount: 1,
                maximumCount: nil,
                preferredFormat: .fastq,
                inputDescription: "Sequencing reads with quality scores"
            )
        ],
        outputCapabilities: [],  // FastQC output is a report
        requiresExternalBinary: true,
        externalBinaryName: "fastqc"
    )

    /// All built-in tool definitions
    public static var allTools: [any ToolDefinition] {
        [
            bwaAligner,
            spadesAssembler,
            samtoolsSort,
            samtoolsIndex,
            blastn,
            bcftoolsCall,
            fastqc
        ]
    }

    /// Returns tools in a specific category
    public static func tools(in category: ToolCategory) -> [any ToolDefinition] {
        allTools.filter { $0.category == category }
    }

    /// Finds a tool by identifier
    public static func tool(withIdentifier identifier: String) -> (any ToolDefinition)? {
        allTools.first { $0.identifier == identifier }
    }
}

// MARK: - BWAAligner

/// BWA-MEM aligner tool definition.
///
/// BWA-MEM is the primary algorithm in BWA for aligning sequence reads
/// against a reference genome. It works well for reads from 70bp to several
/// megabases and automatically switches between local and end-to-end alignment.
///
/// ## Algorithm Details
/// - Uses seed-and-extend approach with re-seeding
/// - Supports both global and local alignment modes
/// - Handles long reads efficiently with optional seeding heuristics
///
/// ## Input Validation
/// This tool has custom validation that checks:
/// 1. Both reads and reference are provided
/// 2. Reference is properly indexed
/// 3. Quality scores are present (warning if missing)
public struct BWAAligner: ToolDefinition {
    public let identifier = "bwa-mem"
    public let name = "BWA MEM Alignment"
    public let description = "Aligns sequencing reads to a reference genome using BWA-MEM algorithm"
    public let category: ToolCategory = .alignment

    public let inputSignatures: [InputSignature] = [
        // Reads input
        InputSignature(
            requiredCapabilities: .nucleotideSequence,
            optionalCapabilities: .qualityScores,
            minimumCount: 1,
            maximumCount: 2,  // Single-end or paired-end
            preferredFormat: .fastq,
            inputDescription: "Sequencing reads (single or paired-end FASTQ)"
        ),
        // Reference input
        InputSignature(
            requiredCapabilities: [.nucleotideSequence, .referenceSequence, .indexed],
            minimumCount: 1,
            maximumCount: 1,
            preferredFormat: .fasta,
            inputDescription: "Indexed reference genome (FASTA with BWA index)"
        )
    ]

    public let outputCapabilities: DocumentCapability = [
        .nucleotideSequence,
        .qualityScores,
        .alignment
    ]

    public let requiresExternalBinary = true
    public let externalBinaryName: String? = "bwa"
    public let versionRequirement: String? = ">=0.7.17"

    public init() {}

    /// Custom validation that checks both reads and reference are provided.
    public func validate(inputs: [any CapabilityProvider]) -> ValidationResult {
        var errors: [ValidationError] = []

        // Check that we have at least 2 inputs (reads + reference)
        // or 3 inputs (paired reads + reference)
        if inputs.count < 2 {
            errors.append(ValidationError(
                message: "BWA requires at least 2 inputs: reads and reference genome",
                suggestion: "Provide sequencing reads and an indexed reference genome",
                category: .count
            ))
            return .invalid(reasons: errors)
        }

        // Find reference candidates (must have referenceSequence capability)
        let references = inputs.filter { $0.capabilities.contains(.referenceSequence) }
        if references.isEmpty {
            errors.append(ValidationError(
                message: "No reference genome found in inputs",
                suggestion: "Add an indexed FASTA reference genome",
                category: .capability
            ))
        } else if references.count > 1 {
            errors.append(ValidationError(
                message: "Multiple reference genomes found",
                suggestion: "Provide only one reference genome",
                category: .count
            ))
        }

        // Find read candidates (have nucleotide sequence, may have quality)
        let reads = inputs.filter {
            $0.capabilities.contains(.nucleotideSequence) &&
            !$0.capabilities.contains(.referenceSequence)
        }

        if reads.isEmpty {
            errors.append(ValidationError(
                message: "No sequencing reads found in inputs",
                suggestion: "Add FASTQ files with sequencing reads",
                category: .capability
            ))
        } else if reads.count > 2 {
            errors.append(ValidationError(
                message: "Too many read files (\(reads.count))",
                suggestion: "Provide 1 file (single-end) or 2 files (paired-end)",
                category: .count
            ))
        }

        // Check if reads have quality scores (warning, not error)
        for (index, read) in reads.enumerated() {
            if !read.capabilities.contains(.qualityScores) {
                errors.append(ValidationError(
                    message: "Read file \(index + 1) missing quality scores",
                    suggestion: "Use FASTQ format for best alignment results",
                    category: .format
                ))
            }
        }

        // Check reference is indexed
        if let ref = references.first {
            if !ref.capabilities.contains(.indexed) {
                errors.append(ValidationError(
                    message: "Reference genome is not indexed",
                    suggestion: "Run 'bwa index' on the reference FASTA first",
                    category: .capability
                ))
            }
        }

        if errors.isEmpty {
            return .valid
        }
        return .invalid(reasons: errors)
    }
}

// MARK: - SPAdesAssembler

/// SPAdes genome assembler tool definition.
///
/// SPAdes is an assembly toolkit containing various assembly pipelines.
/// It can assemble bacterial genomes, metagenomes, and transcriptomes
/// from Illumina, IonTorrent, and PacBio reads.
///
/// ## Features
/// - Multi-cell and single-cell assembly modes
/// - Metagenome and transcriptome assembly
/// - Supports multiple sequencing technologies
/// - Automatic error correction
///
/// ## Input Requirements
/// SPAdes requires quality scores for error correction. FASTA input
/// without quality scores will result in validation errors.
public struct SPAdesAssembler: ToolDefinition {
    public let identifier = "spades"
    public let name = "SPAdes Assembler"
    public let description = "De novo genome assembler for bacterial genomes, metagenomes, and transcriptomes"
    public let category: ToolCategory = .assembly

    public let inputSignatures: [InputSignature] = [
        // Single-end or paired-end reads
        InputSignature(
            requiredCapabilities: [.nucleotideSequence, .qualityScores],
            optionalCapabilities: .pairedReads,
            minimumCount: 1,
            maximumCount: nil,  // Can accept multiple libraries
            preferredFormat: .fastq,
            inputDescription: "Sequencing reads (FASTQ with quality scores)"
        )
    ]

    public let outputCapabilities: DocumentCapability = [
        .nucleotideSequence,
        .assembly
    ]

    public let requiresExternalBinary = true
    public let externalBinaryName: String? = "spades.py"
    public let versionRequirement: String? = ">=3.15.0"

    public init() {}

    /// Validates SPAdes inputs with specific checks for assembly requirements.
    public func validate(inputs: [any CapabilityProvider]) -> ValidationResult {
        var errors: [ValidationError] = []

        // Must have at least one input
        if inputs.isEmpty {
            errors.append(.tooFewInputs(expected: 1, actual: 0))
            return .invalid(reasons: errors)
        }

        // Check each input has required capabilities
        for (index, input) in inputs.enumerated() {
            // Must have nucleotide sequence
            if !input.capabilities.contains(.nucleotideSequence) {
                errors.append(.missingCapabilities(
                    "nucleotideSequence",
                    inputIndex: index
                ))
            }

            // Must have quality scores for assembly
            if !input.capabilities.contains(.qualityScores) {
                errors.append(ValidationError(
                    message: "Input \(index) missing quality scores",
                    suggestion: "SPAdes requires quality scores for error correction. Use FASTQ format.",
                    category: .capability
                ))
            }
        }

        if errors.isEmpty {
            return .valid
        }
        return .invalid(reasons: errors)
    }
}

// MARK: - SamtoolsSort

/// Samtools sort tool definition.
///
/// Sorts alignments by leftmost coordinates, or by read name when `-n` is used.
/// An appropriate @HD-SO sort order header tag will be added or an existing
/// one updated if necessary.
///
/// ## Sort Orders
/// - Coordinate sort (default): Required for indexing and variant calling
/// - Name sort (`-n`): Required for some downstream tools like `fixmate`
///
/// ## Performance
/// - Uses multiple threads for faster sorting
/// - Supports streaming large files
/// - Can merge multiple sorted files
public struct SamtoolsSort: ToolDefinition {
    public let identifier = "samtools-sort"
    public let name = "Samtools Sort"
    public let description = "Sorts alignment files by coordinate or read name"
    public let category: ToolCategory = .utility

    public let inputSignatures: [InputSignature] = [
        InputSignature(
            requiredCapabilities: .alignment,
            optionalCapabilities: [.qualityScores, .pairedReads],
            minimumCount: 1,
            maximumCount: 1,
            preferredFormat: .bam,
            inputDescription: "Unsorted or differently-sorted SAM/BAM/CRAM file"
        )
    ]

    public let outputCapabilities: DocumentCapability = [
        .alignment,
        .sorted
    ]

    public let requiresExternalBinary = true
    public let externalBinaryName: String? = "samtools"
    public let versionRequirement: String? = ">=1.10"

    public init() {}

    /// Validates samtools sort inputs.
    public func validate(inputs: [any CapabilityProvider]) -> ValidationResult {
        var errors: [ValidationError] = []

        // Must have exactly one input
        if inputs.isEmpty {
            errors.append(.tooFewInputs(expected: 1, actual: 0))
            return .invalid(reasons: errors)
        }

        if inputs.count > 1 {
            errors.append(.tooManyInputs(expected: 1, actual: inputs.count))
        }

        // Check the input has alignment data
        if let input = inputs.first {
            if !input.capabilities.contains(.alignment) {
                errors.append(.missingCapabilities(
                    "alignment",
                    inputIndex: 0
                ))
            }

            // Warn if already sorted (not an error, but potentially wasteful)
            // This could be extended to include informational messages
        }

        if errors.isEmpty {
            return .valid
        }
        return .invalid(reasons: errors)
    }
}

// MARK: - ToolDefinition Conformance

extension BWAAligner: Equatable {
    public static func == (lhs: BWAAligner, rhs: BWAAligner) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

extension BWAAligner: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

extension SPAdesAssembler: Equatable {
    public static func == (lhs: SPAdesAssembler, rhs: SPAdesAssembler) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

extension SPAdesAssembler: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

extension SamtoolsSort: Equatable {
    public static func == (lhs: SamtoolsSort, rhs: SamtoolsSort) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

extension SamtoolsSort: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
