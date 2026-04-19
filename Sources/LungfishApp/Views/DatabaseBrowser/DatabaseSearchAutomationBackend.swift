import Foundation
import LungfishCore

struct DatabaseSearchAutomationRequest: Sendable {
    let source: DatabaseSource
    let ncbiSearchType: NCBISearchType
    let searchText: String
}

enum DatabaseSearchUITestScenario: String, Sendable {
    case basic = "database-search-basic"
}

struct DatabaseSearchAutomationBackend: Sendable {
    let scenario: DatabaseSearchUITestScenario

    init?(scenarioName: String) {
        guard let scenario = DatabaseSearchUITestScenario(rawValue: scenarioName) else {
            return nil
        }

        self.scenario = scenario
    }

    init?(configuration: AppUITestConfiguration) {
        guard configuration.isEnabled,
              let scenarioName = configuration.scenarioName else {
            return nil
        }

        self.init(scenarioName: scenarioName)
    }

    func search(_ request: DatabaseSearchAutomationRequest) async throws -> SearchResults {
        let records: [SearchResultRecord]

        switch (scenario, request.source, request.ncbiSearchType) {
        case (.basic, .ncbi, .nucleotide):
            records = [
                SearchResultRecord(
                    id: "NC_045512.2",
                    accession: "NC_045512.2",
                    title: "Severe acute respiratory syndrome coronavirus 2 isolate Wuhan-Hu-1, complete genome",
                    organism: "Severe acute respiratory syndrome coronavirus 2",
                    length: 29_903,
                    source: .ncbi
                ),
                SearchResultRecord(
                    id: "PP000001.1",
                    accession: "PP000001.1",
                    title: "Synthetic respiratory virus reference",
                    organism: "Synthetic respiratory virus",
                    length: 14_552,
                    source: .ncbi
                ),
            ]

        case (.basic, .ena, _):
            records = [
                SearchResultRecord(
                    id: "SRR000001",
                    accession: "SRR000001",
                    title: "Example Illumina run",
                    organism: "Synthetic respiratory virus",
                    length: 1_500_000,
                    source: .ena
                )
            ]

        case (.basic, .pathoplexus, _):
            records = [
                SearchResultRecord(
                    id: "MPXV-OPEN-001",
                    accession: "MPXV-OPEN-001",
                    title: "Open Pathoplexus mpox record",
                    organism: "Mpox virus",
                    length: 197_209,
                    source: .pathoplexus
                )
            ]

        default:
            records = []
        }

        _ = request.searchText

        return SearchResults(
            totalCount: records.count,
            records: records,
            hasMore: false,
            nextCursor: nil
        )
    }

    func simulateDownload(records: [SearchResultRecord], source: DatabaseSource) async throws {
        _ = (records, source)
    }
}
