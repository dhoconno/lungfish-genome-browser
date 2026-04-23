import Foundation
import LungfishCore
import LungfishWorkflow

public struct ManagedSamtoolsHome: Sendable {
    public enum HomeError: Error, LocalizedError {
        case samtoolsNotFound

        public var errorDescription: String? {
            switch self {
            case .samtoolsNotFound:
                return "A real samtools executable is required for this test."
            }
        }
    }

    public let homeURL: URL
    public let managedRootURL: URL
    public let samtoolsPath: URL

    public init(homeURL: URL, managedRootURL: URL, samtoolsPath: URL) {
        self.homeURL = homeURL
        self.managedRootURL = managedRootURL
        self.samtoolsPath = samtoolsPath
    }

    public static func makeReal(
        rootURL: URL = FileManager.default.temporaryDirectory
    ) throws -> ManagedSamtoolsHome {
        guard let realSamtoolsPath = BamFixtureBuilder.locateSamtools() else {
            throw HomeError.samtoolsNotFound
        }

        let fileManager = FileManager.default
        let homeURL = rootURL
            .appendingPathComponent("ManagedSamtoolsHome-\(UUID().uuidString)", isDirectory: true)
        try fileManager.createDirectory(at: homeURL, withIntermediateDirectories: true)

        let managedRootURL = ManagedStorageConfigStore(homeDirectory: homeURL).defaultLocation.rootURL
        let samtoolsPath = CoreToolLocator.executableURL(
            environment: "samtools",
            executableName: "samtools",
            homeDirectory: homeURL
        )
        try fileManager.createDirectory(
            at: samtoolsPath.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        if fileManager.fileExists(atPath: samtoolsPath.path) {
            try fileManager.removeItem(at: samtoolsPath)
        }
        try fileManager.createSymbolicLink(
            at: samtoolsPath,
            withDestinationURL: URL(fileURLWithPath: realSamtoolsPath)
        )

        return ManagedSamtoolsHome(
            homeURL: homeURL,
            managedRootURL: managedRootURL,
            samtoolsPath: samtoolsPath
        )
    }
}
