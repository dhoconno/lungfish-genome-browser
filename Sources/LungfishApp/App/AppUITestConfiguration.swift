import Foundation

struct AppUITestConfiguration: Equatable, Sendable {
    let isEnabled: Bool
    let scenarioName: String?

    init(arguments: [String], environment: [String: String]) {
        let explicitFlag = arguments.contains("--ui-test-mode")
        let environmentFlag = environment["LUNGFISH_UI_TEST_MODE"] == "1"

        isEnabled = explicitFlag || environmentFlag
        scenarioName = environment["LUNGFISH_UI_TEST_SCENARIO"]
    }

    static let current = AppUITestConfiguration(
        arguments: ProcessInfo.processInfo.arguments,
        environment: ProcessInfo.processInfo.environment
    )
}
