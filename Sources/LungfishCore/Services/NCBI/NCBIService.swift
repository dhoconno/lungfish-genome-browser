// NCBIService.swift - NCBI Entrez E-utilities integration
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Owner: NCBI Integration Lead (Role 12)

import Foundation

// MARK: - NCBI Service

/// Service for accessing NCBI databases via Entrez E-utilities.
///
/// This service provides programmatic access to NCBI's databases including
/// GenBank (nucleotide), protein, SRA, and more.
///
/// ## Usage
/// ```swift
/// let service = NCBIService()
///
/// // Search for sequences
/// let results = try await service.esearch(
///     database: .nucleotide,
///     term: "Ebola virus[Organism]",
///     retmax: 10
/// )
///
/// // Fetch sequences
/// let data = try await service.efetch(
///     database: .nucleotide,
///     ids: results,
///     format: .fasta
/// )
/// ```
///
/// ## Rate Limiting
/// NCBI allows 3 requests/second without an API key, or 10/second with one.
/// This service automatically throttles requests to comply.
public actor NCBIService: DatabaseService {

    // MARK: - Properties

    public nonisolated let name = "NCBI"
    public nonisolated let baseURL = URL(string: "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/")!

    private let httpClient: HTTPClient
    private let apiKey: String?
    private var lastRequestTime: Date?
    private let minRequestInterval: TimeInterval

    // MARK: - Initialization

    /// Creates a new NCBI service.
    ///
    /// - Parameters:
    ///   - apiKey: Optional NCBI API key for higher rate limits
    ///   - httpClient: HTTP client for making requests (defaults to URLSession)
    public init(apiKey: String? = nil, httpClient: HTTPClient = URLSessionHTTPClient()) {
        self.apiKey = apiKey
        self.httpClient = httpClient
        // 3 requests/second without key, 10/second with key
        self.minRequestInterval = apiKey != nil ? 0.1 : 0.34
    }

    // MARK: - DatabaseService Protocol

    public func search(_ query: SearchQuery) async throws -> SearchResults {
        // Build NCBI search term
        var terms: [String] = []
        terms.append(query.term)

        if let organism = query.organism {
            terms.append("\(organism)[Organism]")
        }

        if let minLen = query.minLength {
            terms.append("\(minLen):*[Sequence Length]")
        }

        let term = terms.joined(separator: " AND ")

        let ids = try await esearch(
            database: .nucleotide,
            term: term,
            retmax: query.limit,
            retstart: query.offset
        )

        guard !ids.isEmpty else {
            return .empty
        }

        // Get summaries for the results
        let summaries = try await esummary(database: .nucleotide, ids: ids)

        let records = summaries.map { summary in
            SearchResultRecord(
                id: summary.uid,
                accession: summary.accessionVersion ?? summary.uid,
                title: summary.title ?? "Unknown",
                organism: summary.organism,
                length: summary.length,
                date: summary.createDate,
                source: .ncbi
            )
        }

        return SearchResults(
            totalCount: ids.count,  // Note: ESearch can return total count separately
            records: records,
            hasMore: records.count == query.limit,
            nextCursor: String(query.offset + records.count)
        )
    }

    public func fetch(accession: String) async throws -> DatabaseRecord {
        // First search to get the UID
        let ids = try await esearch(
            database: .nucleotide,
            term: accession,
            retmax: 1
        )

        guard let uid = ids.first else {
            throw DatabaseServiceError.notFound(accession: accession)
        }

        // Fetch the GenBank record
        let data = try await efetch(
            database: .nucleotide,
            ids: [uid],
            format: .genbank
        )

        // Parse GenBank format
        guard let content = String(data: data, encoding: .utf8) else {
            throw DatabaseServiceError.parseError(message: "Invalid GenBank data encoding")
        }

        return try parseGenBankRecord(content, uid: uid)
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

    // MARK: - E-utilities Methods

    /// Searches an NCBI database and returns matching UIDs.
    ///
    /// - Parameters:
    ///   - database: The database to search
    ///   - term: The search term
    ///   - retmax: Maximum number of results
    ///   - retstart: Starting offset for pagination
    /// - Returns: Array of UIDs
    public func esearch(
        database: NCBIDatabase,
        term: String,
        retmax: Int = 20,
        retstart: Int = 0
    ) async throws -> [String] {
        var components = URLComponents(url: baseURL.appendingPathComponent("esearch.fcgi"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "db", value: database.rawValue),
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "retmax", value: String(retmax)),
            URLQueryItem(name: "retstart", value: String(retstart)),
            URLQueryItem(name: "retmode", value: "json"),
            URLQueryItem(name: "usehistory", value: "n")
        ]

        if let apiKey = apiKey {
            components.queryItems?.append(URLQueryItem(name: "api_key", value: apiKey))
        }

        let data = try await makeRequest(url: components.url!)

        let response = try JSONDecoder().decode(ESearchResponse.self, from: data)

        if let error = response.esearchresult?.errorlist?.phrasesnotfound?.first {
            throw DatabaseServiceError.invalidQuery(reason: "Term not found: \(error)")
        }

        return response.esearchresult?.idlist ?? []
    }

    /// Fetches records from an NCBI database.
    ///
    /// - Parameters:
    ///   - database: The database to fetch from
    ///   - ids: UIDs to fetch
    ///   - format: Output format
    /// - Returns: Raw data in the requested format
    public func efetch(
        database: NCBIDatabase,
        ids: [String],
        format: NCBIFormat
    ) async throws -> Data {
        var components = URLComponents(url: baseURL.appendingPathComponent("efetch.fcgi"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "db", value: database.rawValue),
            URLQueryItem(name: "id", value: ids.joined(separator: ",")),
            URLQueryItem(name: "rettype", value: format.rettype),
            URLQueryItem(name: "retmode", value: format.retmode)
        ]

        if let apiKey = apiKey {
            components.queryItems?.append(URLQueryItem(name: "api_key", value: apiKey))
        }

        return try await makeRequest(url: components.url!)
    }

    /// Retrieves document summaries for UIDs.
    ///
    /// - Parameters:
    ///   - database: The database
    ///   - ids: UIDs to get summaries for
    /// - Returns: Array of document summaries
    public func esummary(
        database: NCBIDatabase,
        ids: [String]
    ) async throws -> [NCBIDocumentSummary] {
        var components = URLComponents(url: baseURL.appendingPathComponent("esummary.fcgi"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "db", value: database.rawValue),
            URLQueryItem(name: "id", value: ids.joined(separator: ",")),
            URLQueryItem(name: "retmode", value: "json")
        ]

        if let apiKey = apiKey {
            components.queryItems?.append(URLQueryItem(name: "api_key", value: apiKey))
        }

        let data = try await makeRequest(url: components.url!)

        let response = try JSONDecoder().decode(ESummaryResponse.self, from: data)

        return ids.compactMap { id in
            response.result?[id]
        }
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
            throw DatabaseServiceError.notFound(accession: url.absoluteString)
        case 429:
            throw DatabaseServiceError.rateLimitExceeded
        case 500...599:
            throw DatabaseServiceError.serverError(message: "HTTP \(httpResponse.statusCode)")
        default:
            throw DatabaseServiceError.invalidResponse(statusCode: httpResponse.statusCode)
        }
    }

    private func parseGenBankRecord(_ content: String, uid: String) throws -> DatabaseRecord {
        // Basic GenBank parsing
        var accession = uid
        var version: String?
        var title = ""
        var organism: String?
        var sequence = ""
        var metadata: [String: String] = [:]

        let lines = content.components(separatedBy: "\n")
        var inSequence = false

        for line in lines {
            if line.hasPrefix("LOCUS") {
                let parts = line.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
                if parts.count > 1 {
                    accession = parts[1]
                }
            } else if line.hasPrefix("ACCESSION") {
                let parts = line.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
                if parts.count > 1 {
                    accession = parts[1]
                }
            } else if line.hasPrefix("VERSION") {
                let parts = line.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
                if parts.count > 1 {
                    version = parts[1]
                }
            } else if line.hasPrefix("DEFINITION") {
                title = String(line.dropFirst(12)).trimmingCharacters(in: .whitespaces)
            } else if line.hasPrefix("  ORGANISM") {
                organism = String(line.dropFirst(12)).trimmingCharacters(in: .whitespaces)
            } else if line.hasPrefix("ORIGIN") {
                inSequence = true
            } else if line.hasPrefix("//") {
                inSequence = false
            } else if inSequence {
                // Parse sequence lines (numbered with spaces)
                let seqPart = line.components(separatedBy: .whitespaces).dropFirst().joined()
                sequence += seqPart.uppercased()
            }
        }

        return DatabaseRecord(
            id: uid,
            accession: accession,
            version: version,
            title: title,
            organism: organism,
            sequence: sequence,
            metadata: metadata,
            source: .ncbi
        )
    }
}

// MARK: - NCBI Database

/// NCBI databases available through E-utilities.
public enum NCBIDatabase: String, Sendable, CaseIterable {
    case nucleotide
    case protein
    case gene
    case sra
    case biosample
    case bioproject
    case taxonomy
    case pubmed
    case pmc

    /// Human-readable name.
    public var displayName: String {
        switch self {
        case .nucleotide: return "Nucleotide (GenBank)"
        case .protein: return "Protein"
        case .gene: return "Gene"
        case .sra: return "SRA (Sequence Read Archive)"
        case .biosample: return "BioSample"
        case .bioproject: return "BioProject"
        case .taxonomy: return "Taxonomy"
        case .pubmed: return "PubMed"
        case .pmc: return "PubMed Central"
        }
    }
}

// MARK: - NCBI Format

/// Output formats for NCBI EFetch.
public enum NCBIFormat: Sendable {
    case fasta
    case genbank
    case genbankWithParts
    case xml

    var rettype: String {
        switch self {
        case .fasta: return "fasta"
        case .genbank, .genbankWithParts: return "gb"
        case .xml: return "native"
        }
    }

    var retmode: String {
        switch self {
        case .xml: return "xml"
        default: return "text"
        }
    }
}

// MARK: - Response Types

struct ESearchResponse: Codable {
    let esearchresult: ESearchResult?
}

struct ESearchResult: Codable {
    let count: String?
    let retmax: String?
    let retstart: String?
    let idlist: [String]?
    let errorlist: ESearchErrorList?
}

struct ESearchErrorList: Codable {
    let phrasesnotfound: [String]?
}

struct ESummaryResponse: Codable {
    let result: [String: NCBIDocumentSummary]?

    private enum CodingKeys: String, CodingKey {
        case result
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // The result is nested inside the "result" key
        let resultContainer = try container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: .result)
        var result: [String: NCBIDocumentSummary] = [:]

        for key in resultContainer.allKeys {
            // Skip the "uids" array
            if key.stringValue == "uids" { continue }
            if let summary = try? resultContainer.decode(NCBIDocumentSummary.self, forKey: key) {
                result[key.stringValue] = summary
            }
        }

        self.result = result.isEmpty ? nil : result
    }
}

struct DynamicCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }

    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}

/// Document summary from NCBI ESummary.
public struct NCBIDocumentSummary: Codable, Sendable {
    public let uid: String
    public let caption: String?
    public let title: String?
    public let accessionVersion: String?
    public let organism: String?
    public let taxid: Int?
    public let slen: Int?
    public let createDate: Date?

    public var length: Int? { slen }

    enum CodingKeys: String, CodingKey {
        case uid
        case caption
        case title
        case accessionVersion = "accessionversion"
        case organism
        case taxid
        case slen
        case createDate = "createdate"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decode(String.self, forKey: .uid)
        caption = try container.decodeIfPresent(String.self, forKey: .caption)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        accessionVersion = try container.decodeIfPresent(String.self, forKey: .accessionVersion)
        organism = try container.decodeIfPresent(String.self, forKey: .organism)
        taxid = try container.decodeIfPresent(Int.self, forKey: .taxid)
        slen = try container.decodeIfPresent(Int.self, forKey: .slen)

        // Parse date string
        if let dateStr = try container.decodeIfPresent(String.self, forKey: .createDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            createDate = formatter.date(from: dateStr)
        } else {
            createDate = nil
        }
    }
}
