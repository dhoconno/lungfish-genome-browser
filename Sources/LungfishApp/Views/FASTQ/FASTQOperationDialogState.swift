import Foundation
import Observation
import LungfishWorkflow

@MainActor
@Observable
final class FASTQOperationDialogState {
    var selectedCategory: FASTQOperationCategoryID {
        didSet {
            if selectedToolID.categoryID != selectedCategory {
                selectedToolID = selectedCategory.defaultToolID
                return
            }

            normalizeSelectionState()
        }
    }

    var selectedToolID: FASTQOperationToolID {
        didSet {
            if selectedCategory != selectedToolID.categoryID {
                selectedCategory = selectedToolID.categoryID
                return
            }

            normalizeSelectionState()
        }
    }

    var selectedInputURLs: [URL]
    var auxiliaryInputs: [FASTQOperationInputKind: URL]
    var outputMode: FASTQOperationOutputMode {
        didSet {
            normalizeOutputMode()
        }
    }
    var embeddedRunTrigger: Int
    var projectURL: URL?
    var outputDirectoryURL: URL?
    var pendingLaunchRequest: FASTQOperationLaunchRequest?
    var pendingMinimap2Config: Minimap2Config?
    var pendingSPAdesConfig: SPAdesAssemblyConfig?
    var pendingClassificationConfigs: [ClassificationConfig]
    var pendingEsVirituConfigs: [EsVirituConfig]
    var pendingTaxTriageConfig: TaxTriageConfig?

    private var embeddedToolReady: Bool

    init(
        initialCategory: FASTQOperationCategoryID,
        selectedInputURLs: [URL],
        projectURL: URL? = DocumentManager.shared.activeProject?.url
    ) {
        let defaultToolID = initialCategory.defaultToolID
        self.selectedCategory = initialCategory
        self.selectedToolID = defaultToolID
        self.selectedInputURLs = selectedInputURLs
        self.auxiliaryInputs = [:]
        self.outputMode = defaultToolID.defaultOutputMode
        self.embeddedRunTrigger = 0
        self.projectURL = projectURL
        self.outputDirectoryURL = Self.defaultOutputDirectory(
            projectURL: projectURL,
            selectedInputURLs: selectedInputURLs
        )
        self.pendingLaunchRequest = nil
        self.pendingMinimap2Config = nil
        self.pendingSPAdesConfig = nil
        self.pendingClassificationConfigs = []
        self.pendingEsVirituConfigs = []
        self.pendingTaxTriageConfig = nil
        self.embeddedToolReady = defaultToolID.defaultEmbeddedReadiness
    }

    func selectCategory(_ category: FASTQOperationCategoryID) {
        selectedCategory = category
        selectedToolID = category.defaultToolID
        normalizeSelectionState()
    }

    func selectTool(_ toolID: FASTQOperationToolID) {
        selectedCategory = toolID.categoryID
        selectedToolID = toolID
        normalizeSelectionState()
    }

    func setAuxiliaryInput(_ url: URL, for kind: FASTQOperationInputKind) {
        auxiliaryInputs[kind] = url.standardizedFileURL
    }

    func removeAuxiliaryInput(for kind: FASTQOperationInputKind) {
        auxiliaryInputs.removeValue(forKey: kind)
    }

    func auxiliaryInputURL(for kind: FASTQOperationInputKind) -> URL? {
        auxiliaryInputs[kind]
    }

    func isAuxiliaryInputValid(for kind: FASTQOperationInputKind) -> Bool {
        guard let url = auxiliaryInputs[kind] else { return false }
        return kind.accepts(url: url)
    }

    func updateEmbeddedReadiness(_ ready: Bool) {
        embeddedToolReady = ready
    }

    func prepareForRun() {
        if selectedToolID.usesEmbeddedConfiguration {
            pendingLaunchRequest = nil
            embeddedRunTrigger += 1
            return
        }

        pendingMinimap2Config = nil
        pendingSPAdesConfig = nil
        pendingClassificationConfigs = []
        pendingEsVirituConfigs = []
        pendingTaxTriageConfig = nil
        if selectedToolID == .refreshQCSummary {
            pendingLaunchRequest = .refreshQCSummary(inputURLs: selectedInputURLs)
        } else {
            pendingLaunchRequest = .derivative(
                tool: selectedToolID,
                inputURLs: selectedInputURLs,
                outputMode: outputMode
            )
        }
    }

    func captureMinimap2Config(_ config: Minimap2Config) {
        setAuxiliaryInput(config.referenceURL, for: .referenceSequence)
        pendingMinimap2Config = config
        pendingSPAdesConfig = nil
        pendingClassificationConfigs = []
        pendingEsVirituConfigs = []
        pendingTaxTriageConfig = nil
        pendingLaunchRequest = .map(
            inputURLs: config.inputFiles,
            referenceURL: config.referenceURL,
            outputMode: outputMode
        )
        embeddedToolReady = true
    }

    func captureSPAdesConfig(_ config: SPAdesAssemblyConfig) {
        outputDirectoryURL = config.outputDirectory
        pendingMinimap2Config = nil
        pendingSPAdesConfig = config
        pendingClassificationConfigs = []
        pendingEsVirituConfigs = []
        pendingTaxTriageConfig = nil
        pendingLaunchRequest = .assemble(
            inputURLs: config.allInputFiles,
            outputMode: outputMode
        )
        embeddedToolReady = true
    }

    func captureClassificationConfigs(_ configs: [ClassificationConfig]) {
        guard let first = configs.first else { return }
        setAuxiliaryInput(first.databasePath, for: .database)
        pendingMinimap2Config = nil
        pendingSPAdesConfig = nil
        pendingClassificationConfigs = configs
        pendingEsVirituConfigs = []
        pendingTaxTriageConfig = nil
        pendingLaunchRequest = .classify(
            tool: .kraken2,
            inputURLs: configs.flatMap(\.inputFiles),
            databaseName: first.databaseName
        )
        embeddedToolReady = true
    }

    func captureEsVirituConfigs(_ configs: [EsVirituConfig]) {
        guard let first = configs.first else { return }
        setAuxiliaryInput(first.databasePath, for: .database)
        pendingMinimap2Config = nil
        pendingSPAdesConfig = nil
        pendingClassificationConfigs = []
        pendingEsVirituConfigs = configs
        pendingTaxTriageConfig = nil
        pendingLaunchRequest = .classify(
            tool: .esViritu,
            inputURLs: configs.flatMap(\.inputFiles),
            databaseName: first.databasePath.lastPathComponent
        )
        embeddedToolReady = true
    }

    func captureTaxTriageConfig(_ config: TaxTriageConfig) {
        if let databasePath = config.kraken2DatabasePath {
            setAuxiliaryInput(databasePath, for: .database)
        }
        pendingMinimap2Config = nil
        pendingSPAdesConfig = nil
        pendingClassificationConfigs = []
        pendingEsVirituConfigs = []
        pendingTaxTriageConfig = config
        pendingLaunchRequest = .classify(
            tool: .taxTriage,
            inputURLs: config.samples.flatMap { sample in
                [sample.fastq1] + (sample.fastq2.map { [$0] } ?? [])
            },
            databaseName: config.kraken2DatabasePath?.lastPathComponent ?? ""
        )
        embeddedToolReady = true
    }

    var visibleSections: [DatasetOperationSection] {
        var sections: [DatasetOperationSection] = [.inputs, .primarySettings, .advancedSettings]
        if showsOutputStrategyPicker {
            sections.append(.output)
        }
        sections.append(.readiness)
        return sections
    }

    var inputSectionTitle: String {
        DatasetOperationSection.inputs.title
    }

    var outputSectionTitle: String {
        DatasetOperationSection.output.title
    }

    var readinessText: String {
        if selectedInputURLs.isEmpty {
            return "Select at least one FASTQ dataset."
        }

        if let missingKind = missingRequiredAuxiliaryInputKinds.first {
            return missingKind.missingSelectionText
        }

        if !embeddedToolReady {
            return selectedToolID.embeddedReadinessText
        }

        if showsOutputStrategyPicker {
            return "Ready to configure output."
        }

        return "Batch output is fixed for this tool."
    }

    var outputStrategyOptions: [FASTQOperationOutputMode] {
        showsOutputStrategyPicker ? [.perInput, .groupedResult] : [.fixedBatch]
    }

    var showsOutputStrategyPicker: Bool {
        selectedToolID.categoryID != .classification
    }

    var requiredInputKinds: [FASTQOperationInputKind] {
        selectedToolID.requiredInputKinds
    }

    var isRunEnabled: Bool {
        !selectedInputURLs.isEmpty
        && missingRequiredAuxiliaryInputKinds.isEmpty
        && embeddedToolReady
    }

    var datasetLabel: String {
        switch selectedInputURLs.count {
        case 0:
            return "No FASTQ selected"
        case 1:
            return selectedInputURLs[0].lastPathComponent
        default:
            return "\(selectedInputURLs.count) FASTQ datasets"
        }
    }

    var sidebarItems: [DatasetOperationToolSidebarItem] {
        Self.toolIDs(for: selectedCategory).map(\.sidebarItem)
    }

    var selectedToolSummary: String {
        switch selectedToolID {
        case .refreshQCSummary:
            return "Recompute the QC summary for the selected FASTQ datasets."
        case .demultiplexBarcodes:
            return "Split pooled reads into sample-specific outputs using a barcode definition."
        case .qualityTrim:
            return "Trim low-quality bases from read ends."
        case .adapterRemoval:
            return "Remove adapter sequence from reads."
        case .primerTrimming:
            return "Trim PCR primer sequences using a literal or reference-backed source."
        case .trimFixedBases:
            return "Remove a fixed number of bases from either end of each read."
        case .filterByReadLength:
            return "Keep reads in the requested length range."
        case .removeHumanReads:
            return "Filter reads that match the configured human database."
        case .removeContaminants:
            return "Filter reads that match a contaminant reference."
        case .removeDuplicates:
            return "Collapse duplicate reads from the selected datasets."
        case .mergeOverlappingPairs:
            return "Merge overlapping paired-end reads."
        case .repairPairedEndFiles:
            return "Repair synchronization issues between paired-end mates."
        case .orientReads:
            return "Orient reads against a required reference sequence."
        case .correctSequencingErrors:
            return "Correct likely sequencing errors before downstream analysis."
        case .subsampleByProportion:
            return "Keep a user-defined fraction of reads."
        case .subsampleByCount:
            return "Keep a fixed number of reads."
        case .extractReadsByID:
            return "Extract reads whose identifiers match the requested values."
        case .extractReadsByMotif:
            return "Extract reads containing the requested motif."
        case .selectReadsBySequence:
            return "Keep reads matching a target sequence."
        case .minimap2:
            return "Configure minimap2 mapping against a reference sequence."
        case .spades:
            return "Configure a SPAdes assembly run."
        case .kraken2:
            return "Configure Kraken2 classification."
        case .esViritu:
            return "Configure EsViritu viral detection."
        case .taxTriage:
            return "Configure TaxTriage pathogen triage."
        }
    }

    static func toolIDs(for category: FASTQOperationCategoryID) -> [FASTQOperationToolID] {
        switch category {
        case .qcReporting:
            return [.refreshQCSummary]
        case .demultiplexing:
            return [.demultiplexBarcodes]
        case .trimmingFiltering:
            return [.qualityTrim, .adapterRemoval, .primerTrimming, .trimFixedBases, .filterByReadLength]
        case .decontamination:
            return [.removeHumanReads, .removeContaminants, .removeDuplicates]
        case .readProcessing:
            return [.mergeOverlappingPairs, .repairPairedEndFiles, .orientReads, .correctSequencingErrors]
        case .searchSubsetting:
            return [.subsampleByProportion, .subsampleByCount, .extractReadsByID, .extractReadsByMotif, .selectReadsBySequence]
        case .mapping:
            return [.minimap2]
        case .assembly:
            return [.spades]
        case .classification:
            return [.kraken2, .esViritu, .taxTriage]
        }
    }

    private var missingRequiredAuxiliaryInputKinds: [FASTQOperationInputKind] {
        guard !selectedToolID.usesEmbeddedConfiguration else {
            return []
        }

        return requiredInputKinds.filter { kind in
            kind != .fastqDataset && !isAuxiliaryInputValid(for: kind)
        }
    }

    private func normalizeSelectionState() {
        auxiliaryInputs = auxiliaryInputs.filter { requiredInputKinds.contains($0.key) }
        embeddedToolReady = selectedToolID.defaultEmbeddedReadiness
        embeddedRunTrigger = 0
        pendingLaunchRequest = nil
        pendingMinimap2Config = nil
        pendingSPAdesConfig = nil
        pendingClassificationConfigs = []
        pendingEsVirituConfigs = []
        pendingTaxTriageConfig = nil
        normalizeOutputMode()
    }

    private func normalizeOutputMode() {
        if outputMode != selectedToolID.defaultOutputMode && !selectedToolID.supportsConfigurableOutput {
            outputMode = selectedToolID.defaultOutputMode
            return
        }

        if !outputStrategyOptions.contains(outputMode) {
            outputMode = outputStrategyOptions.first ?? selectedToolID.defaultOutputMode
        }
    }

    private static func defaultOutputDirectory(projectURL: URL?, selectedInputURLs: [URL]) -> URL? {
        if let projectURL {
            return projectURL.appendingPathComponent("Analyses", isDirectory: true)
        }

        return selectedInputURLs.first?.deletingLastPathComponent()
    }
}

enum FASTQOperationToolID: String, CaseIterable, Sendable {
    case refreshQCSummary
    case demultiplexBarcodes
    case qualityTrim
    case adapterRemoval
    case primerTrimming
    case trimFixedBases
    case filterByReadLength
    case removeHumanReads
    case removeContaminants
    case removeDuplicates
    case mergeOverlappingPairs
    case repairPairedEndFiles
    case orientReads
    case correctSequencingErrors
    case subsampleByProportion
    case subsampleByCount
    case extractReadsByID
    case extractReadsByMotif
    case selectReadsBySequence
    case minimap2
    case spades
    case kraken2
    case esViritu
    case taxTriage

    var title: String {
        switch self {
        case .refreshQCSummary: return "Refresh QC Summary"
        case .demultiplexBarcodes: return "Demultiplex Barcodes"
        case .qualityTrim: return "Quality Trim"
        case .adapterRemoval: return "Adapter Removal"
        case .primerTrimming: return "Primer Trimming"
        case .trimFixedBases: return "Trim Fixed Bases"
        case .filterByReadLength: return "Filter by Read Length"
        case .removeHumanReads: return "Remove Human Reads"
        case .removeContaminants: return "Remove Contaminants"
        case .removeDuplicates: return "Remove Duplicates"
        case .mergeOverlappingPairs: return "Merge Overlapping Pairs"
        case .repairPairedEndFiles: return "Repair Paired-End Files"
        case .orientReads: return "Orient Reads"
        case .correctSequencingErrors: return "Correct Sequencing Errors"
        case .subsampleByProportion: return "Subsample by Proportion"
        case .subsampleByCount: return "Subsample by Count"
        case .extractReadsByID: return "Extract Reads by ID"
        case .extractReadsByMotif: return "Extract Reads by Motif"
        case .selectReadsBySequence: return "Select Reads by Sequence"
        case .minimap2: return "minimap2"
        case .spades: return "SPAdes"
        case .kraken2: return "Kraken2"
        case .esViritu: return "EsViritu"
        case .taxTriage: return "TaxTriage"
        }
    }

    var subtitle: String {
        switch self {
        case .refreshQCSummary: return "Rebuild the QC summary for the current FASTQ data."
        case .demultiplexBarcodes: return "Split pooled reads into barcode-defined samples."
        case .qualityTrim: return "Trim low-quality bases from read ends."
        case .adapterRemoval: return "Remove adapter sequence from reads."
        case .primerTrimming: return "Trim PCR primer sequence from reads."
        case .trimFixedBases: return "Remove a fixed number of bases from either end."
        case .filterByReadLength: return "Keep reads in a requested length range."
        case .removeHumanReads: return "Remove reads against a human database."
        case .removeContaminants: return "Remove spike-ins or other contaminant sequences."
        case .removeDuplicates: return "Collapse duplicate reads."
        case .mergeOverlappingPairs: return "Merge overlapping paired-end reads."
        case .repairPairedEndFiles: return "Restore proper pairing for FASTQ mates."
        case .orientReads: return "Orient reads to a reference strand."
        case .correctSequencingErrors: return "Correct random sequencing errors."
        case .subsampleByProportion: return "Keep a fraction of the input reads."
        case .subsampleByCount: return "Keep a fixed number of reads."
        case .extractReadsByID: return "Select reads matching identifiers."
        case .extractReadsByMotif: return "Select reads containing a motif."
        case .selectReadsBySequence: return "Select reads matching a sequence."
        case .minimap2: return "Map reads to a reference sequence."
        case .spades: return "Assemble reads into contigs."
        case .kraken2: return "Classify reads taxonomically."
        case .esViritu: return "Detect viruses and report coverage."
        case .taxTriage: return "Run the TaxTriage pathogen workflow."
        }
    }

    var categoryID: FASTQOperationCategoryID {
        switch self {
        case .refreshQCSummary:
            return .qcReporting
        case .demultiplexBarcodes:
            return .demultiplexing
        case .qualityTrim, .adapterRemoval, .primerTrimming, .trimFixedBases, .filterByReadLength:
            return .trimmingFiltering
        case .removeHumanReads, .removeContaminants, .removeDuplicates:
            return .decontamination
        case .mergeOverlappingPairs, .repairPairedEndFiles, .orientReads, .correctSequencingErrors:
            return .readProcessing
        case .subsampleByProportion, .subsampleByCount, .extractReadsByID, .extractReadsByMotif, .selectReadsBySequence:
            return .searchSubsetting
        case .minimap2:
            return .mapping
        case .spades:
            return .assembly
        case .kraken2, .esViritu, .taxTriage:
            return .classification
        }
    }

    var requiredInputKinds: [FASTQOperationInputKind] {
        switch self {
        case .refreshQCSummary:
            return [.fastqDataset]
        case .demultiplexBarcodes:
            return [.fastqDataset, .barcodeDefinition]
        case .qualityTrim, .adapterRemoval, .trimFixedBases, .filterByReadLength,
             .removeDuplicates, .mergeOverlappingPairs, .repairPairedEndFiles,
             .correctSequencingErrors, .subsampleByProportion, .subsampleByCount,
             .extractReadsByID, .extractReadsByMotif, .selectReadsBySequence, .spades:
            return [.fastqDataset]
        case .primerTrimming:
            return [.fastqDataset, .primerSource]
        case .removeHumanReads, .kraken2, .esViritu, .taxTriage:
            return [.fastqDataset, .database]
        case .removeContaminants:
            return [.fastqDataset, .contaminantReference]
        case .orientReads, .minimap2:
            return [.fastqDataset, .referenceSequence]
        }
    }

    var defaultOutputMode: FASTQOperationOutputMode {
        categoryID == .classification ? .fixedBatch : .perInput
    }

    var sidebarItem: DatasetOperationToolSidebarItem {
        DatasetOperationToolSidebarItem(
            id: rawValue,
            title: title,
            subtitle: subtitle,
            availability: .available
        )
    }

    var usesEmbeddedConfiguration: Bool {
        switch self {
        case .minimap2, .spades, .kraken2, .esViritu, .taxTriage:
            return true
        default:
            return false
        }
    }

    var supportsConfigurableOutput: Bool {
        categoryID != .classification
    }

    var defaultEmbeddedReadiness: Bool {
        switch self {
        case .minimap2, .kraken2, .esViritu, .taxTriage:
            return false
        default:
            return true
        }
    }

    var embeddedReadinessText: String {
        switch self {
        case .minimap2:
            return "Select a reference sequence to continue."
        case .kraken2, .esViritu, .taxTriage:
            return "Complete the classifier settings to continue."
        case .spades:
            return "Complete the assembly settings to continue."
        default:
            return "Complete the required tool settings to continue."
        }
    }
}

enum FASTQOperationInputKind: String, CaseIterable, Sendable {
    case fastqDataset
    case referenceSequence
    case database
    case barcodeDefinition
    case primerSource
    case contaminantReference

    var title: String {
        switch self {
        case .fastqDataset:
            return "FASTQ Datasets"
        case .referenceSequence:
            return "Reference Sequence"
        case .database:
            return "Database"
        case .barcodeDefinition:
            return "Barcode Definition"
        case .primerSource:
            return "Primer Source"
        case .contaminantReference:
            return "Contaminant Reference"
        }
    }

    var missingSelectionText: String {
        switch self {
        case .referenceSequence:
            return "Select a reference sequence to continue."
        case .database:
            return "Select a database to continue."
        case .barcodeDefinition:
            return "Select a barcode definition to continue."
        case .primerSource:
            return "Select a primer source to continue."
        case .contaminantReference:
            return "Select a contaminant reference to continue."
        case .fastqDataset:
            return "Select at least one FASTQ dataset."
        }
    }

    func accepts(url: URL) -> Bool {
        let ext = url.pathExtension.lowercased()
        let fastaLike = ["fa", "fasta", "fna", "fas", "ffn", "frn", "faa", "gb", "gbk", "gbff", "embl", "lungfishref"]
        let textLike = ["txt", "csv", "tsv", "json", "fasta", "fa"]

        switch self {
        case .fastqDataset:
            return true
        case .referenceSequence, .contaminantReference:
            return fastaLike.contains(ext)
        case .database:
            return url.hasDirectoryPath || ext.isEmpty || ["db", "k2d", "sqlite", "json"].contains(ext)
        case .barcodeDefinition, .primerSource:
            return textLike.contains(ext)
        }
    }
}

enum FASTQOperationOutputMode: String, CaseIterable, Sendable {
    case perInput
    case groupedResult
    case fixedBatch
}

enum FASTQOperationLaunchRequest: Sendable, Equatable {
    case refreshQCSummary(inputURLs: [URL])
    case derivative(tool: FASTQOperationToolID, inputURLs: [URL], outputMode: FASTQOperationOutputMode)
    case map(inputURLs: [URL], referenceURL: URL, outputMode: FASTQOperationOutputMode)
    case assemble(inputURLs: [URL], outputMode: FASTQOperationOutputMode)
    case classify(tool: FASTQOperationToolID, inputURLs: [URL], databaseName: String)
}

extension FASTQOperationCategoryID {
    var defaultToolID: FASTQOperationToolID {
        switch self {
        case .qcReporting:
            return .refreshQCSummary
        case .demultiplexing:
            return .demultiplexBarcodes
        case .trimmingFiltering:
            return .qualityTrim
        case .decontamination:
            return .removeHumanReads
        case .readProcessing:
            return .mergeOverlappingPairs
        case .searchSubsetting:
            return .subsampleByProportion
        case .mapping:
            return .minimap2
        case .assembly:
            return .spades
        case .classification:
            return .kraken2
        }
    }
}
