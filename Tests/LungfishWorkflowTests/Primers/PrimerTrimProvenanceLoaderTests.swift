import XCTest
import LungfishIO
@testable import LungfishWorkflow

final class PrimerTrimProvenanceLoaderTests: XCTestCase {
    private var tempDir: URL!

    override func setUpWithError() throws {
        tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("PrimerTrimProvenanceLoaderTests-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
    }

    override func tearDownWithError() throws {
        try? FileManager.default.removeItem(at: tempDir)
    }

    func testLoadReturnsNilWhenSidecarAbsent() throws {
        let bamURL = tempDir.appendingPathComponent("alignments/sample.sorted.bam")
        try FileManager.default.createDirectory(
            at: bamURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try Data("BAM".utf8).write(to: bamURL)

        XCTAssertNil(PrimerTrimProvenanceLoader.load(forBAMAt: bamURL))
    }

    func testLoadDecodesValidSidecarAtBAMSansExtPath() throws {
        let bamURL = tempDir.appendingPathComponent("alignments/sample.sorted.bam")
        try FileManager.default.createDirectory(
            at: bamURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try Data("BAM".utf8).write(to: bamURL)

        let provenance = BAMPrimerTrimProvenance(
            operation: "primer-trim",
            primerScheme: .init(
                bundleName: "QIASeqDIRECT-SARS2",
                bundleSource: "built-in",
                bundleVersion: "1.0.0",
                canonicalAccession: "MN908947.3"
            ),
            sourceBAMRelativePath: "alignments/sample.sorted.bam",
            ivarVersion: "1.4.4",
            ivarTrimArgs: ["trim", "-b", "primers.bed"],
            timestamp: Date(timeIntervalSince1970: 1_700_000_000)
        )
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(provenance)
        let sidecarURL = bamURL.deletingPathExtension()
            .appendingPathExtension("primer-trim-provenance.json")
        try data.write(to: sidecarURL)

        let loaded = PrimerTrimProvenanceLoader.load(forBAMAt: bamURL)
        XCTAssertEqual(loaded?.primerScheme.bundleName, "QIASeqDIRECT-SARS2")
        XCTAssertEqual(loaded?.operation, "primer-trim")
    }

    func testLoadRejectsSidecarWithWrongOperation() throws {
        let bamURL = tempDir.appendingPathComponent("alignments/sample.sorted.bam")
        try FileManager.default.createDirectory(
            at: bamURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try Data("BAM".utf8).write(to: bamURL)

        let provenance = BAMPrimerTrimProvenance(
            operation: "mark-duplicates",
            primerScheme: .init(
                bundleName: "ignored",
                bundleSource: "built-in",
                bundleVersion: nil,
                canonicalAccession: "X"
            ),
            sourceBAMRelativePath: "x",
            ivarVersion: "x",
            ivarTrimArgs: [],
            timestamp: Date()
        )
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(provenance)
        let sidecarURL = bamURL.deletingPathExtension()
            .appendingPathExtension("primer-trim-provenance.json")
        try data.write(to: sidecarURL)

        XCTAssertNil(PrimerTrimProvenanceLoader.load(forBAMAt: bamURL))
    }

    func testLoadReturnsNilOnCorruptJSON() throws {
        let bamURL = tempDir.appendingPathComponent("alignments/sample.sorted.bam")
        try FileManager.default.createDirectory(
            at: bamURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try Data("BAM".utf8).write(to: bamURL)
        let sidecarURL = bamURL.deletingPathExtension()
            .appendingPathExtension("primer-trim-provenance.json")
        try Data("{ not json".utf8).write(to: sidecarURL)

        XCTAssertNil(PrimerTrimProvenanceLoader.load(forBAMAt: bamURL))
    }
}
