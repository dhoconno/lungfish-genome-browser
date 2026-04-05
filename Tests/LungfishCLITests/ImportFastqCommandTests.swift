// ImportFastqCommandTests.swift - Tests for the `lungfish import fastq` CLI subcommand
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import ArgumentParser
import XCTest
@testable import LungfishCLI

final class ImportFastqCommandTests: XCTestCase {

    func testParseMinimalArguments() throws {
        let command = try ImportCommand.FastqSubcommand.parse([
            "/data/fastq_dir",
            "--project", "/projects/Test.lungfish",
        ])
        XCTAssertEqual(command.input, ["/data/fastq_dir"])
        XCTAssertEqual(command.project, "/projects/Test.lungfish")
        XCTAssertEqual(command.recipe, "none")
        XCTAssertFalse(command.dryRun)
    }

    func testParseExplicitFilePaths() throws {
        let command = try ImportCommand.FastqSubcommand.parse([
            "/data/sample_R1.fastq.gz",
            "/data/sample_R2.fastq.gz",
            "--project", "/projects/Test.lungfish",
        ])
        XCTAssertEqual(command.input, ["/data/sample_R1.fastq.gz", "/data/sample_R2.fastq.gz"])
        XCTAssertEqual(command.project, "/projects/Test.lungfish")
    }

    func testParseSingleFilePath() throws {
        let command = try ImportCommand.FastqSubcommand.parse([
            "/data/reads.fastq.gz",
            "--project", "/projects/Test.lungfish",
        ])
        XCTAssertEqual(command.input, ["/data/reads.fastq.gz"])
    }

    func testParseFullArguments() throws {
        let command = try ImportCommand.FastqSubcommand.parse([
            "/data/fastq_dir",
            "--project", "/projects/Test.lungfish",
            "--recipe", "vsp2",
            "--quality-binning", "illumina4",
            "--threads", "16",
            "--log-dir", "/tmp/logs",
            "--dry-run",
        ])
        XCTAssertEqual(command.recipe, "vsp2")
        XCTAssertEqual(command.qualityBinning, "illumina4")
        XCTAssertEqual(command.threads, 16)
        XCTAssertEqual(command.logDir, "/tmp/logs")
        XCTAssertTrue(command.dryRun)
    }

    func testParseDefaultThreads() throws {
        let command = try ImportCommand.FastqSubcommand.parse([
            "/data/fastq_dir",
            "--project", "/projects/Test.lungfish",
        ])
        XCTAssertNil(command.threads)
    }

    func testParseDefaultQualityBinning() throws {
        let command = try ImportCommand.FastqSubcommand.parse([
            "/data/fastq_dir",
            "--project", "/projects/Test.lungfish",
        ])
        XCTAssertEqual(command.qualityBinning, "illumina4")
    }

    func testParseShortProjectFlag() throws {
        let command = try ImportCommand.FastqSubcommand.parse([
            "/data/fastq_dir",
            "-p", "/projects/Test.lungfish",
        ])
        XCTAssertEqual(command.project, "/projects/Test.lungfish")
    }

    func testParseNewFlags() throws {
        let command = try ImportCommand.FastqSubcommand.parse([
            "/data/fastq_dir",
            "--project", "/projects/Test.lungfish",
            "--platform", "illumina",
            "--recipe", "vsp2",
            "--no-optimize-storage",
            "--compression", "maximum",
            "--force",
        ])
        XCTAssertEqual(command.platform, "illumina")
        XCTAssertTrue(command.noOptimizeStorage)
        XCTAssertEqual(command.compression, "maximum")
        XCTAssertTrue(command.force)
    }

    func testParseDefaultNewFlags() throws {
        let command = try ImportCommand.FastqSubcommand.parse([
            "/data/fastq_dir",
            "--project", "/projects/Test.lungfish",
        ])
        XCTAssertNil(command.platform)
        XCTAssertFalse(command.noOptimizeStorage)
        XCTAssertEqual(command.compression, "balanced")
        XCTAssertFalse(command.force)
    }

    func testParsePlatformONT() throws {
        let command = try ImportCommand.FastqSubcommand.parse([
            "/data/fastq_dir",
            "--project", "/projects/Test.lungfish",
            "--platform", "ont",
        ])
        XCTAssertEqual(command.platform, "ont")
    }

    func testParsePlatformPacBio() throws {
        let command = try ImportCommand.FastqSubcommand.parse([
            "/data/fastq_dir",
            "--project", "/projects/Test.lungfish",
            "--platform", "pacbio",
        ])
        XCTAssertEqual(command.platform, "pacbio")
    }

    func testParseCompressionFast() throws {
        let command = try ImportCommand.FastqSubcommand.parse([
            "/data/fastq_dir",
            "--project", "/projects/Test.lungfish",
            "--compression", "fast",
        ])
        XCTAssertEqual(command.compression, "fast")
    }

    func testParseAllFlagsCombined() throws {
        let command = try ImportCommand.FastqSubcommand.parse([
            "/data/fastq_dir",
            "--project", "/projects/Test.lungfish",
            "--platform", "ultima",
            "--recipe", "vsp2",
            "--quality-binning", "none",
            "--no-optimize-storage",
            "--compression", "fast",
            "--threads", "4",
            "--log-dir", "/tmp/logs",
            "--force",
            "--dry-run",
        ])
        XCTAssertEqual(command.platform, "ultima")
        XCTAssertEqual(command.recipe, "vsp2")
        XCTAssertEqual(command.qualityBinning, "none")
        XCTAssertTrue(command.noOptimizeStorage)
        XCTAssertEqual(command.compression, "fast")
        XCTAssertEqual(command.threads, 4)
        XCTAssertEqual(command.logDir, "/tmp/logs")
        XCTAssertTrue(command.force)
        XCTAssertTrue(command.dryRun)
    }
}
