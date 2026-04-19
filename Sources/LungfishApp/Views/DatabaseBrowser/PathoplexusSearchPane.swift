import SwiftUI
import LungfishCore

struct PathoplexusSearchPane: View {
    @ObservedObject var viewModel: DatabaseBrowserViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pathoplexus adds consent-aware browsing and organism targeting on top of the shared search controls.")
                .font(.callout)
                .foregroundStyle(.secondary)

            DatabaseBrowserPane(
                viewModel: viewModel,
                title: "Pathoplexus",
                summary: "Search open pathogen records and surveillance metadata."
            ) {
                EmptyView()
            }
        }
    }
}
