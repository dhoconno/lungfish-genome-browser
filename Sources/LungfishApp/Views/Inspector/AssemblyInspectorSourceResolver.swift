import Foundation
import LungfishWorkflow

enum AssemblyInspectorSourceResolver {
    static func resolve(
        provenanceInputs: [InputFileRecord],
        projectURL: URL?
    ) -> [AssemblyDocumentSourceRow] {
        provenanceInputs.map { resolve(input: $0, projectURL: projectURL) }
    }

    static func resolve(
        envelope: ProvenanceEnvelope,
        outputDirectory: URL,
        projectURL: URL?
    ) -> [AssemblyDocumentSourceRow] {
        let inputs = envelope.files.filter { $0.role == .input }.map { file in
            let url = URL(fileURLWithPath: file.path, relativeTo: outputDirectory).standardizedFileURL
            return InputFileRecord(
                filename: url.lastPathComponent,
                originalPath: url.path,
                sha256: file.checksumSHA256,
                sizeBytes: Int64(clamping: file.fileSize ?? 0)
            )
        }
        return resolve(provenanceInputs: inputs, projectURL: projectURL)
    }

    private static func resolve(
        input: InputFileRecord,
        projectURL: URL?
    ) -> AssemblyDocumentSourceRow {
        guard let originalPath = input.originalPath, !originalPath.isEmpty else {
            return .missing(name: input.filename, originalPath: nil)
        }

        let fileManager = FileManager.default
        let candidateURL = URL(fileURLWithPath: originalPath).standardizedFileURL
        let fileExists = fileManager.fileExists(atPath: candidateURL.path)

        if let bundleURL = resolveBundleURL(fromInputFilePath: originalPath),
           fileExists {
            if let projectURL, isURL(bundleURL, inside: projectURL) {
                return .projectLink(name: input.filename, targetURL: bundleURL)
            }
            return .filesystemLink(name: input.filename, fileURL: bundleURL)
        }

        if fileExists {
            if let projectURL, isURL(candidateURL, inside: projectURL) {
                return .projectLink(name: input.filename, targetURL: candidateURL)
            }
            return .filesystemLink(name: input.filename, fileURL: candidateURL)
        }

        return .missing(name: input.filename, originalPath: originalPath)
    }

    private static func resolveBundleURL(fromInputFilePath path: String) -> URL? {
        var url = URL(fileURLWithPath: path)
        while url.pathComponents.count > 1 {
            url = url.deletingLastPathComponent()
            if url.pathExtension.lowercased() == "lungfishfastq" {
                var isDirectory: ObjCBool = false
                if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory),
                   isDirectory.boolValue {
                    return url.standardizedFileURL
                }
            }
        }
        return nil
    }

    private static func isURL(_ url: URL, inside directory: URL) -> Bool {
        let child = url.standardizedFileURL.resolvingSymlinksInPath().pathComponents
        let parent = directory.standardizedFileURL.resolvingSymlinksInPath().pathComponents
        return child.count >= parent.count && child.starts(with: parent)
    }
}
