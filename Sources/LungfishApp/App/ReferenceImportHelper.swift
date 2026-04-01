// ReferenceImportHelper.swift - Headless helper-mode reference importer
// Copyright (c) 2026 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation

/// Helper-mode entrypoint used by the GUI process to import standalone
/// reference sequence files as `.lungfishref` bundles in a subprocess.
public enum ReferenceImportHelper {
    private struct Event: Codable {
        let event: String
        let progress: Double?
        let message: String?
        let bundlePath: String?
        let bundleName: String?
        let error: String?
    }

    public static func runIfRequested(arguments: [String]) -> Int32? {
        guard arguments.contains("--reference-import-helper") else { return nil }

        guard let inputPath = value(for: "--input-file", in: arguments),
              let outputDirPath = value(for: "--output-dir", in: arguments)
        else {
            emit(Event(
                event: "error",
                progress: nil,
                message: nil,
                bundlePath: nil,
                bundleName: nil,
                error: "Missing required helper arguments: --input-file and --output-dir"
            ))
            return 2
        }

        let inputURL = URL(fileURLWithPath: inputPath)
        let outputDirectory = URL(fileURLWithPath: outputDirPath)
        let preferredName = value(for: "--name", in: arguments)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let bundleName = preferredName?.isEmpty == true ? nil : preferredName

        final class ExitCodeBox: @unchecked Sendable {
            var value: Int32 = 0
        }

        let semaphore = DispatchSemaphore(value: 0)
        let exitState = ExitCodeBox()

        Task { @MainActor in
            do {
                emit(Event(
                    event: "started",
                    progress: 0.0,
                    message: "Starting reference import helper...",
                    bundlePath: nil,
                    bundleName: nil,
                    error: nil
                ))

                let result = try await ReferenceBundleImportService.shared.importAsReferenceBundle(
                    sourceURL: inputURL,
                    outputDirectory: outputDirectory,
                    preferredBundleName: bundleName
                ) { progress, message in
                    emit(Event(
                        event: "progress",
                        progress: max(0.0, min(1.0, progress)),
                        message: message,
                        bundlePath: nil,
                        bundleName: nil,
                        error: nil
                    ))
                }

                emit(Event(
                    event: "done",
                    progress: 1.0,
                    message: "Reference import complete",
                    bundlePath: result.bundleURL.path,
                    bundleName: result.bundleName,
                    error: nil
                ))
            } catch {
                exitState.value = 1
                emit(Event(
                    event: "error",
                    progress: nil,
                    message: nil,
                    bundlePath: nil,
                    bundleName: nil,
                    error: error.localizedDescription
                ))
            }
            semaphore.signal()
        }

        semaphore.wait()
        return exitState.value
    }

    private static func value(for flag: String, in arguments: [String]) -> String? {
        guard let flagIndex = arguments.firstIndex(of: flag), flagIndex + 1 < arguments.count else {
            return nil
        }
        return arguments[flagIndex + 1]
    }

    private static func emit(_ event: Event) {
        guard let data = try? JSONEncoder().encode(event),
              var line = String(data: data, encoding: .utf8) else { return }
        line.append("\n")
        if let outputData = line.data(using: .utf8) {
            FileHandle.standardOutput.write(outputData)
        }
    }
}
