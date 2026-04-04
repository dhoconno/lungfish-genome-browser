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
        XCTAssertEqual(command.input, "/data/fastq_dir")
        XCTAssertEqual(command.project, "/projects/Test.lungfish")
        XCTAssertEqual(command.recipe, "none")
        XCTAssertFalse(command.dryRun)
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
}
