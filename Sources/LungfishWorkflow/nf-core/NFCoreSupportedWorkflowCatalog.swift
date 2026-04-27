import Foundation

public enum NFCoreWorkflowDifficulty: String, Codable, Sendable, Equatable {
    case easy
    case moderate
    case hard

    public var displayName: String {
        switch self {
        case .easy: return "Easy"
        case .moderate: return "Moderate"
        case .hard: return "Hard"
        }
    }
}

public enum NFCoreResultSurface: String, Codable, Sendable, Equatable, CaseIterable {
    case fastqDatasets
    case referenceBundles
    case mappingBundles
    case variantTracks
    case reports
    case taxonomy
    case intervals
    case expression
    case singleCell
    case imaging
    case proteomics
    case graph
    case custom
}

public struct NFCoreSupportedWorkflow: Codable, Sendable, Equatable, Identifiable {
    public var id: String { name }
    public let name: String
    public let description: String
    public let pinnedVersion: String
    public let whenToUse: String
    public let requiredInputs: String
    public let expectedOutputs: String
    public let acceptedInputSuffixes: [String]
    public let primaryInputParameter: String
    public let keyParameters: [NFCoreWorkflowParameter]
    public let difficulty: NFCoreWorkflowDifficulty
    public let resultSurfaces: [NFCoreResultSurface]
    public let supportedAdapterIDs: [String]

    public var fullName: String { "nf-core/\(name)" }
    public var documentationURL: URL { URL(string: "https://nf-co.re/\(name)")! }

    public init(
        name: String,
        description: String,
        pinnedVersion: String,
        whenToUse: String,
        requiredInputs: String,
        expectedOutputs: String,
        acceptedInputSuffixes: [String],
        primaryInputParameter: String = "input",
        keyParameters: [NFCoreWorkflowParameter] = [],
        difficulty: NFCoreWorkflowDifficulty,
        resultSurfaces: [NFCoreResultSurface],
        supportedAdapterIDs: [String] = ["generic-report"]
    ) {
        self.name = name
        self.description = description
        self.pinnedVersion = pinnedVersion
        self.whenToUse = whenToUse
        self.requiredInputs = requiredInputs
        self.expectedOutputs = expectedOutputs
        self.acceptedInputSuffixes = acceptedInputSuffixes
        self.primaryInputParameter = primaryInputParameter
        self.keyParameters = keyParameters
        self.difficulty = difficulty
        self.resultSurfaces = resultSurfaces
        self.supportedAdapterIDs = supportedAdapterIDs
    }
}

public struct NFCoreWorkflowParameter: Codable, Sendable, Equatable, Identifiable {
    public var id: String { name }
    public let name: String
    public let displayName: String
    public let defaultValue: String
    public let help: String

    public init(name: String, displayName: String, defaultValue: String = "", help: String) {
        self.name = name
        self.displayName = displayName
        self.defaultValue = defaultValue
        self.help = help
    }
}

public enum NFCoreSupportedWorkflowCatalog {
    public static let firstWave: [NFCoreSupportedWorkflow] = [
        NFCoreSupportedWorkflow(
            name: "fetchngs",
            description: "Fetch public metadata and FASTQ files.",
            pinnedVersion: "1.12.0",
            whenToUse: "Use this when you have SRA, ENA, DDBJ, Synapse, or GEO accessions and want Lungfish to download the FASTQ files into the project.",
            requiredInputs: "A CSV, TSV, or TXT accession/sample sheet. This workflow downloads FASTQ files; FASTQ files are not the starting input.",
            expectedOutputs: "FASTQ datasets plus run metadata, pipeline reports, and MultiQC summaries.",
            acceptedInputSuffixes: [".csv", ".tsv", ".txt"],
            keyParameters: [
                NFCoreWorkflowParameter(name: "download_method", displayName: "Download method", defaultValue: "sratools", help: "Backend used by nf-core/fetchngs to retrieve reads."),
                NFCoreWorkflowParameter(name: "nf_core_pipeline", displayName: "Output samplesheet type", defaultValue: "none", help: "Optional downstream nf-core samplesheet format to generate."),
            ],
            difficulty: .easy,
            resultSurfaces: [.fastqDatasets, .reports]
        ),
        NFCoreSupportedWorkflow(
            name: "bamtofastq",
            description: "Convert BAM or CRAM files to FASTQ with QC.",
            pinnedVersion: "1.2.0",
            whenToUse: "Use this when aligned BAM or CRAM files need to be converted back into FASTQ reads for reprocessing.",
            requiredInputs: "One or more BAM or CRAM files already present in the project.",
            expectedOutputs: "FASTQ datasets and conversion/QC reports.",
            acceptedInputSuffixes: [".bam", ".cram"],
            difficulty: .easy,
            resultSurfaces: [.fastqDatasets, .reports]
        ),
        NFCoreSupportedWorkflow(
            name: "fastqrepair",
            description: "Repair malformed, unordered, or unpaired FASTQ records.",
            pinnedVersion: "1.0.0",
            whenToUse: "Use this when paired FASTQ files are out of sync or have malformed records that block downstream processing.",
            requiredInputs: "FASTQ files or compressed FASTQ files.",
            expectedOutputs: "Repaired FASTQ datasets and reports.",
            acceptedInputSuffixes: [".fastq", ".fq", ".fastq.gz", ".fq.gz"],
            difficulty: .easy,
            resultSurfaces: [.fastqDatasets, .reports]
        ),
        NFCoreSupportedWorkflow(
            name: "seqinspector",
            description: "Run sequencing QC and MultiQC reports.",
            pinnedVersion: "1.0.1",
            whenToUse: "Use this for a quick quality-control pass over FASTQ files before mapping, assembly, or classification.",
            requiredInputs: "FASTQ files or compressed FASTQ files.",
            expectedOutputs: "QC reports, metrics, and MultiQC summaries.",
            acceptedInputSuffixes: [".fastq", ".fq", ".fastq.gz", ".fq.gz"],
            keyParameters: [
                NFCoreWorkflowParameter(name: "skip_fastqc", displayName: "Skip FastQC", defaultValue: "false", help: "Set to true to skip FastQC when only other report outputs are needed."),
            ],
            difficulty: .easy,
            resultSurfaces: [.reports]
        ),
        NFCoreSupportedWorkflow(
            name: "references",
            description: "Build reusable reference assets.",
            pinnedVersion: "0.1",
            whenToUse: "Use this to prepare reference assets that can be reused by downstream workflows.",
            requiredInputs: "FASTA reference files or reference metadata tables.",
            expectedOutputs: "Reference bundles and reports.",
            acceptedInputSuffixes: [".fasta", ".fa", ".fna", ".fasta.gz", ".fa.gz", ".csv", ".tsv"],
            difficulty: .easy,
            resultSurfaces: [.referenceBundles, .reports]
        ),
        NFCoreSupportedWorkflow(
            name: "nanoseq",
            description: "Run nanopore demultiplexing, QC, and alignment.",
            pinnedVersion: "3.1.0",
            whenToUse: "Use this for Oxford Nanopore read QC and alignment workflows.",
            requiredInputs: "Nanopore FASTQ files or compressed FASTQ files.",
            expectedOutputs: "FASTQ datasets, mapping bundles, and QC reports.",
            acceptedInputSuffixes: [".fastq", ".fq", ".fastq.gz", ".fq.gz"],
            difficulty: .easy,
            resultSurfaces: [.fastqDatasets, .mappingBundles, .reports]
        ),
        NFCoreSupportedWorkflow(
            name: "viralrecon",
            description: "Run viral assembly, consensus, and variant calling.",
            pinnedVersion: "3.0.0",
            whenToUse: "Use this for viral amplicon or metagenomic analysis where consensus sequences, mappings, and variants are expected outputs.",
            requiredInputs: "FASTQ reads plus the reference/settings required by nf-core/viralrecon.",
            expectedOutputs: "Reference-derived outputs, mapping bundles, variant tracks, consensus sequences, and reports.",
            acceptedInputSuffixes: [".fastq", ".fq", ".fastq.gz", ".fq.gz", ".csv", ".tsv", ".fasta", ".fa", ".fna"],
            difficulty: .easy,
            resultSurfaces: [.referenceBundles, .mappingBundles, .variantTracks, .reports]
        ),
        NFCoreSupportedWorkflow(
            name: "vipr",
            description: "Run archived viral assembly and intrahost variant calling.",
            pinnedVersion: "6eef3b32eac4ac3979c7a45e61188e8a3628aa68",
            whenToUse: "Use only for legacy viral workflows that specifically require nf-core/vipr. Prefer viralrecon for new analyses.",
            requiredInputs: "FASTQ reads and VIPR-compatible viral reference/configuration files.",
            expectedOutputs: "Viral assembly, mapping, variant, and report outputs. This archived workflow may require older Nextflow versions.",
            acceptedInputSuffixes: [".fastq", ".fq", ".fastq.gz", ".fq.gz", ".csv", ".tsv", ".fasta", ".fa", ".fna"],
            difficulty: .easy,
            resultSurfaces: [.referenceBundles, .mappingBundles, .variantTracks, .reports]
        ),
    ]

    public static let futureCustomInterfaceWorkflows: [NFCoreSupportedWorkflow] = [
        NFCoreSupportedWorkflow(
            name: "scrnaseq",
            description: "Single-cell RNA-seq analysis requiring matrix and embedding views.",
            pinnedVersion: "4.1.0",
            whenToUse: "Future custom interface workflow.",
            requiredInputs: "Single-cell samplesheets and count inputs.",
            expectedOutputs: "Single-cell matrices and reports.",
            acceptedInputSuffixes: [".csv", ".tsv", ".mtx", ".h5"],
            difficulty: .hard,
            resultSurfaces: [.singleCell]
        ),
        NFCoreSupportedWorkflow(
            name: "spatialvi",
            description: "Spatial transcriptomics analysis requiring image and coordinate overlays.",
            pinnedVersion: "0.1.0",
            whenToUse: "Future custom interface workflow.",
            requiredInputs: "Spatial transcriptomics matrices, images, and coordinate files.",
            expectedOutputs: "Spatial analysis outputs.",
            acceptedInputSuffixes: [".csv", ".tsv", ".h5", ".png", ".jpg", ".jpeg", ".tif", ".tiff"],
            difficulty: .hard,
            resultSurfaces: [.singleCell, .imaging]
        ),
        NFCoreSupportedWorkflow(
            name: "pangenome",
            description: "Pangenome graph rendering requiring graph visualization.",
            pinnedVersion: "1.1.3",
            whenToUse: "Future custom interface workflow.",
            requiredInputs: "Pangenome-compatible sequence and graph inputs.",
            expectedOutputs: "Graph outputs and reports.",
            acceptedInputSuffixes: [".fasta", ".fa", ".gfa", ".vg", ".csv", ".tsv"],
            difficulty: .hard,
            resultSurfaces: [.graph]
        ),
        NFCoreSupportedWorkflow(
            name: "quantms",
            description: "Quantitative mass spectrometry requiring proteomics result models.",
            pinnedVersion: "1.2.0",
            whenToUse: "Future custom interface workflow.",
            requiredInputs: "Proteomics raw files and samplesheets.",
            expectedOutputs: "Proteomics quantification outputs.",
            acceptedInputSuffixes: [".csv", ".tsv", ".mzml", ".raw"],
            difficulty: .hard,
            resultSurfaces: [.proteomics]
        ),
    ]

    public static var allCurated: [NFCoreSupportedWorkflow] {
        firstWave + futureCustomInterfaceWorkflows
    }

    public static func workflow(named rawName: String) -> NFCoreSupportedWorkflow? {
        let name = rawName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "nf-core/", with: "")
            .lowercased()
        return allCurated.first { $0.name == name }
    }

}
