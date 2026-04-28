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
        let persistedRequest = try persistGeneratedInputs(from: request, in: bundleURL)
        try writeRunBundle(for: persistedRequest, to: bundleURL)

        let commandPreview = cliCommandPreview(for: persistedRequest, bundleURL: bundleURL)
        let operationID = operationCenter.start(
            title: "Viral Recon",
            detail: initialDetail(for: persistedRequest),
            operationType: .viralRecon,
            targetBundleURL: bundleURL,
            cliCommand: commandPreview
        )
        logPreparation(for: persistedRequest, bundleURL: bundleURL, commandPreview: commandPreview, operationID: operationID)

        do {
            let processResult = try await processRunner.runLungfishCLI(
                arguments: persistedRequest.cliArguments(bundlePath: bundleURL),
                workingDirectory: bundleURL,
                outputHandler: { [operationCenter] output in
                    switch output {
                    case .standardOutput(let line):
                        operationCenter.log(id: operationID, level: .info, message: line)
                    case .standardError(let line):
                        operationCenter.log(id: operationID, level: .warning, message: line)
                    }
                }
            )
            try writeProcessLogs(processResult, to: bundleURL.appendingPathComponent("logs", isDirectory: true))
            logProcessOutput(processResult, operationID: operationID)

            if processResult.exitCode == 0 {
                operationCenter.log(id: operationID, level: .info, message: "Viral Recon completed")
                operationCenter.complete(
                    id: operationID,
                    detail: completionDetail(for: persistedRequest, bundleURL: bundleURL),
                    bundleURLs: [bundleURL]
                )
            } else {
                let tail = stderrTail(processResult.standardError)
                let failureDetail = failureDetail(exitCode: processResult.exitCode, stderrTail: tail)
                operationCenter.log(
                    id: operationID,
                    level: .error,
                    message: "Viral Recon failed with exit code \(processResult.exitCode)"
                )
                operationCenter.fail(
                    id: operationID,
                    detail: failureDetail,
                    errorMessage: "Viral Recon failed (exit code \(processResult.exitCode))",
                    errorDetail: "exit code \(processResult.exitCode)\n\n\(tail)"
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

    private func persistGeneratedInputs(from request: ViralReconRunRequest, in bundleURL: URL) throws -> ViralReconRunRequest {
        let inputsURL = bundleURL.appendingPathComponent("inputs", isDirectory: true)
        let primersURL = inputsURL.appendingPathComponent("primers", isDirectory: true)
        let nanoporeURL = inputsURL.appendingPathComponent("nanopore", isDirectory: true)
        try FileManager.default.createDirectory(at: primersURL, withIntermediateDirectories: true)

        let samplesheetURL = inputsURL.appendingPathComponent("samplesheet.csv")
        let primerBEDURL = primersURL.appendingPathComponent("primers.bed")
        let primerFASTAURL = primersURL.appendingPathComponent("primers.fasta")
        try copyItem(from: request.samplesheetURL, to: samplesheetURL)
        try copyItem(from: request.primer.bedURL, to: primerBEDURL)
        try copyItem(from: request.primer.fastaURL, to: primerFASTAURL)

        var fastqPassDirectoryURL: URL?
        var sequencingSummaryURL: URL?
        if request.platform == .nanopore {
            if let sourceFastqPass = request.fastqPassDirectoryURL {
                try FileManager.default.createDirectory(at: nanoporeURL, withIntermediateDirectories: true)
                let destinationFastqPass = nanoporeURL.appendingPathComponent("fastq_pass", isDirectory: true)
                try copyItem(from: sourceFastqPass, to: destinationFastqPass)
                fastqPassDirectoryURL = destinationFastqPass
            }
            if let sourceSummary = request.sequencingSummaryURL {
                try FileManager.default.createDirectory(at: nanoporeURL, withIntermediateDirectories: true)
                let destinationSummary = nanoporeURL.appendingPathComponent(sourceSummary.lastPathComponent)
                try copyItem(from: sourceSummary, to: destinationSummary)
                sequencingSummaryURL = destinationSummary
            }
        }

        let primer = ViralReconPrimerSelection(
            bundleURL: request.primer.bundleURL,
            displayName: request.primer.displayName,
            bedURL: primerBEDURL,
            fastaURL: primerFASTAURL,
            leftSuffix: request.primer.leftSuffix,
            rightSuffix: request.primer.rightSuffix,
            derivedFasta: request.primer.derivedFasta
        )

        return try ViralReconRunRequest(
            samples: request.samples,
            platform: request.platform,
            protocol: request.protocol,
            samplesheetURL: samplesheetURL,
            outputDirectory: request.outputDirectory,
            executor: request.executor,
            version: request.version,
            reference: request.reference,
            primer: primer,
            minimumMappedReads: request.minimumMappedReads,
            variantCaller: request.variantCaller,
            consensusCaller: request.consensusCaller,
            skipOptions: request.skipOptions,
            advancedParams: request.advancedParams,
            fastqPassDirectoryURL: fastqPassDirectoryURL ?? request.fastqPassDirectoryURL,
            sequencingSummaryURL: sequencingSummaryURL ?? request.sequencingSummaryURL
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

    private func logProcessOutput(_ result: ViralReconWorkflowProcessResult, operationID: UUID) {
        for line in result.standardOutput.split(whereSeparator: \.isNewline) {
            operationCenter.log(id: operationID, level: .info, message: String(line))
        }
        for line in result.standardError.split(whereSeparator: \.isNewline) {
            operationCenter.log(id: operationID, level: .warning, message: String(line))
        }
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

    private func initialDetail(for request: ViralReconRunRequest) -> String {
        "\(request.platform.rawValue) · \(request.samples.count) sample(s) · \(referenceDisplayName(request.reference))"
    }

    private func completionDetail(for request: ViralReconRunRequest, bundleURL: URL) -> String {
        "Viral Recon completed. Output: \(request.outputDirectory.path). Run bundle: \(bundleURL.path)"
    }

    private func failureDetail(exitCode: Int32, stderrTail: String) -> String {
        let trimmedTail = stderrTail.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTail.isEmpty else {
            return "Viral Recon failed with exit code \(exitCode)"
        }
        return "Viral Recon failed with exit code \(exitCode). \(trimmedTail)"
    }

    private func referenceDisplayName(_ reference: ViralReconReference) -> String {
        switch reference {
        case .genome(let accession):
            return accession
        case .local(let fastaURL, _):
            return fastaURL.lastPathComponent
        }
    }

    private func copyItem(from sourceURL: URL, to destinationURL: URL) throws {
        let source = sourceURL.standardizedFileURL
        let destination = destinationURL.standardizedFileURL
        if source.path == destination.path {
            return
        }
        if FileManager.default.fileExists(atPath: destination.path) {
            try FileManager.default.removeItem(at: destination)
        }
        try FileManager.default.createDirectory(
            at: destination.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try FileManager.default.copyItem(at: source, to: destination)
    }
}

struct ViralReconWorkflowProcessResult: Sendable, Equatable {
    let exitCode: Int32
    let standardOutput: String
    let standardError: String
}

enum ViralReconWorkflowProcessOutput: Sendable, Equatable {
    case standardOutput(String)
    case standardError(String)
}

@MainActor
protocol ViralReconWorkflowProcessRunning {
    func runLungfishCLI(
        arguments: [String],
        workingDirectory: URL,
        outputHandler: (@MainActor @Sendable (ViralReconWorkflowProcessOutput) -> Void)?
    ) async throws -> ViralReconWorkflowProcessResult
}

enum ViralReconWorkflowExecutionError: Error, Equatable {
    case nonZeroExit(Int32)
    case missingWorkflowDefinition
}

struct ProcessViralReconWorkflowProcessRunner: ViralReconWorkflowProcessRunning {
    func runLungfishCLI(
        arguments: [String],
        workingDirectory: URL,
        outputHandler: (@MainActor @Sendable (ViralReconWorkflowProcessOutput) -> Void)?
    ) async throws -> ViralReconWorkflowProcessResult {
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
