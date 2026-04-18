import AppKit
import SwiftUI

@MainActor
struct FASTQOperationsDialogPresenter {
    static func present(
        from window: NSWindow,
        selectedInputURLs: [URL],
        initialCategory: FASTQOperationCategoryID,
        onRun: ((FASTQOperationDialogState) -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        let state = FASTQOperationDialogState(
            initialCategory: initialCategory,
            selectedInputURLs: selectedInputURLs
        )

        let panel = NSPanel(
            contentRect: .zero,
            styleMask: [.titled],
            backing: .buffered,
            defer: true
        )
        panel.title = initialCategory.title
        panel.isReleasedWhenClosed = false

        let dialog = FASTQOperationDialog(
            state: state,
            onCancel: {
                window.endSheet(panel)
                onCancel?()
            },
            onRun: {
                window.endSheet(panel)
                onRun?(state)
            }
        )

        let hostingController = NSHostingController(rootView: dialog)
        panel.contentViewController = hostingController
        panel.setContentSize(NSSize(width: 980, height: 700))
        window.beginSheet(panel)
    }
}
