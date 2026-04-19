import CoreGraphics

@MainActor
final class WorkspaceShellLayoutCoordinator {
    enum Event {
        case shellDidResize
        case recommendationArrived
        case userDraggedSidebar
        case userDraggedInspector
    }

    struct Decision: Equatable {
        var shouldSetSidebarDividerSynchronously: Bool
        var sidebarWidthToPersist: CGFloat?
        var inspectorWidthToPersist: CGFloat?
    }

    private(set) var state = WorkspaceShellLayoutState()

    private let sidebarMinWidth: CGFloat
    private let sidebarMaxWidth: CGFloat
    private let inspectorMinWidth: CGFloat
    private let inspectorMaxWidth: CGFloat
    private let viewerMinWidth: CGFloat

    init(
        sidebarMinWidth: CGFloat,
        sidebarMaxWidth: CGFloat,
        inspectorMinWidth: CGFloat,
        inspectorMaxWidth: CGFloat,
        viewerMinWidth: CGFloat
    ) {
        self.sidebarMinWidth = sidebarMinWidth
        self.sidebarMaxWidth = sidebarMaxWidth
        self.inspectorMinWidth = inspectorMinWidth
        self.inspectorMaxWidth = inspectorMaxWidth
        self.viewerMinWidth = viewerMinWidth
    }

    func recordRecommendation(_ width: CGFloat) {
        state.pendingRecommendedSidebarWidth = clampSidebarWidth(width)
    }

    func recordUserSidebarWidth(_ width: CGFloat) {
        state.lastUserSidebarWidth = clampSidebarWidth(width)
    }

    func recordUserInspectorWidth(_ width: CGFloat) {
        state.lastUserInspectorWidth = clampInspectorWidth(width)
    }

    func setSidebarVisible(_ isVisible: Bool) {
        state.isSidebarVisible = isVisible
    }

    func setInspectorVisible(_ isVisible: Bool) {
        state.isInspectorVisible = isVisible
    }

    func resolvedSidebarWidth(currentWidth: CGFloat) -> CGFloat {
        state.lastUserSidebarWidth
            ?? state.pendingRecommendedSidebarWidth
            ?? clampSidebarWidth(currentWidth)
    }

    func resizeDecision(
        event: Event,
        currentSidebarWidth: CGFloat,
        currentInspectorWidth: CGFloat,
        totalWidth: CGFloat
    ) -> Decision {
        _ = event
        _ = totalWidth
        _ = viewerMinWidth

        return Decision(
            shouldSetSidebarDividerSynchronously: false,
            sidebarWidthToPersist: clampSidebarWidth(currentSidebarWidth),
            inspectorWidthToPersist: clampInspectorWidth(currentInspectorWidth)
        )
    }

    private func clampSidebarWidth(_ width: CGFloat) -> CGFloat {
        min(max(width, sidebarMinWidth), sidebarMaxWidth)
    }

    private func clampInspectorWidth(_ width: CGFloat) -> CGFloat {
        min(max(width, inspectorMinWidth), inspectorMaxWidth)
    }
}
