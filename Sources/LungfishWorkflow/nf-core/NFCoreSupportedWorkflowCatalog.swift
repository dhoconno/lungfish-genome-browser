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
    public let difficulty: NFCoreWorkflowDifficulty
    public let resultSurfaces: [NFCoreResultSurface]
    public let supportedAdapterIDs: [String]

    public var fullName: String { "nf-core/\(name)" }
    public var documentationURL: URL { URL(string: "https://nf-co.re/\(name)")! }

    public init(
        name: String,
        description: String,
        difficulty: NFCoreWorkflowDifficulty,
        resultSurfaces: [NFCoreResultSurface],
        supportedAdapterIDs: [String] = ["generic-report"]
    ) {
        self.name = name
        self.description = description
        self.difficulty = difficulty
        self.resultSurfaces = resultSurfaces
        self.supportedAdapterIDs = supportedAdapterIDs
    }
}

public enum NFCoreSupportedWorkflowCatalog {
    public static let firstWave: [NFCoreSupportedWorkflow] = [
        workflow("fetchngs", "Fetch public metadata and FASTQ files.", [.fastqDatasets, .reports]),
        workflow("bamtofastq", "Convert BAM or CRAM files to FASTQ with QC.", [.fastqDatasets, .reports]),
        workflow("fastqrepair", "Repair malformed, unordered, or unpaired FASTQ records.", [.fastqDatasets, .reports]),
        workflow("seqinspector", "Run sequencing QC and MultiQC reports.", [.reports]),
        workflow("references", "Build reusable reference assets.", [.referenceBundles, .reports]),
        workflow("nanoseq", "Run nanopore demultiplexing, QC, and alignment.", [.fastqDatasets, .mappingBundles, .reports]),
        workflow("viralrecon", "Run viral assembly, consensus, and variant calling.", [.referenceBundles, .mappingBundles, .variantTracks, .reports]),
        workflow("vipr", "Run viral assembly and intrahost variant calling.", [.referenceBundles, .mappingBundles, .variantTracks, .reports]),
    ]

    public static let futureCustomInterfaceWorkflows: [NFCoreSupportedWorkflow] = [
        NFCoreSupportedWorkflow(
            name: "scrnaseq",
            description: "Single-cell RNA-seq analysis requiring matrix and embedding views.",
            difficulty: .hard,
            resultSurfaces: [.singleCell]
        ),
        NFCoreSupportedWorkflow(
            name: "spatialvi",
            description: "Spatial transcriptomics analysis requiring image and coordinate overlays.",
            difficulty: .hard,
            resultSurfaces: [.singleCell, .imaging]
        ),
        NFCoreSupportedWorkflow(
            name: "pangenome",
            description: "Pangenome graph rendering requiring graph visualization.",
            difficulty: .hard,
            resultSurfaces: [.graph]
        ),
        NFCoreSupportedWorkflow(
            name: "quantms",
            description: "Quantitative mass spectrometry requiring proteomics result models.",
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

    private static func workflow(
        _ name: String,
        _ description: String,
        _ resultSurfaces: [NFCoreResultSurface]
    ) -> NFCoreSupportedWorkflow {
        NFCoreSupportedWorkflow(
            name: name,
            description: description,
            difficulty: .easy,
            resultSurfaces: resultSurfaces
        )
    }
}
