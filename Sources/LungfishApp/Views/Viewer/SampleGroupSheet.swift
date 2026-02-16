// SampleGroupSheet.swift - SwiftUI sheet for managing sample groups
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import SwiftUI
import LungfishCore

// MARK: - Sample Group Sheet

/// SwiftUI view for creating and managing sample groups (e.g. "Cases" vs "Controls").
///
/// Presented as a sheet via NSHostingController. Users can create named groups,
/// assign samples to groups by dragging or selecting, and assign colors.
struct SampleGroupSheet: View {
    @State private var groups: [SampleGroup]
    @State private var selectedGroupId: UUID?
    @State private var newGroupName = ""

    let allSampleNames: [String]
    let onApply: ([SampleGroup]) -> Void
    let onCancel: () -> Void

    private static let groupColors = [
        "#4A90D9", "#E74C3C", "#2ECC71", "#F39C12",
        "#9B59B6", "#1ABC9C", "#E67E22", "#3498DB",
    ]

    init(groups: [SampleGroup], allSampleNames: [String], onApply: @escaping ([SampleGroup]) -> Void, onCancel: @escaping () -> Void) {
        _groups = State(initialValue: groups)
        self.allSampleNames = allSampleNames
        self.onApply = onApply
        self.onCancel = onCancel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Title
            HStack {
                Text("Sample Groups")
                    .font(.headline)
                Spacer()
                Text("\(allSampleNames.count) samples available")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)

            Divider()

            HStack(spacing: 0) {
                // Left: group list
                VStack(alignment: .leading, spacing: 8) {
                    Text("Groups")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)

                    List(selection: $selectedGroupId) {
                        ForEach(groups) { group in
                            HStack {
                                Circle()
                                    .fill(Color(hex: group.colorHex))
                                    .frame(width: 10, height: 10)
                                Text(group.name)
                                    .font(.system(size: 12))
                                Spacer()
                                Text("\(group.sampleNames.count)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .tag(group.id)
                        }
                        .onDelete { offsets in
                            groups.remove(atOffsets: offsets)
                            if let selected = selectedGroupId, !groups.contains(where: { $0.id == selected }) {
                                selectedGroupId = groups.first?.id
                            }
                        }
                    }
                    .listStyle(.bordered)
                    .frame(minWidth: 160)

                    HStack {
                        TextField("New group", text: $newGroupName)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(size: 11))
                        Button {
                            addGroup()
                        } label: {
                            Image(systemName: "plus")
                        }
                        .disabled(newGroupName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding(.horizontal, 8)
                }
                .frame(width: 200)
                .padding(.vertical, 8)

                Divider()

                // Right: sample assignment
                VStack(alignment: .leading, spacing: 8) {
                    if let groupId = selectedGroupId, let groupIndex = groups.firstIndex(where: { $0.id == groupId }) {
                        HStack {
                            Text("Assign samples to \"\(groups[groupIndex].name)\"")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            ColorPicker("", selection: colorBinding(for: groupIndex))
                                .labelsHidden()
                                .frame(width: 30)
                        }
                        .padding(.horizontal, 8)

                        List {
                            ForEach(allSampleNames, id: \.self) { sample in
                                HStack {
                                    Toggle(isOn: sampleBinding(sample: sample, groupIndex: groupIndex)) {
                                        Text(sample)
                                            .font(.system(size: 11, design: .monospaced))
                                    }
                                    .toggleStyle(.checkbox)

                                    Spacer()

                                    // Show which group(s) this sample belongs to
                                    ForEach(groups.filter({ $0.sampleNames.contains(sample) && $0.id != groupId })) { otherGroup in
                                        Circle()
                                            .fill(Color(hex: otherGroup.colorHex))
                                            .frame(width: 6, height: 6)
                                            .help(otherGroup.name)
                                    }
                                }
                            }
                        }
                        .listStyle(.bordered)

                        HStack {
                            Button("Select All") {
                                groups[groupIndex].sampleNames = Set(allSampleNames)
                            }
                            .controlSize(.small)

                            Button("Deselect All") {
                                groups[groupIndex].sampleNames.removeAll()
                            }
                            .controlSize(.small)

                            Spacer()
                        }
                        .padding(.horizontal, 8)
                    } else {
                        Spacer()
                        Text("Select or create a group to assign samples")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Spacer()
                    }
                }
                .frame(minWidth: 300)
                .padding(.vertical, 8)
            }
            .frame(minHeight: 300, maxHeight: 450)

            Divider()

            // Action buttons
            HStack {
                if !groups.isEmpty {
                    Text(groupSummary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button("Cancel") {
                    onCancel()
                }
                .keyboardShortcut(.cancelAction)

                Button("Apply") {
                    onApply(groups)
                }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .frame(width: 560, height: 480)
    }

    private var groupSummary: String {
        let assigned = Set(groups.flatMap(\.sampleNames))
        return "\(assigned.count)/\(allSampleNames.count) samples assigned to \(groups.count) group\(groups.count == 1 ? "" : "s")"
    }

    private func addGroup() {
        let name = newGroupName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        let colorIndex = groups.count % Self.groupColors.count
        let group = SampleGroup(name: name, colorHex: Self.groupColors[colorIndex])
        groups.append(group)
        selectedGroupId = group.id
        newGroupName = ""
    }

    private func sampleBinding(sample: String, groupIndex: Int) -> Binding<Bool> {
        Binding(
            get: { groups[groupIndex].sampleNames.contains(sample) },
            set: { isOn in
                if isOn {
                    groups[groupIndex].sampleNames.insert(sample)
                } else {
                    groups[groupIndex].sampleNames.remove(sample)
                }
            }
        )
    }

    private func colorBinding(for groupIndex: Int) -> Binding<Color> {
        Binding(
            get: { Color(hex: groups[groupIndex].colorHex) },
            set: { newColor in
                // Convert SwiftUI Color to hex string
                if let components = NSColor(newColor).usingColorSpace(.sRGB) {
                    let hex = String(format: "#%02X%02X%02X",
                                     Int(components.redComponent * 255),
                                     Int(components.greenComponent * 255),
                                     Int(components.blueComponent * 255))
                    groups[groupIndex].colorHex = hex
                }
            }
        )
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8) & 0xFF) / 255.0
        let b = Double(int & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
