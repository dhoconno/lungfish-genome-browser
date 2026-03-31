// AssemblyConfigurationViewController.swift - Sheet presenter for SPAdes assembly wizard
// Copyright (c) 2025 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import SwiftUI
import os.log
import LungfishCore
import LungfishWorkflow

/// Logger for assembly sheet presenter operations.
private let logger = Logger(subsystem: LogSubsystem.app, category: "AssemblySheetPresenter")

// MARK: - AssemblySheetPresenter

/// Presents the SPAdes assembly wizard as an `NSPanel` sheet.
///
/// The presenter creates an ``AssemblyWizardSheet`` SwiftUI view, wraps it
/// in an `NSHostingController`, and attaches it as a sheet to the given
/// parent window. When the user clicks Run, the config is delivered via the
/// `onRun` callback and the sheet is dismissed automatically.
///
/// Assembly execution is handled by ``AssemblyRunner`` which registers
/// with ``OperationCenter`` so the task survives sheet dismissal.
///
/// ## Usage
///
/// ```swift
/// AssemblySheetPresenter.present(
///     from: window,
///     inputFiles: fastqURLs,
///     outputDirectory: assembliesDir,
///     onRun: { config in
///         AssemblyRunner.run(config: config)
///     }
/// )
/// ```
@MainActor
public struct AssemblySheetPresenter {

    /// Presents the SPAdes assembly configuration sheet.
    ///
    /// - Parameters:
    ///   - window: The parent window to attach the sheet to.
    ///   - inputFiles: FASTQ file URLs to assemble.
    ///   - outputDirectory: Directory for assembly output (e.g. project's Assemblies/).
    ///   - onRun: Called with the assembled ``SPAdesAssemblyConfig`` when the user clicks Run.
    ///            If nil, defaults to ``AssemblyRunner/run(config:)``.
    ///   - onCancel: Called when the user cancels.
    public static func present(
        from window: NSWindow,
        inputFiles: [URL],
        outputDirectory: URL?,
        onRun: ((SPAdesAssemblyConfig) -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        let wizardPanel = NSPanel(
            contentRect: .zero,
            styleMask: [.titled],
            backing: .buffered,
            defer: true
        )
        wizardPanel.title = "SPAdes Assembly"
        wizardPanel.isReleasedWhenClosed = false

        let sheet = AssemblyWizardSheet(
            inputFiles: inputFiles,
            outputDirectory: outputDirectory,
            onRun: { config in
                window.endSheet(wizardPanel)
                if let onRun {
                    onRun(config)
                } else {
                    AssemblyRunner.run(config: config)
                }
            },
            onCancel: {
                window.endSheet(wizardPanel)
                onCancel?()
            }
        )

        let hostingController = NSHostingController(rootView: sheet)
        wizardPanel.contentViewController = hostingController
        wizardPanel.setContentSize(NSSize(width: 520, height: 520))

        window.beginSheet(wizardPanel)

        logger.info("Assembly wizard presented with \(inputFiles.count) input files")
    }
}
