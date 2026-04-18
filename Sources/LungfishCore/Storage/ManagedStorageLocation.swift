import Foundation

public struct ManagedStorageLocation: Sendable, Codable, Equatable {
    public enum ValidationError: String, Sendable, Codable, Equatable, Error {
        case containsSpaces
        case nestedInsideProject
        case nestedInsideAppBundle
        case notWritable
        case unsupportedFilesystem
        case unreachable
    }

    public enum ValidationResult: Sendable, Equatable {
        case valid
        case invalid(ValidationError)
    }

    public let rootURL: URL

    public init(rootURL: URL) {
        self.rootURL = rootURL.standardizedFileURL
    }

    public var condaRootURL: URL {
        rootURL.appendingPathComponent("conda", isDirectory: true)
    }

    public var databaseRootURL: URL {
        rootURL.appendingPathComponent("databases", isDirectory: true)
    }

    public static func defaultLocation(homeDirectory: URL = FileManager.default.homeDirectoryForCurrentUser) -> ManagedStorageLocation {
        ManagedStorageLocation(rootURL: homeDirectory.appendingPathComponent(".lungfish", isDirectory: true))
    }

    public static func validateSelection(_ url: URL) -> ValidationResult {
        let resolved = url.resolvingSymlinksInPath().standardizedFileURL

        if resolved.path.contains(" ") {
            return .invalid(.containsSpaces)
        }

        let pathComponents = resolved.pathComponents
        if pathComponents.contains(where: { component in
            component != ".lungfish" && component.hasSuffix(".lungfish")
        }) {
            return .invalid(.nestedInsideProject)
        }

        if pathComponents.contains(where: { component in
            component.hasSuffix(".app")
        }) {
            return .invalid(.nestedInsideAppBundle)
        }

        return .valid
    }
}
