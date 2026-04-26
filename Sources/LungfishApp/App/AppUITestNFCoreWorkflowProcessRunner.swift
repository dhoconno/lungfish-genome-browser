import Foundation

@MainActor
struct AppUITestNFCoreWorkflowProcessRunner: NFCoreWorkflowProcessRunning {
    func runNextflow(arguments: [String], workingDirectory: URL) async throws -> NFCoreWorkflowProcessResult {
        AppUITestConfiguration.current.appendEvent("nfcore.cli.invoked \(arguments.joined(separator: " "))")
        if let bundlePath = value(after: "--bundle-path", in: arguments) {
            let bundleURL = URL(fileURLWithPath: bundlePath)
            let logsURL = bundleURL.appendingPathComponent("logs", isDirectory: true)
            let reportsURL = bundleURL.appendingPathComponent("reports", isDirectory: true)
            try FileManager.default.createDirectory(at: logsURL, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: reportsURL, withIntermediateDirectories: true)
            try "deterministic nf-core stdout".write(
                to: logsURL.appendingPathComponent("stdout.log"),
                atomically: true,
                encoding: .utf8
            )
            try "deterministic nf-core stderr".write(
                to: logsURL.appendingPathComponent("stderr.log"),
                atomically: true,
                encoding: .utf8
            )
            try "<html><body>nf-core report</body></html>".write(
                to: reportsURL.appendingPathComponent("multiqc_report.html"),
                atomically: true,
                encoding: .utf8
            )
        }
        return NFCoreWorkflowProcessResult(
            exitCode: 0,
            standardOutput: "deterministic nf-core completed",
            standardError: ""
        )
    }

    private func value(after flag: String, in arguments: [String]) -> String? {
        guard let index = arguments.firstIndex(of: flag),
              arguments.indices.contains(arguments.index(after: index)) else {
            return nil
        }
        return arguments[arguments.index(after: index)]
    }
}
