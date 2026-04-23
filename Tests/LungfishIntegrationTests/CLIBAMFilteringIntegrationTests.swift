import XCTest
import LungfishTestSupport
@testable import LungfishCLI
@testable import LungfishCore
@testable import LungfishIO
@testable import LungfishWorkflow

final class CLIBAMFilteringIntegrationTests: XCTestCase {
    private var tempDir: URL!

    override func setUpWithError() throws {
        tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("CLIBAMFilteringIntegrationTests-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
    }

    override func tearDownWithError() throws {
        try? FileManager.default.removeItem(at: tempDir)
    }

    func testBundleFilteringCreatesFilteredSiblingTrackWithProvenance() async throws {
        let managedHome = try ManagedSamtoolsHome.makeReal(rootURL: tempDir)
        let fixture = try BundleAlignmentFixture.make(
            rootURL: tempDir,
            samtoolsPath: managedHome.samtoolsPath,
            includeMappingResult: false
        )

        let command = try BAMCommand.FilterSubcommand.parse([
            "filter",
            "--bundle", fixture.bundleURL.path,
            "--alignment-track", fixture.sourceTrackID,
            "--output-track-name", "Mapped Reads",
            "--mapped-only",
            "--format", "json",
        ])

        var lines: [String] = []
        let result = try await command.executeForTesting(
            runtime: makeRuntime(homeDirectory: managedHome.homeURL)
        ) { lines.append($0) }

        XCTAssertEqual(result.bundleURL, fixture.bundleURL)
        XCTAssertNil(result.mappingResultURL)
        XCTAssertEqual(result.trackInfo.name, "Mapped Reads")
        XCTAssertTrue(result.trackInfo.sourcePath.hasPrefix("alignments/filtered/"))

        let manifest = try BundleManifest.load(from: fixture.bundleURL)
        XCTAssertEqual(manifest.alignments.count, 2)
        XCTAssertTrue(manifest.alignments.contains(where: { $0.id == fixture.sourceTrackID }))
        XCTAssertTrue(manifest.alignments.contains(where: { $0.id == result.trackInfo.id }))

        let metadataURL = fixture.bundleURL.appendingPathComponent(try XCTUnwrap(result.trackInfo.metadataDBPath))
        let metadataDB = try AlignmentMetadataDatabase.openForUpdate(at: metadataURL)
        XCTAssertEqual(metadataDB.getFileInfo("derivation_kind"), "filtered_alignment")
        XCTAssertEqual(metadataDB.getFileInfo("derivation_source_track_id"), fixture.sourceTrackID)
        XCTAssertEqual(metadataDB.getFileInfo("derivation_target_kind"), "bundle")
        XCTAssertEqual(metadataDB.provenanceHistory().map(\.subcommand), ["view", "sort", "index"])
        XCTAssertTrue(metadataDB.getFileInfo("derivation_command_chain")?.contains("samtools view") == true)

        let runComplete = try XCTUnwrap(lines.compactMap(decodeEvent).first(where: { $0.event == "runComplete" }))
        XCTAssertEqual(runComplete.bundlePath, fixture.bundleURL.path)
        XCTAssertNil(runComplete.mappingResultPath)
        XCTAssertEqual(runComplete.sourceAlignmentTrackID, fixture.sourceTrackID)
        XCTAssertEqual(runComplete.outputAlignmentTrackID, result.trackInfo.id)
    }

    func testMappingResultFilteringWritesIntoViewerBundleOnly() async throws {
        let managedHome = try ManagedSamtoolsHome.makeReal(rootURL: tempDir)
        let fixture = try BundleAlignmentFixture.make(
            rootURL: tempDir,
            samtoolsPath: managedHome.samtoolsPath,
            includeMappingResult: true
        )
        let mappingResultURL = try XCTUnwrap(fixture.mappingResultURL)

        let command = try BAMCommand.FilterSubcommand.parse([
            "filter",
            "--mapping-result", mappingResultURL.path,
            "--alignment-track", fixture.sourceTrackID,
            "--output-track-name", "Primary Reads",
            "--primary-only",
        ])

        var lines: [String] = []
        let result = try await command.executeForTesting(
            runtime: makeRuntime(homeDirectory: managedHome.homeURL)
        ) { lines.append($0) }

        XCTAssertEqual(result.bundleURL, fixture.bundleURL)
        XCTAssertEqual(result.mappingResultURL, mappingResultURL)

        let mappingResultContents = try FileManager.default.contentsOfDirectory(
            atPath: mappingResultURL.path
        ).sorted()
        XCTAssertEqual(mappingResultContents, ["mapping-result.json"])

        let manifest = try BundleManifest.load(from: fixture.bundleURL)
        XCTAssertEqual(manifest.alignments.count, 2)
        XCTAssertTrue(manifest.alignments.contains(where: { $0.id == result.trackInfo.id }))

        let metadataURL = fixture.bundleURL.appendingPathComponent(try XCTUnwrap(result.trackInfo.metadataDBPath))
        let metadataDB = try AlignmentMetadataDatabase.openForUpdate(at: metadataURL)
        XCTAssertEqual(metadataDB.getFileInfo("derivation_target_kind"), "mapping_result")
        XCTAssertEqual(metadataDB.getFileInfo("derivation_mapping_result_path"), mappingResultURL.path)
        XCTAssertEqual(metadataDB.provenanceHistory().map(\.subcommand), ["view", "sort", "index"])

        XCTAssertTrue(lines.contains("Mapping result: \(mappingResultURL.path)"))
        XCTAssertTrue(
            FileManager.default.fileExists(
                atPath: fixture.bundleURL.appendingPathComponent(result.trackInfo.sourcePath).path
            )
        )
    }

    private func makeRuntime(homeDirectory: URL) -> BAMCommand.FilterSubcommand.Runtime {
        let toolRunner = NativeToolRunner(toolsDirectory: nil, homeDirectory: homeDirectory)
        let samtoolsRunner = NativeToolSamtoolsRunner(runner: toolRunner)
        let service = BundleAlignmentFilterService(samtoolsRunner: samtoolsRunner)

        return BAMCommand.FilterSubcommand.Runtime(
            runFilter: { target, sourceTrackID, outputTrackName, request in
                try await service.deriveFilteredAlignment(
                    target: target,
                    sourceTrackID: sourceTrackID,
                    outputTrackName: outputTrackName,
                    filterRequest: request
                )
            }
        )
    }
}

private func decodeEvent(_ line: String) -> BAMCommand.FilterEvent? {
    guard let data = line.data(using: .utf8) else {
        return nil
    }
    return try? JSONDecoder().decode(BAMCommand.FilterEvent.self, from: data)
}
