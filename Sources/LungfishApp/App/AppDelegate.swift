// AppDelegate.swift - Application lifecycle management
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import LungfishCore
import UniformTypeIdentifiers

/// Main application delegate handling app lifecycle and global state.
@MainActor
public class AppDelegate: NSObject, NSApplicationDelegate,
    FileMenuActions, ViewMenuActions, SequenceMenuActions, ToolsMenuActions, HelpMenuActions {

    /// The shared application delegate instance
    public static var shared: AppDelegate? {
        NSApp.delegate as? AppDelegate
    }

    /// Main window controller for the application
    private var mainWindowController: MainWindowController?

    // MARK: - Application Lifecycle

    public func applicationWillFinishLaunching(_ notification: Notification) {
        // Install the main menu before app finishes launching
        NSApp.mainMenu = MainMenu.createMainMenu()
    }

    public func applicationDidFinishLaunching(_ notification: Notification) {
        // Create and show the main window
        mainWindowController = MainWindowController()
        mainWindowController?.showWindow(nil)

        // Configure application appearance
        configureAppearance()

        // Register for system notifications
        registerNotifications()
    }

    public func applicationWillTerminate(_ notification: Notification) {
        // Save application state
        saveApplicationState()
    }

    public func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // Keep app running even when all windows are closed (standard macOS behavior)
        return false
    }

    public func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // Show main window when dock icon is clicked
        if !flag {
            mainWindowController?.showWindow(nil)
        }
        return true
    }

    // MARK: - File Handling

    public func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        // Handle opening files via Finder or drag-drop to dock
        let url = URL(fileURLWithPath: filename)
        return openDocument(at: url)
    }

    public func application(_ sender: NSApplication, openFiles filenames: [String]) {
        // Handle opening multiple files
        for filename in filenames {
            let url = URL(fileURLWithPath: filename)
            _ = openDocument(at: url)
        }
    }

    // MARK: - Private Methods

    private func configureAppearance() {
        // Use system appearance (respects Dark Mode)
        // No custom appearance overrides - follow HIG
    }

    private func registerNotifications() {
        // Register for relevant system notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowWillClose(_:)),
            name: NSWindow.willCloseNotification,
            object: nil
        )
    }

    @objc private func windowWillClose(_ notification: Notification) {
        // Handle window close events
    }

    private func saveApplicationState() {
        // Persist user preferences and window state
        UserDefaults.standard.synchronize()
    }

    private func openDocument(at url: URL) -> Bool {
        // TODO: Implement document opening
        // For now, just return true to indicate we handled it
        print("Opening document: \(url.path)")
        return true
    }

    // MARK: - Menu Actions

    @IBAction func newDocument(_ sender: Any?) {
        // Create new project/document
        mainWindowController?.showWindow(nil)
    }

    @IBAction func openDocument(_ sender: Any?) {
        // Show open panel
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [
            .init(filenameExtension: "fa")!,
            .init(filenameExtension: "fasta")!,
            .init(filenameExtension: "fna")!,
            .init(filenameExtension: "gb")!,
            .init(filenameExtension: "gbk")!,
            .init(filenameExtension: "gff")!,
            .init(filenameExtension: "gff3")!,
        ]

        panel.begin { response in
            if response == .OK {
                for url in panel.urls {
                    _ = self.openDocument(at: url)
                }
            }
        }
    }

    @IBAction func showPreferences(_ sender: Any?) {
        // Show preferences window (will be SwiftUI Settings scene)
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
    }

    // MARK: - FileMenuActions

    @objc func importFASTA(_ sender: Any?) {
        showImportPanel(
            title: "Import FASTA Sequences",
            types: [
                UTType(filenameExtension: "fa")!,
                UTType(filenameExtension: "fasta")!,
                UTType(filenameExtension: "fna")!,
            ]
        )
    }

    @objc func importFASTQ(_ sender: Any?) {
        showImportPanel(
            title: "Import FASTQ Reads",
            types: [
                UTType(filenameExtension: "fq")!,
                UTType(filenameExtension: "fastq")!,
            ]
        )
    }

    @objc func importGenBank(_ sender: Any?) {
        showImportPanel(
            title: "Import GenBank File",
            types: [
                UTType(filenameExtension: "gb")!,
                UTType(filenameExtension: "gbk")!,
            ]
        )
    }

    @objc func importGFF3(_ sender: Any?) {
        showImportPanel(
            title: "Import GFF3 Annotations",
            types: [
                UTType(filenameExtension: "gff")!,
                UTType(filenameExtension: "gff3")!,
            ]
        )
    }

    @objc func importBED(_ sender: Any?) {
        showImportPanel(
            title: "Import BED Annotations",
            types: [
                UTType(filenameExtension: "bed")!,
            ]
        )
    }

    @objc func importBAM(_ sender: Any?) {
        showImportPanel(
            title: "Import BAM/CRAM Alignments",
            types: [
                UTType(filenameExtension: "bam")!,
                UTType(filenameExtension: "cram")!,
            ]
        )
    }

    @objc func exportFASTA(_ sender: Any?) {
        showExportPanel(title: "Export FASTA", defaultExtension: "fa")
    }

    @objc func exportGenBank(_ sender: Any?) {
        showExportPanel(title: "Export GenBank", defaultExtension: "gb")
    }

    @objc func exportGFF3(_ sender: Any?) {
        showExportPanel(title: "Export GFF3", defaultExtension: "gff3")
    }

    @objc func exportImage(_ sender: Any?) {
        showExportPanel(title: "Export Image", defaultExtension: "png")
    }

    @objc func exportPDF(_ sender: Any?) {
        showExportPanel(title: "Export PDF", defaultExtension: "pdf")
    }

    private func showImportPanel(title: String, types: [UTType]) {
        let panel = NSOpenPanel()
        panel.title = title
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.allowedContentTypes = types

        panel.begin { response in
            if response == .OK {
                for url in panel.urls {
                    _ = self.openDocument(at: url)
                }
            }
        }
    }

    private func showExportPanel(title: String, defaultExtension: String) {
        let panel = NSSavePanel()
        panel.title = title
        panel.allowedContentTypes = [UTType(filenameExtension: defaultExtension)!]
        panel.nameFieldStringValue = "untitled.\(defaultExtension)"

        panel.begin { response in
            if response == .OK, let url = panel.url {
                print("Export to: \(url.path)")
                // TODO: Implement export
            }
        }
    }

    // MARK: - ViewMenuActions

    @objc func toggleSidebar(_ sender: Any?) {
        mainWindowController?.mainSplitViewController?.toggleSidebar(nil)
    }

    @objc func toggleInspector(_ sender: Any?) {
        mainWindowController?.mainSplitViewController?.toggleInspector()
    }

    @objc func zoomIn(_ sender: Any?) {
        mainWindowController?.mainSplitViewController?.viewerController?.zoomIn()
    }

    @objc func zoomOut(_ sender: Any?) {
        mainWindowController?.mainSplitViewController?.viewerController?.zoomOut()
    }

    @objc func zoomToFit(_ sender: Any?) {
        mainWindowController?.mainSplitViewController?.viewerController?.zoomToFit()
    }

    @objc func setDisplayModeCollapsed(_ sender: Any?) {
        // TODO: Implement display mode change
    }

    @objc func setDisplayModeSquished(_ sender: Any?) {
        // TODO: Implement display mode change
    }

    @objc func setDisplayModeExpanded(_ sender: Any?) {
        // TODO: Implement display mode change
    }

    // MARK: - SequenceMenuActions

    @objc func reverseComplement(_ sender: Any?) {
        // TODO: Implement reverse complement
    }

    @objc func translate(_ sender: Any?) {
        // TODO: Implement translation
    }

    @objc func goToPosition(_ sender: Any?) {
        // Show go-to-position dialog
        let alert = NSAlert()
        alert.messageText = "Go to Position"
        alert.informativeText = "Enter a genomic position or region:"
        alert.addButton(withTitle: "Go")
        alert.addButton(withTitle: "Cancel")

        let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        textField.placeholderString = "chr1:1000000 or chr1:1000000-2000000"
        alert.accessoryView = textField

        if alert.runModal() == .alertFirstButtonReturn {
            let input = textField.stringValue
            print("Navigate to: \(input)")
            // TODO: Parse position and navigate
        }
    }

    @objc func selectRegion(_ sender: Any?) {
        // TODO: Implement region selection
    }

    @objc func addAnnotation(_ sender: Any?) {
        // TODO: Implement add annotation
    }

    @objc func findORFs(_ sender: Any?) {
        // TODO: Implement ORF finding
    }

    @objc func findRestrictionSites(_ sender: Any?) {
        // TODO: Implement restriction site finding
    }

    // MARK: - ToolsMenuActions

    @objc func runSPAdes(_ sender: Any?) {
        showNotImplementedAlert("SPAdes Assembly")
    }

    @objc func runMEGAHIT(_ sender: Any?) {
        showNotImplementedAlert("MEGAHIT Assembly")
    }

    @objc func designPrimers(_ sender: Any?) {
        showNotImplementedAlert("Primer Design")
    }

    @objc func primalScheme(_ sender: Any?) {
        showNotImplementedAlert("PrimalScheme")
    }

    @objc func inSilicoPCR(_ sender: Any?) {
        showNotImplementedAlert("In-Silico PCR")
    }

    @objc func alignSequences(_ sender: Any?) {
        showNotImplementedAlert("Sequence Alignment")
    }

    @objc func searchNCBI(_ sender: Any?) {
        showNotImplementedAlert("NCBI Search")
    }

    @objc func searchENA(_ sender: Any?) {
        showNotImplementedAlert("ENA Search")
    }

    @objc func runNextflow(_ sender: Any?) {
        showNotImplementedAlert("Nextflow Runner")
    }

    @objc func runSnakemake(_ sender: Any?) {
        showNotImplementedAlert("Snakemake Runner")
    }

    @objc func openWorkflowBuilder(_ sender: Any?) {
        showNotImplementedAlert("Workflow Builder")
    }

    private func showNotImplementedAlert(_ feature: String) {
        let alert = NSAlert()
        alert.messageText = "Feature Not Yet Implemented"
        alert.informativeText = "\(feature) will be available in a future release."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    // MARK: - HelpMenuActions

    @objc func openDocumentation(_ sender: Any?) {
        if let url = URL(string: "https://github.com/dho/lungfish-genome-browser#readme") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc func openReleaseNotes(_ sender: Any?) {
        if let url = URL(string: "https://github.com/dho/lungfish-genome-browser/releases") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc func reportIssue(_ sender: Any?) {
        if let url = URL(string: "https://github.com/dho/lungfish-genome-browser/issues/new") {
            NSWorkspace.shared.open(url)
        }
    }
}
