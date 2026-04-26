import AppKit
import LungfishWorkflow

@MainActor
final class NFCoreWorkflowDialogController: NSWindowController, NSTableViewDataSource, NSTableViewDelegate {
    private let model: NFCoreWorkflowDialogModel
    private let executionService: NFCoreWorkflowExecutionService
    private let tableView = NSTableView()
    private let workflowPopup = NSPopUpButton()
    private let executorPopup = NSPopUpButton()
    private let versionField = NSTextField()
    private let statusLabel = NSTextField(labelWithString: "")
    private let runButton = NSButton(title: "Run", target: nil, action: nil)

    init(
        projectURL: URL?,
        executionService: NFCoreWorkflowExecutionService = NFCoreWorkflowExecutionService()
    ) {
        self.model = NFCoreWorkflowDialogModel(projectURL: projectURL)
        self.executionService = executionService

        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 760, height: 520),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        panel.title = "nf-core Workflows"
        panel.setAccessibilityIdentifier(NFCoreWorkflowAccessibilityID.window)
        panel.isReleasedWhenClosed = false
        super.init(window: panel)
        panel.contentView = buildContentView()
        panel.center()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        model.inputCandidates.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard row < model.inputCandidates.count else { return nil }
        let candidate = model.inputCandidates[row]
        let identifier = tableColumn?.identifier.rawValue ?? "input"

        if identifier == "selected" {
            let button = NSButton(checkboxWithTitle: "", target: self, action: #selector(toggleInput(_:)))
            button.tag = row
            button.state = model.isInputSelected(candidate.url) ? .on : .off
            button.setAccessibilityIdentifier("nf-core-input-selected-\(row)")
            return button
        }

        let text = NSTextField(labelWithString: candidate.relativePath)
        text.lineBreakMode = .byTruncatingMiddle
        text.setAccessibilityIdentifier("nf-core-input-row-\(row)")
        return text
    }

    private func buildContentView() -> NSView {
        let root = NSView()

        let title = NSTextField(labelWithString: "Run nf-core Workflow")
        title.font = .systemFont(ofSize: 18, weight: .semibold)

        workflowPopup.addItems(withTitles: model.availableWorkflows.map(\.fullName))
        workflowPopup.target = self
        workflowPopup.action = #selector(workflowChanged(_:))
        workflowPopup.setAccessibilityIdentifier(NFCoreWorkflowAccessibilityID.workflowPicker)

        executorPopup.addItems(withTitles: [NFCoreExecutor.docker.rawValue, NFCoreExecutor.conda.rawValue, NFCoreExecutor.local.rawValue])
        executorPopup.selectItem(withTitle: model.executor.rawValue)
        executorPopup.target = self
        executorPopup.action = #selector(executorChanged(_:))
        executorPopup.setAccessibilityIdentifier(NFCoreWorkflowAccessibilityID.executorPicker)

        versionField.placeholderString = "Optional version/tag"
        versionField.setAccessibilityIdentifier(NFCoreWorkflowAccessibilityID.versionField)

        let selectAll = NSButton(title: "Select All", target: self, action: #selector(selectAllInputs(_:)))
        selectAll.setAccessibilityIdentifier(NFCoreWorkflowAccessibilityID.selectAllButton)
        let clear = NSButton(title: "Clear", target: self, action: #selector(clearInputs(_:)))
        clear.setAccessibilityIdentifier(NFCoreWorkflowAccessibilityID.clearButton)

        tableView.addTableColumn(NSTableColumn(identifier: NSUserInterfaceItemIdentifier("selected")))
        tableView.tableColumns[0].width = 42
        tableView.addTableColumn(NSTableColumn(identifier: NSUserInterfaceItemIdentifier("input")))
        tableView.tableColumns[1].title = "Project Inputs"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.headerView = nil
        tableView.setAccessibilityIdentifier(NFCoreWorkflowAccessibilityID.inputTable)

        let scrollView = NSScrollView()
        scrollView.documentView = tableView
        scrollView.hasVerticalScroller = true
        scrollView.borderType = .bezelBorder

        statusLabel.textColor = .secondaryLabelColor
        statusLabel.setAccessibilityIdentifier(NFCoreWorkflowAccessibilityID.statusLabel)
        updateStatus()

        runButton.target = self
        runButton.action = #selector(runWorkflow(_:))
        runButton.keyEquivalent = "\r"
        runButton.bezelStyle = .rounded
        runButton.setAccessibilityIdentifier(NFCoreWorkflowAccessibilityID.runButton)

        let cancel = NSButton(title: "Cancel", target: self, action: #selector(cancel(_:)))
        cancel.setAccessibilityIdentifier(NFCoreWorkflowAccessibilityID.cancelButton)

        let grid = NSGridView(views: [
            [NSTextField(labelWithString: "Workflow"), workflowPopup],
            [NSTextField(labelWithString: "Executor"), executorPopup],
            [NSTextField(labelWithString: "Version"), versionField],
        ])
        grid.column(at: 0).xPlacement = .trailing
        grid.column(at: 1).width = 560
        grid.rowSpacing = 8

        let inputButtons = NSStackView(views: [selectAll, clear])
        inputButtons.orientation = .horizontal
        inputButtons.spacing = 8

        let footer = NSStackView(views: [statusLabel, NSView(), cancel, runButton])
        footer.orientation = .horizontal
        footer.spacing = 8
        footer.setHuggingPriority(.defaultLow, for: .horizontal)

        let stack = NSStackView(views: [title, grid, inputButtons, scrollView, footer])
        stack.orientation = .vertical
        stack.alignment = .leading
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        root.addSubview(stack)

        for view in [title, grid, inputButtons, scrollView, footer] {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        }

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: root.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: root.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: root.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: root.bottomAnchor, constant: -20),
            scrollView.heightAnchor.constraint(equalToConstant: 280),
        ])

        return root
    }

    @objc private func workflowChanged(_ sender: NSPopUpButton) {
        if let title = sender.selectedItem?.title {
            model.selectWorkflow(named: title)
        }
        updateStatus()
    }

    @objc private func executorChanged(_ sender: NSPopUpButton) {
        if let raw = sender.selectedItem?.title,
           let executor = NFCoreExecutor(rawValue: raw) {
            model.executor = executor
        }
        updateStatus()
    }

    @objc private func toggleInput(_ sender: NSButton) {
        guard sender.tag < model.inputCandidates.count else { return }
        model.setInputSelected(model.inputCandidates[sender.tag].url, selected: sender.state == .on)
        updateStatus()
    }

    @objc private func selectAllInputs(_ sender: NSButton) {
        model.selectAllInputs()
        tableView.reloadData()
        updateStatus()
    }

    @objc private func clearInputs(_ sender: NSButton) {
        model.clearInputSelection()
        tableView.reloadData()
        updateStatus()
    }

    @objc private func cancel(_ sender: NSButton) {
        close()
    }

    @objc private func runWorkflow(_ sender: NSButton) {
        model.version = versionField.stringValue
        do {
            let request = try model.makeRequest()
            guard let bundleRoot = model.bundleRootURL else { return }
            runButton.isEnabled = false
            statusLabel.stringValue = "Starting \(request.workflow.fullName)..."
            Task { [executionService] in
                do {
                    _ = try await executionService.run(request, bundleRoot: bundleRoot)
                    AppUITestConfiguration.current.appendEvent("nfcore.workflow.completed \(request.workflow.fullName)")
                } catch {
                    AppUITestConfiguration.current.appendEvent("nfcore.workflow.failed \(request.workflow.fullName) error=\(error.localizedDescription)")
                }
            }
            close()
        } catch NFCoreWorkflowDialogModel.ValidationError.missingInputs {
            statusLabel.stringValue = "Select at least one project input."
        } catch {
            statusLabel.stringValue = error.localizedDescription
        }
    }

    private func updateStatus() {
        if model.inputCandidates.isEmpty {
            statusLabel.stringValue = "No supported project inputs found."
            runButton.isEnabled = false
        } else {
            statusLabel.stringValue = "\(model.inputCandidates.count) supported project input(s) available."
            runButton.isEnabled = true
        }
    }
}
