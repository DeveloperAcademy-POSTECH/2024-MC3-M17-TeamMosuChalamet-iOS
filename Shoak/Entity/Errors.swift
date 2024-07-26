//
//  Errors.swift
//  Shoak
//
//  Created by 정종인 on 7/24/24.
//

import Foundation

enum Errors: Error {
    case networkError(code: Int)
    case error(description: String)
    case unknown
}
