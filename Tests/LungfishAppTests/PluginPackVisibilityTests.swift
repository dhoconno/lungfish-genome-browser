import XCTest
@testable import LungfishApp
@testable import LungfishWorkflow

private actor StubPluginManagerPackStatusProvider: PluginPackStatusProviding {
    let statuses: [PluginPackStatus]

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
        progress: (@Sendable (PluginPackInstallProgress) -> Void)?
    ) async throws {
        progress?(PluginPackInstallProgress(
            requirementID: nil,
            requirementDisplayName: nil,
            overallFraction: 1.0,
            itemFraction: 1.0,
            message: "Installed"
        ))
    }
}

private final class DelayedPluginManagerPackStatusProvider: @unchecked Sendable, PluginPackStatusProviding {
    let statuses: [PluginPackStatus]
    private let lock = NSLock()
    private var continuations: [CheckedContinuation<Void, Never>] = []

    init(statuses: [PluginPackStatus]) {
        self.statuses = statuses
    }

    func visibleStatuses() async -> [PluginPackStatus] {
        await withCheckedContinuation { continuation in
            lock.withLock {
                continuations.append(continuation)
            }
        }
        return statuses
    }

    func status(for pack: PluginPack) async -> PluginPackStatus {
        statuses.first(where: { $0.pack.id == pack.id })!
    }

    func install(
        pack: PluginPack,
        reinstall: Bool,
        progress: (@Sendable (PluginPackInstallProgress) -> Void)?
    ) async throws {}

    func release() {
        let pending = lock.withLock {
            let pending = continuations
            continuations.removeAll()
            return pending
        }
        for continuation in pending {
            continuation.resume()
        }
    }
}

@MainActor
final class PluginPackVisibilityTests: XCTestCase {

    func testViewModelExposesRequiredSetupSeparatelyFromOptionalPacks() async {
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
        let viewModel = PluginManagerViewModel(
            packStatusProvider: StubPluginManagerPackStatusProvider(statuses: [required, optional])
        )

        await viewModel.loadPackStatuses()

        XCTAssertEqual(viewModel.requiredSetupPack?.pack.id, "lungfish-tools")
        XCTAssertEqual(viewModel.optionalPackStatuses.map(\.pack.id), ["metagenomics"])
    }

    func testFocusPackSelectsPacksTabAndStoresPackID() {
        let viewModel = PluginManagerViewModel(
            packStatusProvider: StubPluginManagerPackStatusProvider(statuses: [])
        )

        viewModel.focusPack("metagenomics")

        XCTAssertEqual(viewModel.selectedTab, .packs)
        XCTAssertEqual(viewModel.focusedPackID, "metagenomics")
    }

    func testRefreshPackStatusesExposesLoadingStateWhileStatusesArePending() async {
        let required = PluginPackStatus(
            pack: .requiredSetupPack,
            state: .needsInstall,
            toolStatuses: [],
            failureMessage: nil
        )
        let provider = DelayedPluginManagerPackStatusProvider(statuses: [required])
        let viewModel = PluginManagerViewModel(packStatusProvider: provider)

        try? await Task.sleep(for: .milliseconds(20))

        XCTAssertTrue(viewModel.isLoadingPackStatuses)
        XCTAssertNil(viewModel.requiredSetupPack)

        provider.release()
        try? await Task.sleep(for: .milliseconds(50))

        XCTAssertFalse(viewModel.isLoadingPackStatuses)
        XCTAssertEqual(viewModel.requiredSetupPack?.pack.id, "lungfish-tools")
    }
}
