import SwiftUI
import UniformTypeIdentifiers

struct FASTQOperationToolPanes: View {
    @Bindable var state: FASTQOperationDialogState

    var body: some View {
        switch state.selectedToolID {
        case .minimap2:
            MapReadsWizardSheet(
                inputFiles: state.selectedInputURLs,
                projectURL: state.projectURL,
                embeddedInOperationsDialog: true,
                embeddedRunTrigger: state.embeddedRunTrigger,
                onRun: state.captureMinimap2Config(_:),
                onRunnerAvailabilityChange: state.updateEmbeddedReadiness(_:)
            )
        case .spades:
            AssemblyWizardSheet(
                inputFiles: state.selectedInputURLs,
                outputDirectory: state.outputDirectoryURL,
                embeddedInOperationsDialog: true,
                embeddedRunTrigger: state.embeddedRunTrigger,
                onRun: state.captureSPAdesConfig(_:),
                onRunnerAvailabilityChange: state.updateEmbeddedReadiness(_:)
            )
        case .kraken2:
            ClassificationWizardSheet(
                inputFiles: state.selectedInputURLs,
                embeddedInOperationsDialog: true,
                embeddedRunTrigger: state.embeddedRunTrigger,
                onRun: state.captureClassificationConfigs(_:),
                onRunnerAvailabilityChange: state.updateEmbeddedReadiness(_:)
            )
        case .esViritu:
            EsVirituWizardSheet(
                inputFiles: state.selectedInputURLs,
                embeddedInOperationsDialog: true,
                embeddedRunTrigger: state.embeddedRunTrigger,
                onRun: state.captureEsVirituConfigs(_:),
                onRunnerAvailabilityChange: state.updateEmbeddedReadiness(_:)
            )
        case .taxTriage:
            TaxTriageWizardSheet(
                initialFiles: state.selectedInputURLs,
                embeddedInOperationsDialog: true,
                embeddedRunTrigger: state.embeddedRunTrigger,
                onRun: state.captureTaxTriageConfig(_:),
                onRunnerAvailabilityChange: state.updateEmbeddedReadiness(_:)
            )
        default:
            derivativePane
        }
    }

    private var derivativePane: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                section(DatasetOperationSection.overview.title) {
                    Text(state.selectedToolSummary)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                if state.visibleSections.contains(.inputs) {
                    section(state.inputSectionTitle) {
                        FASTQOperationInputsSection(state: state)
                    }
                }

                if state.visibleSections.contains(.primarySettings) {
                    section(DatasetOperationSection.primarySettings.title) {
                        FASTQOperationPrimarySettingsSection(state: state)
                    }
                }

                if state.visibleSections.contains(.advancedSettings) {
                    section(DatasetOperationSection.advancedSettings.title) {
                        FASTQOperationAdvancedSettingsSection(state: state)
                    }
                }

                if state.visibleSections.contains(.output) {
                    section(state.outputSectionTitle) {
                        Picker("Output Strategy", selection: $state.outputMode) {
                            ForEach(state.outputStrategyOptions, id: \.self) { option in
                                Text(option.title).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }

                if state.visibleSections.contains(.readiness) {
                    section(DatasetOperationSection.readiness.title) {
                        Text(state.readinessText)
                            .font(.callout)
                            .foregroundStyle(state.isRunEnabled ? Color.lungfishSecondaryText : Color.lungfishOrangeFallback)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
    }

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct FASTQOperationInputsSection: View {
    @Bindable var state: FASTQOperationDialogState
    @State private var browsingInputKind: FASTQOperationInputKind?
    @State private var isImporterPresented = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(state.datasetLabel, systemImage: "doc.text")
                .font(.body)

            ForEach(state.requiredInputKinds.filter { $0 != .fastqDataset }, id: \.self) { kind in
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .center, spacing: 10) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(kind.title)
                                .font(.subheadline.weight(.medium))
                            Text(inputSummary(for: kind))
                                .font(.caption)
                                .foregroundStyle(inputSummaryColor(for: kind))
                        }

                        Spacer()

                        Button(state.auxiliaryInputURL(for: kind) == nil ? "Choose…" : "Replace…") {
                            browsingInputKind = kind
                            isImporterPresented = true
                        }

                        if state.auxiliaryInputURL(for: kind) != nil {
                            Button("Clear") {
                                state.removeAuxiliaryInput(for: kind)
                            }
                        }
                    }
                }
            }
        }
        .fileImporter(
            isPresented: $isImporterPresented,
            allowedContentTypes: [.item],
            allowsMultipleSelection: false
        ) { result in
            defer { browsingInputKind = nil }
            guard let browsingInputKind else { return }
            guard case .success(let urls) = result, let url = urls.first else { return }
            state.setAuxiliaryInput(url, for: browsingInputKind)
        }
    }

    private func inputSummary(for kind: FASTQOperationInputKind) -> String {
        guard let url = state.auxiliaryInputURL(for: kind) else {
            return "Required before this tool can run."
        }

        guard state.isAuxiliaryInputValid(for: kind) else {
            return "\(url.lastPathComponent) is not a valid \(kind.title.lowercased())."
        }

        return url.lastPathComponent
    }

    private func inputSummaryColor(for kind: FASTQOperationInputKind) -> Color {
        state.auxiliaryInputURL(for: kind) != nil && !state.isAuxiliaryInputValid(for: kind)
            ? Color.lungfishOrangeFallback
            : .secondary
    }
}

private struct FASTQOperationPrimarySettingsSection: View {
    let state: FASTQOperationDialogState

    var body: some View {
        Text(primarySettingsSummary)
            .font(.body)
            .foregroundStyle(.secondary)
    }

    private var primarySettingsSummary: String {
        switch state.selectedToolID {
        case .refreshQCSummary:
            return "No additional primary settings are required for this QC summary refresh."
        case .demultiplexBarcodes:
            return "Choose the barcode definition input to split pooled reads into sample-specific outputs."
        case .orientReads:
            return "Orienting requires a reference sequence and keeps output configurable once that input is present."
        default:
            return "Primary settings for \(state.selectedToolID.title) will live in this standardized section."
        }
    }
}

private struct FASTQOperationAdvancedSettingsSection: View {
    let state: FASTQOperationDialogState

    var body: some View {
        Text(advancedSummary)
            .font(.body)
            .foregroundStyle(.secondary)
    }

    private var advancedSummary: String {
        switch state.selectedToolID {
        case .qualityTrim, .adapterRemoval, .primerTrimming, .trimFixedBases, .filterByReadLength:
            return "Advanced trimming controls will stay grouped here instead of spilling into the dataset drawer."
        case .removeHumanReads, .removeContaminants, .removeDuplicates:
            return "Advanced decontamination controls will stay grouped here."
        default:
            return "Advanced \(state.selectedToolID.title.lowercased()) options will stay grouped here."
        }
    }
}

private extension FASTQOperationOutputMode {
    var title: String {
        switch self {
        case .perInput:
            return "Per Input"
        case .groupedResult:
            return "Grouped Result"
        case .fixedBatch:
            return "Batch Output"
        }
    }
}
