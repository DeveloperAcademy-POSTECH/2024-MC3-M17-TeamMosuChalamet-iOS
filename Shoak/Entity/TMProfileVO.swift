//
//  TMProfileVO.swift
//  Shoak
//
//  Created by 정종인 on 7/24/24.
//

import SwiftUI

struct TMProfileVO {
    var memberID: TMMemberID
    var imageURLString: String?
    var name: String
}

extension TMProfileVO {
    static var mockData: TMProfileVO {
        TMProfileVO(memberID: "TestData from VO",imageURLString: "https://picsum.photos/200/200", name: "TestName from VO")
    }
}
