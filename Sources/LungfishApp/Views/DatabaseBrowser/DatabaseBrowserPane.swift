import SwiftUI
import LungfishCore

struct DatabaseBrowserPane<Accessory: View>: View {
    @ObservedObject var viewModel: DatabaseBrowserViewModel
    let title: String
    let summary: String
    @ViewBuilder let accessoryControls: () -> Accessory

    init(
        viewModel: DatabaseBrowserViewModel,
        title: String,
        summary: String,
        @ViewBuilder accessoryControls: @escaping () -> Accessory
    ) {
        self.viewModel = viewModel
        self.title = title
        self.summary = summary
        self.accessoryControls = accessoryControls
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            accessoryControls()
            searchControls
            resultsSection
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title2.weight(.semibold))
            Text(summary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var searchControls: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                AppKitTextField(
                    text: $viewModel.searchText,
                    placeholder: searchPlaceholder,
                    onSubmit: {
                        viewModel.performSearch()
                    }
                )
                .frame(minWidth: 260)

                Button("Search") {
                    viewModel.performSearch()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.isSearchTextValid || viewModel.isSearching || viewModel.isDownloading)
            }

            if viewModel.searchScope != .all {
                Text(viewModel.searchScope.helpText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Results")
                .font(.headline)

            if viewModel.isSearching || viewModel.isDownloading {
                ProgressView()
                Text(viewModel.statusMessage ?? "Working…")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else if viewModel.filteredResults.isEmpty {
                Text(emptyStateText)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            } else {
                List(viewModel.filteredResults) { record in
                    DatabaseSearchResultRow(
                        record: record,
                        isSelected: viewModel.selectedRecords.contains(record),
                        onToggle: {
                            toggleSelection(for: record)
                        }
                    )
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private var searchPlaceholder: String {
        switch viewModel.searchScope {
        case .all:
            return "Search by accession, organism, or title"
        case .accession:
            return "Search by accession"
        case .organism:
            return "Search by organism"
        case .title:
            return "Search by title"
        case .bioProject:
            return "Search by BioProject"
        case .author:
            return "Search by author"
        }
    }

    private var emptyStateText: String {
        if viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Enter a search term to find records."
        }
        return "No results matched the current search."
    }

    private func toggleSelection(for record: SearchResultRecord) {
        if viewModel.selectedRecords.contains(record) {
            viewModel.selectedRecords.remove(record)
        } else {
            viewModel.selectedRecords.insert(record)
        }
    }
}

struct DatabaseSearchResultRow: View {
    let record: SearchResultRecord
    var isSelected: Bool
    var onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)
                    .font(.title3)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(record.accession)
                            .font(.headline.monospaced())
                        if let sourceDatabase = record.sourceDatabase, !sourceDatabase.isEmpty {
                            Text(sourceDatabase)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        if let length = record.length {
                            Text("\(length) bp")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Text(record.title)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .lineLimit(2)

                    if let organism = record.organism, !organism.isEmpty {
                        Text(organism)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
