// AIProviderHelpers.swift - Shared helpers for AI provider implementations
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation

// MARK: - JSONValue / Any Conversion

/// Converts a ``JSONValue`` to its untyped `Any` equivalent for use
/// with `JSONSerialization`.
///
/// - Parameter value: The strongly-typed JSON value to convert.
/// - Returns: An `Any` suitable for inclusion in a `JSONSerialization`-compatible dictionary.
func jsonValueToAny(_ value: JSONValue) -> Any {
    switch value {
    case .string(let s): return s
    case .number(let d): return d
    case .integer(let i): return i
    case .bool(let b): return b
    case .null: return NSNull()
    case .array(let a): return a.map { jsonValueToAny($0) }
    case .object(let o): return o.mapValues { jsonValueToAny($0) }
    }
}

/// Converts an untyped `Any` (from `JSONSerialization`) back to a
/// strongly-typed ``JSONValue``.
///
/// Unknown types are coerced to their `String` description.
///
/// - Parameter value: The untyped value to convert.
/// - Returns: A ``JSONValue`` representation.
func anyToJSONValue(_ value: Any) -> JSONValue {
    switch value {
    case let s as String: return .string(s)
    case let i as Int: return .integer(i)
    case let d as Double: return .number(d)
    case let b as Bool: return .bool(b)
    case is NSNull: return .null
    case let a as [Any]: return .array(a.map { anyToJSONValue($0) })
    case let d as [String: Any]: return .object(d.mapValues { anyToJSONValue($0) })
    default: return .string("\(value)")
    }
}

// MARK: - Argument Encoding

/// Encodes a dictionary of ``JSONValue`` entries into a plain `[String: Any]`
/// dictionary suitable for `JSONSerialization`.
///
/// - Parameter arguments: The tool-call arguments to encode.
/// - Returns: An untyped dictionary ready for JSON serialization.
func encodeArguments(_ arguments: [String: JSONValue]) -> [String: Any] {
    var result: [String: Any] = [:]
    for (key, value) in arguments {
        result[key] = jsonValueToAny(value)
    }
    return result
}

// MARK: - Error Parsing

/// Attempts to extract a human-readable error message from an API error
/// response body.
///
/// Looks for the common `{ "error": { "message": "..." } }` structure used
/// by Anthropic, OpenAI, and Google Gemini APIs. Falls back to the raw
/// UTF-8 body text if parsing fails.
///
/// - Parameter data: The raw HTTP response body.
/// - Returns: The extracted error message, or `nil` if the data cannot be decoded.
func parseErrorMessage(_ data: Data) -> String? {
    guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
          let error = json["error"] as? [String: Any],
          let message = error["message"] as? String else {
        return String(data: data, encoding: .utf8)
    }
    return message
}
