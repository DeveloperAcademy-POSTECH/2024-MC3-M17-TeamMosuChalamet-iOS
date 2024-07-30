//
//  AuthUseCaseTests.swift
//  ShoakTests
//
//  Created by 정종인 on 7/29/24.
//

import XCTest
@testable import Shoak

final class AuthUseCaseTests: XCTestCase {

    var apiClient: APIClient!
    var authUseCase: AuthUseCase!

    override func setUpWithError() throws {
        let apiClient = TestAPIClient()
//        let apiClient = DefaultAPIClient(tokenManager: TokenManager(refreshAPIService: TokenRefreshAPIService(isTesting: true)))
        self.apiClient = apiClient
        let repository = AuthRepository(apiClient: apiClient)
        authUseCase = AuthUseCase(authRepository: repository)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }

    func test_로그인_테스트() async throws {
        let identityToken = "abcdabcdabcdabcd"
        let result = await authUseCase.loginOrSignUp(identityToken: identityToken)
        switch result {
        case .success(let success):
            XCTAssert((success as Any) is TMProfileVO)
        case .failure(let failure):
            XCTFail(failure.errorDescription)
        }
    }

    func test_로그인_할_때_토큰도_잘_저장_되는지() async throws {
        try await test_로그인_테스트()

        guard let tokenManagable = apiClient as? TokenManagable else {
            XCTFail("Token을 Manage할 수 있는 APIClient가 아닙니다.")
            return
        }

        XCTAssertNotNil(tokenManagable.tokenManager.getAccessToken(), "Access Token이 Nil입니다")
        XCTAssertNotNil(tokenManagable.tokenManager.getRefreshToken(), "Refresh Token이 Nil입니다")

    }
}
