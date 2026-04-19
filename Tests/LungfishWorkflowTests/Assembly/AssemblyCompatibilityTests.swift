// AssemblyCompatibilityTests.swift - Tests for the v1 assembly compatibility matrix
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishWorkflow

final class AssemblyCompatibilityTests: XCTestCase {
    func testIlluminaShortReadsEnableOnlySPAdesMEGAHITAndSKESA() {
        XCTAssertEqual(
            Set(AssemblyCompatibility.supportedTools(for: .illuminaShortReads)),
            [.spades, .megahit, .skesa]
        )
        XCTAssertTrue(AssemblyCompatibility.isSupported(tool: .spades, for: .illuminaShortReads))
        XCTAssertFalse(AssemblyCompatibility.isSupported(tool: .flye, for: .illuminaShortReads))
        XCTAssertFalse(AssemblyCompatibility.isSupported(tool: .hifiasm, for: .illuminaShortReads))
    }

    func testONTReadsEnableOnlyFlye() {
        XCTAssertEqual(
            Set(AssemblyCompatibility.supportedTools(for: .ontReads)),
            [.flye]
        )
        XCTAssertTrue(AssemblyCompatibility.isSupported(tool: .flye, for: .ontReads))
        XCTAssertFalse(AssemblyCompatibility.isSupported(tool: .spades, for: .ontReads))
        XCTAssertFalse(AssemblyCompatibility.isSupported(tool: .megahit, for: .ontReads))
        XCTAssertFalse(AssemblyCompatibility.isSupported(tool: .skesa, for: .ontReads))
        XCTAssertFalse(AssemblyCompatibility.isSupported(tool: .hifiasm, for: .ontReads))
    }

    func testPacBioHiFiEnablesOnlyHifiasm() {
        XCTAssertEqual(
            Set(AssemblyCompatibility.supportedTools(for: .pacBioHiFi)),
            [.hifiasm]
        )
        XCTAssertTrue(AssemblyCompatibility.isSupported(tool: .hifiasm, for: .pacBioHiFi))
        XCTAssertFalse(AssemblyCompatibility.isSupported(tool: .spades, for: .pacBioHiFi))
        XCTAssertFalse(AssemblyCompatibility.isSupported(tool: .flye, for: .pacBioHiFi))
        XCTAssertFalse(AssemblyCompatibility.isSupported(tool: .megahit, for: .pacBioHiFi))
        XCTAssertFalse(AssemblyCompatibility.isSupported(tool: .skesa, for: .pacBioHiFi))
    }

    func testMixedDetectedReadTypesAreBlockedInV1() {
        let evaluation = AssemblyCompatibility.evaluate(detectedReadTypes: [.illuminaShortReads, .ontReads])

        XCTAssertTrue(evaluation.isBlocked)
        XCTAssertEqual(evaluation.blockingMessage, AssemblyCompatibility.hybridAssemblyUnsupportedMessage)
        XCTAssertEqual(
            evaluation.blockingMessage,
            "Hybrid assembly is not supported in v1. Select one read class per run."
        )
        XCTAssertEqual(evaluation.supportedTools, [])
    }

    func testMixedSinglePassSequenceStillBlocksHybridInput() {
        let singlePassSequence = IteratorSequence(
            AnyIterator([AssemblyReadType.ontReads, .illuminaShortReads].makeIterator())
        )

        let evaluation = AssemblyCompatibility.evaluate(detectedReadTypes: singlePassSequence)

        XCTAssertTrue(evaluation.isBlocked)
        XCTAssertEqual(
            evaluation.blockingMessage,
            "Hybrid assembly is not supported in v1. Select one read class per run."
        )
    }

    func testPacBioSubreadsDoNotAutoClassifyAsHiFi() throws {
        let fixtureURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("assembly-read-type-\(UUID().uuidString).fastq")
        defer { try? FileManager.default.removeItem(at: fixtureURL) }

        let fastq = """
        @m64001_190101_000000/123/subreads
        ACGT
        +
        !!!!
        """
        try Data(fastq.utf8).write(to: fixtureURL)

        XCTAssertNil(AssemblyReadType.detect(fromFASTQ: fixtureURL))
    }

    func testGenericPacBioZMWHeadersDoNotAutoClassifyAsHiFi() throws {
        let fixtureURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("assembly-read-type-\(UUID().uuidString).fastq")
        defer { try? FileManager.default.removeItem(at: fixtureURL) }

        let fastq = """
        @m64001_190101_000000/12345/0_1000 zmw=12345
        ACGT
        +
        !!!!
        """
        try Data(fastq.utf8).write(to: fixtureURL)

        XCTAssertNil(AssemblyReadType.detect(fromFASTQ: fixtureURL))
    }

    func testPacBioCCSHeadersClassifyAsHiFi() throws {
        let fixtureURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("assembly-read-type-\(UUID().uuidString).fastq")
        defer { try? FileManager.default.removeItem(at: fixtureURL) }

        let fastq = """
        @m64001_190101_000000/123/ccs
        ACGT
        +
        !!!!
        """
        try Data(fastq.utf8).write(to: fixtureURL)

        XCTAssertEqual(AssemblyReadType.detect(fromFASTQ: fixtureURL), .pacBioHiFi)
    }

    func testWorkflowPlatformPacBioDoesNotAutoClassifyAsHiFi() {
        XCTAssertNil(AssemblyReadType.detect(fromWorkflowPlatform: .pacbio))
    }

    func testWorkflowPlatformsStillMapIlluminaAndONT() {
        XCTAssertEqual(AssemblyReadType.detect(fromWorkflowPlatform: .illumina), .illuminaShortReads)
        XCTAssertEqual(AssemblyReadType.detect(fromWorkflowPlatform: .ont), .ontReads)
    }

    func testGzippedIlluminaFixtureStillClassifiesAsShortReads() {
        let fixtureURL = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Fixtures/sarscov2/test_1.fastq.gz")

        XCTAssertEqual(AssemblyReadType.detect(fromFASTQ: fixtureURL), .illuminaShortReads)
    }
}
