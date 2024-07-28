//
//  UserUseCaseTests.swift
//  ShoakTests
//
//  Created by 정종인 on 7/27/24.
//

import XCTest
@testable import Shoak

final class UserUseCaseTests: XCTestCase {

    var userUseCase: UserUseCase!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let apiClient = TestAPIClient()
        let userRepository = UserRepository(apiClient: apiClient)
        self.userUseCase = UserUseCase(userRepository: userRepository)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_친구_불러오기() async throws {
        let result = await userUseCase.getFriends()
        switch result {
        case .success(let success):
            XCTAssert((success as Any) is [TMFriendVO])
        case .failure(let failure):
            XCTFail(failure.errorDescription)
        }
    }

    func test_프로필_불러오기() async throws {
        let result = await userUseCase.getProfile()
        switch result {
        case .success(let success):
            XCTAssert((success as Any) is TMProfileVO)
        case .failure(let failure):
            XCTFail(failure.errorDescription)
        }
    }

    func test_프로필_이미지_업로드하기() async throws {
        let image = UIImage(systemName: "figure.sailing")!
        let result = await userUseCase.uploadProfileImage(image: image)
        switch result {
        case .success(let success):
            dump(success)
            XCTAssert((success as Any) is TMProfileVO)
        case .failure(let failure):
            XCTFail(failure.errorDescription)
        }
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
