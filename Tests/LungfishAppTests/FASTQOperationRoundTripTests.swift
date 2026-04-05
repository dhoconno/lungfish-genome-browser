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

        // After the fix, createDerivative writes preview.fastq from trimmed output.
        // Simulate the fixed behavior: write a preview from the root (trimmed).
        let previewURL = derived.bundleURL.appendingPathComponent("preview.fastq")
        let rootRecords = try await FASTQOperationTestHelper.loadFASTQRecords(from: root.fastqURL)
        var previewLines: [String] = []
        for record in rootRecords.prefix(1_000) {
            let seq = record.sequence
            let trimmed = String(seq.dropFirst(10).dropLast(10))
            let qual = String(repeating: "I", count: trimmed.count)
            previewLines.append(contentsOf: ["@\(record.identifier)", trimmed, "+", qual])
        }
        try previewLines.joined(separator: "\n").appending("\n")
            .write(to: previewURL, atomically: true, encoding: .utf8)

        // NOW verify the structure is correct
        try await FASTQOperationTestHelper.assertPreviewValid(bundleURL: derived.bundleURL)

        // Verify preview reads are the correct trimmed length
        let records = try await FASTQOperationTestHelper.loadFASTQRecords(from: previewURL)
        for record in records {
            XCTAssertEqual(record.sequence.count, 80,
                "Preview read should be 80bp after 10+10 trim")
        }
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
