// PathoplexusSubmissionTests.swift - Tests for Pathoplexus submission workflow
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishCore

final class PathoplexusSubmissionTests: XCTestCase {

    var mockClient: MockHTTPClient!
    var authenticator: PathoplexusAuthenticator!
    var submitter: PathoplexusSubmitter!

    override func setUp() async throws {
        mockClient = MockHTTPClient()
        authenticator = PathoplexusAuthenticator(httpClient: mockClient)
        submitter = PathoplexusSubmitter(authenticator: authenticator, httpClient: mockClient)
    }

    // MARK: - Helper Methods

    private func createValidToken() -> PathoplexusToken {
        PathoplexusToken(
            accessToken: "valid-access-token",
            refreshToken: "valid-refresh-token",
            expiresAt: Date().addingTimeInterval(3600),
            refreshExpiresAt: Date().addingTimeInterval(7200)
        )
    }

    private func createTempFile(content: String, filename: String) throws -> URL {
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        let fileURL = tempDir.appendingPathComponent(filename)
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
        return fileURL
    }

    // MARK: - List Groups Tests

    func testListGroupsReturnsGroups() async throws {
        let groupsResponse: [[String: Any]] = [
            ["id": "group1", "name": "Test Group 1", "institution": "Test Inst"],
            ["id": "group2", "name": "Test Group 2"]
        ]
        await mockClient.register(pattern: "/groups", response: .json(groupsResponse))

        let token = createValidToken()
        let groups = try await submitter.listGroups(token: token)

        XCTAssertEqual(groups.count, 2)
        XCTAssertEqual(groups[0].id, "group1")
        XCTAssertEqual(groups[0].name, "Test Group 1")
    }

    func testListGroupsSendsAuthHeader() async throws {
        await mockClient.register(pattern: "/groups", response: .json([]))

        let token = createValidToken()
        _ = try await submitter.listGroups(token: token)

        let requests = await mockClient.requests
        XCTAssertEqual(requests.count, 1)

        let authHeader = requests[0].value(forHTTPHeaderField: "Authorization")
        XCTAssertEqual(authHeader, "Bearer valid-access-token")
    }

    func testListGroupsUnauthorized() async throws {
        await mockClient.register(pattern: "/groups", response: .error(statusCode: 401, message: "Unauthorized"))

        let token = createValidToken()

        do {
            _ = try await submitter.listGroups(token: token)
            XCTFail("Should have thrown an error")
        } catch let error as PathoplexusSubmissionError {
            if case .unauthorized = error {
                // Expected
            } else {
                XCTFail("Expected unauthorized error")
            }
        }
    }

    // MARK: - Submission Tests

    func testSubmitReturnsResult() async throws {
        await mockClient.registerPathoplexusSubmission(submissionId: "SUB_12345", status: "AWAITING_APPROVAL")

        let fastaURL = try createTempFile(content: ">seq1\nATGC", filename: "sequences.fasta")
        let metadataURL = try createTempFile(content: "submissionId\tfield1\nseq1\tvalue1", filename: "metadata.tsv")

        defer {
            try? FileManager.default.removeItem(at: fastaURL.deletingLastPathComponent())
        }

        let request = PathoplexusSubmissionRequest(
            organism: "mpox",
            sequencesFile: fastaURL,
            metadataFile: metadataURL,
            groupId: "test-group",
            dataUseTerms: .open
        )

        let token = createValidToken()
        let result = try await submitter.submit(request, token: token)

        XCTAssertEqual(result.submissionId, "SUB_12345")
        XCTAssertEqual(result.status, .awaitingApproval)
        XCTAssertTrue(result.pendingApproval)
    }

    func testSubmitSendsMultipartRequest() async throws {
        await mockClient.registerPathoplexusSubmission(submissionId: "SUB_001")

        let fastaURL = try createTempFile(content: ">seq1\nATGCATGC", filename: "sequences.fasta")
        let metadataURL = try createTempFile(content: "submissionId\nseq1", filename: "metadata.tsv")

        defer {
            try? FileManager.default.removeItem(at: fastaURL.deletingLastPathComponent())
        }

        let request = PathoplexusSubmissionRequest(
            organism: "ebola-zaire",
            sequencesFile: fastaURL,
            metadataFile: metadataURL,
            groupId: "my-group",
            dataUseTerms: .restricted
        )

        let token = createValidToken()
        _ = try await submitter.submit(request, token: token)

        let requests = await mockClient.requests
        XCTAssertEqual(requests.count, 1)

        let contentType = requests[0].value(forHTTPHeaderField: "Content-Type")
        XCTAssertTrue(contentType?.contains("multipart/form-data") ?? false)

        let url = requests[0].url!.absoluteString
        XCTAssertTrue(url.contains("ebola-zaire"))
        XCTAssertTrue(url.contains("submit"))
    }

    func testSubmitWithInvalidOrganism() async throws {
        await mockClient.register(pattern: "/submit", response: .error(statusCode: 404, message: "Not Found"))

        let fastaURL = try createTempFile(content: ">seq1\nATGC", filename: "sequences.fasta")
        let metadataURL = try createTempFile(content: "submissionId\nseq1", filename: "metadata.tsv")

        defer {
            try? FileManager.default.removeItem(at: fastaURL.deletingLastPathComponent())
        }

        let request = PathoplexusSubmissionRequest(
            organism: "invalid-organism",
            sequencesFile: fastaURL,
            metadataFile: metadataURL,
            groupId: "group",
            dataUseTerms: .open
        )

        let token = createValidToken()

        do {
            _ = try await submitter.submit(request, token: token)
            XCTFail("Should have thrown an error")
        } catch let error as PathoplexusSubmissionError {
            if case .invalidOrganism(let org) = error {
                XCTAssertEqual(org, "invalid-organism")
            } else {
                XCTFail("Expected invalidOrganism error")
            }
        }
    }

    func testSubmitWithValidationErrors() async throws {
        let errorResponse: [String: Any] = [
            "errors": [
                ["field": "sequence", "message": "Invalid nucleotide at position 5", "sequenceId": "seq1"],
                ["field": "metadata", "message": "Missing required field"]
            ]
        ]
        await mockClient.register(pattern: "/submit", response: .json(errorResponse, statusCode: 400))

        let fastaURL = try createTempFile(content: ">seq1\nATGXC", filename: "sequences.fasta")
        let metadataURL = try createTempFile(content: "submissionId\nseq1", filename: "metadata.tsv")

        defer {
            try? FileManager.default.removeItem(at: fastaURL.deletingLastPathComponent())
        }

        let request = PathoplexusSubmissionRequest(
            organism: "mpox",
            sequencesFile: fastaURL,
            metadataFile: metadataURL,
            groupId: "group",
            dataUseTerms: .open
        )

        let token = createValidToken()

        do {
            _ = try await submitter.submit(request, token: token)
            XCTFail("Should have thrown an error")
        } catch let error as PathoplexusSubmissionError {
            if case .validationFailed(let errors) = error {
                XCTAssertEqual(errors.count, 2)
                XCTAssertEqual(errors[0].field, "sequence")
                XCTAssertEqual(errors[0].sequenceId, "seq1")
            } else {
                XCTFail("Expected validationFailed error")
            }
        }
    }

    // MARK: - In-Memory Submission Tests

    func testSubmitEntriesCreatesFiles() async throws {
        await mockClient.registerPathoplexusSubmission(submissionId: "SUB_MEM")

        let entries = [
            SubmissionEntry(
                submissionId: "seq1",
                sequence: "ATGCATGCATGC",
                metadata: SubmissionMetadata(
                    sampleCollectionDate: "2024-01-15",
                    geoLocCountry: "USA"
                )
            ),
            SubmissionEntry(
                submissionId: "seq2",
                sequence: "GCTAGCTAGCTA",
                metadata: SubmissionMetadata(
                    sampleCollectionDate: "2024-01-20",
                    geoLocCountry: "Canada"
                )
            )
        ]

        let token = createValidToken()
        let result = try await submitter.submit(
            entries: entries,
            organism: "mpox",
            groupId: "test-group",
            dataUseTerms: .open,
            token: token
        )

        XCTAssertEqual(result.submissionId, "SUB_MEM")
    }

    // MARK: - Revision Tests

    func testReviseSubmission() async throws {
        await mockClient.register(pattern: "/revise/", response: .text("", statusCode: 204))

        let fastaURL = try createTempFile(content: ">seq1\nATGCATGC", filename: "sequences.fasta")

        defer {
            try? FileManager.default.removeItem(at: fastaURL.deletingLastPathComponent())
        }

        let token = createValidToken()

        try await submitter.revise(
            submissionId: "SUB_123",
            sequencesFile: fastaURL,
            metadataFile: nil,
            organism: "mpox",
            token: token
        )

        let requests = await mockClient.requests
        XCTAssertEqual(requests.count, 1)

        let url = requests[0].url!.absoluteString
        XCTAssertTrue(url.contains("revise"))
        XCTAssertTrue(url.contains("SUB_123"))
    }

    func testReviseNotFound() async throws {
        await mockClient.register(pattern: "/revise/", response: .error(statusCode: 404, message: "Not Found"))

        let token = createValidToken()

        do {
            try await submitter.revise(
                submissionId: "NONEXISTENT",
                sequencesFile: nil,
                metadataFile: nil,
                organism: "mpox",
                token: token
            )
            XCTFail("Should have thrown an error")
        } catch let error as PathoplexusSubmissionError {
            if case .revisionFailed(let reason) = error {
                XCTAssertTrue(reason.contains("NONEXISTENT"))
            } else {
                XCTFail("Expected revisionFailed error")
            }
        }
    }

    // MARK: - Approval Tests

    func testApproveSubmission() async throws {
        await mockClient.register(pattern: "/approve/", response: .text("", statusCode: 200))

        let token = createValidToken()

        try await submitter.approve(
            submissionId: "SUB_PENDING",
            organism: "mpox",
            token: token
        )

        let requests = await mockClient.requests
        XCTAssertEqual(requests.count, 1)

        let url = requests[0].url!.absoluteString
        XCTAssertTrue(url.contains("approve"))
        XCTAssertTrue(url.contains("SUB_PENDING"))
    }

    func testApproveUnauthorized() async throws {
        await mockClient.register(pattern: "/approve/", response: .error(statusCode: 403, message: "Forbidden"))

        let token = createValidToken()

        do {
            try await submitter.approve(
                submissionId: "SUB_123",
                organism: "mpox",
                token: token
            )
            XCTFail("Should have thrown an error")
        } catch let error as PathoplexusSubmissionError {
            if case .approvalFailed(let reason) = error {
                XCTAssertTrue(reason.lowercased().contains("not authorized"))
            } else {
                XCTFail("Expected approvalFailed error")
            }
        }
    }
}

// MARK: - SubmissionMetadata Tests

final class SubmissionMetadataTests: XCTestCase {

    func testToTSVRowBasicFields() {
        let metadata = SubmissionMetadata(
            sampleCollectionDate: "2024-01-15",
            geoLocCountry: "USA",
            host: "Homo sapiens"
        )

        let columns = ["submissionId", "sampleCollectionDate", "geoLocCountry", "host"]
        let row = metadata.toTSVRow(submissionId: "seq1", columns: columns)

        let values = row.split(separator: "\t").map(String.init)
        XCTAssertEqual(values[0], "seq1")
        XCTAssertEqual(values[1], "2024-01-15")
        XCTAssertEqual(values[2], "USA")
        XCTAssertEqual(values[3], "Homo sapiens")
    }

    func testToTSVRowWithCustomFields() {
        var metadata = SubmissionMetadata()
        metadata.customFields["clade"] = "IIb"
        metadata.customFields["lineage"] = "B.1"

        let columns = ["submissionId", "clade", "lineage"]
        let row = metadata.toTSVRow(submissionId: "test", columns: columns)

        let values = row.split(separator: "\t").map(String.init)
        XCTAssertEqual(values[1], "IIb")
        XCTAssertEqual(values[2], "B.1")
    }

    func testToTSVRowWithMissingFields() {
        let metadata = SubmissionMetadata(geoLocCountry: "UK")

        let columns = ["submissionId", "sampleCollectionDate", "geoLocCountry", "host"]
        let row = metadata.toTSVRow(submissionId: "seq1", columns: columns)

        // Missing fields should be empty strings
        XCTAssertTrue(row.contains("\t\t"))  // Empty date and host
    }

    func testMetadataCodable() throws {
        let metadata = SubmissionMetadata(
            sampleCollectionDate: "2024-01-15",
            geoLocCountry: "Germany",
            authors: "Smith J"
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(metadata)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(SubmissionMetadata.self, from: data)

        XCTAssertEqual(decoded.sampleCollectionDate, "2024-01-15")
        XCTAssertEqual(decoded.geoLocCountry, "Germany")
        XCTAssertEqual(decoded.authors, "Smith J")
    }
}

// MARK: - MetadataTemplateGenerator Tests

final class MetadataTemplateGeneratorTests: XCTestCase {

    func testGenerateTemplateIncludesStandardColumns() {
        let template = MetadataTemplateGenerator.generateTemplate(for: "mpox")

        XCTAssertTrue(template.contains("submissionId"))
        XCTAssertTrue(template.contains("sampleCollectionDate"))
        XCTAssertTrue(template.contains("geoLocCountry"))
        XCTAssertTrue(template.contains("authors"))
    }

    func testGenerateTemplateIncludesOrganismSpecificColumns() {
        let mpoxTemplate = MetadataTemplateGenerator.generateTemplate(for: "mpox")
        XCTAssertTrue(mpoxTemplate.contains("clade"))
        XCTAssertTrue(mpoxTemplate.contains("lineage"))

        let cchfTemplate = MetadataTemplateGenerator.generateTemplate(for: "cchf")
        XCTAssertTrue(cchfTemplate.contains("segment"))
    }

    func testGenerateSampleRow() {
        let sample = MetadataTemplateGenerator.generateSampleRow(for: "mpox")

        XCTAssertTrue(sample.contains("sample_001"))
        XCTAssertTrue(sample.contains("2024-01-15"))
        XCTAssertTrue(sample.contains("USA"))
    }
}

// MARK: - SubmissionValidationError Tests

final class SubmissionValidationErrorTests: XCTestCase {

    func testDescriptionWithSequenceId() {
        let error = SubmissionValidationError(
            field: "sequence",
            message: "Invalid character at position 5",
            sequenceId: "seq1"
        )

        XCTAssertTrue(error.description.contains("[seq1]"))
        XCTAssertTrue(error.description.contains("sequence"))
        XCTAssertTrue(error.description.contains("Invalid character"))
    }

    func testDescriptionWithoutSequenceId() {
        let error = SubmissionValidationError(
            field: "metadata",
            message: "Missing required field"
        )

        XCTAssertFalse(error.description.contains("["))
        XCTAssertTrue(error.description.contains("metadata"))
    }
}

// MARK: - SubmissionStatus Tests

final class SubmissionStatusTests: XCTestCase {

    func testAllStatusesHaveRawValues() {
        let statuses: [SubmissionStatus] = [
            .draft, .submitted, .processing, .awaitingApproval,
            .approved, .rejected, .hasErrors
        ]

        for status in statuses {
            XCTAssertFalse(status.rawValue.isEmpty)
        }
    }

    func testStatusFromRawValue() {
        XCTAssertEqual(SubmissionStatus(rawValue: "DRAFT"), .draft)
        XCTAssertEqual(SubmissionStatus(rawValue: "AWAITING_APPROVAL"), .awaitingApproval)
        XCTAssertEqual(SubmissionStatus(rawValue: "HAS_ERRORS"), .hasErrors)
    }
}

// MARK: - PathoplexusSubmissionError Tests

final class PathoplexusSubmissionErrorTests: XCTestCase {

    func testAllErrorsHaveDescriptions() {
        let errors: [PathoplexusSubmissionError] = [
            .unauthorized,
            .invalidOrganism("test"),
            .invalidGroup("group"),
            .fileReadError("/path"),
            .validationFailed([SubmissionValidationError(field: "f", message: "m")]),
            .submissionFailed("reason"),
            .networkError("network"),
            .serverError(500, "server"),
            .approvalFailed("approval"),
            .revisionFailed("revision")
        ]

        for error in errors {
            XCTAssertNotNil(error.errorDescription)
            XCTAssertFalse(error.errorDescription!.isEmpty)
        }
    }
}

// MARK: - PathoplexusGroup Tests

final class PathoplexusGroupTests: XCTestCase {

    func testGroupIdentifiable() {
        let group = PathoplexusGroup(id: "grp1", name: "Test Group")
        XCTAssertEqual(group.id, "grp1")
    }

    func testGroupCodable() throws {
        let group = PathoplexusGroup(
            id: "grp123",
            name: "Research Group",
            institution: "University",
            contactEmail: "test@example.com"
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(group)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(PathoplexusGroup.self, from: data)

        XCTAssertEqual(decoded.id, group.id)
        XCTAssertEqual(decoded.name, group.name)
        XCTAssertEqual(decoded.institution, group.institution)
        XCTAssertEqual(decoded.contactEmail, group.contactEmail)
    }
}
