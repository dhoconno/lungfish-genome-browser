// main.swift - Lungfish Genome Browser application entry point
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import LungfishApp

// Use MainActor to properly initialize the app delegate
@MainActor
func runApp() {
    let app = NSApplication.shared
    let delegate = AppDelegate()
    app.delegate = delegate

    // Activate the app (bring to front)
    app.setActivationPolicy(.regular)
    app.activate(ignoringOtherApps: true)

    // Run the main event loop
    app.run()
}

// Start the app on the main actor
DispatchQueue.main.async {
    runApp()
}

// Keep the main thread alive
dispatchMain()
