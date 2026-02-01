// PathoplexusAuthTests.swift - Tests for Pathoplexus authentication
// Copyright (c) 2024 Lungfish Contributors
// SPDX-License-Identifier: MIT

import XCTest
@testable import LungfishCore

final class PathoplexusAuthTests: XCTestCase {

    var mockClient: MockHTTPClient!
    var authenticator: PathoplexusAuthenticator!

    override func setUp() async throws {
        mockClient = MockHTTPClient()
        authenticator = PathoplexusAuthenticator(httpClient: mockClient)
    }

    // MARK: - Authentication Tests

    func testAuthenticateReturnsToken() async throws {
        await mockClient.registerKeycloakToken(
            accessToken: "test-access-token",
            refreshToken: "test-refresh-token",
            expiresIn: 36000
        )

        let token = try await authenticator.authenticate(username: "testuser", password: "testpass")

        XCTAssertEqual(token.accessToken, "test-access-token")
        XCTAssertEqual(token.refreshToken, "test-refresh-token")
        XCTAssertEqual(token.tokenType, "Bearer")
        XCTAssertFalse(token.isExpired)
    }

    func testAuthenticateSendsCorrectRequest() async throws {
        await mockClient.registerKeycloakToken()

        _ = try await authenticator.authenticate(username: "myuser", password: "mypass")

        let requests = await mockClient.requests
        XCTAssertEqual(requests.count, 1)

        let request = requests[0]
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(request.url!.absoluteString.contains("openid-connect/token"))

        let body = String(data: request.httpBody!, encoding: .utf8)!
        XCTAssertTrue(body.contains("grant_type=password"))
        XCTAssertTrue(body.contains("username=myuser"))
    }

    func testAuthenticateWithInvalidCredentials() async throws {
        await mockClient.register(pattern: "openid-connect/token", response: .error(statusCode: 401, message: "Invalid credentials"))

        do {
            _ = try await authenticator.authenticate(username: "bad", password: "wrong")
            XCTFail("Should have thrown an error")
        } catch let error as PathoplexusAuthError {
            if case .invalidCredentials = error {
                // Expected
            } else {
                XCTFail("Expected invalidCredentials error, got \(error)")
            }
        }
    }

    func testAuthenticateHandlesServerUnavailable() async throws {
        await mockClient.register(pattern: "openid-connect/token", response: .error(statusCode: 503, message: "Service Unavailable"))

        do {
            _ = try await authenticator.authenticate(username: "user", password: "pass")
            XCTFail("Should have thrown an error")
        } catch let error as PathoplexusAuthError {
            if case .keycloakUnavailable = error {
                // Expected
            } else {
                XCTFail("Expected keycloakUnavailable error, got \(error)")
            }
        }
    }

    // MARK: - Token Refresh Tests

    func testRefreshTokenReturnsNewToken() async throws {
        await mockClient.registerKeycloakToken(
            accessToken: "new-access-token",
            refreshToken: "new-refresh-token"
        )

        let oldToken = PathoplexusToken(
            accessToken: "old-access",
            refreshToken: "old-refresh",
            expiresAt: Date().addingTimeInterval(-60),  // Expired
            refreshExpiresAt: Date().addingTimeInterval(3600)  // Still valid
        )

        let newToken = try await authenticator.refreshToken(oldToken)

        XCTAssertEqual(newToken.accessToken, "new-access-token")
        XCTAssertEqual(newToken.refreshToken, "new-refresh-token")
        XCTAssertFalse(newToken.isExpired)
    }

    func testRefreshTokenSendsCorrectRequest() async throws {
        await mockClient.registerKeycloakToken()

        let token = PathoplexusToken(
            accessToken: "access",
            refreshToken: "my-refresh-token",
            expiresAt: Date().addingTimeInterval(-60),
            refreshExpiresAt: Date().addingTimeInterval(3600)
        )

        _ = try await authenticator.refreshToken(token)

        let requests = await mockClient.requests
        XCTAssertEqual(requests.count, 1)

        let body = String(data: requests[0].httpBody!, encoding: .utf8)!
        XCTAssertTrue(body.contains("grant_type=refresh_token"))
        XCTAssertTrue(body.contains("refresh_token=my-refresh-token"))
    }

    func testRefreshTokenFailsWhenRefreshExpired() async throws {
        let expiredToken = PathoplexusToken(
            accessToken: "access",
            refreshToken: "refresh",
            expiresAt: Date().addingTimeInterval(-3600),
            refreshExpiresAt: Date().addingTimeInterval(-60)  // Refresh also expired
        )

        do {
            _ = try await authenticator.refreshToken(expiredToken)
            XCTFail("Should have thrown an error")
        } catch let error as PathoplexusAuthError {
            if case .refreshFailed(let reason) = error {
                XCTAssertTrue(reason.contains("expired"))
            } else {
                XCTFail("Expected refreshFailed error")
            }
        }
    }

    // MARK: - GetValidToken Tests

    func testGetValidTokenReturnsTokenIfNotExpired() async throws {
        let validToken = PathoplexusToken(
            accessToken: "valid-access",
            refreshToken: "refresh",
            expiresAt: Date().addingTimeInterval(3600),
            refreshExpiresAt: Date().addingTimeInterval(7200)
        )

        let result = try await authenticator.getValidToken(validToken)

        XCTAssertEqual(result.accessToken, "valid-access")

        // Should not have made any network requests
        let requests = await mockClient.requests
        XCTAssertTrue(requests.isEmpty)
    }

    func testGetValidTokenRefreshesExpiredToken() async throws {
        await mockClient.registerKeycloakToken(accessToken: "refreshed-access")

        let expiredToken = PathoplexusToken(
            accessToken: "expired-access",
            refreshToken: "valid-refresh",
            expiresAt: Date().addingTimeInterval(-60),  // Expired
            refreshExpiresAt: Date().addingTimeInterval(3600)  // Refresh valid
        )

        let result = try await authenticator.getValidToken(expiredToken)

        XCTAssertEqual(result.accessToken, "refreshed-access")
    }

    func testGetValidTokenThrowsWhenBothExpired() async throws {
        let fullyExpiredToken = PathoplexusToken(
            accessToken: "expired",
            refreshToken: "also-expired",
            expiresAt: Date().addingTimeInterval(-3600),
            refreshExpiresAt: Date().addingTimeInterval(-60)
        )

        do {
            _ = try await authenticator.getValidToken(fullyExpiredToken)
            XCTFail("Should have thrown an error")
        } catch let error as PathoplexusAuthError {
            if case .tokenExpired = error {
                // Expected
            } else {
                XCTFail("Expected tokenExpired error")
            }
        }
    }

    // MARK: - Logout Tests

    func testLogoutClearsCurrentToken() async throws {
        await mockClient.registerKeycloakToken()

        // First authenticate
        _ = try await authenticator.authenticate(username: "user", password: "pass")

        // Verify we have a valid token
        let tokenBefore = await authenticator.validToken
        XCTAssertNotNil(tokenBefore)

        // Logout
        await authenticator.logout()

        // Verify token is cleared
        let tokenAfter = await authenticator.validToken
        XCTAssertNil(tokenAfter)
    }
}

// MARK: - PathoplexusToken Tests

final class PathoplexusTokenTests: XCTestCase {

    func testTokenIsExpired() {
        let expiredToken = PathoplexusToken(
            accessToken: "access",
            refreshToken: "refresh",
            expiresAt: Date().addingTimeInterval(-60),
            refreshExpiresAt: Date().addingTimeInterval(3600)
        )

        XCTAssertTrue(expiredToken.isExpired)
    }

    func testTokenIsNotExpired() {
        let validToken = PathoplexusToken(
            accessToken: "access",
            refreshToken: "refresh",
            expiresAt: Date().addingTimeInterval(3600),
            refreshExpiresAt: Date().addingTimeInterval(7200)
        )

        XCTAssertFalse(validToken.isExpired)
    }

    func testTokenCanRefresh() {
        let token = PathoplexusToken(
            accessToken: "access",
            refreshToken: "refresh",
            expiresAt: Date().addingTimeInterval(-60),
            refreshExpiresAt: Date().addingTimeInterval(3600)
        )

        XCTAssertTrue(token.canRefresh)
    }

    func testTokenCannotRefresh() {
        let token = PathoplexusToken(
            accessToken: "access",
            refreshToken: "refresh",
            expiresAt: Date().addingTimeInterval(-3600),
            refreshExpiresAt: Date().addingTimeInterval(-60)
        )

        XCTAssertFalse(token.canRefresh)
    }

    func testAuthorizationHeader() {
        let token = PathoplexusToken(
            accessToken: "my-access-token",
            refreshToken: "refresh",
            expiresAt: Date().addingTimeInterval(3600),
            refreshExpiresAt: Date().addingTimeInterval(7200),
            tokenType: "Bearer"
        )

        XCTAssertEqual(token.authorizationHeader, "Bearer my-access-token")
    }

    func testTokenCodable() throws {
        let token = PathoplexusToken(
            accessToken: "access123",
            refreshToken: "refresh456",
            expiresAt: Date(timeIntervalSince1970: 1704067200),
            refreshExpiresAt: Date(timeIntervalSince1970: 1704153600),
            tokenType: "Bearer"
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(token)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(PathoplexusToken.self, from: data)

        XCTAssertEqual(decoded.accessToken, token.accessToken)
        XCTAssertEqual(decoded.refreshToken, token.refreshToken)
        XCTAssertEqual(decoded.tokenType, token.tokenType)
    }

    func testTimeUntilExpiration() {
        let futureDate = Date().addingTimeInterval(3600)
        let token = PathoplexusToken(
            accessToken: "access",
            refreshToken: "refresh",
            expiresAt: futureDate,
            refreshExpiresAt: Date().addingTimeInterval(7200)
        )

        let timeLeft = token.timeUntilExpiration
        XCTAssertGreaterThan(timeLeft, 3500)  // Should be close to 3600
        XCTAssertLessThanOrEqual(timeLeft, 3600)
    }
}

// MARK: - PathoplexusAuthError Tests

final class PathoplexusAuthErrorTests: XCTestCase {

    func testErrorDescriptions() {
        let errors: [PathoplexusAuthError] = [
            .invalidCredentials,
            .tokenExpired,
            .refreshFailed("test reason"),
            .networkError("network issue"),
            .serverError(500, "internal error"),
            .invalidResponse,
            .keycloakUnavailable
        ]

        for error in errors {
            XCTAssertNotNil(error.errorDescription)
            XCTAssertFalse(error.errorDescription!.isEmpty)
        }
    }

    func testInvalidCredentialsDescription() {
        let error = PathoplexusAuthError.invalidCredentials
        XCTAssertTrue(error.errorDescription!.lowercased().contains("invalid"))
    }

    func testServerErrorIncludesCode() {
        let error = PathoplexusAuthError.serverError(503, "Service Unavailable")
        XCTAssertTrue(error.errorDescription!.contains("503"))
    }

    func testRefreshFailedIncludesReason() {
        let error = PathoplexusAuthError.refreshFailed("custom reason here")
        XCTAssertTrue(error.errorDescription!.contains("custom reason here"))
    }
}
