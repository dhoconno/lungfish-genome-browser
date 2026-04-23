import Foundation

enum ReadViewportPolicy {
    static let coverageThresholdBpPerPx: Double = 2.0
    static let baseThresholdBpPerPx: Double = 0.6

    static func zoomTier(scale: Double) -> ReadTrackRenderer.ZoomTier {
        if scale > coverageThresholdBpPerPx {
            return .coverage
        } else if scale > baseThresholdBpPerPx {
            return .packed
        } else {
            return .base
        }
    }

    static func allowsIndividualReads(scale: Double) -> Bool {
        zoomTier(scale: scale) != .coverage
    }
}
