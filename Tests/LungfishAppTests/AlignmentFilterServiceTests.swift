// AlignmentFilterServiceTests.swift - Tests for bundle-centric BAM filtering
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishApp
@testable import LungfishCore
@testable import LungfishIO
@testable import LungfishWorkflow

final class AlignmentFilterServiceTests: XCTestCase {

    private var tempDir: URL!

    override func setUp() async throws {
        tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("AlignmentFilterServiceTests-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
    }

    override func tearDown() async throws {
        if let tempDir {
            try? FileManager.default.removeItem(at: tempDir)
        }
    }

    func testFilterAlignmentFailsWhenNMTagIsRequiredButMissing() async throws {
        let bundle = try makeBundleFixture()
        let selectionArgs = ["-F", "0x4", "-q", "20"]
        let region = "chr1:1-10"
        let totalCountCommand = ["view", "-c"] + selectionArgs + [bundle.sourceBAMURL.path, region]
        let taggedCountCommand = ["view", "-c"] + selectionArgs + ["-e", "exists([NM])", bundle.sourceBAMURL.path, region]
        let runner = FilterServiceRecordingSamtoolsRunner(
            countResponses: [
                FilterServiceRecordingSamtoolsRunner.responseKey(for: totalCountCommand): 12,
                FilterServiceRecordingSamtoolsRunner.responseKey(for: taggedCountCommand): 0
            ]
        )
        let markdupPipeline = FilterServiceRecordingMarkdupPipeline()
        let importer = FilterServiceRecordingImporter(result: makeImportResult(trackID: "derived"))
        let service = AlignmentFilterService(
            samtoolsRunner: runner,
            markdupPipeline: markdupPipeline,
            bamImporter: importer
        )

        do {
            _ = try await service.deriveFilteredAlignment(
                bundleURL: bundle.bundleURL,
                sourceTrackID: bundle.sourceTrack.id,
                outputTrackName: "Exact matches",
                filterRequest: AlignmentFilterRequest(
                    mappedOnly: true,
                    minimumMAPQ: 20,
                    identityFilter: .exactMatch,
                    region: region
                ),
                progressHandler: nil as (@Sendable (Double, String) -> Void)?
            )
            XCTFail("Expected missing-tag failure")
        } catch let error as AlignmentFilterServiceError {
            guard case .missingRequiredSAMTags(let tags, let sourceTrackID) = error else {
                return XCTFail("Unexpected error: \(error)")
            }
            XCTAssertEqual(tags, ["NM"])
            XCTAssertEqual(sourceTrackID, bundle.sourceTrack.id)
        }

        let commands = await runner.commands
        let markdupInvocations = await markdupPipeline.invocations
        let importedBAMURLs = await importer.importedBAMURLs
        XCTAssertEqual(commands, [
            totalCountCommand,
            taggedCountCommand
        ])
        XCTAssertEqual(markdupInvocations.count, 0)
        XCTAssertEqual(importedBAMURLs.count, 0)
    }

    func testFilterAlignmentRunsDuplicatePreprocessingBeforeViewStepForRemoveMode() async throws {
        let bundle = try makeBundleFixture()
        let runner = FilterServiceRecordingSamtoolsRunner()
        let markdupOutputURL = tempDir.appendingPathComponent("preprocessed/marked.bam")
        let markdupPipeline = FilterServiceRecordingMarkdupPipeline(outputURL: markdupOutputURL)
        let importer = FilterServiceRecordingImporter(result: makeImportResult(trackID: "derived"))
        let service = AlignmentFilterService(
            samtoolsRunner: runner,
            markdupPipeline: markdupPipeline,
            bamImporter: importer
        )

        let result = try await service.deriveFilteredAlignment(
            bundleURL: bundle.bundleURL,
            sourceTrackID: bundle.sourceTrack.id,
            outputTrackName: "Removed duplicates",
            filterRequest: AlignmentFilterRequest(duplicateMode: .remove),
            progressHandler: nil
        )

        let markdupInvocations = await markdupPipeline.invocations
        XCTAssertEqual(markdupInvocations.count, 1)
        XCTAssertEqual(markdupInvocations[0].inputURL, bundle.sourceBAMURL)
        XCTAssertFalse(markdupInvocations[0].removeDuplicates)

        let commands = await runner.commands
        guard let viewCommand = commands.first(where: { $0.first == "view" && !$0.contains("-c") }) else {
            return XCTFail("Expected view command")
        }
        XCTAssertEqual(Array(viewCommand.prefix(5)), ["view", "-b", "-F", "0x400", "-o"])
        XCTAssertTrue(viewCommand.contains(markdupOutputURL.path))
        XCTAssertEqual(commands.dropFirst().first?.first, "sort")
        XCTAssertEqual(commands.dropFirst(2).first?.first, "index")

        let importedBAMs = await importer.importedBAMURLs
        XCTAssertEqual(importedBAMs.count, 1)
        XCTAssertEqual(importedBAMs[0].lastPathComponent, "source-track.filtered.sorted.bam")
        XCTAssertTrue(result.importResult.trackInfo.sourcePath.hasPrefix("alignments/filtered/"))
        XCTAssertTrue(result.importResult.trackInfo.indexPath.hasPrefix("alignments/filtered/"))
        XCTAssertTrue(result.importResult.trackInfo.metadataDBPath?.hasPrefix("alignments/filtered/") ?? false)

        let manifest = try BundleManifest.load(from: bundle.bundleURL)
        guard let importedTrack = manifest.alignments.first(where: { $0.id == result.importResult.trackInfo.id }) else {
            return XCTFail("Expected imported track in manifest")
        }
        XCTAssertTrue(importedTrack.sourcePath.hasPrefix("alignments/filtered/"))
        XCTAssertTrue(importedTrack.indexPath.hasPrefix("alignments/filtered/"))
        XCTAssertTrue(importedTrack.metadataDBPath?.hasPrefix("alignments/filtered/") ?? false)

        XCTAssertTrue(
            FileManager.default.fileExists(
                atPath: bundle.bundleURL.appendingPathComponent(importedTrack.sourcePath).path
            )
        )
        XCTAssertFalse(
            FileManager.default.fileExists(
                atPath: bundle.bundleURL.appendingPathComponent("alignments/derived.bam").path
            )
        )

        let metadataDB = try XCTUnwrap(
            AlignmentMetadataDatabase(url: bundle.bundleURL.appendingPathComponent(importedTrack.metadataDBPath!))
        )
        XCTAssertEqual(metadataDB.getFileInfo("source_path_in_bundle"), importedTrack.sourcePath)
        XCTAssertEqual(metadataDB.getFileInfo("file_name"), URL(fileURLWithPath: importedTrack.sourcePath).lastPathComponent)
    }

    func testFilterAlignmentRollsBackCopiedFilteredFilesWhenManifestSaveFails() async throws {
        let bundle = try makeBundleFixture()
        let runner = FilterServiceRecordingSamtoolsRunner()
        let importer = FilterServiceRecordingImporter(result: makeImportResult(trackID: "derived"))
        let manifestWriter = FailingAlignmentManifestWriter()
        let service = AlignmentFilterService(
            samtoolsRunner: runner,
            bamImporter: importer,
            manifestWriter: manifestWriter
        )

        do {
            _ = try await service.deriveFilteredAlignment(
                bundleURL: bundle.bundleURL,
                sourceTrackID: bundle.sourceTrack.id,
                outputTrackName: "Filtered",
                filterRequest: AlignmentFilterRequest(),
                progressHandler: nil
            )
            XCTFail("Expected manifest writer failure")
        } catch {
            let rootBAMURL = bundle.bundleURL.appendingPathComponent("alignments/derived.bam")
            let rootIndexURL = bundle.bundleURL.appendingPathComponent("alignments/derived.bam.bai")
            let rootDBURL = bundle.bundleURL.appendingPathComponent("alignments/derived.stats.db")
            let filteredBAMURL = bundle.bundleURL.appendingPathComponent("alignments/filtered/derived.bam")
            let filteredIndexURL = bundle.bundleURL.appendingPathComponent("alignments/filtered/derived.bam.bai")
            let filteredDBURL = bundle.bundleURL.appendingPathComponent("alignments/filtered/derived.stats.db")

            XCTAssertTrue(FileManager.default.fileExists(atPath: rootBAMURL.path))
            XCTAssertTrue(FileManager.default.fileExists(atPath: rootIndexURL.path))
            XCTAssertTrue(FileManager.default.fileExists(atPath: rootDBURL.path))
            XCTAssertFalse(FileManager.default.fileExists(atPath: filteredBAMURL.path))
            XCTAssertFalse(FileManager.default.fileExists(atPath: filteredIndexURL.path))
            XCTAssertFalse(FileManager.default.fileExists(atPath: filteredDBURL.path))

            let manifest = try BundleManifest.load(from: bundle.bundleURL)
            let importedTrack = try XCTUnwrap(manifest.alignments.first(where: { $0.id == "derived" }))
            XCTAssertEqual(importedTrack.sourcePath, "alignments/derived.bam")
            XCTAssertEqual(importedTrack.indexPath, "alignments/derived.bam.bai")
            XCTAssertEqual(importedTrack.metadataDBPath, "alignments/derived.stats.db")
        }
    }

    func testFilterAlignmentWrapsMarkdupPreprocessingFailuresIntoFilterServiceError() async throws {
        let bundle = try makeBundleFixture()
        let runner = FilterServiceRecordingSamtoolsRunner()
        let markdupPipeline = FailingFilterServiceMarkdupPipeline(error: AlignmentDuplicateError.samtoolsFailed("markdup failed"))
        let importer = FilterServiceRecordingImporter(result: makeImportResult(trackID: "derived"))
        let service = AlignmentFilterService(
            samtoolsRunner: runner,
            markdupPipeline: markdupPipeline,
            bamImporter: importer
        )

        do {
            _ = try await service.deriveFilteredAlignment(
                bundleURL: bundle.bundleURL,
                sourceTrackID: bundle.sourceTrack.id,
                outputTrackName: "Filtered",
                filterRequest: AlignmentFilterRequest(duplicateMode: .remove),
                progressHandler: nil
            )
            XCTFail("Expected preprocessing failure")
        } catch let error as AlignmentFilterServiceError {
            guard case .preprocessingFailed(let message) = error else {
                return XCTFail("Unexpected filter-service error: \(error)")
            }
            XCTAssertTrue(message.contains("markdup failed"))
        }
    }

    private func makeBundleFixture() throws -> BundleFixture {
        let bundleURL = tempDir.appendingPathComponent("fixture.lungfishref", isDirectory: true)
        let alignmentsURL = bundleURL.appendingPathComponent("alignments", isDirectory: true)
        let genomeURL = bundleURL.appendingPathComponent("genome", isDirectory: true)
        try FileManager.default.createDirectory(at: alignmentsURL, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: genomeURL, withIntermediateDirectories: true)

        let sourceBAMURL = alignmentsURL.appendingPathComponent("source.bam")
        let sourceIndexURL = alignmentsURL.appendingPathComponent("source.bam.bai")
        try Data("bam".utf8).write(to: sourceBAMURL)
        try Data("bai".utf8).write(to: sourceIndexURL)

        let fastaURL = genomeURL.appendingPathComponent("sequence.fa.gz")
        let fastaIndexURL = genomeURL.appendingPathComponent("sequence.fa.gz.fai")
        try Data(">chr1\nACGT\n".utf8).write(to: fastaURL)
        try Data("chr1\t4\t6\t4\t5\n".utf8).write(to: fastaIndexURL)

        let sourceTrack = AlignmentTrackInfo(
            id: "source-track",
            name: "Source Track",
            format: .bam,
            sourcePath: "alignments/source.bam",
            indexPath: "alignments/source.bam.bai"
        )
        let manifest = BundleManifest(
            name: "Fixture",
            identifier: "org.lungfish.tests.fixture",
            source: SourceInfo(organism: "Test organism", assembly: "fixture"),
            genome: GenomeInfo(
                path: "genome/sequence.fa.gz",
                indexPath: "genome/sequence.fa.gz.fai",
                totalLength: 4,
                chromosomes: [
                    ChromosomeInfo(name: "chr1", length: 4, offset: 0, lineBases: 4, lineWidth: 5)
                ]
            ),
            alignments: [sourceTrack]
        )
        try manifest.save(to: bundleURL)

        return BundleFixture(
            bundleURL: bundleURL,
            sourceTrack: sourceTrack,
            sourceBAMURL: sourceBAMURL
        )
    }

    private func makeImportResult(trackID: String) -> BAMImportService.ImportResult {
        let trackInfo = AlignmentTrackInfo(
            id: trackID,
            name: "Derived",
            format: .bam,
            sourcePath: "alignments/\(trackID).bam",
            indexPath: "alignments/\(trackID).bam.bai",
            metadataDBPath: "alignments/\(trackID).stats.db"
        )
        return BAMImportService.ImportResult(
            trackInfo: trackInfo,
            mappedReads: 0,
            unmappedReads: 0,
            sampleNames: [],
            indexWasCreated: false,
            wasSorted: false
        )
    }
}

private struct BundleFixture {
    let bundleURL: URL
    let sourceTrack: AlignmentTrackInfo
    let sourceBAMURL: URL
}

private actor FilterServiceRecordingSamtoolsRunner: AlignmentSamtoolsRunning {
    private let countResponses: [String: Int]
    private(set) var commands: [[String]] = []

    init(countResponses: [String: Int] = [:]) {
        self.countResponses = countResponses
    }

    nonisolated static func responseKey(for arguments: [String]) -> String {
        arguments.joined(separator: "\u{1F}")
    }

    func runSamtools(arguments: [String], timeout: TimeInterval) async throws -> NativeToolResult {
        commands.append(arguments)

        let key = Self.responseKey(for: arguments)
        if let count = countResponses[key] {
            return NativeToolResult(exitCode: 0, stdout: "\(count)\n", stderr: "")
        }

        if let outputIndex = arguments.firstIndex(of: "-o"), outputIndex + 1 < arguments.count {
            let outputURL = URL(fileURLWithPath: arguments[outputIndex + 1])
            try FileManager.default.createDirectory(
                at: outputURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            FileManager.default.createFile(atPath: outputURL.path, contents: Data())
        } else if arguments.first == "index", arguments.count >= 2 {
            FileManager.default.createFile(atPath: arguments[1] + ".bai", contents: Data())
        }

        return NativeToolResult(exitCode: 0, stdout: "", stderr: "")
    }
}

private actor FilterServiceRecordingMarkdupPipeline: AlignmentMarkdupPipelining {
    struct Invocation: Equatable {
        let inputURL: URL
        let outputURL: URL
        let removeDuplicates: Bool
        let referenceFastaPath: String?
    }

    private let configuredOutputURL: URL?
    private(set) var invocations: [Invocation] = []

    init(outputURL: URL? = nil) {
        self.configuredOutputURL = outputURL
    }

    func run(
        inputURL: URL,
        outputURL: URL,
        removeDuplicates: Bool,
        referenceFastaPath: String?,
        progressHandler: (@Sendable (Double, String) -> Void)?
    ) async throws -> AlignmentMarkdupPipelineResult {
        let effectiveOutputURL = configuredOutputURL ?? outputURL
        invocations.append(
            Invocation(
                inputURL: inputURL,
                outputURL: effectiveOutputURL,
                removeDuplicates: removeDuplicates,
                referenceFastaPath: referenceFastaPath
            )
        )

        try FileManager.default.createDirectory(
            at: effectiveOutputURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        FileManager.default.createFile(atPath: effectiveOutputURL.path, contents: Data())
        FileManager.default.createFile(atPath: effectiveOutputURL.path + ".bai", contents: Data())

        return AlignmentMarkdupPipelineResult(
            outputURL: effectiveOutputURL,
            indexURL: URL(fileURLWithPath: effectiveOutputURL.path + ".bai"),
            intermediateFiles: .init(
                nameSortedBAM: effectiveOutputURL.deletingLastPathComponent().appendingPathComponent("name.sorted.bam"),
                fixmateBAM: effectiveOutputURL.deletingLastPathComponent().appendingPathComponent("fixmate.bam"),
                coordinateSortedBAM: effectiveOutputURL.deletingLastPathComponent().appendingPathComponent("coord.sorted.bam")
            ),
            commandHistory: []
        )
    }
}

private actor FilterServiceRecordingImporter: AlignmentBAMImporting {
    private let result: BAMImportService.ImportResult
    private(set) var importedBAMURLs: [URL] = []

    init(result: BAMImportService.ImportResult) {
        self.result = result
    }

    func importBAM(
        bamURL: URL,
        bundleURL: URL,
        name: String?,
        progressHandler: (@Sendable (Double, String) -> Void)?
    ) async throws -> BAMImportService.ImportResult {
        importedBAMURLs.append(bamURL)
        try FileManager.default.createDirectory(
            at: bundleURL.appendingPathComponent("alignments"),
            withIntermediateDirectories: true
        )

        let importedTrack = result.trackInfo
        let sourceURL = bundleURL.appendingPathComponent(importedTrack.sourcePath)
        let indexURL = bundleURL.appendingPathComponent(importedTrack.indexPath)
        let dbURL = bundleURL.appendingPathComponent(importedTrack.metadataDBPath!)
        FileManager.default.createFile(atPath: sourceURL.path, contents: Data("bam".utf8))
        FileManager.default.createFile(atPath: indexURL.path, contents: Data("bai".utf8))

        let metadataDB = try AlignmentMetadataDatabase.create(at: dbURL)
        metadataDB.setFileInfo("source_path", value: sourceURL.path)
        metadataDB.setFileInfo("source_path_in_bundle", value: importedTrack.sourcePath)
        metadataDB.setFileInfo("file_name", value: sourceURL.lastPathComponent)

        let manifest = try BundleManifest.load(from: bundleURL)
        try manifest.addingAlignmentTrack(importedTrack).save(to: bundleURL)
        return result
    }
}

private struct FailingFilterServiceMarkdupPipeline: AlignmentMarkdupPipelining {
    let error: Error

    func run(
        inputURL: URL,
        outputURL: URL,
        removeDuplicates: Bool,
        referenceFastaPath: String?,
        progressHandler: (@Sendable (Double, String) -> Void)?
    ) async throws -> AlignmentMarkdupPipelineResult {
        throw error
    }
}

private struct FailingAlignmentManifestWriter: AlignmentBundleManifestWriting {
    func save(_ manifest: BundleManifest, to bundleURL: URL) throws {
        throw NSError(domain: "AlignmentFilterServiceTests", code: 99, userInfo: [NSLocalizedDescriptionKey: "manifest save failed"])
    }
}
