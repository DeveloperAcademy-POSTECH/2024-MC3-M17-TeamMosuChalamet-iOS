//
//  TMFriendVO.swift
//  Shoak
//
//  Created by 정종인 on 7/24/24.
//

import SwiftUI

struct TMFriendVO: Equatable {
    var memberID: TMMemberID
    var imageURLString: String?
    var name: String
}

extension TMFriendVO {
    static var mockData: TMFriendVO {
        TMFriendVO(memberID: 123123, imageURLString: "https://picsum.photos/200/200", name: "TestName from VO")
    }
    static var mockData2: TMFriendVO {
        TMFriendVO(memberID: 234234, imageURLString: "https://picsum.photos/200/200", name: "TestName from VO 2")
    }
}

extension Array where Element == TMFriendVO {
    static var testData: [TMFriendVO] {
        [
            TMFriendVO(memberID: 2, imageURLString: "https://ada-mc3.s3.ap-northeast-2.amazonaws.com/profile/kumi.jpeg", name: "백쿠미Test"),
            TMFriendVO(memberID: 3, imageURLString: "https://ada-mc3.s3.ap-northeast-2.amazonaws.com/profile/mosu.png", name: "정모수Test")
        ]
    }
}


extension Array where Element == TMFriendVO {
    static var mockData: [Element] {
        [
            .mockData,
            .mockData2
        ]
    }
}
