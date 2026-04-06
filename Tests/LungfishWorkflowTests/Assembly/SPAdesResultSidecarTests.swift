// SPAdesResultSidecarTests.swift - Tests for SPAdes assembly result persistence
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishWorkflow
import LungfishIO

final class SPAdesResultSidecarTests: XCTestCase {
    private var tempDir: URL!

    override func setUp() {
        super.setUp()
        tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("test-spades-sidecar-\(UUID().uuidString)")
        try! FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: tempDir)
        super.tearDown()
    }

    /// Creates AssemblyStatistics via the public calculator API (the struct's memberwise
    /// init is internal; this is the correct public-API path for cross-module construction).
    private func makeStatistics(contigLengths: [Int64] = [250_000, 200_000, 100_000, 50_000, 5_000]) -> AssemblyStatistics {
        AssemblyStatisticsCalculator.computeFromLengths(contigLengths)
    }

    private func makeResult() -> SPAdesAssemblyResult {
        let statistics = makeStatistics()
        return SPAdesAssemblyResult(
            contigsPath: tempDir.appendingPathComponent("contigs.fasta"),
            scaffoldsPath: tempDir.appendingPathComponent("scaffolds.fasta"),
            graphPath: tempDir.appendingPathComponent("assembly_graph.gfa"),
            logPath: tempDir.appendingPathComponent("spades.log"),
            paramsPath: tempDir.appendingPathComponent("params.txt"),
            statistics: statistics,
            spadesVersion: "4.0.0",
            wallTimeSeconds: 182.5,
            commandLine: "spades.py --meta -1 reads_1.fastq -2 reads_2.fastq -o out",
            exitCode: 0
        )
    }

    func testExistsReturnsFalseForMissingFile() {
        XCTAssertFalse(SPAdesAssemblyResult.exists(in: tempDir))
    }

    func testExistsReturnsTrueAfterSave() throws {
        let result = makeResult()
        try result.save(to: tempDir)
        XCTAssertTrue(SPAdesAssemblyResult.exists(in: tempDir))
    }

    func testSaveWritesJSONFile() throws {
        let result = makeResult()
        try result.save(to: tempDir)
        let jsonURL = tempDir.appendingPathComponent("assembly-result.json")
        XCTAssertTrue(FileManager.default.fileExists(atPath: jsonURL.path))
        let data = try Data(contentsOf: jsonURL)
        XCTAssertGreaterThan(data.count, 0)
    }

    func testSaveAndLoadRoundTrip() throws {
        let original = makeResult()
        try original.save(to: tempDir)
        let loaded = try SPAdesAssemblyResult.load(from: tempDir)

        // File paths should point into tempDir
        XCTAssertEqual(loaded.contigsPath.lastPathComponent, "contigs.fasta")
        XCTAssertEqual(loaded.scaffoldsPath?.lastPathComponent, "scaffolds.fasta")
        XCTAssertEqual(loaded.graphPath?.lastPathComponent, "assembly_graph.gfa")
        XCTAssertEqual(loaded.logPath.lastPathComponent, "spades.log")
        XCTAssertEqual(loaded.paramsPath?.lastPathComponent, "params.txt")

        // Statistics (computed from [250_000, 200_000, 100_000, 50_000, 5_000])
        let expectedStats = makeStatistics()
        XCTAssertEqual(loaded.statistics.contigCount, expectedStats.contigCount)
        XCTAssertEqual(loaded.statistics.totalLengthBP, expectedStats.totalLengthBP)
        XCTAssertEqual(loaded.statistics.largestContigBP, expectedStats.largestContigBP)
        XCTAssertEqual(loaded.statistics.smallestContigBP, expectedStats.smallestContigBP)
        XCTAssertEqual(loaded.statistics.n50, expectedStats.n50)
        XCTAssertEqual(loaded.statistics.l50, expectedStats.l50)
        XCTAssertEqual(loaded.statistics.n90, expectedStats.n90)
        XCTAssertEqual(loaded.statistics.gcFraction, expectedStats.gcFraction, accuracy: 1e-9)
        XCTAssertEqual(loaded.statistics.meanLengthBP, expectedStats.meanLengthBP, accuracy: 1e-6)
        // Full equality via Equatable
        XCTAssertEqual(loaded.statistics, expectedStats)

        // Metadata
        XCTAssertEqual(loaded.spadesVersion, "4.0.0")
        XCTAssertEqual(loaded.wallTimeSeconds, 182.5, accuracy: 1e-9)
        XCTAssertEqual(loaded.commandLine, "spades.py --meta -1 reads_1.fastq -2 reads_2.fastq -o out")
        XCTAssertEqual(loaded.exitCode, 0)
    }

    func testLoadThrowsWhenSidecarMissing() {
        XCTAssertThrowsError(try SPAdesAssemblyResult.load(from: tempDir)) { error in
            XCTAssertTrue(error is SPAdesResultLoadError)
        }
    }

    func testNilOptionalFieldsRoundTrip() throws {
        let statistics = makeStatistics(contigLengths: [5_000, 3_000, 1_000, 500, 500])
        let result = SPAdesAssemblyResult(
            contigsPath: tempDir.appendingPathComponent("contigs.fasta"),
            scaffoldsPath: nil,
            graphPath: nil,
            logPath: tempDir.appendingPathComponent("spades.log"),
            paramsPath: nil,
            statistics: statistics,
            spadesVersion: nil,
            wallTimeSeconds: 10.0,
            commandLine: "spades.py -s reads.fastq -o out",
            exitCode: 0
        )
        try result.save(to: tempDir)
        let loaded = try SPAdesAssemblyResult.load(from: tempDir)
        XCTAssertNil(loaded.scaffoldsPath)
        XCTAssertNil(loaded.graphPath)
        XCTAssertNil(loaded.paramsPath)
        XCTAssertNil(loaded.spadesVersion)
    }
}
