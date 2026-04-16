import XCTest
@testable import LungfishApp
@testable import LungfishWorkflow

private actor StubWelcomePackStatusProvider: PluginPackStatusProviding {
    var statuses: [PluginPackStatus]

    init(statuses: [PluginPackStatus]) {
        self.statuses = statuses
    }

    func visibleStatuses() async -> [PluginPackStatus] {
        statuses
    }

    func status(for pack: PluginPack) async -> PluginPackStatus {
        statuses.first(where: { $0.pack.id == pack.id })!
    }

    func install(
        pack: PluginPack,
        reinstall: Bool,
        progress: (@Sendable (Double, String) -> Void)?
    ) async throws {
        progress?(1.0, "Installed")
    }
}

@MainActor
final class WelcomeSetupTests: XCTestCase {

    func testAvailableActionsExcludeOpenFiles() {
        XCTAssertEqual(WelcomeAction.allCases, [.createProject, .openProject])
    }

    func testLaunchRemainsDisabledUntilRequiredSetupIsReady() async {
        let required = PluginPackStatus(
            pack: .requiredSetupPack,
            state: .needsInstall,
            toolStatuses: [],
            failureMessage: nil
        )
        let optional = PluginPackStatus(
            pack: PluginPack.activeOptionalPacks[0],
            state: .needsInstall,
            toolStatuses: [],
            failureMessage: nil
        )

        let viewModel = WelcomeViewModel(
            statusProvider: StubWelcomePackStatusProvider(statuses: [required, optional])
        )
        await viewModel.refreshSetup()

        XCTAssertFalse(viewModel.canLaunch)
        XCTAssertEqual(viewModel.optionalPackStatuses.map(\.pack.id), ["metagenomics"])
    }

    func testLaunchEnablesWhenRequiredSetupIsReady() async {
        let required = PluginPackStatus(
            pack: .requiredSetupPack,
            state: .ready,
            toolStatuses: [],
            failureMessage: nil
        )

        let viewModel = WelcomeViewModel(
            statusProvider: StubWelcomePackStatusProvider(statuses: [required])
        )
        await viewModel.refreshSetup()

        XCTAssertTrue(viewModel.canLaunch)
    }
}
