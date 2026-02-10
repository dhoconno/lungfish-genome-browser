// VariantDatabase.swift - SQLite-backed variant database for reference bundles
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import Foundation
import SQLite3
import LungfishCore
import os.log

/// Logger for variant database operations
private let variantDBLogger = Logger(subsystem: "com.lungfish.browser", category: "VariantDatabase")

// MARK: - VariantDatabaseRecord

/// A single variant record from the SQLite database.
public struct VariantDatabaseRecord: Sendable, Equatable {
    /// Chromosome name
    public let chromosome: String

    /// 0-based start position
    public let position: Int

    /// 0-based end position (exclusive)
    public let end: Int

    /// Variant ID (rsID or generated)
    public let variantID: String

    /// Reference allele
    public let ref: String

    /// Alternate allele(s), comma-separated
    public let alt: String

    /// Variant type (SNP, INS, DEL, MNP, COMPLEX)
    public let variantType: String

    /// Quality score (PHRED-scaled), nil if unknown
    public let quality: Double?

    /// Filter status (PASS, filter name, or nil)
    public let filter: String?

    /// INFO field as raw string for optional parsing
    public let info: String?

    public init(
        chromosome: String, position: Int, end: Int, variantID: String,
        ref: String, alt: String, variantType: String,
        quality: Double?, filter: String?, info: String?
    ) {
        self.chromosome = chromosome
        self.position = position
        self.end = end
        self.variantID = variantID
        self.ref = ref
        self.alt = alt
        self.variantType = variantType
        self.quality = quality
        self.filter = filter
        self.info = info
    }

    /// Converts this record to a `BundleVariant` for use by the rendering pipeline.
    public func toBundleVariant() -> BundleVariant {
        BundleVariant(
            id: variantID,
            chromosome: chromosome,
            position: Int64(position),
            ref: ref,
            alt: alt.split(separator: ",").map(String.init),
            quality: quality.map { Float($0) },
            variantId: variantID,
            filter: filter
        )
    }

    /// Converts this record to a `SequenceAnnotation` for rendering in the annotation pipeline.
    public func toAnnotation() -> SequenceAnnotation {
        let annotationType: AnnotationType
        switch variantType {
        case "SNP": annotationType = .snp
        case "INS": annotationType = .insertion
        case "DEL": annotationType = .deletion
        default: annotationType = .variation
        }

        let vtype = VariantType(rawValue: variantType) ?? .complex
        let color = vtype.defaultColor

        var qualifiers: [String: AnnotationQualifier] = [:]
        qualifiers["variant_type"] = AnnotationQualifier(variantType)
        qualifiers["ref"] = AnnotationQualifier(ref)
        qualifiers["alt"] = AnnotationQualifier(alt)
        if let q = quality {
            qualifiers["quality"] = AnnotationQualifier(String(format: "%.2f", q))
        }
        if let f = filter {
            qualifiers["filter"] = AnnotationQualifier(f)
        }

        let alts = alt.split(separator: ",").map(String.init)
        var noteComponents: [String] = []
        noteComponents.append("\(vtype.displayName): \(ref) > \(alts.joined(separator: ", "))")
        if let q = quality {
            noteComponents.append("Quality: \(String(format: "%.1f", q))")
        }
        if let f = filter, f != "." {
            noteComponents.append("Filter: \(f)")
        }

        return SequenceAnnotation(
            type: annotationType,
            name: variantID,
            chromosome: chromosome,
            start: position,
            end: end,
            strand: .unknown,
            qualifiers: qualifiers,
            color: color,
            note: noteComponents.joined(separator: "\n")
        )
    }
}

// MARK: - VariantDatabase (Reader)

/// Reads variant data from a SQLite database embedded in a .lungfishref bundle.
///
/// The database is created during bundle building from VCF files, providing instant
/// random-access queries by genomic region without requiring a tabix/CSI index reader.
///
/// Schema:
/// ```sql
/// CREATE TABLE variants (
///     chromosome TEXT NOT NULL,
///     position INTEGER NOT NULL,
///     end_pos INTEGER NOT NULL,
///     variant_id TEXT NOT NULL,
///     ref TEXT NOT NULL,
///     alt TEXT NOT NULL,
///     variant_type TEXT NOT NULL,
///     quality REAL,
///     filter TEXT,
///     info TEXT
/// );
/// CREATE INDEX idx_variants_region ON variants(chromosome, position, end_pos);
/// CREATE INDEX idx_variants_type ON variants(variant_type);
/// CREATE INDEX idx_variants_id ON variants(variant_id COLLATE NOCASE);
/// ```
public final class VariantDatabase: @unchecked Sendable {

    private var db: OpaquePointer?
    private let url: URL

    /// Opens an existing variant database for reading.
    ///
    /// - Parameter url: URL to the SQLite database file
    /// - Throws: If the database cannot be opened
    public init(url: URL) throws {
        self.url = url
        let rc = sqlite3_open_v2(url.path, &db, SQLITE_OPEN_READONLY | SQLITE_OPEN_NOMUTEX, nil)
        guard rc == SQLITE_OK else {
            let msg = db.flatMap { String(cString: sqlite3_errmsg($0)) } ?? "Unknown error"
            sqlite3_close(db)
            db = nil
            throw VariantDatabaseError.openFailed(msg)
        }
        variantDBLogger.info("Opened variant database: \(url.lastPathComponent)")
    }

    deinit {
        if let db {
            sqlite3_close(db)
        }
    }

    // MARK: - Metadata Queries

    /// Returns the total number of variants in the database.
    public func totalCount() -> Int {
        guard let db else { return 0 }
        var stmt: OpaquePointer?
        defer { sqlite3_finalize(stmt) }
        guard sqlite3_prepare_v2(db, "SELECT COUNT(*) FROM variants", -1, &stmt, nil) == SQLITE_OK,
              sqlite3_step(stmt) == SQLITE_ROW else { return 0 }
        return Int(sqlite3_column_int64(stmt, 0))
    }

    /// Returns all distinct variant type strings (SNP, INS, DEL, MNP, COMPLEX, REF).
    public func allTypes() -> [String] {
        guard let db else { return [] }
        var stmt: OpaquePointer?
        defer { sqlite3_finalize(stmt) }
        guard sqlite3_prepare_v2(db, "SELECT DISTINCT variant_type FROM variants ORDER BY variant_type", -1, &stmt, nil) == SQLITE_OK else { return [] }

        var types: [String] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            if let cStr = sqlite3_column_text(stmt, 0) {
                types.append(String(cString: cStr))
            }
        }
        return types
    }

    /// Returns all distinct chromosome names in the database.
    public func allChromosomes() -> [String] {
        guard let db else { return [] }
        var stmt: OpaquePointer?
        defer { sqlite3_finalize(stmt) }
        guard sqlite3_prepare_v2(db, "SELECT DISTINCT chromosome FROM variants ORDER BY chromosome", -1, &stmt, nil) == SQLITE_OK else { return [] }

        var chroms: [String] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            if let cStr = sqlite3_column_text(stmt, 0) {
                chroms.append(String(cString: cStr))
            }
        }
        return chroms
    }

    // MARK: - Region Query

    /// Queries variants overlapping a genomic region.
    ///
    /// This is the primary query for rendering — returns all variants whose
    /// `[position, end_pos)` interval overlaps the given `[start, end)` region.
    ///
    /// - Parameters:
    ///   - chromosome: Chromosome name
    ///   - start: 0-based start position (inclusive)
    ///   - end: 0-based end position (exclusive)
    ///   - types: Set of variant type strings to include (empty = all types)
    ///   - minQuality: Minimum quality score to include (nil = no filter)
    ///   - onlyPassing: If true, only return variants with PASS filter
    ///   - limit: Maximum number of results
    /// - Returns: Array of matching variant records, ordered by position
    public func query(
        chromosome: String,
        start: Int,
        end: Int,
        types: Set<String> = [],
        minQuality: Double? = nil,
        onlyPassing: Bool = false,
        limit: Int = 50_000
    ) -> [VariantDatabaseRecord] {
        guard let db else { return [] }

        var sql = "SELECT chromosome, position, end_pos, variant_id, ref, alt, variant_type, quality, filter, info FROM variants"
        var conditions: [String] = []
        var bindingsText: [(Int32, String)] = []
        var bindingsDouble: [(Int32, Double)] = []
        var paramIndex: Int32 = 1

        // Region overlap: variant.position < query.end AND variant.end_pos > query.start
        conditions.append("chromosome = ?")
        bindingsText.append((paramIndex, chromosome))
        paramIndex += 1

        conditions.append("position < ?")
        bindingsDouble.append((paramIndex, Double(end)))
        paramIndex += 1

        conditions.append("end_pos > ?")
        bindingsDouble.append((paramIndex, Double(start)))
        paramIndex += 1

        if !types.isEmpty {
            let placeholders = types.map { _ in "?" }.joined(separator: ",")
            conditions.append("variant_type IN (\(placeholders))")
            for t in types.sorted() {
                bindingsText.append((paramIndex, t))
                paramIndex += 1
            }
        }

        if let minQ = minQuality {
            conditions.append("quality >= ?")
            bindingsDouble.append((paramIndex, minQ))
            paramIndex += 1
        }

        if onlyPassing {
            conditions.append("(filter = 'PASS' OR filter = '.' OR filter IS NULL)")
        }

        sql += " WHERE " + conditions.joined(separator: " AND ")
        sql += " ORDER BY position"
        sql += " LIMIT \(limit)"

        var stmt: OpaquePointer?
        defer { sqlite3_finalize(stmt) }
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else {
            variantDBLogger.error("Failed to prepare variant query: \(sql)")
            return []
        }

        for (idx, value) in bindingsText {
            sqlite3_bind_text(stmt, idx, (value as NSString).utf8String, -1, nil)
        }
        for (idx, value) in bindingsDouble {
            sqlite3_bind_double(stmt, idx, value)
        }

        var results: [VariantDatabaseRecord] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            let chrom = sqlite3_column_text(stmt, 0).map { String(cString: $0) } ?? ""
            let pos = Int(sqlite3_column_int64(stmt, 1))
            let endPos = Int(sqlite3_column_int64(stmt, 2))
            let vid = sqlite3_column_text(stmt, 3).map { String(cString: $0) } ?? ""
            let ref = sqlite3_column_text(stmt, 4).map { String(cString: $0) } ?? ""
            let alt = sqlite3_column_text(stmt, 5).map { String(cString: $0) } ?? ""
            let vtype = sqlite3_column_text(stmt, 6).map { String(cString: $0) } ?? "SNP"
            let quality: Double? = sqlite3_column_type(stmt, 7) == SQLITE_NULL ? nil : sqlite3_column_double(stmt, 7)
            let filter = sqlite3_column_text(stmt, 8).map { String(cString: $0) }
            let info = sqlite3_column_text(stmt, 9).map { String(cString: $0) }

            results.append(VariantDatabaseRecord(
                chromosome: chrom, position: pos, end: endPos, variantID: vid,
                ref: ref, alt: alt, variantType: vtype,
                quality: quality, filter: filter, info: info
            ))
        }

        return results
    }

    /// Queries variant count in a region (without fetching full records).
    public func queryCount(chromosome: String, start: Int, end: Int) -> Int {
        guard let db else { return 0 }

        let sql = "SELECT COUNT(*) FROM variants WHERE chromosome = ? AND position < ? AND end_pos > ?"
        var stmt: OpaquePointer?
        defer { sqlite3_finalize(stmt) }
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else { return 0 }

        sqlite3_bind_text(stmt, 1, (chromosome as NSString).utf8String, -1, nil)
        sqlite3_bind_int64(stmt, 2, Int64(end))
        sqlite3_bind_int64(stmt, 3, Int64(start))

        guard sqlite3_step(stmt) == SQLITE_ROW else { return 0 }
        return Int(sqlite3_column_int64(stmt, 0))
    }

    /// Queries variants with optional type filter and name filter.
    ///
    /// Unlike `searchByID`, this supports unfiltered queries (returns all variants)
    /// and type-based filtering for the unified annotation table.
    ///
    /// - Parameters:
    ///   - nameFilter: Case-insensitive substring match on variant_id (empty = no name filter)
    ///   - types: Set of variant type strings to include (empty = all types)
    ///   - limit: Maximum number of results
    /// - Returns: Array of matching variant records
    public func queryForTable(nameFilter: String = "", types: Set<String> = [], limit: Int = 5000) -> [VariantDatabaseRecord] {
        guard let db else { return [] }

        var sql = "SELECT chromosome, position, end_pos, variant_id, ref, alt, variant_type, quality, filter, info FROM variants"
        var conditions: [String] = []
        var bindings: [(Int32, String)] = []
        var paramIndex: Int32 = 1

        if !nameFilter.isEmpty {
            conditions.append("variant_id LIKE ?")
            bindings.append((paramIndex, "%\(nameFilter)%"))
            paramIndex += 1
        }

        if !types.isEmpty {
            let placeholders = types.map { _ in "?" }.joined(separator: ",")
            conditions.append("variant_type IN (\(placeholders))")
            for t in types.sorted() {
                bindings.append((paramIndex, t))
                paramIndex += 1
            }
        }

        if !conditions.isEmpty {
            sql += " WHERE " + conditions.joined(separator: " AND ")
        }
        sql += " ORDER BY chromosome, position LIMIT \(limit)"

        var stmt: OpaquePointer?
        defer { sqlite3_finalize(stmt) }
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else { return [] }

        for (idx, value) in bindings {
            sqlite3_bind_text(stmt, idx, (value as NSString).utf8String, -1, nil)
        }

        var results: [VariantDatabaseRecord] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            let chrom = sqlite3_column_text(stmt, 0).map { String(cString: $0) } ?? ""
            let pos = Int(sqlite3_column_int64(stmt, 1))
            let endPos = Int(sqlite3_column_int64(stmt, 2))
            let vid = sqlite3_column_text(stmt, 3).map { String(cString: $0) } ?? ""
            let refStr = sqlite3_column_text(stmt, 4).map { String(cString: $0) } ?? ""
            let altStr = sqlite3_column_text(stmt, 5).map { String(cString: $0) } ?? ""
            let vtype = sqlite3_column_text(stmt, 6).map { String(cString: $0) } ?? "SNP"
            let quality: Double? = sqlite3_column_type(stmt, 7) == SQLITE_NULL ? nil : sqlite3_column_double(stmt, 7)
            let filterStr = sqlite3_column_text(stmt, 8).map { String(cString: $0) }
            let infoStr = sqlite3_column_text(stmt, 9).map { String(cString: $0) }

            results.append(VariantDatabaseRecord(
                chromosome: chrom, position: pos, end: endPos, variantID: vid,
                ref: refStr, alt: altStr, variantType: vtype,
                quality: quality, filter: filterStr, info: infoStr
            ))
        }
        return results
    }

    /// Returns variant count matching optional filters.
    public func queryCountForTable(nameFilter: String = "", types: Set<String> = []) -> Int {
        guard let db else { return 0 }

        var sql = "SELECT COUNT(*) FROM variants"
        var conditions: [String] = []
        var bindings: [(Int32, String)] = []
        var paramIndex: Int32 = 1

        if !nameFilter.isEmpty {
            conditions.append("variant_id LIKE ?")
            bindings.append((paramIndex, "%\(nameFilter)%"))
            paramIndex += 1
        }

        if !types.isEmpty {
            let placeholders = types.map { _ in "?" }.joined(separator: ",")
            conditions.append("variant_type IN (\(placeholders))")
            for t in types.sorted() {
                bindings.append((paramIndex, t))
                paramIndex += 1
            }
        }

        if !conditions.isEmpty {
            sql += " WHERE " + conditions.joined(separator: " AND ")
        }

        var stmt: OpaquePointer?
        defer { sqlite3_finalize(stmt) }
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else { return 0 }

        for (idx, value) in bindings {
            sqlite3_bind_text(stmt, idx, (value as NSString).utf8String, -1, nil)
        }

        guard sqlite3_step(stmt) == SQLITE_ROW else { return 0 }
        return Int(sqlite3_column_int64(stmt, 0))
    }

    /// Searches variants by ID (e.g., rsID) with case-insensitive prefix/substring matching.
    ///
    /// - Parameters:
    ///   - idFilter: Case-insensitive substring match on variant_id
    ///   - limit: Maximum number of results
    /// - Returns: Array of matching variant records
    public func searchByID(idFilter: String, limit: Int = 1000) -> [VariantDatabaseRecord] {
        guard let db, !idFilter.isEmpty else { return [] }

        let sql = "SELECT chromosome, position, end_pos, variant_id, ref, alt, variant_type, quality, filter, info FROM variants WHERE variant_id LIKE ? ORDER BY variant_id COLLATE NOCASE LIMIT ?"
        var stmt: OpaquePointer?
        defer { sqlite3_finalize(stmt) }
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else { return [] }

        sqlite3_bind_text(stmt, 1, ("%\(idFilter)%" as NSString).utf8String, -1, nil)
        sqlite3_bind_int(stmt, 2, Int32(limit))

        var results: [VariantDatabaseRecord] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            let chrom = sqlite3_column_text(stmt, 0).map { String(cString: $0) } ?? ""
            let pos = Int(sqlite3_column_int64(stmt, 1))
            let endPos = Int(sqlite3_column_int64(stmt, 2))
            let vid = sqlite3_column_text(stmt, 3).map { String(cString: $0) } ?? ""
            let ref = sqlite3_column_text(stmt, 4).map { String(cString: $0) } ?? ""
            let alt = sqlite3_column_text(stmt, 5).map { String(cString: $0) } ?? ""
            let vtype = sqlite3_column_text(stmt, 6).map { String(cString: $0) } ?? "SNP"
            let quality: Double? = sqlite3_column_type(stmt, 7) == SQLITE_NULL ? nil : sqlite3_column_double(stmt, 7)
            let filter = sqlite3_column_text(stmt, 8).map { String(cString: $0) }
            let info = sqlite3_column_text(stmt, 9).map { String(cString: $0) }

            results.append(VariantDatabaseRecord(
                chromosome: chrom, position: pos, end: endPos, variantID: vid,
                ref: ref, alt: alt, variantType: vtype,
                quality: quality, filter: filter, info: info
            ))
        }
        return results
    }

    // MARK: - Static Creation (for bundle building)

    /// Creates a new variant database from a VCF file.
    ///
    /// Parses all variant records from the VCF, classifies them by type,
    /// and inserts them into a SQLite database with spatial indexes.
    ///
    /// - Parameters:
    ///   - vcfURL: URL to the VCF file (plain text, not compressed)
    ///   - outputURL: URL for the SQLite database to create
    /// - Returns: Number of records inserted
    @discardableResult
    public static func createFromVCF(vcfURL: URL, outputURL: URL) throws -> Int {
        try? FileManager.default.removeItem(at: outputURL)

        var db: OpaquePointer?
        let rc = sqlite3_open(outputURL.path, &db)
        guard rc == SQLITE_OK, let db else {
            let msg = db.flatMap { String(cString: sqlite3_errmsg($0)) } ?? "Unknown error"
            sqlite3_close(db)
            throw VariantDatabaseError.createFailed(msg)
        }
        defer { sqlite3_close(db) }

        // Create schema
        let schema = """
        CREATE TABLE variants (
            chromosome TEXT NOT NULL,
            position INTEGER NOT NULL,
            end_pos INTEGER NOT NULL,
            variant_id TEXT NOT NULL,
            ref TEXT NOT NULL,
            alt TEXT NOT NULL,
            variant_type TEXT NOT NULL,
            quality REAL,
            filter TEXT,
            info TEXT
        );
        """
        var errMsg: UnsafeMutablePointer<CChar>?
        sqlite3_exec(db, schema, nil, nil, &errMsg)
        if let errMsg {
            let msg = String(cString: errMsg)
            sqlite3_free(errMsg)
            throw VariantDatabaseError.createFailed(msg)
        }

        // Begin transaction for bulk insert
        sqlite3_exec(db, "BEGIN TRANSACTION", nil, nil, nil)

        let insertSQL = """
        INSERT INTO variants (chromosome, position, end_pos, variant_id, ref, alt, variant_type, quality, filter, info)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """
        var insertStmt: OpaquePointer?
        guard sqlite3_prepare_v2(db, insertSQL, -1, &insertStmt, nil) == SQLITE_OK else {
            throw VariantDatabaseError.createFailed("Failed to prepare INSERT statement")
        }
        defer { sqlite3_finalize(insertStmt) }

        let content = try String(contentsOf: vcfURL, encoding: .utf8)
        var insertCount = 0
        var sampleNames: [String] = []

        for line in content.split(separator: "\n") {
            guard !line.isEmpty else { continue }

            // Skip meta-information lines
            if line.hasPrefix("##") { continue }

            // Parse header line for sample names
            if line.hasPrefix("#CHROM") {
                let fields = line.split(separator: "\t").map(String.init)
                if fields.count > 9 {
                    sampleNames = Array(fields.dropFirst(9))
                }
                continue
            }

            // Parse variant line
            let fields = line.split(separator: "\t", omittingEmptySubsequences: false).map(String.init)
            guard fields.count >= 8 else { continue }

            let chromosome = fields[0]
            guard let pos1based = Int(fields[1]), pos1based >= 1 else { continue }
            let position = pos1based - 1  // Convert to 0-based

            let rawID = fields[2]
            let variantID = rawID == "." ? "\(chromosome)_\(pos1based)" : rawID

            let ref = fields[3]
            let alt = fields[4]
            let qualStr = fields[5]
            let quality: Double? = qualStr == "." ? nil : Double(qualStr)
            let filter = fields[6] == "." ? nil : fields[6]

            // Classify variant type
            let altAlleles = alt.split(separator: ",").map(String.init)
            let variantType = classifyVariant(ref: ref, alts: altAlleles)

            // Compute end position (0-based, exclusive)
            let endPos: Int
            // Check for END in INFO field
            let infoField = fields[7]
            if let endValue = parseINFOEnd(infoField) {
                endPos = endValue  // INFO END is already 1-based inclusive, convert to 0-based exclusive
            } else {
                endPos = position + ref.count
            }

            // Store raw INFO for optional parsing later
            let infoStr = fields[7] == "." ? nil : fields[7]

            sqlite3_reset(insertStmt)
            sqlite3_bind_text(insertStmt, 1, (chromosome as NSString).utf8String, -1, nil)
            sqlite3_bind_int64(insertStmt, 2, Int64(position))
            sqlite3_bind_int64(insertStmt, 3, Int64(endPos))
            sqlite3_bind_text(insertStmt, 4, (variantID as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 5, (ref as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 6, (alt as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 7, (variantType as NSString).utf8String, -1, nil)
            if let q = quality {
                sqlite3_bind_double(insertStmt, 8, q)
            } else {
                sqlite3_bind_null(insertStmt, 8)
            }
            if let f = filter {
                sqlite3_bind_text(insertStmt, 9, (f as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(insertStmt, 9)
            }
            if let info = infoStr {
                sqlite3_bind_text(insertStmt, 10, (info as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(insertStmt, 10)
            }

            if sqlite3_step(insertStmt) != SQLITE_DONE {
                variantDBLogger.warning("Failed to insert variant: \(variantID)")
            }
            insertCount += 1
        }

        // Create indexes after bulk insert (faster)
        sqlite3_exec(db, "CREATE INDEX idx_variants_region ON variants(chromosome, position, end_pos)", nil, nil, nil)
        sqlite3_exec(db, "CREATE INDEX idx_variants_type ON variants(variant_type)", nil, nil, nil)
        sqlite3_exec(db, "CREATE INDEX idx_variants_id ON variants(variant_id COLLATE NOCASE)", nil, nil, nil)

        sqlite3_exec(db, "COMMIT", nil, nil, nil)

        variantDBLogger.info("Created variant database with \(insertCount) records at \(outputURL.lastPathComponent)")
        return insertCount
    }

    // MARK: - Variant Classification

    /// Classifies a variant based on ref/alt alleles.
    private static func classifyVariant(ref: String, alts: [String]) -> String {
        guard let firstAlt = alts.first, !firstAlt.isEmpty, firstAlt != "." else {
            return VariantType.reference.rawValue
        }

        if ref.count == 1 && firstAlt.count == 1 {
            return VariantType.snp.rawValue
        } else if ref.count > firstAlt.count {
            return VariantType.deletion.rawValue
        } else if ref.count < firstAlt.count {
            return VariantType.insertion.rawValue
        } else if ref.count == firstAlt.count && ref.count > 1 {
            return VariantType.mnp.rawValue
        } else {
            return VariantType.complex.rawValue
        }
    }

    /// Parses the END value from a VCF INFO field string.
    private static func parseINFOEnd(_ info: String) -> Int? {
        guard info != "." else { return nil }
        for pair in info.split(separator: ";") {
            if pair.hasPrefix("END=") {
                let value = pair.dropFirst(4)
                if let endVal = Int(value) {
                    // VCF END is 1-based inclusive; convert to 0-based exclusive = endVal (since 1-based inclusive N = 0-based exclusive N)
                    return endVal
                }
            }
        }
        return nil
    }
}

// MARK: - Errors

public enum VariantDatabaseError: Error, LocalizedError, Sendable {
    case openFailed(String)
    case createFailed(String)

    public var errorDescription: String? {
        switch self {
        case .openFailed(let msg): return "Failed to open variant database: \(msg)"
        case .createFailed(let msg): return "Failed to create variant database: \(msg)"
        }
    }
}
