// DownloadCenter.swift - Shared download task tracking for toolbar and UI
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import SwiftUI

@MainActor
public final class DownloadCenter: ObservableObject {
    public struct Item: Identifiable, Sendable {
        public enum State: String, Sendable {
            case running
            case completed
            case failed
        }

        public let id: UUID
        public var title: String
        public var detail: String
        public var progress: Double
        public var state: State
        public var startedAt: Date
        public var finishedAt: Date?
        /// File URLs produced by this download (e.g. .lungfishref bundle paths).
        /// Set when the download completes via ``complete(id:detail:bundleURLs:)``.
        public var bundleURLs: [URL]

        public init(
            id: UUID = UUID(),
            title: String,
            detail: String,
            progress: Double,
            state: State,
            startedAt: Date = Date(),
            finishedAt: Date? = nil,
            bundleURLs: [URL] = []
        ) {
            self.id = id
            self.title = title
            self.detail = detail
            self.progress = progress
            self.state = state
            self.startedAt = startedAt
            self.finishedAt = finishedAt
            self.bundleURLs = bundleURLs
        }
    }

    public static let shared = DownloadCenter()

    @Published public private(set) var items: [Item] = []

    /// Called when a download completes with bundle URLs that need importing.
    /// The AppDelegate sets this once at startup to handle bundle import.
    public var onBundleReady: (([URL]) -> Void)?

    public var activeCount: Int {
        items.filter { $0.state == .running }.count
    }

    public func start(title: String, detail: String) -> UUID {
        let id = UUID()
        items.insert(
            Item(id: id, title: title, detail: detail, progress: 0, state: .running),
            at: 0
        )
        trimCompletedItemsIfNeeded()
        return id
    }

    public func update(id: UUID, progress: Double, detail: String) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].progress = max(0, min(1, progress))
        items[index].detail = detail
    }

    public func complete(id: UUID, detail: String) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].state = .completed
        items[index].progress = 1
        items[index].detail = detail
        items[index].finishedAt = Date()
        trimCompletedItemsIfNeeded()
    }

    /// Completes a download and delivers bundle URLs to the app for import.
    ///
    /// This is the primary mechanism for getting built bundles from background
    /// download tasks to the AppDelegate for import into the sidebar. It avoids
    /// fragile callback chains through sheet controllers that get deallocated.
    public func complete(id: UUID, detail: String, bundleURLs: [URL]) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].state = .completed
        items[index].progress = 1
        items[index].detail = detail
        items[index].bundleURLs = bundleURLs
        items[index].finishedAt = Date()
        trimCompletedItemsIfNeeded()

        if !bundleURLs.isEmpty {
            onBundleReady?(bundleURLs)
        }
    }

    public func fail(id: UUID, detail: String) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].state = .failed
        items[index].detail = detail
        items[index].finishedAt = Date()
        trimCompletedItemsIfNeeded()
    }

    public func clearCompleted() {
        items.removeAll { $0.state != .running }
    }

    private func trimCompletedItemsIfNeeded() {
        let keepLimit = 20
        let running = items.filter { $0.state == .running }
        let finished = items
            .filter { $0.state != .running }
            .sorted { ($0.finishedAt ?? .distantPast) > ($1.finishedAt ?? .distantPast) }

        items = running + Array(finished.prefix(max(0, keepLimit - running.count)))
    }
}
