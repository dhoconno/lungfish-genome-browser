// ReferenceBundleViewportController.swift - Shared viewport for reference bundles and mapping results
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import AppKit
import LungfishCore
import LungfishIO
import LungfishWorkflow

@MainActor
final class ReferenceSequenceTableView: BatchTableView<BundleBrowserSequenceSummary> {
    override var columnSpecs: [BatchColumnSpec] {
        [
            .init(identifier: .init("sequence"), title: "Sequence", width: 220, minWidth: 140, defaultAscending: true),
            .init(identifier: .init("length"), title: "Length", width: 100, minWidth: 80, defaultAscending: false),
            .init(identifier: .init("role"), title: "Role", width: 100, minWidth: 80, defaultAscending: true),
        ]
    }

    override var searchPlaceholder: String { "Filter sequences\u{2026}" }
    override var searchAccessibilityIdentifier: String? { "reference-bundle-sequence-search" }
    override var searchAccessibilityLabel: String? { "Filter reference sequences" }
    override var tableAccessibilityIdentifier: String? { "reference-bundle-sequence-table" }
    override var tableAccessibilityLabel: String? { "Reference sequence table" }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        finishSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        finishSetup()
    }

    private func finishSetup() {
        tableView.allowsMultipleSelection = false
        tableView.sortDescriptors = [
            NSSortDescriptor(key: "sequence", ascending: true),
        ]
    }

    override func cellContent(
        for column: NSUserInterfaceItemIdentifier,
        row: BundleBrowserSequenceSummary
    ) -> (text: String, alignment: NSTextAlignment, font: NSFont?) {
        switch column.rawValue {
        case "sequence":
            return (row.name, .left, .systemFont(ofSize: 12))
        case "length":
            return (row.length.formatted(), .right, numericFont)
        case "role":
            return (roleDescription(for: row), .left, .systemFont(ofSize: 12))
        default:
            return ("", .left, nil)
        }
    }

    override func columnValue(for columnId: String, row: BundleBrowserSequenceSummary) -> String {
        switch columnId {
        case "sequence":
            return row.name
        case "length":
            return "\(row.length)"
        case "role":
            return roleDescription(for: row)
        default:
            return super.columnValue(for: columnId, row: row)
        }
    }

    override func rowMatchesFilter(_ row: BundleBrowserSequenceSummary, filterText: String) -> Bool {
        let query = filterText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return true }

        let haystack = [
            row.name,
            row.displayDescription ?? "",
            row.length.formatted(),
            row.aliases.joined(separator: " "),
            roleDescription(for: row),
        ]

        return haystack.contains { $0.localizedCaseInsensitiveContains(query) }
    }

    override func compareRows(
        _ lhs: BundleBrowserSequenceSummary,
        _ rhs: BundleBrowserSequenceSummary,
        by key: String,
        ascending: Bool
    ) -> Bool {
        let comparison: ComparisonResult
        switch key {
        case "sequence":
            comparison = lhs.name.localizedCaseInsensitiveCompare(rhs.name)
        case "length":
            comparison = compare(lhs.length, rhs.length)
        case "role":
            comparison = roleDescription(for: lhs).localizedCaseInsensitiveCompare(roleDescription(for: rhs))
        default:
            comparison = lhs.name.localizedCaseInsensitiveCompare(rhs.name)
        }

        if comparison == .orderedSame {
            let fallback = lhs.name.localizedCaseInsensitiveCompare(rhs.name)
            if fallback == .orderedSame {
                return false
            }
            return ascending ? fallback == .orderedAscending : fallback == .orderedDescending
        }

        return ascending ? comparison == .orderedAscending : comparison == .orderedDescending
    }

    private var numericFont: NSFont {
        .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
    }

    private func roleDescription(for row: BundleBrowserSequenceSummary) -> String {
        if row.isMitochondrial {
            return "Mitochondrial"
        }
        return row.isPrimary ? "Primary" : "Alternate"
    }

    private func compare<T: Comparable>(_ lhs: T, _ rhs: T) -> ComparisonResult {
        if lhs < rhs {
            return .orderedAscending
        }
        if lhs > rhs {
            return .orderedDescending
        }
        return .orderedSame
    }
}

@MainActor
public class ReferenceBundleViewportController: NSViewController {
    enum PresentationMode: Equatable {
        case listDetail
        case focusedDetail
    }

    private(set) var currentInput: ReferenceBundleViewportInput?
    private(set) var presentationMode: PresentationMode = .listDetail
    private(set) var currentResult: MappingResult?
    private var currentResultDirectoryURL: URL?
    private var loadedViewerBundleURL: URL?
    private var sequenceRows: [BundleBrowserSequenceSummary] = []

    var onEmbeddedReferenceBundleLoaded: ((ReferenceBundle) -> Void)?

    private let embeddedViewerController = ViewerViewController()
    private let splitCoordinator = TwoPaneTrackedSplitCoordinator()

    private let summaryBar: NSView = {
        let bar = NSView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()

    private let summaryLabel: NSTextField = {
        let label = NSTextField(labelWithString: "Reference Bundle")
        label.font = .systemFont(ofSize: NSFont.smallSystemFontSize, weight: .semibold)
        label.textColor = .secondaryLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setAccessibilityIdentifier("reference-bundle-summary-label")
        return label
    }()

    private let splitView = TrackedDividerSplitView()
    private let listContainer = NSView()
    private let detailContainer = NSView()
    private let contigTableView = MappingContigTableView()
    private let sequenceTableView = ReferenceSequenceTableView()

    private let detailPlaceholderLabel: NSTextField = {
        let label = NSTextField(labelWithString: "Select a sequence to inspect.")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alignment = .center
        label.textColor = .secondaryLabelColor
        label.maximumNumberOfLines = 0
        label.setAccessibilityIdentifier("reference-bundle-detail-placeholder")
        return label
    }()

    public override func loadView() {
        let root = NSView()
        root.translatesAutoresizingMaskIntoConstraints = false
        root.setAccessibilityElement(true)
        root.setAccessibilityRole(.group)
        root.setAccessibilityLabel("Reference bundle viewport")
        root.setAccessibilityIdentifier("reference-bundle-view")
        view = root

        setupSummaryBar()
        setupContainers()
        setupSplitView()
        layoutSubviews()
        wireCallbacks()
        applyLayoutPreference()
    }

    public override func viewDidLayout() {
        super.viewDidLayout()
        guard splitView.arrangedSubviews.count > 1 else { return }
        guard splitCoordinator.needsInitialSplitValidation else { return }
        scheduleInitialSplitValidationIfNeeded()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupSummaryBar() {
        summaryBar.addSubview(summaryLabel)
        NSLayoutConstraint.activate([
            summaryLabel.leadingAnchor.constraint(equalTo: summaryBar.leadingAnchor, constant: 12),
            summaryLabel.trailingAnchor.constraint(lessThanOrEqualTo: summaryBar.trailingAnchor, constant: -12),
            summaryLabel.centerYAnchor.constraint(equalTo: summaryBar.centerYAnchor),
            summaryBar.heightAnchor.constraint(equalToConstant: 32),
        ])
    }

    private func setupContainers() {
        [summaryBar, splitView, listContainer, detailContainer, contigTableView, sequenceTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        embeddedViewerController.publishesGlobalViewportNotifications = false

        listContainer.addSubview(contigTableView)
        listContainer.addSubview(sequenceTableView)
        detailContainer.addSubview(detailPlaceholderLabel)

        addChild(embeddedViewerController)
        let detailView = embeddedViewerController.view
        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailContainer.addSubview(detailView, positioned: .below, relativeTo: detailPlaceholderLabel)

        NSLayoutConstraint.activate([
            contigTableView.topAnchor.constraint(equalTo: listContainer.topAnchor),
            contigTableView.leadingAnchor.constraint(equalTo: listContainer.leadingAnchor),
            contigTableView.trailingAnchor.constraint(equalTo: listContainer.trailingAnchor),
            contigTableView.bottomAnchor.constraint(equalTo: listContainer.bottomAnchor),

            sequenceTableView.topAnchor.constraint(equalTo: listContainer.topAnchor),
            sequenceTableView.leadingAnchor.constraint(equalTo: listContainer.leadingAnchor),
            sequenceTableView.trailingAnchor.constraint(equalTo: listContainer.trailingAnchor),
            sequenceTableView.bottomAnchor.constraint(equalTo: listContainer.bottomAnchor),

            detailView.topAnchor.constraint(equalTo: detailContainer.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: detailContainer.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: detailContainer.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: detailContainer.bottomAnchor),

            detailPlaceholderLabel.centerXAnchor.constraint(equalTo: detailContainer.centerXAnchor),
            detailPlaceholderLabel.centerYAnchor.constraint(equalTo: detailContainer.centerYAnchor),
            detailPlaceholderLabel.leadingAnchor.constraint(greaterThanOrEqualTo: detailContainer.leadingAnchor, constant: 24),
            detailPlaceholderLabel.trailingAnchor.constraint(lessThanOrEqualTo: detailContainer.trailingAnchor, constant: -24),
        ])
    }

    private func setupSplitView() {
        splitView.translatesAutoresizingMaskIntoConstraints = false
        splitView.dividerStyle = .thin
        splitView.delegate = self
        splitView.isVertical = true
        splitView.addArrangedSubview(listContainer)
        splitView.addArrangedSubview(detailContainer)
        splitView.setHoldingPriority(.defaultLow, forSubviewAt: 0)
        splitView.setHoldingPriority(.defaultLow, forSubviewAt: 1)
    }

    private func layoutSubviews() {
        view.addSubview(summaryBar)
        view.addSubview(splitView)

        NSLayoutConstraint.activate([
            summaryBar.topAnchor.constraint(equalTo: view.topAnchor),
            summaryBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            splitView.topAnchor.constraint(equalTo: summaryBar.bottomAnchor),
            splitView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            splitView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            splitView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func wireCallbacks() {
        contigTableView.onRowSelected = { [weak self] row in
            self?.displaySelectedContig(row)
        }
        contigTableView.onSelectionCleared = { [weak self] in
            self?.showDetailPlaceholder("Select a mapped contig to inspect mapped reads.")
        }

        sequenceTableView.onRowSelected = { [weak self] row in
            self?.displaySelectedSequence(row)
        }
        sequenceTableView.onSelectionCleared = { [weak self] in
            self?.showDetailPlaceholder("Select a sequence to inspect.")
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLayoutPreferenceChanged),
            name: .mappingLayoutSwapRequested,
            object: nil
        )
    }

    @objc private func handleLayoutPreferenceChanged() {
        applyLayoutPreference()
    }

    private func defaultLeadingFraction(for layout: MappingPanelLayout) -> CGFloat {
        switch layout {
        case .detailLeading:
            return 0.6
        case .listLeading, .stacked:
            return 0.4
        }
    }

    private func minimumExtents(for layout: MappingPanelLayout) -> (leading: CGFloat, trailing: CGFloat) {
        switch layout {
        case .detailLeading:
            return (320, 320)
        case .listLeading, .stacked:
            return (320, 320)
        }
    }

    private func applyLayoutPreference() {
        guard splitView.arrangedSubviews.count > 1 else { return }
        let layout = MappingPanelLayout.current()
        let detailLeading = layout == .detailLeading
        splitCoordinator.applyLayoutPreference(
            to: splitView,
            desiredIsVertical: layout != .stacked,
            desiredFirstPane: detailLeading ? detailContainer : listContainer,
            desiredSecondPane: detailLeading ? listContainer : detailContainer,
            defaultLeadingFraction: defaultLeadingFraction(for: layout),
            minimumExtents: minimumExtents(for: layout),
            isViewInWindow: view.window != nil
        )
    }

    private func scheduleInitialSplitValidationIfNeeded() {
        splitCoordinator.scheduleInitialSplitValidationIfNeeded(
            ownerView: view,
            splitView: splitView,
            minimumExtents: { [weak self] in
                self?.minimumExtents(for: MappingPanelLayout.current()) ?? (320, 320)
            },
            defaultLeadingFraction: { [weak self] in
                self?.defaultLeadingFraction(for: MappingPanelLayout.current()) ?? 0.4
            }
        )
    }

    private func updateSummaryBar() {
        guard let result = currentResult else {
            summaryLabel.stringValue = currentInput?.documentTitle ?? "Reference Bundle"
            return
        }
        let pct = result.totalReads > 0
            ? String(format: "%.1f%%", Double(result.mappedReads) / Double(result.totalReads) * 100)
            : "—"
        summaryLabel.stringValue = "\(result.mapper.displayName) Mapping — \(result.mappedReads.formatted()) / \(result.totalReads.formatted()) reads mapped (\(pct))"
    }

    func configure(input: ReferenceBundleViewportInput) throws {
        currentInput = input
        currentResult = input.mappingResult
        currentResultDirectoryURL = input.mappingResultDirectoryURL
        loadedViewerBundleURL = nil
        presentationMode = .listDetail
        updateSummaryBar()

        switch input.kind {
        case .mappingResult:
            configureMappingRows(input.mappingResult)
        case .directBundle:
            try configureDirectBundleRows(input: input)
        }

        applyLayoutPreference()
    }

    private func configureMappingRows(_ result: MappingResult?) {
        sequenceRows = []
        sequenceTableView.configure(rows: [])
        sequenceTableView.isHidden = true
        contigTableView.isHidden = false
        contigTableView.configure(rows: result?.contigs ?? [])
        refreshSelection()
    }

    private func configureDirectBundleRows(input: ReferenceBundleViewportInput) throws {
        contigTableView.configure(rows: [])
        contigTableView.isHidden = true
        sequenceTableView.isHidden = false

        guard let bundleURL = input.renderedBundleURL else {
            sequenceRows = []
            sequenceTableView.configure(rows: [])
            showDetailPlaceholder("Reference bundle viewer unavailable for this mapping result.")
            return
        }

        let manifest: BundleManifest
        if let inputManifest = input.manifest {
            manifest = inputManifest
        } else {
            manifest = try BundleManifest.load(from: bundleURL)
        }
        let loadResult = try BundleBrowserLoader().load(bundleURL: bundleURL, manifest: manifest)
        sequenceRows = loadResult.summary.sequences
        sequenceTableView.configure(rows: sequenceRows)
        refreshSequenceSelection()
    }

    private func refreshSelection() {
        guard !contigTableView.displayedRows.isEmpty else {
            if let viewerBundleURL = currentInput?.renderedBundleURL {
                do {
                    try loadViewerBundleIfNeeded(from: viewerBundleURL, sequenceName: "")
                    showDetailViewer()
                } catch {
                    showDetailPlaceholder("Unable to load the reference mapping viewer.")
                }
            } else {
                showDetailPlaceholder("Reference bundle viewer unavailable for this mapping result.")
            }
            return
        }

        contigTableView.tableView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
        displaySelectedContig(contigTableView.displayedRows[0])
    }

    private func refreshSequenceSelection() {
        guard !sequenceTableView.displayedRows.isEmpty else {
            showDetailPlaceholder("No sequences are available for this reference bundle.")
            return
        }

        sequenceTableView.tableView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
        displaySelectedSequence(sequenceTableView.displayedRows[0])
    }

    private func loadViewerBundleIfNeeded(from bundleURL: URL, sequenceName: String) throws {
        let standardized = bundleURL.standardizedFileURL
        if loadedViewerBundleURL == standardized {
            return
        }

        embeddedViewerController.clearViewport(statusMessage: "Loading reference viewer...")
        embeddedViewerController.annotationSearchIndex = nil
        try embeddedViewerController.displayBundle(
            at: standardized,
            mode: .sequence(name: sequenceName, restoreViewState: false)
        )
        rebuildEmbeddedAnnotationSearchIndex()
        loadedViewerBundleURL = standardized
    }

    @objc(reloadViewerBundleForInspectorChangesAndReturnError:)
    func reloadViewerBundleForInspectorChanges() throws {
        guard let input = currentInput else { return }
        loadedViewerBundleURL = nil
        try configure(input: input)
    }

    var filteredAlignmentServiceTarget: AlignmentFilterTarget? {
        if let resultDirectoryURL = currentResultDirectoryURL?.standardizedFileURL {
            return .mappingResult(resultDirectoryURL)
        }

        if let result = currentResult {
            return .mappingResult(result.bamURL.deletingLastPathComponent().standardizedFileURL)
        }
        return nil
    }

    func applyEmbeddedReadDisplaySettings(_ userInfo: [AnyHashable: Any]) {
        embeddedViewerController.applyReadDisplaySettings(userInfo)
    }

    func notifyEmbeddedReferenceBundleLoadedIfAvailable() {
        if let bundle = embeddedViewerController.viewerView.currentReferenceBundle {
            onEmbeddedReferenceBundleLoaded?(bundle)
        }
    }

    func buildConsensusExportPayload() async throws -> (records: [String], suggestedName: String) {
        let request = try buildConsensusExportRequest()
        let consensus = try await embeddedViewerController.fetchMappingConsensusSequence(request)
        let record = ">\(request.recordName)\n\(consensus)\n"
        return ([record], request.suggestedName)
    }

    // TODO(2026-04-22): Add visible-viewport consensus export.
    // TODO(2026-04-22): Add selected-annotation consensus export.
    // TODO(2026-04-22): Add selected-region consensus export.
    func buildConsensusExportRequest() throws -> MappingConsensusExportRequest {
        guard let result = currentResult else {
            throw NSError(
                domain: "Lungfish",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "No mapping result loaded"]
            )
        }

        let fallbackChromosome = embeddedViewerController.currentBundleDataProvider?
            .chromosomeInfo(named: embeddedViewerController.referenceFrame?.chromosome ?? "")

        return try MappingConsensusExportRequestBuilder.build(
            sampleName: result.bamURL.deletingPathExtension().deletingPathExtension().lastPathComponent,
            selectedContig: currentSelectedContig(),
            fallbackChromosome: fallbackChromosome,
            consensusMode: embeddedViewerController.viewerView.consensusModeSetting,
            consensusMinDepth: embeddedViewerController.viewerView.consensusMinDepthSetting,
            consensusMinMapQ: max(
                embeddedViewerController.viewerView.minMapQSetting,
                embeddedViewerController.viewerView.consensusMinMapQSetting
            ),
            consensusMinBaseQ: embeddedViewerController.viewerView.consensusMinBaseQSetting,
            excludeFlags: embeddedViewerController.viewerView.excludeFlagsSetting,
            useAmbiguity: embeddedViewerController.viewerView.consensusUseAmbiguitySetting
        )
    }

    private func rebuildEmbeddedAnnotationSearchIndex() {
        guard let bundle = embeddedViewerController.viewerView.currentReferenceBundle else {
            embeddedViewerController.annotationSearchIndex = nil
            return
        }

        let index = AnnotationSearchIndex()
        let chromosomes = embeddedViewerController.currentBundleDataProvider?.chromosomes ?? []
        index.buildIndex(bundle: bundle, chromosomes: chromosomes)
        embeddedViewerController.annotationSearchIndex = index
        onEmbeddedReferenceBundleLoaded?(bundle)
    }

    private func displaySelectedContig(_ selectedContig: MappingContigSummary) {
        guard currentResult != nil else {
            showDetailPlaceholder("No mapping result loaded.")
            return
        }

        guard let viewerBundleURL = currentInput?.renderedBundleURL else {
            showDetailPlaceholder("Reference bundle viewer unavailable for this mapping result.")
            return
        }

        do {
            try loadViewerBundleIfNeeded(
                from: viewerBundleURL,
                sequenceName: selectedContig.contigName
            )
            guard let chromosome = embeddedViewerController.currentBundleDataProvider?.chromosomeInfo(named: selectedContig.contigName) else {
                showDetailPlaceholder("Selected contig is not present in the reference bundle.")
                return
            }

            showDetailViewer()
            embeddedViewerController.navigateToChromosomeAndPosition(
                chromosome: chromosome.name,
                chromosomeLength: Int(chromosome.length),
                start: 0,
                end: max(1, Int(chromosome.length))
            )
        } catch {
            showDetailPlaceholder("Unable to load the reference mapping viewer.")
        }
    }

    private func displaySelectedSequence(_ selectedSequence: BundleBrowserSequenceSummary) {
        guard let bundleURL = currentInput?.renderedBundleURL else {
            showDetailPlaceholder("Reference bundle viewer unavailable for this mapping result.")
            return
        }

        do {
            try loadViewerBundleIfNeeded(from: bundleURL, sequenceName: selectedSequence.name)
            guard let chromosome = embeddedViewerController.currentBundleDataProvider?.chromosomeInfo(named: selectedSequence.name) else {
                showDetailPlaceholder("Selected sequence is not present in the reference bundle.")
                return
            }

            showDetailViewer()
            embeddedViewerController.navigateToChromosomeAndPosition(
                chromosome: chromosome.name,
                chromosomeLength: Int(chromosome.length),
                start: 0,
                end: max(1, Int(chromosome.length))
            )
        } catch {
            showDetailPlaceholder("Unable to load sequence detail for \(selectedSequence.name).")
        }
    }

    private func showDetailViewer() {
        embeddedViewerController.view.isHidden = false
        detailPlaceholderLabel.isHidden = true
    }

    private func showDetailPlaceholder(_ message: String) {
        detailPlaceholderLabel.stringValue = message
        detailPlaceholderLabel.isHidden = false
        embeddedViewerController.view.isHidden = true
    }

    private func currentSelectedContig() -> MappingContigSummary? {
        let selectedRow = contigTableView.tableView.selectedRow
        guard selectedRow >= 0, selectedRow < contigTableView.displayedRows.count else { return nil }
        return contigTableView.displayedRows[selectedRow]
    }

    private func currentSelectedSequence() -> BundleBrowserSequenceSummary? {
        let selectedRow = sequenceTableView.tableView.selectedRow
        guard selectedRow >= 0, selectedRow < sequenceTableView.displayedRows.count else { return nil }
        return sequenceTableView.displayedRows[selectedRow]
    }
}

extension ReferenceBundleViewportController: ResultViewportController {
    public typealias ResultType = MappingResult

    public static var resultTypeName: String { "Mapping Results" }

    public func configure(result: MappingResult) {
        configure(result: result, resultDirectoryURL: nil)
    }

    public func configure(result: MappingResult, resultDirectoryURL: URL?) {
        let input = ReferenceBundleViewportInput.mappingResult(
            result: result,
            resultDirectoryURL: resultDirectoryURL,
            provenance: nil as MappingProvenance?
        )
        do {
            try configure(input: input)
        } catch {
            currentInput = input
            currentResult = result
            currentResultDirectoryURL = resultDirectoryURL?.standardizedFileURL
            showDetailPlaceholder("Unable to load the reference mapping viewer.")
        }
    }

    public var summaryBarView: NSView { summaryBar }

    public func exportResults(to url: URL, format: ResultExportFormat) throws {
        throw NSError(
            domain: "Lungfish",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Mapping export not yet implemented"]
        )
    }
}

extension ReferenceBundleViewportController: NSSplitViewDelegate {
    public func splitView(
        _ splitView: NSSplitView,
        constrainSplitPosition proposedPosition: CGFloat,
        ofSubviewAt dividerIndex: Int
    ) -> CGFloat {
        guard splitView === self.splitView else { return proposedPosition }
        let extent = splitView.isVertical ? splitView.bounds.width : splitView.bounds.height
        let extents = minimumExtents(for: MappingPanelLayout.current())
        return SplitPaneSizing.clampedDividerPosition(
            proposed: proposedPosition,
            containerExtent: extent,
            minimumLeadingExtent: extents.leading,
            minimumTrailingExtent: extents.trailing
        )
    }

    public func splitView(_ splitView: NSSplitView, resizeSubviewsWithOldSize oldSize: NSSize) {
        guard let trackedSplitView = splitView as? TrackedDividerSplitView,
              trackedSplitView === self.splitView else { return }
        splitCoordinator.resizeSubviewsWithOldSize(
            trackedSplitView,
            oldSize: oldSize,
            defaultLeadingFraction: defaultLeadingFraction(for: MappingPanelLayout.current()),
            minimumExtents: minimumExtents(for: MappingPanelLayout.current())
        )
    }

    public func splitViewDidResizeSubviews(_ notification: Notification) {
        guard splitView.arrangedSubviews.count > 1 else { return }
        if splitCoordinator.needsInitialSplitValidation {
            scheduleInitialSplitValidationIfNeeded()
        }
        splitCoordinator.splitViewDidResizeSubviews(
            splitView,
            minimumExtents: minimumExtents(for: MappingPanelLayout.current())
        )
    }
}

#if DEBUG
extension ReferenceBundleViewportController {
    func configureForTesting(input: ReferenceBundleViewportInput) throws {
        try configure(input: input)
    }

    func configureForTesting(result: MappingResult, resultDirectoryURL: URL? = nil) {
        configure(result: result, resultDirectoryURL: resultDirectoryURL)
    }

    var testDisplayedSequenceNames: [String] { sequenceRows.map(\.name) }
    var testSelectedSequenceName: String? { currentSelectedSequence()?.name }
    var testPresentationMode: PresentationMode { presentationMode }
    var testSplitView: TrackedDividerSplitView { splitView }
    var testListContainer: NSView { listContainer }
    var testDetailContainer: NSView { detailContainer }
    var testSummaryText: String { summaryLabel.stringValue }
    var testContigTableView: MappingContigTableView { contigTableView }
    var testDetailPlaceholderMessage: String { detailPlaceholderLabel.stringValue }
    var testEmbeddedViewerPublishesGlobalViewportNotifications: Bool {
        embeddedViewerController.publishesGlobalViewportNotifications
    }
    var testEmbeddedViewerShowsBundleBrowser: Bool {
        embeddedViewerController.testBundleBrowserController != nil
    }
    var testEmbeddedViewerShowsChromosomeNavigator: Bool {
        embeddedViewerController.chromosomeNavigatorView != nil
    }
    var testFilteredAlignmentServiceTarget: AlignmentFilterTarget? {
        filteredAlignmentServiceTarget
    }

    func testSelectContig(named name: String) {
        guard let row = contigTableView.displayedRows.firstIndex(where: { $0.contigName == name }) else { return }
        contigTableView.tableView.selectRowIndexes(IndexSet(integer: row), byExtendingSelection: false)
    }

    func testClearContigSelection() {
        contigTableView.tableView.deselectAll(nil)
    }

    func testBuildConsensusExportRequest() throws -> MappingConsensusExportRequest {
        try buildConsensusExportRequest()
    }

    func testSetEmbeddedReadDisplaySettings(minMapQ: Int, consensusMinMapQ: Int) {
        embeddedViewerController.viewerView.minMapQSetting = minMapQ
        embeddedViewerController.viewerView.consensusMinMapQSetting = consensusMinMapQ
    }
}
#endif
