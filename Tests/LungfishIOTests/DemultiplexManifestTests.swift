import XCTest
@testable import LungfishIO

final class DemultiplexManifestTests: XCTestCase {

    private func makeTempDir() throws -> URL {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("DemuxManifestTests-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    // MARK: - DemultiplexManifest

    func testDemuxManifestRoundTrip() throws {
        let dir = try makeTempDir()
        defer { try? FileManager.default.removeItem(at: dir) }

        let manifest = DemultiplexManifest(
            barcodeKit: BarcodeKit(name: "SQK-NBD114.96", vendor: "oxford_nanopore", barcodeCount: 96),
            parameters: DemultiplexParameters(tool: "dorado", maxMismatches: 2),
            barcodes: [
                BarcodeResult(barcodeID: "barcode01", sampleName: "SampleA", readCount: 5000, baseCount: 50_000_000, bundleRelativePath: "barcode01.lungfishfastq"),
                BarcodeResult(barcodeID: "barcode02", sampleName: "SampleB", readCount: 3000, baseCount: 30_000_000, bundleRelativePath: "barcode02.lungfishfastq"),
            ],
            unassigned: UnassignedReadsSummary(readCount: 200, baseCount: 2_000_000),
            outputDirectoryRelativePath: "../multiplexed-demux/",
            inputReadCount: 8200
        )

        try manifest.save(to: dir)
        let loaded = DemultiplexManifest.load(from: dir)

        XCTAssertNotNil(loaded)
        // Use Equatable for comprehensive field verification
        // (Date round-trips lose sub-second precision via ISO 8601, so compare key fields)
        XCTAssertEqual(loaded?.barcodes.count, 2)
        XCTAssertEqual(loaded?.barcodeKit, manifest.barcodeKit)
        XCTAssertEqual(loaded?.parameters, manifest.parameters)
        XCTAssertEqual(loaded?.inputReadCount, manifest.inputReadCount)
        XCTAssertEqual(loaded?.barcodes, manifest.barcodes)
        XCTAssertEqual(loaded?.unassigned, manifest.unassigned)
        XCTAssertEqual(loaded?.outputDirectoryRelativePath, manifest.outputDirectoryRelativePath)
        XCTAssertEqual(loaded?.version, manifest.version)
    }

    func testAssignmentRate() {
        let manifest = DemultiplexManifest(
            barcodeKit: BarcodeKit(name: "kit", vendor: "test", barcodeCount: 2),
            parameters: DemultiplexParameters(tool: "test"),
            barcodes: [
                BarcodeResult(barcodeID: "bc01", readCount: 800, baseCount: 8000, bundleRelativePath: "bc01"),
            ],
            unassigned: UnassignedReadsSummary(readCount: 200, baseCount: 2000),
            outputDirectoryRelativePath: "../demux/",
            inputReadCount: 1000
        )

        XCTAssertEqual(manifest.assignmentRate, 0.8, accuracy: 0.001)
        XCTAssertEqual(manifest.assignedReadCount, 800)
        XCTAssertTrue(manifest.isAccountingBalanced)
    }

    func testAccountingImbalance() {
        let manifest = DemultiplexManifest(
            barcodeKit: BarcodeKit(name: "kit", vendor: "test", barcodeCount: 1),
            parameters: DemultiplexParameters(tool: "test"),
            barcodes: [
                BarcodeResult(barcodeID: "bc01", readCount: 500, baseCount: 5000, bundleRelativePath: "bc01"),
            ],
            unassigned: UnassignedReadsSummary(readCount: 100, baseCount: 1000),
            outputDirectoryRelativePath: "../demux/",
            inputReadCount: 1000
        )

        XCTAssertFalse(manifest.isAccountingBalanced)
    }

    func testAssignmentRateZeroInput() {
        let manifest = DemultiplexManifest(
            barcodeKit: BarcodeKit(name: "kit", vendor: "test", barcodeCount: 0),
            parameters: DemultiplexParameters(tool: "test"),
            barcodes: [],
            unassigned: UnassignedReadsSummary(readCount: 0, baseCount: 0),
            outputDirectoryRelativePath: "../demux/",
            inputReadCount: 0
        )
        XCTAssertEqual(manifest.assignmentRate, 0)
    }

    func testLoadMalformedJSON() throws {
        let dir = try makeTempDir()
        defer { try? FileManager.default.removeItem(at: dir) }

        let malformed = dir.appendingPathComponent(DemultiplexManifest.filename)
        try "{ not valid json".data(using: .utf8)!.write(to: malformed)
        XCTAssertNil(DemultiplexManifest.load(from: dir))
    }

    func testBarcodeResultDisplayName() {
        let withSample = BarcodeResult(barcodeID: "bc01", sampleName: "Patient-042", readCount: 100, baseCount: 1000, bundleRelativePath: "bc01")
        XCTAssertEqual(withSample.displayName, "Patient-042")

        let withoutSample = BarcodeResult(barcodeID: "bc01", readCount: 100, baseCount: 1000, bundleRelativePath: "bc01")
        XCTAssertEqual(withoutSample.displayName, "bc01")
    }

    func testIsDemultiplexedBundle() throws {
        let dir = try makeTempDir()
        defer { try? FileManager.default.removeItem(at: dir) }

        XCTAssertFalse(DemultiplexManifest.isDemultiplexedBundle(dir))

        // Write a manifest
        let manifest = DemultiplexManifest(
            barcodeKit: BarcodeKit(name: "kit", vendor: "test", barcodeCount: 1),
            parameters: DemultiplexParameters(tool: "test"),
            barcodes: [],
            unassigned: UnassignedReadsSummary(readCount: 0, baseCount: 0),
            outputDirectoryRelativePath: "../demux/",
            inputReadCount: 0
        )
        try manifest.save(to: dir)

        XCTAssertTrue(DemultiplexManifest.isDemultiplexedBundle(dir))
    }

    // MARK: - Barcode Kit

    func testBarcodeTypeCases() {
        XCTAssertEqual(BarcodeType.allCases.count, 3)
        XCTAssertEqual(BarcodeType.symmetric.rawValue, "symmetric")
        XCTAssertEqual(BarcodeType.asymmetric.rawValue, "asymmetric")
        XCTAssertEqual(BarcodeType.singleEnd.rawValue, "singleEnd")
    }

    // MARK: - Demultiplex Parameters

    func testParametersDefaults() {
        let params = DemultiplexParameters(tool: "cutadapt")
        XCTAssertEqual(params.maxMismatches, 1)
        XCTAssertFalse(params.requireBothEnds)
        XCTAssertTrue(params.trimBarcodes)
        XCTAssertNil(params.toolVersion)
    }

    // MARK: - Unassigned Disposition

    func testUnassignedDispositionCases() {
        XCTAssertEqual(UnassignedDisposition.allCases.count, 2)
        XCTAssertEqual(UnassignedDisposition.keep.rawValue, "keep")
        XCTAssertEqual(UnassignedDisposition.discard.rawValue, "discard")
    }
}
