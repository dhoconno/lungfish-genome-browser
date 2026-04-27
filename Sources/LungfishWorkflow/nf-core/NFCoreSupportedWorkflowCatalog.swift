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
    public let displayName: String
    public let description: String
    public let pinnedVersion: String
    public let whenToUse: String
    public let notFor: String
    public let requiredInputs: String
    public let expectedOutputs: String
    public let exampleUseCase: String
    public let runButtonTitle: String
    public let acceptedInputSuffixes: [String]
    public let primaryInputParameter: String
    public let defaultParams: [String: String]
    public let keyParameters: [NFCoreWorkflowParameter]
    public let difficulty: NFCoreWorkflowDifficulty
    public let resultSurfaces: [NFCoreResultSurface]
    public let supportedAdapterIDs: [String]
    public let isLegacy: Bool

    public var fullName: String { "nf-core/\(name)" }
    public var documentationURL: URL { URL(string: "https://nf-co.re/\(name)")! }

    public init(
        name: String,
        displayName: String,
        description: String,
        pinnedVersion: String,
        whenToUse: String,
        notFor: String,
        requiredInputs: String,
        expectedOutputs: String,
        exampleUseCase: String,
        runButtonTitle: String,
        acceptedInputSuffixes: [String],
        primaryInputParameter: String = "input",
        defaultParams: [String: String] = [:],
        keyParameters: [NFCoreWorkflowParameter] = [],
        difficulty: NFCoreWorkflowDifficulty,
        resultSurfaces: [NFCoreResultSurface],
        supportedAdapterIDs: [String] = ["generic-report"],
        isLegacy: Bool = false
    ) {
        self.name = name
        self.displayName = displayName
        self.description = description
        self.pinnedVersion = pinnedVersion
        self.whenToUse = whenToUse
        self.notFor = notFor
        self.requiredInputs = requiredInputs
        self.expectedOutputs = expectedOutputs
        self.exampleUseCase = exampleUseCase
        self.runButtonTitle = runButtonTitle
        self.acceptedInputSuffixes = acceptedInputSuffixes
        self.primaryInputParameter = primaryInputParameter
        self.defaultParams = defaultParams
        self.keyParameters = keyParameters
        self.difficulty = difficulty
        self.resultSurfaces = resultSurfaces
        self.supportedAdapterIDs = supportedAdapterIDs
        self.isLegacy = isLegacy
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
            displayName: "Download public sequencing reads",
            description: "Download FASTQ files and sample information from public accession lists.",
            pinnedVersion: "1.12.0",
            whenToUse: "Use this when you have SRA, ENA, DDBJ, GEO, or Synapse accessions from a paper, archive page, or study and want Lungfish to download the matching reads.",
            notFor: "Do not use this when FASTQ files are already in the project. This downloads data; it does not check quality, map reads, assemble genomes, or call variants.",
            requiredInputs: "Choose an accession list: a CSV, TSV, or TXT file with public sequencing accessions such as SRR, ERR, DRR, PRJNA, SRP, or GSE IDs.",
            expectedOutputs: "Downloaded, ready-to-use FASTQ files, sample metadata, accession mapping tables, and a download report.",
            exampleUseCase: "Example: download SRR11605097 or a PRJNA study from a paper so those reads can be checked or analyzed in this project.",
            runButtonTitle: "Download Reads",
            acceptedInputSuffixes: [".csv", ".tsv", ".txt"],
            defaultParams: ["download_method": "sratools"],
            difficulty: .easy,
            resultSurfaces: [.fastqDatasets, .reports]
        ),
        NFCoreSupportedWorkflow(
            name: "bamtofastq",
            displayName: "Convert BAM/CRAM back to FASTQ",
            description: "Recover sequencing reads from aligned BAM or CRAM files.",
            pinnedVersion: "1.2.0",
            whenToUse: "Use this when a collaborator or public archive provided aligned read files, but the next analysis needs FASTQ reads.",
            notFor: "Do not use this when the original FASTQ files are available. Prefer original reads when possible.",
            requiredInputs: "Choose one or more BAM or CRAM aligned read files. CRAM files may also need the matching reference genome.",
            expectedOutputs: "FASTQ read files, conversion checks, and a quality summary.",
            exampleUseCase: "Example: a collaborator sent only a BAM file, and you need FASTQ reads for QC or reanalysis.",
            runButtonTitle: "Convert Reads",
            acceptedInputSuffixes: [".bam", ".cram"],
            difficulty: .easy,
            resultSurfaces: [.fastqDatasets, .reports]
        ),
        NFCoreSupportedWorkflow(
            name: "fastqrepair",
            displayName: "Repair FASTQ files",
            description: "Fix FASTQ files that are damaged, incomplete, out of order, or missing paired reads.",
            pinnedVersion: "1.0.0",
            whenToUse: "Use this only when FASTQ import, QC, or analysis failed because files are malformed, corrupted, or paired-end files do not match.",
            notFor: "Do not use this to improve biologically low-quality reads. It repairs file structure and may discard reads that cannot be safely matched.",
            requiredInputs: "Choose FASTQ or FASTQ.gz files. For paired-end data, choose both R1 and R2 files for each sample.",
            expectedOutputs: "Repaired FASTQ files, counts of problem reads that were fixed or removed, and a repair report.",
            exampleUseCase: "Example: R1 and R2 contain different read names after a file transfer or filtering step.",
            runButtonTitle: "Repair FASTQs",
            acceptedInputSuffixes: [".fastq", ".fq", ".fastq.gz", ".fq.gz"],
            difficulty: .easy,
            resultSurfaces: [.fastqDatasets, .reports]
        ),
        NFCoreSupportedWorkflow(
            name: "seqinspector",
            displayName: "Inspect sequencing quality",
            description: "Create a broad quality report for FASTQ sequencing reads.",
            pinnedVersion: "1.0.1",
            whenToUse: "Use this before mapping, assembly, viral analysis, or sharing data to check read quality, adapter content, duplication, pairing, and possible technical artifacts.",
            notFor: "Do not use this when you need mapping, assembly, consensus sequences, variant calls, expression analysis, or taxonomy. This is QC only.",
            requiredInputs: "Choose raw FASTQ read files.",
            expectedOutputs: "A per-sample and project-wide sequencing quality report with read counts, quality summaries, library-prep warnings, duplication, and other QC metrics.",
            exampleUseCase: "Example: the sequencing core delivered new Illumina FASTQs and you want to see whether they are usable before analysis.",
            runButtonTitle: "Inspect Quality",
            acceptedInputSuffixes: [".fastq", ".fq", ".fastq.gz", ".fq.gz"],
            difficulty: .easy,
            resultSurfaces: [.reports]
        ),
        NFCoreSupportedWorkflow(
            name: "references",
            displayName: "Build reference assets",
            description: "Prepare reusable reference files for later mapping and variant workflows.",
            pinnedVersion: "0.1",
            whenToUse: "Use this when a lab reference genome or viral reference needs to be prepared once and reused consistently in future analyses.",
            notFor: "Do not use this just to open or view a FASTA file. Use normal reference import for browsing.",
            requiredInputs: "Choose a reference genome FASTA. Add annotation GFF/GTF or reference metadata only when the selected recipe asks for it.",
            expectedOutputs: "A reusable Lungfish reference bundle when the output is recognized, plus reference preparation files and a build report.",
            exampleUseCase: "Example: prepare a lungfish genome FASTA so future read mapping uses the same named reference version.",
            runButtonTitle: "Build Reference",
            acceptedInputSuffixes: [".fasta", ".fa", ".fna", ".fasta.gz", ".fa.gz", ".csv", ".tsv"],
            difficulty: .easy,
            resultSurfaces: [.referenceBundles, .reports]
        ),
        NFCoreSupportedWorkflow(
            name: "nanoseq",
            displayName: "Analyze nanopore reads",
            description: "Process Oxford Nanopore reads for QC, barcode summaries, and optional alignment.",
            pinnedVersion: "3.1.0",
            whenToUse: "Use this for general Oxford Nanopore FASTQ data when you need read QC, barcode summaries, filtering, or alignment to a reference.",
            notFor: "Do not use this for Illumina reads. For SARS-CoV-2-style viral amplicon consensus and mutation reports, use viral analysis instead.",
            requiredInputs: "Choose nanopore FASTQ files or barcode folders. Choose a reference only when you want alignments.",
            expectedOutputs: "Nanopore quality reports, cleaned or demultiplexed FASTQ files when applicable, optional alignments, coverage tracks, and run reports.",
            exampleUseCase: "Example: process MinION reads from a small genome run and produce a QC report plus alignments to a known reference.",
            runButtonTitle: "Analyze Nanopore Reads",
            acceptedInputSuffixes: [".fastq", ".fq", ".fastq.gz", ".fq.gz"],
            difficulty: .easy,
            resultSurfaces: [.fastqDatasets, .mappingBundles, .reports]
        ),
        NFCoreSupportedWorkflow(
            name: "viralrecon",
            displayName: "Analyze viral amplicon samples",
            description: "Generate viral consensus sequences, coverage summaries, alignments, and mutation tables.",
            pinnedVersion: "3.0.0",
            whenToUse: "Use this for viral sequencing reads, especially SARS-CoV-2-style amplicon samples, when you want consensus genomes, coverage, and variants.",
            notFor: "Do not use this for whole-organism genomes, RNA-seq, non-viral samples, or generic nanopore QC.",
            requiredInputs: "Choose viral FASTQ reads. A matching viral reference and primer scheme may be required for final analysis.",
            expectedOutputs: "Consensus viral sequences, mapped reads, coverage summaries, variant tables, and QC reports.",
            exampleUseCase: "Example: analyze SARS-CoV-2 amplicon reads to produce a consensus FASTA and variant table for each sample.",
            runButtonTitle: "Run Viral Analysis",
            acceptedInputSuffixes: [".fastq", ".fq", ".fastq.gz", ".fq.gz", ".csv", ".tsv", ".fasta", ".fa", ".fna"],
            difficulty: .easy,
            resultSurfaces: [.referenceBundles, .mappingBundles, .variantTracks, .reports]
        ),
    ]

    public static let legacyWorkflows: [NFCoreSupportedWorkflow] = [
        NFCoreSupportedWorkflow(
            name: "vipr",
            displayName: "Legacy viral workflow",
            description: "Reproduce older viral assembly and within-sample variant analyses.",
            pinnedVersion: "6eef3b32eac4ac3979c7a45e61188e8a3628aa68",
            whenToUse: "Use this only when an older lab protocol, collaborator, or previous project specifically requires ViPR-compatible outputs.",
            notFor: "Do not use this for new viral analyses. Use viral analysis instead.",
            requiredInputs: "Choose viral FASTQ reads and the matching legacy reference/configuration files required by the old protocol.",
            expectedOutputs: "Legacy viral assembly, mapped reads, within-sample variant tables, and reports.",
            exampleUseCase: "Example: reproduce an old collaborator analysis that was originally run with ViPR.",
            runButtonTitle: "Run Legacy Workflow",
            acceptedInputSuffixes: [".fastq", ".fq", ".fastq.gz", ".fq.gz", ".csv", ".tsv", ".fasta", ".fa", ".fna"],
            difficulty: .moderate,
            resultSurfaces: [.referenceBundles, .mappingBundles, .variantTracks, .reports],
            isLegacy: true
        ),
    ]

    public static let futureCustomInterfaceWorkflows: [NFCoreSupportedWorkflow] = [
        NFCoreSupportedWorkflow(
            name: "scrnaseq",
            displayName: "Single-cell RNA-seq analysis",
            description: "Single-cell RNA-seq analysis requiring matrix and embedding views.",
            pinnedVersion: "4.1.0",
            whenToUse: "Future custom interface workflow.",
            notFor: "Not available in the generic workflow dialog yet.",
            requiredInputs: "Single-cell samplesheets and count inputs.",
            expectedOutputs: "Single-cell matrices and reports.",
            exampleUseCase: "Example: import count matrices and metadata for single-cell clustering.",
            runButtonTitle: "Run Single-Cell Analysis",
            acceptedInputSuffixes: [".csv", ".tsv", ".mtx", ".h5"],
            difficulty: .hard,
            resultSurfaces: [.singleCell]
        ),
        NFCoreSupportedWorkflow(
            name: "spatialvi",
            displayName: "Spatial transcriptomics analysis",
            description: "Spatial transcriptomics analysis requiring image and coordinate overlays.",
            pinnedVersion: "0.1.0",
            whenToUse: "Future custom interface workflow.",
            notFor: "Not available in the generic workflow dialog yet.",
            requiredInputs: "Spatial transcriptomics matrices, images, and coordinate files.",
            expectedOutputs: "Spatial analysis outputs.",
            exampleUseCase: "Example: combine tissue images with spatial expression coordinates.",
            runButtonTitle: "Run Spatial Analysis",
            acceptedInputSuffixes: [".csv", ".tsv", ".h5", ".png", ".jpg", ".jpeg", ".tif", ".tiff"],
            difficulty: .hard,
            resultSurfaces: [.singleCell, .imaging]
        ),
        NFCoreSupportedWorkflow(
            name: "pangenome",
            displayName: "Pangenome graph analysis",
            description: "Pangenome graph rendering requiring graph visualization.",
            pinnedVersion: "1.1.3",
            whenToUse: "Future custom interface workflow.",
            notFor: "Not available in the generic workflow dialog yet.",
            requiredInputs: "Pangenome-compatible sequence and graph inputs.",
            expectedOutputs: "Graph outputs and reports.",
            exampleUseCase: "Example: compare assemblies in a graph representation.",
            runButtonTitle: "Run Pangenome Analysis",
            acceptedInputSuffixes: [".fasta", ".fa", ".gfa", ".vg", ".csv", ".tsv"],
            difficulty: .hard,
            resultSurfaces: [.graph]
        ),
        NFCoreSupportedWorkflow(
            name: "quantms",
            displayName: "Mass spectrometry quantification",
            description: "Quantitative mass spectrometry requiring proteomics result models.",
            pinnedVersion: "1.2.0",
            whenToUse: "Future custom interface workflow.",
            notFor: "Not available in the generic workflow dialog yet.",
            requiredInputs: "Proteomics raw files and samplesheets.",
            expectedOutputs: "Proteomics quantification outputs.",
            exampleUseCase: "Example: quantify proteins from mzML files and sample metadata.",
            runButtonTitle: "Run Proteomics Analysis",
            acceptedInputSuffixes: [".csv", ".tsv", ".mzml", ".raw"],
            difficulty: .hard,
            resultSurfaces: [.proteomics]
        ),
    ]

    public static var allCurated: [NFCoreSupportedWorkflow] {
        firstWave + legacyWorkflows + futureCustomInterfaceWorkflows
    }

    public static func workflow(named rawName: String) -> NFCoreSupportedWorkflow? {
        let name = rawName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "nf-core/", with: "")
            .lowercased()
        return allCurated.first { $0.name == name }
    }

}
