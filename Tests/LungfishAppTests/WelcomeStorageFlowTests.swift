import XCTest
@testable import LungfishApp
@testable import LungfishCore
@testable import LungfishWorkflow

private actor SequencedWelcomeStorageStatusProvider: PluginPackStatusProviding {
    private let sequences: [[PluginPackStatus]]
    private var index = 0

    init(sequences: [[PluginPackStatus]]) {
        self.sequences = sequences
    }

    func visibleStatuses() async -> [PluginPackStatus] {
        let current = sequences[min(index, sequences.count - 1)]
        index += 1
        return current
    }

    func status(for pack: PluginPack) async -> PluginPackStatus {
        sequences.flatMap { $0 }.first(where: { $0.pack.id == pack.id })!
    }

    func invalidateVisibleStatusesCache() async {}

    func install(
        pack: PluginPack,
        reinstall: Bool,
        progress: (@Sendable (PluginPackInstallProgress) -> Void)?
    ) async throws {}
}

final class WelcomeStorageFlowTests: XCTestCase {
    private var tempHome: URL!

    override func setUpWithError() throws {
        try super.setUpWithError()
        tempHome = FileManager.default.temporaryDirectory
            .appendingPathComponent("welcome-storage-flow-tests-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: tempHome, withIntermediateDirectories: true)
    }

    override func tearDownWithError() throws {
        if let tempHome {
            try? FileManager.default.removeItem(at: tempHome)
        }
        tempHome = nil
        try super.tearDownWithError()
    }

    @MainActor
    func testChooseAlternateStorageLocationShowsChooser() {
        let store = ManagedStorageConfigStore(homeDirectory: tempHome)
        let viewModel = WelcomeViewModel(
            statusProvider: SequencedWelcomeStorageStatusProvider(sequences: [[requiredStatus(state: .needsInstall)]]),
            storageConfigStore: store
        )

        XCTAssertFalse(viewModel.showingStorageChooser)
        XCTAssertNil(viewModel.pendingStorageSelection)
        XCTAssertFalse(viewModel.canConfirmStorageSelection)

        viewModel.chooseAlternateStorageLocation()

        XCTAssertTrue(viewModel.showingStorageChooser)
    }

    @MainActor
    func testCannotConfirmSelectionWhenResolvedPathContainsSpaces() async throws {
        let store = ManagedStorageConfigStore(homeDirectory: tempHome)
        let defaultRoot = store.defaultLocation.rootURL
        let invalidSelection = URL(fileURLWithPath: "/Volumes/My SSD/Lungfish", isDirectory: true)
        let coordinator = ManagedStorageCoordinator(
            configStore: store,
            databaseMigrator: { _, _ in },
            toolInstaller: { _ in },
            verifier: { _ in }
        )
        let viewModel = WelcomeViewModel(
            statusProvider: SequencedWelcomeStorageStatusProvider(sequences: [[requiredStatus(state: .needsInstall)]]),
            storageCoordinator: coordinator,
            storageConfigStore: store
        )

        let result = viewModel.validateStorageSelection(invalidSelection)

        XCTAssertEqual(result, .invalid(.containsSpaces))

        viewModel.chooseAlternateStorageLocation()
        viewModel.updatePendingStorageSelection(invalidSelection)
        try await viewModel.confirmAlternateStorageLocation()

        XCTAssertEqual(store.currentLocation().rootURL, defaultRoot)
        XCTAssertFalse(viewModel.canConfirmStorageSelection)
        XCTAssertEqual(viewModel.storageValidationResult, .invalid(.containsSpaces))
    }

    @MainActor
    func testConfirmAlternateStorageLocationChangesStorageAndRefreshesSetup() async throws {
        let store = ManagedStorageConfigStore(homeDirectory: tempHome)
        let newRoot = tempHome.appendingPathComponent("ExternalManagedStorage", isDirectory: true)
        let provider = SequencedWelcomeStorageStatusProvider(sequences: [
            [requiredStatus(state: .needsInstall)],
            [requiredStatus(state: .ready)]
        ])
        let coordinator = ManagedStorageCoordinator(
            configStore: store,
            databaseMigrator: { _, _ in },
            toolInstaller: { _ in },
            verifier: { _ in }
        )
        let viewModel = WelcomeViewModel(
            statusProvider: provider,
            storageCoordinator: coordinator,
            storageConfigStore: store
        )

        await viewModel.refreshSetup()
        XCTAssertEqual(viewModel.requiredSetupStatus?.state, .needsInstall)

        viewModel.chooseAlternateStorageLocation()
        viewModel.updatePendingStorageSelection(newRoot)
        try await viewModel.confirmAlternateStorageLocation()

        XCTAssertEqual(store.currentLocation().rootURL, newRoot.standardizedFileURL)
        XCTAssertEqual(viewModel.requiredSetupStatus?.state, .ready)
        XCTAssertFalse(viewModel.showingStorageChooser)
    }

    private func requiredStatus(state: PluginPackState) -> PluginPackStatus {
        PluginPackStatus(
            pack: .requiredSetupPack,
            state: state,
            toolStatuses: [],
            failureMessage: nil
        )
    }
}
