import AppKit

/// `NSSplitView` does not always preserve the requested divider position across
/// subsequent constraint-based relayouts. Track the last requested divider
/// position so controllers can re-apply it when AppKit snaps back.
final class TrackedDividerSplitView: NSSplitView {
    private var requestedDividerPositions: [Int: CGFloat] = [:]

    override func setPosition(_ position: CGFloat, ofDividerAt dividerIndex: Int) {
        requestedDividerPositions[dividerIndex] = position
        super.setPosition(position, ofDividerAt: dividerIndex)
    }

    func requestedDividerPosition(at dividerIndex: Int) -> CGFloat? {
        requestedDividerPositions[dividerIndex]
    }

    func clearRequestedDividerPosition(at dividerIndex: Int = 0) {
        requestedDividerPositions.removeValue(forKey: dividerIndex)
    }
}
