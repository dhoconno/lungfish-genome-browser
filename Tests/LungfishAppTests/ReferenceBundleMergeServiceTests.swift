import XCTest
@testable import LungfishApp
@testable import LungfishCore
@testable import LungfishIO

@MainActor
final class ReferenceBundleMergeServiceTests: XCTestCase {
    func testMergeCreatesSequenceOnlyReferenceBundle() async throws {
        let root = FileManager.default.temporaryDirectory
            .appendingPathComponent("ReferenceBundleMergeServiceTests-\(UUID().uuidString)", isDirectory: true)
        let projectURL = root.appendingPathComponent("Fixture.lungfish", isDirectory: true)

        try FileManager.default.createDirectory(at: projectURL, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: root) }

        let fastaA = root.appendingPathComponent("A.fa")
        let fastaB = root.appendingPathComponent("B.fa")
        try ">chrA\nAAAA\n".write(to: fastaA, atomically: true, encoding: .utf8)
        try ">chrB\nCCCC\n".write(to: fastaB, atomically: true, encoding: .utf8)

        let bundleA = try ReferenceSequenceFolder.importReference(
            from: fastaA,
            into: projectURL,
            displayName: "A"
        )
        let bundleB = try ReferenceSequenceFolder.importReference(
            from: fastaB,
            into: projectURL,
            displayName: "B"
        )

        let mergedURL = try await ReferenceBundleMergeService.merge(
            sourceBundleURLs: [bundleA, bundleB],
            outputDirectory: projectURL,
            bundleName: "Merged Reference"
        )

        let manifest = try BundleManifest.load(from: mergedURL)
        XCTAssertEqual(manifest.name, "Merged Reference")
        XCTAssertEqual(manifest.annotations.count, 0)
        XCTAssertEqual(manifest.variants.count, 0)
        XCTAssertEqual(manifest.tracks.count, 0)
        XCTAssertNotNil(manifest.genome)
    }
}
