import CoreGraphics

enum MetagenomicsPaneSizing {
    static func clampedDrawerExtent(
        proposed: CGFloat,
        containerExtent: CGFloat,
        minimumDrawerExtent: CGFloat,
        minimumSiblingExtent: CGFloat
    ) -> CGFloat {
        let maximumDrawerExtent = max(minimumDrawerExtent, containerExtent - minimumSiblingExtent)
        return min(max(proposed, minimumDrawerExtent), maximumDrawerExtent)
    }

    static func clampedDividerPosition(
        proposed: CGFloat,
        containerExtent: CGFloat,
        minimumLeadingExtent: CGFloat,
        minimumTrailingExtent: CGFloat
    ) -> CGFloat {
        let maximumDividerPosition = max(minimumLeadingExtent, containerExtent - minimumTrailingExtent)
        return min(max(proposed, minimumLeadingExtent), maximumDividerPosition)
    }
}
