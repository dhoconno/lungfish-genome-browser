import Foundation
import LungfishCore

@MainActor
enum BundleBrowserPanelLayout: String, CaseIterable, Sendable {
    case detailLeading
    case listLeading
    case stacked

    static let defaultsKey = "bundleBrowserPanelLayout"

    static func current(defaults: UserDefaults = .standard) -> Self {
        guard let raw = defaults.string(forKey: defaultsKey),
              let value = Self(rawValue: raw) else {
            return .listLeading
        }
        return value
    }

    func persist(
        defaults: UserDefaults = .standard,
        notificationCenter: NotificationCenter = .default
    ) {
        defaults.set(rawValue, forKey: Self.defaultsKey)
        notificationCenter.post(name: .bundleBrowserLayoutSwapRequested, object: nil)
    }
}

@MainActor
enum BundleBrowserScrollDirectionPreference {
    static let defaultsKey = "bundleBrowserHorizontalScrollDirection"

    static func current(defaults: UserDefaults = .standard) -> ScrollDirectionPreference {
        guard let raw = defaults.string(forKey: defaultsKey),
              let value = ScrollDirectionPreference(rawValue: raw) else {
            return .traditional
        }
        return value
    }

    static func persist(
        _ preference: ScrollDirectionPreference,
        defaults: UserDefaults = .standard,
        notificationCenter: NotificationCenter = .default
    ) {
        defaults.set(preference.rawValue, forKey: defaultsKey)
        notificationCenter.post(name: .bundleBrowserScrollDirectionChanged, object: nil)
    }
}

extension Notification.Name {
    static let bundleBrowserLayoutSwapRequested = Notification.Name("com.lungfish.bundleBrowserLayoutSwapRequested")
    static let bundleBrowserScrollDirectionChanged = Notification.Name("com.lungfish.bundleBrowserScrollDirectionChanged")
}
