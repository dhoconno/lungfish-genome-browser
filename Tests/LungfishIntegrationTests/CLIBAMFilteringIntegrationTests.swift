import Foundation
import XCTest
import LungfishTestSupport
@testable import LungfishCLI
@testable import LungfishCore
@testable import LungfishIO

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
            "-q",
        ])

        try await managedHome.withLiveRuntimeActivation {
            try await command.run()
        }

        let manifest = try BundleManifest.load(from: fixture.bundleURL)
        XCTAssertEqual(manifest.alignments.count, 2)
        XCTAssertTrue(manifest.alignments.contains(where: { $0.id == fixture.sourceTrackID }))
        let derivedTrack = try XCTUnwrap(manifest.alignments.first(where: { $0.id != fixture.sourceTrackID }))
        XCTAssertEqual(derivedTrack.name, "Mapped Reads")
        XCTAssertTrue(derivedTrack.sourcePath.hasPrefix("alignments/filtered/"))

        let metadataURL = fixture.bundleURL.appendingPathComponent(try XCTUnwrap(derivedTrack.metadataDBPath))
        let metadataDB = try AlignmentMetadataDatabase.openForUpdate(at: metadataURL)
        XCTAssertEqual(metadataDB.getFileInfo("derivation_kind"), "filtered_alignment")
        XCTAssertEqual(metadataDB.getFileInfo("derivation_source_track_id"), fixture.sourceTrackID)
        XCTAssertEqual(metadataDB.getFileInfo("derivation_target_kind"), "bundle")
        XCTAssertEqual(metadataDB.provenanceHistory().map(\.subcommand), ["view", "sort", "index"])
        XCTAssertTrue(metadataDB.getFileInfo("derivation_command_chain")?.contains("samtools view") == true)
        XCTAssertEqual(
            try bamReadNames(
                at: fixture.bundleURL.appendingPathComponent(derivedTrack.sourcePath),
                samtoolsPath: managedHome.samtoolsPath
            ),
            ["mapped-primary-highmapq", "mapped-primary-lowmapq", "mapped-secondary"]
        )
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
            "-q",
        ])

        try await managedHome.withLiveRuntimeActivation {
            try await command.run()
        }

        let mappingResultContents = try FileManager.default.contentsOfDirectory(
            atPath: mappingResultURL.path
        ).sorted()
        XCTAssertEqual(mappingResultContents, ["mapping-result.json"])

        let manifest = try BundleManifest.load(from: fixture.bundleURL)
        XCTAssertEqual(manifest.alignments.count, 2)
        let derivedTrack = try XCTUnwrap(manifest.alignments.first(where: { $0.id != fixture.sourceTrackID }))
        XCTAssertEqual(derivedTrack.name, "Primary Reads")

        let metadataURL = fixture.bundleURL.appendingPathComponent(try XCTUnwrap(derivedTrack.metadataDBPath))
        let metadataDB = try AlignmentMetadataDatabase.openForUpdate(at: metadataURL)
        XCTAssertEqual(metadataDB.getFileInfo("derivation_target_kind"), "mapping_result")
        XCTAssertEqual(metadataDB.getFileInfo("derivation_mapping_result_path"), mappingResultURL.path)
        XCTAssertEqual(metadataDB.provenanceHistory().map(\.subcommand), ["view", "sort", "index"])
        XCTAssertTrue(
            FileManager.default.fileExists(
                atPath: fixture.bundleURL.appendingPathComponent(derivedTrack.sourcePath).path
            )
        )
        XCTAssertEqual(
            try bamReadNames(
                at: fixture.bundleURL.appendingPathComponent(derivedTrack.sourcePath),
                samtoolsPath: managedHome.samtoolsPath
            ),
            ["mapped-primary-highmapq", "mapped-primary-lowmapq", "unmapped-read"]
        )
    }
}

private func bamReadNames(at bamURL: URL, samtoolsPath: URL) throws -> [String] {
    let process = Process()
    process.executableURL = samtoolsPath
    process.arguments = ["view", bamURL.path]
    let stdout = Pipe()
    let stderr = Pipe()
    process.standardOutput = stdout
    process.standardError = stderr
    try process.run()
    process.waitUntilExit()

    let stderrText = String(
        data: stderr.fileHandleForReading.readDataToEndOfFile(),
        encoding: .utf8
    ) ?? ""
    XCTAssertEqual(process.terminationStatus, 0, "samtools view failed: \(stderrText)")

    let output = String(
        data: stdout.fileHandleForReading.readDataToEndOfFile(),
        encoding: .utf8
    ) ?? ""
    return output
        .split(separator: "\n")
        .compactMap { line in
            line.split(separator: "\t", omittingEmptySubsequences: false).first.map(String.init)
        }
}
