// PathoplexusSubmission.swift - Sequence submission workflow for Pathoplexus
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Owner: Workflow Integration Lead (Role 14)

import Foundation

// MARK: - Submission Status

/// Status of a Pathoplexus submission.
public enum SubmissionStatus: String, Sendable, Codable {
    case draft = "DRAFT"
    case submitted = "SUBMITTED"
    case processing = "PROCESSING"
    case awaitingApproval = "AWAITING_APPROVAL"
    case approved = "APPROVED"
    case rejected = "REJECTED"
    case hasErrors = "HAS_ERRORS"
}

// MARK: - Submission Errors

/// Errors that can occur during Pathoplexus submission.
public enum PathoplexusSubmissionError: Error, Sendable, LocalizedError {
    case unauthorized
    case invalidOrganism(String)
    case invalidGroup(String)
    case fileReadError(String)
    case validationFailed([SubmissionValidationError])
    case submissionFailed(String)
    case networkError(String)
    case serverError(Int, String)
    case approvalFailed(String)
    case revisionFailed(String)

    public var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Not authenticated. Please log in first."
        case .invalidOrganism(let organism):
            return "Invalid organism: \(organism)"
        case .invalidGroup(let group):
            return "Invalid group: \(group). You may not have access to this group."
        case .fileReadError(let path):
            return "Failed to read file: \(path)"
        case .validationFailed(let errors):
            let errorList = errors.map { $0.description }.joined(separator: "\n")
            return "Validation failed:\n\(errorList)"
        case .submissionFailed(let reason):
            return "Submission failed: \(reason)"
        case .networkError(let message):
            return "Network error: \(message)"
        case .serverError(let code, let message):
            return "Server error (\(code)): \(message)"
        case .approvalFailed(let reason):
            return "Approval failed: \(reason)"
        case .revisionFailed(let reason):
            return "Revision failed: \(reason)"
        }
    }
}

// MARK: - Validation Error

/// A validation error from Pathoplexus.
public struct SubmissionValidationError: Sendable, Codable {
    public let field: String
    public let message: String
    public let sequenceId: String?

    public var description: String {
        if let seqId = sequenceId {
            return "[\(seqId)] \(field): \(message)"
        }
        return "\(field): \(message)"
    }

    public init(field: String, message: String, sequenceId: String? = nil) {
        self.field = field
        self.message = message
        self.sequenceId = sequenceId
    }
}

// MARK: - Submission Result

/// Result of a successful submission to Pathoplexus.
public struct PathoplexusSubmissionResult: Sendable {
    /// Unique submission ID
    public let submissionId: String

    /// Number of sequences submitted
    public let sequenceCount: Int

    /// Current status
    public let status: SubmissionStatus

    /// Whether the submission is pending approval
    public var pendingApproval: Bool {
        status == .awaitingApproval
    }

    /// Any warnings from validation
    public let warnings: [String]

    /// Accessions assigned (if approved)
    public let accessions: [String]?

    public init(
        submissionId: String,
        sequenceCount: Int,
        status: SubmissionStatus,
        warnings: [String] = [],
        accessions: [String]? = nil
    ) {
        self.submissionId = submissionId
        self.sequenceCount = sequenceCount
        self.status = status
        self.warnings = warnings
        self.accessions = accessions
    }
}

// MARK: - Submission Entry

/// An entry in a submission batch.
public struct SubmissionEntry: Sendable {
    /// Unique identifier for this sequence within the submission
    public let submissionId: String

    /// Sequence data (FASTA format content, without header)
    public let sequence: String

    /// Metadata for this sequence
    public let metadata: SubmissionMetadata

    public init(submissionId: String, sequence: String, metadata: SubmissionMetadata) {
        self.submissionId = submissionId
        self.sequence = sequence
        self.metadata = metadata
    }
}

// MARK: - Submission Metadata

/// Metadata for a sequence submission.
public struct SubmissionMetadata: Sendable, Codable {
    /// Sample collection date (YYYY-MM-DD)
    public var sampleCollectionDate: String?

    /// Geographic location country
    public var geoLocCountry: String?

    /// Geographic location admin1 (state/province)
    public var geoLocAdmin1: String?

    /// Host organism
    public var host: String?

    /// Sequencing instrument
    public var sequencingInstrument: String?

    /// Assembly method
    public var assemblyMethod: String?

    /// Authors
    public var authors: String?

    /// Additional custom fields
    public var customFields: [String: String]

    public init(
        sampleCollectionDate: String? = nil,
        geoLocCountry: String? = nil,
        geoLocAdmin1: String? = nil,
        host: String? = nil,
        sequencingInstrument: String? = nil,
        assemblyMethod: String? = nil,
        authors: String? = nil,
        customFields: [String: String] = [:]
    ) {
        self.sampleCollectionDate = sampleCollectionDate
        self.geoLocCountry = geoLocCountry
        self.geoLocAdmin1 = geoLocAdmin1
        self.host = host
        self.sequencingInstrument = sequencingInstrument
        self.assemblyMethod = assemblyMethod
        self.authors = authors
        self.customFields = customFields
    }

    /// Converts to TSV row format.
    public func toTSVRow(submissionId: String, columns: [String]) -> String {
        var values: [String] = []
        for column in columns {
            let value: String
            switch column {
            case "submissionId":
                value = submissionId
            case "sampleCollectionDate":
                value = sampleCollectionDate ?? ""
            case "geoLocCountry":
                value = geoLocCountry ?? ""
            case "geoLocAdmin1":
                value = geoLocAdmin1 ?? ""
            case "host":
                value = host ?? ""
            case "sequencingInstrument":
                value = sequencingInstrument ?? ""
            case "assemblyMethod":
                value = assemblyMethod ?? ""
            case "authors":
                value = authors ?? ""
            default:
                value = customFields[column] ?? ""
            }
            values.append(value)
        }
        return values.joined(separator: "\t")
    }
}

// MARK: - Pathoplexus Submitter

/// Handles sequence submission to Pathoplexus.
public actor PathoplexusSubmitter {

    // MARK: - Properties

    /// Backend API base URL
    public let backendURL: URL

    /// HTTP client for making requests
    private let httpClient: HTTPClient

    /// Authenticator for obtaining tokens
    private let authenticator: PathoplexusAuthenticator

    // MARK: - Configuration

    /// Default Pathoplexus backend URL
    public static let defaultBackendURL = URL(string: "https://backend.pathoplexus.org")!

    // MARK: - Initialization

    public init(
        backendURL: URL = defaultBackendURL,
        authenticator: PathoplexusAuthenticator,
        httpClient: HTTPClient = URLSessionHTTPClient()
    ) {
        self.backendURL = backendURL
        self.authenticator = authenticator
        self.httpClient = httpClient
    }

    // MARK: - Group Management

    /// Lists groups the authenticated user belongs to.
    ///
    /// - Parameter token: Authentication token
    /// - Returns: List of groups
    public func listGroups(token: PathoplexusToken) async throws -> [PathoplexusGroup] {
        let validToken = try await authenticator.getValidToken(token)

        let url = backendURL.appendingPathComponent("groups")

        var request = URLRequest(url: url)
        request.setValue(validToken.authorizationHeader, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, response) = try await httpClient.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw PathoplexusSubmissionError.networkError("Invalid response")
            }

            switch httpResponse.statusCode {
            case 200:
                let decoder = JSONDecoder()
                return try decoder.decode([PathoplexusGroup].self, from: data)

            case 401:
                throw PathoplexusSubmissionError.unauthorized

            default:
                let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw PathoplexusSubmissionError.serverError(httpResponse.statusCode, message)
            }
        } catch let error as PathoplexusSubmissionError {
            throw error
        } catch {
            throw PathoplexusSubmissionError.networkError(error.localizedDescription)
        }
    }

    // MARK: - Submission

    /// Submits sequences to Pathoplexus.
    ///
    /// - Parameters:
    ///   - request: The submission request
    ///   - token: Authentication token
    /// - Returns: Submission result
    public func submit(
        _ request: PathoplexusSubmissionRequest,
        token: PathoplexusToken
    ) async throws -> PathoplexusSubmissionResult {
        let validToken = try await authenticator.getValidToken(token)

        // Read files
        guard let sequencesData = try? Data(contentsOf: request.sequencesFile) else {
            throw PathoplexusSubmissionError.fileReadError(request.sequencesFile.path)
        }

        guard let metadataData = try? Data(contentsOf: request.metadataFile) else {
            throw PathoplexusSubmissionError.fileReadError(request.metadataFile.path)
        }

        // Build multipart request
        let boundary = UUID().uuidString
        let url = backendURL.appendingPathComponent(request.organism).appendingPathComponent("submit")

        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "POST"
        httpRequest.setValue(validToken.authorizationHeader, forHTTPHeaderField: "Authorization")
        httpRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // Add groupId field
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"groupId\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(request.groupId)\r\n".data(using: .utf8)!)

        // Add dataUseTerms field
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"dataUseTerms\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(request.dataUseTerms.rawValue)\r\n".data(using: .utf8)!)

        // Add sequences file
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"sequenceFile\"; filename=\"sequences.fasta\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: text/plain\r\n\r\n".data(using: .utf8)!)
        body.append(sequencesData)
        body.append("\r\n".data(using: .utf8)!)

        // Add metadata file
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"metadataFile\"; filename=\"metadata.tsv\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: text/tab-separated-values\r\n\r\n".data(using: .utf8)!)
        body.append(metadataData)
        body.append("\r\n".data(using: .utf8)!)

        // Close boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        httpRequest.httpBody = body

        do {
            let (data, response) = try await httpClient.data(for: httpRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw PathoplexusSubmissionError.networkError("Invalid response")
            }

            switch httpResponse.statusCode {
            case 200, 201:
                return try parseSubmissionResponse(data)

            case 400:
                let errors = try parseValidationErrors(data)
                throw PathoplexusSubmissionError.validationFailed(errors)

            case 401:
                throw PathoplexusSubmissionError.unauthorized

            case 403:
                throw PathoplexusSubmissionError.invalidGroup(request.groupId)

            case 404:
                throw PathoplexusSubmissionError.invalidOrganism(request.organism)

            default:
                let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw PathoplexusSubmissionError.serverError(httpResponse.statusCode, message)
            }
        } catch let error as PathoplexusSubmissionError {
            throw error
        } catch {
            throw PathoplexusSubmissionError.networkError(error.localizedDescription)
        }
    }

    /// Submits sequences from in-memory data.
    ///
    /// - Parameters:
    ///   - entries: Sequence entries to submit
    ///   - organism: Target organism
    ///   - groupId: Submission group
    ///   - dataUseTerms: Data use terms
    ///   - token: Authentication token
    /// - Returns: Submission result
    public func submit(
        entries: [SubmissionEntry],
        organism: String,
        groupId: String,
        dataUseTerms: DataUseTerms,
        token: PathoplexusToken
    ) async throws -> PathoplexusSubmissionResult {
        // Create temporary files
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        // Write FASTA file
        let fastaURL = tempDir.appendingPathComponent("sequences.fasta")
        let fastaContent = entries.map { entry in
            ">\(entry.submissionId)\n\(entry.sequence)"
        }.joined(separator: "\n")
        try fastaContent.write(to: fastaURL, atomically: true, encoding: .utf8)

        // Write metadata TSV
        let metadataURL = tempDir.appendingPathComponent("metadata.tsv")
        let columns = ["submissionId", "sampleCollectionDate", "geoLocCountry", "geoLocAdmin1",
                       "host", "sequencingInstrument", "assemblyMethod", "authors"]
        var tsvContent = columns.joined(separator: "\t") + "\n"
        for entry in entries {
            tsvContent += entry.metadata.toTSVRow(submissionId: entry.submissionId, columns: columns) + "\n"
        }
        try tsvContent.write(to: metadataURL, atomically: true, encoding: .utf8)

        // Submit
        let request = PathoplexusSubmissionRequest(
            organism: organism,
            sequencesFile: fastaURL,
            metadataFile: metadataURL,
            groupId: groupId,
            dataUseTerms: dataUseTerms
        )

        return try await submit(request, token: token)
    }

    // MARK: - Revision

    /// Revises an existing submission.
    ///
    /// - Parameters:
    ///   - submissionId: ID of the submission to revise
    ///   - sequencesFile: Updated sequences file (optional)
    ///   - metadataFile: Updated metadata file (optional)
    ///   - organism: Organism for the submission
    ///   - token: Authentication token
    public func revise(
        submissionId: String,
        sequencesFile: URL?,
        metadataFile: URL?,
        organism: String,
        token: PathoplexusToken
    ) async throws {
        let validToken = try await authenticator.getValidToken(token)

        let boundary = UUID().uuidString
        let url = backendURL
            .appendingPathComponent(organism)
            .appendingPathComponent("revise")
            .appendingPathComponent(submissionId)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(validToken.authorizationHeader, forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // Add sequences file if provided
        if let seqURL = sequencesFile, let seqData = try? Data(contentsOf: seqURL) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"sequenceFile\"; filename=\"sequences.fasta\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: text/plain\r\n\r\n".data(using: .utf8)!)
            body.append(seqData)
            body.append("\r\n".data(using: .utf8)!)
        }

        // Add metadata file if provided
        if let metaURL = metadataFile, let metaData = try? Data(contentsOf: metaURL) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"metadataFile\"; filename=\"metadata.tsv\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: text/tab-separated-values\r\n\r\n".data(using: .utf8)!)
            body.append(metaData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        do {
            let (data, response) = try await httpClient.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw PathoplexusSubmissionError.networkError("Invalid response")
            }

            switch httpResponse.statusCode {
            case 200, 204:
                return

            case 400:
                let errors = try parseValidationErrors(data)
                throw PathoplexusSubmissionError.validationFailed(errors)

            case 401:
                throw PathoplexusSubmissionError.unauthorized

            case 404:
                throw PathoplexusSubmissionError.revisionFailed("Submission not found: \(submissionId)")

            default:
                let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw PathoplexusSubmissionError.serverError(httpResponse.statusCode, message)
            }
        } catch let error as PathoplexusSubmissionError {
            throw error
        } catch {
            throw PathoplexusSubmissionError.networkError(error.localizedDescription)
        }
    }

    // MARK: - Approval

    /// Approves a pending submission (for group admins).
    ///
    /// - Parameters:
    ///   - submissionId: ID of the submission to approve
    ///   - organism: Organism for the submission
    ///   - token: Authentication token
    public func approve(
        submissionId: String,
        organism: String,
        token: PathoplexusToken
    ) async throws {
        let validToken = try await authenticator.getValidToken(token)

        let url = backendURL
            .appendingPathComponent(organism)
            .appendingPathComponent("approve")
            .appendingPathComponent(submissionId)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(validToken.authorizationHeader, forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await httpClient.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw PathoplexusSubmissionError.networkError("Invalid response")
            }

            switch httpResponse.statusCode {
            case 200, 204:
                return

            case 401:
                throw PathoplexusSubmissionError.unauthorized

            case 403:
                throw PathoplexusSubmissionError.approvalFailed("Not authorized to approve this submission")

            case 404:
                throw PathoplexusSubmissionError.approvalFailed("Submission not found: \(submissionId)")

            default:
                let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw PathoplexusSubmissionError.serverError(httpResponse.statusCode, message)
            }
        } catch let error as PathoplexusSubmissionError {
            throw error
        } catch {
            throw PathoplexusSubmissionError.networkError(error.localizedDescription)
        }
    }

    // MARK: - Private Helpers

    private func parseSubmissionResponse(_ data: Data) throws -> PathoplexusSubmissionResult {
        struct Response: Codable {
            let submissionId: String
            let sequenceCount: Int?
            let status: String?
            let warnings: [String]?
            let accessions: [String]?
        }

        let decoder = JSONDecoder()
        guard let response = try? decoder.decode(Response.self, from: data) else {
            // Try to extract just the submission ID from simple response
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let submissionId = json["submissionId"] as? String {
                return PathoplexusSubmissionResult(
                    submissionId: submissionId,
                    sequenceCount: 0,
                    status: .submitted
                )
            }
            throw PathoplexusSubmissionError.networkError("Invalid response format")
        }

        let status = response.status.flatMap { SubmissionStatus(rawValue: $0) } ?? .submitted

        return PathoplexusSubmissionResult(
            submissionId: response.submissionId,
            sequenceCount: response.sequenceCount ?? 0,
            status: status,
            warnings: response.warnings ?? [],
            accessions: response.accessions
        )
    }

    private func parseValidationErrors(_ data: Data) throws -> [SubmissionValidationError] {
        struct ErrorResponse: Codable {
            let errors: [ErrorDetail]?
            let message: String?

            struct ErrorDetail: Codable {
                let field: String?
                let message: String
                let sequenceId: String?
            }
        }

        let decoder = JSONDecoder()
        if let response = try? decoder.decode(ErrorResponse.self, from: data) {
            if let errors = response.errors {
                return errors.map {
                    SubmissionValidationError(
                        field: $0.field ?? "unknown",
                        message: $0.message,
                        sequenceId: $0.sequenceId
                    )
                }
            } else if let message = response.message {
                return [SubmissionValidationError(field: "general", message: message)]
            }
        }

        // Fallback to raw message
        let message = String(data: data, encoding: .utf8) ?? "Unknown validation error"
        return [SubmissionValidationError(field: "unknown", message: message)]
    }
}

// MARK: - Metadata Template

/// Generates metadata templates for different organisms.
public struct MetadataTemplateGenerator {

    /// Standard columns for all organisms
    public static let standardColumns = [
        "submissionId",
        "sampleCollectionDate",
        "geoLocCountry",
        "geoLocAdmin1",
        "host",
        "authors"
    ]

    /// Additional columns for specific organisms
    public static let organismSpecificColumns: [String: [String]] = [
        "ebola-zaire": ["outbreak", "passageHistory"],
        "mpox": ["clade", "lineage"],
        "rsv-a": ["subtype"],
        "rsv-b": ["subtype"],
        "cchf": ["segment"]
    ]

    /// Generates a TSV template header for an organism.
    public static func generateTemplate(for organism: String) -> String {
        var columns = standardColumns
        if let specific = organismSpecificColumns[organism] {
            columns.append(contentsOf: specific)
        }
        return columns.joined(separator: "\t")
    }

    /// Generates a sample row with placeholders.
    public static func generateSampleRow(for organism: String) -> String {
        var columns = standardColumns
        if let specific = organismSpecificColumns[organism] {
            columns.append(contentsOf: specific)
        }

        let placeholders = columns.map { column -> String in
            switch column {
            case "submissionId": return "sample_001"
            case "sampleCollectionDate": return "2024-01-15"
            case "geoLocCountry": return "USA"
            case "geoLocAdmin1": return "California"
            case "host": return "Homo sapiens"
            case "authors": return "Smith J, Doe A"
            default: return ""
            }
        }

        return placeholders.joined(separator: "\t")
    }
}
