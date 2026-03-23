// ClassificationWizardTests.swift - Tests for ClassificationWizardSheet logic
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishWorkflow
@testable import LungfishApp

// MARK: - ClassificationWizardTests

/// Tests for the ``ClassificationWizardSheet`` configuration logic.
///
/// These tests verify the data-layer behavior of the wizard without rendering
/// SwiftUI views. They test goal options, preset mappings, database selection,
/// and configuration generation.
final class ClassificationWizardTests: XCTestCase {

    // MARK: - Test Fixtures

    private let tempDir = FileManager.default.temporaryDirectory
        .appendingPathComponent("wizard-test-\(UUID().uuidString)")

    override func setUpWithError() throws {
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
    }

    override func tearDownWithError() throws {
        try? FileManager.default.removeItem(at: tempDir)
    }

    /// Creates a fake database info entry for testing.
    private func makeDatabaseInfo(
        name: String,
        status: DatabaseStatus = .ready,
        sizeBytes: Int64 = 8 * 1_073_741_824
    ) -> MetagenomicsDatabaseInfo {
        MetagenomicsDatabaseInfo(
            name: name,
            tool: "kraken2",
            version: "2024-09-04",
            sizeBytes: sizeBytes,
            sizeOnDisk: sizeBytes,
            downloadURL: nil,
            description: "Test database",
            collection: nil,
            path: status == .ready ? tempDir.appendingPathComponent(name) : nil,
            isExternal: false,
            bookmarkData: nil,
            lastUpdated: Date(),
            status: status,
            recommendedRAM: sizeBytes
        )
    }

    // MARK: - testGoalOptions

    /// Verifies that all three classification goals are available.
    func testGoalOptions() {
        let goals = ClassificationWizardSheet.ClassificationGoal.allCases

        XCTAssertEqual(goals.count, 3)
        XCTAssertTrue(goals.contains(.classify))
        XCTAssertTrue(goals.contains(.profile))
        XCTAssertTrue(goals.contains(.extract))
    }

    /// Verifies that each goal has a unique SF Symbol name.
    func testGoalSymbolNames() {
        let goals = ClassificationWizardSheet.ClassificationGoal.allCases
        let symbols = goals.map(\.symbolName)

        XCTAssertEqual(Set(symbols).count, 3, "Each goal should have a unique symbol")
        XCTAssertTrue(symbols.contains("magnifyingglass"))
        XCTAssertTrue(symbols.contains("chart.pie"))
        XCTAssertTrue(symbols.contains("scissors"))
    }

    /// Verifies that each goal has a non-empty description.
    func testGoalDescriptions() {
        for goal in ClassificationWizardSheet.ClassificationGoal.allCases {
            XCTAssertFalse(goal.goalDescription.isEmpty, "\(goal) should have a description")
            XCTAssertFalse(goal.rawValue.isEmpty, "\(goal) should have a display name")
        }
    }

    // MARK: - testPresetMapping

    /// Verifies that each preset maps to expected confidence and hit group values.
    func testPresetMapping() {
        let sensitive = ClassificationConfig.Preset.sensitive.parameters
        XCTAssertEqual(sensitive.confidence, 0.0)
        XCTAssertEqual(sensitive.minimumHitGroups, 1)

        let balanced = ClassificationConfig.Preset.balanced.parameters
        XCTAssertEqual(balanced.confidence, 0.2)
        XCTAssertEqual(balanced.minimumHitGroups, 2)

        let precise = ClassificationConfig.Preset.precise.parameters
        XCTAssertEqual(precise.confidence, 0.5)
        XCTAssertEqual(precise.minimumHitGroups, 3)
    }

    /// Verifies that all presets are available via CaseIterable.
    func testPresetCaseIterable() {
        let presets = ClassificationConfig.Preset.allCases
        XCTAssertEqual(presets.count, 3)
        XCTAssertTrue(presets.contains(.sensitive))
        XCTAssertTrue(presets.contains(.balanced))
        XCTAssertTrue(presets.contains(.precise))
    }

    // MARK: - testDatabaseSelection

    /// Verifies that databases with ready status are selectable.
    func testDatabaseSelectionReady() {
        let readyDB = makeDatabaseInfo(name: "Standard-8", status: .ready)
        let missingDB = makeDatabaseInfo(name: "PlusPF", status: .missing)

        let databases = [readyDB, missingDB]
        let readyDatabases = databases.filter { $0.status == .ready }

        XCTAssertEqual(readyDatabases.count, 1)
        XCTAssertEqual(readyDatabases.first?.name, "Standard-8")
    }

    /// Verifies that the first ready database is selected by default.
    func testDatabaseDefaultSelection() {
        let db1 = makeDatabaseInfo(name: "Viral", status: .ready, sizeBytes: 536_870_912)
        let db2 = makeDatabaseInfo(name: "Standard-8", status: .ready)

        let databases = [db1, db2]
        let defaultDB = databases.first(where: { $0.status == .ready })?.name

        XCTAssertEqual(defaultDB, "Viral", "First ready database should be selected by default")
    }

    // MARK: - testAdvancedSettingsCollapsed

    /// Verifies that advanced settings default to collapsed state with balanced preset values.
    func testAdvancedSettingsDefaults() {
        // The wizard initializes with .balanced preset
        let balanced = ClassificationConfig.Preset.balanced.parameters

        // These values should be the defaults when the sheet opens
        XCTAssertEqual(balanced.confidence, 0.2)
        XCTAssertEqual(balanced.minimumHitGroups, 2)
    }

    // MARK: - testConfigGeneration

    /// Verifies that a ClassificationConfig is correctly generated from wizard state.
    func testConfigGeneration() throws {
        let dbPath = tempDir.appendingPathComponent("test-db")
        try FileManager.default.createDirectory(at: dbPath, withIntermediateDirectories: true)

        let inputFile = tempDir.appendingPathComponent("input.fastq")
        try "test".write(to: inputFile, atomically: true, encoding: .utf8)

        let outputDir = tempDir.appendingPathComponent("output")

        let config = ClassificationConfig(
            inputFiles: [inputFile],
            isPairedEnd: false,
            databaseName: "Standard-8",
            databasePath: dbPath,
            confidence: 0.2,
            minimumHitGroups: 2,
            threads: 4,
            memoryMapping: false,
            quickMode: false,
            outputDirectory: outputDir
        )

        XCTAssertEqual(config.inputFiles.count, 1)
        XCTAssertFalse(config.isPairedEnd)
        XCTAssertEqual(config.databaseName, "Standard-8")
        XCTAssertEqual(config.confidence, 0.2)
        XCTAssertEqual(config.minimumHitGroups, 2)
        XCTAssertEqual(config.threads, 4)
        XCTAssertFalse(config.memoryMapping)
    }

    /// Verifies that fromPreset creates a config with correct parameters.
    func testConfigFromPreset() {
        let dbPath = tempDir.appendingPathComponent("test-db")
        let inputFile = tempDir.appendingPathComponent("input.fastq")
        let outputDir = tempDir.appendingPathComponent("output")

        let config = ClassificationConfig.fromPreset(
            .precise,
            inputFiles: [inputFile],
            isPairedEnd: false,
            databaseName: "Viral",
            databasePath: dbPath,
            threads: 8,
            outputDirectory: outputDir
        )

        XCTAssertEqual(config.confidence, 0.5)
        XCTAssertEqual(config.minimumHitGroups, 3)
        XCTAssertEqual(config.threads, 8)
        XCTAssertEqual(config.databaseName, "Viral")
    }

    /// Verifies kraken2 argument generation from config.
    func testConfigArgumentGeneration() {
        let dbPath = tempDir.appendingPathComponent("test-db")
        let inputFile = tempDir.appendingPathComponent("input.fastq")
        let outputDir = tempDir.appendingPathComponent("output")

        let config = ClassificationConfig(
            inputFiles: [inputFile],
            isPairedEnd: false,
            databaseName: "Standard-8",
            databasePath: dbPath,
            confidence: 0.2,
            minimumHitGroups: 2,
            threads: 4,
            memoryMapping: true,
            quickMode: false,
            outputDirectory: outputDir
        )

        let args = config.kraken2Arguments()

        XCTAssertTrue(args.contains("--db"), "Should include --db flag")
        XCTAssertTrue(args.contains("--threads"), "Should include --threads flag")
        XCTAssertTrue(args.contains("--confidence"), "Should include --confidence flag")
        XCTAssertTrue(args.contains("--memory-mapping"), "Should include --memory-mapping flag")
        XCTAssertTrue(args.contains("--report-minimizer-data"), "Should include minimizer data flag")
        XCTAssertFalse(args.contains("--paired"), "Should not include --paired for single-end")
        XCTAssertFalse(args.contains("--quick"), "Should not include --quick when disabled")
    }

    /// Verifies paired-end argument generation.
    func testConfigPairedEndArguments() {
        let dbPath = tempDir.appendingPathComponent("test-db")
        let r1 = tempDir.appendingPathComponent("R1.fastq")
        let r2 = tempDir.appendingPathComponent("R2.fastq")
        let outputDir = tempDir.appendingPathComponent("output")

        let config = ClassificationConfig(
            inputFiles: [r1, r2],
            isPairedEnd: true,
            databaseName: "Standard-8",
            databasePath: dbPath,
            outputDirectory: outputDir
        )

        let args = config.kraken2Arguments()

        XCTAssertTrue(args.contains("--paired"), "Should include --paired for paired-end")
    }

    // MARK: - testDatabaseInfoProperties

    /// Verifies database info properties used by the wizard.
    func testDatabaseInfoProperties() {
        let db = makeDatabaseInfo(name: "Viral", status: .ready, sizeBytes: 536_870_912)

        XCTAssertEqual(db.name, "Viral")
        XCTAssertEqual(db.id, "Viral")
        XCTAssertEqual(db.status, .ready)
        XCTAssertTrue(db.isDownloaded)
        XCTAssertEqual(db.sizeBytes, 536_870_912)
    }

    /// Verifies database info for a not-yet-downloaded database.
    func testDatabaseInfoNotDownloaded() {
        let db = makeDatabaseInfo(name: "Standard", status: .missing)

        XCTAssertFalse(db.isDownloaded)
        XCTAssertEqual(db.status, .missing)
    }
}
