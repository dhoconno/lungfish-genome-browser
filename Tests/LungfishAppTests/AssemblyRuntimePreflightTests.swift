import XCTest
@testable import LungfishApp
@testable import LungfishWorkflow

private actor StubPluginPackStatusProvider: PluginPackStatusProviding {
    let packStatus: PluginPackStatus?

    init(packStatus: PluginPackStatus?) {
        self.packStatus = packStatus
    }

    func visibleStatuses() async -> [PluginPackStatus] {
        packStatus.map { [$0] } ?? []
    }

    func status(for pack: PluginPack) async -> PluginPackStatus {
        packStatus ?? PluginPackStatus(pack: pack, state: .needsInstall, toolStatuses: [], failureMessage: nil)
    }

    func status(forPackID packID: String) async -> PluginPackStatus? {
        packStatus
    }

    func invalidateVisibleStatusesCache() async {}

    func install(
        pack: PluginPack,
        reinstall: Bool,
        progress: (@Sendable (PluginPackInstallProgress) -> Void)?
    ) async throws {}
}

final class AssemblyRuntimePreflightTests: XCTestCase {
    func testReadyToolProducesNoWarning() async throws {
        let request = AssemblyRunRequest(
            tool: .spades,
            readType: .illuminaShortReads,
            inputURLs: [URL(fileURLWithPath: "/tmp/sample.fastq")],
            projectName: "Demo",
            outputDirectory: URL(fileURLWithPath: "/tmp/output"),
            threads: 4
        )

        let message = await AssemblyRuntimePreflight.warningMessage(
            for: request,
            statusProvider: StubPluginPackStatusProvider(packStatus: try makeAssemblyPackStatus(toolID: "spades", environmentExists: true, missingExecutables: [], smokeTestFailure: nil))
        )

        XCTAssertNil(message)
    }

    func testMissingToolProducesInstallWarning() async throws {
        let request = AssemblyRunRequest(
            tool: .megahit,
            readType: .illuminaShortReads,
            inputURLs: [URL(fileURLWithPath: "/tmp/sample.fastq")],
            projectName: "Demo",
            outputDirectory: URL(fileURLWithPath: "/tmp/output"),
            threads: 4
        )

        let message = await AssemblyRuntimePreflight.warningMessage(
            for: request,
            statusProvider: StubPluginPackStatusProvider(packStatus: try makeAssemblyPackStatus(toolID: "megahit", environmentExists: false, missingExecutables: ["megahit"], smokeTestFailure: nil))
        )

        XCTAssertEqual(
            message,
            "Install the Genome Assembly pack to enable MEGAHIT."
        )
    }

    func testInvalidRequestSurfacesConfigurationProblemBeforeAvailability() async {
        let request = AssemblyRunRequest(
            tool: .flye,
            readType: .ontReads,
            inputURLs: [
                URL(fileURLWithPath: "/tmp/read-1.fastq"),
                URL(fileURLWithPath: "/tmp/read-2.fastq"),
            ],
            projectName: "Demo",
            outputDirectory: URL(fileURLWithPath: "/tmp/output"),
            threads: 4
        )

        let message = await AssemblyRuntimePreflight.warningMessage(
            for: request,
            statusProvider: StubPluginPackStatusProvider(packStatus: nil)
        )

        XCTAssertEqual(
            message,
            "Flye expects a single ONT FASTQ input in v1."
        )
    }

    private func makeAssemblyPackStatus(
        toolID: String,
        environmentExists: Bool,
        missingExecutables: [String],
        smokeTestFailure: String?
    ) throws -> PluginPackStatus {
        let pack = try XCTUnwrap(PluginPack.builtInPack(id: "assembly"))
        let toolStatuses = pack.toolRequirements.map { requirement in
            PackToolStatus(
                requirement: requirement,
                environmentExists: requirement.id == toolID ? environmentExists : true,
                missingExecutables: requirement.id == toolID ? missingExecutables : [],
                smokeTestFailure: requirement.id == toolID ? smokeTestFailure : nil,
                storageUnavailablePath: nil
            )
        }
        return PluginPackStatus(
            pack: pack,
            state: .ready,
            toolStatuses: toolStatuses,
            failureMessage: nil
        )
    }
}
