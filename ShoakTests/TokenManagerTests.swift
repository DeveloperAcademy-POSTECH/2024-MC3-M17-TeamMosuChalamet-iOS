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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        tokenManager = TokenManager(refreshAPIService: TokenRefreshAPIService())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_엑세스_토큰이_유효할_때_헤더가_잘_갱신되는지() throws {
        let now = Date().timeIntervalSince1970
        let accessTokenExpiredTime = Int(now + 60) // 60초
        let refreshTokenExpiredTime = Int(now + 600) // 600초
        let sampleAccessToken = AccessToken(token: "abcdabcdabcd", expiredIn: accessTokenExpiredTime)
        let sampleRefreshToken = RefreshToken(token: "bcdbcdbcdbcd", expiredIn: refreshTokenExpiredTime)

        tokenManager.save(sampleAccessToken)
        tokenManager.save(sampleRefreshToken)

        let testURLRequest = try! URLRequest(url: URL(string: "https://mosu.blog")!, method: .get, headers: ["Authorization": ""])

        tokenManager.validTokenAndAddHeader(request: testURLRequest) { validationResult in
            switch validationResult {
            case .success(let success):
                XCTAssertEqual(success.headers["Authorization"]!, "Bearer " + sampleAccessToken.token)
            case .failure:
                XCTFail()
            }
        }
    }

    func test_엑세스_토큰이_유효하지_않을_때_헤더가_잘_갱신되는지() throws {
        // TODO: 실제 서버 연동 필요
    }

}
