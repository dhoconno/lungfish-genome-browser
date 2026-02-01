// PathoplexusAuth.swift - Keycloak authentication for Pathoplexus
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT
//
// Owner: Workflow Integration Lead (Role 14)

import Foundation

// MARK: - Pathoplexus Token

/// Authentication token for Pathoplexus API access.
public struct PathoplexusToken: Sendable, Codable {
    /// The access token for API requests
    public let accessToken: String

    /// The refresh token for obtaining new access tokens
    public let refreshToken: String

    /// Token expiration time
    public let expiresAt: Date

    /// Refresh token expiration time
    public let refreshExpiresAt: Date

    /// Token type (typically "Bearer")
    public let tokenType: String

    /// Whether the token is expired
    public var isExpired: Bool {
        Date() >= expiresAt
    }

    /// Whether the token can be refreshed
    public var canRefresh: Bool {
        Date() < refreshExpiresAt
    }

    /// Time until token expires
    public var timeUntilExpiration: TimeInterval {
        expiresAt.timeIntervalSince(Date())
    }

    public init(
        accessToken: String,
        refreshToken: String,
        expiresAt: Date,
        refreshExpiresAt: Date,
        tokenType: String = "Bearer"
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresAt = expiresAt
        self.refreshExpiresAt = refreshExpiresAt
        self.tokenType = tokenType
    }

    /// Creates authorization header value
    public var authorizationHeader: String {
        "\(tokenType) \(accessToken)"
    }
}

// MARK: - Keycloak Response

/// Response from Keycloak token endpoint.
private struct KeycloakTokenResponse: Codable {
    let access_token: String
    let refresh_token: String
    let expires_in: Int
    let refresh_expires_in: Int
    let token_type: String
}

// MARK: - Authentication Errors

/// Errors that can occur during Pathoplexus authentication.
public enum PathoplexusAuthError: Error, Sendable, LocalizedError {
    case invalidCredentials
    case tokenExpired
    case refreshFailed(String)
    case networkError(String)
    case serverError(Int, String)
    case invalidResponse
    case keycloakUnavailable

    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid username or password"
        case .tokenExpired:
            return "Authentication token has expired"
        case .refreshFailed(let reason):
            return "Failed to refresh token: \(reason)"
        case .networkError(let message):
            return "Network error: \(message)"
        case .serverError(let code, let message):
            return "Server error (\(code)): \(message)"
        case .invalidResponse:
            return "Invalid response from authentication server"
        case .keycloakUnavailable:
            return "Authentication service is unavailable"
        }
    }
}

// MARK: - Pathoplexus Authenticator

/// Handles authentication with Pathoplexus via Keycloak.
public actor PathoplexusAuthenticator {

    // MARK: - Properties

    /// Keycloak authentication base URL
    public let authURL: URL

    /// Keycloak realm for Pathoplexus
    public let realm: String

    /// Client ID for Pathoplexus
    public let clientId: String

    /// HTTP client for making requests
    private let httpClient: HTTPClient

    /// Current token (if authenticated)
    private var currentToken: PathoplexusToken?

    // MARK: - Configuration

    /// Default Pathoplexus authentication URL
    public static let defaultAuthURL = URL(string: "https://authentication.pathoplexus.org")!

    /// Default realm for Pathoplexus
    public static let defaultRealm = "loculus"

    /// Default client ID
    public static let defaultClientId = "backend-client"

    // MARK: - Initialization

    public init(
        authURL: URL = defaultAuthURL,
        realm: String = defaultRealm,
        clientId: String = defaultClientId,
        httpClient: HTTPClient = URLSessionHTTPClient()
    ) {
        self.authURL = authURL
        self.realm = realm
        self.clientId = clientId
        self.httpClient = httpClient
    }

    // MARK: - Authentication

    /// Authenticates with username and password.
    ///
    /// - Parameters:
    ///   - username: Pathoplexus username
    ///   - password: Pathoplexus password
    /// - Returns: Authentication token
    /// - Throws: `PathoplexusAuthError` if authentication fails
    public func authenticate(username: String, password: String) async throws -> PathoplexusToken {
        let tokenURL = authURL
            .appendingPathComponent("realms")
            .appendingPathComponent(realm)
            .appendingPathComponent("protocol")
            .appendingPathComponent("openid-connect")
            .appendingPathComponent("token")

        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let body = [
            "grant_type": "password",
            "client_id": clientId,
            "username": username,
            "password": password
        ]

        request.httpBody = body
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? $0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)

        do {
            let (data, response) = try await httpClient.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw PathoplexusAuthError.invalidResponse
            }

            switch httpResponse.statusCode {
            case 200:
                let token = try parseTokenResponse(data)
                currentToken = token
                return token

            case 401:
                throw PathoplexusAuthError.invalidCredentials

            case 503:
                throw PathoplexusAuthError.keycloakUnavailable

            default:
                let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw PathoplexusAuthError.serverError(httpResponse.statusCode, message)
            }
        } catch let error as PathoplexusAuthError {
            throw error
        } catch {
            throw PathoplexusAuthError.networkError(error.localizedDescription)
        }
    }

    /// Refreshes an expired token.
    ///
    /// - Parameter token: The token to refresh
    /// - Returns: A new authentication token
    /// - Throws: `PathoplexusAuthError` if refresh fails
    public func refreshToken(_ token: PathoplexusToken) async throws -> PathoplexusToken {
        guard token.canRefresh else {
            throw PathoplexusAuthError.refreshFailed("Refresh token has expired")
        }

        let tokenURL = authURL
            .appendingPathComponent("realms")
            .appendingPathComponent(realm)
            .appendingPathComponent("protocol")
            .appendingPathComponent("openid-connect")
            .appendingPathComponent("token")

        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let body = [
            "grant_type": "refresh_token",
            "client_id": clientId,
            "refresh_token": token.refreshToken
        ]

        request.httpBody = body
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? $0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)

        do {
            let (data, response) = try await httpClient.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw PathoplexusAuthError.invalidResponse
            }

            switch httpResponse.statusCode {
            case 200:
                let newToken = try parseTokenResponse(data)
                currentToken = newToken
                return newToken

            case 400, 401:
                throw PathoplexusAuthError.refreshFailed("Invalid refresh token")

            default:
                let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw PathoplexusAuthError.serverError(httpResponse.statusCode, message)
            }
        } catch let error as PathoplexusAuthError {
            throw error
        } catch {
            throw PathoplexusAuthError.networkError(error.localizedDescription)
        }
    }

    /// Gets a valid token, refreshing if necessary.
    ///
    /// - Parameter token: The token to validate/refresh
    /// - Returns: A valid token
    /// - Throws: `PathoplexusAuthError` if token cannot be obtained
    public func getValidToken(_ token: PathoplexusToken) async throws -> PathoplexusToken {
        if !token.isExpired {
            return token
        }

        if token.canRefresh {
            return try await refreshToken(token)
        }

        throw PathoplexusAuthError.tokenExpired
    }

    /// Logs out and invalidates the current token.
    public func logout() async {
        currentToken = nil
    }

    /// Returns the current token if available and valid.
    public var validToken: PathoplexusToken? {
        guard let token = currentToken, !token.isExpired else {
            return nil
        }
        return token
    }

    // MARK: - Private Helpers

    private func parseTokenResponse(_ data: Data) throws -> PathoplexusToken {
        let decoder = JSONDecoder()

        guard let response = try? decoder.decode(KeycloakTokenResponse.self, from: data) else {
            throw PathoplexusAuthError.invalidResponse
        }

        let now = Date()
        return PathoplexusToken(
            accessToken: response.access_token,
            refreshToken: response.refresh_token,
            expiresAt: now.addingTimeInterval(TimeInterval(response.expires_in)),
            refreshExpiresAt: now.addingTimeInterval(TimeInterval(response.refresh_expires_in)),
            tokenType: response.token_type
        )
    }
}

// MARK: - Secure Token Storage

/// Protocol for secure token storage.
public protocol TokenStorage: Sendable {
    func store(_ token: PathoplexusToken, forUser username: String) async throws
    func retrieve(forUser username: String) async throws -> PathoplexusToken?
    func delete(forUser username: String) async throws
}

/// Keychain-based token storage for macOS.
public actor KeychainTokenStorage: TokenStorage {

    private let service = "com.lungfish.pathoplexus"

    public init() {}

    public func store(_ token: PathoplexusToken, forUser username: String) async throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(token)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: username,
            kSecValueData as String: data
        ]

        // Delete existing item first
        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unableToStore
        }
    }

    public func retrieve(forUser username: String) async throws -> PathoplexusToken? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: username,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess, let data = result as? Data else {
            return nil
        }

        let decoder = JSONDecoder()
        return try? decoder.decode(PathoplexusToken.self, from: data)
    }

    public func delete(forUser username: String) async throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: username
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unableToDelete
        }
    }

    public enum KeychainError: Error {
        case unableToStore
        case unableToDelete
    }
}
