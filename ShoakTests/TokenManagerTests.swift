//
//  TokenManagerTests.swift
//  ShoakTests
//
//  Created by 정종인 on 7/29/24.
//

import XCTest
@testable import Shoak

final class TokenManagerTests: XCTestCase {

    var tokenManager: TokenManager!

    var now: TimeInterval {
        Date().timeIntervalSince1970
    }

    var testURLRequest: URLRequest {
        try! URLRequest(url: URL(string: "https://mosu.blog")!, method: .get, headers: ["Authorization": ""])
    }

    var sampleAccessTokenString: String {
        "abcdabcdabcd"
    }

    var sampleRefreshTokenString: String {
        "bcdbcdbcdbcd"
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        tokenManager = TokenManager(refreshAPIService: TokenRefreshAPIService(isTesting: true))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    private func storeExampleAccessTokens(accessTokenExpiredTime: Int, refreshTokenExpiredTime: Int) {
        let accessTokenExpiredTime = Int(accessTokenExpiredTime)
        let refreshTokenExpiredTime = Int(refreshTokenExpiredTime)
        let sampleAccessToken = AccessToken(token: sampleAccessTokenString, expiredIn: accessTokenExpiredTime)
        let sampleRefreshToken = RefreshToken(token: sampleRefreshTokenString, expiredIn: refreshTokenExpiredTime)

        tokenManager.save(sampleAccessToken)
        tokenManager.save(sampleRefreshToken)
    }

    func test_엑세스_토큰이_유효할_때_헤더가_잘_갱신되는지() async throws {
        let accessTokenExpiredTime = Int(now + 60) // 60초
        let refreshTokenExpiredTime = Int(now + 600) // 600초

        storeExampleAccessTokens(accessTokenExpiredTime: accessTokenExpiredTime, refreshTokenExpiredTime: refreshTokenExpiredTime)

        let validationResult = await tokenManager.validTokenAndAddHeader(request: testURLRequest)

        switch validationResult {
        case .success(let success):
            XCTAssertEqual(success.headers["Authorization"]!, "Bearer " + self.sampleAccessTokenString)
        case .failure:
            XCTFail()
        }
    }

    func test_TokenRefreshAPI가_잘_작동하는지() async throws {
        let accessTokenExpiredTime = Int(now + -60) // -60초
        let refreshTokenExpiredTime = Int(now + 600) // 600초

        storeExampleAccessTokens(accessTokenExpiredTime: accessTokenExpiredTime, refreshTokenExpiredTime: refreshTokenExpiredTime)

        let validationResult = await tokenManager.validTokenAndAddHeader(request: testURLRequest)

        switch validationResult {
        case .success(let success):
            let convertedAuthHeader = success.headers["Authorization"]!
            print("바뀐 토큰 헤더 : \(convertedAuthHeader).")
            XCTAssertNotEqual(convertedAuthHeader, "Bearer ")
            XCTAssertNotEqual(convertedAuthHeader, "Bearer " + self.sampleAccessTokenString)
        case .failure:
            XCTFail()
        }
    }

    func test_리프레쉬_토큰도_만료되었을_때_오류_잘_던지는지() async throws {
        let accessTokenExpiredTime = Int(now + -60) // -60초
        let refreshTokenExpiredTime = Int(now + -600) // -600초

        storeExampleAccessTokens(accessTokenExpiredTime: accessTokenExpiredTime, refreshTokenExpiredTime: refreshTokenExpiredTime)

        let validationResult = await tokenManager.validTokenAndAddHeader(request: testURLRequest)
        switch validationResult {
        case .success(let success):
            XCTFail()
        case .failure(let failure):
            XCTAssertEqual(failure, TokenError.refreshTokenExpired)
        }
    }

}
