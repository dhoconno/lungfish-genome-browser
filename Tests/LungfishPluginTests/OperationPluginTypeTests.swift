// OperationPluginTypeTests.swift - Tests for operation plugin data types
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishPlugin

// MARK: - OperationInput Tests

final class OperationInputTests: XCTestCase {

    func testRegionToTransformWholeSequence() {
        let input = OperationInput(sequence: "ATCGATCG", alphabet: .dna)
        XCTAssertEqual(input.regionToTransform, "ATCGATCG")
    }

    func testRegionToTransformWithSelection() {
        let input = OperationInput(
            sequence: "ATCGATCG",
            alphabet: .dna,
            selection: 2..<6
        )
        XCTAssertEqual(input.regionToTransform, "CGAT")
    }

    func testDefaultValues() {
        let input = OperationInput(sequence: "ATCG")
        XCTAssertEqual(input.sequenceName, "Sequence")
        XCTAssertEqual(input.alphabet, .dna)
        XCTAssertNil(input.selection)
    }
}

// MARK: - OperationOptions Tests

final class OperationOptionsTests: XCTestCase {

    func testEmptyOptions() {
        let options = OperationOptions()
        XCTAssertNil(options["anything"])
    }

    func testIntegerOption() {
        var options = OperationOptions()
        options["count"] = .integer(42)
        XCTAssertEqual(options.integer(for: "count"), 42)
    }

    func testIntegerOptionDefault() {
        let options = OperationOptions()
        XCTAssertEqual(options.integer(for: "missing", default: 99), 99)
    }

    func testDoubleOption() {
        var options = OperationOptions()
        options["threshold"] = .double(0.75)
        XCTAssertEqual(options.double(for: "threshold"), 0.75, accuracy: 0.001)
    }

    func testStringOption() {
        var options = OperationOptions()
        options["mode"] = .string("fast")
        XCTAssertEqual(options.string(for: "mode"), "fast")
    }

    func testStringOptionDefault() {
        let options = OperationOptions()
        XCTAssertEqual(options.string(for: "missing", default: "default"), "default")
    }

    func testBoolOption() {
        var options = OperationOptions()
        options["flag"] = .bool(true)
        XCTAssertTrue(options.bool(for: "flag"))
    }

    func testBoolOptionDefault() {
        let options = OperationOptions()
        XCTAssertFalse(options.bool(for: "missing"))
    }

    func testInitWithDictionary() {
        let options = OperationOptions([
            "frame": .string("+1"),
            "trim": .bool(true),
        ])
        XCTAssertEqual(options.string(for: "frame"), "+1")
        XCTAssertTrue(options.bool(for: "trim"))
    }

    func testOverwriteOption() {
        var options = OperationOptions()
        options["key"] = .integer(1)
        XCTAssertEqual(options.integer(for: "key"), 1)
        options["key"] = .integer(2)
        XCTAssertEqual(options.integer(for: "key"), 2)
    }
}

// MARK: - OperationResult Tests

final class OperationResultTests: XCTestCase {

    func testSuccessResult() {
        let result = OperationResult(sequence: "MAAA*")
        XCTAssertTrue(result.isSuccess)
        XCTAssertEqual(result.sequence, "MAAA*")
        XCTAssertNil(result.sequenceName)
        XCTAssertNil(result.alphabet)
        XCTAssertNil(result.errorMessage)
        XCTAssertTrue(result.annotations.isEmpty)
        XCTAssertTrue(result.metadata.isEmpty)
    }

    func testFailureResult() {
        let result = OperationResult.failure("Something went wrong")
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.sequence, "")
        XCTAssertEqual(result.errorMessage, "Something went wrong")
    }

    func testResultWithMetadata() {
        let result = OperationResult(
            sequence: "MAAA",
            sequenceName: "translated",
            alphabet: .protein,
            metadata: ["source_length": "12", "frame": "+1"]
        )
        XCTAssertEqual(result.sequenceName, "translated")
        XCTAssertEqual(result.alphabet, .protein)
        XCTAssertEqual(result.metadata["source_length"], "12")
        XCTAssertEqual(result.metadata["frame"], "+1")
    }

    func testResultWithAnnotations() {
        let annotations = [
            AnnotationResult(name: "Feature", type: "CDS", start: 0, end: 50)
        ]
        let result = OperationResult(sequence: "MAAA", annotations: annotations)
        XCTAssertEqual(result.annotations.count, 1)
    }
}

// MARK: - AnnotationInput Tests

final class AnnotationInputTests: XCTestCase {

    func testDefaultValues() {
        let input = AnnotationInput(sequence: "ATCG")
        XCTAssertEqual(input.sequenceName, "Sequence")
        XCTAssertEqual(input.alphabet, .dna)
        XCTAssertTrue(input.existingAnnotations.isEmpty)
    }

    func testWithExistingAnnotations() {
        let existing = [
            AnnotationResult(name: "Gene1", type: "gene", start: 0, end: 100)
        ]
        let input = AnnotationInput(
            sequence: "ATCG",
            existingAnnotations: existing
        )
        XCTAssertEqual(input.existingAnnotations.count, 1)
    }
}

// MARK: - AnnotationOptions Tests

final class AnnotationOptionsTests: XCTestCase {

    func testEmptyOptions() {
        let options = AnnotationOptions()
        XCTAssertNil(options["anything"])
    }

    func testIntegerOption() {
        var options = AnnotationOptions()
        options["minLength"] = .integer(100)
        XCTAssertEqual(options.integer(for: "minLength"), 100)
    }

    func testBoolOption() {
        var options = AnnotationOptions()
        options["circular"] = .bool(true)
        XCTAssertTrue(options.bool(for: "circular"))
    }

    func testStringOption() {
        var options = AnnotationOptions()
        options["type"] = .string("CDS")
        XCTAssertEqual(options.string(for: "type"), "CDS")
    }

    func testStringArrayOption() {
        var options = AnnotationOptions()
        options["enzymes"] = .stringArray(["EcoRI", "BamHI"])
        XCTAssertEqual(options.stringArray(for: "enzymes"), ["EcoRI", "BamHI"])
    }

    func testDefaultValues() {
        let options = AnnotationOptions()
        XCTAssertEqual(options.integer(for: "x", default: 5), 5)
        XCTAssertFalse(options.bool(for: "x"))
        XCTAssertEqual(options.string(for: "x", default: "y"), "y")
        XCTAssertEqual(options.stringArray(for: "x"), [])
    }
}

// MARK: - Default Protocol Implementations Tests

final class ProtocolDefaultImplementationsTests: XCTestCase {

    struct StubAnalysis: SequenceAnalysisPlugin {
        let id = "test.analysis"
        let name = "Test"
        let version = "1.0.0"
        let description = "Test"
        let category = PluginCategory.sequenceAnalysis
        let capabilities: PluginCapabilities = .standardAnalysis

        func analyze(_ input: AnalysisInput) async throws -> AnalysisResult {
            AnalysisResult(summary: "done")
        }
    }

    struct StubOperation: SequenceOperationPlugin {
        let id = "test.operation"
        let name = "Test"
        let version = "1.0.0"
        let description = "Test"
        let category = PluginCategory.sequenceOperations
        let capabilities: PluginCapabilities = [.worksOnWholeSequence]

        func transform(_ input: OperationInput) async throws -> OperationResult {
            OperationResult(sequence: input.sequence)
        }
    }

    struct StubAnnotation: AnnotationGeneratorPlugin {
        let id = "test.annotation"
        let name = "Test"
        let version = "1.0.0"
        let description = "Test"
        let category = PluginCategory.annotationTools
        let capabilities: PluginCapabilities = .nucleotideAnnotator

        func generateAnnotations(_ input: AnnotationInput) async throws -> [AnnotationResult] {
            []
        }
    }

    func testAnalysisPluginDefaultOptions() {
        let plugin = StubAnalysis()
        let options = plugin.defaultOptions
        // Default options should be empty
        XCTAssertNil(options["anything"])
    }

    func testAnalysisPluginDefaultValidation() throws {
        let plugin = StubAnalysis()
        // Default validation should not throw
        XCTAssertNoThrow(try plugin.validateOptions(AnalysisOptions()))
    }

    func testOperationPluginDefaultOptions() {
        let plugin = StubOperation()
        let options = plugin.defaultOptions
        XCTAssertNil(options["anything"])
    }

    func testOperationPluginDefaultValidation() throws {
        let plugin = StubOperation()
        XCTAssertNoThrow(try plugin.validateOptions(OperationOptions()))
    }

    func testOperationPluginDefaultSupportsPreview() {
        let plugin = StubOperation()
        XCTAssertTrue(plugin.supportsPreview)
    }

    func testAnnotationPluginDefaultOptions() {
        let plugin = StubAnnotation()
        let options = plugin.defaultOptions
        XCTAssertNil(options["anything"])
    }

    func testAnnotationPluginDefaultValidation() throws {
        let plugin = StubAnnotation()
        XCTAssertNoThrow(try plugin.validateOptions(AnnotationOptions()))
    }
}
