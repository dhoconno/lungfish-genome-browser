// RenderingSettingsTab.swift - Advanced rendering preferences tab
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import SwiftUI
import LungfishCore

/// Advanced rendering preferences: zoom thresholds, display limits, fetch caps.
struct RenderingSettingsTab: View {

    @State private var settings = AppSettings.shared

    var body: some View {
        Form {
            Section("Display Limits") {
                Stepper(
                    "Max annotation rows: \(settings.maxAnnotationRows)",
                    value: $settings.maxAnnotationRows,
                    in: 10...200,
                    step: 10
                )
                Stepper(
                    "Max table items: \(settings.maxTableDisplayCount.formatted())",
                    value: $settings.maxTableDisplayCount,
                    in: 1_000...50_000,
                    step: 1_000
                )
            }

            Section("Sequence Fetch") {
                Stepper(
                    "Fetch cap: \(settings.sequenceFetchCapKb) Kb",
                    value: $settings.sequenceFetchCapKb,
                    in: 100...5_000,
                    step: 100
                )
                Text("Sequence data is only fetched when the viewport is narrower than this limit.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Zoom Thresholds") {
                Stepper(
                    "Density mode: > \(Int(settings.densityThresholdBpPerPixel).formatted()) bp/px",
                    value: $settings.densityThresholdBpPerPixel,
                    in: 10_000...500_000,
                    step: 5_000
                )
                Stepper(
                    "Squished mode: > \(Int(settings.squishedThresholdBpPerPixel).formatted()) bp/px",
                    value: $settings.squishedThresholdBpPerPixel,
                    in: 100...5_000,
                    step: 100
                )
                Stepper(
                    "Show letters: < \(Int(settings.showLettersThresholdBpPerPixel)) bp/px",
                    value: $settings.showLettersThresholdBpPerPixel,
                    in: 1...50,
                    step: 1
                )
                Text("These thresholds control which annotation rendering mode is used at different zoom levels.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Spacer()
                Button("Restore Defaults") {
                    settings.resetSection(.rendering)
                }
            }
        }
        .formStyle(.grouped)
        .onChange(of: settings.maxAnnotationRows) { _, _ in settings.save() }
        .onChange(of: settings.maxTableDisplayCount) { _, _ in settings.save() }
        .onChange(of: settings.sequenceFetchCapKb) { _, _ in settings.save() }
        .onChange(of: settings.densityThresholdBpPerPixel) { _, _ in settings.save() }
        .onChange(of: settings.squishedThresholdBpPerPixel) { _, _ in settings.save() }
        .onChange(of: settings.showLettersThresholdBpPerPixel) { _, _ in settings.save() }
    }
}
