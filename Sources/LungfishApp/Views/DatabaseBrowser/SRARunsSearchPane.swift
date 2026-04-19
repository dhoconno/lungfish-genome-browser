import SwiftUI
import LungfishCore

struct SRARunsSearchPane: View {
    @ObservedObject var viewModel: DatabaseBrowserViewModel

    var body: some View {
        DatabaseBrowserPane(
            viewModel: viewModel,
            title: "SRA Runs",
            summary: "Search sequencing runs and import accession lists."
        ) {
            HStack(spacing: 12) {
                Button("Import Accessions") {
                    viewModel.importAccessionList()
                }
                Text("Use CSV or plain text accession lists when you already have run IDs.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
