// SequenceExtractorTests.swift - Tests for sequence extraction logic
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishCore

final class SequenceExtractorTests: XCTestCase {

    // A simple sequence provider that returns a substring of a known genome.
    // Genome: 200 bases of repeating "ACGT"
    let genome = String(repeating: "ACGT", count: 50) // 200 bp
    let chromLength = 200

    func makeProvider() -> SequenceExtractor.SequenceProvider {
        let g = genome
        return { _, start, end in
            guard start >= 0, end <= g.count, start < end else { return nil }
            let startIdx = g.index(g.startIndex, offsetBy: start)
            let endIdx = g.index(g.startIndex, offsetBy: end)
            return String(g[startIdx..<endIdx])
        }
    }

    // MARK: - Region Extraction

    func testExtractSimpleRegion() throws {
        let request = ExtractionRequest(
            source: .region(chromosome: "chr1", start: 10, end: 20)
        )

        let result = try SequenceExtractor.extract(
            request: request,
            sequenceProvider: makeProvider(),
            chromosomeLength: chromLength
        )

        XCTAssertEqual(result.nucleotideSequence.count, 10)
        XCTAssertEqual(result.effectiveStart, 10)
        XCTAssertEqual(result.effectiveEnd, 20)
        XCTAssertEqual(result.chromosome, "chr1")
        XCTAssertFalse(result.isReverseComplement)
        XCTAssertNil(result.proteinSequence)
    }

    func testExtractRegionWithFlanking() throws {
        let request = ExtractionRequest(
            source: .region(chromosome: "chr1", start: 20, end: 30),
            flank5Prime: 5,
            flank3Prime: 10
        )

        let result = try SequenceExtractor.extract(
            request: request,
            sequenceProvider: makeProvider(),
            chromosomeLength: chromLength
        )

        // 10bp region + 5bp 5' + 10bp 3' = 25bp
        XCTAssertEqual(result.nucleotideSequence.count, 25)
        XCTAssertEqual(result.effectiveStart, 15)
        XCTAssertEqual(result.effectiveEnd, 40)
    }

    func testFlankingClampedToChromosomeBounds() throws {
        let request = ExtractionRequest(
            source: .region(chromosome: "chr1", start: 2, end: 10),
            flank5Prime: 100,
            flank3Prime: 500
        )

        let result = try SequenceExtractor.extract(
            request: request,
            sequenceProvider: makeProvider(),
            chromosomeLength: chromLength
        )

        // 5' clamped to 0, 3' clamped to 200
        XCTAssertEqual(result.effectiveStart, 0)
        XCTAssertEqual(result.effectiveEnd, chromLength)
        XCTAssertEqual(result.nucleotideSequence.count, chromLength)
    }

    func testExtractRegionReverseComplement() throws {
        let request = ExtractionRequest(
            source: .region(chromosome: "chr1", start: 0, end: 4),
            reverseComplement: true
        )

        let result = try SequenceExtractor.extract(
            request: request,
            sequenceProvider: makeProvider(),
            chromosomeLength: chromLength
        )

        // genome starts with "ACGT", RC of "ACGT" is "ACGT"
        XCTAssertEqual(result.nucleotideSequence, "ACGT")
        XCTAssertTrue(result.isReverseComplement)
    }

    func testExtractRegionRCDifferentSequence() throws {
        // Use a custom provider with asymmetric sequence
        let customProvider: SequenceExtractor.SequenceProvider = { _, start, end in
            let seq = "AAACCCTTTGGG"
            guard start >= 0, end <= seq.count else { return nil }
            let s = seq.index(seq.startIndex, offsetBy: start)
            let e = seq.index(seq.startIndex, offsetBy: end)
            return String(seq[s..<e])
        }

        let request = ExtractionRequest(
            source: .region(chromosome: "chr1", start: 0, end: 6),
            reverseComplement: true
        )

        let result = try SequenceExtractor.extract(
            request: request,
            sequenceProvider: customProvider,
            chromosomeLength: 12
        )

        // "AAACCC" -> RC -> "GGGTTT"
        XCTAssertEqual(result.nucleotideSequence, "GGGTTT")
    }

    func testEmptyRegionThrows() {
        let request = ExtractionRequest(
            source: .region(chromosome: "chr1", start: 10, end: 10)
        )

        XCTAssertThrowsError(try SequenceExtractor.extract(
            request: request,
            sequenceProvider: makeProvider(),
            chromosomeLength: chromLength
        )) { error in
            XCTAssertTrue(error is ExtractionError)
        }
    }

    // MARK: - Contiguous Annotation Extraction

    func testExtractContiguousAnnotation() throws {
        let annotation = SequenceAnnotation(
            type: .gene,
            name: "TestGene",
            chromosome: "chr1",
            start: 10,
            end: 30,
            strand: .forward
        )

        let request = ExtractionRequest(source: .annotation(annotation))

        let result = try SequenceExtractor.extract(
            request: request,
            sequenceProvider: makeProvider(),
            chromosomeLength: chromLength
        )

        XCTAssertEqual(result.nucleotideSequence.count, 20)
        XCTAssertEqual(result.effectiveStart, 10)
        XCTAssertEqual(result.effectiveEnd, 30)
        XCTAssertEqual(result.sourceName, "TestGene")
        XCTAssertNil(result.proteinSequence)
    }

    func testExtractAnnotationWithFlanking() throws {
        let annotation = SequenceAnnotation(
            type: .gene,
            name: "TestGene",
            chromosome: "chr1",
            start: 20,
            end: 40,
            strand: .forward
        )

        let request = ExtractionRequest(
            source: .annotation(annotation),
            flank5Prime: 10,
            flank3Prime: 5
        )

        let result = try SequenceExtractor.extract(
            request: request,
            sequenceProvider: makeProvider(),
            chromosomeLength: chromLength
        )

        // 20bp annotation + 10bp 5' + 5bp 3' = 35bp
        XCTAssertEqual(result.nucleotideSequence.count, 35)
        XCTAssertEqual(result.effectiveStart, 10)
        XCTAssertEqual(result.effectiveEnd, 45)
    }

    // MARK: - Discontiguous Annotation Extraction

    func testExtractDiscontiguousAnnotationFullRegion() throws {
        // Two exons: 10-20 and 30-40
        let annotation = SequenceAnnotation(
            type: .mRNA,
            name: "TestmRNA",
            chromosome: "chr1",
            intervals: [
                AnnotationInterval(start: 10, end: 20),
                AnnotationInterval(start: 30, end: 40)
            ],
            strand: .forward
        )

        // Without concatenation: fetch full bounding region 10-40
        let request = ExtractionRequest(
            source: .annotation(annotation),
            concatenateExons: false
        )

        let result = try SequenceExtractor.extract(
            request: request,
            sequenceProvider: makeProvider(),
            chromosomeLength: chromLength
        )

        // Full bounding region: 30bp (10 to 40)
        XCTAssertEqual(result.nucleotideSequence.count, 30)
        XCTAssertEqual(result.effectiveStart, 10)
        XCTAssertEqual(result.effectiveEnd, 40)
    }

    func testExtractDiscontiguousConcatenated() throws {
        // Two exons: 10-20 and 30-40
        let annotation = SequenceAnnotation(
            type: .mRNA,
            name: "TestmRNA",
            chromosome: "chr1",
            intervals: [
                AnnotationInterval(start: 10, end: 20),
                AnnotationInterval(start: 30, end: 40)
            ],
            strand: .forward
        )

        let request = ExtractionRequest(
            source: .annotation(annotation),
            concatenateExons: true
        )

        let result = try SequenceExtractor.extract(
            request: request,
            sequenceProvider: makeProvider(),
            chromosomeLength: chromLength
        )

        // Concatenated exons: 10bp + 10bp = 20bp (intron removed)
        XCTAssertEqual(result.nucleotideSequence.count, 20)
    }

    func testExtractDiscontiguousConcatenatedWithFlanking() throws {
        let annotation = SequenceAnnotation(
            type: .mRNA,
            name: "TestmRNA",
            chromosome: "chr1",
            intervals: [
                AnnotationInterval(start: 20, end: 30),
                AnnotationInterval(start: 40, end: 50)
            ],
            strand: .forward
        )

        let request = ExtractionRequest(
            source: .annotation(annotation),
            flank5Prime: 5,
            flank3Prime: 5,
            concatenateExons: true
        )

        let result = try SequenceExtractor.extract(
            request: request,
            sequenceProvider: makeProvider(),
            chromosomeLength: chromLength
        )

        // 5bp flank + 10bp exon + 10bp exon + 5bp flank = 30bp
        XCTAssertEqual(result.nucleotideSequence.count, 30)
        XCTAssertEqual(result.effectiveStart, 15)
        XCTAssertEqual(result.effectiveEnd, 55)
    }

    // MARK: - CDS Translation

    func testExtractCDSWithTranslation() throws {
        // Create a CDS with ATG...TAA (simple ORF)
        // ATG GCA GCA TAA = M A A * (12 bp)
        let cdsSequence = "ATGGCAGCATAA"
        let provider: SequenceExtractor.SequenceProvider = { _, start, end in
            guard start >= 0, end <= cdsSequence.count else { return nil }
            let s = cdsSequence.index(cdsSequence.startIndex, offsetBy: start)
            let e = cdsSequence.index(cdsSequence.startIndex, offsetBy: end)
            return String(cdsSequence[s..<e])
        }

        let annotation = SequenceAnnotation(
            type: .cds,
            name: "TestCDS",
            chromosome: "chr1",
            start: 0,
            end: 12,
            strand: .forward
        )

        let request = ExtractionRequest(source: .annotation(annotation))

        let result = try SequenceExtractor.extract(
            request: request,
            sequenceProvider: provider,
            chromosomeLength: 12
        )

        XCTAssertEqual(result.nucleotideSequence, "ATGGCAGCATAA")
        XCTAssertNotNil(result.proteinSequence)
        XCTAssertEqual(result.proteinSequence, "MAA*")
    }

    func testNonCDSHasNoTranslation() throws {
        let annotation = SequenceAnnotation(
            type: .gene,
            name: "TestGene",
            chromosome: "chr1",
            start: 0,
            end: 20,
            strand: .forward
        )

        let request = ExtractionRequest(source: .annotation(annotation))

        let result = try SequenceExtractor.extract(
            request: request,
            sequenceProvider: makeProvider(),
            chromosomeLength: chromLength
        )

        XCTAssertNil(result.proteinSequence)
    }

    // MARK: - FASTA Formatting

    func testFormatFASTA() throws {
        let result = ExtractionResult(
            fastaHeader: "TestGene [chr1:10-30] [gene] [strand: +] [20 bp]",
            nucleotideSequence: "ACGTACGTACGTACGTACGT",
            proteinSequence: nil,
            sourceName: "TestGene",
            chromosome: "chr1",
            effectiveStart: 10,
            effectiveEnd: 30,
            isReverseComplement: false
        )

        let fasta = SequenceExtractor.formatFASTA(result)

        XCTAssertTrue(fasta.hasPrefix(">TestGene"))
        XCTAssertTrue(fasta.contains("[chr1:10-30]"))
        // Sequence should be on second line
        let lines = fasta.split(separator: "\n")
        XCTAssertEqual(lines.count, 2) // header + sequence (short enough for one line)
    }

    func testFormatFASTAWrapsLongSequence() throws {
        let longSeq = String(repeating: "A", count: 150)
        let result = ExtractionResult(
            fastaHeader: "test",
            nucleotideSequence: longSeq,
            proteinSequence: nil,
            sourceName: "test",
            chromosome: "chr1",
            effectiveStart: 0,
            effectiveEnd: 150,
            isReverseComplement: false
        )

        let fasta = SequenceExtractor.formatFASTA(result, lineWidth: 70)
        let lines = fasta.split(separator: "\n")

        XCTAssertEqual(lines.count, 4) // header + 70 + 70 + 10
        XCTAssertEqual(lines[1].count, 70)
        XCTAssertEqual(lines[2].count, 70)
        XCTAssertEqual(lines[3].count, 10)
    }

    func testFormatProteinFASTA() throws {
        let result = ExtractionResult(
            fastaHeader: "TestCDS [chr1:0-12] [CDS] [12 bp]",
            nucleotideSequence: "ATGGCAGCATAA",
            proteinSequence: "MAA*",
            sourceName: "TestCDS",
            chromosome: "chr1",
            effectiveStart: 0,
            effectiveEnd: 12,
            isReverseComplement: false
        )

        let proteinFASTA = SequenceExtractor.formatProteinFASTA(result)
        XCTAssertNotNil(proteinFASTA)
        XCTAssertTrue(proteinFASTA!.contains("[protein]"))
        XCTAssertTrue(proteinFASTA!.contains("MAA*"))
    }

    func testFormatProteinFASTAReturnsNilForNonCDS() throws {
        let result = ExtractionResult(
            fastaHeader: "test",
            nucleotideSequence: "ACGT",
            proteinSequence: nil,
            sourceName: "test",
            chromosome: "chr1",
            effectiveStart: 0,
            effectiveEnd: 4,
            isReverseComplement: false
        )

        XCTAssertNil(SequenceExtractor.formatProteinFASTA(result))
    }

    // MARK: - Header Formatting

    func testHeaderIncludesAnnotationMetadata() throws {
        let annotation = SequenceAnnotation(
            type: .cds,
            name: "XP_001114420.3",
            chromosome: "NC_041760.1",
            start: 100,
            end: 200,
            strand: .reverse
        )

        let request = ExtractionRequest(
            source: .annotation(annotation),
            reverseComplement: true
        )

        let provider: SequenceExtractor.SequenceProvider = { _, _, _ in
            String(repeating: "A", count: 100)
        }

        let result = try SequenceExtractor.extract(
            request: request,
            sequenceProvider: provider,
            chromosomeLength: 1000
        )

        XCTAssertTrue(result.fastaHeader.contains("XP_001114420.3"))
        XCTAssertTrue(result.fastaHeader.contains("[NC_041760.1:100-200]"))
        XCTAssertTrue(result.fastaHeader.contains("[CDS]"))
        XCTAssertTrue(result.fastaHeader.contains("[strand: -]"))
        XCTAssertTrue(result.fastaHeader.contains("[reverse complement]"))
        XCTAssertTrue(result.fastaHeader.contains("[100 bp]"))
    }

    func testHeaderIncludesConcatenatedLabel() throws {
        let annotation = SequenceAnnotation(
            type: .mRNA,
            name: "TestmRNA",
            chromosome: "chr1",
            intervals: [
                AnnotationInterval(start: 10, end: 20),
                AnnotationInterval(start: 30, end: 40)
            ],
            strand: .forward
        )

        let request = ExtractionRequest(
            source: .annotation(annotation),
            concatenateExons: true
        )

        let result = try SequenceExtractor.extract(
            request: request,
            sequenceProvider: makeProvider(),
            chromosomeLength: chromLength
        )

        XCTAssertTrue(result.fastaHeader.contains("[exons concatenated]"))
    }

    // MARK: - Edge Cases

    func testNegativeFlankingClampedToZero() throws {
        // ExtractionRequest constructor clamps negative to 0
        let request = ExtractionRequest(
            source: .region(chromosome: "chr1", start: 10, end: 20),
            flank5Prime: -10,
            flank3Prime: -5
        )

        let result = try SequenceExtractor.extract(
            request: request,
            sequenceProvider: makeProvider(),
            chromosomeLength: chromLength
        )

        // No flanking applied
        XCTAssertEqual(result.effectiveStart, 10)
        XCTAssertEqual(result.effectiveEnd, 20)
    }

    func testSequenceProviderReturnsNilThrows() {
        let nilProvider: SequenceExtractor.SequenceProvider = { _, _, _ in nil }

        let request = ExtractionRequest(
            source: .region(chromosome: "chr1", start: 0, end: 10)
        )

        XCTAssertThrowsError(try SequenceExtractor.extract(
            request: request,
            sequenceProvider: nilProvider,
            chromosomeLength: 100
        )) { error in
            XCTAssertTrue(error is ExtractionError)
        }
    }
}
