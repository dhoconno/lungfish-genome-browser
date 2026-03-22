// LungfishError.swift - Common error protocol for user-facing presentation
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation

/// Protocol for Lungfish errors that provide both technical and user-facing descriptions.
///
/// Conforming types supply a structured error presentation suitable for display
/// in alert sheets and log output. The protocol bridges to `LocalizedError` so
/// that the standard `localizedDescription` property returns the user-friendly
/// title automatically.
///
/// ## Conformance Example
///
/// ```swift
/// enum ImportError: LungfishError {
///     case unsupportedFormat(String)
///     case fileTooLarge(Int)
///
///     var userTitle: String {
///         switch self {
///         case .unsupportedFormat:
///             return "Unsupported File Format"
///         case .fileTooLarge:
///             return "File Too Large"
///         }
///     }
///
///     var userMessage: String {
///         switch self {
///         case .unsupportedFormat(let ext):
///             return "The file format \".\(ext)\" is not supported by Lungfish."
///         case .fileTooLarge(let bytes):
///             let mb = bytes / 1_048_576
///             return "The file is \(mb) MB, which exceeds the maximum supported size."
///         }
///     }
///
///     var recoverySuggestion: String? {
///         switch self {
///         case .unsupportedFormat:
///             return "Try converting the file to FASTA, GenBank, or another supported format."
///         case .fileTooLarge:
///             return "Split the file into smaller chunks or use indexed access."
///         }
///     }
/// }
/// ```
public protocol LungfishError: LocalizedError {
    /// A brief, user-friendly summary suitable for display as an alert title.
    var userTitle: String { get }

    /// A more detailed explanation suitable for display as alert informative text.
    var userMessage: String { get }

    /// An actionable recovery suggestion, or `nil` if no specific action is recommended.
    var recoverySuggestion: String? { get }
}

// MARK: - Default LocalizedError Bridging

extension LungfishError {
    /// Maps ``userTitle`` to the standard `LocalizedError.errorDescription`.
    public var errorDescription: String? { userTitle }

    /// Maps ``userMessage`` to the standard `LocalizedError.failureReason`.
    public var failureReason: String? { userMessage }
}

// MARK: - Presentation Helpers

extension LungfishError {
    /// Returns a multi-line string combining all user-facing fields, suitable for
    /// logging or text-based alert display.
    ///
    /// Format:
    /// ```
    /// Error: <userTitle>
    /// <userMessage>
    /// Suggestion: <recoverySuggestion>   (if present)
    /// ```
    public var formattedDescription: String {
        var result = "Error: \(userTitle)\n\(userMessage)"
        if let suggestion = recoverySuggestion {
            result += "\nSuggestion: \(suggestion)"
        }
        return result
    }
}
