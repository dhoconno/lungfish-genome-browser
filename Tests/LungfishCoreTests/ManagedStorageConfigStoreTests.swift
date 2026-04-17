import XCTest
@testable import LungfishCore

final class ManagedStorageConfigStoreTests: XCTestCase {
    private func makeTemporaryHomeDirectory() throws -> URL {
        let home = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: home, withIntermediateDirectories: true)
        addTeardownBlock {
            try? FileManager.default.removeItem(at: home)
        }
        return home
    }

    func testCurrentLocationDefaultsToDotLungfishUnderHome() throws {
        let home = try makeTemporaryHomeDirectory()
        let store = ManagedStorageConfigStore(homeDirectory: home)

        XCTAssertEqual(store.configURL.path, home.appendingPathComponent(".config/lungfish/storage-location.json").path)
        XCTAssertEqual(store.currentLocation().rootURL.path, home.appendingPathComponent(".lungfish").path)
    }

    func testSetActiveRootPersistsBootstrapConfig() throws {
        let home = try makeTemporaryHomeDirectory()
        let customRoot = URL(fileURLWithPath: "/tmp/custom-lungfish", isDirectory: true)

        let store = ManagedStorageConfigStore(homeDirectory: home)
        try store.setActiveRoot(customRoot)

        let reloaded = ManagedStorageConfigStore(homeDirectory: home)
        XCTAssertEqual(reloaded.currentLocation().rootURL.standardizedFileURL.path, customRoot.standardizedFileURL.path)
    }
}
