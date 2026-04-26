import XCTest
@testable import LungfishApp
@testable import LungfishWorkflow

@MainActor
final class NFCoreWorkflowDialogModelTests: XCTestCase {
    func testModelDiscoversProjectInputsAndBuildsRunRequest() throws {
        let root = FileManager.default.temporaryDirectory
            .appendingPathComponent("nfcore-dialog-model-\(UUID().uuidString)", isDirectory: true)
        let project = root.appendingPathComponent("Demo.lungfish", isDirectory: true)
        let analyses = project.appendingPathComponent("Analyses", isDirectory: true)
        let read1 = project.appendingPathComponent("sample_R1.fastq.gz")
        let read2 = project.appendingPathComponent("sample_R2.fastq.gz")
        let ignored = analyses.appendingPathComponent("old.lungfishrun", isDirectory: true)
        defer { try? FileManager.default.removeItem(at: root) }

        try FileManager.default.createDirectory(at: analyses, withIntermediateDirectories: true)
        try Data("r1".utf8).write(to: read1)
        try Data("r2".utf8).write(to: read2)
        try FileManager.default.createDirectory(at: ignored, withIntermediateDirectories: true)

        let model = NFCoreWorkflowDialogModel(projectURL: project)

        XCTAssertEqual(model.availableWorkflows.map(\.name).first, "fetchngs")
        XCTAssertTrue(model.inputCandidates.map(\.url.lastPathComponent).contains("sample_R1.fastq.gz"))
        XCTAssertTrue(model.inputCandidates.map(\.url.lastPathComponent).contains("sample_R2.fastq.gz"))
        XCTAssertFalse(model.inputCandidates.map(\.url.lastPathComponent).contains("old.lungfishrun"))

        model.selectWorkflow(named: "seqinspector")
        model.setInputSelected(read1, selected: true)
        model.setInputSelected(read2, selected: true)
        model.executor = .conda
        model.version = "1.2.3"

        let request = try model.makeRequest()

        XCTAssertEqual(request.workflow.fullName, "nf-core/seqinspector")
        XCTAssertEqual(request.inputURLs, [read1.standardizedFileURL, read2.standardizedFileURL])
        XCTAssertEqual(request.executor, .conda)
        XCTAssertEqual(request.version, "1.2.3")
        XCTAssertEqual(request.outputDirectory, project.appendingPathComponent("Analyses/nf-core-seqinspector-results", isDirectory: true).standardizedFileURL)
    }

    func testModelRejectsRunWithoutInputs() {
        let project = FileManager.default.temporaryDirectory
            .appendingPathComponent("nfcore-empty-\(UUID().uuidString).lungfish", isDirectory: true)
        defer { try? FileManager.default.removeItem(at: project.deletingLastPathComponent()) }
        try? FileManager.default.createDirectory(at: project, withIntermediateDirectories: true)

        let model = NFCoreWorkflowDialogModel(projectURL: project)

        XCTAssertThrowsError(try model.makeRequest()) { error in
            XCTAssertEqual(error as? NFCoreWorkflowDialogModel.ValidationError, .missingInputs)
        }
    }
}
