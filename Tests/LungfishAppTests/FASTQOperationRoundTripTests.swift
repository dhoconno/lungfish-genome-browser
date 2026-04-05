import XCTest
@testable import LungfishApp
@testable import LungfishIO

final class FASTQOperationRoundTripTests: XCTestCase {

    // MARK: - Trim Preview Bug

    /// Verifies that trim derivatives include a preview.fastq file.
    /// This tests the bug where trim operations only wrote trim-positions.tsv
    /// but not preview.fastq, causing the viewport to show nothing.
    func testTrimDerivativeBundleContainsPreviewFASTQ() async throws {
        let tempDir = try FASTQOperationTestHelper.makeTempDir(prefix: "TrimPreviewTest")
        defer { try? FileManager.default.removeItem(at: tempDir) }

        // Create a root bundle with known reads
        let root = try FASTQOperationTestHelper.makeBundle(named: "root", in: tempDir)
        try FASTQOperationTestHelper.writeSyntheticFASTQ(
            to: root.fastqURL,
            readCount: 50,
            readLength: 100,
            idPrefix: "read"
        )

        // Create a derived bundle that mimics what createDerivative does for trim ops:
        // - writes trim-positions.tsv
        // - does NOT write preview.fastq (the bug)
        let derived = try FASTQOperationTestHelper.makeBundle(named: "trimmed", in: tempDir)

        // Write trim positions: every read trimmed by 10 from each end
        var trimRecords: [FASTQTrimRecord] = []
        for i in 0..<50 {
            trimRecords.append(FASTQTrimRecord(
                readID: "read\(i + 1)#0",
                trimStart: 10,
                trimEnd: 90
            ))
        }
        let trimURL = derived.bundleURL.appendingPathComponent(FASTQBundle.trimPositionFilename)
        try FASTQTrimPositionFile.write(trimRecords, to: trimURL)

        // The bundle should have a preview.fastq for the viewport to display.
        // This assertion WILL FAIL — proving the bug exists.
        let previewURL = derived.bundleURL.appendingPathComponent("preview.fastq")
        XCTAssertTrue(
            FileManager.default.fileExists(atPath: previewURL.path),
            "Trim derivative bundle is missing preview.fastq — viewport will show nothing"
        )
    }

    /// Verifies that fixed trim preview reads are shorter than originals by the expected amount.
    /// Uses the full createDerivative flow (requires seqkit + fastp).
    func testFixedTrimPreviewReadsAreTrimmed() async throws {
        let tempDir = try FASTQOperationTestHelper.makeTempDir(prefix: "FixedTrimInteg")
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let root = try FASTQOperationTestHelper.makeBundle(named: "root", in: tempDir)
        try FASTQOperationTestHelper.writeSyntheticFASTQ(
            to: root.fastqURL,
            readCount: 50,
            readLength: 100,
            idPrefix: "read"
        )

        let service = FASTQDerivativeService()
        let derivedURL = try await service.createDerivative(
            from: root.bundleURL,
            request: .fixedTrim(from5Prime: 10, from3Prime: 10),
            progress: nil
        )

        // Assert preview exists and is valid
        try await FASTQOperationTestHelper.assertPreviewValid(bundleURL: derivedURL)

        // Assert trim positions file exists
        try FASTQOperationTestHelper.assertTrimPositionsValid(bundleURL: derivedURL)

        // Assert preview reads are trimmed (80bp, not 100bp)
        let previewURL = derivedURL.appendingPathComponent("preview.fastq")
        let previewRecords = try await FASTQOperationTestHelper.loadFASTQRecords(from: previewURL)
        for record in previewRecords {
            XCTAssertEqual(
                record.sequence.count, 80,
                "Preview read \(record.identifier) should be 80bp after 10+10 trim, got \(record.sequence.count)bp"
            )
        }
    }
}
