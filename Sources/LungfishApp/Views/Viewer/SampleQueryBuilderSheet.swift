// SampleQueryBuilderSheet.swift - SwiftUI query builder for sample filtering
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import SwiftUI

private enum SampleQueryField: String, CaseIterable, Identifiable {
    case text
    case name
    case source
    case visible
    case metadata

    var id: String { rawValue }

    var label: String {
        switch self {
        case .text: return "Any Text"
        case .name: return "Sample Name"
        case .source: return "Source"
        case .visible: return "Visibility"
        case .metadata: return "Metadata"
        }
    }
}

private enum SampleQueryOperator: String, CaseIterable, Identifiable {
    case contains = "~"
    case notContains = "!~"
    case equals = "="
    case notEquals = "!="
    case beginsWith = "^="
    case endsWith = "$="
    case isEmpty = "is-empty"
    case isNotEmpty = "is-not-empty"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .contains: return "contains"
        case .notContains: return "does not contain"
        case .equals: return "equals"
        case .notEquals: return "not equals"
        case .beginsWith: return "begins with"
        case .endsWith: return "ends with"
        case .isEmpty: return "is empty"
        case .isNotEmpty: return "is not empty"
        }
    }

    var requiresValue: Bool {
        switch self {
        case .isEmpty, .isNotEmpty:
            return false
        default:
            return true
        }
    }
}

private struct SampleQueryRuleUI: Identifiable {
    let id = UUID()
    var field: SampleQueryField = .name
    var metadataField: String = ""
    var op: SampleQueryOperator = .contains
    var value: String = ""

    func toClause() -> String? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        let opToken: String
        switch op {
        case .isEmpty:
            opToken = "="
        case .isNotEmpty:
            opToken = "!="
        default:
            opToken = op.rawValue
        }
        switch field {
        case .text:
            guard !trimmed.isEmpty else { return nil }
            return "text~\(trimmed)"
        case .name:
            if op.requiresValue {
                guard !trimmed.isEmpty else { return nil }
                return "name\(opToken)\(trimmed)"
            }
            return "name\(opToken)"
        case .source:
            if op.requiresValue {
                guard !trimmed.isEmpty else { return nil }
                return "source\(opToken)\(trimmed)"
            }
            return "source\(opToken)"
        case .visible:
            if value == "visible" { return "visible=true" }
            if value == "hidden" { return "visible=false" }
            return nil
        case .metadata:
            let key = metadataField.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !key.isEmpty else { return nil }
            if op.requiresValue {
                guard !trimmed.isEmpty else { return nil }
                return "meta.\(key)\(opToken)\(trimmed)"
            }
            return "meta.\(key)\(opToken)"
        }
    }
}

struct SampleQueryBuilderView: View {
    @State private var rules: [SampleQueryRuleUI]
    let initialFilterText: String
    let metadataFields: [String]
    let onApply: (String) -> Void
    let onCancel: () -> Void

    init(
        initialFilterText: String,
        metadataFields: [String],
        onApply: @escaping (String) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.initialFilterText = initialFilterText
        self.metadataFields = metadataFields
        self.onApply = onApply
        self.onCancel = onCancel
        _rules = State(initialValue: Self.parseInitialRules(from: initialFilterText))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Sample Query Builder")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)

            Divider()

            ScrollView {
                VStack(spacing: 6) {
                    ForEach($rules) { $rule in
                        HStack(spacing: 6) {
                            Picker("", selection: $rule.field) {
                                ForEach(SampleQueryField.allCases) { field in
                                    Text(field.label).tag(field)
                                }
                            }
                            .frame(width: 130)

                            if rule.field == .metadata {
                                Picker("", selection: $rule.metadataField) {
                                    Text("Metadata Field").tag("")
                                    ForEach(metadataFields, id: \.self) { field in
                                        Text(field).tag(field)
                                    }
                                }
                                .frame(width: 150)
                            }

                            if rule.field != .visible {
                                if rule.field != .text {
                                    Picker("", selection: $rule.op) {
                                        ForEach(SampleQueryOperator.allCases) { op in
                                            Text(op.label).tag(op)
                                        }
                                    }
                                    .frame(width: 120)
                                }

                                if rule.field == .text || rule.op.requiresValue {
                                    TextField("Value", text: $rule.value)
                                        .textFieldStyle(.roundedBorder)
                                        .frame(minWidth: 180)
                                } else {
                                    Text("No value")
                                        .foregroundStyle(.secondary)
                                        .frame(minWidth: 180, alignment: .leading)
                                }
                            } else {
                                Picker("", selection: $rule.value) {
                                    Text("Visible").tag("visible")
                                    Text("Hidden").tag("hidden")
                                }
                                .frame(width: 140)
                            }

                            Button {
                                removeRule(rule.id)
                            } label: {
                                Image(systemName: "minus.circle")
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(Color.lungfishOrangeFallback)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .frame(minHeight: 140, maxHeight: 340)

            HStack {
                Button {
                    var next = SampleQueryRuleUI()
                    next.field = metadataFields.isEmpty ? .name : .metadata
                    if let first = metadataFields.first {
                        next.metadataField = first
                    }
                    if next.field == .visible {
                        next.value = "visible"
                    }
                    next.op = .contains
                    rules.append(next)
                } label: {
                    Label("Add Rule", systemImage: "plus.circle")
                }
                .buttonStyle(.plain)
                .font(.caption)
                .foregroundStyle(.blue)
                Spacer()
                if !initialFilterText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text("Current: \(initialFilterText)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)

            Divider()

            HStack {
                Button("Clear All") {
                    rules = [SampleQueryRuleUI()]
                }
                .buttonStyle(.bordered)
                .controlSize(.small)

                Button("Clear Filters") {
                    onApply("")
                }
                .buttonStyle(.bordered)
                .controlSize(.small)

                Spacer()

                Button("Cancel") {
                    onCancel()
                }
                .keyboardShortcut(.cancelAction)

                Button("Apply") {
                    let clauses = rules.compactMap { $0.toClause() }
                    onApply(clauses.joined(separator: "; "))
                }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .frame(width: 700, height: min(CGFloat(rules.count) * 56 + 220, 560))
        .onAppear {
            // Seed metadata rule defaults after first render.
            if let first = metadataFields.first {
                for idx in rules.indices where rules[idx].field == .metadata && rules[idx].metadataField.isEmpty {
                    rules[idx].metadataField = first
                }
            }
        }
    }

    private func removeRule(_ id: UUID) {
        rules.removeAll { $0.id == id }
        if rules.isEmpty {
            rules = [SampleQueryRuleUI()]
        }
    }

    private static func parseInitialRules(from rawText: String) -> [SampleQueryRuleUI] {
        let text = rawText
            .replacingOccurrences(
                of: #"^\s*samples:\s*"#,
                with: "",
                options: [.regularExpression, .caseInsensitive]
            )
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return [SampleQueryRuleUI()] }

        let operators = ["!~", "^=", "$=", "!=", "~", "="]
        var parsed: [SampleQueryRuleUI] = []

        for rawClause in text.split(separator: ";") {
            let clause = rawClause.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !clause.isEmpty else { continue }

            guard let op = operators.first(where: { clause.contains($0) }),
                  let range = clause.range(of: op) else {
                var rule = SampleQueryRuleUI()
                rule.field = .text
                rule.value = clause
                parsed.append(rule)
                continue
            }

            let key = String(clause[..<range.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
            let value = String(clause[range.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
            let lowerKey = key.lowercased()

            var rule = SampleQueryRuleUI()
            switch lowerKey {
            case "text":
                rule.field = .text
                rule.value = value
            case "name":
                rule.field = .name
                rule.op = opToSampleOperator(op: op, value: value)
                rule.value = value
            case "source":
                rule.field = .source
                rule.op = opToSampleOperator(op: op, value: value)
                rule.value = value
            case "visible":
                rule.field = .visible
                let lowerValue = value.lowercased()
                let isVisible = ["1", "true", "yes", "on", "visible"].contains(lowerValue)
                let isHidden = ["0", "false", "no", "off", "hidden"].contains(lowerValue)
                switch op {
                case "!=":
                    rule.value = isVisible ? "hidden" : "visible"
                default:
                    rule.value = isHidden ? "hidden" : "visible"
                }
            default:
                rule.field = .metadata
                if lowerKey.hasPrefix("meta.") {
                    rule.metadataField = String(key.dropFirst(5))
                } else {
                    rule.metadataField = key
                }
                rule.op = opToSampleOperator(op: op, value: value)
                rule.value = value
            }
            parsed.append(rule)
        }

        return parsed.isEmpty ? [SampleQueryRuleUI()] : parsed
    }

    private static func opToSampleOperator(op: String, value: String) -> SampleQueryOperator {
        if op == "=" && value.isEmpty { return .isEmpty }
        if op == "!=" && value.isEmpty { return .isNotEmpty }
        switch op {
        case "=": return .equals
        case "!=": return .notEquals
        case "~": return .contains
        case "!~": return .notContains
        case "^=": return .beginsWith
        case "$=": return .endsWith
        default: return .contains
        }
    }
}
