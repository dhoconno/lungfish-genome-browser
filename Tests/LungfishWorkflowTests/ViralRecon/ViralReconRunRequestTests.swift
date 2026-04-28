import XCTest
@testable import LungfishWorkflow

final class ViralReconRunRequestTests: XCTestCase {
    func testIlluminaRequestBuildsViralReconCLIArgumentsWithGeneratedParameters() throws {
        let input = URL(fileURLWithPath: "/tmp/run/inputs/samplesheet.csv")
        let output = URL(fileURLWithPath: "/tmp/run/outputs")
        let request = try ViralReconRunRequest(
            samples: [
                ViralReconSample(
                    sampleName: "SARS2_A",
                    sourceBundleURL: URL(fileURLWithPath: "/tmp/A.lungfishfastq"),
                    fastqURLs: [
                        URL(fileURLWithPath: "/tmp/A_R1.fastq.gz"),
                        URL(fileURLWithPath: "/tmp/A_R2.fastq.gz"),
                    ],
                    barcode: nil,
                    sequencingSummaryURL: nil
                )
            ],
            platform: .illumina,
            protocol: .amplicon,
            samplesheetURL: input,
            outputDirectory: output,
            executor: .docker,
            version: "3.0.0",
            reference: .genome("MN908947.3"),
            primer: ViralReconPrimerSelection(
                bundleURL: URL(fileURLWithPath: "/tmp/QIASeqDIRECT-SARS2.lungfishprimers"),
                displayName: "QIASeq DIRECT SARS-CoV-2",
                bedURL: URL(fileURLWithPath: "/tmp/primers.bed"),
                fastaURL: URL(fileURLWithPath: "/tmp/primers.fasta"),
                leftSuffix: "_LEFT",
                rightSuffix: "_RIGHT",
                derivedFasta: true
            ),
            minimumMappedReads: 1000,
            variantCaller: .ivar,
            consensusCaller: .bcftools,
            skipOptions: [.assembly, .kraken2],
            advancedParams: ["max_cpus": "4", "max_memory": "8.GB"]
        )

        let args = request.cliArguments(bundlePath: URL(fileURLWithPath: "/tmp/run/viralrecon.lungfishrun"))

        XCTAssertEqual(args.prefix(3), ["workflow", "run", "nf-core/viralrecon"])
        XCTAssertTrue(args.contains("--version"))
        XCTAssertTrue(args.contains("3.0.0"))
        XCTAssertTrue(args.contains("--param"))
        XCTAssertTrue(args.contains("platform=illumina"))
        XCTAssertTrue(args.contains("protocol=amplicon"))
        XCTAssertTrue(args.contains("genome=MN908947.3"))
        XCTAssertTrue(args.contains("primer_bed=/tmp/primers.bed"))
        XCTAssertTrue(args.contains("primer_fasta=/tmp/primers.fasta"))
        XCTAssertTrue(args.contains("skip_assembly=true"))
        XCTAssertTrue(args.contains("skip_kraken2=true"))
    }

    func testAdvancedParamsRejectGeneratedKeys() {
        XCTAssertThrowsError(
            try ViralReconRunRequest.validateAdvancedParams(["input": "manual.csv"])
        ) { error in
            XCTAssertEqual(error as? ViralReconRunRequest.ValidationError, .conflictingAdvancedParam("input"))
        }
    }
}
