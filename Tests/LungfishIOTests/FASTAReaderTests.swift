// FASTAReaderTests.swift - Comprehensive tests for FASTA file reading
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishIO
@testable import LungfishCore

final class FASTAReaderTests: XCTestCase {

    // MARK: - Test Fixtures

    var tempDirectory: URL!

    override func setUp() async throws {
        // Create a temporary directory for test files
        tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("LungfishTests-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
    }

    override func tearDown() async throws {
        // Clean up temporary files
        if let tempDir = tempDirectory {
            try? FileManager.default.removeItem(at: tempDir)
        }
    }

    /// Creates a temporary FASTA file with the given content
    private func createTempFASTA(_ content: String, filename: String = "test.fasta") throws -> URL {
        let fileURL = tempDirectory.appendingPathComponent(filename)
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
        return fileURL
    }

    // MARK: - Basic Reading Tests

    func testReadSingleSequence() async throws {
        let content = """
        >seq1 Test sequence
        ATCGATCGATCG
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences.count, 1)
        XCTAssertEqual(sequences[0].name, "seq1")
        XCTAssertEqual(sequences[0].description, "Test sequence")
        XCTAssertEqual(sequences[0].asString(), "ATCGATCGATCG")
        XCTAssertEqual(sequences[0].length, 12)
    }

    func testReadMultipleSequences() async throws {
        let content = """
        >seq1 First sequence
        ATCGATCG
        >seq2 Second sequence
        GGGGCCCC
        >seq3 Third sequence
        AAAATTTT
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences.count, 3)
        XCTAssertEqual(sequences[0].name, "seq1")
        XCTAssertEqual(sequences[1].name, "seq2")
        XCTAssertEqual(sequences[2].name, "seq3")
        XCTAssertEqual(sequences[0].asString(), "ATCGATCG")
        XCTAssertEqual(sequences[1].asString(), "GGGGCCCC")
        XCTAssertEqual(sequences[2].asString(), "AAAATTTT")
    }

    func testReadMultiLineSequence() async throws {
        let content = """
        >seq1 Multi-line sequence
        ATCGATCG
        ATCGATCG
        ATCGATCG
        ATCGATCG
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences.count, 1)
        XCTAssertEqual(sequences[0].asString(), "ATCGATCGATCGATCGATCGATCGATCGATCG")
        XCTAssertEqual(sequences[0].length, 32)
    }

    func testReadVaryingLineLengths() async throws {
        let content = """
        >seq1
        ATCG
        ATCGATCGATCGATCGATCG
        AT
        ATCGATCGATCGATCGATCGATCGATCGATCG
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences.count, 1)
        XCTAssertEqual(sequences[0].length, 58)  // 4 + 20 + 2 + 32
    }

    // MARK: - Header Parsing Tests

    func testParseHeaderNameOnly() async throws {
        let content = """
        >sequence_name
        ATCG
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences[0].name, "sequence_name")
        XCTAssertNil(sequences[0].description)
    }

    func testParseHeaderWithDescription() async throws {
        let content = """
        >seq1 This is a description with spaces
        ATCG
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences[0].name, "seq1")
        XCTAssertEqual(sequences[0].description, "This is a description with spaces")
    }

    func testParseHeaderWithSpecialCharacters() async throws {
        let content = """
        >chr1:100-200|gene=BRCA1|organism=Homo_sapiens
        ATCGATCG
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences[0].name, "chr1:100-200|gene=BRCA1|organism=Homo_sapiens")
    }

    func testReadHeaders() async throws {
        let content = """
        >seq1 First description
        ATCGATCG
        >seq2 Second description
        GGGGCCCC
        >seq3
        AAAATTTT
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let headers = try await reader.readHeaders()

        XCTAssertEqual(headers.count, 3)
        XCTAssertEqual(headers[0].name, "seq1")
        XCTAssertEqual(headers[0].description, "First description")
        XCTAssertEqual(headers[1].name, "seq2")
        XCTAssertEqual(headers[2].name, "seq3")
        XCTAssertNil(headers[2].description)
    }

    // MARK: - Alphabet Detection Tests

    func testAutoDetectDNA() async throws {
        let content = """
        >dna_seq
        ATCGATCGATCGATCG
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences[0].alphabet, .dna)
    }

    func testAutoDetectRNA() async throws {
        let content = """
        >rna_seq
        AUCGAUCGAUCGAUCG
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences[0].alphabet, .rna)
    }

    func testAutoDetectProtein() async throws {
        let content = """
        >protein_seq
        MKTAYIAKQRQISFVKSHFSRQLEERLGLI
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences[0].alphabet, .protein)
    }

    func testExplicitAlphabet() async throws {
        let content = """
        >seq1
        ATCGATCG
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll(alphabet: .dna)

        XCTAssertEqual(sequences[0].alphabet, .dna)
    }

    // MARK: - Edge Cases

    func testEmptyFile() async throws {
        let content = ""

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertTrue(sequences.isEmpty)
    }

    func testFileWithOnlyHeader() async throws {
        let content = ">header_only"

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        // Empty sequence (no bases after header) should be skipped
        XCTAssertTrue(sequences.isEmpty)
    }

    func testFileWithEmptyLines() async throws {
        let content = """
        >seq1 Test

        ATCG

        ATCG

        >seq2

        GGGG
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences.count, 2)
        XCTAssertEqual(sequences[0].asString(), "ATCGATCG")
        XCTAssertEqual(sequences[1].asString(), "GGGG")
    }

    func testFileWithLeadingWhitespace() async throws {
        let content = """
        >seq1
           ATCG
           ATCG
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences[0].asString(), "ATCGATCG")
    }

    func testFileWithTrailingWhitespace() async throws {
        let content = ">seq1\nATCG   \nATCG   \n"

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences[0].asString(), "ATCGATCG")
    }

    func testLowercaseBases() async throws {
        let content = """
        >seq1
        atcgatcg
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences.count, 1)
        XCTAssertEqual(sequences[0].length, 8)
    }

    func testMixedCaseBases() async throws {
        let content = """
        >seq1
        AtCgAtCg
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences.count, 1)
    }

    func testAmbiguousBases() async throws {
        let content = """
        >seq1
        ATCGNNNNATCG
        RYSWKMBDHVN
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences.count, 1)
        XCTAssertTrue(sequences[0].asString().contains("N"))
    }

    // MARK: - Error Handling Tests

    func testFileNotFound() async {
        let fileURL = URL(fileURLWithPath: "/nonexistent/path/file.fasta")

        do {
            _ = try FASTAReader(url: fileURL)
            XCTFail("Should throw error for non-existent file")
        } catch let error as FASTAError {
            if case .fileNotFound(_) = error {
                // Expected
            } else {
                XCTFail("Wrong error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func testSequenceBeforeHeader() async throws {
        let content = """
        ATCGATCG
        >seq1
        GGGG
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)

        do {
            _ = try await reader.readAll()
            XCTFail("Should throw error for sequence before header")
        } catch let error as FASTAError {
            if case .sequenceBeforeHeader(let line) = error {
                XCTAssertEqual(line, 1)
            } else {
                XCTFail("Wrong error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func testInvalidCharacter() async throws {
        let content = """
        >seq1
        ATCG123XYZ
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)

        do {
            _ = try await reader.readAll(alphabet: .dna)
            XCTFail("Should throw error for invalid characters")
        } catch let error as FASTAError {
            if case .invalidSequence(let name, _) = error {
                XCTAssertEqual(name, "seq1")
            } else {
                XCTFail("Wrong error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    // MARK: - Streaming Tests

    func testSequenceStream() async throws {
        let content = """
        >seq1
        ATCG
        >seq2
        GGGG
        >seq3
        CCCC
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)

        var count = 0
        for try await sequence in reader.sequences() {
            count += 1
            XCTAssertEqual(sequence.length, 4)
        }

        XCTAssertEqual(count, 3)
    }

    func testStreamStopsOnError() async throws {
        let content = """
        >seq1
        ATCG
        >seq2
        INVALID123
        >seq3
        GGGG
        """

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)

        var sequences: [Sequence] = []
        var errorThrown = false

        do {
            for try await sequence in reader.sequences(alphabet: .dna) {
                sequences.append(sequence)
            }
        } catch {
            errorThrown = true
        }

        XCTAssertTrue(errorThrown)
        XCTAssertEqual(sequences.count, 1)  // First valid sequence before error
    }

    // MARK: - Large File Tests

    func testLargeFile() async throws {
        var content = ""
        for i in 0..<100 {
            content += ">seq\(i)\n"
            content += String(repeating: "ATCGATCGATCGATCGATCG", count: 50) + "\n"  // 1000 bp each
        }

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences.count, 100)
        for seq in sequences {
            XCTAssertEqual(seq.length, 1000)
        }
    }

    func testVeryLongSequence() async throws {
        var content = ">long_sequence\n"
        // Create a 100,000 bp sequence
        content += String(repeating: "ATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCG\n", count: 1667)

        let fileURL = try createTempFASTA(content)
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences.count, 1)
        XCTAssertGreaterThan(sequences[0].length, 90000)
    }

    // MARK: - File Extension Tests

    func testSupportedExtensions() {
        let supported = FASTAReader.supportedExtensions
        XCTAssertTrue(supported.contains("fa"))
        XCTAssertTrue(supported.contains("fasta"))
        XCTAssertTrue(supported.contains("fna"))
        XCTAssertTrue(supported.contains("faa"))
        XCTAssertTrue(supported.contains("ffn"))
    }

    func testVariousFileExtensions() async throws {
        let content = """
        >seq1
        ATCG
        """

        for ext in ["fa", "fasta", "fna", "faa"] {
            let fileURL = try createTempFASTA(content, filename: "test.\(ext)")
            let reader = try FASTAReader(url: fileURL)
            let sequences = try await reader.readAll()
            XCTAssertEqual(sequences.count, 1, "Failed for extension: \(ext)")
        }
    }

    // MARK: - Performance Tests

    func testReadPerformance() async throws {
        // Create a file with 1000 sequences of 1000 bp each
        var content = ""
        for i in 0..<1000 {
            content += ">seq\(i)\n"
            content += String(repeating: "ATCG", count: 250) + "\n"
        }

        let fileURL = try createTempFASTA(content, filename: "performance_test.fasta")
        let reader = try FASTAReader(url: fileURL)

        measure {
            let expectation = self.expectation(description: "Read completes")
            Task {
                _ = try? await reader.readAll()
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 10.0)
        }
    }
}

// MARK: - FASTAWriter Tests

final class FASTAWriterTests: XCTestCase {

    var tempDirectory: URL!

    override func setUp() async throws {
        tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("LungfishWriterTests-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
    }

    override func tearDown() async throws {
        if let tempDir = tempDirectory {
            try? FileManager.default.removeItem(at: tempDir)
        }
    }

    func testWriteSingleSequence() async throws {
        let fileURL = tempDirectory.appendingPathComponent("output.fasta")
        let writer = FASTAWriter(url: fileURL)

        let sequence = try Sequence(name: "test", description: "Test sequence", alphabet: .dna, bases: "ATCGATCG")
        try writer.write([sequence])

        // Read back and verify
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences.count, 1)
        XCTAssertEqual(sequences[0].name, "test")
        XCTAssertEqual(sequences[0].description, "Test sequence")
        XCTAssertEqual(sequences[0].asString(), "ATCGATCG")
    }

    func testWriteMultipleSequences() async throws {
        let fileURL = tempDirectory.appendingPathComponent("multi.fasta")
        let writer = FASTAWriter(url: fileURL)

        let sequences = [
            try Sequence(name: "seq1", alphabet: .dna, bases: "ATCG"),
            try Sequence(name: "seq2", alphabet: .dna, bases: "GGGG"),
            try Sequence(name: "seq3", alphabet: .dna, bases: "CCCC")
        ]
        try writer.write(sequences)

        // Read back and verify
        let reader = try FASTAReader(url: fileURL)
        let readSequences = try await reader.readAll()

        XCTAssertEqual(readSequences.count, 3)
    }

    func testWriteLineWidth() async throws {
        let fileURL = tempDirectory.appendingPathComponent("linewidth.fasta")
        let writer = FASTAWriter(url: fileURL, lineWidth: 10)

        // Create a 25 bp sequence
        let sequence = try Sequence(name: "test", alphabet: .dna, bases: "ATCGATCGATCGATCGATCGATCGA")
        try writer.write([sequence])

        // Read the raw file and check line lengths
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        let lines = content.split(separator: "\n", omittingEmptySubsequences: false)

        // Should have: header, 10bp, 10bp, 5bp
        XCTAssertEqual(lines[1].count, 10)
        XCTAssertEqual(lines[2].count, 10)
        XCTAssertEqual(lines[3].count, 5)
    }

    func testAppendSequence() async throws {
        let fileURL = tempDirectory.appendingPathComponent("append.fasta")
        let writer = FASTAWriter(url: fileURL)

        // Write first sequence
        let seq1 = try Sequence(name: "seq1", alphabet: .dna, bases: "ATCG")
        try writer.write([seq1])

        // Append second sequence
        let seq2 = try Sequence(name: "seq2", alphabet: .dna, bases: "GGGG")
        try writer.append(seq2)

        // Read back and verify
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences.count, 2)
        XCTAssertEqual(sequences[0].name, "seq1")
        XCTAssertEqual(sequences[1].name, "seq2")
    }

    func testRoundTrip() async throws {
        let fileURL = tempDirectory.appendingPathComponent("roundtrip.fasta")
        let writer = FASTAWriter(url: fileURL)

        let originalSequences = [
            try Sequence(name: "seq1", description: "First", alphabet: .dna, bases: "ATCGATCGATCGATCGATCGATCGATCG"),
            try Sequence(name: "seq2", description: "Second with longer description", alphabet: .dna, bases: "GGGGCCCCAAAATTTT"),
            try Sequence(name: "seq3", alphabet: .dna, bases: "NNNNNNNN")
        ]

        try writer.write(originalSequences)

        let reader = try FASTAReader(url: fileURL)
        let readSequences = try await reader.readAll()

        XCTAssertEqual(readSequences.count, originalSequences.count)

        for (original, read) in zip(originalSequences, readSequences) {
            XCTAssertEqual(read.name, original.name)
            XCTAssertEqual(read.description, original.description)
            XCTAssertEqual(read.asString(), original.asString())
        }
    }

    func testWriteProteinSequence() async throws {
        let fileURL = tempDirectory.appendingPathComponent("protein.fasta")
        let writer = FASTAWriter(url: fileURL)

        let sequence = try Sequence(
            name: "protein1",
            description: "Test protein",
            alphabet: .protein,
            bases: "MKTAYIAKQRQISFVKSHFSRQLEERLGLI"
        )
        try writer.write([sequence])

        // Read back
        let reader = try FASTAReader(url: fileURL)
        let sequences = try await reader.readAll()

        XCTAssertEqual(sequences[0].asString(), "MKTAYIAKQRQISFVKSHFSRQLEERLGLI")
    }
}

// MARK: - FASTAError Tests

final class FASTAErrorTests: XCTestCase {

    func testFileNotFoundErrorDescription() {
        let url = URL(fileURLWithPath: "/path/to/file.fasta")
        let error = FASTAError.fileNotFound(url)
        XCTAssertTrue(error.errorDescription?.contains("/path/to/file.fasta") ?? false)
    }

    func testInvalidEncodingErrorDescription() {
        let error = FASTAError.invalidEncoding
        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription?.contains("encoding") ?? false)
    }

    func testSequenceBeforeHeaderErrorDescription() {
        let error = FASTAError.sequenceBeforeHeader(line: 5)
        XCTAssertTrue(error.errorDescription?.contains("5") ?? false)
    }

    func testInvalidSequenceErrorDescription() {
        let underlying = SequenceError.invalidCharacter("X", position: 10)
        let error = FASTAError.invalidSequence(name: "seq1", underlying: underlying)
        XCTAssertTrue(error.errorDescription?.contains("seq1") ?? false)
    }

    func testRegionOutOfBoundsErrorDescription() {
        let region = GenomicRegion(chromosome: "chr1", start: 1000, end: 2000)
        let error = FASTAError.regionOutOfBounds(region, sequenceLength: 500)
        XCTAssertTrue(error.errorDescription?.contains("500") ?? false)
    }
}
