import XCTest
@testable import LungfishWorkflow

final class BAMPrimerTrimProvenanceTests: XCTestCase {
    func testProvenanceEncodesToJSONAndRoundTrips() throws {
        let provenance = BAMPrimerTrimProvenance(
            operation: "primer-trim",
            primerScheme: .init(
                bundleName: "QIASeqDIRECT-SARS2",
                bundleSource: "built-in",
                bundleVersion: "1.0",
                canonicalAccession: "MN908947.3"
            ),
            sourceBAMRelativePath: "derivatives/alignment.bam",
            ivarVersion: "1.4.2",
            ivarTrimArgs: ["-q", "20", "-m", "30"],
            timestamp: Date(timeIntervalSince1970: 1714000000)
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(provenance)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(BAMPrimerTrimProvenance.self, from: data)

        XCTAssertEqual(decoded, provenance)
    }
}
