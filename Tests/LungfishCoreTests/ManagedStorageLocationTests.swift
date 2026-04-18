import XCTest
@testable import LungfishCore

final class ManagedStorageLocationTests: XCTestCase {
    func testDefaultLocationUsesDotLungfishRoot() {
        let home = URL(fileURLWithPath: "/Users/tester", isDirectory: true)
        let location = ManagedStorageLocation.defaultLocation(homeDirectory: home)

        XCTAssertEqual(location.rootURL.path, "/Users/tester/.lungfish")
        XCTAssertEqual(location.condaRootURL.path, "/Users/tester/.lungfish/conda")
        XCTAssertEqual(location.databaseRootURL.path, "/Users/tester/.lungfish/databases")
    }

    func testValidationRejectsResolvedPathsContainingSpaces() {
        let base = URL(fileURLWithPath: "/Volumes/My SSD/Lungfish", isDirectory: true)
        let result = ManagedStorageLocation.validateSelection(base)

        XCTAssertEqual(result, .invalid(.containsSpaces))
        XCTAssertEqual(
            ManagedStorageLocation.ValidationError.containsSpaces.errorDescription,
            "The selected location resolves to a path with spaces. Managed tool installs still require a space-free path, so choose a folder whose full path has no spaces or rename the external volume."
        )
    }

    func testValidationRejectsProjectNestedPath() {
        let base = URL(fileURLWithPath: "/Users/tester/Project.lungfish/Support", isDirectory: true)
        let result = ManagedStorageLocation.validateSelection(base)

        XCTAssertEqual(result, .invalid(.nestedInsideProject))
    }
}
