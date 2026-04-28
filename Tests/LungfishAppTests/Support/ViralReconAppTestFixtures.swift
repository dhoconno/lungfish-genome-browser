import Foundation
@testable import LungfishWorkflow

enum ViralReconAppTestFixtures {
    static func illuminaRequest(root: URL) throws -> ViralReconRunRequest {
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
        let inputs = root.appendingPathComponent("inputs", isDirectory: true)
        let outputs = root.appendingPathComponent("outputs", isDirectory: true)
        let primerBundle = root.appendingPathComponent("QIASeqDIRECT-SARS2.lungfishprimers", isDirectory: true)
        try FileManager.default.createDirectory(at: inputs, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: outputs, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: primerBundle, withIntermediateDirectories: true)

        let samplesheet = inputs.appendingPathComponent("samplesheet.csv")
        let read1 = inputs.appendingPathComponent("sample_R1.fastq.gz")
        let read2 = inputs.appendingPathComponent("sample_R2.fastq.gz")
        let primerBED = primerBundle.appendingPathComponent("primers.bed")
        let primerFASTA = primerBundle.appendingPathComponent("primers.fasta")

        try "sample,fastq_1,fastq_2\nSARS2_A,\(read1.path),\(read2.path)\n"
            .write(to: samplesheet, atomically: true, encoding: .utf8)
        FileManager.default.createFile(atPath: read1.path, contents: Data())
        FileManager.default.createFile(atPath: read2.path, contents: Data())
        try "MN908947.3\t1\t20\tSARS2_1_LEFT\nMN908947.3\t20\t40\tSARS2_1_RIGHT\n"
            .write(to: primerBED, atomically: true, encoding: .utf8)
        try ">SARS2_1_LEFT\nACGT\n>SARS2_1_RIGHT\nTGCA\n"
            .write(to: primerFASTA, atomically: true, encoding: .utf8)

        return try ViralReconRunRequest(
            samples: [
                ViralReconSample(
                    sampleName: "SARS2_A",
                    sourceBundleURL: root.appendingPathComponent("SARS2_A.lungfishfastq", isDirectory: true),
                    fastqURLs: [read1, read2],
                    barcode: nil,
                    sequencingSummaryURL: nil
                ),
            ],
            platform: .illumina,
            protocol: .amplicon,
            samplesheetURL: samplesheet,
            outputDirectory: outputs,
            executor: .docker,
            version: "3.0.0",
            reference: .genome("MN908947.3"),
            primer: ViralReconPrimerSelection(
                bundleURL: primerBundle,
                displayName: "QIASeq DIRECT SARS-CoV-2",
                bedURL: primerBED,
                fastaURL: primerFASTA,
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
    }
}
