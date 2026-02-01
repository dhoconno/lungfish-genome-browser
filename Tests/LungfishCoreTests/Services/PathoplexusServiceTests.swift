// PathoplexusServiceTests.swift - Tests for Pathoplexus service
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishCore

final class PathoplexusServiceTests: XCTestCase {

    var mockClient: MockHTTPClient!
    var service: PathoplexusService!

    override func setUp() async throws {
        mockClient = MockHTTPClient()
        service = PathoplexusService(httpClient: mockClient)
    }

    // MARK: - List Organisms Tests

    func testListOrganismsReturnsKnownOrganisms() async throws {
        let organisms = try await service.listOrganisms()

        XCTAssertGreaterThan(organisms.count, 0)

        // Check for expected organisms
        let ids = organisms.map { $0.id }
        XCTAssertTrue(ids.contains("ebola-zaire"))
        XCTAssertTrue(ids.contains("mpox"))
        XCTAssertTrue(ids.contains("cchf"))
    }

    func testListOrganismsIncludesSegmentedInfo() async throws {
        let organisms = try await service.listOrganisms()

        // CCHF should be segmented
        let cchf = organisms.first { $0.id == "cchf" }
        XCTAssertNotNil(cchf)
        XCTAssertTrue(cchf!.segmented)
        XCTAssertNotNil(cchf!.segments)
        XCTAssertEqual(cchf!.segments?.count, 3)  // S, M, L segments
    }

    func testListOrganismsIncludesNonSegmented() async throws {
        let organisms = try await service.listOrganisms()

        // Ebola should not be segmented
        let ebola = organisms.first { $0.id == "ebola-zaire" }
        XCTAssertNotNil(ebola)
        XCTAssertFalse(ebola!.segmented)
        XCTAssertNil(ebola!.segments)
    }

    // MARK: - Search Tests

    func testSearchReturnsResults() async throws {
        await mockClient.registerPathoplexusCount(42)
        await mockClient.registerPathoplexusMetadata([
            [
                "accession": "PP_12345",
                "organism": "Ebola zaire",
                "geoLocCountry": "DRC",
                "sampleCollectionDate": "2024-01-15",
                "length": 18959
            ]
        ])

        let query = SearchQuery(term: "ebola", organism: "ebola-zaire", limit: 10)
        let results = try await service.search(query)

        XCTAssertEqual(results.totalCount, 42)
        XCTAssertGreaterThan(results.records.count, 0)
    }

    func testSearchWithFilters() async throws {
        await mockClient.registerPathoplexusCount(5)
        await mockClient.registerPathoplexusMetadata([])

        let filters = PathoplexusFilters(
            geoLocCountry: "USA",
            sampleCollectionDateFrom: Date(),
            lengthFrom: 1000,
            lengthTo: 20000
        )

        let results = try await service.search(organism: "mpox", filters: filters)

        XCTAssertEqual(results.totalCount, 5)

        // Check that filters were included in the request
        let requests = await mockClient.requests
        XCTAssertGreaterThan(requests.count, 0)
    }

    // MARK: - Aggregated Count Tests

    func testGetAggregatedCount() async throws {
        await mockClient.registerPathoplexusCount(156)

        let count = try await service.getAggregatedCount(organism: "ebola-zaire", filters: PathoplexusFilters())

        XCTAssertEqual(count, 156)
    }

    func testGetAggregatedCountWithFilters() async throws {
        await mockClient.registerPathoplexusCount(25)

        let filters = PathoplexusFilters(geoLocCountry: "Uganda")
        let count = try await service.getAggregatedCount(organism: "ebola-sudan", filters: filters)

        XCTAssertEqual(count, 25)

        let requests = await mockClient.requests
        let url = requests[0].url!.absoluteString
        XCTAssertTrue(url.contains("geoLocCountry=Uganda") || url.contains("geoLocCountry"))
    }

    // MARK: - Fetch Metadata Tests

    func testFetchMetadataReturnsRecords() async throws {
        await mockClient.registerPathoplexusMetadata([
            [
                "accession": "PP_001",
                "accessionVersion": "1",
                "organism": "Mpox",
                "geoLocCountry": "Nigeria",
                "sampleCollectionDate": "2024-02-01",
                "length": 197209
            ],
            [
                "accession": "PP_002",
                "accessionVersion": "1",
                "organism": "Mpox",
                "geoLocCountry": "DRC",
                "sampleCollectionDate": "2024-01-20",
                "length": 197150
            ]
        ])

        let metadata = try await service.fetchMetadata(organism: "mpox", filters: PathoplexusFilters())

        XCTAssertEqual(metadata.count, 2)
        XCTAssertEqual(metadata[0].accession, "PP_001")
        XCTAssertEqual(metadata[0].geoLocCountry, "Nigeria")
        XCTAssertEqual(metadata[1].accession, "PP_002")
        XCTAssertEqual(metadata[1].geoLocCountry, "DRC")
    }

    func testFetchMetadataHandlesIntAndStringLength() async throws {
        await mockClient.registerPathoplexusMetadata([
            ["accession": "PP_001", "length": 1000],
            ["accession": "PP_002", "length": "2000"]
        ])

        let metadata = try await service.fetchMetadata(organism: "mpox", filters: PathoplexusFilters())

        XCTAssertEqual(metadata.count, 2)
        XCTAssertEqual(metadata[0].length, 1000)
        XCTAssertEqual(metadata[1].length, 2000)
    }

    // MARK: - Fetch Sequences Tests

    func testFetchSequencesStreamsData() async throws {
        let fastaContent = """
        >PP_001
        ATGCATGCATGC
        >PP_002
        GCTAGCTAGCTA
        """
        await mockClient.register(pattern: "NucleotideSequences", response: .text(fastaContent))

        let stream = try await service.fetchSequences(organism: "mpox", filters: PathoplexusFilters())

        var records: [FASTARecord] = []
        for try await record in stream {
            records.append(record)
        }

        XCTAssertEqual(records.count, 2)
        XCTAssertEqual(records[0].accession, "PP_001")
        XCTAssertEqual(records[1].accession, "PP_002")
    }

    func testFetchAlignedSequences() async throws {
        let fastaContent = ">PP_001\nATG---CATGC"
        await mockClient.register(pattern: "alignedNucleotideSequences", response: .text(fastaContent))

        let stream = try await service.fetchSequences(organism: "mpox", filters: PathoplexusFilters(), aligned: true)

        var records: [FASTARecord] = []
        for try await record in stream {
            records.append(record)
        }

        XCTAssertEqual(records.count, 1)
        XCTAssertTrue(records[0].sequence.contains("-"))
    }

    func testFetchUnalignedSequences() async throws {
        let fastaContent = ">PP_001\nATGCATGC"
        await mockClient.register(pattern: "unalignedNucleotideSequences", response: .text(fastaContent))

        let stream = try await service.fetchSequences(organism: "mpox", filters: PathoplexusFilters(), aligned: false)

        var records: [FASTARecord] = []
        for try await record in stream {
            records.append(record)
        }

        XCTAssertEqual(records.count, 1)
        XCTAssertFalse(records[0].sequence.contains("-"))
    }

    // MARK: - Fetch Tests (DatabaseService Protocol)

    func testFetchReturnsRecord() async throws {
        await mockClient.registerPathoplexusMetadata([
            ["accession": "PP_TEST", "length": 5000]
        ])
        await mockClient.register(pattern: "NucleotideSequences", response: .text(">PP_TEST\nATGCATGC"))

        let record = try await service.fetch(accession: "PP_TEST")

        XCTAssertEqual(record.accession, "PP_TEST")
        XCTAssertEqual(record.source, .pathoplexus)
    }

    // MARK: - Filter Building Tests

    func testFiltersIncludeAllParameters() async throws {
        await mockClient.registerPathoplexusCount(0)

        let filters = PathoplexusFilters(
            accession: "PP_001",
            accessionVersion: "1",
            geoLocCountry: "USA",
            sampleCollectionDateFrom: Date(timeIntervalSince1970: 1704067200),  // 2024-01-01
            sampleCollectionDateTo: Date(timeIntervalSince1970: 1706745600),    // 2024-02-01
            lengthFrom: 1000,
            lengthTo: 20000,
            nucleotideMutations: ["C180T"],
            aminoAcidMutations: ["GP:440G"],
            versionStatus: .latestVersion
        )

        _ = try await service.getAggregatedCount(organism: "mpox", filters: filters)

        let requests = await mockClient.requests
        XCTAssertEqual(requests.count, 1)
    }

    // MARK: - Error Handling Tests

    func testHandlesNetworkError() async throws {
        // No response registered

        do {
            _ = try await service.getAggregatedCount(organism: "mpox", filters: PathoplexusFilters())
            XCTFail("Should have thrown an error")
        } catch {
            // Expected
        }
    }

    func testHandlesServerError() async throws {
        await mockClient.register(pattern: "/aggregated", response: .error(statusCode: 500, message: "Internal Error"))

        do {
            _ = try await service.getAggregatedCount(organism: "mpox", filters: PathoplexusFilters())
            XCTFail("Should have thrown an error")
        } catch let error as DatabaseServiceError {
            if case .serverError = error {
                // Expected
            } else {
                XCTFail("Expected serverError, got \(error)")
            }
        }
    }

    func testHandlesInvalidOrganism() async throws {
        await mockClient.register(pattern: "/aggregated", response: .error(statusCode: 404, message: "Not Found"))

        do {
            _ = try await service.getAggregatedCount(organism: "invalid-organism", filters: PathoplexusFilters())
            XCTFail("Should have thrown an error")
        } catch let error as DatabaseServiceError {
            if case .notFound = error {
                // Expected
            } else {
                XCTFail("Expected notFound error, got \(error)")
            }
        }
    }

    // MARK: - Service Properties Tests

    func testServiceName() async {
        XCTAssertEqual(service.name, "Pathoplexus")
    }

    func testServiceBaseURL() async {
        XCTAssertTrue(service.baseURL.absoluteString.contains("pathoplexus"))
    }
}

// MARK: - PathoplexusFilters Tests

final class PathoplexusFiltersTests: XCTestCase {

    func testDefaultFiltersAreEmpty() {
        let filters = PathoplexusFilters()

        XCTAssertNil(filters.accession)
        XCTAssertNil(filters.geoLocCountry)
        XCTAssertNil(filters.sampleCollectionDateFrom)
        XCTAssertNil(filters.lengthFrom)
        XCTAssertNil(filters.nucleotideMutations)
    }

    func testFiltersEquatable() {
        let filters1 = PathoplexusFilters(geoLocCountry: "USA")
        let filters2 = PathoplexusFilters(geoLocCountry: "USA")
        let filters3 = PathoplexusFilters(geoLocCountry: "UK")

        XCTAssertEqual(filters1, filters2)
        XCTAssertNotEqual(filters1, filters3)
    }
}

// MARK: - PathoplexusOrganism Tests

final class PathoplexusOrganismTests: XCTestCase {

    func testOrganismIdentifiable() {
        let organism = PathoplexusOrganism(id: "mpox", displayName: "Mpox", segmented: false, segments: nil)

        XCTAssertEqual(organism.id, "mpox")
    }

    func testOrganismEquatable() {
        let org1 = PathoplexusOrganism(id: "mpox", displayName: "Mpox", segmented: false, segments: nil)
        let org2 = PathoplexusOrganism(id: "mpox", displayName: "Mpox", segmented: false, segments: nil)
        let org3 = PathoplexusOrganism(id: "ebola", displayName: "Ebola", segmented: false, segments: nil)

        XCTAssertEqual(org1, org2)
        XCTAssertNotEqual(org1, org3)
    }

    func testOrganismCodable() throws {
        let organism = PathoplexusOrganism(id: "cchf", displayName: "CCHF", segmented: true, segments: ["S", "M", "L"])

        let encoder = JSONEncoder()
        let data = try encoder.encode(organism)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(PathoplexusOrganism.self, from: data)

        XCTAssertEqual(decoded.id, organism.id)
        XCTAssertEqual(decoded.segmented, organism.segmented)
        XCTAssertEqual(decoded.segments, organism.segments)
    }
}

// MARK: - DataUseTerms Tests

final class DataUseTermsTests: XCTestCase {

    func testDataUseTermsRawValues() {
        XCTAssertEqual(DataUseTerms.open.rawValue, "OPEN")
        XCTAssertEqual(DataUseTerms.restricted.rawValue, "RESTRICTED")
    }

    func testDataUseTermsDescription() {
        XCTAssertTrue(DataUseTerms.open.description.contains("Open"))
        XCTAssertTrue(DataUseTerms.restricted.description.contains("Restricted"))
    }

    func testDataUseTermsCaseIterable() {
        XCTAssertEqual(DataUseTerms.allCases.count, 2)
    }
}

// MARK: - VersionStatus Tests

final class VersionStatusTests: XCTestCase {

    func testVersionStatusRawValues() {
        XCTAssertEqual(VersionStatus.latestVersion.rawValue, "LATEST_VERSION")
        XCTAssertEqual(VersionStatus.revisedVersion.rawValue, "REVISED_VERSION")
    }
}
