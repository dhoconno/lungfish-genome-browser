// SAMParserTests.swift - Tests for SAM text parser
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishIO
@testable import LungfishCore

// MARK: - SAMParser Tests

final class SAMParserTests: XCTestCase {

    // MARK: - Test Data

    private let sampleSAMLine = "read1\t99\tchr1\t100\t60\t75M\t=\t300\t275\tACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACG\t*\tRG:Z:sample1\tMD:Z:75"

    private let reverseSAMLine = "read2\t147\tchr1\t300\t40\t50M2I48M\t=\t100\t-275\tACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGT\t*"

    private let unmappedSAMLine = "unmapped\t4\t*\t0\t0\t*\t*\t0\t0\tACGT\t*"

    private let headerText = """
    @HD\tVN:1.6\tSO:coordinate
    @SQ\tSN:chr1\tLN:248956422
    @RG\tID:RG1\tSM:SampleA\tPL:ILLUMINA\tLB:lib1\tPU:flowcell:1:ATCACG
    @RG\tID:RG2\tSM:SampleB\tPL:ONT\tCN:WellcomeCenter
    """

    // MARK: - Parse Single Line

    func testParseSingleLine() {
        let read = SAMParser.parseLine(sampleSAMLine)
        XCTAssertNotNil(read)
        XCTAssertEqual(read?.name, "read1")
        XCTAssertEqual(read?.flag, 99)
        XCTAssertEqual(read?.chromosome, "chr1")
        XCTAssertEqual(read?.position, 99) // 1-based 100 → 0-based 99
        XCTAssertEqual(read?.mapq, 60)
        XCTAssertEqual(read?.cigar.count, 1)
        XCTAssertEqual(read?.cigar[0].op, .match)
        XCTAssertEqual(read?.cigar[0].length, 75)
        XCTAssertEqual(read?.mateChromosome, "chr1") // "=" means same
        XCTAssertEqual(read?.matePosition, 299) // 1-based 300 → 0-based 299
        XCTAssertEqual(read?.insertSize, 275)
        XCTAssertEqual(read?.readGroup, "sample1")
        XCTAssertEqual(read?.mdTag, "75")
    }

    func testParseReverseRead() {
        let read = SAMParser.parseLine(reverseSAMLine)
        XCTAssertNotNil(read)
        XCTAssertEqual(read?.name, "read2")
        XCTAssertTrue(read?.isReverse ?? false)
        XCTAssertTrue(read?.isPaired ?? false)
        XCTAssertTrue(read?.isSecondInPair ?? false)
        XCTAssertEqual(read?.cigar.count, 3) // 50M2I48M
        XCTAssertNil(read?.readGroup)
    }

    func testSkipUnmappedReads() {
        let read = SAMParser.parseLine(unmappedSAMLine)
        XCTAssertNil(read, "Unmapped reads should be skipped")
    }

    func testSkipHeaderLines() {
        let reads = SAMParser.parse("@HD\tVN:1.6\n\(sampleSAMLine)")
        XCTAssertEqual(reads.count, 1)
        XCTAssertEqual(reads[0].name, "read1")
    }

    func testParseMultipleReads() {
        let samText = "\(sampleSAMLine)\n\(reverseSAMLine)"
        let reads = SAMParser.parse(samText)
        XCTAssertEqual(reads.count, 2)
    }

    func testMaxReadsLimit() {
        // Create 10 identical reads
        let lines = (0..<10).map { _ in sampleSAMLine }.joined(separator: "\n")
        let reads = SAMParser.parse(lines, maxReads: 5)
        XCTAssertEqual(reads.count, 5)
    }

    func testParseInvalidLine() {
        let read = SAMParser.parseLine("not\ta\tvalid\tline")
        XCTAssertNil(read)
    }

    func testParseEmptyInput() {
        let reads = SAMParser.parse("")
        XCTAssertTrue(reads.isEmpty)
    }

    // MARK: - Read Group Parsing

    func testParseReadGroups() {
        let groups = SAMParser.parseReadGroups(from: headerText)
        XCTAssertEqual(groups.count, 2)

        XCTAssertEqual(groups[0].id, "RG1")
        XCTAssertEqual(groups[0].sample, "SampleA")
        XCTAssertEqual(groups[0].platform, "ILLUMINA")
        XCTAssertEqual(groups[0].library, "lib1")
        XCTAssertEqual(groups[0].platformUnit, "flowcell:1:ATCACG")

        XCTAssertEqual(groups[1].id, "RG2")
        XCTAssertEqual(groups[1].sample, "SampleB")
        XCTAssertEqual(groups[1].platform, "ONT")
        XCTAssertEqual(groups[1].center, "WellcomeCenter")
        XCTAssertNil(groups[1].library)
    }

    func testParseReadGroupsEmptyHeader() {
        let groups = SAMParser.parseReadGroups(from: "@HD\tVN:1.6")
        XCTAssertTrue(groups.isEmpty)
    }

    // MARK: - Position Conversion

    func testPositionIsZeroBased() {
        // SAM uses 1-based; parser should convert to 0-based
        let read = SAMParser.parseLine("r\t0\tchr1\t1\t60\t10M\t*\t0\t0\tACGTACGTAC\t*")
        XCTAssertEqual(read?.position, 0, "SAM POS 1 should become 0-based position 0")
    }

    func testMatePositionIsZeroBased() {
        let read = SAMParser.parseLine("r\t99\tchr1\t100\t60\t10M\t=\t200\t110\tACGTACGTAC\t*")
        XCTAssertEqual(read?.matePosition, 199, "SAM PNEXT 200 should become 0-based 199")
    }

    // MARK: - Quality Parsing

    func testQualityParsing() {
        let qualLine = "r\t0\tchr1\t100\t60\t4M\t*\t0\t0\tACGT\tIIII"
        let read = SAMParser.parseLine(qualLine)
        XCTAssertNotNil(read)
        // 'I' is ASCII 73, Phred+33 = 73-33 = 40
        XCTAssertEqual(read?.qualities, [40, 40, 40, 40])
    }

    func testStarQuality() {
        let read = SAMParser.parseLine("r\t0\tchr1\t100\t60\t4M\t*\t0\t0\tACGT\t*")
        XCTAssertNotNil(read)
        XCTAssertTrue(read?.qualities.isEmpty ?? false)
    }
}
