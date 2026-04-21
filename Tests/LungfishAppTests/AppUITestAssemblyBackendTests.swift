import XCTest
@testable import LungfishApp
import LungfishWorkflow

final class AppUITestAssemblyBackendTests: XCTestCase {
    func testBackendSynthesizesMegahitAnalysisArtifacts() throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("assembly-ui-backend-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let request = AssemblyRunRequest(
            tool: .megahit,
            readType: .illuminaShortReads,
            inputURLs: [
                URL(fileURLWithPath: "/tmp/R1.fastq.gz"),
                URL(fileURLWithPath: "/tmp/R2.fastq.gz"),
            ],
            projectName: "demo",
            outputDirectory: tempDir,
            pairedEnd: true,
            threads: 8
        )

        try AppUITestAssemblyBackend.writeResult(for: request)

        XCTAssertTrue(
            FileManager.default.fileExists(
                atPath: tempDir.appendingPathComponent("assembly-result.json").path
            )
        )
        XCTAssertTrue(
            FileManager.default.fileExists(
                atPath: tempDir.appendingPathComponent("contigs.fasta").path
            )
        )
        XCTAssertEqual(try AssemblyResult.load(from: tempDir).tool, .megahit)
    }

    func testBackendSynthesizesArtifactsForEveryAssemblyTool() throws {
        let fileManager = FileManager.default
        let parent = fileManager.temporaryDirectory
            .appendingPathComponent("assembly-ui-backend-each-\(UUID().uuidString)", isDirectory: true)
        try fileManager.createDirectory(at: parent, withIntermediateDirectories: true)
        defer { try? fileManager.removeItem(at: parent) }

        for tool in AssemblyTool.allCases {
            let tempDir = parent.appendingPathComponent(tool.rawValue, isDirectory: true)
            try fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true)

            let request = AssemblyRunRequest(
                tool: tool,
                readType: defaultReadType(for: tool),
                inputURLs: [
                    URL(fileURLWithPath: "/tmp/\(tool.rawValue).fastq.gz")
                ],
                projectName: "demo-\(tool.rawValue)",
                outputDirectory: tempDir,
                pairedEnd: false,
                threads: 4
            )

            try AppUITestAssemblyBackend.writeResult(for: request)
            let loaded = try AssemblyResult.load(from: tempDir)
            XCTAssertEqual(loaded.tool, tool)
            XCTAssertGreaterThan(loaded.statistics.contigCount, 0)
        }
    }

    private func defaultReadType(for tool: AssemblyTool) -> AssemblyReadType {
        switch tool {
        case .spades, .megahit, .skesa:
            return .illuminaShortReads
        case .flye:
            return .ontReads
        case .hifiasm:
            return .pacBioHiFi
        }
    }
}
