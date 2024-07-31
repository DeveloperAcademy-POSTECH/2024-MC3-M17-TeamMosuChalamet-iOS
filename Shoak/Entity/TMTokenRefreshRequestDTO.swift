//
//  TMTokenRefreshRequestDTO.swift
//  Shoak
//
//  Created by 정종인 on 7/31/24.
//

import Foundation

struct TMTokenRefreshRequestDTO: Codable {
    let identityToken: String
    let name: String
    let deviceToken: String
}
