// ENAService.swift - European Nucleotide Archive integration
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Owner: ENA Integration Specialist (Role 13)

import Foundation

// MARK: - ENA Service

/// Service for accessing the European Nucleotide Archive.
///
/// This service provides programmatic access to ENA's sequence data
/// via the Portal API and Browser API.
///
/// ## Usage
/// ```swift
/// let service = ENAService()
///
/// // Search for sequences
/// let query = SearchQuery(term: "Ebola", organism: "Ebolavirus")
/// let results = try await service.search(query)
///
/// // Fetch a sequence
/// let record = try await service.fetch(accession: "MN908947")
/// ```
///
/// ## Rate Limiting
/// ENA allows 50 requests/second. This service throttles accordingly.
public actor ENAService: DatabaseService {

    // MARK: - Properties

    public nonisolated let name = "ENA"
    public nonisolated let baseURL = URL(string: "https://www.ebi.ac.uk/ena/browser/api/")!
    private let portalURL = URL(string: "https://www.ebi.ac.uk/ena/portal/api/")!

    private let httpClient: HTTPClient
    private var lastRequestTime: Date?
    private let minRequestInterval: TimeInterval = 0.02  // 50 requests/second

    // MARK: - Initialization

    /// Creates a new ENA service.
    ///
    /// - Parameter httpClient: HTTP client for making requests
    public init(httpClient: HTTPClient = URLSessionHTTPClient()) {
        self.httpClient = httpClient
    }

    // MARK: - DatabaseService Protocol

    public func search(_ query: SearchQuery) async throws -> SearchResults {
        var queryParts: [String] = []

        if !query.term.isEmpty {
            queryParts.append("description=\"*\(query.term)*\"")
        }

        if let organism = query.organism {
            queryParts.append("tax_tree(\"\(organism)\")")
        }

        if let minLen = query.minLength {
            queryParts.append("base_count>=\(minLen)")
        }

        if let maxLen = query.maxLength {
            queryParts.append("base_count<=\(maxLen)")
        }

        let queryString = queryParts.isEmpty ? "*" : queryParts.joined(separator: " AND ")

        var components = URLComponents(url: portalURL.appendingPathComponent("search"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "query", value: queryString),
            URLQueryItem(name: "result", value: "sequence"),
            URLQueryItem(name: "fields", value: "accession,description,tax_id,scientific_name,base_count,first_public"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "limit", value: String(query.limit)),
            URLQueryItem(name: "offset", value: String(query.offset))
        ]

        let data = try await makeRequest(url: components.url!)

        let records = try JSONDecoder().decode([ENASearchRecord].self, from: data)

        let searchResults = records.map { record in
            SearchResultRecord(
                id: record.accession,
                accession: record.accession,
                title: record.description ?? "No description",
                organism: record.scientificName,
                length: record.baseCount,
                date: record.firstPublic,
                source: .ena
            )
        }

        return SearchResults(
            totalCount: searchResults.count,
            records: searchResults,
            hasMore: searchResults.count == query.limit,
            nextCursor: String(query.offset + searchResults.count)
        )
    }

    public func fetch(accession: String) async throws -> DatabaseRecord {
        // Fetch FASTA
        let fastaData = try await fetchFASTA(accession: accession)

        // Parse FASTA header and sequence
        let lines = fastaData.components(separatedBy: "\n")
        guard let headerLine = lines.first, headerLine.hasPrefix(">") else {
            throw DatabaseServiceError.parseError(message: "Invalid FASTA format")
        }

        let header = String(headerLine.dropFirst())
        let sequence = lines.dropFirst().joined().uppercased()

        // Parse header for metadata
        let headerParts = header.components(separatedBy: " ")
        let accessionPart = headerParts.first ?? accession
        let title = headerParts.dropFirst().joined(separator: " ")

        return DatabaseRecord(
            id: accession,
            accession: accessionPart,
            title: title.isEmpty ? accession : title,
            sequence: sequence,
            source: .ena
        )
    }

    public nonisolated func fetchBatch(accessions: [String]) async throws -> AsyncThrowingStream<DatabaseRecord, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    for accession in accessions {
                        let record = try await self.fetch(accession: accession)
                        continuation.yield(record)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    // MARK: - ENA-Specific Methods

    /// Fetches a sequence in FASTA format.
    ///
    /// - Parameter accession: The accession number
    /// - Returns: FASTA-formatted sequence
    public func fetchFASTA(accession: String) async throws -> String {
        let url = baseURL.appendingPathComponent("fasta/\(accession)")
        let data = try await makeRequest(url: url)

        guard let fasta = String(data: data, encoding: .utf8) else {
            throw DatabaseServiceError.parseError(message: "Invalid FASTA encoding")
        }

        return fasta
    }

    /// Fetches a sequence in EMBL format.
    ///
    /// - Parameter accession: The accession number
    /// - Returns: EMBL-formatted sequence
    public func fetchEMBL(accession: String) async throws -> String {
        let url = baseURL.appendingPathComponent("embl/\(accession)")
        let data = try await makeRequest(url: url)

        guard let embl = String(data: data, encoding: .utf8) else {
            throw DatabaseServiceError.parseError(message: "Invalid EMBL encoding")
        }

        return embl
    }

    /// Fetches sequence metadata as XML.
    ///
    /// - Parameter accession: The accession number
    /// - Returns: XML metadata
    public func fetchXML(accession: String) async throws -> String {
        let url = baseURL.appendingPathComponent("xml/\(accession)")
        let data = try await makeRequest(url: url)

        guard let xml = String(data: data, encoding: .utf8) else {
            throw DatabaseServiceError.parseError(message: "Invalid XML encoding")
        }

        return xml
    }

    // MARK: - Private Methods

    private func makeRequest(url: URL) async throws -> Data {
        // Rate limiting
        if let lastTime = lastRequestTime {
            let elapsed = Date().timeIntervalSince(lastTime)
            if elapsed < minRequestInterval {
                try await Task.sleep(nanoseconds: UInt64((minRequestInterval - elapsed) * 1_000_000_000))
            }
        }
        lastRequestTime = Date()

        var request = URLRequest(url: url)
        request.setValue("Lungfish Genome Browser", forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = 30

        let (data, response) = try await httpClient.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw DatabaseServiceError.networkError(underlying: "Invalid response type")
        }

        switch httpResponse.statusCode {
        case 200...299:
            return data
        case 400:
            throw DatabaseServiceError.invalidQuery(reason: "Bad request")
        case 404:
            throw DatabaseServiceError.notFound(accession: url.lastPathComponent)
        case 429:
            throw DatabaseServiceError.rateLimitExceeded
        case 500...599:
            throw DatabaseServiceError.serverError(message: "HTTP \(httpResponse.statusCode)")
        default:
            throw DatabaseServiceError.invalidResponse(statusCode: httpResponse.statusCode)
        }
    }
}

// MARK: - ENA Search Record

/// A record from ENA Portal API search.
struct ENASearchRecord: Codable {
    let accession: String
    let description: String?
    let taxId: Int?
    let scientificName: String?
    let baseCount: Int?
    let firstPublic: Date?

    enum CodingKeys: String, CodingKey {
        case accession
        case description
        case taxId = "tax_id"
        case scientificName = "scientific_name"
        case baseCount = "base_count"
        case firstPublic = "first_public"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accession = try container.decode(String.self, forKey: .accession)
        description = try container.decodeIfPresent(String.self, forKey: .description)

        // Handle both string and int for tax_id
        if let taxIdInt = try? container.decodeIfPresent(Int.self, forKey: .taxId) {
            taxId = taxIdInt
        } else if let taxIdStr = try? container.decodeIfPresent(String.self, forKey: .taxId) {
            taxId = Int(taxIdStr)
        } else {
            taxId = nil
        }

        scientificName = try container.decodeIfPresent(String.self, forKey: .scientificName)

        // Handle both string and int for base_count
        if let countInt = try? container.decodeIfPresent(Int.self, forKey: .baseCount) {
            baseCount = countInt
        } else if let countStr = try? container.decodeIfPresent(String.self, forKey: .baseCount) {
            baseCount = Int(countStr)
        } else {
            baseCount = nil
        }

        // Parse date
        if let dateStr = try container.decodeIfPresent(String.self, forKey: .firstPublic) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            firstPublic = formatter.date(from: dateStr)
        } else {
            firstPublic = nil
        }
    }
}
