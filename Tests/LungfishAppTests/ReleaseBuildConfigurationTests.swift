import Foundation
import Testing

@Suite("Release Build Configuration")
struct ReleaseBuildConfigurationTests {

    @Test("Xcode Release configuration pins arm64 only")
    func xcodeReleaseConfigurationPinsArm64Only() throws {
        let project = try String(
            contentsOf: Self.repositoryRoot()
                .appendingPathComponent("Lungfish.xcodeproj/project.pbxproj"),
            encoding: .utf8
        )
        let releaseBlock = try Self.buildConfigurationBlock(
            named: "F1E2D3C4B5A6978877665559 /* Release */",
            in: project
        )

        #expect(releaseBlock.contains("ARCHS = arm64;"))
        #expect(releaseBlock.contains("EXCLUDED_ARCHS = x86_64;"))
        #expect(releaseBlock.contains("ONLY_ACTIVE_ARCH = YES;"))
        #expect(releaseBlock.contains("ENABLE_HARDENED_RUNTIME = YES;"))
    }

    @Test("Fallback build-app script builds arm64 release binary")
    func buildAppScriptBuildsArm64ReleaseBinary() throws {
        let script = try String(
            contentsOf: Self.repositoryRoot()
                .appendingPathComponent("scripts/build-app.sh"),
            encoding: .utf8
        )

        #expect(script.contains("swift build -c release --arch arm64"))
        #expect(script.contains(".build/arm64-apple-macosx/release"))
    }

    @Test("Native tool bundler defaults to arm64")
    func nativeToolBundlerDefaultsToArm64() throws {
        let script = try String(
            contentsOf: Self.repositoryRoot()
                .appendingPathComponent("scripts/bundle-native-tools.sh"),
            encoding: .utf8
        )

        #expect(script.contains("TARGET_ARCH=\"arm64\""))
        #expect(script.contains("default: arm64"))
    }

    @Test("Native tool bundler applies prefix maps to scrub builder paths")
    func nativeToolBundlerAppliesPrefixMapsToScrubBuilderPaths() throws {
        let script = try String(
            contentsOf: Self.repositoryRoot()
                .appendingPathComponent("scripts/bundle-native-tools.sh"),
            encoding: .utf8
        )

        #expect(script.contains("ffile-prefix-map"))
        #expect(script.contains("fdebug-prefix-map"))
    }

    @Test("Release tools sanitizer preserves wrappers and strips resource executables")
    func releaseToolsSanitizerPreservesWrappersAndStripsResourceExecutables() throws {
        let repositoryRoot = Self.repositoryRoot()
        let sanitizerURL = repositoryRoot.appendingPathComponent("scripts/sanitize-bundled-tools.sh")
        #expect(FileManager.default.fileExists(atPath: sanitizerURL.path))

        let tempRoot = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let toolsRoot = tempRoot.appendingPathComponent("Tools", isDirectory: true)
        let bbtoolsDir = toolsRoot.appendingPathComponent("bbtools", isDirectory: true)
        let scrubberScriptsDir = toolsRoot
            .appendingPathComponent("scrubber/scripts", isDirectory: true)
        let configDir = bbtoolsDir.appendingPathComponent("config", isDirectory: true)
        try FileManager.default.createDirectory(at: configDir, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: scrubberScriptsDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempRoot) }

        let bbdukURL = bbtoolsDir.appendingPathComponent("bbduk.sh")
        try "#!/bin/bash\nexit 0\n".write(to: bbdukURL, atomically: true, encoding: .utf8)
        try Self.makeExecutable(bbdukURL)

        let scrubberHelperURL = scrubberScriptsDir.appendingPathComponent("cut_spots_fastq.py")
        try "#!/usr/bin/env python3\nprint('ok')\n".write(to: scrubberHelperURL, atomically: true, encoding: .utf8)
        try Self.makeExecutable(scrubberHelperURL)

        let configURL = configDir.appendingPathComponent("histograms.txt")
        try "histogram=true\n".write(to: configURL, atomically: true, encoding: .utf8)
        try Self.makeExecutable(configURL)

        let machOURL = toolsRoot.appendingPathComponent("samtools")
        try FileManager.default.copyItem(at: URL(fileURLWithPath: "/bin/ls"), to: machOURL)
        try Self.makeExecutable(machOURL)

        try Self.runScript(sanitizerURL, arguments: [toolsRoot.path])

        #expect(FileManager.default.isExecutableFile(atPath: bbdukURL.path))
        #expect(FileManager.default.isExecutableFile(atPath: scrubberHelperURL.path))
        #expect(FileManager.default.isExecutableFile(atPath: machOURL.path))
        #expect(FileManager.default.isExecutableFile(atPath: configURL.path) == false)
    }

    @Test("Release tools sanitizer removes BBTools build-only helper scripts")
    func releaseToolsSanitizerRemovesBBToolsBuildOnlyHelperScripts() throws {
        let repositoryRoot = Self.repositoryRoot()
        let sanitizerURL = repositoryRoot.appendingPathComponent("scripts/sanitize-bundled-tools.sh")
        #expect(FileManager.default.fileExists(atPath: sanitizerURL.path))

        let tempRoot = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let bbtoolsDir = tempRoot.appendingPathComponent("Tools/bbtools", isDirectory: true)
        try FileManager.default.createDirectory(at: bbtoolsDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempRoot) }

        let buildEnvSetupURL = bbtoolsDir.appendingPathComponent("build_env_setup.sh")
        try "export PREFIX=/Users/dho/miniforge3\n".write(
            to: buildEnvSetupURL,
            atomically: true,
            encoding: .utf8
        )
        try Self.makeExecutable(buildEnvSetupURL)

        let condaBuildURL = bbtoolsDir.appendingPathComponent("conda_build.sh")
        try "source /opt/mambaforge/work/build_env_setup.sh\n".write(
            to: condaBuildURL,
            atomically: true,
            encoding: .utf8
        )
        try Self.makeExecutable(condaBuildURL)

        try Self.runScript(sanitizerURL, arguments: [tempRoot.appendingPathComponent("Tools").path])

        #expect(FileManager.default.fileExists(atPath: buildEnvSetupURL.path) == false)
        #expect(FileManager.default.fileExists(atPath: condaBuildURL.path) == false)
    }

    @Test("Xcode Release build runs tools sanitizer")
    func xcodeReleaseBuildRunsToolsSanitizer() throws {
        let project = try String(
            contentsOf: Self.repositoryRoot()
                .appendingPathComponent("Lungfish.xcodeproj/project.pbxproj"),
            encoding: .utf8
        )

        #expect(project.contains("Sanitize bundled tools"))
        #expect(project.contains("sanitize-bundled-tools.sh"))
        #expect(project.contains(#"if [ \"$CONFIGURATION\" = \"Release\" ]"#))
        #expect(project.contains("INSTALLATION_BUILD_PRODUCTS_LOCATION"))
        #expect(project.contains("UninstalledProducts/macosx"))
        #expect(project.contains("EXECUTABLE_FOLDER_PATH"))
        #expect(
            project.contains(
                """
                F1E2D3C4B5A6978877665567 /* Embed lungfish-cli */,
                \t\t\t\tF1E2D3C4B5A6978877665566 /* Index Help Book */,
                \t\t\t\tF1E2D3C4B5A6978877665568 /* Sanitize bundled tools */,
                """
            )
        )
    }

    @Test("Embed lungfish-cli phase signs CLI with hardened runtime")
    func embedLungfishCLIPhaseSignsCLIWithHardenedRuntime() throws {
        let project = try String(
            contentsOf: Self.repositoryRoot()
                .appendingPathComponent("Lungfish.xcodeproj/project.pbxproj"),
            encoding: .utf8
        )

        #expect(project.contains("Embed lungfish-cli"))
        #expect(project.contains("EXPANDED_CODE_SIGN_IDENTITY"))
        #expect(project.contains("codesign --force --sign"))
        #expect(project.contains("--options runtime"))
        #expect(project.contains("lungfish-cli.entitlements"))
    }

    @Test("Release smoke test script exercises bundled tools")
    func releaseSmokeTestScriptExercisesBundledTools() throws {
        let script = try String(
            contentsOf: Self.repositoryRoot()
                .appendingPathComponent("scripts/smoke-test-release-tools.sh"),
            encoding: .utf8
        )

        #expect(script.contains("bbduk.sh"))
        #expect(script.contains("reformat.sh"))
        #expect(script.contains("clumpify.sh"))
        #expect(script.contains("bbmerge.sh"))
        #expect(script.contains("repair.sh"))
        #expect(script.contains("tadpole.sh"))
        #expect(script.contains("scrub.sh"))
    }

    @Test("Release smoke test validates bundled Java launcher")
    func releaseSmokeTestValidatesBundledJavaLauncher() throws {
        let script = try String(
            contentsOf: Self.repositoryRoot()
                .appendingPathComponent("scripts/smoke-test-release-tools.sh"),
            encoding: .utf8
        )

        #expect(script.contains("jre/bin/java"))
        #expect(script.contains("allow-jit"))
    }

    @Test("Release smoke test resolves ripgrep from PATH instead of /usr/bin")
    func releaseSmokeTestResolvesRipgrepFromPath() throws {
        let script = try String(
            contentsOf: Self.repositoryRoot()
                .appendingPathComponent("scripts/smoke-test-release-tools.sh"),
            encoding: .utf8
        )

        #expect(script.contains("command -v rg"))
        #expect(script.contains("/usr/bin/rg") == false)
    }

    @Test("Notarized DMG release script archives signs notarizes and staples")
    func notarizedDMGReleaseScriptArchivesSignsNotarizesAndStaples() throws {
        let script = try String(
            contentsOf: Self.repositoryRoot()
                .appendingPathComponent("scripts/release/build-notarized-dmg.sh"),
            encoding: .utf8
        )

        #expect(script.contains("xcodebuild -project Lungfish.xcodeproj"))
        #expect(script.contains("--product lungfish-cli"))
        #expect(script.contains("Contents/MacOS/lungfish-cli"))
        #expect(script.contains("notarytool submit"))
        #expect(script.contains("stapler staple"))
        #expect(script.contains("hdiutil create"))
        #expect(script.contains("DMG_PATH"))
        #expect(script.contains("release-metadata.txt"))
    }

    @Test("Notarized DMG release script builds CLI with prefix maps")
    func notarizedDMGReleaseScriptBuildsCLIWithPrefixMaps() throws {
        let script = try String(
            contentsOf: Self.repositoryRoot()
                .appendingPathComponent("scripts/release/build-notarized-dmg.sh"),
            encoding: .utf8
        )

        #expect(script.contains("-debug-prefix-map"))
        #expect(script.contains("-file-compilation-dir"))
        #expect(script.contains("ffile-prefix-map"))
    }

    @Test("Notarized DMG release script sanitizes embedded CLI before signing")
    func notarizedDMGReleaseScriptSanitizesEmbeddedCLIBeforeSigning() throws {
        let script = try String(
            contentsOf: Self.repositoryRoot()
                .appendingPathComponent("scripts/release/build-notarized-dmg.sh"),
            encoding: .utf8
        )

        let sanitizeMarker = #"scripts/sanitize-bundled-tools.sh "$APP_PATH/Contents/MacOS""#

        #expect(script.contains(sanitizeMarker))
        let lines = script.split(separator: "\n", omittingEmptySubsequences: false)
        guard let sanitizeIndex = lines.firstIndex(where: { $0.contains(sanitizeMarker) }),
              let codesignIndex = lines.enumerated().first(where: { index, line in
                  index > sanitizeIndex
                      && line.contains(#"/usr/bin/codesign --force --sign "$SIGNING_IDENTITY""#)
              })?.offset
        else {
            Issue.record("expected CLI sanitizer to run before CLI codesign")
            return
        }

        #expect(sanitizeIndex < codesignIndex)
    }

    @Test("Notarized DMG release script signs JRE launchers with explicit entitlements")
    func notarizedDMGReleaseScriptSignsJRELaunchersWithEntitlements() throws {
        let script = try String(
            contentsOf: Self.repositoryRoot()
                .appendingPathComponent("scripts/release/build-notarized-dmg.sh"),
            encoding: .utf8
        )

        #expect(script.contains("jre-launcher.entitlements"))
        #expect(script.contains("jre/bin/java"))
        #expect(script.contains("jre/bin/keytool"))
        #expect(script.contains("jre/lib/jspawnhelper"))
    }

    @Test("JRE launcher entitlements allow bundled JVM execution under hardened runtime")
    func jreLauncherEntitlementsAllowBundledJVMExecutionUnderHardenedRuntime() throws {
        let entitlements = try String(
            contentsOf: Self.repositoryRoot()
                .appendingPathComponent("scripts/release/jre-launcher.entitlements"),
            encoding: .utf8
        )

        #expect(entitlements.contains("com.apple.security.cs.allow-jit"))
        #expect(entitlements.contains("com.apple.security.cs.allow-unsigned-executable-memory"))
    }

    @Test("Release agent is tracked in repo")
    func releaseAgentIsTrackedInRepo() throws {
        let agent = try String(
            contentsOf: Self.repositoryRoot()
                .appendingPathComponent(".codex/agents/release-agent.md"),
            encoding: .utf8
        )

        #expect(agent.contains("name: release-agent"))
        #expect(agent.contains("scripts/release/build-notarized-dmg.sh"))
        #expect(agent.contains("scripts/smoke-test-release-tools.sh"))
        #expect(agent.contains("notarytool"))
        #expect(agent.contains(".dmg"))
    }

    @Test("Production runtime resource lookups avoid SwiftPM Bundle.module accessors")
    func productionRuntimeResourceLookupsAvoidSwiftPMBundleModuleAccessors() throws {
        let repositoryRoot = Self.repositoryRoot()
        let runtimeSources = [
            "Sources/LungfishWorkflow/Native/NativeToolRunner.swift",
            "Sources/LungfishWorkflow/Databases/DatabaseRegistry.swift",
            "Sources/LungfishWorkflow/Conda/CondaManager.swift",
            "Sources/LungfishWorkflow/Engines/AppleContainerRuntime.swift",
            "Sources/LungfishWorkflow/Metagenomics/NaoMgsSamplePartitioner.swift",
            "Sources/LungfishWorkflow/Recipes/RecipeRegistry.swift",
            "Sources/LungfishApp/Views/Help/HelpWindowController.swift",
            "Sources/LungfishApp/Views/Welcome/WelcomeWindowController.swift",
            "Sources/LungfishApp/App/AppIcon.swift",
            "Sources/LungfishApp/App/AboutWindowController.swift",
        ]

        for relativePath in runtimeSources {
            let source = try String(
                contentsOf: repositoryRoot.appendingPathComponent(relativePath),
                encoding: .utf8
            )
            #expect(source.contains("Bundle.module") == false, "\(relativePath) still references Bundle.module")
        }
    }

    @Test("Release GUI runtime avoids compile-time source path fallbacks")
    func releaseGUIRuntimeAvoidsCompileTimeSourcePathFallbacks() throws {
        let source = try String(
            contentsOf: Self.repositoryRoot()
                .appendingPathComponent("Sources/LungfishApp/Services/CLIImportRunner.swift"),
            encoding: .utf8
        )

        #expect(source.contains("#filePath") == false)
    }

    @Test("Release tools sanitizer scrubs builder paths from bundled executables")
    func releaseToolsSanitizerScrubsBuilderPathsFromBundledExecutables() throws {
        let repositoryRoot = Self.repositoryRoot()
        let sanitizerURL = repositoryRoot.appendingPathComponent("scripts/sanitize-bundled-tools.sh")
        #expect(FileManager.default.fileExists(atPath: sanitizerURL.path))

        let tempRoot = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let toolsRoot = tempRoot.appendingPathComponent("Tools", isDirectory: true)
        try FileManager.default.createDirectory(at: toolsRoot, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempRoot) }

        let vendoredBinaryURL = toolsRoot.appendingPathComponent("prefetch")
        try FileManager.default.copyItem(at: URL(fileURLWithPath: "/bin/ls"), to: vendoredBinaryURL)
        let embeddedPaths = [
            "prefix\0/Users/dho/Documents/lungfish-genome-browser/.build/xcode-cli-release/checkouts/test\0",
            "prefix\0/Users/dho/Documents/ncbi-vdb/libs/vfs/resolver.c\0",
        ].joined()
        let handle = try FileHandle(forWritingTo: vendoredBinaryURL)
        try handle.seekToEnd()
        try handle.write(contentsOf: Data(embeddedPaths.utf8))
        try handle.close()
        try Self.makeExecutable(vendoredBinaryURL)

        try Self.runScript(sanitizerURL, arguments: [toolsRoot.path])

        let sanitized = String(decoding: try Data(contentsOf: vendoredBinaryURL), as: UTF8.self)
        #expect(sanitized.contains("/Users/dho") == false)
        #expect(sanitized.contains(".build/xcode-cli-release") == false)
    }

    @Test("Release tools sanitizer scrubs builder paths from standalone executables")
    func releaseToolsSanitizerScrubsBuilderPathsFromStandaloneExecutables() throws {
        let repositoryRoot = Self.repositoryRoot()
        let sanitizerURL = repositoryRoot.appendingPathComponent("scripts/sanitize-bundled-tools.sh")
        #expect(FileManager.default.fileExists(atPath: sanitizerURL.path))

        let tempRoot = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: tempRoot, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempRoot) }

        let cliBinaryURL = tempRoot.appendingPathComponent("lungfish-cli")
        try FileManager.default.copyItem(at: URL(fileURLWithPath: "/bin/ls"), to: cliBinaryURL)
        let embeddedPaths = [
            "prefix\0\(repositoryRoot.path)/.build/xcode-cli-release/arm64-apple-macosx/release/LungfishCLI.build/Main.swift.o\0",
            "prefix\0/workspace/.build/xcode-cli-release/checkouts/swift-nio/Sources/CNIOAtomics/src\0",
        ].joined()
        let handle = try FileHandle(forWritingTo: cliBinaryURL)
        try handle.seekToEnd()
        try handle.write(contentsOf: Data(embeddedPaths.utf8))
        try handle.close()
        try Self.makeExecutable(cliBinaryURL)

        try Self.runScript(sanitizerURL, arguments: [cliBinaryURL.path])

        let sanitized = String(decoding: try Data(contentsOf: cliBinaryURL), as: UTF8.self)
        #expect(sanitized.contains(repositoryRoot.path) == false)
        #expect(sanitized.contains("/Users/dho") == false)
        #expect(sanitized.contains(".build/xcode-cli-release") == false)
    }

    private static func repositoryRoot() -> URL {
        var candidate = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
        for _ in 0..<10 {
            let package = candidate.appendingPathComponent("Package.swift")
            if FileManager.default.fileExists(atPath: package.path) {
                return candidate
            }
            candidate.deleteLastPathComponent()
        }

        fatalError("Cannot locate repository root from \(#filePath)")
    }

    private static func buildConfigurationBlock(named marker: String, in project: String) throws -> String {
        guard let markerRange = project.range(of: marker),
              let blockEnd = project[markerRange.lowerBound...].range(of: "\n\t\t};")
        else {
            throw NSError(domain: "ReleaseBuildConfigurationTests", code: 1)
        }

        return String(project[markerRange.lowerBound..<blockEnd.upperBound])
    }

    private static func makeExecutable(_ url: URL) throws {
        try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: url.path)
    }

    private static func runScript(_ scriptURL: URL, arguments: [String]) throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = [scriptURL.path] + arguments

        let stdout = Pipe()
        let stderr = Pipe()
        process.standardOutput = stdout
        process.standardError = stderr
        try process.run()
        process.waitUntilExit()

        let stderrData = stderr.fileHandleForReading.readDataToEndOfFile()
        let stderrString = String(data: stderrData, encoding: .utf8) ?? ""
        #expect(process.terminationStatus == 0, "script failed: \(stderrString)")
    }
}
