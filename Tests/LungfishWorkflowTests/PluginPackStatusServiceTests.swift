import XCTest
@testable import LungfishWorkflow

final class PluginPackStatusServiceTests: XCTestCase {

    func testRequiredPackNeedsInstallWhenBBToolsExecutablesAreMissing() async throws {
        let sandbox = FileManager.default.temporaryDirectory
            .appendingPathComponent("pack-status-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: sandbox, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: sandbox) }

        let manager = CondaManager(
            rootPrefix: sandbox.appendingPathComponent("conda"),
            bundledMicromambaProvider: { nil },
            bundledMicromambaVersionProvider: { nil }
        )

        let nextflowBin = await manager.environmentURL(named: "nextflow").appendingPathComponent("bin/nextflow")
        let snakemakeBin = await manager.environmentURL(named: "snakemake").appendingPathComponent("bin/snakemake")
        try FileManager.default.createDirectory(at: nextflowBin.deletingLastPathComponent(), withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: snakemakeBin.deletingLastPathComponent(), withIntermediateDirectories: true)
        FileManager.default.createFile(atPath: nextflowBin.path, contents: Data("#!/bin/sh\n".utf8))
        FileManager.default.createFile(atPath: snakemakeBin.path, contents: Data("#!/bin/sh\n".utf8))
        try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: nextflowBin.path)
        try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: snakemakeBin.path)

        let service = PluginPackStatusService(condaManager: manager)
        let status = await service.status(for: .requiredSetupPack)

        XCTAssertEqual(status.pack.id, "lungfish-tools")
        XCTAssertEqual(status.state, .needsInstall)
        XCTAssertEqual(status.toolStatuses.first(where: { $0.requirement.environment == "bbtools" })?.isReady, false)
    }

    func testRequiredPackReadyWhenAllCoreExecutablesExist() async throws {
        let sandbox = FileManager.default.temporaryDirectory
            .appendingPathComponent("pack-status-ready-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: sandbox, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: sandbox) }

        let manager = CondaManager(
            rootPrefix: sandbox.appendingPathComponent("conda"),
            bundledMicromambaProvider: { nil },
            bundledMicromambaVersionProvider: { nil }
        )

        for requirement in PluginPack.requiredSetupPack.toolRequirements {
            let binDir = await manager.environmentURL(named: requirement.environment).appendingPathComponent("bin")
            try FileManager.default.createDirectory(at: binDir, withIntermediateDirectories: true)
            for executable in requirement.executables {
                let path = binDir.appendingPathComponent(executable)
                FileManager.default.createFile(atPath: path.path, contents: Data("#!/bin/sh\n".utf8))
                try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: path.path)
            }
        }

        let service = PluginPackStatusService(condaManager: manager)
        let status = await service.status(for: .requiredSetupPack)

        XCTAssertEqual(status.state, .ready)
        XCTAssertTrue(status.toolStatuses.allSatisfy(\.isReady))
    }

    func testInstallPackUsesReinstallWhenRequested() async throws {
        actor InstallRecorder {
            var calls: [(packages: [String], environment: String, reinstall: Bool)] = []
            func record(_ packages: [String], _ environment: String, _ reinstall: Bool) {
                calls.append((packages, environment, reinstall))
            }
            func recordedCalls() -> [(packages: [String], environment: String, reinstall: Bool)] { calls }
        }

        let recorder = InstallRecorder()
        let manager = CondaManager(
            rootPrefix: FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString),
            bundledMicromambaProvider: { nil },
            bundledMicromambaVersionProvider: { nil }
        )

        let service = PluginPackStatusService(
            condaManager: manager,
            installAction: { packages, environment, reinstall, _ in
                await recorder.record(packages, environment, reinstall)
            }
        )

        try await service.install(pack: .requiredSetupPack, reinstall: true, progress: nil)

        let calls = await recorder.recordedCalls()
        XCTAssertEqual(calls.map(\.environment), ["nextflow", "snakemake", "bbtools"])
        XCTAssertTrue(calls.allSatisfy(\.reinstall))
    }
}
