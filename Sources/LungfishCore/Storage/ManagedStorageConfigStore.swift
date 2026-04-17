import Foundation

public struct ManagedStorageBootstrapConfig: Codable, Equatable, Sendable {
    public var activeRootPath: String

    public init(activeRootPath: String) {
        self.activeRootPath = activeRootPath
    }
}

public final class ManagedStorageConfigStore: @unchecked Sendable {
    @MainActor public static var shared = ManagedStorageConfigStore()

    public let configURL: URL

    private let fileManager: FileManager
    private let homeDirectory: URL

    public init(
        fileManager: FileManager = .default,
        homeDirectory: URL = FileManager.default.homeDirectoryForCurrentUser
    ) {
        self.fileManager = fileManager
        self.homeDirectory = homeDirectory.standardizedFileURL
        self.configURL = self.homeDirectory
            .appendingPathComponent(".config", isDirectory: true)
            .appendingPathComponent("lungfish", isDirectory: true)
            .appendingPathComponent("storage-location.json")
    }

    public var defaultLocation: ManagedStorageLocation {
        ManagedStorageLocation.defaultLocation(homeDirectory: homeDirectory)
    }

    public func currentLocation() -> ManagedStorageLocation {
        guard let config = loadBootstrapConfig(),
              !config.activeRootPath.isEmpty else {
            return defaultLocation
        }

        return ManagedStorageLocation(rootURL: URL(fileURLWithPath: config.activeRootPath, isDirectory: true))
    }

    public func setActiveRoot(_ rootURL: URL) throws {
        let location = ManagedStorageLocation(rootURL: rootURL)
        switch ManagedStorageLocation.validateSelection(location.rootURL) {
        case .valid:
            break
        case .invalid(let error):
            throw error
        }

        if location.rootURL.standardizedFileURL == defaultLocation.rootURL.standardizedFileURL {
            try removeBootstrapConfigIfPresent()
            return
        }

        let config = ManagedStorageBootstrapConfig(activeRootPath: location.rootURL.path)
        try saveBootstrapConfig(config)
    }

    private func loadBootstrapConfig() -> ManagedStorageBootstrapConfig? {
        guard fileManager.fileExists(atPath: configURL.path) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: configURL)
            return try JSONDecoder().decode(ManagedStorageBootstrapConfig.self, from: data)
        } catch {
            return nil
        }
    }

    private func saveBootstrapConfig(_ config: ManagedStorageBootstrapConfig) throws {
        try fileManager.createDirectory(
            at: configURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(config)
        try data.write(to: configURL, options: [.atomic])
    }

    private func removeBootstrapConfigIfPresent() throws {
        if fileManager.fileExists(atPath: configURL.path) {
            try fileManager.removeItem(at: configURL)
        }
    }
}
