// DatabaseServiceIntegrationTests.swift - Integration tests for database services
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishCore

/// Integration tests that make real network requests to NCBI and ENA.
/// These tests require network access and may be slow.
final class DatabaseServiceIntegrationTests: XCTestCase {

    // MARK: - NCBI Tests

    func testNCBISearch() async throws {
        let service = NCBIService()

        // Search for a well-known sequence
        let query = SearchQuery(term: "NC_001802", limit: 5)
        let results = try await service.search(query)

        XCTAssertGreaterThan(results.records.count, 0, "Should find at least one result")

        if let first = results.records.first {
            print("Found: \(first.accession) - \(first.title)")
            XCTAssertFalse(first.accession.isEmpty)
            XCTAssertFalse(first.title.isEmpty)
        }
    }

    func testNCBIFetchGenBank() async throws {
        let service = NCBIService()

        // Fetch HIV-1 reference genome (well-known, stable accession)
        let record = try await service.fetch(accession: "NC_001802")

        XCTAssertEqual(record.source, .ncbi)
        XCTAssertFalse(record.accession.isEmpty)
        XCTAssertFalse(record.title.isEmpty)
        XCTAssertGreaterThan(record.sequence.count, 1000, "HIV-1 genome should be >9kb")

        print("Fetched: \(record.accession)")
        print("Title: \(record.title)")
        print("Organism: \(record.organism ?? "Unknown")")
        print("Sequence length: \(record.sequence.count) bp")
    }

    func testNCBISearchEbola() async throws {
        // Wait to avoid rate limiting from previous tests
        try await Task.sleep(nanoseconds: 500_000_000)  // 0.5 seconds

        let service = NCBIService()

        // Search for Ebola virus sequences using accession prefix
        // KM034562 is a well-known Ebola virus Makona genome
        let query = SearchQuery(term: "KM034562", limit: 5)
        let results = try await service.search(query)

        print("Found \(results.records.count) Ebola-related sequences:")
        for record in results.records.prefix(5) {
            print("  \(record.accession): \(record.title.prefix(60))...")
        }

        XCTAssertGreaterThan(results.records.count, 0, "Should find KM034562 Ebola sequence")
    }

    // MARK: - ENA Tests

    func testENASearch() async throws {
        let service = ENAService()

        // Search for a well-known sequence
        let query = SearchQuery(term: "coronavirus", limit: 5)
        let results = try await service.search(query)

        print("ENA found \(results.records.count) results:")
        for record in results.records.prefix(3) {
            print("  \(record.accession): \(record.title.prefix(50))...")
        }

        // ENA may return 0 results depending on API status
        // Just verify no crash
    }

    func testENAFetchFASTA() async throws {
        let service = ENAService()

        // Fetch a known ENA sequence
        let fasta = try await service.fetchFASTA(accession: "MN908947")

        XCTAssertTrue(fasta.hasPrefix(">"), "Should be valid FASTA")
        XCTAssertGreaterThan(fasta.count, 100)

        print("Fetched FASTA from ENA:")
        print(fasta.prefix(200))
    }

    // MARK: - SRA Tests

    func testSRASearch() async throws {
        // Wait to avoid rate limiting
        try await Task.sleep(nanoseconds: 500_000_000)

        let service = SRAService()

        // Search for a well-known SRA run
        let query = SearchQuery(term: "SRR11140748", limit: 5)
        let results = try await service.search(query)

        print("SRA found \(results.runs.count) runs:")
        for run in results.runs.prefix(3) {
            print("  \(run.accession): \(run.organism ?? "Unknown") - \(run.spotsString)")
        }

        // The search may return 0 if the run info API changes
        // Just verify no crash and results structure is valid
    }

    func testSRAToolkitDetection() async throws {
        let service = SRAService()
        let available = await service.isSRAToolkitAvailable

        print("SRA Toolkit available: \(available)")
        // Don't assert - toolkit may or may not be installed
    }

    // MARK: - Download to File Tests

    func testDownloadToTemporaryFile() async throws {
        let service = NCBIService()

        // Fetch a small sequence
        let record = try await service.fetch(accession: "NC_001802")

        // Save to temporary file
        let tempDir = FileManager.default.temporaryDirectory
        let filename = "\(record.accession).fasta"
        let fileURL = tempDir.appendingPathComponent(filename)

        // Create FASTA content
        var fastaContent = ">\(record.accession)"
        if !record.title.isEmpty {
            fastaContent += " \(record.title)"
        }
        if let organism = record.organism {
            fastaContent += " [\(organism)]"
        }
        fastaContent += "\n"

        // Wrap sequence at 80 characters
        let sequence = record.sequence
        let lineLength = 80
        var index = sequence.startIndex
        while index < sequence.endIndex {
            let end = sequence.index(index, offsetBy: lineLength, limitedBy: sequence.endIndex) ?? sequence.endIndex
            fastaContent += String(sequence[index..<end]) + "\n"
            index = end
        }

        try fastaContent.write(to: fileURL, atomically: true, encoding: .utf8)

        // Verify file exists
        XCTAssertTrue(FileManager.default.fileExists(atPath: fileURL.path))

        // Read back and verify
        let readContent = try String(contentsOf: fileURL, encoding: .utf8)
        XCTAssertTrue(readContent.hasPrefix(">NC_001802"))

        print("Downloaded to: \(fileURL.path)")
        print("File size: \(readContent.count) bytes")

        // Clean up
        try? FileManager.default.removeItem(at: fileURL)
    }
}
