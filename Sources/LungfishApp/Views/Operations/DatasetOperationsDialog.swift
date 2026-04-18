import SwiftUI

struct DatasetOperationsDialog<Detail: View>: View {
    let title: String
    let subtitle: String
    let datasetLabel: String
    let tools: [DatasetOperationToolSidebarItem]
    let selectedToolID: String
    let statusText: String
    let isRunEnabled: Bool
    let onSelectTool: (String) -> Void
    let onCancel: () -> Void
    let onRun: () -> Void
    @ViewBuilder let detail: () -> Detail

    var body: some View {
        HStack(spacing: 0) {
            toolSidebar
                .frame(width: 260)
            Divider()
            VStack(spacing: 0) {
                detailPane
                Divider()
                footerBar
            }
        }
    }

    private var toolSidebar: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title2.weight(.semibold))
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(datasetLabel)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                ForEach(tools) { tool in
                    Button {
                        onSelectTool(tool.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text(tool.title)
                                Spacer(minLength: 8)
                                if let badgeText = tool.availability.badgeText {
                                    Text(badgeText)
                                        .font(.caption2.weight(.semibold))
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Text(tool.subtitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                    }
                    .buttonStyle(.plain)
                    .disabled(tool.availability != .available)
                    .background(selectedToolID == tool.id ? Color.accentColor.opacity(0.12) : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
            }
            .padding(16)
        }
    }

    private var detailPane: some View {
        detail()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(16)
    }

    private var footerBar: some View {
        HStack(spacing: 12) {
            Text(statusText)
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            Button("Cancel", action: onCancel)
            Button("Run", action: onRun)
                .disabled(!isRunEnabled)
        }
        .padding(16)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}
