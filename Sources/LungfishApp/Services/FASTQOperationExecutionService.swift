import Foundation

struct CLIInvocation: Sendable, Equatable {
    let subcommand: String
    let arguments: [String]
}

struct FASTQOperationExecutionService {
    func buildInvocation(for request: FASTQOperationLaunchRequest) throws -> CLIInvocation {
        switch request {
        case .refreshQCSummary(let inputURLs):
            return CLIInvocation(
                subcommand: "fastq",
                arguments: ["qc-summary"] + inputURLs.map(\.path)
            )

        case .derivative(let tool, let inputURLs, _):
            return CLIInvocation(
                subcommand: "fastq",
                arguments: [fastqSubcommandName(for: tool)] + inputURLs.map(\.path)
            )

        case .map(let inputURLs, let referenceURL, _):
            var arguments = inputURLs.map(\.path)
            arguments += ["--reference", referenceURL.path]
            if inputURLs.count == 2 {
                arguments.append("--paired")
            }
            return CLIInvocation(subcommand: "map", arguments: arguments)

        case .assemble(let inputURLs, _):
            var arguments = inputURLs.map(\.path)
            if inputURLs.count == 2 {
                arguments.append("--paired")
            }
            return CLIInvocation(subcommand: "assemble", arguments: arguments)

        case .classify(let tool, let inputURLs, let databaseName):
            let arguments = inputURLs.map(\.path) + ["--db", databaseName]
            switch tool {
            case .kraken2:
                return CLIInvocation(subcommand: "classify", arguments: arguments)
            case .esViritu:
                return CLIInvocation(subcommand: "esviritu", arguments: ["detect"] + arguments)
            case .taxTriage:
                return CLIInvocation(subcommand: "taxtriage", arguments: ["run"] + arguments)
            default:
                return CLIInvocation(subcommand: "classify", arguments: arguments)
            }
        }
    }

    private func fastqSubcommandName(for toolID: FASTQOperationToolID) -> String {
        switch toolID {
        case .refreshQCSummary:
            return "qc-summary"
        case .demultiplexBarcodes:
            return "demultiplex"
        case .qualityTrim:
            return "quality-trim"
        case .adapterRemoval:
            return "adapter-trim"
        case .primerTrimming:
            return "primer-remove"
        case .trimFixedBases:
            return "fixed-trim"
        case .filterByReadLength:
            return "length-filter"
        case .removeHumanReads:
            return "scrub-human"
        case .removeContaminants:
            return "contaminant-filter"
        case .removeDuplicates:
            return "deduplicate"
        case .mergeOverlappingPairs:
            return "merge"
        case .repairPairedEndFiles:
            return "repair"
        case .orientReads:
            return "orient"
        case .correctSequencingErrors:
            return "error-correct"
        case .subsampleByProportion, .subsampleByCount:
            return "subsample"
        case .extractReadsByID:
            return "search-text"
        case .extractReadsByMotif:
            return "search-motif"
        case .selectReadsBySequence:
            return "sequence-filter"
        case .minimap2:
            return "map"
        case .spades:
            return "assemble"
        case .kraken2:
            return "classify"
        case .esViritu:
            return "esviritu"
        case .taxTriage:
            return "taxtriage"
        }
    }
}
