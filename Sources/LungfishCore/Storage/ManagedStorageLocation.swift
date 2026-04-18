import Foundation

public struct ManagedStorageLocation: Sendable, Codable, Equatable {
    public enum ValidationError: String, Sendable, Codable, Equatable, Error, LocalizedError {
        case containsSpaces
        case nestedInsideProject
        case nestedInsideAppBundle
        case notWritable
        case unsupportedFilesystem
        case unreachable

        public var errorDescription: String? {
            switch self {
            case .containsSpaces:
                return "The selected location resolves to a path with spaces. Managed tool installs still require a space-free path, so choose a folder whose full path has no spaces or rename the external volume."
            case .nestedInsideProject:
                return "Choose a location outside any .lungfish project folder."
            case .nestedInsideAppBundle:
                return "Choose a location outside the Lungfish app bundle."
            case .notWritable:
                return "The selected location is not writable."
            case .unsupportedFilesystem:
                return "The selected location uses an unsupported filesystem."
            case .unreachable:
                return "The selected location is not reachable right now."
            }
        }
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
