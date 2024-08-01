//
//  TMProfileVO.swift
//  Shoak
//
//  Created by 정종인 on 7/28/24.
//

import Foundation

struct TMProfileVO: Codable, Equatable {
    
    var name: String
    var imageURL: String?
}

extension TMProfileVO {
    static var testData: TMProfileVO {
        TMProfileVO(name: "이빈치", imageURL: "https://ada-mc3.s3.ap-northeast-2.amazonaws.com/profile/a7b899ae-528e-4e37-a6f1-e9ac08ab50c9vinci.jpeg")
    }
}
