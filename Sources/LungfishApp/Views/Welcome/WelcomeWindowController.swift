// WelcomeWindowController.swift - Launch experience and project selection
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Owner: UI/UX Lead - HIG Expert (Role 2)

import AppKit
import SwiftUI
import LungfishCore
import LungfishWorkflow
import os.log

/// Logger for welcome window
private let logger = Logger(subsystem: LogSubsystem.app, category: "WelcomeWindow")

// MARK: - Recent Projects Manager

/// Manages the list of recently opened projects
@MainActor
public final class RecentProjectsManager: ObservableObject {
    /// Singleton instance
    public static let shared = RecentProjectsManager()

    /// Maximum number of recent projects to track
    private let maxRecentProjects = 10

    /// UserDefaults key for recent projects
    private let recentProjectsKey = "com.lungfish.recentProjects"

    /// Last used project key
    private let lastProjectKey = "com.lungfish.lastProject"

    /// Recent project entries
    @Published public private(set) var recentProjects: [RecentProject] = []

    private init() {
        loadRecentProjects()
    }

    /// Adds a project to the recent list
    public func addRecentProject(url: URL, name: String) {
        logger.info("Adding recent project: \(name, privacy: .public) at \(url.path, privacy: .public)")

        // Remove any existing entry for this URL
        recentProjects.removeAll { $0.url == url }

        // Add to front
        let entry = RecentProject(url: url, name: name, lastOpened: Date())
        recentProjects.insert(entry, at: 0)

        // Trim to max size
        if recentProjects.count > maxRecentProjects {
            recentProjects = Array(recentProjects.prefix(maxRecentProjects))
        }

        saveRecentProjects()
        saveLastProject(url: url)
    }

    /// Removes a project from the recent list
    public func removeRecentProject(at index: Int) {
        guard index >= 0 && index < recentProjects.count else { return }
        recentProjects.remove(at: index)
        saveRecentProjects()
    }

    /// Clears all recent projects
    public func clearRecentProjects() {
        recentProjects = []
        saveRecentProjects()
    }

    /// Gets the last opened project URL
    public var lastProjectURL: URL? {
        guard let path = UserDefaults.standard.string(forKey: lastProjectKey) else {
            return nil
        }
        let url = URL(fileURLWithPath: path)
        // Verify it still exists
        return FileManager.default.fileExists(atPath: url.path) ? url : nil
    }

    // MARK: - Private

    private func loadRecentProjects() {
        guard let data = UserDefaults.standard.data(forKey: recentProjectsKey),
              let projects = try? JSONDecoder().decode([RecentProject].self, from: data) else {
            recentProjects = []
            return
        }

        // Filter out projects that no longer exist
        recentProjects = projects.filter { project in
            FileManager.default.fileExists(atPath: project.url.path)
        }
    }

    private func saveRecentProjects() {
        guard let data = try? JSONEncoder().encode(recentProjects) else { return }
        UserDefaults.standard.set(data, forKey: recentProjectsKey)
    }

    private func saveLastProject(url: URL) {
        UserDefaults.standard.set(url.path, forKey: lastProjectKey)
    }
}

/// Represents a recently opened project
public struct RecentProject: Codable, Identifiable, Equatable {
    public var id: String { url.path }
    public let url: URL
    public let name: String
    public let lastOpened: Date

    /// Checks if the project still exists on disk
    public var exists: Bool {
        FileManager.default.fileExists(atPath: url.path)
    }

    /// Formatted last opened date
    public var lastOpenedFormatted: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: lastOpened, relativeTo: Date())
    }
}

// MARK: - Welcome View Model

@MainActor
final class WelcomeViewModel: ObservableObject {
    @Published var selectedAction: WelcomeAction?
    @Published var isLoading = false
    @Published var isInstallingRequiredSetup = false
    @Published private(set) var requiredSetupStatus: PluginPackStatus?
    @Published private(set) var optionalPackStatuses: [PluginPackStatus] = []
    @Published var setupErrorMessage: String?
    @Published var showingSetupDetails = false

    let recentProjects = RecentProjectsManager.shared
    private let statusProvider: any PluginPackStatusProviding

    var onCreateProject: ((URL) -> Void)?
    var onOpenProject: ((URL) -> Void)?
    var onOpenOptionalPack: ((String) -> Void)?
    var onDismiss: (() -> Void)?

    init(statusProvider: any PluginPackStatusProviding = PluginPackStatusService.shared) {
        self.statusProvider = statusProvider
    }

    var canLaunch: Bool {
        requiredSetupStatus?.state == .ready && !isInstallingRequiredSetup
    }

    func refreshSetup() async {
        let statuses = await statusProvider.visibleStatuses()
        requiredSetupStatus = statuses.first(where: { $0.pack.isRequiredBeforeLaunch })
        optionalPackStatuses = statuses.filter { !$0.pack.isRequiredBeforeLaunch }
    }

    func installRequiredSetup() {
        guard let pack = requiredSetupStatus?.pack else { return }
        isInstallingRequiredSetup = true
        setupErrorMessage = nil

        Task {
            defer { isInstallingRequiredSetup = false }
            do {
                try await statusProvider.install(
                    pack: pack,
                    reinstall: requiredSetupStatus?.state == .ready,
                    progress: nil
                )
                await refreshSetup()
            } catch {
                setupErrorMessage = error.localizedDescription
            }
        }
    }
}

enum WelcomeAction: String, Identifiable, CaseIterable {
    case createProject = "Create Project"
    case openProject = "Open Project"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .createProject: return "folder.badge.plus"
        case .openProject: return "folder"
        }
    }

    var description: String {
        switch self {
        case .createProject: return "Create a new project folder to organize your work"
        case .openProject: return "Open an existing Lungfish project"
        }
    }
}

// MARK: - Welcome View

struct WelcomeView: View {
    @ObservedObject var viewModel: WelcomeViewModel
    @State private var hoveredAction: WelcomeAction?

    var body: some View {
        HStack(spacing: 0) {
            // Left panel - branding and actions
            VStack(alignment: .leading, spacing: 0) {
                // App icon and title
                VStack(alignment: .leading, spacing: 8) {
                    Image(nsImage: Self.loadLogo())
                        .resizable()
                        .frame(width: 64, height: 64)

                    Text("Lungfish Genome Explorer")
                        .font(.system(size: 22, weight: .bold))

                    Text("Seeing the invisible. Informing action.")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 32)

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(WelcomeAction.allCases) { action in
                        ActionButton(
                            action: action,
                            isHovered: hoveredAction == action,
                            isEnabled: viewModel.canLaunch,
                            onTap: { performAction(action) }
                        )
                        .onHover { isHovered in
                            hoveredAction = isHovered ? action : nil
                        }
                    }
                }

                if let requiredStatus = viewModel.requiredSetupStatus {
                    RequiredSetupCard(
                        status: requiredStatus,
                        isInstalling: viewModel.isInstallingRequiredSetup,
                        showingDetails: $viewModel.showingSetupDetails,
                        onInstall: { viewModel.installRequiredSetup() }
                    )
                    .padding(.top, 20)
                }

                if !viewModel.optionalPackStatuses.isEmpty {
                    OptionalToolsCard(
                        statuses: viewModel.optionalPackStatuses,
                        onOpenPack: { viewModel.onOpenOptionalPack?($0) }
                    )
                    .padding(.top, 14)
                }

                Spacer()

                // Version info
                Text("Version \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.1")")
                    .font(.caption)
                    .foregroundColor(.secondary.opacity(0.6))
                    .padding(.top, 16)
            }
            .frame(width: 340)
            .padding(24)
            .background(Color(nsColor: .windowBackgroundColor))

            Divider()

            // Right panel - recent projects
            VStack(alignment: .leading, spacing: 0) {
                Text("Recent Projects")
                    .font(.headline)
                    .padding(.bottom, 12)

                if !viewModel.canLaunch {
                    Text("Finish required setup before opening a recent project.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 12)
                }

                if viewModel.recentProjects.recentProjects.isEmpty {
                    VStack(spacing: 12) {
                        Spacer()
                        Image(systemName: "folder.badge.questionmark")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary.opacity(0.6))
                        Text("No Recent Projects")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Create or open a project to get started")
                            .font(.subheadline)
                            .foregroundColor(.secondary.opacity(0.6))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 4) {
                            ForEach(viewModel.recentProjects.recentProjects) { project in
                                RecentProjectRow(
                                    project: project,
                                    isEnabled: viewModel.canLaunch
                                ) {
                                    viewModel.onOpenProject?(project.url)
                                }
                            }
                        }
                    }
                }
            }
            .frame(minWidth: 300)
            .padding(24)
            .background(Color(nsColor: .controlBackgroundColor))
        }
        .frame(width: 760, height: 520)
        .alert(
            "Setup Error",
            isPresented: Binding(
                get: { viewModel.setupErrorMessage != nil },
                set: { if !$0 { viewModel.setupErrorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {
                viewModel.setupErrorMessage = nil
            }
        } message: {
            Text(viewModel.setupErrorMessage ?? "")
        }
    }

    private static func loadLogo() -> NSImage {
        if let url = RuntimeResourceLocator.path("Images/about-logo.png", in: .app),
           let image = NSImage(contentsOf: url) {
            return image
        }
        return NSApplication.shared.applicationIconImage
    }

    private func performAction(_ action: WelcomeAction) {
        guard viewModel.canLaunch else { return }

        switch action {
        case .createProject:
            Task { @MainActor in
                await showCreateProjectPanel()
            }
        case .openProject:
            Task { @MainActor in
                await showOpenProjectPanel()
            }
        }
    }

    private func showCreateProjectPanel() async {
        let savePanel = NSSavePanel()
        savePanel.title = "Create New Project"
        savePanel.message = "Choose a location for your new Lungfish project"
        savePanel.nameFieldLabel = "Project Name:"
        savePanel.nameFieldStringValue = "My Genome Project"
        savePanel.canCreateDirectories = true
        savePanel.allowedContentTypes = [.folder]
        savePanel.isExtensionHidden = false

        guard let window = NSApp.keyWindow else { return }
        let response = await savePanel.beginSheetModal(for: window)
        if response == .OK, let url = savePanel.url {
            // Create the project directory with .lungfish extension
            let projectURL = url.deletingPathExtension().appendingPathExtension("lungfish")
            viewModel.onCreateProject?(projectURL)
        }
    }

    private func showOpenProjectPanel() async {
        let openPanel = NSOpenPanel()
        openPanel.title = "Open Project"
        openPanel.message = "Select a Lungfish project folder"
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false
        openPanel.canCreateDirectories = false

        guard let window = NSApp.keyWindow else { return }
        let response = await openPanel.beginSheetModal(for: window)
        if response == .OK, let url = openPanel.url {
            viewModel.onOpenProject?(url)
        }
    }
}

// MARK: - Action Button

struct ActionButton: View {
    let action: WelcomeAction
    let isHovered: Bool
    let isEnabled: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: action.icon)
                    .font(.system(size: 20))
                    .foregroundColor(.accentColor)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 2) {
                    Text(action.rawValue)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.primary)

                    Text(action.description)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isHovered ? Color.accentColor.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
    }
}

// MARK: - Setup Cards

private struct RequiredSetupCard: View {
    let status: PluginPackStatus
    let isInstalling: Bool
    @Binding var showingDetails: Bool
    let onInstall: () -> Void

    private var isReady: Bool {
        status.state == .ready
    }

    private var statusColor: Color {
        isReady ? .green : .red
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 8) {
                Circle()
                    .fill(statusColor)
                    .frame(width: 10, height: 10)

                Text("Needed Before You Begin")
                    .font(.headline)

                Spacer()

                if isInstalling {
                    ProgressView()
                        .controlSize(.small)
                }
            }

            Text("Lungfish needs a few tools installed before you can create or open a project.")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Button(isReady ? "Reinstall" : "Install") {
                onInstall()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
            .disabled(isInstalling)

            Button(showingDetails ? "Hide Setup Details" : "Show Setup Details") {
                showingDetails.toggle()
            }
            .buttonStyle(.plain)
            .font(.caption)
            .foregroundColor(.accentColor)

            if showingDetails {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(status.toolStatuses) { toolStatus in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(toolStatus.isReady ? Color.green : Color.red)
                                .frame(width: 8, height: 8)
                            Text(toolStatus.requirement.displayName)
                                .font(.caption)
                            Spacer()
                            Text(toolStatus.isReady ? "Ready" : "Needs install")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.top, 2)
            }
        }
        .padding(14)
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

private struct OptionalToolsCard: View {
    let statuses: [PluginPackStatus]
    let onOpenPack: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Optional Tools")
                .font(.headline)

            ForEach(statuses) { status in
                HStack(spacing: 8) {
                    Circle()
                        .fill(status.state == .ready ? Color.green : Color.red)
                        .frame(width: 8, height: 8)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(status.pack.name)
                            .font(.subheadline)
                        Text(status.pack.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }

                    Spacer()

                    Button("Open") {
                        onOpenPack(status.pack.id)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
        }
        .padding(14)
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Recent Project Row

struct RecentProjectRow: View {
    let project: RecentProject
    let isEnabled: Bool
    let onTap: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                Image(systemName: "folder.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.accentColor)

                VStack(alignment: .leading, spacing: 2) {
                    Text(project.name)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.primary)
                        .lineLimit(1)

                    Text(project.url.path)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary.opacity(0.6))
                        .lineLimit(1)
                        .truncationMode(.middle)
                }

                Spacer()

                Text(project.lastOpenedFormatted)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary.opacity(0.6))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isHovered ? Color.accentColor.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Welcome Window Controller

@MainActor
public final class WelcomeWindowController: NSWindowController {

    private var viewModel: WelcomeViewModel!

    /// Completion handler called when user makes a selection
    public var onProjectSelected: ((URL) -> Void)?
    public var onOptionalPackSelected: ((String) -> Void)?

    public init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 650, height: 400),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "Welcome to Lungfish Genome Explorer"
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.isRestorable = false
        window.center()

        super.init(window: window)

        setupContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContent() {
        viewModel = WelcomeViewModel()

        viewModel.onCreateProject = { [weak self] url in
            logger.info("Creating project at: \(url.path, privacy: .public)")
            self?.createProject(at: url)
        }

        viewModel.onOpenProject = { [weak self] url in
            logger.info("Opening project at: \(url.path, privacy: .public)")
            self?.openProject(at: url)
        }

        viewModel.onOpenOptionalPack = { [weak self] packID in
            logger.info("Opening optional tool pack: \(packID, privacy: .public)")
            self?.onOptionalPackSelected?(packID)
        }

        let welcomeView = WelcomeView(viewModel: viewModel)
        let hostingView = NSHostingView(rootView: welcomeView)
        window?.contentView = hostingView

        Task {
            await viewModel.refreshSetup()
        }
    }

    private func createProject(at url: URL) {
        do {
            // Create the project
            let project = try DocumentManager.shared.createProject(
                at: url,
                name: url.deletingPathExtension().lastPathComponent
            )

            // Add to recent projects
            RecentProjectsManager.shared.addRecentProject(
                url: project.url,
                name: project.name
            )

            // Close welcome window and notify
            window?.close()
            onProjectSelected?(project.url)

        } catch {
            let alert = NSAlert()
            alert.messageText = "Failed to Create Project"
            alert.informativeText = error.localizedDescription
            alert.alertStyle = .critical
            alert.addButton(withTitle: "OK")
            if let window = self.window {
                alert.beginSheetModal(for: window)
            }
        }
    }

    private func openProject(at url: URL) {
        do {
            // Open the project
            let project = try DocumentManager.shared.openProject(at: url)

            // Add to recent projects
            RecentProjectsManager.shared.addRecentProject(
                url: project.url,
                name: project.name
            )

            // Close welcome window and notify
            window?.close()
            onProjectSelected?(project.url)

        } catch {
            // If it's not a valid .lungfish project, treat it as a working directory
            let alert = NSAlert()
            alert.messageText = "Open as Working Directory?"
            alert.informativeText = "This folder is not a Lungfish project. Would you like to use it as a working directory for downloads and file operations?"
            alert.alertStyle = .informational
            alert.addButton(withTitle: "Use as Working Directory")
            alert.addButton(withTitle: "Cancel")

            if let window = self.window {
                Task { @MainActor [weak self] in
                    let response = await alert.beginSheetModal(for: window)
                    if response == .alertFirstButtonReturn {
                        // Set as working directory without creating a full project
                        self?.setWorkingDirectory(url)
                    }
                }
            }
        }
    }

    private func setWorkingDirectory(_ url: URL) {
        // Add to recent projects for easy access
        RecentProjectsManager.shared.addRecentProject(
            url: url,
            name: url.lastPathComponent
        )

        // Close welcome window and notify
        window?.close()
        onProjectSelected?(url)
    }

    /// Shows the welcome window
    public func show() {
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate()
    }
}
