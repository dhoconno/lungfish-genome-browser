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
        XCTAssertFalse(model.inputCandidates.map(\.url.lastPathComponent).contains("old.lungfishrun"))

        model.selectWorkflow(named: "seqinspector")
        XCTAssertTrue(model.inputCandidates.map(\.url.lastPathComponent).contains("sample_R1.fastq.gz"))
        XCTAssertTrue(model.inputCandidates.map(\.url.lastPathComponent).contains("sample_R2.fastq.gz"))

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

    func testFetchngsExplainsAccessionInputsAndUsesPinnedVersion() throws {
        let root = FileManager.default.temporaryDirectory
            .appendingPathComponent("nfcore-fetchngs-model-\(UUID().uuidString)", isDirectory: true)
        let project = root.appendingPathComponent("Demo.lungfish", isDirectory: true)
        let accessions = project.appendingPathComponent("accessions.csv")
        let reads = project.appendingPathComponent("reads.fastq.gz")
        defer { try? FileManager.default.removeItem(at: root) }

        try FileManager.default.createDirectory(at: project, withIntermediateDirectories: true)
        try Data("sample,run_accession\nA,SRR123\n".utf8).write(to: accessions)
        try Data("reads".utf8).write(to: reads)

        let model = NFCoreWorkflowDialogModel(projectURL: project)
        model.selectWorkflow(named: "fetchngs")

        XCTAssertEqual(model.selectedWorkflow?.name, "fetchngs")
        XCTAssertEqual(model.version, NFCoreSupportedWorkflowCatalog.workflow(named: "fetchngs")?.pinnedVersion)
        XCTAssertTrue(model.selectedWorkflowDetail.requiredInputs.contains("accession"))
        XCTAssertTrue(model.selectedWorkflowDetail.whenToUse.contains("download"))
        XCTAssertTrue(model.selectedWorkflowDetail.expectedOutputs.contains("FASTQ"))
        XCTAssertTrue(model.inputCandidates.map(\.displayName).contains("accessions.csv"))
        XCTAssertFalse(model.inputCandidates.map(\.displayName).contains("reads.fastq.gz"))

        model.setInputSelected(accessions, selected: true)
        let request = try model.makeRequest()

        XCTAssertEqual(request.version, NFCoreSupportedWorkflowCatalog.workflow(named: "fetchngs")?.pinnedVersion)
        XCTAssertEqual(request.params["input"], accessions.standardizedFileURL.path)
        XCTAssertTrue(request.commandPreview.contains("-r \(request.version)"))
    }

    func testSelectingWorkflowRefreshesFilteredInputsAndKeyParameters() throws {
        let root = FileManager.default.temporaryDirectory
            .appendingPathComponent("nfcore-filter-model-\(UUID().uuidString)", isDirectory: true)
        let project = root.appendingPathComponent("Demo.lungfish", isDirectory: true)
        let metadata = project.appendingPathComponent("accessions.tsv")
        let reads = project.appendingPathComponent("reads.fastq.gz")
        defer { try? FileManager.default.removeItem(at: root) }

        try FileManager.default.createDirectory(at: project, withIntermediateDirectories: true)
        try Data("SRR123\n".utf8).write(to: metadata)
        try Data("reads".utf8).write(to: reads)

        let model = NFCoreWorkflowDialogModel(projectURL: project)
        XCTAssertEqual(model.inputCandidates.map(\.displayName), ["accessions.tsv"])

        model.selectWorkflow(named: "seqinspector")

        XCTAssertEqual(model.inputCandidates.map(\.displayName), ["reads.fastq.gz"])
        XCTAssertTrue(model.selectedWorkflowDetail.keyParameters.contains { $0.name == "skip_fastqc" })
    }
}
