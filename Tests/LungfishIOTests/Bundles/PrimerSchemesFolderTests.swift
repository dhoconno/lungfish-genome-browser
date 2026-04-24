import XCTest
@testable import LungfishIO

final class PrimerSchemesFolderTests: XCTestCase {
    func testEnsureFolderCreatesPrimerSchemesDirectory() throws {
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: tmp, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tmp) }

        let url = try PrimerSchemesFolder.ensureFolder(in: tmp)
        XCTAssertEqual(url.lastPathComponent, "Primer Schemes")
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }

    func testListReturnsBundlesSortedByName() throws {
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: tmp, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tmp) }

        let folder = try PrimerSchemesFolder.ensureFolder(in: tmp)

        // Copy the fixture bundle twice with different names.
        let fixture = Bundle.module.url(
            forResource: "primerschemes/valid-simple.lungfishprimers",
            withExtension: nil
        )!
        try FileManager.default.copyItem(
            at: fixture,
            to: folder.appendingPathComponent("ZZZ.lungfishprimers", isDirectory: true)
        )
        try FileManager.default.copyItem(
            at: fixture,
            to: folder.appendingPathComponent("AAA.lungfishprimers", isDirectory: true)
        )

        let bundles = PrimerSchemesFolder.listBundles(in: tmp)
        XCTAssertEqual(bundles.count, 2)
        XCTAssertEqual(bundles.first?.url.lastPathComponent, "AAA.lungfishprimers")
        XCTAssertEqual(bundles.last?.url.lastPathComponent, "ZZZ.lungfishprimers")
    }
}
