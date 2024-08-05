//
//  TMMemberID.swift
//  Shoak
//
//  Created by 정종인 on 7/24/24.
//

import Foundation

public typealias TMMemberID = Int64

extension TMMemberID: @retroactive Identifiable {
    public var id: TMMemberID {
        return self
    }
}
