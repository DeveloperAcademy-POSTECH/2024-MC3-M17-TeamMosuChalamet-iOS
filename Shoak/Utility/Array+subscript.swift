//
//  Array+subscript.swift
//  Shoak
//
//  Created by 정종인 on 7/29/24.
//

import Foundation

extension Array {
    /// 안전하게 인덱스로 배열에 접근할 수 있도록 한다.
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
