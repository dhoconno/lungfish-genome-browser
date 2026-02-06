// ViewerViewController+BundleDisplay.swift - Reference bundle display for ViewerViewController
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// This extension adds reference genome bundle display capabilities to ViewerViewController,
// including chromosome navigation, on-demand data fetching, and bundle-specific layout.

import AppKit
import LungfishCore
import LungfishIO
import os.log

/// Logger for bundle display operations
private let bundleLogger = Logger(subsystem: "com.lungfish.browser", category: "ViewerBundleDisplay")

// MARK: - ViewerViewController Bundle Display Extension

extension ViewerViewController: ChromosomeNavigatorDelegate {

    // MARK: - Bundle Display

    /// Displays a reference genome bundle in the viewer with a chromosome navigator.
    ///
    /// This method sets up the complete bundle viewing experience:
    /// 1. Creates a `BundleDataProvider` for on-demand data access
    /// 2. Shows a `ChromosomeNavigatorView` on the left side of the viewer
    /// 3. Configures the `ReferenceFrame` for the first chromosome
    /// 4. Passes the underlying `ReferenceBundle` to the `SequenceViewerView`
    ///    for on-demand sequence and annotation rendering
    ///
    /// - Parameter url: URL of the `.lungfishref` bundle directory
    /// - Throws: Error if the manifest cannot be loaded or the bundle is invalid
    public func displayBundle(at url: URL) throws {
        bundleLogger.info("displayBundle: Opening bundle at '\(url.lastPathComponent, privacy: .public)'")

        // Load and validate manifest
        let manifest = try BundleManifest.load(from: url)
        let validationErrors = manifest.validate()
        if !validationErrors.isEmpty {
            let messages = validationErrors.map { $0.localizedDescription }.joined(separator: "; ")
            bundleLogger.error("displayBundle: Manifest validation failed: \(messages, privacy: .public)")
            throw DocumentLoadError.parseError("Bundle validation failed: \(messages)")
        }

        // Create data provider
        let provider = BundleDataProvider(bundleURL: url, manifest: manifest)
        currentBundleDataProvider = provider

        // Create reference bundle with pre-loaded manifest (synchronous)
        let bundle = ReferenceBundle(url: url, manifest: manifest)

        // Hide any QuickLook preview and ensure genomics viewer is visible
        hideQuickLookPreview()

        // Note: ViewerViewController.currentReferenceBundle has private(set) access,
        // so we cannot assign it from this extension file. Instead, we rely on
        // viewerView.setReferenceBundle(bundle) below, which stores the bundle on the
        // SequenceViewerView where the drawing code actually reads it.

        // Set up chromosome navigator
        configureChromosomeNavigator(with: manifest.genome.chromosomes)

        // Force layout for valid bounds
        view.layoutSubtreeIfNeeded()
        let effectiveWidth = max(800, Int(viewerView.bounds.width))

        // Set up the viewer with bundle - this stores the bundle on SequenceViewerView
        // for on-demand sequence and annotation rendering in draw(_:)
        viewerView.setReferenceBundle(bundle)

        // Navigate to the first chromosome
        guard let firstChrom = manifest.genome.chromosomes.first else {
            bundleLogger.error("displayBundle: No chromosomes in bundle")
            showNoSequenceSelected()
            return
        }

        let chromLength = Int(firstChrom.length)
        bundleLogger.info("displayBundle: Navigating to first chromosome '\(firstChrom.name, privacy: .public)' length=\(chromLength)")

        // Create reference frame
        referenceFrame = ReferenceFrame(
            chromosome: firstChrom.name,
            start: 0,
            end: Double(min(chromLength, 10000)),
            pixelWidth: effectiveWidth,
            sequenceLength: chromLength
        )

        // Update header with track names
        let trackNames = [firstChrom.name] + manifest.annotations.map { "Annotations: \($0.name)" }
        headerView.setTrackNames(trackNames)

        // Update ruler
        enhancedRulerView.referenceFrame = referenceFrame

        // Update status bar
        updateStatusBar()

        // Trigger redraw
        viewerView.needsDisplay = true
        enhancedRulerView.needsDisplay = true
        headerView.needsDisplay = true

        // Schedule delayed redraw for layout timing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self else { return }

            if let frame = self.referenceFrame, self.viewerView.bounds.width > 0 {
                frame.pixelWidth = Int(self.viewerView.bounds.width)
            }

            self.viewerView.needsDisplay = true
            self.enhancedRulerView.needsDisplay = true
            self.headerView.needsDisplay = true
        }

        bundleLogger.info("displayBundle: Bundle displayed successfully with \(manifest.genome.chromosomes.count) chromosomes")
    }

    // MARK: - Chromosome Navigator

    /// Configures the chromosome navigator panel on the left side of the viewer.
    ///
    /// If a navigator already exists, it is updated with the new chromosome list.
    /// Otherwise, a new navigator is created and installed in the view hierarchy
    /// alongside the existing viewer components.
    ///
    /// - Parameter chromosomes: The chromosome list from the bundle manifest
    private func configureChromosomeNavigator(with chromosomes: [ChromosomeInfo]) {
        if let existing = chromosomeNavigatorView {
            // Update existing navigator
            existing.chromosomes = chromosomes
            existing.selectedChromosomeIndex = 0
            existing.isHidden = false
            bundleLogger.debug("configureChromosomeNavigator: Updated existing navigator with \(chromosomes.count) chromosomes")
            return
        }

        // Create new navigator
        let navigator = ChromosomeNavigatorView()
        navigator.translatesAutoresizingMaskIntoConstraints = false
        navigator.delegate = self
        navigator.chromosomes = chromosomes
        navigator.selectedChromosomeIndex = 0

        // Insert into view hierarchy at the leading edge
        view.addSubview(navigator)

        // The navigator sits between the header and the viewer, sharing the header's
        // column space. We adjust the header to accommodate the navigator above the
        // track labels.
        let navigatorWidth: CGFloat = 160

        // Store constraints so we can remove them later when hiding the navigator
        let constraints = [
            navigator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigator.widthAnchor.constraint(equalToConstant: navigatorWidth),
            navigator.bottomAnchor.constraint(equalTo: statusBar.topAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        chromosomeNavigatorConstraints = constraints

        // Adjust existing views: push headerView and viewerView to the right of navigator
        adjustViewerLayoutForNavigator(width: navigatorWidth)

        chromosomeNavigatorView = navigator
        bundleLogger.info("configureChromosomeNavigator: Created navigator with \(chromosomes.count) chromosomes, width=\(navigatorWidth)")
    }

    /// Adjusts the existing viewer layout to accommodate the chromosome navigator panel.
    ///
    /// Updates the leading constraint of the header view so the header and viewer
    /// shift to the right of the navigator panel.
    ///
    /// - Parameter width: Width of the navigator panel
    private func adjustViewerLayoutForNavigator(width: CGFloat) {
        // Update the header's leading anchor to sit after the navigator
        // The header is constrained to container.leadingAnchor in loadView().
        // We need to update that constraint.
        for constraint in view.constraints {
            if constraint.firstItem === headerView,
               constraint.firstAttribute == .leading,
               constraint.secondItem === view,
               constraint.secondAttribute == .leading {
                constraint.constant = width
                break
            }
        }

        view.layoutSubtreeIfNeeded()
        bundleLogger.debug("adjustViewerLayoutForNavigator: Layout adjusted for navigator width=\(width)")
    }

    /// Hides the chromosome navigator panel, restoring the default viewer layout.
    public func hideChromosomeNavigator() {
        guard let navigator = chromosomeNavigatorView else { return }

        navigator.isHidden = true

        // Restore header leading constraint
        for constraint in view.constraints {
            if constraint.firstItem === headerView,
               constraint.firstAttribute == .leading,
               constraint.secondItem === view,
               constraint.secondAttribute == .leading {
                constraint.constant = 0
                break
            }
        }

        view.layoutSubtreeIfNeeded()
        bundleLogger.info("hideChromosomeNavigator: Navigator hidden, layout restored")
    }

    /// Removes the chromosome navigator from the view hierarchy entirely.
    public func removeChromosomeNavigator() {
        guard let navigator = chromosomeNavigatorView else { return }

        // Deactivate and remove constraints
        if let constraints = chromosomeNavigatorConstraints {
            NSLayoutConstraint.deactivate(constraints)
        }
        chromosomeNavigatorConstraints = nil

        navigator.removeFromSuperview()
        chromosomeNavigatorView = nil

        // Restore header leading constraint
        for constraint in view.constraints {
            if constraint.firstItem === headerView,
               constraint.firstAttribute == .leading,
               constraint.secondItem === view,
               constraint.secondAttribute == .leading {
                constraint.constant = 0
                break
            }
        }

        view.layoutSubtreeIfNeeded()
        bundleLogger.info("removeChromosomeNavigator: Navigator removed from view hierarchy")
    }

    // MARK: - ChromosomeNavigatorDelegate

    public func chromosomeNavigator(_ navigator: ChromosomeNavigatorView, didSelectChromosome chromosome: ChromosomeInfo) {
        bundleLogger.info("chromosomeNavigator: Navigating to '\(chromosome.name, privacy: .public)' length=\(chromosome.length)")

        let chromLength = Int(chromosome.length)
        let effectiveWidth = max(800, Int(viewerView.bounds.width))

        // Update reference frame for the new chromosome
        referenceFrame = ReferenceFrame(
            chromosome: chromosome.name,
            start: 0,
            end: Double(min(chromLength, 10000)),
            pixelWidth: effectiveWidth,
            sequenceLength: chromLength
        )

        // Update header - show the selected chromosome as the first track
        if let provider = currentBundleDataProvider {
            let trackNames = [chromosome.name] + provider.annotationTrackIds.map { "Annotations: \($0)" }
            headerView.setTrackNames(trackNames)
        } else {
            headerView.setTrackNames([chromosome.name])
        }

        // Update ruler
        enhancedRulerView.referenceFrame = referenceFrame

        // Update status bar
        updateStatusBar()

        // Trigger redraw - the SequenceViewerView will fetch data for the new chromosome
        // using the reference bundle's on-demand readers
        viewerView.needsDisplay = true
        enhancedRulerView.needsDisplay = true
        headerView.needsDisplay = true

        bundleLogger.info("chromosomeNavigator: Navigation to '\(chromosome.name, privacy: .public)' complete")
    }

    // MARK: - Bundle State Management

    /// Clears all bundle display state, removing the navigator and data provider.
    ///
    /// Call this when switching away from a bundle to a regular document or
    /// when the viewer is cleared entirely.
    public func clearBundleDisplay() {
        bundleLogger.info("clearBundleDisplay: Clearing bundle state")

        currentBundleDataProvider = nil
        removeChromosomeNavigator()

        // The existing clearViewer() handles clearing currentReferenceBundle
        // and viewer state, so we only clean up bundle-specific state here.
    }
}

// MARK: - ViewerViewController Stored Properties for Bundle Display

/// Extension to add stored properties via associated objects.
///
/// Swift extensions cannot add stored properties directly, so we use
/// Objective-C associated objects for the chromosome navigator and
/// bundle data provider references.
extension ViewerViewController {

    private static var chromosomeNavigatorKey: UInt8 = 0
    private static var chromosomeNavigatorConstraintsKey: UInt8 = 0
    private static var bundleDataProviderKey: UInt8 = 0

    /// The chromosome navigator view, if currently displayed.
    var chromosomeNavigatorView: ChromosomeNavigatorView? {
        get {
            objc_getAssociatedObject(self, &Self.chromosomeNavigatorKey) as? ChromosomeNavigatorView
        }
        set {
            objc_setAssociatedObject(self, &Self.chromosomeNavigatorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// Layout constraints for the chromosome navigator.
    var chromosomeNavigatorConstraints: [NSLayoutConstraint]? {
        get {
            objc_getAssociatedObject(self, &Self.chromosomeNavigatorConstraintsKey) as? [NSLayoutConstraint]
        }
        set {
            objc_setAssociatedObject(self, &Self.chromosomeNavigatorConstraintsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// The current bundle data provider for on-demand data access.
    public var currentBundleDataProvider: BundleDataProvider? {
        get {
            objc_getAssociatedObject(self, &Self.bundleDataProviderKey) as? BundleDataProvider
        }
        set {
            objc_setAssociatedObject(self, &Self.bundleDataProviderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
