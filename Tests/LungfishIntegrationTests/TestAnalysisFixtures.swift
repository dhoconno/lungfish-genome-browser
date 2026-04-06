import Foundation

/// Type-safe accessors for analysis result test fixtures.
public enum TestAnalysisFixtures {

    public static let fixturesRoot: URL = {
        if let bundleURL = Bundle.module.resourceURL?
            .appendingPathComponent("Fixtures")
            .appendingPathComponent("analyses") {
            if FileManager.default.fileExists(atPath: bundleURL.path) {
                return bundleURL
            }
        }
        var dir = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
        for _ in 0..<10 {
            let candidate = dir.appendingPathComponent("Tests/Fixtures/analyses")
            if FileManager.default.fileExists(atPath: candidate.path) {
                return candidate
            }
            dir = dir.deletingLastPathComponent()
        }
        fatalError("Cannot locate Tests/Fixtures/analyses/. Run from a test target.")
    }()

    public static var esvirituResult: URL { fixture("esviritu-2026-01-15T10-00-00") }
    public static var kraken2Result: URL { fixture("kraken2-2026-01-15T11-00-00") }
    public static var taxTriageResult: URL { fixture("taxtriage-2026-01-15T12-00-00") }
    public static var spadesResult: URL { fixture("spades-2026-01-15T13-00-00") }
    public static var minimap2Result: URL { fixture("minimap2-2026-01-15T14-00-00") }
    public static var esvirituBatchResult: URL { fixture("esviritu-batch-2026-01-15T15-00-00") }

    public static var sampleManifest: URL {
        let url = fixturesRoot.appendingPathComponent("analyses-manifest.json")
        precondition(FileManager.default.fileExists(atPath: url.path),
                     "Test fixture missing: analyses/analyses-manifest.json")
        return url
    }

    public static func createTempProject() throws -> URL {
        let fm = FileManager.default
        let tempDir = fm.temporaryDirectory
            .appendingPathComponent("test-analyses-\(UUID().uuidString)")
        try fm.createDirectory(at: tempDir, withIntermediateDirectories: true)

        let analysesDir = tempDir.appendingPathComponent("Analyses")
        try fm.createDirectory(at: analysesDir, withIntermediateDirectories: true)

        let fixtureDirs = [
            "esviritu-2026-01-15T10-00-00",
            "kraken2-2026-01-15T11-00-00",
            "taxtriage-2026-01-15T12-00-00",
            "spades-2026-01-15T13-00-00",
            "minimap2-2026-01-15T14-00-00",
            "esviritu-batch-2026-01-15T15-00-00",
        ]
        for dirName in fixtureDirs {
            let src = fixturesRoot.appendingPathComponent(dirName)
            let dst = analysesDir.appendingPathComponent(dirName)
            try fm.copyItem(at: src, to: dst)
        }

        let bundleDir = tempDir.appendingPathComponent("testSample.lungfishfastq")
        try fm.createDirectory(at: bundleDir, withIntermediateDirectories: true)
        try fm.copyItem(
            at: sampleManifest,
            to: bundleDir.appendingPathComponent("analyses-manifest.json")
        )

        return tempDir
    }

    private static func fixture(_ name: String) -> URL {
        let url = fixturesRoot.appendingPathComponent(name)
        precondition(FileManager.default.fileExists(atPath: url.path),
                     "Test fixture missing: analyses/\(name)")
        return url
    }
}
