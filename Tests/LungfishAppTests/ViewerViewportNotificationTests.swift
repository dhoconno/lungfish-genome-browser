import XCTest
@testable import LungfishApp
import LungfishCore

@MainActor
final class ViewerViewportNotificationTests: XCTestCase {
    func testPrimaryViewerPublishesContentModeChanges() {
        let viewer = ViewerViewController()
        let notification = XCTNSNotificationExpectation(
            name: .viewportContentModeDidChange,
            object: viewer
        )

        viewer.contentMode = .mapping

        wait(for: [notification], timeout: 0.1)
    }

    func testEmbeddedViewerSuppressesContentModeChanges() {
        let viewer = ViewerViewController()
        viewer.publishesGlobalViewportNotifications = false

        let notification = XCTNSNotificationExpectation(
            name: .viewportContentModeDidChange,
            object: viewer
        )
        notification.isInverted = true

        viewer.contentMode = .mapping

        wait(for: [notification], timeout: 0.1)
    }

    func testEmbeddedViewerSuppressesBundleLoadNotifications() {
        let viewer = ViewerViewController()
        viewer.publishesGlobalViewportNotifications = false

        let notification = XCTNSNotificationExpectation(
            name: .bundleDidLoad,
            object: viewer
        )
        notification.isInverted = true

        viewer.publishBundleDidLoadNotification(
            userInfo: [NotificationUserInfoKey.bundleURL: URL(fileURLWithPath: "/tmp/example.lungfishref")]
        )

        wait(for: [notification], timeout: 0.1)
    }
}
