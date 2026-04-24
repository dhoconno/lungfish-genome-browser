import Foundation
import os.log

private let logger = Logger(subsystem: LogSubsystem.io, category: "PrimerSchemesFolder")

public enum PrimerSchemesFolder {
    public static let folderName = "Primer Schemes"

    public static func ensureFolder(in projectURL: URL) throws -> URL {
        let folderURL = projectURL.appendingPathComponent(folderName, isDirectory: true)
        let fm = FileManager.default
        if !fm.fileExists(atPath: folderURL.path) {
            try fm.createDirectory(at: folderURL, withIntermediateDirectories: true)
            logger.info("Created Primer Schemes folder at \(folderURL.path)")
        }
        return folderURL
    }

    public static func folderURL(in projectURL: URL) -> URL? {
        let folderURL = projectURL.appendingPathComponent(folderName, isDirectory: true)
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: folderURL.path, isDirectory: &isDir), isDir.boolValue {
            return folderURL
        }
        return nil
    }

    public static func listBundles(in projectURL: URL) -> [PrimerSchemeBundle] {
        guard let folder = folderURL(in: projectURL) else { return [] }
        let fm = FileManager.default
        guard let contents = try? fm.contentsOfDirectory(
            at: folder,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        ) else { return [] }

        return contents
            .filter { $0.pathExtension == "lungfishprimers" }
            .compactMap { try? PrimerSchemeBundle.load(from: $0) }
            .sorted { $0.url.lastPathComponent < $1.url.lastPathComponent }
    }
}
