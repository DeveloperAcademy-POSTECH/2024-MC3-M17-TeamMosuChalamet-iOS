//
//  TMProfileVO.swift
//  Shoak
//
//  Created by 정종인 on 7/24/24.
//

import SwiftUI

struct TMProfileVO: Equatable {
    var memberID: TMMemberID
    var imageURLString: String?
    var name: String
}

extension TMProfileVO {
    static var mockData: TMProfileVO {
        TMProfileVO(memberID: 123123, imageURLString: "https://picsum.photos/200/200", name: "TestName from VO")
    }
    static var mockData2: TMProfileVO {
        TMProfileVO(memberID: 234234, imageURLString: "https://picsum.photos/200/200", name: "TestName from VO 2")
    }
}

extension Array where Element == TMProfileVO {
    static var testData: [TMProfileVO] {
        [
            TMProfileVO(memberID: 2, imageURLString: "https://ada-mc3.s3.ap-northeast-2.amazonaws.com/profile/kumi.jpeg", name: "백쿠미Test"),
            TMProfileVO(memberID: 3, imageURLString: "https://ada-mc3.s3.ap-northeast-2.amazonaws.com/profile/mosu.png", name: "정모수Test")
        ]
    }
}


extension Array where Element == TMProfileVO {
    static var mockData: [Element] {
        [
            .mockData,
            .mockData2
        ]
    }
}
