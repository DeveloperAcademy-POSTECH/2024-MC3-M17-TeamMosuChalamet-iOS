//
//  TokenManagerTests.swift
//  ShoakTests
//
//  Created by 정종인 on 7/29/24.
//

import XCTest
@testable import Shoak

final class TokenManagerTests: XCTestCase {

    var keychainTokenRepository: KeychainTokenRepository!
    var tokenUseCase: TokenUseCase!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        keychainTokenRepository = KeychainTokenRepository()
        tokenUseCase = TokenUseCase(tokenRepository: keychainTokenRepository, tokenRefreshRepository: DefaultTokenRefreshRepository(tokenRepository: keychainTokenRepository))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_TokenRefreshAPI가_잘_작동하는지() async throws {
        let original = "eyJhbGciOiJIUzI1NiJ9.eyJjYXRlZ29yeSI6ImFjY2VzcyIsIm1lbWJlcklkIjoiNTEiLCJyb2xlIjoiUk9MRV9VU0VSIiwiaWF0IjoxNzIzNzkwOTAwLCJleHAiOjE3MjYzODI5MDB9.vJh2GvCoaV2kAndTaK4_1uhEJ1SyYyfdPl_KMP3xabQ"
        tokenUseCase.save(accessToken: original)
        tokenUseCase.save(refreshToken: "eyJhbGciOiJIUzI1NiJ9.eyJjYXRlZ29yeSI6InJlZnJlc2giLCJtZW1iZXJJZCI6IjUxIiwicm9sZSI6IlJPTEVfVVNFUiIsImlhdCI6MTcyMzc5MDk5OCwiZXhwIjoxNzI2MzgyOTk4fQ.5p6Mulou62luhoGoRoEUvcejUJzIbv-N4-Co9QA-pwY")

        if case .success(let result) = await tokenUseCase.refreshAccessAndRefreshToken() {
            print(result)
            XCTAssertFalse(original == tokenUseCase.tokenRepository.getAccessToken()!.token)
        } else {
            XCTFail()
        }
    }

    func test_TokenRefresh가_잘_되는지() async throws {
        let originalAccess = ""
        let originalRefresh = "eyJhbGciOiJIUzI1NiJ9.eyJjYXRlZ29yeSI6InJlZnJlc2giLCJtZW1iZXJJZCI6IjUxIiwicm9sZSI6IlJPTEVfVVNFUiIsImlhdCI6MTcyMzc5MjkwMSwiZXhwIjoxNzI2Mzg0OTAxfQ.3AkSG3I_NOx3gU0xLcyzQudU_BKg6a17YrVBhthPv-w"

        let defaultAPIClient = DefaultAPIClient(tokenRepository: keychainTokenRepository, tokenRefreshRepository: DefaultTokenRefreshRepository(tokenRepository: keychainTokenRepository))

        tokenUseCase.save(accessToken: originalAccess)
        tokenUseCase.save(refreshToken: originalRefresh)

        let userUseCase = UserUseCase(userRepository: UserRepository(apiClient: defaultAPIClient))
        let result = await userUseCase.getProfile()
        if case .failure(let failure) = result {
            print(failure)
            XCTFail()
        }
    }

}
