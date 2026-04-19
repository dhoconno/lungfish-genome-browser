import Observation
import SwiftUI
import LungfishCore

struct DatabaseSearchDialog: View {
    @Bindable var state: DatabaseSearchDialogState

    var body: some View {
        DatasetOperationsDialog(
            title: state.dialogTitle,
            subtitle: state.dialogSubtitle,
            datasetLabel: state.contextLabel,
            tools: state.sidebarItems,
            selectedToolID: state.selectedToolID,
            statusText: state.statusText,
            isRunEnabled: state.isPrimaryActionEnabled,
            primaryActionTitle: state.primaryActionTitle,
            onSelectTool: state.selectDestination(named:),
            onCancel: state.cancel,
            onRun: state.performPrimaryAction
        ) {
            detailPane
        }
    }

    @ViewBuilder
    private var detailPane: some View {
        switch state.selectedDestination {
        case .genBankGenomes:
            GenBankGenomesSearchPane(viewModel: state.genBankGenomesViewModel)
        case .sraRuns:
            SRARunsSearchPane(viewModel: state.sraRunsViewModel)
        case .pathoplexus:
            PathoplexusSearchPane(viewModel: state.pathoplexusViewModel)
        }
    }
}
