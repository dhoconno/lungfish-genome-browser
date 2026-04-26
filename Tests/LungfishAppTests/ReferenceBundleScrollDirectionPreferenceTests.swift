import XCTest
@testable import LungfishApp
@testable import LungfishCore

@MainActor
final class ReferenceBundleScrollDirectionPreferenceTests: XCTestCase {
    func testCurrentScrollDirectionDefaultsToTraditional() {
        let suite = "reference-bundle-scroll-direction-pref-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }

        XCTAssertEqual(
            ReferenceBundleScrollDirectionPreference.current(defaults: defaults),
            .traditional
        )
    }

    func testCurrentScrollDirectionReadsLegacyBundleBrowserPreference() {
        let suite = "reference-bundle-scroll-direction-pref-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }

        defaults.set(
            ScrollDirectionPreference.natural.rawValue,
            forKey: "bundleBrowserHorizontalScrollDirection"
        )

        XCTAssertEqual(
            ReferenceBundleScrollDirectionPreference.current(defaults: defaults),
            .natural
        )
    }

    func testPersistScrollDirectionWritesReferenceBundleKeyAndPostsNotification() {
        let suite = "reference-bundle-scroll-direction-pref-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        let center = NotificationCenter()
        defer { defaults.removePersistentDomain(forName: suite) }

        let exp = expectation(description: "reference bundle scroll direction notification")
        let token = center.addObserver(
            forName: .referenceBundleScrollDirectionChanged,
            object: nil,
            queue: nil
        ) { _ in
            exp.fulfill()
        }
        defer { center.removeObserver(token) }

        ReferenceBundleScrollDirectionPreference.persist(
            .natural,
            defaults: defaults,
            notificationCenter: center
        )

        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(
            defaults.string(forKey: ReferenceBundleScrollDirectionPreference.defaultsKey),
            ScrollDirectionPreference.natural.rawValue
        )
        XCTAssertNil(defaults.string(forKey: MappingPanelLayout.defaultsKey))
    }
}
