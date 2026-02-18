// AlignedReadTests.swift - Tests for AlignedRead and CIGAROperation
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishCore

// MARK: - CIGAROperation Tests

final class CIGAROperationTests: XCTestCase {

    func testParseSimpleCIGAR() {
        let ops = CIGAROperation.parse("75M")
        XCTAssertNotNil(ops)
        XCTAssertEqual(ops?.count, 1)
        XCTAssertEqual(ops?.first?.op, .match)
        XCTAssertEqual(ops?.first?.length, 75)
    }

    func testParseComplexCIGAR() {
        let ops = CIGAROperation.parse("50M2I3D45M")
        XCTAssertNotNil(ops)
        XCTAssertEqual(ops?.count, 4)
        XCTAssertEqual(ops?[0].op, .match)
        XCTAssertEqual(ops?[0].length, 50)
        XCTAssertEqual(ops?[1].op, .insertion)
        XCTAssertEqual(ops?[1].length, 2)
        XCTAssertEqual(ops?[2].op, .deletion)
        XCTAssertEqual(ops?[2].length, 3)
        XCTAssertEqual(ops?[3].op, .match)
        XCTAssertEqual(ops?[3].length, 45)
    }

    func testParseSoftClipCIGAR() {
        let ops = CIGAROperation.parse("5S95M")
        XCTAssertNotNil(ops)
        XCTAssertEqual(ops?.count, 2)
        XCTAssertEqual(ops?[0].op, .softClip)
        XCTAssertEqual(ops?[0].length, 5)
    }

    func testParseStarCIGAR() {
        let ops = CIGAROperation.parse("*")
        XCTAssertNotNil(ops)
        XCTAssertTrue(ops?.isEmpty ?? false)
    }

    func testParseInvalidCIGAR() {
        XCTAssertNil(CIGAROperation.parse("abc"))
        XCTAssertNil(CIGAROperation.parse("50"))
        XCTAssertNil(CIGAROperation.parse("M50"))
    }

    func testParseAllOperationTypes() {
        let ops = CIGAROperation.parse("10M5I3D2N4S1H1P2=3X")
        XCTAssertNotNil(ops)
        XCTAssertEqual(ops?.count, 9)
        XCTAssertEqual(ops?[0].op, .match)
        XCTAssertEqual(ops?[1].op, .insertion)
        XCTAssertEqual(ops?[2].op, .deletion)
        XCTAssertEqual(ops?[3].op, .skip)
        XCTAssertEqual(ops?[4].op, .softClip)
        XCTAssertEqual(ops?[5].op, .hardClip)
        XCTAssertEqual(ops?[6].op, .padding)
        XCTAssertEqual(ops?[7].op, .seqMatch)
        XCTAssertEqual(ops?[8].op, .seqMismatch)
    }

    func testConsumesReference() {
        let matchOp = CIGAROperation(op: .match, length: 10)
        XCTAssertTrue(matchOp.consumesReference)

        let insertOp = CIGAROperation(op: .insertion, length: 5)
        XCTAssertFalse(insertOp.consumesReference)

        let deletionOp = CIGAROperation(op: .deletion, length: 3)
        XCTAssertTrue(deletionOp.consumesReference)

        let softClipOp = CIGAROperation(op: .softClip, length: 5)
        XCTAssertFalse(softClipOp.consumesReference)
    }

    func testConsumesQuery() {
        let matchOp = CIGAROperation(op: .match, length: 10)
        XCTAssertTrue(matchOp.consumesQuery)

        let insertOp = CIGAROperation(op: .insertion, length: 5)
        XCTAssertTrue(insertOp.consumesQuery)

        let deletionOp = CIGAROperation(op: .deletion, length: 3)
        XCTAssertFalse(deletionOp.consumesQuery)
    }
}

// MARK: - AlignedRead Tests

final class AlignedReadTests: XCTestCase {

    private func makeRead(
        flag: UInt16 = 0,
        position: Int = 100,
        cigar: String = "100M",
        sequence: String = String(repeating: "A", count: 100),
        mapq: UInt8 = 60
    ) -> AlignedRead {
        AlignedRead(
            name: "read1",
            flag: flag,
            chromosome: "chr1",
            position: position,
            mapq: mapq,
            cigar: CIGAROperation.parse(cigar)!,
            sequence: sequence,
            qualities: Array(repeating: UInt8(30), count: sequence.count)
        )
    }

    func testAlignmentEnd() {
        let read = makeRead(position: 100, cigar: "75M")
        XCTAssertEqual(read.alignmentEnd, 175)
    }

    func testAlignmentEndWithDeletion() {
        let read = makeRead(position: 100, cigar: "50M5D50M")
        XCTAssertEqual(read.alignmentEnd, 205) // 50 + 5 + 50 = 105 ref bases
    }

    func testAlignmentEndWithInsertion() {
        // Insertion does not consume reference
        let read = makeRead(position: 100, cigar: "50M5I45M", sequence: String(repeating: "A", count: 100))
        XCTAssertEqual(read.alignmentEnd, 195) // 50 + 45 = 95 ref bases
    }

    func testReferenceLength() {
        let read = makeRead(cigar: "50M5I3D42M")
        XCTAssertEqual(read.referenceLength, 95) // 50 + 3 + 42 = 95
    }

    func testQueryLength() {
        let read = makeRead(cigar: "50M5I45M", sequence: String(repeating: "A", count: 100))
        XCTAssertEqual(read.queryLength, 100) // 50 + 5 + 45 = 100
    }

    func testFlagProperties() {
        // Forward read, first in pair, properly paired
        let forward = makeRead(flag: 0x3 | 0x40) // paired + proper pair + first
        XCTAssertTrue(forward.isPaired)
        XCTAssertTrue(forward.isProperPair)
        XCTAssertTrue(forward.isFirstInPair)
        XCTAssertFalse(forward.isReverse)
        XCTAssertFalse(forward.isDuplicate)
        XCTAssertEqual(forward.strand, .forward)

        // Reverse read, duplicate
        let reverse = makeRead(flag: 0x10 | 0x400)
        XCTAssertTrue(reverse.isReverse)
        XCTAssertTrue(reverse.isDuplicate)
        XCTAssertEqual(reverse.strand, .reverse)

        // Secondary and supplementary
        let secondary = makeRead(flag: 0x100)
        XCTAssertTrue(secondary.isSecondary)

        let supplementary = makeRead(flag: 0x800)
        XCTAssertTrue(supplementary.isSupplementary)
    }

    func testCigarString() {
        let read = makeRead(cigar: "50M2I3D45M")
        XCTAssertEqual(read.cigarString, "50M2I3D45M")
    }

    func testCigarStringEmpty() {
        let read = AlignedRead(
            name: "unmapped", flag: 4, chromosome: "*", position: 0,
            mapq: 0, cigar: [], sequence: "ACGT", qualities: [30, 30, 30, 30]
        )
        XCTAssertEqual(read.cigarString, "*")
    }

    func testForEachAlignedBase() {
        let read = makeRead(
            position: 100,
            cigar: "5M",
            sequence: "ACGTG"
        )

        var bases: [(Character, Int)] = []
        read.forEachAlignedBase { base, refPos, _ in
            bases.append((base, refPos))
        }

        XCTAssertEqual(bases.count, 5)
        XCTAssertEqual(bases[0].0, "A")
        XCTAssertEqual(bases[0].1, 100)
        XCTAssertEqual(bases[4].0, "G")
        XCTAssertEqual(bases[4].1, 104)
    }

    func testInsertions() {
        let read = makeRead(
            position: 100,
            cigar: "5M3I5M",
            sequence: "ACGTGAAACGTGG"
        )

        let insertions = read.insertions
        XCTAssertEqual(insertions.count, 1)
        XCTAssertEqual(insertions[0].position, 105)
        XCTAssertEqual(insertions[0].bases, "AAA")
    }

    func testMultipleInsertions() {
        let read = makeRead(
            position: 100,
            cigar: "3M2I3M1I2M",
            sequence: "ACGTTACGTCA"
        )

        let insertions = read.insertions
        XCTAssertEqual(insertions.count, 2)
        XCTAssertEqual(insertions[0].position, 103)
        XCTAssertEqual(insertions[0].bases, "TT")
        XCTAssertEqual(insertions[1].position, 106)
        XCTAssertEqual(insertions[1].bases, "T")
    }

    func testSendable() {
        let read = makeRead()
        let sendableCheck: @Sendable () -> String = { read.name }
        XCTAssertEqual(sendableCheck(), "read1")
    }
}
