import XCTest
@testable import LungfishApp
@testable import LungfishCore

final class MappingViewerBundlePreparerTests: XCTestCase {

    func testPrepareBaseBundleLinksReferencePayloadInsteadOfCopyingFullBundle() throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("MappingViewerBundlePreparerTests-\(UUID().uuidString)")
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let sourceBundle = tempDir.appendingPathComponent("Reference.lungfishref", isDirectory: true)
        let genomeDir = sourceBundle.appendingPathComponent("genome", isDirectory: true)
        let alignmentsDir = sourceBundle.appendingPathComponent("alignments", isDirectory: true)
        try FileManager.default.createDirectory(at: genomeDir, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: alignmentsDir, withIntermediateDirectories: true)
        try "ACGT".write(to: genomeDir.appendingPathComponent("sequence.fa.gz"), atomically: true, encoding: .utf8)
        try "chr1\t4\n".write(to: genomeDir.appendingPathComponent("sequence.fa.gz.fai"), atomically: true, encoding: .utf8)
        try "old".write(to: alignmentsDir.appendingPathComponent("old.bam"), atomically: true, encoding: .utf8)

        let manifest = BundleManifest(
            name: "Reference",
            identifier: "test.reference",
            source: SourceInfo(organism: "Test", assembly: "test"),
            genome: GenomeInfo(
                path: "genome/sequence.fa.gz",
                indexPath: "genome/sequence.fa.gz.fai",
                totalLength: 4,
                chromosomes: []
            ),
            alignments: [
                AlignmentTrackInfo(id: "old", name: "Old", sourcePath: "alignments/old.bam", indexPath: "alignments/old.bam.bai")
            ]
        )
        try manifest.save(to: sourceBundle)

        let viewerBundle = tempDir.appendingPathComponent("Analysis/Reference.lungfishref", isDirectory: true)

        try MappingViewerBundlePreparer.prepareBaseBundle(
            sourceBundleURL: sourceBundle,
            viewerBundleURL: viewerBundle
        )

        let viewerGenomePath = viewerBundle.appendingPathComponent("genome").path
        let viewerGenomeAttributes = try FileManager.default.attributesOfItem(atPath: viewerGenomePath)
        XCTAssertEqual(viewerGenomeAttributes[.type] as? FileAttributeType, .typeSymbolicLink)
        XCTAssertFalse(FileManager.default.fileExists(atPath: viewerBundle.appendingPathComponent("alignments/old.bam").path))

        let viewerManifest = try BundleManifest.load(from: viewerBundle)
        XCTAssertEqual(viewerManifest.alignments, [])
        XCTAssertNotNil(viewerManifest.originBundlePath)
        XCTAssertTrue(FileManager.default.fileExists(atPath: viewerBundle.appendingPathComponent("genome/sequence.fa.gz").path))
    }
}
