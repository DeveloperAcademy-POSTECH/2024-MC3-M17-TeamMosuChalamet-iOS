//
//  NetworkHandler.swift
//  Shoak
//
//  Created by 정종인 on 7/28/24.
//

import Foundation
import Moya

public final class NetworkHandler {
    public static func requestDecoded<T: Decodable>(by response: Response) -> Result<T, NetworkError> {
        let decoder = JSONDecoder()

        switch response.statusCode {
        case 200..<300:
            guard let decodedData = try? decoder.decode(T.self, from: response.data) else {
                return .failure(.decodeError)
            }
            return .success(decodedData)
        case 300..<500:
            guard let errorResponse = try? decoder.decode(ErrorResponse.self, from: response.data) else {
                return .failure(.pathError)
            }
            return .failure(.requestError(errorResponse))
        default:
            return .failure(.networkFail)
        }
    }
}
