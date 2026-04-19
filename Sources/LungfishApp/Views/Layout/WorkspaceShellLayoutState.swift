import CoreGraphics

struct WorkspaceShellLayoutState: Equatable {
    var isSidebarVisible = true
    var isInspectorVisible = true
    var lastUserSidebarWidth: CGFloat?
    var lastUserInspectorWidth: CGFloat?
    var pendingRecommendedSidebarWidth: CGFloat?
}
