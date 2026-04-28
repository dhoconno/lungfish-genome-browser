import Foundation
import LungfishWorkflow

@MainActor
final class ViralReconWorkflowExecutionService {
    struct RunResult {
        let operationID: UUID
        let bundleURL: URL
        let operationItem: OperationCenter.Item?
    }

    private let operationCenter: OperationCenter
    private let processRunner: ViralReconWorkflowProcessRunning

    init(
        operationCenter: OperationCenter = .shared,
        processRunner: ViralReconWorkflowProcessRunning = ProcessViralReconWorkflowProcessRunner()
    ) {
        self.operationCenter = operationCenter
        self.processRunner = processRunner
    }

    func run(_ request: ViralReconRunRequest, bundleRoot: URL) async throws -> RunResult {
        try FileManager.default.createDirectory(at: bundleRoot, withIntermediateDirectories: true)
        let bundleURL = try availableBundleURL(in: bundleRoot)
        try writeRunBundle(for: request, to: bundleURL)

        let commandPreview = cliCommandPreview(for: request, bundleURL: bundleURL)
        let operationID = operationCenter.start(
            title: "Viral Recon",
            detail: "\(request.platform.rawValue) · \(request.samples.count) sample(s)",
            operationType: .viralRecon,
            targetBundleURL: bundleURL,
            cliCommand: commandPreview
        )
        logPreparation(for: request, bundleURL: bundleURL, commandPreview: commandPreview, operationID: operationID)

        do {
            let processResult = try await processRunner.runLungfishCLI(
                arguments: request.cliArguments(bundlePath: bundleURL),
                workingDirectory: bundleURL
            )
            try writeProcessLogs(processResult, to: bundleURL.appendingPathComponent("logs", isDirectory: true))

            if processResult.exitCode == 0 {
                operationCenter.log(id: operationID, level: .info, message: "Viral Recon completed")
                operationCenter.complete(
                    id: operationID,
                    detail: "Viral Recon completed",
                    bundleURLs: [bundleURL]
                )
            } else {
                let tail = stderrTail(processResult.standardError)
                operationCenter.log(
                    id: operationID,
                    level: .error,
                    message: "Viral Recon failed with exit code \(processResult.exitCode)"
                )
                operationCenter.fail(
                    id: operationID,
                    detail: "Viral Recon failed",
                    errorMessage: "Viral Recon failed",
                    errorDetail: tail
                )
                throw ViralReconWorkflowExecutionError.nonZeroExit(processResult.exitCode)
            }
        } catch {
            if operationCenter.items.first(where: { $0.id == operationID })?.state == .running {
                operationCenter.fail(
                    id: operationID,
                    detail: "Viral Recon failed",
                    errorMessage: "Viral Recon failed",
                    errorDetail: String(describing: error)
                )
            }
            throw error
        }

        return RunResult(
            operationID: operationID,
            bundleURL: bundleURL,
            operationItem: operationCenter.items.first { $0.id == operationID }
        )
    }

    private func writeRunBundle(for request: ViralReconRunRequest, to bundleURL: URL) throws {
        let workflow = try viralReconWorkflow()
        let runRequest = NFCoreRunRequest(
            workflow: workflow,
            version: request.version,
            executor: request.executor,
            inputURLs: [request.samplesheetURL],
            outputDirectory: request.outputDirectory,
            params: request.effectiveParams,
            presentationMode: .customAdapter("viralrecon")
        )
        try NFCoreRunBundleStore.write(runRequest.manifest(), to: bundleURL)

        let inputsURL = bundleURL.appendingPathComponent("inputs", isDirectory: true)
        try FileManager.default.createDirectory(at: inputsURL, withIntermediateDirectories: true)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(request)
        try data.write(to: inputsURL.appendingPathComponent("viralrecon-request.json"), options: .atomic)
        try request.samplesheetURL.path.write(
            to: inputsURL.appendingPathComponent("samplesheet.path"),
            atomically: true,
            encoding: .utf8
        )
    }

    private func logPreparation(
        for request: ViralReconRunRequest,
        bundleURL: URL,
        commandPreview: String,
        operationID: UUID
    ) {
        operationCenter.log(
            id: operationID,
            level: .info,
            message: "Prepared run bundle at \(bundleURL.path)"
        )
        operationCenter.log(
            id: operationID,
            level: .info,
            message: "Using samplesheet \(request.samplesheetURL.path)"
        )
        operationCenter.log(
            id: operationID,
            level: .info,
            message: "Using primer scheme \(request.primer.displayName) from \(request.primer.bundleURL.path)"
        )
        if request.primer.derivedFasta {
            operationCenter.log(
                id: operationID,
                level: .info,
                message: "Using derived primer FASTA \(request.primer.fastaURL.path)"
            )
        }
        operationCenter.log(id: operationID, level: .info, message: commandPreview)
    }

    private func availableBundleURL(in root: URL) throws -> URL {
        let base = root.appendingPathComponent("viralrecon.\(NFCoreRunBundleStore.directoryExtension)", isDirectory: true)
        guard FileManager.default.fileExists(atPath: base.path) else {
            return base
        }

        for index in 2...999 {
            let candidate = root.appendingPathComponent(
                "viralrecon-\(index).\(NFCoreRunBundleStore.directoryExtension)",
                isDirectory: true
            )
            if !FileManager.default.fileExists(atPath: candidate.path) {
                return candidate
            }
        }

        throw CocoaError(.fileWriteFileExists, userInfo: [NSFilePathErrorKey: base.path])
    }

    private func viralReconWorkflow() throws -> NFCoreSupportedWorkflow {
        if let workflow = NFCoreSupportedWorkflowCatalog.workflow(named: "viralrecon") {
            return workflow
        }
        throw ViralReconWorkflowExecutionError.missingWorkflowDefinition
    }

    private func writeProcessLogs(_ result: ViralReconWorkflowProcessResult, to logsURL: URL) throws {
        try FileManager.default.createDirectory(at: logsURL, withIntermediateDirectories: true)
        try result.standardOutput.write(
            to: logsURL.appendingPathComponent("stdout.log"),
            atomically: true,
            encoding: .utf8
        )
        try result.standardError.write(
            to: logsURL.appendingPathComponent("stderr.log"),
            atomically: true,
            encoding: .utf8
        )
    }

    private func cliCommandPreview(for request: ViralReconRunRequest, bundleURL: URL) -> String {
        (["lungfish-cli"] + request.cliArguments(bundlePath: bundleURL))
            .map(Self.shellEscaped)
            .joined(separator: " ")
    }

    private static func shellEscaped(_ value: String) -> String {
        guard value.rangeOfCharacter(from: .whitespacesAndNewlines) != nil else {
            return value
        }
        return "'\(value.replacingOccurrences(of: "'", with: "'\\''"))'"
    }

    private func stderrTail(_ stderr: String) -> String {
        let lines = stderr.split(separator: "\n", omittingEmptySubsequences: false)
        return lines.suffix(40).joined(separator: "\n")
    }
}

struct ViralReconWorkflowProcessResult: Sendable, Equatable {
    let exitCode: Int32
    let standardOutput: String
    let standardError: String
}

@MainActor
protocol ViralReconWorkflowProcessRunning {
    func runLungfishCLI(arguments: [String], workingDirectory: URL) async throws -> ViralReconWorkflowProcessResult
}

enum ViralReconWorkflowExecutionError: Error, Equatable {
    case nonZeroExit(Int32)
    case missingWorkflowDefinition
}

struct ProcessViralReconWorkflowProcessRunner: ViralReconWorkflowProcessRunning {
    func runLungfishCLI(arguments: [String], workingDirectory: URL) async throws -> ViralReconWorkflowProcessResult {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try FileManager.default.createDirectory(at: workingDirectory, withIntermediateDirectories: true)
                let captureID = UUID().uuidString
                let stdoutURL = workingDirectory.appendingPathComponent(".viralrecon-\(captureID)-stdout.log")
                let stderrURL = workingDirectory.appendingPathComponent(".viralrecon-\(captureID)-stderr.log")
                _ = FileManager.default.createFile(atPath: stdoutURL.path, contents: nil)
                _ = FileManager.default.createFile(atPath: stderrURL.path, contents: nil)
                let stdoutHandle = try FileHandle(forWritingTo: stdoutURL)
                let stderrHandle = try FileHandle(forWritingTo: stderrURL)

                let process = Process()
                if let cliURL = Self.lungfishCLIURL() {
                    process.executableURL = cliURL
                    process.arguments = arguments
                } else {
                    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
                    process.arguments = ["lungfish-cli"] + arguments
                }
                process.currentDirectoryURL = workingDirectory
                process.standardOutput = stdoutHandle
                process.standardError = stderrHandle
                process.terminationHandler = { process in
                    try? stdoutHandle.close()
                    try? stderrHandle.close()
                    let outputData = (try? Data(contentsOf: stdoutURL)) ?? Data()
                    let errorData = (try? Data(contentsOf: stderrURL)) ?? Data()
                    try? FileManager.default.removeItem(at: stdoutURL)
                    try? FileManager.default.removeItem(at: stderrURL)
                    continuation.resume(returning: ViralReconWorkflowProcessResult(
                        exitCode: process.terminationStatus,
                        standardOutput: String(data: outputData, encoding: .utf8) ?? "",
                        standardError: String(data: errorData, encoding: .utf8) ?? ""
                    ))
                }

                try process.run()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    private static func lungfishCLIURL() -> URL? {
        let environment = ProcessInfo.processInfo.environment
        if let path = environment["LUNGFISH_CLI_PATH"],
           FileManager.default.isExecutableFile(atPath: path) {
            return URL(fileURLWithPath: path)
        }

        let bundled = Bundle.main.bundleURL
            .appendingPathComponent("Contents/MacOS/lungfish-cli")
        if FileManager.default.isExecutableFile(atPath: bundled.path) {
            return bundled
        }

        return nil
    }
}
