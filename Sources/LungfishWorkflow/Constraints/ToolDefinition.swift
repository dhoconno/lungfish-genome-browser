// ToolDefinition.swift - Protocol for defining workflow tool interfaces
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import LungfishCore
import LungfishIO

// MARK: - ToolCategory

/// Categories for organizing tools in the workflow system.
///
/// Categories help users discover tools and organize the tool palette
/// in the workflow builder interface.
public enum ToolCategory: String, Sendable, CaseIterable, Codable {
    /// Read alignment tools (BWA, Bowtie2, STAR, etc.)
    case alignment

    /// Genome/transcriptome assembly tools (SPAdes, Trinity, etc.)
    case assembly

    /// Annotation tools (Prokka, BLAST, InterProScan, etc.)
    case annotation

    /// Variant calling tools (GATK, bcftools, FreeBayes, etc.)
    case variantCalling

    /// Phylogenetics tools (RAxML, IQ-TREE, BEAST, etc.)
    case phylogenetics

    /// Sequence analysis tools (BLAST, HMMER, etc.)
    case sequenceAnalysis

    /// Quality control tools (FastQC, MultiQC, etc.)
    case qualityControl

    /// Format conversion utilities
    case conversion

    /// Visualization tools
    case visualization

    /// General utility tools
    case utility

    /// Returns a human-readable display name for the category
    public var displayName: String {
        switch self {
        case .alignment: return "Alignment"
        case .assembly: return "Assembly"
        case .annotation: return "Annotation"
        case .variantCalling: return "Variant Calling"
        case .phylogenetics: return "Phylogenetics"
        case .sequenceAnalysis: return "Sequence Analysis"
        case .qualityControl: return "Quality Control"
        case .conversion: return "Conversion"
        case .visualization: return "Visualization"
        case .utility: return "Utility"
        }
    }

    /// Returns an SF Symbol icon name for the category
    public var iconName: String {
        switch self {
        case .alignment: return "arrow.left.arrow.right"
        case .assembly: return "puzzlepiece.extension"
        case .annotation: return "tag"
        case .variantCalling: return "waveform.path.ecg"
        case .phylogenetics: return "tree"
        case .sequenceAnalysis: return "magnifyingglass"
        case .qualityControl: return "checkmark.shield"
        case .conversion: return "arrow.triangle.2.circlepath"
        case .visualization: return "chart.bar"
        case .utility: return "wrench.and.screwdriver"
        }
    }
}

// MARK: - ToolDefinition Protocol

/// Defines a tool's interface for input/output validation and workflow integration.
///
/// Tools implement this protocol to declare their requirements,
/// enabling automatic validation and conversion suggestions.
///
/// The workflow system uses tool definitions to:
/// - Validate inputs before execution
/// - Suggest format conversions when needed
/// - Display appropriate UI for tool configuration
/// - Check for required external binaries
///
/// ## Example
/// ```swift
/// struct BWAMemTool: ToolDefinition {
///     let identifier = "bwa-mem"
///     let name = "BWA MEM"
///     let description = "Aligns sequencing reads to a reference genome"
///     let category: ToolCategory = .alignment
///     let inputSignatures = [
///         InputSignature(
///             requiredCapabilities: [.nucleotideSequence, .qualityScores],
///             minimumCount: 1,
///             maximumCount: 2,
///             preferredFormat: .fastq,
///             description: "Sequencing reads (single or paired-end)"
///         )
///     ]
///     let outputCapabilities: DocumentCapability = [.alignment, .qualityScores]
///     let requiresExternalBinary = true
///     let externalBinaryName: String? = "bwa"
/// }
/// ```
public protocol ToolDefinition: Sendable {
    /// Unique identifier for the tool (e.g., "bwa-mem", "spades", "samtools-sort").
    ///
    /// This identifier is used internally to reference tools and should be
    /// stable across versions. Use lowercase with hyphens for consistency.
    var identifier: String { get }

    /// Human-readable name for display in the UI.
    var name: String { get }

    /// Brief description of what the tool does.
    var description: String { get }

    /// Category for organizing the tool in the UI.
    var category: ToolCategory { get }

    /// Input requirements - may have multiple for different input types.
    ///
    /// For example, an aligner might have separate signatures for:
    /// - Reads input (FASTQ)
    /// - Reference input (FASTA)
    ///
    /// The workflow builder uses these to validate connections between tools.
    var inputSignatures: [InputSignature] { get }

    /// Capabilities that the tool's output will have.
    ///
    /// This enables the workflow system to determine which downstream
    /// tools can accept this tool's output.
    var outputCapabilities: DocumentCapability { get }

    /// Whether this tool requires an external binary (not built into Lungfish).
    ///
    /// If `true`, the workflow system will check for the binary's presence
    /// before allowing the tool to be used.
    var requiresExternalBinary: Bool { get }

    /// Name of the external binary if required (e.g., "bwa", "samtools").
    ///
    /// This is the command name that should be found in PATH.
    var externalBinaryName: String? { get }

    /// Version requirement for the external binary (e.g., ">=0.7.17").
    ///
    /// If specified, the workflow system will verify the installed version
    /// meets this requirement.
    var versionRequirement: String? { get }

    /// Validates inputs against all input signatures.
    ///
    /// Override this method for tools with complex validation logic that
    /// goes beyond simple capability checking.
    ///
    /// - Parameter inputs: The capability providers to validate
    /// - Returns: Validation result with any errors
    func validate(inputs: [any CapabilityProvider]) -> ValidationResult
}

// MARK: - Default Implementation

extension ToolDefinition {
    /// Default validation checks if inputs satisfy any of the input signatures.
    public func validate(inputs: [any CapabilityProvider]) -> ValidationResult {
        // If no signatures defined, accept any input
        guard !inputSignatures.isEmpty else {
            return .valid
        }

        // Try each signature and collect the results
        var allErrors: [[ValidationError]] = []

        for signature in inputSignatures {
            let result = signature.matches(documents: inputs)
            if result.isValid {
                return .valid
            }
            allErrors.append(result.errors)
        }

        // None of the signatures matched - return errors from the first signature
        // as it is typically the primary input signature
        return .invalid(reasons: allErrors[0])
    }

    /// Default: no version requirement
    public var versionRequirement: String? { nil }

    /// Checks if the required external binary is available on the system.
    ///
    /// This uses `which` to locate the binary in PATH.
    public var isExternalBinaryAvailable: Bool {
        guard requiresExternalBinary, let binaryName = externalBinaryName else {
            return true
        }

        // Check if binary exists in PATH
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/which")
        process.arguments = [binaryName]

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus == 0
        } catch {
            return false
        }
    }
}

// MARK: - GenericToolDefinition

/// A generic implementation of ToolDefinition for simple tool configurations.
///
/// Use this for tools that don't need custom validation logic.
/// For tools with complex validation requirements, create a custom
/// struct conforming to ToolDefinition instead.
///
/// ## Example
/// ```swift
/// let blastTool = GenericToolDefinition(
///     identifier: "blastn",
///     name: "BLAST Nucleotide Search",
///     description: "Search nucleotide databases using a nucleotide query",
///     category: .sequenceAnalysis,
///     inputSignatures: [
///         InputSignature(
///             requiredCapabilities: .nucleotideSequence,
///             preferredFormat: .fasta,
///             description: "Query sequences"
///         )
///     ],
///     outputCapabilities: [],
///     requiresExternalBinary: true,
///     externalBinaryName: "blastn"
/// )
/// ```
public struct GenericToolDefinition: ToolDefinition {
    public let identifier: String
    public let name: String
    public let description: String
    public let category: ToolCategory
    public let inputSignatures: [InputSignature]
    public let outputCapabilities: DocumentCapability
    public let requiresExternalBinary: Bool
    public let externalBinaryName: String?
    public let versionRequirement: String?

    /// Creates a new generic tool definition.
    ///
    /// - Parameters:
    ///   - identifier: Unique identifier for the tool
    ///   - name: Human-readable name
    ///   - description: Brief description
    ///   - category: Tool category for organization
    ///   - inputSignatures: Input requirements
    ///   - outputCapabilities: Capabilities of the output
    ///   - requiresExternalBinary: Whether an external binary is needed
    ///   - externalBinaryName: Name of the external binary
    ///   - versionRequirement: Version requirement string
    public init(
        identifier: String,
        name: String,
        description: String,
        category: ToolCategory,
        inputSignatures: [InputSignature],
        outputCapabilities: DocumentCapability,
        requiresExternalBinary: Bool = false,
        externalBinaryName: String? = nil,
        versionRequirement: String? = nil
    ) {
        self.identifier = identifier
        self.name = name
        self.description = description
        self.category = category
        self.inputSignatures = inputSignatures
        self.outputCapabilities = outputCapabilities
        self.requiresExternalBinary = requiresExternalBinary
        self.externalBinaryName = externalBinaryName
        self.versionRequirement = versionRequirement
    }
}

// MARK: - GenericToolDefinition Equatable & Hashable

extension GenericToolDefinition: Equatable {
    public static func == (lhs: GenericToolDefinition, rhs: GenericToolDefinition) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

extension GenericToolDefinition: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

// MARK: - ToolDefinition Collection Extensions

extension Collection where Element: ToolDefinition {
    /// Returns tools in a specific category.
    public func inCategory(_ category: ToolCategory) -> [Element] {
        filter { $0.category == category }
    }

    /// Finds a tool by its identifier.
    public func withIdentifier(_ identifier: String) -> Element? {
        first { $0.identifier == identifier }
    }

    /// Returns tools that can accept a given capability set.
    ///
    /// Useful for finding tools that can process a specific document type.
    public func accepting(capabilities: DocumentCapability) -> [Element] {
        filter { tool in
            tool.inputSignatures.contains { signature in
                capabilities.contains(signature.requiredCapabilities)
            }
        }
    }

    /// Returns tools that produce a given capability set.
    ///
    /// Useful for finding tools that can create outputs for downstream analysis.
    public func producing(capabilities: DocumentCapability) -> [Element] {
        filter { $0.outputCapabilities.contains(capabilities) }
    }
}
