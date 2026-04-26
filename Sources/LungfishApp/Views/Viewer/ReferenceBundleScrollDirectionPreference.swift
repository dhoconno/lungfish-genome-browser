import Foundation
import LungfishCore

@MainActor
enum ReferenceBundleScrollDirectionPreference {
    static let defaultsKey = "referenceBundleHorizontalScrollDirection"
    private static let legacyDefaultsKey = "bundleBrowserHorizontalScrollDirection"

    static func current(defaults: UserDefaults = .standard) -> ScrollDirectionPreference {
        let rawValue = defaults.string(forKey: defaultsKey)
            ?? defaults.string(forKey: legacyDefaultsKey)
        guard let rawValue,
              let value = ScrollDirectionPreference(rawValue: rawValue) else {
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
        notificationCenter.post(name: .referenceBundleScrollDirectionChanged, object: nil)
    }

    static func viewportDirection(for preference: ScrollDirectionPreference) -> ScrollDirectionPreference {
        switch preference {
        case .system:
            return .system
        case .natural:
            return .traditional
        case .traditional:
            return .natural
        }
    }
}

extension Notification.Name {
    static let referenceBundleScrollDirectionChanged = Notification.Name("com.lungfish.referenceBundleScrollDirectionChanged")
}
