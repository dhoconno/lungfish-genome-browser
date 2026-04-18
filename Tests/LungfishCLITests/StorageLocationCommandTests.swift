import ArgumentParser
import XCTest
import Darwin
@testable import LungfishCLI

final class StorageLocationCommandTests: XCTestCase {
    func testProvisionToolsStatusReportsConfiguredStorageRoot() async throws {
        let root = URL(fileURLWithPath: "/Volumes/Lungfish SSD/custom-storage-root", isDirectory: true)
        let originalOverride = ProvisionToolsCommand.storageRootOverride
        ProvisionToolsCommand.storageRootOverride = root
        defer { ProvisionToolsCommand.storageRootOverride = originalOverride }

        let output = try await captureStandardOutput {
            var command = try ProvisionToolsCommand.parse(["--status"])
            try await command.run()
        }

        XCTAssertTrue(output.contains(root.path), "Expected status output to mention \(root.path), got: \(output)")
    }

    func testCondaPackInstallSurfacesStorageUnavailableError() async throws {
        let root = URL(fileURLWithPath: "/Volumes/Lungfish SSD/conda", isDirectory: true)
        let error = CondaCommand.storageUnavailableValidationError(for: root)

        XCTAssertTrue(error.description.contains("Storage location unavailable"))
        XCTAssertTrue(error.description.contains(root.path))
    }

    private func captureStandardOutput(_ operation: () async throws -> Void) async throws -> String {
        let pipe = Pipe()
        let originalStdout = dup(STDOUT_FILENO)
        dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)

        do {
            try await operation()
            fflush(stdout)
        } catch {
            fflush(stdout)
            dup2(originalStdout, STDOUT_FILENO)
            close(originalStdout)
            pipe.fileHandleForWriting.closeFile()
            throw error
        }

        dup2(originalStdout, STDOUT_FILENO)
        close(originalStdout)
        pipe.fileHandleForWriting.closeFile()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? ""
    }
}
