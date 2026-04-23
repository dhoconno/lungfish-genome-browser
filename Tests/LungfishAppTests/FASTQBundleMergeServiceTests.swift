import XCTest
@testable import LungfishApp
@testable import LungfishIO

@MainActor
final class FASTQBundleMergeServiceTests: XCTestCase {
    func testMergeCreatesVirtualBundleForSingleEndPhysicalInputs() async throws {
        let root = try makeTempDirectory()
        defer { try? FileManager.default.removeItem(at: root) }

        let first = try makeBundle(
            root: root,
            name: "A",
            fastqName: "reads.fastq",
            contents: "@r1\nACGT\n+\nIIII\n",
            pairing: .singleEnd
        )
        let second = try makeBundle(
            root: root,
            name: "B",
            fastqName: "reads.fastq",
            contents: "@r2\nTTTT\n+\nIIII\n",
            pairing: .singleEnd
        )

        let mergedURL = try await FASTQBundleMergeService.merge(
            sourceBundleURLs: [first, second],
            outputDirectory: root,
            bundleName: "Merged Reads"
        )

        XCTAssertTrue(FASTQSourceFileManifest.exists(in: mergedURL))
        XCTAssertTrue(
            FileManager.default.fileExists(
                atPath: mergedURL.appendingPathComponent("preview.fastq").path
            )
        )

        let manifest = try XCTUnwrap(try? FASTQSourceFileManifest.load(from: mergedURL))
        XCTAssertEqual(manifest.files.count, 2)

        let resolvedFASTQs = try XCTUnwrap(FASTQBundle.resolveAllFASTQURLs(for: mergedURL))
        XCTAssertEqual(resolvedFASTQs.count, 2)
    }

    func testMergeCreatesMaterializedBundleForInterleavedInputs() async throws {
        let root = try makeTempDirectory()
        defer { try? FileManager.default.removeItem(at: root) }

        let firstContents = "@r1/1\nACGT\n+\nIIII\n@r1/2\nTGCA\n+\nIIII\n"
        let secondContents = "@r2/1\nCCCC\n+\nIIII\n@r2/2\nGGGG\n+\nIIII\n"

        let first = try makeBundle(
            root: root,
            name: "A",
            fastqName: "reads.fastq",
            contents: firstContents,
            pairing: .interleaved
        )
        let second = try makeBundle(
            root: root,
            name: "B",
            fastqName: "reads.fastq",
            contents: secondContents,
            pairing: .interleaved
        )

        let mergedURL = try await FASTQBundleMergeService.merge(
            sourceBundleURLs: [first, second],
            outputDirectory: root,
            bundleName: "Merged Interleaved"
        )

        XCTAssertFalse(FASTQSourceFileManifest.exists(in: mergedURL))

        let mergedFASTQ = try XCTUnwrap(FASTQBundle.resolvePrimaryFASTQURL(for: mergedURL))
        XCTAssertEqual(mergedFASTQ.lastPathComponent, "reads.fastq")
        XCTAssertEqual(
            FASTQMetadataStore.load(for: mergedFASTQ)?.ingestion?.pairingMode,
            .interleaved
        )
        XCTAssertEqual(
            try String(contentsOf: mergedFASTQ, encoding: .utf8),
            firstContents + secondContents
        )
    }

    private func makeTempDirectory() throws -> URL {
        let root = FileManager.default.temporaryDirectory
            .appendingPathComponent("FASTQBundleMergeServiceTests-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
        return root
    }

    private func makeBundle(
        root: URL,
        name: String,
        fastqName: String,
        contents: String,
        pairing: IngestionMetadata.PairingMode
    ) throws -> URL {
        let bundleURL = root.appendingPathComponent(
            "\(name).\(FASTQBundle.directoryExtension)",
            isDirectory: true
        )
        try FileManager.default.createDirectory(at: bundleURL, withIntermediateDirectories: true)

        let fastqURL = bundleURL.appendingPathComponent(fastqName)
        try contents.write(to: fastqURL, atomically: true, encoding: .utf8)
        FASTQMetadataStore.save(
            PersistedFASTQMetadata(ingestion: IngestionMetadata(pairingMode: pairing)),
            for: fastqURL
        )

        return bundleURL
    }
}
