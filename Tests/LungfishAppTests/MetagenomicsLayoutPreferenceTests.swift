import XCTest
@testable import LungfishApp

@MainActor
final class MetagenomicsLayoutPreferenceTests: XCTestCase {
    func testCurrentLayoutFallsBackToLegacyBoolWhenEnumKeyIsMissing() {
        let suite = "layout-pref-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }

        defaults.set(true, forKey: MetagenomicsPanelLayout.legacyTableOnLeftKey)

        XCTAssertEqual(
            MetagenomicsPanelLayout.current(defaults: defaults),
            .listLeading
        )
    }

    func testPersistWritesEnumRawValueAndPostsLayoutChangeNotification() {
        let suite = "layout-pref-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        let center = NotificationCenter()
        defer { defaults.removePersistentDomain(forName: suite) }

        let exp = expectation(
            forNotification: .metagenomicsLayoutSwapRequested,
            object: nil,
            handler: nil
        )

        MetagenomicsPanelLayout.stacked.persist(
            defaults: defaults,
            notificationCenter: center
        )

        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(
            defaults.string(forKey: MetagenomicsPanelLayout.defaultsKey),
            MetagenomicsPanelLayout.stacked.rawValue
        )
    }
}
