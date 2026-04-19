import XCTest
@testable import LungfishApp
import ObjectiveC.runtime

private final class SplitViewPositionSpy: NSSplitView {
    static var setPositionCallCount = 0

    override func setPosition(_ position: CGFloat, ofDividerAt dividerIndex: Int) {
        Self.setPositionCallCount += 1
        super.setPosition(position, ofDividerAt: dividerIndex)
    }
}

@MainActor
final class MetagenomicsLayoutModeTests: XCTestCase {
    private func setLayoutPreference(
        _ layout: MetagenomicsPanelLayout,
        legacyTableOnLeft: Bool
    ) {
        UserDefaults.standard.set(layout.rawValue, forKey: MetagenomicsPanelLayout.defaultsKey)
        UserDefaults.standard.set(legacyTableOnLeft, forKey: MetagenomicsPanelLayout.legacyTableOnLeftKey)
    }

    nonisolated private static func clearLayoutPreference() {
        UserDefaults.standard.removeObject(forKey: "metagenomicsPanelLayout")
        UserDefaults.standard.removeObject(forKey: "metagenomicsTableOnLeft")
    }

    override func tearDown() {
        Self.clearLayoutPreference()
        super.tearDown()
    }

    func testTaxonomyViewStacksTableAboveDetailWhenLayoutIsStacked() {
        setLayoutPreference(.stacked, legacyTableOnLeft: false)

        let vc = TaxonomyViewController()
        _ = vc.view

        XCTAssertFalse(vc.testSplitView.isVertical)
        XCTAssertTrue(vc.testSplitView.arrangedSubviews[0].subviews.contains(vc.testTableView))
        XCTAssertTrue(vc.testSplitView.arrangedSubviews[1].subviews.contains(vc.testSunburstView))
    }

    func testTaxonomyLiveWindowKeepsBothPanesVisibleInStackedMode() {
        setLayoutPreference(.stacked, legacyTableOnLeft: false)

        let vc = TaxonomyViewController()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1400, height: 900),
            styleMask: [.titled, .resizable, .closable],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = vc
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertGreaterThan(vc.testSplitView.arrangedSubviews[0].frame.height, 120)
        XCTAssertGreaterThan(vc.testSplitView.arrangedSubviews[1].frame.height, 120)
    }

    func testTaxonomyLiveWindowKeepsBothPanesVisibleInListLeadingMode() {
        setLayoutPreference(.listLeading, legacyTableOnLeft: true)

        let vc = TaxonomyViewController()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1400, height: 900),
            styleMask: [.titled, .resizable, .closable],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = vc
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertGreaterThan(vc.testSplitView.arrangedSubviews[0].frame.width, 180)
        XCTAssertGreaterThan(vc.testSplitView.arrangedSubviews[1].frame.width, 180)
    }

    func testNaoMgsViewStacksTaxonomyTableAboveDetailWhenLayoutIsStacked() {
        setLayoutPreference(.stacked, legacyTableOnLeft: false)

        let vc = NaoMgsResultViewController()
        _ = vc.view

        XCTAssertFalse(vc.testSplitView.isVertical)
        XCTAssertTrue(vc.testSplitView.arrangedSubviews[0] === vc.testTableContainer)
        XCTAssertTrue(vc.testSplitView.arrangedSubviews[1] === vc.testDetailContainer)
    }

    func testNaoMgsLiveWindowKeepsBothPanesVisibleInListLeadingMode() {
        setLayoutPreference(.listLeading, legacyTableOnLeft: true)

        let vc = NaoMgsResultViewController()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1400, height: 900),
            styleMask: [.titled, .resizable, .closable],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = vc
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertGreaterThan(vc.testSplitView.arrangedSubviews[0].frame.width, 180)
        XCTAssertGreaterThan(vc.testSplitView.arrangedSubviews[1].frame.width, 180)
    }

    func testNaoMgsLiveWindowPreservesUserMovedVerticalDivider() {
        setLayoutPreference(.listLeading, legacyTableOnLeft: true)

        let vc = NaoMgsResultViewController()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1400, height: 900),
            styleMask: [.titled, .resizable, .closable],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = vc
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        let initialWidth = vc.testSplitView.arrangedSubviews[0].frame.width
        let minimumLeadingWidth: CGFloat = 320
        let maximumLeadingWidth = vc.testSplitView.bounds.width - 320
        let targetPosition: CGFloat
        if maximumLeadingWidth - initialWidth >= 120 {
            targetPosition = initialWidth + 160
        } else {
            targetPosition = max(minimumLeadingWidth, initialWidth - 160)
        }
        XCTAssertGreaterThan(abs(targetPosition - initialWidth), 80)

        vc.testSplitView.setPosition(targetPosition, ofDividerAt: 0)
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()

        let movedWidth = vc.testSplitView.arrangedSubviews[0].frame.width
        XCTAssertGreaterThan(
            abs(movedWidth - initialWidth),
            80,
            "initial=\(initialWidth) target=\(targetPosition) moved=\(movedWidth) bounds=\(vc.testSplitView.bounds.width)"
        )

        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()

        XCTAssertEqual(vc.testSplitView.arrangedSubviews[0].frame.width, movedWidth, accuracy: 2)
    }

    func testNvdViewStacksOutlineAboveDetailWhenLayoutIsStacked() {
        setLayoutPreference(.stacked, legacyTableOnLeft: false)

        let vc = NvdResultViewController()
        _ = vc.view

        XCTAssertFalse(vc.testSplitView.isVertical)
        XCTAssertTrue(vc.testSplitView.arrangedSubviews[0] === vc.testOutlineContainer)
        XCTAssertTrue(vc.testSplitView.arrangedSubviews[1] === vc.testDetailContainer)
    }

    func testNvdLiveWindowKeepsBothPanesVisibleInListLeadingMode() {
        setLayoutPreference(.listLeading, legacyTableOnLeft: true)

        let vc = NvdResultViewController()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1400, height: 900),
            styleMask: [.titled, .resizable, .closable],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = vc
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertGreaterThan(vc.testSplitView.arrangedSubviews[0].frame.width, 180)
        XCTAssertGreaterThan(vc.testSplitView.arrangedSubviews[1].frame.width, 180)
    }

    func testNvdLiveWindowPreservesUserMovedVerticalDivider() {
        setLayoutPreference(.listLeading, legacyTableOnLeft: true)

        let vc = NvdResultViewController()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1400, height: 900),
            styleMask: [.titled, .resizable, .closable],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = vc
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        let initialWidth = vc.testSplitView.arrangedSubviews[0].frame.width
        let minimumLeadingWidth: CGFloat = 320
        let maximumLeadingWidth = vc.testSplitView.bounds.width - 320
        let targetPosition: CGFloat
        if maximumLeadingWidth - initialWidth >= 120 {
            targetPosition = initialWidth + 160
        } else {
            targetPosition = max(minimumLeadingWidth, initialWidth - 160)
        }
        XCTAssertGreaterThan(abs(targetPosition - initialWidth), 80)

        vc.testSplitView.setPosition(targetPosition, ofDividerAt: 0)
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()

        let movedWidth = vc.testSplitView.arrangedSubviews[0].frame.width
        XCTAssertGreaterThan(
            abs(movedWidth - initialWidth),
            80,
            "initial=\(initialWidth) target=\(targetPosition) moved=\(movedWidth) bounds=\(vc.testSplitView.bounds.width)"
        )

        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()

        XCTAssertEqual(vc.testSplitView.arrangedSubviews[0].frame.width, movedWidth, accuracy: 2)
    }

    func testTaxTriageViewStacksListAboveDetailWhenLayoutIsStacked() {
        setLayoutPreference(.stacked, legacyTableOnLeft: false)

        let vc = TaxTriageResultViewController()
        _ = vc.view

        XCTAssertFalse(vc.testSplitView.isVertical)
        XCTAssertTrue(vc.testSplitView.arrangedSubviews[0] === vc.testRightPaneContainer)
        XCTAssertTrue(vc.testSplitView.arrangedSubviews[1] === vc.testLeftPaneContainer)
    }

    func testTaxTriageLiveWindowKeepsBothPanesVisibleInListLeadingMode() {
        setLayoutPreference(.listLeading, legacyTableOnLeft: true)

        let vc = TaxTriageResultViewController()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1400, height: 900),
            styleMask: [.titled, .resizable, .closable],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = vc
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertGreaterThan(vc.testSplitView.arrangedSubviews[0].frame.width, 180)
        XCTAssertGreaterThan(vc.testSplitView.arrangedSubviews[1].frame.width, 180)
    }

    func testTaxTriageLiveWindowHonorsListLeadingMinimumPaneWidths() {
        setLayoutPreference(.listLeading, legacyTableOnLeft: true)

        let vc = TaxTriageResultViewController()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1400, height: 900),
            styleMask: [.titled, .resizable, .closable],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = vc
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        let debugContext = "left=\(vc.testSplitView.arrangedSubviews[0].frame.width) right=\(vc.testSplitView.arrangedSubviews[1].frame.width) leftFit=\(vc.testRightPaneContainer.fittingSize.width) rightFit=\(vc.testLeftPaneContainer.fittingSize.width) min=\(vc.testSplitView.minPossiblePositionOfDivider(at: 0)) max=\(vc.testSplitView.maxPossiblePositionOfDivider(at: 0)) requested=\(String(describing: vc.testRequestedDividerPosition)) needsValidation=\(vc.testNeedsInitialSplitValidation)"
        XCTAssertGreaterThanOrEqual(vc.testSplitView.arrangedSubviews[0].frame.width, 298, debugContext)
        XCTAssertGreaterThanOrEqual(vc.testSplitView.arrangedSubviews[1].frame.width, 248, debugContext)
    }

    func testTaxTriageLiveWindowPreservesUserMovedVerticalDivider() {
        setLayoutPreference(.listLeading, legacyTableOnLeft: true)

        let vc = TaxTriageResultViewController()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1400, height: 900),
            styleMask: [.titled, .resizable, .closable],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = vc
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        let initialWidth = vc.testSplitView.arrangedSubviews[0].frame.width
        let minimumLeadingWidth: CGFloat = 320
        let maximumLeadingWidth = vc.testSplitView.bounds.width - 320
        let targetPosition: CGFloat
        if maximumLeadingWidth - initialWidth >= 120 {
            targetPosition = initialWidth + 160
        } else {
            targetPosition = max(minimumLeadingWidth, initialWidth - 160)
        }
        XCTAssertGreaterThan(abs(targetPosition - initialWidth), 80)

        vc.testSplitView.setPosition(targetPosition, ofDividerAt: 0)
        vc.testSplitView.adjustSubviews()
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()

        let movedWidth = vc.testSplitView.arrangedSubviews[0].frame.width
        XCTAssertGreaterThan(
            abs(movedWidth - initialWidth),
            80,
            "initial=\(initialWidth) target=\(targetPosition) moved=\(movedWidth) bounds=\(vc.testSplitView.bounds.width) leftFit=\(vc.testRightPaneContainer.fittingSize.width) rightFit=\(vc.testLeftPaneContainer.fittingSize.width) min=\(vc.testSplitView.minPossiblePositionOfDivider(at: 0)) max=\(vc.testSplitView.maxPossiblePositionOfDivider(at: 0))"
        )

        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()

        XCTAssertEqual(vc.testSplitView.arrangedSubviews[0].frame.width, movedWidth, accuracy: 2)
    }

    func testTaxTriageImmediateUserDividerMoveSurvivesDeferredValidation() {
        setLayoutPreference(.listLeading, legacyTableOnLeft: true)

        let vc = TaxTriageResultViewController()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1400, height: 900),
            styleMask: [.titled, .resizable, .closable],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = vc
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()

        let initialWidth = vc.testSplitView.arrangedSubviews[0].frame.width
        let minimumLeadingWidth: CGFloat = 320
        let maximumLeadingWidth = vc.testSplitView.bounds.width - 320
        let targetPosition: CGFloat
        if maximumLeadingWidth - initialWidth >= 120 {
            targetPosition = initialWidth + 160
        } else {
            targetPosition = max(minimumLeadingWidth, initialWidth - 160)
        }
        vc.testSplitView.setPosition(targetPosition, ofDividerAt: 0)
        vc.testSplitView.adjustSubviews()
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()

        let movedWidth = vc.testSplitView.arrangedSubviews[0].frame.width
        XCTAssertGreaterThan(
            abs(movedWidth - initialWidth),
            80,
            "initial=\(initialWidth) target=\(targetPosition) moved=\(movedWidth) bounds=\(vc.testSplitView.bounds.width)"
        )

        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()

        XCTAssertEqual(vc.testSplitView.arrangedSubviews[0].frame.width, movedWidth, accuracy: 2)
    }

    func testTaxTriageDidResizeSubviewsDoesNotReapplyStaleTrackedDividerPosition() {
        setLayoutPreference(.detailLeading, legacyTableOnLeft: false)

        let vc = TaxTriageResultViewController()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1400, height: 900),
            styleMask: [.titled, .resizable, .closable],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = vc
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        let initialWidth = vc.testSplitView.arrangedSubviews[0].frame.width
        let draggedWidth = initialWidth - 160
        let dividerThickness = vc.testSplitView.dividerThickness
        let totalWidth = vc.testSplitView.bounds.width

        var firstFrame = vc.testSplitView.arrangedSubviews[0].frame
        firstFrame.size.width = draggedWidth
        vc.testSplitView.arrangedSubviews[0].frame = firstFrame

        var secondFrame = vc.testSplitView.arrangedSubviews[1].frame
        secondFrame.origin.x = draggedWidth + dividerThickness
        secondFrame.size.width = totalWidth - draggedWidth - dividerThickness
        vc.testSplitView.arrangedSubviews[1].frame = secondFrame

        vc.splitViewDidResizeSubviews(Notification(name: .init("TestSplitResize"), object: vc.testSplitView))

        XCTAssertEqual(
            vc.testSplitView.arrangedSubviews[0].frame.width,
            draggedWidth,
            accuracy: 2,
            "initial=\(initialWidth) dragged=\(draggedWidth) tracked=\(String(describing: vc.testRequestedDividerPosition)) current=\(vc.testSplitView.arrangedSubviews[0].frame.width)"
        )
    }

    func testTaxTriageMiniBAMScrollViewTracksDetailPaneResize() throws {
        setLayoutPreference(.detailLeading, legacyTableOnLeft: false)

        let vc = TaxTriageResultViewController()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1400, height: 900),
            styleMask: [.titled, .resizable, .closable],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = vc
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        let bamView = try XCTUnwrap(
            vc.testLeftPaneContainer.subviews.first(where: { subview in
                subview.subviews.contains(where: { $0 is NSScrollView })
            })
        )
        let scrollView = try XCTUnwrap(
            bamView.subviews.first(where: { $0 is NSScrollView }) as? NSScrollView
        )

        let minimumLeadingWidth: CGFloat = 250
        let maximumLeadingWidth = vc.testSplitView.bounds.width - 300
        let initialContainerWidth = vc.testLeftPaneContainer.bounds.width
        let targetPosition: CGFloat
        if maximumLeadingWidth - initialContainerWidth >= 120 {
            targetPosition = initialContainerWidth + 160
        } else {
            targetPosition = max(minimumLeadingWidth, initialContainerWidth - 160)
        }

        vc.testSplitView.setPosition(targetPosition, ofDividerAt: 0)
        vc.testSplitView.adjustSubviews()
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(
            scrollView.frame.width,
            bamView.bounds.width,
            accuracy: 2,
            "scrollWidth=\(scrollView.frame.width) bamWidth=\(bamView.bounds.width) containerWidth=\(vc.testLeftPaneContainer.bounds.width)"
        )
    }

    func testEsVirituLiveWindowKeepsBothPanesVisibleInListLeadingMode() {
        setLayoutPreference(.listLeading, legacyTableOnLeft: true)

        let vc = EsVirituResultViewController()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1400, height: 900),
            styleMask: [.titled, .resizable, .closable],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = vc
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertGreaterThan(vc.testSplitView.arrangedSubviews[0].frame.width, 180)
        XCTAssertGreaterThan(vc.testSplitView.arrangedSubviews[1].frame.width, 180)
    }

    func testEsVirituLiveWindowHonorsListLeadingMinimumPaneWidths() {
        setLayoutPreference(.listLeading, legacyTableOnLeft: true)

        let vc = EsVirituResultViewController()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1400, height: 900),
            styleMask: [.titled, .resizable, .closable],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = vc
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        let debugContext = "left=\(vc.testSplitView.arrangedSubviews[0].frame.width) right=\(vc.testSplitView.arrangedSubviews[1].frame.width) requested=\(String(describing: vc.testRequestedDividerPosition)) needsValidation=\(vc.testNeedsInitialSplitValidation)"
        XCTAssertGreaterThanOrEqual(vc.testSplitView.arrangedSubviews[0].frame.width, 248, debugContext)
        XCTAssertGreaterThanOrEqual(vc.testSplitView.arrangedSubviews[1].frame.width, 248, debugContext)
    }

    func testEsVirituLiveWindowPreservesUserMovedVerticalDivider() {
        setLayoutPreference(.listLeading, legacyTableOnLeft: true)

        let vc = EsVirituResultViewController()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1400, height: 900),
            styleMask: [.titled, .resizable, .closable],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = vc
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        let initialWidth = vc.testSplitView.arrangedSubviews[0].frame.width
        let minimumLeadingWidth: CGFloat = 320
        let maximumLeadingWidth = vc.testSplitView.bounds.width - 320
        let targetPosition: CGFloat
        if maximumLeadingWidth - initialWidth >= 120 {
            targetPosition = initialWidth + 160
        } else {
            targetPosition = max(minimumLeadingWidth, initialWidth - 160)
        }
        XCTAssertGreaterThan(abs(targetPosition - initialWidth), 80)

        vc.testSplitView.setPosition(targetPosition, ofDividerAt: 0)
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()

        let movedWidth = vc.testSplitView.arrangedSubviews[0].frame.width
        XCTAssertGreaterThan(
            abs(movedWidth - initialWidth),
            80,
            "initial=\(initialWidth) target=\(targetPosition) moved=\(movedWidth) bounds=\(vc.testSplitView.bounds.width)"
        )

        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()

        XCTAssertEqual(vc.testSplitView.arrangedSubviews[0].frame.width, movedWidth, accuracy: 2)
    }

    func testEsVirituImmediateUserDividerMoveSurvivesDeferredValidation() {
        setLayoutPreference(.listLeading, legacyTableOnLeft: true)

        let vc = EsVirituResultViewController()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1400, height: 900),
            styleMask: [.titled, .resizable, .closable],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = vc
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()

        let initialWidth = vc.testSplitView.arrangedSubviews[0].frame.width
        let minimumLeadingWidth: CGFloat = 320
        let maximumLeadingWidth = vc.testSplitView.bounds.width - 320
        let targetPosition: CGFloat
        if maximumLeadingWidth - initialWidth >= 120 {
            targetPosition = initialWidth + 160
        } else {
            targetPosition = max(minimumLeadingWidth, initialWidth - 160)
        }
        vc.testSplitView.setPosition(targetPosition, ofDividerAt: 0)
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()

        let movedWidth = vc.testSplitView.arrangedSubviews[0].frame.width
        XCTAssertGreaterThan(
            abs(movedWidth - initialWidth),
            80,
            "initial=\(initialWidth) target=\(targetPosition) moved=\(movedWidth) bounds=\(vc.testSplitView.bounds.width)"
        )

        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()

        XCTAssertEqual(vc.testSplitView.arrangedSubviews[0].frame.width, movedWidth, accuracy: 2)
    }

    func testTaxonomyViewDidLayoutDoesNotApplyNewPreferenceWithoutNotification() {
        setLayoutPreference(.detailLeading, legacyTableOnLeft: false)

        let vc = TaxonomyViewController()
        _ = vc.view
        vc.view.frame = NSRect(x: 0, y: 0, width: 900, height: 700)

        let initialFirstPane = vc.testSplitView.arrangedSubviews[0]
        let initialSecondPane = vc.testSplitView.arrangedSubviews[1]

        setLayoutPreference(.stacked, legacyTableOnLeft: false)
        vc.viewDidLayout()

        XCTAssertTrue(vc.testSplitView.isVertical)
        XCTAssertTrue(vc.testSplitView.arrangedSubviews[0] === initialFirstPane)
        XCTAssertTrue(vc.testSplitView.arrangedSubviews[1] === initialSecondPane)
    }

    func testTaxonomyViewDidLayoutDoesNotSynchronouslyMoveDivider() {
        setLayoutPreference(.stacked, legacyTableOnLeft: false)

        let vc = TaxonomyViewController()
        _ = vc.view

        SplitViewPositionSpy.setPositionCallCount = 0
        let originalClass: AnyClass = object_getClass(vc.testSplitView)!
        object_setClass(vc.testSplitView, SplitViewPositionSpy.self)
        defer { object_setClass(vc.testSplitView, originalClass) }

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1400, height: 900),
            styleMask: [.titled, .resizable, .closable],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = vc
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()

        XCTAssertEqual(SplitViewPositionSpy.setPositionCallCount, 0)
    }

    func testNaoMgsViewDidLayoutDoesNotApplyNewPreferenceWithoutNotification() {
        setLayoutPreference(.detailLeading, legacyTableOnLeft: false)

        let vc = NaoMgsResultViewController()
        _ = vc.view
        vc.view.frame = NSRect(x: 0, y: 0, width: 900, height: 700)

        let initialFirstPane = vc.testSplitView.arrangedSubviews[0]
        let initialSecondPane = vc.testSplitView.arrangedSubviews[1]

        setLayoutPreference(.stacked, legacyTableOnLeft: false)
        vc.viewDidLayout()

        XCTAssertTrue(vc.testSplitView.isVertical)
        XCTAssertTrue(vc.testSplitView.arrangedSubviews[0] === initialFirstPane)
        XCTAssertTrue(vc.testSplitView.arrangedSubviews[1] === initialSecondPane)
    }

    func testTaxTriageLayoutChangeResetsCollapsedStackedPaneToSensibleWidth() {
        setLayoutPreference(.stacked, legacyTableOnLeft: false)

        let vc = TaxTriageResultViewController()
        _ = vc.view
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1200, height: 800),
            styleMask: [.titled, .resizable, .closable],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = vc
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()

        vc.testSplitView.setPosition(80, ofDividerAt: 0)

        setLayoutPreference(.listLeading, legacyTableOnLeft: true)
        NotificationCenter.default.post(name: .metagenomicsLayoutSwapRequested, object: nil)
        window.layoutIfNeeded()
        vc.view.layoutSubtreeIfNeeded()

        let firstPaneWidth = vc.testSplitView.arrangedSubviews[0].frame.width
        let secondPaneWidth = vc.testSplitView.arrangedSubviews[1].frame.width
        XCTAssertGreaterThan(firstPaneWidth, 200)
        XCTAssertGreaterThan(secondPaneWidth, 80)
    }

    func testTaxTriageSplitAllowsHiddenTrailingDetailPaneToFullyCollapse() {
        setLayoutPreference(.stacked, legacyTableOnLeft: false)

        let vc = TaxTriageResultViewController()
        _ = vc.view
        vc.view.frame = NSRect(x: 0, y: 0, width: 1200, height: 800)
        vc.testSplitView.frame = NSRect(x: 0, y: 0, width: 1200, height: 700)
        vc.testSplitView.layoutSubtreeIfNeeded()
        vc.viewDidLayout()
        vc.testLeftPaneContainer.isHidden = true

        let totalExtent = vc.testSplitView.bounds.height
        let clamped = vc.splitView(
            vc.testSplitView,
            constrainSplitPosition: totalExtent,
            ofSubviewAt: 0
        )

        XCTAssertEqual(clamped, totalExtent, accuracy: 0.5)
    }
}
