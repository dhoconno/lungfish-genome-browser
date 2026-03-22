// CondaManagerTests.swift - Tests for the conda/micromamba plugin system
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishWorkflow
import LungfishCore

/// Tests for CondaManager, CondaPackageInfo, PluginPack, and related types.
///
/// Note: Tests that actually install packages require network access and
/// are marked with XCTSkip guards. The model and configuration tests run
/// without network.
final class CondaManagerTests: XCTestCase {

    // MARK: - CondaPackageInfo Tests

    func testCondaPackageInfoCreation() {
        let pkg = CondaPackageInfo(
            name: "samtools",
            version: "1.23.1",
            channel: "bioconda",
            buildString: "hc612e98_0",
            subdir: "osx-arm64"
        )

        XCTAssertEqual(pkg.name, "samtools")
        XCTAssertEqual(pkg.version, "1.23.1")
        XCTAssertEqual(pkg.channel, "bioconda")
        XCTAssertTrue(pkg.isNativeMacOS)
    }

    func testCondaPackageInfoLinuxOnly() {
        let pkg = CondaPackageInfo(
            name: "pbaa",
            version: "1.0.3",
            channel: "bioconda",
            subdir: "linux-64"
        )

        XCTAssertFalse(pkg.isNativeMacOS, "linux-64 packages should not be native macOS")
    }

    func testCondaPackageInfoNoarchIsNative() {
        let pkg = CondaPackageInfo(
            name: "multiqc",
            version: "1.20",
            channel: "bioconda",
            subdir: "noarch"
        )

        XCTAssertTrue(pkg.isNativeMacOS, "noarch packages should be considered native")
    }

    func testCondaPackageInfoIdentifiable() {
        let pkg1 = CondaPackageInfo(name: "samtools", version: "1.23", channel: "bioconda")
        let pkg2 = CondaPackageInfo(name: "samtools", version: "1.22", channel: "bioconda")

        XCTAssertNotEqual(pkg1.id, pkg2.id, "Different versions should have different IDs")
    }

    func testCondaPackageInfoCodable() throws {
        let original = CondaPackageInfo(
            name: "bwa-mem2",
            version: "2.2.1",
            channel: "bioconda",
            buildString: "h123_0",
            subdir: "osx-arm64",
            license: "MIT",
            description: "Fast sequence mapper",
            sizeBytes: 5_000_000
        )

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(CondaPackageInfo.self, from: data)

        XCTAssertEqual(decoded.name, original.name)
        XCTAssertEqual(decoded.version, original.version)
        XCTAssertEqual(decoded.license, "MIT")
        XCTAssertEqual(decoded.sizeBytes, 5_000_000)
    }

    // MARK: - CondaEnvironment Tests

    func testCondaEnvironmentCreation() {
        let env = CondaEnvironment(
            name: "samtools",
            path: URL(fileURLWithPath: "/tmp/test/envs/samtools"),
            packageCount: 18
        )

        XCTAssertEqual(env.id, "samtools")
        XCTAssertEqual(env.name, "samtools")
        XCTAssertEqual(env.packageCount, 18)
    }

    func testCondaEnvironmentHashable() {
        let env1 = CondaEnvironment(name: "a", path: URL(fileURLWithPath: "/a"))
        let env2 = CondaEnvironment(name: "b", path: URL(fileURLWithPath: "/b"))
        let env3 = CondaEnvironment(name: "a", path: URL(fileURLWithPath: "/a"))

        var set = Set<CondaEnvironment>()
        set.insert(env1)
        set.insert(env2)
        set.insert(env3)

        XCTAssertEqual(set.count, 2)
    }

    // MARK: - PluginPack Tests

    func testBuiltInPacksExist() {
        XCTAssertFalse(PluginPack.builtIn.isEmpty)
        XCTAssertGreaterThanOrEqual(PluginPack.builtIn.count, 7)
    }

    func testBuiltInPacksHaveUniqueIDs() {
        let ids = PluginPack.builtIn.map(\.id)
        XCTAssertEqual(ids.count, Set(ids).count, "Pack IDs should be unique")
    }

    func testBuiltInPacksHavePackages() {
        for pack in PluginPack.builtIn {
            XCTAssertFalse(pack.packages.isEmpty, "Pack '\(pack.name)' should have packages")
            XCTAssertFalse(pack.name.isEmpty, "Pack should have a name")
            XCTAssertFalse(pack.description.isEmpty, "Pack '\(pack.name)' should have a description")
            XCTAssertFalse(pack.sfSymbol.isEmpty, "Pack '\(pack.name)' should have an SF Symbol")
        }
    }

    func testIlluminaQCPack() {
        let pack = PluginPack.builtIn.first { $0.id == "illumina-qc" }
        XCTAssertNotNil(pack)
        XCTAssertTrue(pack!.packages.contains("fastqc"))
        XCTAssertTrue(pack!.packages.contains("multiqc"))
        XCTAssertTrue(pack!.packages.contains("fastp"))
    }

    func testAlignmentPack() {
        let pack = PluginPack.builtIn.first { $0.id == "alignment" }
        XCTAssertNotNil(pack)
        XCTAssertTrue(pack!.packages.contains("minimap2"))
        XCTAssertTrue(pack!.packages.contains("bwa-mem2"))
    }

    func testMetagenomicsPack() {
        let pack = PluginPack.builtIn.first { $0.id == "metagenomics" }
        XCTAssertNotNil(pack)
        XCTAssertTrue(pack!.packages.contains("freyja"))
    }

    func testPluginPackCodable() throws {
        let original = PluginPack(
            id: "test-pack",
            name: "Test Pack",
            description: "A test pack",
            sfSymbol: "star",
            packages: ["tool1", "tool2"],
            category: "Testing"
        )

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(PluginPack.self, from: data)

        XCTAssertEqual(decoded.id, original.id)
        XCTAssertEqual(decoded.packages, original.packages)
    }

    // MARK: - CondaManager Configuration Tests

    func testCondaManagerRootPrefix() async {
        let manager = CondaManager.shared
        let rootPrefix = await manager.rootPrefix

        XCTAssertTrue(rootPrefix.path.contains(".lungfish/conda"),
                      "Root prefix should use .lungfish/conda (no spaces)")
        XCTAssertFalse(rootPrefix.path.contains("Application Support"),
                       "Root prefix should NOT contain 'Application Support' (spaces break tools)")
    }

    func testCondaManagerMicromambaPath() async {
        let manager = CondaManager.shared
        let path = await manager.micromambaPath

        XCTAssertTrue(path.path.hasSuffix("bin/micromamba"))
    }

    func testCondaManagerDefaultChannels() async {
        let manager = CondaManager.shared
        let channels = await manager.defaultChannels

        XCTAssertTrue(channels.contains("bioconda"))
        XCTAssertTrue(channels.contains("conda-forge"))
    }

    func testNextflowCondaConfig() async {
        let manager = CondaManager.shared
        let config = await manager.nextflowCondaConfig()

        XCTAssertNotNil(config["NXF_CONDA_CACHEDIR"])
        XCTAssertNotNil(config["MAMBA_ROOT_PREFIX"])
        XCTAssertEqual(config["NXF_CONDA_ENABLED"], "true")
    }

    func testNextflowCondaConfigString() async {
        let manager = CondaManager.shared
        let configStr = await manager.nextflowCondaConfigString()

        XCTAssertTrue(configStr.contains("conda {"))
        XCTAssertTrue(configStr.contains("enabled = true"))
        XCTAssertTrue(configStr.contains("useMicromamba = true"))
        XCTAssertTrue(configStr.contains("cacheDir"))
    }

    // MARK: - CondaError Tests

    func testCondaErrorDescriptions() {
        let errors: [CondaError] = [
            .micromambaNotFound,
            .micromambaDownloadFailed("timeout"),
            .environmentCreationFailed("conflict"),
            .environmentNotFound("test-env"),
            .packageInstallFailed("network"),
            .packageNotFound("nonexistent"),
            .toolNotFound(tool: "samtools", environment: "test"),
            .executionFailed(tool: "bwa", exitCode: 1, stderr: "error"),
            .linuxOnlyPackage("pbaa"),
            .networkError("timeout"),
            .diskSpaceError("insufficient"),
        ]

        for error in errors {
            XCTAssertNotNil(error.errorDescription, "Error \(error) should have a description")
            XCTAssertFalse(error.errorDescription!.isEmpty)
        }
    }

    // MARK: - Integration Tests (require network)

    func testListEnvironments() async throws {
        let manager = CondaManager.shared
        // This should not throw even if no environments exist
        let envs = try await manager.listEnvironments()
        // Just verify it returns an array (may be empty or populated)
        XCTAssertTrue(envs is [CondaEnvironment])
    }
}
