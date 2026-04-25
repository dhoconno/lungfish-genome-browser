import XCTest
import LungfishIO
@testable import LungfishApp

final class CLIPrimerTrimRunnerTests: XCTestCase {
    func testBuildCLIArgumentsIncludesAllRequiredFlags() {
        let arguments = CLIPrimerTrimRunner.buildCLIArguments(
            bundleURL: URL(fileURLWithPath: "/tmp/proj/Sample.lungfishref"),
            alignmentTrackID: "aln-1",
            schemeURL: URL(fileURLWithPath: "/tmp/QIASeq.lungfishprimers"),
            outputTrackName: "Primer-trimmed Sample"
        )

        XCTAssertEqual(arguments[0], "bam")
        XCTAssertEqual(arguments[1], "primer-trim")
        XCTAssertTrue(arguments.contains("--bundle"))
        XCTAssertTrue(arguments.contains("/tmp/proj/Sample.lungfishref"))
        XCTAssertTrue(arguments.contains("--alignment-track"))
        XCTAssertTrue(arguments.contains("aln-1"))
        XCTAssertTrue(arguments.contains("--scheme"))
        XCTAssertTrue(arguments.contains("/tmp/QIASeq.lungfishprimers"))
        XCTAssertTrue(arguments.contains("--name"))
        XCTAssertTrue(arguments.contains("Primer-trimmed Sample"))
        XCTAssertTrue(arguments.contains("--format"))
        XCTAssertTrue(arguments.contains("json"))
    }

    func testParseEventDecodesRunStart() throws {
        let line = #"{"event":"runStart","message":"Starting primer trim"}"#
        let event = try XCTUnwrap(CLIPrimerTrimRunner.parseEvent(from: line))
        guard case .runStart(let message) = event else {
            XCTFail("Expected .runStart, got \(event)")
            return
        }
        XCTAssertEqual(message, "Starting primer trim")
    }

    func testParseEventDecodesStageProgress() throws {
        let line = #"{"event":"stageProgress","progress":0.45,"message":"trim 45%"}"#
        let event = try XCTUnwrap(CLIPrimerTrimRunner.parseEvent(from: line))
        guard case .stageProgress(let progress, let message) = event else {
            XCTFail("Expected .stageProgress, got \(event)")
            return
        }
        XCTAssertEqual(progress, 0.45, accuracy: 0.0001)
        XCTAssertEqual(message, "trim 45%")
    }

    func testParseEventDecodesRunComplete() throws {
        let line = #"""
        {"event":"runComplete","progress":1.0,"message":"Primer trim complete","bundlePath":"/tmp/p.lungfishref","sourceAlignmentTrackID":"aln-source","outputAlignmentTrackID":"aln-trimmed","outputAlignmentTrackName":"Trimmed","bamPath":"/tmp/p.lungfishref/alignments/primer-trimmed/x.bam","baiPath":"/tmp/p.lungfishref/alignments/primer-trimmed/x.bam.bai","provenanceSidecarPath":"/tmp/p.lungfishref/alignments/primer-trimmed/x.primer-trim-provenance.json"}
        """#
        let event = try XCTUnwrap(CLIPrimerTrimRunner.parseEvent(from: line))
        guard case .runComplete(let trackID, let trackName, let bamPath, _, _) = event else {
            XCTFail("Expected .runComplete, got \(event)")
            return
        }
        XCTAssertEqual(trackID, "aln-trimmed")
        XCTAssertEqual(trackName, "Trimmed")
        XCTAssertTrue(bamPath.hasSuffix("x.bam"))
    }

    func testParseEventReturnsNilForNonJSONLine() throws {
        XCTAssertNil(try CLIPrimerTrimRunner.parseEvent(from: "Starting primer trim"))
        XCTAssertNil(try CLIPrimerTrimRunner.parseEvent(from: ""))
    }

    func testParseEventReturnsNilForUnknownEvent() throws {
        let line = #"{"event":"madeUpEvent","message":"x"}"#
        XCTAssertNil(try CLIPrimerTrimRunner.parseEvent(from: line))
    }
}
