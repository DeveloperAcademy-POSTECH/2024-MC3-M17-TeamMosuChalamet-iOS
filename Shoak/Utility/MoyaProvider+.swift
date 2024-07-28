//
//  MoyaProvider+.swift
//  Shoak
//
//  Created by 정종인 on 7/27/24.
//

import Moya

extension MoyaProvider {
    func request(_ target: Target) async -> Result<Response, MoyaError> {
        await withCheckedContinuation { continuation in
            self.request(target) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
