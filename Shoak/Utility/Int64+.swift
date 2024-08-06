//
//  Int64+.swift
//  Shoak
//
//  Created by 정종인 on 8/5/24.
//

extension Int64 {
    init?(_ string: String) {
        self.init(string, radix: 10)
    }
}
