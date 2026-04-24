import XCTest
import LungfishIO
@testable import LungfishApp

final class BuiltInPrimerSchemeServiceTests: XCTestCase {
    func testListBuiltInSchemesReturnsBundledSchemes() throws {
        let schemes = BuiltInPrimerSchemeService.listBuiltInSchemes(in: Bundle.module)
        XCTAssertFalse(schemes.isEmpty, "expected at least one built-in primer scheme")
        XCTAssertTrue(schemes.contains { $0.manifest.name == "test-builtin" })
    }
}
