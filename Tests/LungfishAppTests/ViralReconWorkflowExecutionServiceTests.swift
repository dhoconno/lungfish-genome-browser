import XCTest
@testable import LungfishApp
@testable import LungfishWorkflow

@MainActor
final class ViralReconWorkflowExecutionServiceTests: XCTestCase {
    func testServiceCreatesRunBundleAndLogsPreparation() async throws {
        let temp = FileManager.default.temporaryDirectory
            .appendingPathComponent("viral-recon-service-\(UUID().uuidString)", isDirectory: true)
        defer { try? FileManager.default.removeItem(at: temp) }

        let request = try ViralReconAppTestFixtures.illuminaRequest(root: temp)
        let operationCenter = OperationCenter()
        let runner = StubViralReconProcessRunner(result: .init(
            exitCode: 0,
            standardOutput: "nextflow progress",
            standardError: ""
        ))
        let service = ViralReconWorkflowExecutionService(operationCenter: operationCenter, processRunner: runner)

        let result = try await service.run(
            request,
            bundleRoot: temp.appendingPathComponent("Analyses", isDirectory: true)
        )

        XCTAssertEqual(result.bundleURL.pathExtension, "lungfishrun")
        XCTAssertEqual(runner.invocations.first?.arguments, request.cliArguments(bundlePath: result.bundleURL))
        XCTAssertEqual(runner.invocations.first?.workingDirectory, result.bundleURL)

        let manifest = try NFCoreRunBundleStore.read(from: result.bundleURL)
        XCTAssertEqual(manifest.workflowName, "viralrecon")
        XCTAssertEqual(manifest.version, "3.0.0")
        XCTAssertEqual(manifest.executor, .docker)
        XCTAssertEqual(manifest.params["input"], request.samplesheetURL.path)

        XCTAssertEqual(
            try String(contentsOf: result.bundleURL.appendingPathComponent("logs/stdout.log")),
            "nextflow progress"
        )
        XCTAssertEqual(
            try String(contentsOf: result.bundleURL.appendingPathComponent("logs/stderr.log")),
            ""
        )

        let item = try XCTUnwrap(operationCenter.items.first { $0.id == result.operationID })
        XCTAssertEqual(item.operationType, .viralRecon)
        XCTAssertEqual(item.title, "Viral Recon")
        XCTAssertEqual(item.cliCommand, expectedCLICommand(for: request, bundleURL: result.bundleURL))
        XCTAssertTrue(item.logEntries.map(\.message).contains { $0.contains("samplesheet") })
        XCTAssertTrue(item.logEntries.map(\.message).contains { $0.contains("lungfish-cli workflow run nf-core/viralrecon") })
        XCTAssertEqual(item.state, .completed)
        XCTAssertEqual(item.bundleURLs, [result.bundleURL])
    }

    func testServiceFailsWithExitCodeAndStderrTail() async throws {
        let temp = FileManager.default.temporaryDirectory
            .appendingPathComponent("viral-recon-service-\(UUID().uuidString)", isDirectory: true)
        defer { try? FileManager.default.removeItem(at: temp) }

        let request = try ViralReconAppTestFixtures.illuminaRequest(root: temp)
        let operationCenter = OperationCenter()
        let runner = StubViralReconProcessRunner(result: .init(
            exitCode: 2,
            standardOutput: "",
            standardError: "bad params"
        ))
        let service = ViralReconWorkflowExecutionService(operationCenter: operationCenter, processRunner: runner)

        do {
            _ = try await service.run(
                request,
                bundleRoot: temp.appendingPathComponent("Analyses", isDirectory: true)
            )
            XCTFail("Expected Viral Recon service to throw for a non-zero CLI exit")
        } catch {
            XCTAssertEqual(error as? ViralReconWorkflowExecutionError, .nonZeroExit(2))
        }

        let item = try XCTUnwrap(operationCenter.items.first)
        XCTAssertEqual(item.state, .failed)
        XCTAssertEqual(item.errorMessage, "Viral Recon failed")
        XCTAssertTrue(item.errorDetail?.contains("bad params") == true)
    }

    func testServiceAllocatesUniqueBundleNames() async throws {
        let temp = FileManager.default.temporaryDirectory
            .appendingPathComponent("viral-recon-service-\(UUID().uuidString)", isDirectory: true)
        defer { try? FileManager.default.removeItem(at: temp) }

        let request = try ViralReconAppTestFixtures.illuminaRequest(root: temp)
        let analyses = temp.appendingPathComponent("Analyses", isDirectory: true)
        try FileManager.default.createDirectory(
            at: analyses.appendingPathComponent("viralrecon.lungfishrun", isDirectory: true),
            withIntermediateDirectories: true
        )
        let operationCenter = OperationCenter()
        let service = ViralReconWorkflowExecutionService(
            operationCenter: operationCenter,
            processRunner: StubViralReconProcessRunner(result: .init(exitCode: 0, standardOutput: "", standardError: ""))
        )

        let result = try await service.run(request, bundleRoot: analyses)

        XCTAssertEqual(result.bundleURL.lastPathComponent, "viralrecon-2.lungfishrun")
    }
}

@MainActor
private final class StubViralReconProcessRunner: ViralReconWorkflowProcessRunning {
    struct Invocation: Equatable {
        let arguments: [String]
        let workingDirectory: URL
    }

    private(set) var invocations: [Invocation] = []
    let result: ViralReconWorkflowProcessResult

    init(result: ViralReconWorkflowProcessResult) {
        self.result = result
    }

    func runLungfishCLI(arguments: [String], workingDirectory: URL) async throws -> ViralReconWorkflowProcessResult {
        invocations.append(Invocation(arguments: arguments, workingDirectory: workingDirectory))
        return result
    }
}

private func expectedCLICommand(for request: ViralReconRunRequest, bundleURL: URL) -> String {
    (["lungfish-cli"] + request.cliArguments(bundlePath: bundleURL))
        .map { value in
            guard value.rangeOfCharacter(from: .whitespacesAndNewlines) != nil else {
                return value
            }
            return "'\(value.replacingOccurrences(of: "'", with: "'\\''"))'"
        }
        .joined(separator: " ")
}
