import XCTest
@testable import LungfishApp
@testable import LungfishCore

final class DatabaseSearchAutomationBackendTests: XCTestCase {
    func testUnknownScenarioNameReturnsNilBackend() {
        XCTAssertNil(DatabaseSearchAutomationBackend(scenarioName: "unknown"))
    }

    func testBasicScenarioReturnsDeterministicRecordsPerDestination() async throws {
        let backend = try XCTUnwrap(DatabaseSearchAutomationBackend(scenarioName: "database-search-basic"))

        let ncbi = try await backend.search(
            DatabaseSearchAutomationRequest(
                source: .ncbi,
                ncbiSearchType: .nucleotide,
                searchText: "coronavirus"
            )
        )
        XCTAssertEqual(ncbi.records.map(\.accession), ["NC_045512.2", "PP000001.1"])

        let sra = try await backend.search(
            DatabaseSearchAutomationRequest(
                source: .ena,
                ncbiSearchType: .nucleotide,
                searchText: "SRR000001"
            )
        )
        XCTAssertEqual(sra.records.map(\.accession), ["SRR000001"])

        let pathoplexus = try await backend.search(
            DatabaseSearchAutomationRequest(
                source: .pathoplexus,
                ncbiSearchType: .nucleotide,
                searchText: "mpox"
            )
        )
        XCTAssertEqual(pathoplexus.records.map(\.accession), ["MPXV-OPEN-001"])
    }

    func testBasicScenarioSupportsNoOpDownloadSimulation() async throws {
        let backend = try XCTUnwrap(DatabaseSearchAutomationBackend(scenarioName: "database-search-basic"))
        let records = [
            SearchResultRecord(
                id: "NC_045512.2",
                accession: "NC_045512.2",
                title: "Severe acute respiratory syndrome coronavirus 2 isolate Wuhan-Hu-1, complete genome",
                source: .ncbi
            )
        ]

        try await backend.simulateDownload(records: records, source: .ncbi)
    }
}
