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

        tokenManager = TokenManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_TokenRefreshAPI가_잘_작동하는지() async throws {
    }

}
