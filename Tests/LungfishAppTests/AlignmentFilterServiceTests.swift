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
        let runner = FilterServiceRecordingSamtoolsRunner(totalCount: 12, taggedCount: 0)
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
                filterRequest: AlignmentFilterRequest(identityFilter: .exactMatch),
                progressHandler: nil
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
            ["view", "-c", bundle.sourceBAMURL.path],
            ["view", "-c", "-e", "exists([NM])", bundle.sourceBAMURL.path]
        ])
        XCTAssertEqual(markdupInvocations.count, 0)
        XCTAssertEqual(importedBAMURLs.count, 0)
    }

    func testFilterAlignmentRunsDuplicatePreprocessingBeforeViewStepForRemoveMode() async throws {
        let bundle = try makeBundleFixture()
        let runner = FilterServiceRecordingSamtoolsRunner(totalCount: 0, taggedCount: 0)
        let markdupOutputURL = tempDir.appendingPathComponent("preprocessed/marked.bam")
        let markdupPipeline = FilterServiceRecordingMarkdupPipeline(outputURL: markdupOutputURL)
        let importer = FilterServiceRecordingImporter(result: makeImportResult(trackID: "derived"))
        let service = AlignmentFilterService(
            samtoolsRunner: runner,
            markdupPipeline: markdupPipeline,
            bamImporter: importer
        )

        _ = try await service.deriveFilteredAlignment(
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
            indexPath: "alignments/\(trackID).bam.bai"
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
    private let totalCount: Int
    private let taggedCount: Int
    private(set) var commands: [[String]] = []

    init(totalCount: Int, taggedCount: Int) {
        self.totalCount = totalCount
        self.taggedCount = taggedCount
    }

    func runSamtools(arguments: [String], timeout: TimeInterval) async throws -> NativeToolResult {
        commands.append(arguments)

        if arguments.count == 3,
           arguments[0] == "view",
           arguments[1] == "-c" {
            return NativeToolResult(exitCode: 0, stdout: "\(totalCount)\n", stderr: "")
        }
        if arguments.count >= 5,
           arguments[0] == "view",
           arguments[1] == "-c",
           arguments[2] == "-e",
           arguments[3] == "exists([NM])" {
            return NativeToolResult(exitCode: 0, stdout: "\(taggedCount)\n", stderr: "")
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
        return result
    }
}
