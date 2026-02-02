// DownloadFlowTests.swift - Tests for async loading patterns
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishCore
@testable import LungfishIO

/// Tests for the async loading patterns used by NCBI downloads
final class DownloadFlowTests: XCTestCase {

    /// Test that GenBankReader loads files correctly
    func testGenBankLoadingAsync() async throws {
        // Create a temporary GenBank file
        let tempDir = FileManager.default.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("test_download_\(UUID().uuidString).gb")

        // Write minimal GenBank content
        let genBankContent = """
        LOCUS       TEST_SEQ                 100 bp    DNA     linear   UNK
        DEFINITION  Test sequence for download flow
        ACCESSION   TEST001
        VERSION     TEST001.1
        FEATURES             Location/Qualifiers
             gene            1..50
                             /gene="testGene"
        ORIGIN
                1 atgcatgcat gcatgcatgc atgcatgcat gcatgcatgc atgcatgcat
               51 gcatgcatgc atgcatgcat gcatgcatgc atgcatgcat gcatgcatgc
        //
        """

        try genBankContent.write(to: testFile, atomically: true, encoding: .utf8)
        defer { try? FileManager.default.removeItem(at: testFile) }

        // Test GenBankReader directly
        let reader = try GenBankReader(url: testFile)
        let records = try await reader.readAll()

        XCTAssertEqual(records.count, 1, "Should have 1 record")
        XCTAssertEqual(records[0].sequence.length, 100, "Sequence should be 100 bp")
        XCTAssertFalse(records[0].annotations.isEmpty, "Should have annotations")

        print("✓ GenBank loading works correctly")
    }

    /// Test that Task created from DispatchQueue.main.asyncAfter executes
    func testTaskFromDispatchQueue() async throws {
        let expectation = XCTestExpectation(description: "Task should execute")

        // This simulates what happens in handleDownloadedFile
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            Task {
                // Simulate async work
                try? await Task.sleep(nanoseconds: 10_000_000) // 10ms
                expectation.fulfill()
            }
        }

        await fulfillment(of: [expectation], timeout: 2.0)
        print("✓ Task from DispatchQueue.main.asyncAfter executes correctly")
    }

    /// Test that Task created from DispatchQueue.main.asyncAfter can load files
    func testTaskFromDispatchQueueLoadsFile() async throws {
        // Create a temporary GenBank file
        let tempDir = FileManager.default.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("test_dispatch_\(UUID().uuidString).gb")

        let genBankContent = """
        LOCUS       DISPATCH_TEST              50 bp    DNA     linear   UNK
        DEFINITION  Test for dispatch queue loading
        ACCESSION   DT001
        VERSION     DT001.1
        ORIGIN
                1 atgcatgcat gcatgcatgc atgcatgcat gcatgcatgc atgcatgcat
        //
        """

        try genBankContent.write(to: testFile, atomically: true, encoding: .utf8)
        defer { try? FileManager.default.removeItem(at: testFile) }

        let expectation = XCTestExpectation(description: "File should load")
        var loadedSequenceCount = 0

        // Simulate the exact pattern used in loadDownloadedFile
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            Task {
                do {
                    let reader = try GenBankReader(url: testFile)
                    let records = try await reader.readAll()
                    loadedSequenceCount = records.count
                    print("Loaded \(loadedSequenceCount) sequences")
                    expectation.fulfill()
                } catch {
                    XCTFail("Loading failed: \(error)")
                    expectation.fulfill()
                }
            }
        }

        await fulfillment(of: [expectation], timeout: 5.0)
        XCTAssertEqual(loadedSequenceCount, 1, "Should have loaded 1 sequence")
        print("✓ Task from DispatchQueue loads files correctly")
    }

    /// Test the complete flow: copy file, then load via DispatchQueue pattern
    func testCompleteDownloadFlow() async throws {
        // Create a "downloaded" file in temp
        let tempDir = FileManager.default.temporaryDirectory
        let sourceFile = tempDir.appendingPathComponent("source_\(UUID().uuidString).gb")
        let destDir = tempDir.appendingPathComponent("downloads_test_\(UUID().uuidString)")
        let destFile = destDir.appendingPathComponent("downloaded.gb")

        let genBankContent = """
        LOCUS       NC_045512               120 bp    DNA     linear   VRL
        DEFINITION  SARS-CoV-2 isolate test
        ACCESSION   NC_045512
        VERSION     NC_045512.2
        FEATURES             Location/Qualifiers
             source          1..120
                             /organism="SARS-CoV-2"
             gene            1..60
                             /gene="orf1ab"
        ORIGIN
                1 attaaaggtt tataccttcc caggtaacaa accaaccaac tttcgatctc ttgtagatct
               61 gttctctaaa cgaactttaa aatctgtgtg gctgtcactc ggctgcatgc ttagtgcact
        //
        """

        try genBankContent.write(to: sourceFile, atomically: true, encoding: .utf8)
        defer {
            try? FileManager.default.removeItem(at: sourceFile)
            try? FileManager.default.removeItem(at: destDir)
        }

        // Step 1: Copy file (simulating handleDownloadedFile)
        try FileManager.default.createDirectory(at: destDir, withIntermediateDirectories: true)
        try FileManager.default.copyItem(at: sourceFile, to: destFile)
        print("Copied file to: \(destFile.path)")

        // Step 2: Load via DispatchQueue pattern (simulating loadDownloadedFile)
        let expectation = XCTestExpectation(description: "Document should load")
        var loadedName: String?
        var loadedSequenceCount = 0
        var loadedAnnotationCount = 0

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("DispatchQueue block executing...")
            Task {
                print("Task starting...")
                do {
                    let reader = try GenBankReader(url: destFile)
                    let records = try await reader.readAll()
                    print("Loaded \(records.count) records")

                    if let first = records.first {
                        loadedName = first.sequence.name
                        loadedSequenceCount = records.count
                        loadedAnnotationCount = records.flatMap { $0.annotations }.count
                        print("Document: name=\(loadedName ?? "nil"), seqs=\(loadedSequenceCount), annots=\(loadedAnnotationCount)")
                    }
                    expectation.fulfill()
                } catch {
                    print("Load failed: \(error)")
                    XCTFail("Loading failed: \(error)")
                    expectation.fulfill()
                }
            }
            print("Task created")
        }

        await fulfillment(of: [expectation], timeout: 10.0)

        XCTAssertNotNil(loadedName, "Document should have been loaded")
        XCTAssertEqual(loadedSequenceCount, 1, "Should have 1 sequence")
        XCTAssertGreaterThan(loadedAnnotationCount, 0, "Should have annotations")

        print("✓ Complete download flow works correctly")
    }
}
