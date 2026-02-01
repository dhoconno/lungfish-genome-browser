// SequenceTests.swift - Tests for Sequence model
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishCore

final class SequenceTests: XCTestCase {

    // MARK: - Creation Tests

    func testCreateDNASequence() throws {
        let seq = try Sequence(name: "test", alphabet: .dna, bases: "ATCGATCG")
        XCTAssertEqual(seq.name, "test")
        XCTAssertEqual(seq.alphabet, .dna)
        XCTAssertEqual(seq.length, 8)
    }

    func testCreateRNASequence() throws {
        let seq = try Sequence(name: "rna_test", alphabet: .rna, bases: "AUCGAUCG")
        XCTAssertEqual(seq.alphabet, .rna)
        XCTAssertEqual(seq.length, 8)
    }

    func testCreateProteinSequence() throws {
        let seq = try Sequence(name: "protein", alphabet: .protein, bases: "MKTAYIAKQ")
        XCTAssertEqual(seq.alphabet, .protein)
        XCTAssertEqual(seq.length, 9)
    }

    func testInvalidCharacterThrows() {
        XCTAssertThrowsError(try Sequence(name: "bad", alphabet: .dna, bases: "ATCGX")) { error in
            guard case SequenceError.invalidCharacter(let char, _) = error else {
                XCTFail("Expected invalidCharacter error")
                return
            }
            XCTAssertEqual(char, "X")
        }
    }

    // MARK: - Subscript Tests

    func testSubscriptSingleBase() throws {
        let seq = try Sequence(name: "test", alphabet: .dna, bases: "ATCGATCG")
        XCTAssertEqual(seq[0], "A")
        XCTAssertEqual(seq[1], "T")
        XCTAssertEqual(seq[2], "C")
        XCTAssertEqual(seq[3], "G")
    }

    func testSubscriptRange() throws {
        let seq = try Sequence(name: "test", alphabet: .dna, bases: "ATCGATCGATCG")
        XCTAssertEqual(seq[0..<4], "ATCG")
        XCTAssertEqual(seq[4..<8], "ATCG")
    }

    func testAsString() throws {
        let bases = "ATCGATCGATCG"
        let seq = try Sequence(name: "test", alphabet: .dna, bases: bases)
        XCTAssertEqual(seq.asString(), bases)
    }

    // MARK: - 2-bit Encoding Tests

    func testTwoBitEncodingRoundTrip() throws {
        // Test all basic bases
        let bases = "AAACCCGGGTTT"
        let seq = try Sequence(name: "test", alphabet: .dna, bases: bases)
        XCTAssertEqual(seq.asString(), bases)
    }

    func testLargeSequence() throws {
        // Test with a larger sequence to ensure 2-bit encoding handles boundaries
        let bases = String(repeating: "ATCG", count: 1000) // 4000 bases
        let seq = try Sequence(name: "large", alphabet: .dna, bases: bases)
        XCTAssertEqual(seq.length, 4000)
        XCTAssertEqual(seq.asString(), bases)
    }

    func testAmbiguousBases() throws {
        let bases = "ATCNGATCN"
        let seq = try Sequence(name: "ambig", alphabet: .dna, bases: bases)
        XCTAssertEqual(seq.asString(), bases)
        XCTAssertEqual(seq[3], "N")
        XCTAssertEqual(seq[8], "N")
    }

    func testLowercaseBases() throws {
        let bases = "atcgatcg"
        let seq = try Sequence(name: "lower", alphabet: .dna, bases: bases)
        XCTAssertEqual(seq.length, 8)
        // Note: 2-bit encoding normalizes to uppercase for storage efficiency
        // but we preserve the original case through subscript access
    }

    // MARK: - Complement Tests

    func testComplement() throws {
        let seq = try Sequence(name: "test", alphabet: .dna, bases: "ATCG")
        let comp = seq.complement()
        XCTAssertNotNil(comp)
        XCTAssertEqual(comp?.asString(), "TAGC")
    }

    func testReverseComplement() throws {
        let seq = try Sequence(name: "test", alphabet: .dna, bases: "ATCG")
        let rc = seq.reverseComplement()
        XCTAssertNotNil(rc)
        XCTAssertEqual(rc?.asString(), "CGAT")
    }

    func testRNAComplement() throws {
        let seq = try Sequence(name: "rna", alphabet: .rna, bases: "AUCG")
        let comp = seq.complement()
        XCTAssertNotNil(comp)
        XCTAssertEqual(comp?.asString(), "UAGC")
    }

    func testProteinNoComplement() throws {
        let seq = try Sequence(name: "protein", alphabet: .protein, bases: "MKTAY")
        XCTAssertNil(seq.complement())
        XCTAssertNil(seq.reverseComplement())
    }

    // MARK: - Subsequence Tests

    func testSubsequence() throws {
        let seq = try Sequence(name: "test", alphabet: .dna, bases: "ATCGATCGATCG")
        let region = GenomicRegion(chromosome: "test", start: 4, end: 8)
        let subseq = seq.subsequence(region: region)
        XCTAssertEqual(subseq.length, 4)
        XCTAssertEqual(subseq.asString(), "ATCG")
    }
}

// MARK: - GenomicRegion Tests

final class GenomicRegionTests: XCTestCase {

    func testCreateRegion() {
        let region = GenomicRegion(chromosome: "chr1", start: 100, end: 200)
        XCTAssertEqual(region.chromosome, "chr1")
        XCTAssertEqual(region.start, 100)
        XCTAssertEqual(region.end, 200)
        XCTAssertEqual(region.length, 100)
    }

    func testContainsPosition() {
        let region = GenomicRegion(chromosome: "chr1", start: 100, end: 200)
        XCTAssertTrue(region.contains(position: 100))
        XCTAssertTrue(region.contains(position: 150))
        XCTAssertTrue(region.contains(position: 199))
        XCTAssertFalse(region.contains(position: 99))
        XCTAssertFalse(region.contains(position: 200))
    }

    func testOverlaps() {
        let region1 = GenomicRegion(chromosome: "chr1", start: 100, end: 200)
        let region2 = GenomicRegion(chromosome: "chr1", start: 150, end: 250)
        let region3 = GenomicRegion(chromosome: "chr1", start: 200, end: 300)
        let region4 = GenomicRegion(chromosome: "chr2", start: 100, end: 200)

        XCTAssertTrue(region1.overlaps(region2))
        XCTAssertFalse(region1.overlaps(region3))  // Adjacent, not overlapping
        XCTAssertFalse(region1.overlaps(region4))  // Different chromosome
    }

    func testIntersection() {
        let region1 = GenomicRegion(chromosome: "chr1", start: 100, end: 200)
        let region2 = GenomicRegion(chromosome: "chr1", start: 150, end: 250)

        let intersection = region1.intersection(region2)
        XCTAssertNotNil(intersection)
        XCTAssertEqual(intersection?.start, 150)
        XCTAssertEqual(intersection?.end, 200)
    }

    func testUnion() {
        let region1 = GenomicRegion(chromosome: "chr1", start: 100, end: 200)
        let region2 = GenomicRegion(chromosome: "chr1", start: 150, end: 250)

        let union = region1.union(region2)
        XCTAssertNotNil(union)
        XCTAssertEqual(union?.start, 100)
        XCTAssertEqual(union?.end, 250)
    }
}

// MARK: - SequenceAlphabet Tests

final class SequenceAlphabetTests: XCTestCase {

    func testDNAValidCharacters() {
        let alphabet = SequenceAlphabet.dna
        XCTAssertTrue(alphabet.validCharacters.contains("A"))
        XCTAssertTrue(alphabet.validCharacters.contains("T"))
        XCTAssertTrue(alphabet.validCharacters.contains("G"))
        XCTAssertTrue(alphabet.validCharacters.contains("C"))
        XCTAssertTrue(alphabet.validCharacters.contains("N"))
        XCTAssertFalse(alphabet.validCharacters.contains("U"))
    }

    func testRNAValidCharacters() {
        let alphabet = SequenceAlphabet.rna
        XCTAssertTrue(alphabet.validCharacters.contains("A"))
        XCTAssertTrue(alphabet.validCharacters.contains("U"))
        XCTAssertTrue(alphabet.validCharacters.contains("G"))
        XCTAssertTrue(alphabet.validCharacters.contains("C"))
        XCTAssertFalse(alphabet.validCharacters.contains("T"))
    }

    func testSupportsComplement() {
        XCTAssertTrue(SequenceAlphabet.dna.supportsComplement)
        XCTAssertTrue(SequenceAlphabet.rna.supportsComplement)
        XCTAssertFalse(SequenceAlphabet.protein.supportsComplement)
    }

    func testCanTranslate() {
        XCTAssertTrue(SequenceAlphabet.dna.canTranslate)
        XCTAssertTrue(SequenceAlphabet.rna.canTranslate)
        XCTAssertFalse(SequenceAlphabet.protein.canTranslate)
    }
}
