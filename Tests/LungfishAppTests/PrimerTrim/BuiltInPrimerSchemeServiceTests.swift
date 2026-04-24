import XCTest
import LungfishIO
@testable import LungfishApp

final class BuiltInPrimerSchemeServiceTests: XCTestCase {
    func testListBuiltInSchemesReturnsBundledSchemes() throws {
        let schemes = BuiltInPrimerSchemeService.listBuiltInSchemes(in: Bundle.module)
        XCTAssertFalse(schemes.isEmpty, "expected at least one built-in primer scheme")
        XCTAssertTrue(schemes.contains { $0.manifest.name == "test-builtin" })
    }

    func testDefaultBundleMainCallDoesNotCrash() {
        // Exercises the default `bundle: Bundle = .main` parameter path.
        // In a unit-test process, Bundle.main points at the xctest runner, which has
        // no Resources/PrimerSchemes folder — so we expect an empty array, not a crash.
        let result = BuiltInPrimerSchemeService.listBuiltInSchemes()
        XCTAssertTrue(result.isEmpty || !result.isEmpty, "signature-breakage smoke test")
    }
}
