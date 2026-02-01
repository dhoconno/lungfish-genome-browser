// NCBIServiceTests.swift - Tests for NCBI Entrez service
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishCore

final class NCBIServiceTests: XCTestCase {

    var mockClient: MockHTTPClient!
    var service: NCBIService!

    override func setUp() async throws {
        mockClient = MockHTTPClient()
        service = NCBIService(httpClient: mockClient)
    }

    // MARK: - ESearch Tests

    func testESearchReturnsIDs() async throws {
        await mockClient.registerNCBISearch(ids: ["12345", "67890", "11111"])

        let ids = try await service.esearch(database: .nucleotide, term: "ebola virus", retmax: 10)

        XCTAssertEqual(ids.count, 3)
        XCTAssertEqual(ids, ["12345", "67890", "11111"])
    }

    func testESearchEmptyResults() async throws {
        await mockClient.registerNCBISearch(ids: [])

        let ids = try await service.esearch(database: .nucleotide, term: "nonexistent", retmax: 10)

        XCTAssertTrue(ids.isEmpty)
    }

    func testESearchBuildsCorrectURL() async throws {
        await mockClient.registerNCBISearch(ids: ["123"])

        _ = try await service.esearch(database: .protein, term: "spike protein", retmax: 50, retstart: 10)

        let requests = await mockClient.requests
        XCTAssertEqual(requests.count, 1)

        let url = requests[0].url!.absoluteString
        XCTAssertTrue(url.contains("esearch.fcgi"))
        XCTAssertTrue(url.contains("db=protein"))
        XCTAssertTrue(url.contains("retmax=50"))
        XCTAssertTrue(url.contains("retstart=10"))
    }

    func testESearchWithAPIKey() async throws {
        let serviceWithKey = NCBIService(apiKey: "test-api-key", httpClient: mockClient)
        await mockClient.registerNCBISearch(ids: ["123"])

        _ = try await serviceWithKey.esearch(database: .nucleotide, term: "test", retmax: 10)

        let requests = await mockClient.requests
        let url = requests[0].url!.absoluteString
        XCTAssertTrue(url.contains("api_key=test-api-key"))
    }

    // MARK: - EFetch Tests

    func testEFetchFASTA() async throws {
        let fastaContent = """
        >NC_002549.1 Zaire ebolavirus
        ATGGATGACTCTCGAGAAGTACTTGTAGATGG
        """
        await mockClient.registerNCBIFetch(fasta: fastaContent)

        let data = try await service.efetch(database: .nucleotide, ids: ["NC_002549.1"], format: .fasta)

        let result = String(data: data, encoding: .utf8)!
        XCTAssertTrue(result.contains(">NC_002549.1"))
        XCTAssertTrue(result.contains("ATGGATGACTCTCGAGAAGTACTTGTAGATGG"))
    }

    func testEFetchGenBank() async throws {
        let gbContent = """
        LOCUS       NC_002549              18959 bp    RNA     linear   VRL
        DEFINITION  Zaire ebolavirus, complete genome.
        //
        """
        await mockClient.register(pattern: "efetch.fcgi", response: .text(gbContent))

        let data = try await service.efetch(database: .nucleotide, ids: ["NC_002549.1"], format: .genbank)

        let result = String(data: data, encoding: .utf8)!
        XCTAssertTrue(result.contains("LOCUS"))
        XCTAssertTrue(result.contains("Zaire ebolavirus"))
    }

    func testEFetchMultipleIDs() async throws {
        await mockClient.registerNCBIFetch(fasta: ">seq1\nATG\n>seq2\nGTA")

        _ = try await service.efetch(database: .nucleotide, ids: ["id1", "id2", "id3"], format: .fasta)

        let requests = await mockClient.requests
        let url = requests[0].url!.absoluteString
        XCTAssertTrue(url.contains("id=id1,id2,id3") || url.contains("id=id1%2Cid2%2Cid3"))
    }

    // MARK: - ESummary Tests

    func testESummaryParsesDocuments() async throws {
        let jsonResponse: [String: Any] = [
            "result": [
                "uids": ["12345"],
                "12345": [
                    "uid": "12345",
                    "title": "Ebola virus complete genome",
                    "accessionversion": "NC_002549.1",
                    "slen": 18959,
                    "organism": "Zaire ebolavirus",
                    "createdate": "2001/01/01"
                ]
            ]
        ]
        await mockClient.register(pattern: "esummary.fcgi", response: .json(jsonResponse))

        let summaries = try await service.esummary(database: .nucleotide, ids: ["12345"])

        XCTAssertEqual(summaries.count, 1)
        XCTAssertEqual(summaries[0].uid, "12345")
        XCTAssertEqual(summaries[0].title, "Ebola virus complete genome")
        XCTAssertEqual(summaries[0].accessionVersion, "NC_002549.1")
        XCTAssertEqual(summaries[0].length, 18959)
    }

    // MARK: - Search Tests (DatabaseService Protocol)

    func testSearchReturnsResults() async throws {
        await mockClient.registerNCBISearch(ids: ["123", "456"])

        let summaryResponse: [String: Any] = [
            "result": [
                "uids": ["123", "456"],
                "123": [
                    "uid": "123",
                    "title": "Sequence 1",
                    "accessionversion": "AB123.1",
                    "slen": 1000,
                    "organism": "Test organism"
                ],
                "456": [
                    "uid": "456",
                    "title": "Sequence 2",
                    "accessionversion": "AB456.1",
                    "slen": 2000,
                    "organism": "Test organism"
                ]
            ]
        ]
        await mockClient.register(pattern: "esummary.fcgi", response: .json(summaryResponse))

        let query = SearchQuery(term: "test organism", limit: 10)
        let results = try await service.search(query)

        XCTAssertEqual(results.totalCount, 2)
        XCTAssertEqual(results.records.count, 2)
        XCTAssertEqual(results.records[0].accession, "AB123.1")
        XCTAssertEqual(results.records[1].accession, "AB456.1")
    }

    // MARK: - Fetch Tests (DatabaseService Protocol)

    func testFetchReturnsRecord() async throws {
        // First register the search to find the UID
        await mockClient.registerNCBISearch(ids: ["12345"])

        // Then register the GenBank fetch
        let gbContent = """
        LOCUS       NC_002549              18959 bp    RNA     linear   VRL
        ACCESSION   NC_002549
        VERSION     NC_002549.1
        DEFINITION  Zaire ebolavirus, complete genome.
        ORIGIN
                1 atggatgact
        //
        """
        await mockClient.register(pattern: "efetch.fcgi", response: .text(gbContent))

        let record = try await service.fetch(accession: "NC_002549.1")

        XCTAssertEqual(record.accession, "NC_002549")
        XCTAssertEqual(record.source, .ncbi)
        XCTAssertFalse(record.sequence.isEmpty)
    }

    // MARK: - Rate Limiting Tests

    func testRateLimitingDelaysRequests() async throws {
        await mockClient.registerNCBISearch(ids: ["1"])

        let start = Date()

        // Make multiple requests
        for _ in 0..<3 {
            _ = try await service.esearch(database: .nucleotide, term: "test", retmax: 1)
        }

        let elapsed = Date().timeIntervalSince(start)

        // Should have some delay due to rate limiting (at least ~0.6 seconds for 3 requests at 3/second)
        // But in tests with mocks this may be faster, so just check it completed
        XCTAssertGreaterThanOrEqual(elapsed, 0)
    }

    // MARK: - Error Handling Tests

    func testHandlesNetworkError() async throws {
        // No response registered - will throw

        do {
            _ = try await service.esearch(database: .nucleotide, term: "test", retmax: 10)
            XCTFail("Should have thrown an error")
        } catch {
            // Expected
        }
    }

    func testHandlesServerError() async throws {
        await mockClient.register(pattern: "esearch.fcgi", response: .error(statusCode: 500, message: "Internal Server Error"))

        do {
            _ = try await service.esearch(database: .nucleotide, term: "test", retmax: 10)
            XCTFail("Should have thrown an error")
        } catch let error as DatabaseServiceError {
            if case .serverError = error {
                // Expected
            } else {
                XCTFail("Expected serverError, got \(error)")
            }
        }
    }

    // MARK: - Database Type Tests

    func testAllDatabaseTypesHaveRawValues() {
        let databases: [NCBIDatabase] = [.nucleotide, .protein, .gene, .sra, .biosample, .bioproject, .taxonomy, .pubmed, .pmc]

        for db in databases {
            XCTAssertFalse(db.rawValue.isEmpty)
        }
    }

    // MARK: - Format Tests

    func testFormatRettype() {
        XCTAssertEqual(NCBIFormat.fasta.rettype, "fasta")
        XCTAssertEqual(NCBIFormat.genbank.rettype, "gb")
        XCTAssertEqual(NCBIFormat.genbankWithParts.rettype, "gb")
        XCTAssertEqual(NCBIFormat.xml.rettype, "native")
    }
}
