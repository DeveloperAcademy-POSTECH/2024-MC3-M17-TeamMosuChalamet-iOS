//
//  TMFriendDTO.swift
//  Shoak
//
//  Created by 정종인 on 7/24/24.
//

import Foundation

struct TMFriendDTO: Codable {
    var id: TMMemberID
    var imageURL: String?
    var name: String
}

extension TMFriendDTO {
    static var mockData: TMFriendDTO {
        TMFriendDTO(id: 12314123, imageURL: "https://picsum.photos/200/300", name: "TestName")
    }
}

extension Array where Element == TMFriendDTO {
    static var testData: [TMFriendDTO] {
        [
            TMFriendDTO(id: 2, imageURL: "https://ada-mc3.s3.ap-northeast-2.amazonaws.com/profile/kumi.jpeg", name: "백쿠미Test"),
            TMFriendDTO(id: 3, imageURL: "https://ada-mc3.s3.ap-northeast-2.amazonaws.com/profile/mosu.png", name: "정모수Test")
        ]
    }
}
