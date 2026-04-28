import Foundation

enum ViralReconWorkflowTestFixtures {
    static func makeTempDirectory() throws -> URL {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent("ViralReconWorkflowTests-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }

    static func writeReferenceFASTA(in directory: URL) throws -> URL {
        let url = directory.appendingPathComponent("MN908947.3.fasta")
        let sequence = String(repeating: "ACGT", count: 20)
        try ">MN908947.3\n\(sequence)\n".write(to: url, atomically: true, encoding: .utf8)
        return url
    }

    static func writePrimerBundleWithoutFasta(in directory: URL) throws -> URL {
        let bundleURL = directory.appendingPathComponent("QIASeqDIRECT-SARS2.lungfishprimers", isDirectory: true)
        try FileManager.default.createDirectory(at: bundleURL, withIntermediateDirectories: true)

        let manifest = """
        {
          "schema_version": 1,
          "name": "qiaseq-direct-sars2",
          "display_name": "QIASeq DIRECT SARS-CoV-2",
          "description": "Viral Recon test fixture",
          "organism": "SARS-CoV-2",
          "reference_accessions": [
            { "accession": "MN908947.3", "canonical": true }
          ],
          "primer_count": 2,
          "amplicon_count": 1
        }
        """
        try manifest.write(to: bundleURL.appendingPathComponent("manifest.json"), atomically: true, encoding: .utf8)

        let bed = """
        MN908947.3\t0\t8\tamplicon_1_LEFT\t1\t+
        MN908947.3\t12\t20\tamplicon_1_RIGHT\t1\t-
        """
        try (bed + "\n").write(to: bundleURL.appendingPathComponent("primers.bed"), atomically: true, encoding: .utf8)
        try "Test fixture.\n".write(to: bundleURL.appendingPathComponent("PROVENANCE.md"), atomically: true, encoding: .utf8)
        return bundleURL
    }
}
