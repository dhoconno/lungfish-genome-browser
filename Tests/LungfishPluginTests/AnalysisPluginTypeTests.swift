// AnalysisPluginTypeTests.swift - Tests for analysis plugin data types
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishPlugin

// MARK: - AnalysisInput Tests

final class AnalysisInputTests: XCTestCase {

    func testRegionToAnalyzeWholeSequence() {
        let input = AnalysisInput(sequence: "ATCGATCG", alphabet: .dna)
        XCTAssertEqual(input.regionToAnalyze, "ATCGATCG")
    }

    func testRegionToAnalyzeWithSelection() {
        let input = AnalysisInput(
            sequence: "ATCGATCG",
            alphabet: .dna,
            selection: 2..<6
        )
        XCTAssertEqual(input.regionToAnalyze, "CGAT")
    }

    func testRegionStartWithoutSelection() {
        let input = AnalysisInput(sequence: "ATCG", alphabet: .dna)
        XCTAssertEqual(input.regionStart, 0)
    }

    func testRegionStartWithSelection() {
        let input = AnalysisInput(sequence: "ATCGATCG", alphabet: .dna, selection: 3..<7)
        XCTAssertEqual(input.regionStart, 3)
    }

    func testRegionEndWithoutSelection() {
        let input = AnalysisInput(sequence: "ATCG", alphabet: .dna)
        XCTAssertEqual(input.regionEnd, 4)
    }

    func testRegionEndWithSelection() {
        let input = AnalysisInput(sequence: "ATCGATCG", alphabet: .dna, selection: 3..<7)
        XCTAssertEqual(input.regionEnd, 7)
    }

    func testDefaultValues() {
        let input = AnalysisInput(sequence: "ATCG")
        XCTAssertEqual(input.sequenceName, "Sequence")
        XCTAssertEqual(input.alphabet, .dna)
        XCTAssertNil(input.selection)
    }
}

// MARK: - AnalysisOptions Tests

final class AnalysisOptionsTests: XCTestCase {

    func testEmptyOptions() {
        let options = AnalysisOptions()
        XCTAssertNil(options["anything"])
    }

    func testIntegerOption() {
        var options = AnalysisOptions()
        options["count"] = .integer(42)
        XCTAssertEqual(options.integer(for: "count"), 42)
    }

    func testIntegerOptionDefault() {
        let options = AnalysisOptions()
        XCTAssertEqual(options.integer(for: "missing", default: 99), 99)
    }

    func testIntegerOptionTypeMismatch() {
        var options = AnalysisOptions()
        options["value"] = .string("not an int")
        XCTAssertEqual(options.integer(for: "value", default: 5), 5)
    }

    func testDoubleOption() {
        var options = AnalysisOptions()
        options["threshold"] = .double(0.95)
        XCTAssertEqual(options.double(for: "threshold"), 0.95, accuracy: 0.001)
    }

    func testDoubleOptionDefault() {
        let options = AnalysisOptions()
        XCTAssertEqual(options.double(for: "missing", default: 1.5), 1.5, accuracy: 0.001)
    }

    func testStringOption() {
        var options = AnalysisOptions()
        options["name"] = .string("test")
        XCTAssertEqual(options.string(for: "name"), "test")
    }

    func testStringOptionDefault() {
        let options = AnalysisOptions()
        XCTAssertEqual(options.string(for: "missing", default: "fallback"), "fallback")
    }

    func testBoolOption() {
        var options = AnalysisOptions()
        options["enabled"] = .bool(true)
        XCTAssertTrue(options.bool(for: "enabled"))
    }

    func testBoolOptionDefault() {
        let options = AnalysisOptions()
        XCTAssertFalse(options.bool(for: "missing"))
        XCTAssertTrue(options.bool(for: "missing", default: true))
    }

    func testStringArrayOption() {
        var options = AnalysisOptions()
        options["items"] = .stringArray(["a", "b", "c"])
        XCTAssertEqual(options.stringArray(for: "items"), ["a", "b", "c"])
    }

    func testStringArrayOptionDefault() {
        let options = AnalysisOptions()
        XCTAssertEqual(options.stringArray(for: "missing"), [])
        XCTAssertEqual(options.stringArray(for: "missing", default: ["x"]), ["x"])
    }

    func testInitWithDictionary() {
        let options = AnalysisOptions([
            "count": .integer(10),
            "name": .string("test"),
        ])
        XCTAssertEqual(options.integer(for: "count"), 10)
        XCTAssertEqual(options.string(for: "name"), "test")
    }
}

// MARK: - OptionValue Tests

final class OptionValueTests: XCTestCase {

    func testEquality() {
        XCTAssertEqual(OptionValue.integer(5), OptionValue.integer(5))
        XCTAssertNotEqual(OptionValue.integer(5), OptionValue.integer(6))
        XCTAssertNotEqual(OptionValue.integer(5), OptionValue.string("5"))
        XCTAssertEqual(OptionValue.bool(true), OptionValue.bool(true))
        XCTAssertEqual(OptionValue.double(1.5), OptionValue.double(1.5))
        XCTAssertEqual(OptionValue.string("abc"), OptionValue.string("abc"))
        XCTAssertEqual(OptionValue.stringArray(["a"]), OptionValue.stringArray(["a"]))
    }

    func testCodableRoundTrip() throws {
        let values: [OptionValue] = [
            .integer(42),
            .double(3.14),
            .string("hello"),
            .bool(true),
            .stringArray(["a", "b"]),
        ]
        for value in values {
            let encoded = try JSONEncoder().encode(value)
            let decoded = try JSONDecoder().decode(OptionValue.self, from: encoded)
            XCTAssertEqual(decoded, value)
        }
    }
}

// MARK: - AnalysisResult Tests

final class AnalysisResultTests: XCTestCase {

    func testSuccessResult() {
        let result = AnalysisResult(summary: "All good")
        XCTAssertTrue(result.isSuccess)
        XCTAssertEqual(result.summary, "All good")
        XCTAssertNil(result.errorMessage)
        XCTAssertTrue(result.sections.isEmpty)
        XCTAssertTrue(result.annotations.isEmpty)
        XCTAssertNil(result.exportData)
    }

    func testFailureResult() {
        let result = AnalysisResult.failure("Something went wrong")
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.summary, "Analysis failed")
        XCTAssertEqual(result.errorMessage, "Something went wrong")
    }

    func testResultWithSections() {
        let sections = [
            ResultSection.text("Title", "Some text"),
            ResultSection.keyValue("Stats", [("Key", "Value")]),
        ]
        let result = AnalysisResult(summary: "Done", sections: sections)
        XCTAssertEqual(result.sections.count, 2)
    }

    func testResultWithAnnotations() {
        let annotations = [
            AnnotationResult(name: "Feature1", type: "gene", start: 0, end: 100),
        ]
        let result = AnalysisResult(summary: "Found features", annotations: annotations)
        XCTAssertEqual(result.annotations.count, 1)
    }

    func testResultWithExportData() {
        let export = ExportData(format: .csv, content: "a,b,c")
        let result = AnalysisResult(summary: "Done", exportData: export)
        XCTAssertNotNil(result.exportData)
        XCTAssertEqual(result.exportData?.format, .csv)
    }
}

// MARK: - ResultSection Tests

final class ResultSectionTests: XCTestCase {

    func testTextSection() {
        let section = ResultSection.text("Title", "Content text")
        XCTAssertEqual(section.title, "Title")
        if case .text(let text) = section.content {
            XCTAssertEqual(text, "Content text")
        } else {
            XCTFail("Expected text content")
        }
    }

    func testKeyValueSection() {
        let pairs = [("Key1", "Val1"), ("Key2", "Val2")]
        let section = ResultSection.keyValue("Stats", pairs)
        XCTAssertEqual(section.title, "Stats")
        if case .keyValue(let kv) = section.content {
            XCTAssertEqual(kv.count, 2)
            XCTAssertEqual(kv[0].0, "Key1")
            XCTAssertEqual(kv[0].1, "Val1")
        } else {
            XCTFail("Expected keyValue content")
        }
    }

    func testTableSection() {
        let section = ResultSection.table(
            "Data",
            headers: ["Name", "Value"],
            rows: [["A", "1"], ["B", "2"]]
        )
        XCTAssertEqual(section.title, "Data")
        if case .table(let headers, let rows) = section.content {
            XCTAssertEqual(headers, ["Name", "Value"])
            XCTAssertEqual(rows.count, 2)
        } else {
            XCTFail("Expected table content")
        }
    }

    func testSectionHasUniqueId() {
        let a = ResultSection.text("A", "text a")
        let b = ResultSection.text("B", "text b")
        XCTAssertNotEqual(a.id, b.id)
    }
}

// MARK: - AnnotationResult Tests

final class AnnotationResultTests: XCTestCase {

    func testBasicAnnotation() {
        let ann = AnnotationResult(name: "Gene1", type: "gene", start: 100, end: 500)
        XCTAssertEqual(ann.name, "Gene1")
        XCTAssertEqual(ann.type, "gene")
        XCTAssertEqual(ann.start, 100)
        XCTAssertEqual(ann.end, 500)
        XCTAssertEqual(ann.strand, .forward)
        XCTAssertTrue(ann.qualifiers.isEmpty)
    }

    func testAnnotationWithStrandAndQualifiers() {
        let ann = AnnotationResult(
            name: "tRNA",
            type: "tRNA",
            start: 200,
            end: 275,
            strand: .reverse,
            qualifiers: ["product": "tRNA-Leu"]
        )
        XCTAssertEqual(ann.strand, .reverse)
        XCTAssertEqual(ann.qualifiers["product"], "tRNA-Leu")
    }

    func testAnnotationHasUniqueId() {
        let a = AnnotationResult(name: "A", type: "gene", start: 0, end: 10)
        let b = AnnotationResult(name: "A", type: "gene", start: 0, end: 10)
        XCTAssertNotEqual(a.id, b.id)
    }
}

// MARK: - ChartData Tests

final class ChartDataTests: XCTestCase {

    func testBarChart() {
        let chart = ChartData(type: .bar, labels: ["A", "B"], values: [1.0, 2.0], title: "Test")
        XCTAssertEqual(chart.labels, ["A", "B"])
        XCTAssertEqual(chart.values, [1.0, 2.0])
        XCTAssertEqual(chart.title, "Test")
    }

    func testDefaultTitle() {
        let chart = ChartData(type: .pie, labels: [], values: [])
        XCTAssertEqual(chart.title, "")
    }
}

// MARK: - ExportData Tests

final class ExportDataTests: XCTestCase {

    func testCSVExport() {
        let export = ExportData(format: .csv, content: "a,b\n1,2")
        XCTAssertEqual(export.format, .csv)
        XCTAssertEqual(export.content, "a,b\n1,2")
    }

    func testAllFormats() {
        let formats: [ExportData.ExportFormat] = [.csv, .tsv, .json, .gff3, .fasta]
        for format in formats {
            let export = ExportData(format: format, content: "data")
            XCTAssertEqual(export.format, format)
            XCTAssertEqual(export.format.rawValue.isEmpty, false)
        }
    }
}
