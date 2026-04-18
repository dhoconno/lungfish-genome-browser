// SettingsView.swift - Root SwiftUI settings tab view
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import SwiftUI
import LungfishCore

/// Root settings view containing all preference tabs.
///
/// Follows macOS HIG tab-based settings layout with five categories:
/// General, Appearance, Rendering, Storage, and AI Services.
struct SettingsView: View {
    @Bindable private var navigation = SettingsNavigationState.shared

    var body: some View {
        TabView(selection: $navigation.selectedTab) {
            GeneralSettingsTab()
                .tag(SettingsNavigationTab.general)
                .tabItem { Label("General", systemImage: "gearshape") }
            AppearanceSettingsTab()
                .tag(SettingsNavigationTab.appearance)
                .tabItem { Label("Appearance", systemImage: "paintbrush") }
            RenderingSettingsTab()
                .tag(SettingsNavigationTab.rendering)
                .tabItem { Label("Rendering", systemImage: "slider.horizontal.3") }
            StorageSettingsTab()
                .tag(SettingsNavigationTab.storage)
                .tabItem { Label("Storage", systemImage: "internaldrive") }
            AIServicesSettingsTab()
                .tag(SettingsNavigationTab.aiServices)
                .tabItem { Label("AI Services", systemImage: "brain") }
        }
        .frame(minWidth: 550, idealWidth: 680, minHeight: 460, idealHeight: 560)
    }
}
