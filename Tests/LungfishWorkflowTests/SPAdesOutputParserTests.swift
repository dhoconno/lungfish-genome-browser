// SPAdesOutputParserTests.swift - Tests for SPAdes log parsing
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishWorkflow

final class SPAdesOutputParserTests: XCTestCase {

    let parser = SPAdesOutputParser()

    // MARK: - Stage Detection

    func testParsesErrorCorrectionStage() {
        let progress = parser.parseLine("== Running read error correction ==")
        XCTAssertNotNil(progress)
        XCTAssertEqual(progress?.stage, .errorCorrection)
        XCTAssertEqual(progress?.fraction, 0.10)
    }

    func testParsesAssemblerStage() {
        let progress = parser.parseLine("== Running assembler ==")
        XCTAssertNotNil(progress)
        XCTAssertEqual(progress?.stage, .assembling)
        XCTAssertEqual(progress?.fraction, 0.30)
    }

    func testParsesKmerIteration() {
        let progress = parser.parseLine("== K21 ==")
        XCTAssertNotNil(progress)
        XCTAssertEqual(progress?.stage, .kmerIteration)
        XCTAssertEqual(progress?.kmerSize, 21)
        XCTAssertNotNil(progress?.fraction)
        XCTAssertEqual(progress!.fraction!, 0.30, accuracy: 0.01)  // First k-mer
    }

    func testParsesLaterKmerIteration() {
        let progress = parser.parseLine("== K77 ==")
        XCTAssertNotNil(progress)
        XCTAssertEqual(progress?.stage, .kmerIteration)
        XCTAssertEqual(progress?.kmerSize, 77)
        XCTAssertNotNil(progress?.fraction)
    }

    func testParsesCustomKmers() {
        let customParser = SPAdesOutputParser(expectedKmers: [21, 33, 55])

        let k21 = customParser.parseLine("== K21 ==")
        XCTAssertEqual(k21!.fraction!, 0.30, accuracy: 0.01)

        let k33 = customParser.parseLine("== K33 ==")
        XCTAssertEqual(k33!.fraction!, 0.50, accuracy: 0.01)

        let k55 = customParser.parseLine("== K55 ==")
        XCTAssertEqual(k55!.fraction!, 0.70, accuracy: 0.01)
    }

    func testParsesMismatchCorrection() {
        let progress = parser.parseLine("== Mismatch correction ==")
        XCTAssertNotNil(progress)
        XCTAssertEqual(progress?.stage, .mismatchCorrection)
        XCTAssertEqual(progress?.fraction, 0.75)
    }

    func testParsesScaffolding() {
        let progress = parser.parseLine("== Scaffolding ==")
        XCTAssertNotNil(progress)
        XCTAssertEqual(progress?.stage, .scaffolding)
        XCTAssertEqual(progress?.fraction, 0.85)
    }

    func testParsesWritingOutput() {
        let progress = parser.parseLine("== Writing output ==")
        XCTAssertNotNil(progress)
        XCTAssertEqual(progress?.stage, .writingOutput)
        XCTAssertEqual(progress?.fraction, 0.90)
    }

    func testParsesPipelineFinished() {
        let progress = parser.parseLine("== SPAdes pipeline finished ==")
        XCTAssertNotNil(progress)
        XCTAssertEqual(progress?.stage, .finished)
        XCTAssertEqual(progress?.fraction, 0.95)
    }

    func testReturnsNilForNonStageLines() {
        XCTAssertNil(parser.parseLine("Processing reads..."))
        XCTAssertNil(parser.parseLine(""))
        XCTAssertNil(parser.parseLine("  INFO some log message"))
    }

    // MARK: - Error Detection

    func testDetectsOutOfMemory() {
        let error = parser.detectError("FATAL: not enough memory for this assembly")
        XCTAssertNotNil(error)
        if case .outOfMemory = error! {
            // OK
        } else {
            XCTFail("Expected outOfMemory, got \(error!)")
        }
    }

    func testDetectsBadAlloc() {
        let error = parser.detectError("terminate called after throwing an instance of 'std::bad_alloc'")
        XCTAssertNotNil(error)
        if case .outOfMemory = error! {
            // OK
        } else {
            XCTFail("Expected outOfMemory, got \(error!)")
        }
    }

    func testDetectsDiskFull() {
        let error = parser.detectError("OSError: [Errno 28] No space left on device")
        XCTAssertNotNil(error)
        if case .diskFull = error! {
            // OK
        } else {
            XCTFail("Expected diskFull, got \(error!)")
        }
    }

    func testDetectsInternalError() {
        let error = parser.detectError("ERROR! some internal error occurred")
        XCTAssertNotNil(error)
    }

    func testNoErrorForNormalLines() {
        XCTAssertNil(parser.detectError("Processing reads..."))
        XCTAssertNil(parser.detectError("== K21 =="))
        XCTAssertNil(parser.detectError(""))
    }

    // MARK: - Version Parsing

    func testParsesVersionString() {
        XCTAssertEqual(
            SPAdesOutputParser.parseVersion("SPAdes genome assembler v4.0.0"),
            "4.0.0"
        )
    }

    func testParsesShortVersionString() {
        XCTAssertEqual(SPAdesOutputParser.parseVersion("v4.0.0"), "4.0.0")
    }

    func testParsesVersionWithoutV() {
        XCTAssertEqual(SPAdesOutputParser.parseVersion("4.0.0"), "4.0.0")
    }

    func testVersionReturnsNilForGarbage() {
        XCTAssertNil(SPAdesOutputParser.parseVersion("no version here"))
    }

    // MARK: - Progress Monotonicity

    func testProgressIsMonotonicallyIncreasing() {
        let lines = [
            "== Running read error correction ==",
            "== Running assembler ==",
            "== K21 ==",
            "== K33 ==",
            "== K55 ==",
            "== K77 ==",
            "== Mismatch correction ==",
            "== Scaffolding ==",
            "== Writing output ==",
            "== SPAdes pipeline finished ==",
        ]

        var lastFraction = -1.0
        for line in lines {
            if let progress = parser.parseLine(line), let fraction = progress.fraction {
                XCTAssertGreaterThanOrEqual(
                    fraction, lastFraction,
                    "Progress should increase: \(line) gave \(fraction) but previous was \(lastFraction)"
                )
                lastFraction = fraction
            }
        }
    }
}
