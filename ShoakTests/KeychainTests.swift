//
//  KeychainTests.swift
//  ShoakTests
//
//  Created by 정종인 on 7/28/24.
//

import XCTest
@testable import Shoak

final class KeychainTests: XCTestCase {

    var keychain: Keychain<String>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        guard let service = Bundle.main.bundleIdentifier else {
            XCTFail("Identifier 없음")
            return
        }
        let sampleAccount = "SampleAccount"
        keychain = Keychain<String>(service: service, account: sampleAccount)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try keychain.deleteItem()
    }

    func test_item_저장하고_찾기() throws {
        let testItem: String = "TestItemHaHA"
        try keychain.saveItem(testItem)
        let searchedItem = try keychain.searchItem()
        XCTAssertEqual(testItem, searchedItem)
    }

    func test_item_저장하고_찾고_삭제하고_다시찾아보기() throws {
        let testItem: String = "TestItemHaHA"
        try keychain.saveItem(testItem)
        let searchedItem = try keychain.searchItem()
        XCTAssertEqual(testItem, searchedItem)
        try keychain.deleteItem()
        XCTAssertThrowsError(try keychain.searchItem())
    }

    func test_item_저장하고_갱신해보기() throws {
        let testItem: String = "TestItemHaHA"
        try keychain.saveItem(testItem)
        let searchedItem = try keychain.searchItem()
        XCTAssertEqual(testItem, searchedItem)

        let testItem2: String = "TestTwoItemHAHAHAHa"
        try keychain.saveItem(testItem2)
        let searchedItem2 = try keychain.searchItem()
        XCTAssertEqual(testItem2, searchedItem2)
    }

}
