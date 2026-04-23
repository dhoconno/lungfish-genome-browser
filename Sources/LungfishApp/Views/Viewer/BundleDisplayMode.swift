import Foundation

public enum BundleDisplayMode: Equatable {
    case browse
    case sequence(name: String, restoreViewState: Bool)
}
