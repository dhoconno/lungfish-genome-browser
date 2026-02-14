// InputSignature.swift - Declares input requirements for workflow tools
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import LungfishCore
import LungfishIO

// MARK: - InputSignature

/// Declares the input requirements for a tool or operation.
///
/// InputSignature allows tools to specify:
/// - Required capabilities (must have all of these)
/// - Optional capabilities (can use if available)
/// - Minimum/maximum number of inputs
/// - Format preferences for optimization
///
/// This enables the workflow system to:
/// - Validate inputs before running tools
/// - Suggest format conversions when needed
/// - Display appropriate file pickers in the UI
///
/// ## Example
/// ```swift
/// // BLAST requires nucleotide sequences
/// let blastInput = InputSignature(
///     requiredCapabilities: .nucleotideSequence,
///     optionalCapabilities: .annotations,
///     minimumCount: 1,
///     maximumCount: nil,
///     preferredFormat: .fasta,
///     inputDescription: "Nucleotide sequences to search"
/// )
///
/// // Variant calling requires aligned, sorted, indexed BAM
/// let variantCallingInput = InputSignature(
///     requiredCapabilities: [.alignment, .sorted, .indexed],
///     optionalCapabilities: .pairedReads,
///     minimumCount: 1,
///     maximumCount: 1,
///     preferredFormat: .bam,
///     inputDescription: "Sorted, indexed BAM file"
/// )
/// ```
public struct InputSignature: Sendable, Hashable {
    /// Required capabilities that input documents must have.
    ///
    /// All documents must satisfy these capabilities for validation to pass.
    public let requiredCapabilities: DocumentCapability

    /// Optional capabilities that enhance the operation.
    ///
    /// The tool can take advantage of these if present, but they are not required.
    public let optionalCapabilities: DocumentCapability

    /// Minimum number of documents required.
    ///
    /// Validation fails if fewer than this many documents are provided.
    public let minimumCount: Int

    /// Maximum number of documents allowed (nil = unlimited).
    ///
    /// Validation fails if more than this many documents are provided.
    /// Set to `nil` for tools that can accept any number of inputs.
    public let maximumCount: Int?

    /// Preferred file format for external tools (nil = any).
    ///
    /// When preparing inputs for external tools, the system will
    /// convert to this format if possible. This is a hint, not a requirement.
    public let preferredFormat: FormatIdentifier?

    /// Human-readable description of the input requirements.
    ///
    /// Used in UI to help users understand what inputs are expected.
    public let inputDescription: String

    // MARK: - Initialization

    /// Creates a new input signature.
    ///
    /// - Parameters:
    ///   - requiredCapabilities: Capabilities that inputs must have
    ///   - optionalCapabilities: Capabilities that enhance operation if present
    ///   - minimumCount: Minimum number of inputs (default: 1)
    ///   - maximumCount: Maximum number of inputs (nil = unlimited, default: 1)
    ///   - preferredFormat: Preferred file format for external tools
    ///   - inputDescription: Human-readable description of requirements
    public init(
        requiredCapabilities: DocumentCapability,
        optionalCapabilities: DocumentCapability = .none,
        minimumCount: Int = 1,
        maximumCount: Int? = 1,
        preferredFormat: FormatIdentifier? = nil,
        inputDescription: String = ""
    ) {
        precondition(minimumCount >= 0, "minimumCount must be non-negative")
        precondition(maximumCount == nil || maximumCount! >= minimumCount,
                     "maximumCount must be >= minimumCount")

        self.requiredCapabilities = requiredCapabilities
        self.optionalCapabilities = optionalCapabilities
        self.minimumCount = minimumCount
        self.maximumCount = maximumCount
        self.preferredFormat = preferredFormat
        self.inputDescription = inputDescription
    }


    // MARK: - Validation

    /// Validates if a set of documents matches this signature.
    ///
    /// This method checks:
    /// 1. Document count is within allowed range
    /// 2. All documents have required capabilities
    ///
    /// - Parameter documents: Array of capability providers to validate
    /// - Returns: ValidationResult indicating success or failure with reasons
    public func matches(documents: [any CapabilityProvider]) -> ValidationResult {
        var errors: [ValidationError] = []

        // Check minimum count
        if documents.count < minimumCount {
            errors.append(.tooFewInputs(expected: minimumCount, actual: documents.count))
        }

        // Check maximum count
        if let max = maximumCount, documents.count > max {
            errors.append(.tooManyInputs(expected: max, actual: documents.count))
        }

        // Check required capabilities for each document
        for (index, document) in documents.enumerated() {
            let missing = document.missingCapabilities(for: requiredCapabilities)
            if !missing.isEmpty {
                errors.append(.missingCapabilities(
                    missing.description,
                    inputIndex: index
                ))
            }
        }

        if errors.isEmpty {
            return .valid
        }
        return .invalid(reasons: errors)
    }

    /// Checks if a single document satisfies the capability requirements.
    ///
    /// This does not check count constraints, only capabilities.
    ///
    /// - Parameter document: A capability provider to check
    /// - Returns: `true` if the document has all required capabilities
    public func isSatisfiedBy(_ document: any CapabilityProvider) -> Bool {
        document.satisfies(requirements: requiredCapabilities)
    }

    /// Returns the additional capabilities a document provides beyond requirements.
    ///
    /// This identifies which optional capabilities are present in the input,
    /// allowing tools to enable enhanced functionality when available.
    ///
    /// - Parameter document: A capability provider to check
    /// - Returns: Capabilities the document has that match optional requirements
    public func bonusCapabilities(from document: any CapabilityProvider) -> DocumentCapability {
        let provided = document.capabilities
        let beyondRequired = provided.subtracting(requiredCapabilities)
        return beyondRequired.intersection(optionalCapabilities)
    }
}

// MARK: - CustomStringConvertible

extension InputSignature: CustomStringConvertible {
    public var description: String {
        var parts: [String] = []

        parts.append("Required: \(requiredCapabilities)")

        if !optionalCapabilities.isEmpty {
            parts.append("Optional: \(optionalCapabilities)")
        }

        let countDesc: String
        if let max = maximumCount {
            if minimumCount == max {
                countDesc = "exactly \(minimumCount)"
            } else {
                countDesc = "\(minimumCount)-\(max)"
            }
        } else {
            countDesc = "\(minimumCount)+"
        }
        parts.append("Count: \(countDesc)")

        if let format = preferredFormat {
            parts.append("Preferred format: \(format.id)")
        }

        if !inputDescription.isEmpty {
            parts.append("Description: \(inputDescription)")
        }

        return "InputSignature(\(parts.joined(separator: ", ")))"
    }
}

// MARK: - Convenience Initializers

extension InputSignature {
    /// Creates an input signature for a single required document.
    ///
    /// - Parameters:
    ///   - requiredCapabilities: Capabilities the document must have
    ///   - preferredFormat: Preferred file format
    ///   - inputDescription: Human-readable description
    public static func single(
        requiredCapabilities: DocumentCapability,
        preferredFormat: FormatIdentifier? = nil,
        inputDescription: String = ""
    ) -> InputSignature {
        InputSignature(
            requiredCapabilities: requiredCapabilities,
            minimumCount: 1,
            maximumCount: 1,
            preferredFormat: preferredFormat,
            inputDescription: inputDescription
        )
    }

    /// Creates an input signature for one or more required documents.
    ///
    /// - Parameters:
    ///   - requiredCapabilities: Capabilities each document must have
    ///   - maxCount: Maximum number of documents (nil = unlimited)
    ///   - preferredFormat: Preferred file format
    ///   - inputDescription: Human-readable description
    public static func oneOrMore(
        requiredCapabilities: DocumentCapability,
        maxCount: Int? = nil,
        preferredFormat: FormatIdentifier? = nil,
        inputDescription: String = ""
    ) -> InputSignature {
        InputSignature(
            requiredCapabilities: requiredCapabilities,
            minimumCount: 1,
            maximumCount: maxCount,
            preferredFormat: preferredFormat,
            inputDescription: inputDescription
        )
    }

    /// Creates an input signature for paired-end read files.
    ///
    /// This is a common pattern for alignment tools that accept
    /// either one file (single-end) or two files (paired-end).
    ///
    /// - Parameters:
    ///   - preferredFormat: Preferred file format (default: .fastq)
    ///   - inputDescription: Human-readable description
    public static func pairedEndReads(
        preferredFormat: FormatIdentifier? = .fastq,
        inputDescription: String = "Sequencing reads (single or paired-end)"
    ) -> InputSignature {
        InputSignature(
            requiredCapabilities: .sequencingReads,
            optionalCapabilities: .pairedReads,
            minimumCount: 1,
            maximumCount: 2,
            preferredFormat: preferredFormat,
            inputDescription: inputDescription
        )
    }

    /// Creates an input signature for an indexed reference genome.
    ///
    /// This is a common requirement for alignment and variant calling tools.
    ///
    /// - Parameters:
    ///   - preferredFormat: Preferred file format (default: .fasta)
    ///   - inputDescription: Human-readable description
    public static func indexedReference(
        preferredFormat: FormatIdentifier? = .fasta,
        inputDescription: String = "Indexed reference genome"
    ) -> InputSignature {
        InputSignature(
            requiredCapabilities: .indexedReference,
            minimumCount: 1,
            maximumCount: 1,
            preferredFormat: preferredFormat,
            inputDescription: inputDescription
        )
    }

    /// Creates an input signature for sorted, indexed alignment files.
    ///
    /// This is required by variant calling and many other downstream tools.
    ///
    /// - Parameters:
    ///   - preferredFormat: Preferred file format (default: .bam)
    ///   - inputDescription: Human-readable description
    public static func analysisReadyAlignment(
        preferredFormat: FormatIdentifier? = .bam,
        inputDescription: String = "Sorted, indexed alignment file"
    ) -> InputSignature {
        InputSignature(
            requiredCapabilities: .analysisReadyAlignment,
            optionalCapabilities: [.pairedReads, .readGroups],
            minimumCount: 1,
            maximumCount: 1,
            preferredFormat: preferredFormat,
            inputDescription: inputDescription
        )
    }
}
