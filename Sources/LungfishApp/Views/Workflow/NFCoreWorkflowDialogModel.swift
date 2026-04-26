import Foundation
import LungfishWorkflow

@MainActor
final class NFCoreWorkflowDialogModel {
    struct InputCandidate: Identifiable, Equatable {
        let id: URL
        let url: URL
        let displayName: String
        let relativePath: String
    }

    enum ValidationError: Error, Equatable {
        case missingProject
        case missingInputs
        case missingWorkflow
    }

    let projectURL: URL?
    let availableWorkflows: [NFCoreSupportedWorkflow]
    private(set) var inputCandidates: [InputCandidate]
    private var selectedInputURLs: Set<URL> = []

    var selectedWorkflow: NFCoreSupportedWorkflow?
    var executor: NFCoreExecutor = .docker
    var version: String = ""

    init(
        projectURL: URL?,
        workflows: [NFCoreSupportedWorkflow] = NFCoreSupportedWorkflowCatalog.firstWave,
        fileManager: FileManager = .default
    ) {
        self.projectURL = projectURL?.standardizedFileURL
        self.availableWorkflows = workflows
        self.selectedWorkflow = workflows.first
        self.inputCandidates = Self.discoverInputCandidates(projectURL: projectURL, fileManager: fileManager)
    }

    func selectWorkflow(named name: String) {
        selectedWorkflow = availableWorkflows.first { $0.name == name || $0.fullName == name } ?? selectedWorkflow
    }

    func isInputSelected(_ url: URL) -> Bool {
        selectedInputURLs.contains(url.standardizedFileURL)
    }

    func setInputSelected(_ url: URL, selected: Bool) {
        let standardizedURL = url.standardizedFileURL
        if selected {
            selectedInputURLs.insert(standardizedURL)
        } else {
            selectedInputURLs.remove(standardizedURL)
        }
    }

    func selectAllInputs() {
        selectedInputURLs = Set(inputCandidates.map { $0.url.standardizedFileURL })
    }

    func clearInputSelection() {
        selectedInputURLs.removeAll()
    }

    func makeRequest() throws -> NFCoreRunRequest {
        guard let projectURL else { throw ValidationError.missingProject }
        guard let selectedWorkflow else { throw ValidationError.missingWorkflow }
        let selectedInputs = inputCandidates
            .map(\.url)
            .filter { selectedInputURLs.contains($0.standardizedFileURL) }
        guard !selectedInputs.isEmpty else { throw ValidationError.missingInputs }

        let outputDirectory = projectURL
            .appendingPathComponent("Analyses", isDirectory: true)
            .appendingPathComponent("nf-core-\(selectedWorkflow.name)-results", isDirectory: true)
        return NFCoreRunRequest(
            workflow: selectedWorkflow,
            version: version.trimmingCharacters(in: .whitespacesAndNewlines),
            executor: executor,
            inputURLs: selectedInputs,
            outputDirectory: outputDirectory
        )
    }

    var bundleRootURL: URL? {
        projectURL?.appendingPathComponent("Analyses", isDirectory: true)
    }

    private static func discoverInputCandidates(projectURL: URL?, fileManager: FileManager) -> [InputCandidate] {
        guard let projectURL else { return [] }
        let keys: Set<URLResourceKey> = [.isDirectoryKey, .isRegularFileKey]
        guard let enumerator = fileManager.enumerator(
            at: projectURL,
            includingPropertiesForKeys: Array(keys),
            options: [.skipsHiddenFiles]
        ) else { return [] }

        var candidates: [InputCandidate] = []
        for case let url as URL in enumerator {
            if url.pathExtension == NFCoreRunBundleStore.directoryExtension {
                enumerator.skipDescendants()
                continue
            }
            let values = try? url.resourceValues(forKeys: keys)
            if values?.isDirectory == true {
                if shouldSkipDirectory(url) {
                    enumerator.skipDescendants()
                }
                continue
            }
            guard values?.isRegularFile == true, isSupportedInput(url) else { continue }
            let relativePath = relativePath(for: url, projectURL: projectURL)
            candidates.append(InputCandidate(
                id: url.standardizedFileURL,
                url: url.standardizedFileURL,
                displayName: url.lastPathComponent,
                relativePath: relativePath
            ))
        }
        return candidates.sorted { $0.relativePath.localizedStandardCompare($1.relativePath) == .orderedAscending }
    }

    private static func shouldSkipDirectory(_ url: URL) -> Bool {
        let name = url.lastPathComponent
        return name.hasSuffix(".lungfishrun")
            || name == ".build"
            || name == "build"
            || name == "DerivedData"
    }

    private static func isSupportedInput(_ url: URL) -> Bool {
        let name = url.lastPathComponent.lowercased()
        return [
            ".fastq", ".fq", ".fastq.gz", ".fq.gz",
            ".fasta", ".fa", ".fna", ".fasta.gz", ".fa.gz",
            ".bam", ".cram", ".vcf", ".vcf.gz", ".csv", ".tsv", ".txt",
        ].contains { name.hasSuffix($0) }
    }

    private static func relativePath(for url: URL, projectURL: URL) -> String {
        let projectPath = projectURL.standardizedFileURL.path
        let path = url.standardizedFileURL.path
        guard path.hasPrefix(projectPath + "/") else { return url.lastPathComponent }
        return String(path.dropFirst(projectPath.count + 1))
    }
}
