// ImportCenterWindowController.swift - Import Center window for data import workflows
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import SwiftUI
import LungfishCore
import os.log

/// Logger for the Import Center window.
private let logger = Logger(subsystem: LogSubsystem.app, category: "ImportCenter")

/// NSWindowController that hosts the Import Center SwiftUI view.
///
/// Provides a singleton window for importing alignments, variants,
/// classification results, and reference sequences into the current
/// project. Follows the same lazy singleton pattern used by
/// ``PluginManagerWindowController``.
///
/// The window features a toolbar with a segmented control
/// (Alignments / Variants / Classification Results / References)
/// and a search field. The content area is a SwiftUI
/// ``ImportCenterView`` wrapped in an ``NSHostingView``.
///
/// ## Usage
///
/// ```swift
/// ImportCenterWindowController.show()
/// ImportCenterWindowController.show(tab: .classificationResults)
/// ```
@MainActor
public final class ImportCenterWindowController: NSWindowController, NSToolbarDelegate {

    /// Shared singleton instance. Created on first call to ``show()``.
    private static var shared: ImportCenterWindowController?

    /// The SwiftUI view model, retained for toolbar-to-view binding.
    private let viewModel = ImportCenterViewModel()

    /// Toolbar item identifiers.
    private enum ToolbarID {
        static let segmentedControl = NSToolbarItem.Identifier("importCenterSegment")
        static let searchField = NSToolbarItem.Identifier("importCenterSearch")
    }

    // MARK: - Singleton Access

    /// Shows the Import Center window, creating it if needed.
    ///
    /// Reuses the singleton window if it already exists. Centers the
    /// window on first display.
    public static func show() {
        showWindow(tab: nil)
    }

    /// Shows the Import Center window and switches to the specified tab.
    ///
    /// - Parameter tab: The tab to display. Pass `.classificationResults`
    ///   to navigate directly to the classification import view.
    static func show(tab: ImportCenterViewModel.Tab) {
        showWindow(tab: tab)
    }

    /// Internal implementation shared by both `show()` overloads.
    private static func showWindow(tab: ImportCenterViewModel.Tab?) {
        if shared == nil {
            shared = ImportCenterWindowController()
        }
        if let tab {
            shared?.viewModel.selectedTab = tab
            shared?.syncSegmentedControl(to: tab)
        }
        shared?.showWindow(nil)
    }

    // MARK: - Initialization

    private init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Import Center"
        window.minSize = NSSize(width: 640, height: 400)
        window.setFrameAutosaveName("ImportCenterWindow")
        window.isRestorable = false
        window.isReleasedWhenClosed = false

        super.init(window: window)

        setupToolbar()
        setupContent()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupToolbar() {
        guard let window else { return }

        let toolbar = NSToolbar(identifier: "ImportCenterToolbar")
        toolbar.delegate = self
        toolbar.displayMode = .iconOnly
        toolbar.allowsUserCustomization = false
        window.toolbar = toolbar
    }

    private func setupContent() {
        guard let window else { return }
        let hostingView = NSHostingView(rootView: ImportCenterView(viewModel: viewModel))
        window.contentView = hostingView
    }

    // MARK: - Window Lifecycle

    override public func showWindow(_ sender: Any?) {
        guard let window else { return }
        if !window.isVisible {
            window.center()
        }
        window.makeKeyAndOrderFront(nil)
        NSApp.activate()
        logger.info("Import Center window shown")
    }

    // MARK: - NSToolbarDelegate

    public func toolbar(
        _ toolbar: NSToolbar,
        itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar flag: Bool
    ) -> NSToolbarItem? {
        switch itemIdentifier {
        case ToolbarID.segmentedControl:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            let labels = ImportCenterViewModel.Tab.allCases.map(\.title)
            let segmented = NSSegmentedControl(
                labels: labels,
                trackingMode: .selectOne,
                target: self,
                action: #selector(segmentChanged(_:))
            )
            segmented.segmentStyle = .texturedRounded
            segmented.selectedSegment = viewModel.selectedTab.segmentIndex
            segmented.setWidth(100, forSegment: 0)
            segmented.setWidth(80, forSegment: 1)
            segmented.setWidth(160, forSegment: 2)
            segmented.setWidth(95, forSegment: 3)
            item.view = segmented
            item.label = "Category"
            item.toolTip = "Switch between import categories"
            return item

        case ToolbarID.searchField:
            let item = NSSearchToolbarItem(itemIdentifier: itemIdentifier)
            item.searchField.delegate = self
            item.searchField.placeholderString = "Filter import types"
            return item

        default:
            return nil
        }
    }

    public func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            ToolbarID.segmentedControl,
            .flexibleSpace,
            ToolbarID.searchField,
        ]
    }

    public func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        toolbarDefaultItemIdentifiers(toolbar)
    }

    // MARK: - Toolbar Actions

    @objc private func segmentChanged(_ sender: NSSegmentedControl) {
        let tab = ImportCenterViewModel.Tab.from(segmentIndex: sender.selectedSegment)
        viewModel.selectedTab = tab
    }

    // MARK: - Helpers

    /// Synchronizes the toolbar segmented control to match a given tab.
    ///
    /// Called when ``show(tab:)`` programmatically changes the selected tab
    /// so that the toolbar visual state remains in sync with the view model.
    private func syncSegmentedControl(to tab: ImportCenterViewModel.Tab) {
        guard let toolbar = window?.toolbar else { return }
        for item in toolbar.items where item.itemIdentifier == ToolbarID.segmentedControl {
            if let segmented = item.view as? NSSegmentedControl {
                segmented.selectedSegment = tab.segmentIndex
            }
        }
    }
}

// MARK: - NSSearchFieldDelegate

extension ImportCenterWindowController: NSSearchFieldDelegate {

    public func controlTextDidChange(_ obj: Notification) {
        guard let field = obj.object as? NSSearchField else { return }
        viewModel.searchText = field.stringValue
    }
}
