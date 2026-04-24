import XCTest
@testable import LungfishApp
@testable import LungfishCore

@MainActor
final class BundleBrowserLayoutPreferenceTests: XCTestCase {
    func testCurrentLayoutDoesNotReuseMappingDefaults() {
        let suite = "bundle-browser-layout-pref-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }

        defaults.set(
            MappingPanelLayout.stacked.rawValue,
            forKey: MappingPanelLayout.defaultsKey
        )

        XCTAssertEqual(
            BundleBrowserPanelLayout.current(defaults: defaults),
            .listLeading
        )
    }

    func testPersistWritesBundleBrowserKeyWithoutTouchingMappingAndPostsNotification() {
        let suite = "bundle-browser-layout-pref-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        let center = NotificationCenter()
        defer { defaults.removePersistentDomain(forName: suite) }

        let exp = expectation(description: "bundle browser layout notification")
        let token = center.addObserver(
            forName: .bundleBrowserLayoutSwapRequested,
            object: nil,
            queue: nil
        ) { _ in
            exp.fulfill()
        }
        defer { center.removeObserver(token) }

        BundleBrowserPanelLayout.stacked.persist(
            defaults: defaults,
            notificationCenter: center
        )

        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(
            defaults.string(forKey: BundleBrowserPanelLayout.defaultsKey),
            BundleBrowserPanelLayout.stacked.rawValue
        )
        XCTAssertNil(defaults.string(forKey: MappingPanelLayout.defaultsKey))
    }

    func testCurrentScrollDirectionDefaultsToTraditional() {
        let suite = "bundle-browser-scroll-direction-pref-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }

        XCTAssertEqual(
            BundleBrowserScrollDirectionPreference.current(defaults: defaults),
            .traditional
        )
    }

    func testPersistScrollDirectionWritesBundleKeyAndPostsNotification() {
        let suite = "bundle-browser-scroll-direction-pref-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        let center = NotificationCenter()
        defer { defaults.removePersistentDomain(forName: suite) }

        let exp = expectation(description: "bundle browser scroll direction notification")
        let token = center.addObserver(
            forName: .bundleBrowserScrollDirectionChanged,
            object: nil,
            queue: nil
        ) { _ in
            exp.fulfill()
        }
        defer { center.removeObserver(token) }

        BundleBrowserScrollDirectionPreference.persist(
            .natural,
            defaults: defaults,
            notificationCenter: center
        )

        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(
            defaults.string(forKey: BundleBrowserScrollDirectionPreference.defaultsKey),
            ScrollDirectionPreference.natural.rawValue
        )
        XCTAssertNil(defaults.string(forKey: BundleBrowserPanelLayout.defaultsKey))
    }
}
