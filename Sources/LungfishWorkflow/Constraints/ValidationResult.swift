// ValidationResult.swift - Result types for input validation
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation

/// Result of validating tool inputs against their requirements.
///
/// ValidationResult provides detailed feedback about whether inputs
/// satisfy a tool's requirements and what issues were found.
///
/// ## Example
/// ```swift
/// let result = signature.matches(documents: inputs)
/// switch result {
/// case .valid:
///     print("Inputs are valid")
/// case .invalid(let reasons):
///     for error in reasons {
///         print("Error: \(error.message)")
///         if let suggestion = error.suggestion {
///             print("Suggestion: \(suggestion)")
///         }
///     }
/// }
/// ```
public enum ValidationResult: Sendable, Equatable {
    /// Validation passed - inputs satisfy all requirements
    case valid

    /// Validation failed - inputs do not satisfy requirements
    case invalid(reasons: [ValidationError])

    /// Whether validation passed
    public var isValid: Bool {
        if case .valid = self {
            return true
        }
        return false
    }

    /// Returns validation errors if invalid, empty array if valid
    public var errors: [ValidationError] {
        switch self {
        case .valid:
            return []
        case .invalid(let reasons):
            return reasons
        }
    }

    /// Combines two validation results.
    ///
    /// If both are valid, returns valid. If either is invalid,
    /// returns invalid with combined error messages.
    public func combined(with other: ValidationResult) -> ValidationResult {
        switch (self, other) {
        case (.valid, .valid):
            return .valid
        case (.valid, .invalid(let errors)):
            return .invalid(reasons: errors)
        case (.invalid(let errors), .valid):
            return .invalid(reasons: errors)
        case (.invalid(let errors1), .invalid(let errors2)):
            return .invalid(reasons: errors1 + errors2)
        }
    }
}

// MARK: - ValidationError

/// Describes a specific validation error with optional remediation suggestion.
///
/// ValidationError provides both a description of what went wrong and,
/// when possible, a suggestion for how to fix the issue.
///
/// ## Example
/// ```swift
/// let error = ValidationError(
///     message: "Missing quality scores",
///     suggestion: "Use FASTQ format instead of FASTA to preserve quality scores"
/// )
/// ```
public struct ValidationError: Sendable, Equatable, CustomStringConvertible {
    /// Human-readable error message describing the validation failure
    public let message: String

    /// Optional suggestion for how to fix the error
    public let suggestion: String?

    /// The category of validation error
    public let category: ErrorCategory

    /// Creates a new validation error.
    ///
    /// - Parameters:
    ///   - message: Description of what went wrong
    ///   - suggestion: Optional suggestion for remediation
    ///   - category: The category of error (defaults to `.requirement`)
    public init(
        message: String,
        suggestion: String? = nil,
        category: ErrorCategory = .requirement
    ) {
        self.message = message
        self.suggestion = suggestion
        self.category = category
    }

    public var description: String {
        if let suggestion = suggestion {
            return "\(message) (Suggestion: \(suggestion))"
        }
        return message
    }
}

// MARK: - ErrorCategory

/// Categories of validation errors for better organization and filtering.
public enum ErrorCategory: String, Sendable, CaseIterable {
    /// Missing required capability
    case capability

    /// Input count constraint violation
    case count

    /// Format preference not met
    case format

    /// General requirement not satisfied
    case requirement

    /// Compatibility issue between inputs
    case compatibility
}

// MARK: - ValidationResult Extensions

extension ValidationResult: CustomStringConvertible {
    public var description: String {
        switch self {
        case .valid:
            return "Valid"
        case .invalid(let reasons):
            let errorList = reasons.map { "  - \($0.message)" }.joined(separator: "\n")
            return "Invalid:\n\(errorList)"
        }
    }
}

// MARK: - Convenience Factory Methods

extension ValidationError {
    /// Creates an error for missing capabilities.
    ///
    /// - Parameters:
    ///   - capabilities: Description of missing capabilities
    ///   - inputIndex: Optional index of the input with missing capabilities
    /// - Returns: A validation error configured for missing capabilities
    public static func missingCapabilities(
        _ capabilities: String,
        inputIndex: Int? = nil
    ) -> ValidationError {
        let indexInfo = inputIndex.map { " (input \($0))" } ?? ""
        return ValidationError(
            message: "Missing required capabilities\(indexInfo): \(capabilities)",
            suggestion: "Provide a document with the required capabilities or convert the input",
            category: .capability
        )
    }

    /// Creates an error for too few inputs.
    ///
    /// - Parameters:
    ///   - expected: Minimum number of inputs required
    ///   - actual: Actual number of inputs provided
    /// - Returns: A validation error for insufficient inputs
    public static func tooFewInputs(expected: Int, actual: Int) -> ValidationError {
        ValidationError(
            message: "Too few inputs: expected at least \(expected), got \(actual)",
            suggestion: "Add more input documents to meet the minimum requirement",
            category: .count
        )
    }

    /// Creates an error for too many inputs.
    ///
    /// - Parameters:
    ///   - expected: Maximum number of inputs allowed
    ///   - actual: Actual number of inputs provided
    /// - Returns: A validation error for excess inputs
    public static func tooManyInputs(expected: Int, actual: Int) -> ValidationError {
        ValidationError(
            message: "Too many inputs: expected at most \(expected), got \(actual)",
            suggestion: "Remove some input documents to meet the maximum limit",
            category: .count
        )
    }

    /// Creates an error for format preference not met.
    ///
    /// - Parameters:
    ///   - preferred: The preferred format identifier
    ///   - actual: The actual format identifier
    /// - Returns: A validation error for format mismatch
    public static func formatMismatch(preferred: String, actual: String) -> ValidationError {
        ValidationError(
            message: "Format preference not met: expected \(preferred), got \(actual)",
            suggestion: "Convert the input to \(preferred) format for optimal results",
            category: .format
        )
    }
}
