//
//  TMProfileDTO.swift
//  Shoak
//
//  Created by 정종인 on 7/24/24.
//

import Foundation

struct TMProfileDTO {
    var memberID: TMMemberID
    var imageURLString: String?
    var name: String
}

extension TMProfileDTO {
    static var mockData: TMProfileDTO {
        TMProfileDTO(memberID: "TestData", imageURLString: "https://picsum.photos/200/300", name: "TestName")
    }
}
