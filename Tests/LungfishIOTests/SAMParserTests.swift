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

    // MARK: - Program Record Parsing

    func testParseProgramRecords() {
        let header = """
        @HD\tVN:1.6\tSO:coordinate
        @PG\tID:bwa\tPN:bwa\tVN:0.7.17-r1188\tCL:bwa mem -t 8 ref.fa reads.fq
        @PG\tID:samtools\tPN:samtools\tVN:1.19\tCL:samtools sort -o sorted.bam\tPP:bwa
        """
        let records = SAMParser.parseProgramRecords(from: header)
        XCTAssertEqual(records.count, 2)

        XCTAssertEqual(records[0].id, "bwa")
        XCTAssertEqual(records[0].name, "bwa")
        XCTAssertEqual(records[0].version, "0.7.17-r1188")
        XCTAssertEqual(records[0].commandLine, "bwa mem -t 8 ref.fa reads.fq")
        XCTAssertNil(records[0].previousProgram)

        XCTAssertEqual(records[1].id, "samtools")
        XCTAssertEqual(records[1].name, "samtools")
        XCTAssertEqual(records[1].version, "1.19")
        XCTAssertEqual(records[1].previousProgram, "bwa")
    }

    func testParseProgramRecordsEmpty() {
        let records = SAMParser.parseProgramRecords(from: "@HD\tVN:1.6")
        XCTAssertTrue(records.isEmpty)
    }

    func testParseProgramRecordsMinimal() {
        let header = "@PG\tID:tool1"
        let records = SAMParser.parseProgramRecords(from: header)
        XCTAssertEqual(records.count, 1)
        XCTAssertEqual(records[0].id, "tool1")
        XCTAssertNil(records[0].name)
        XCTAssertNil(records[0].version)
    }

    // MARK: - Header Record Parsing

    func testParseHeaderRecord() {
        let header = "@HD\tVN:1.6\tSO:coordinate\tGO:query"
        let hd = SAMParser.parseHeaderRecord(from: header)
        XCTAssertNotNil(hd)
        XCTAssertEqual(hd?.version, "1.6")
        XCTAssertEqual(hd?.sortOrder, "coordinate")
        XCTAssertEqual(hd?.groupOrder, "query")
    }

    func testParseHeaderRecordMinimal() {
        let header = "@HD\tVN:1.6"
        let hd = SAMParser.parseHeaderRecord(from: header)
        XCTAssertNotNil(hd)
        XCTAssertEqual(hd?.version, "1.6")
        XCTAssertNil(hd?.sortOrder)
        XCTAssertNil(hd?.groupOrder)
    }

    func testParseHeaderRecordMissing() {
        let header = "@SQ\tSN:chr1\tLN:1000"
        let hd = SAMParser.parseHeaderRecord(from: header)
        XCTAssertNil(hd)
    }

    // MARK: - Reference Sequence Count

    func testReferenceSequenceCount() {
        let header = """
        @HD\tVN:1.6
        @SQ\tSN:chr1\tLN:248956422
        @SQ\tSN:chr2\tLN:242193529
        @SQ\tSN:chrM\tLN:16569
        @RG\tID:RG1\tSM:Sample
        """
        XCTAssertEqual(SAMParser.referenceSequenceCount(from: header), 3)
    }

    func testReferenceSequenceCountEmpty() {
        XCTAssertEqual(SAMParser.referenceSequenceCount(from: "@HD\tVN:1.6"), 0)
    }

    // MARK: - Comment Parsing

    func testParseComments() {
        let header = """
        @HD\tVN:1.6
        @CO\tThis is a comment line
        @CO\tAnother comment
        @SQ\tSN:chr1\tLN:1000
        """
        let comments = SAMParser.parseComments(from: header)
        XCTAssertEqual(comments.count, 2)
        XCTAssertEqual(comments[0], "This is a comment line")
        XCTAssertEqual(comments[1], "Another comment")
    }

    func testParseCommentsEmpty() {
        XCTAssertTrue(SAMParser.parseComments(from: "@HD\tVN:1.6").isEmpty)
    }
}
