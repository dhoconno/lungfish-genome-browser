import XCTest
@testable import LungfishApp

final class FASTQOperationExecutionServiceTests: XCTestCase {
    func testMapLaunchBuildsTopLevelMapInvocation() throws {
        let request = FASTQOperationLaunchRequest.map(
            inputURLs: [
                URL(fileURLWithPath: "/tmp/R1.fastq"),
                URL(fileURLWithPath: "/tmp/R2.fastq"),
            ],
            referenceURL: URL(fileURLWithPath: "/tmp/ref.fasta"),
            outputMode: .groupedResult
        )

        let invocation = try FASTQOperationExecutionService().buildInvocation(for: request)

        XCTAssertEqual(invocation.subcommand, "map")
        XCTAssertEqual(invocation.arguments, [
            "/tmp/R1.fastq",
            "/tmp/R2.fastq",
            "--reference",
            "/tmp/ref.fasta",
            "--paired",
        ])
    }

    func testRefreshQCSummaryLaunchBuildsFastqQCSummaryInvocation() throws {
        let request = FASTQOperationLaunchRequest.refreshQCSummary(
            inputURLs: [
                URL(fileURLWithPath: "/tmp/input-1.fastq"),
                URL(fileURLWithPath: "/tmp/input-2.fastq"),
            ]
        )

        let invocation = try FASTQOperationExecutionService().buildInvocation(for: request)

        XCTAssertEqual(invocation.subcommand, "fastq")
        XCTAssertEqual(invocation.arguments, [
            "qc-summary",
            "/tmp/input-1.fastq",
            "/tmp/input-2.fastq",
            "--output",
            "<derived>",
        ])
    }

    @MainActor
    func testPrepareForRunSynthesizesConcreteDerivativeRequest() throws {
        let state = FASTQOperationDialogState(
            initialCategory: .readProcessing,
            selectedInputURLs: [URL(fileURLWithPath: "/tmp/input.fastq")],
            projectURL: nil
        )
        state.selectTool(.orientReads)
        state.setAuxiliaryInput(URL(fileURLWithPath: "/tmp/reference.fasta"), for: .referenceSequence)

        state.prepareForRun()

        guard case .derivative(let request, let inputURLs, let outputMode)? = state.pendingLaunchRequest else {
            return XCTFail("Expected concrete derivative launch request")
        }

        XCTAssertEqual(inputURLs, [URL(fileURLWithPath: "/tmp/input.fastq")])
        XCTAssertEqual(outputMode, .perInput)
        XCTAssertEqual(request, .orient(
            referenceURL: URL(fileURLWithPath: "/tmp/reference.fasta"),
            wordLength: 12,
            dbMask: "dust",
            saveUnoriented: true
        ))
    }

    func testDerivativeLaunchBuildsConcreteFastqInvocation() throws {
        let request = FASTQOperationLaunchRequest.derivative(
            request: .subsampleProportion(0.25),
            inputURLs: [URL(fileURLWithPath: "/tmp/input.fastq")],
            outputMode: .perInput
        )

        let invocation = try FASTQOperationExecutionService().buildInvocation(for: request)

        XCTAssertEqual(invocation.subcommand, "fastq")
        XCTAssertEqual(invocation.arguments, [
            "subsample",
            "/tmp/input.fastq",
            "--proportion",
            "0.25",
            "-o",
            "<derived>",
        ])
    }

    func testClassificationLaunchesMapToTopLevelCommands() throws {
        let baseInput = [URL(fileURLWithPath: "/tmp/input.fastq")]

        let kraken2 = try FASTQOperationExecutionService().buildInvocation(
            for: .classify(tool: .kraken2, inputURLs: baseInput, databaseName: "kraken-db")
        )
        XCTAssertEqual(kraken2.subcommand, "classify")

        let esviritu = try FASTQOperationExecutionService().buildInvocation(
            for: .classify(tool: .esViritu, inputURLs: baseInput, databaseName: "esv-db")
        )
        XCTAssertEqual(esviritu.subcommand, "esviritu")

        let taxtriage = try FASTQOperationExecutionService().buildInvocation(
            for: .classify(tool: .taxTriage, inputURLs: baseInput, databaseName: "tax-db")
        )
        XCTAssertEqual(taxtriage.subcommand, "taxtriage")
    }
}
