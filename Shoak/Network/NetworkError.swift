//
//  NetworkError.swift
//  Shoak
//
//  Created by 정종인 on 7/27/24.
//

import Foundation

public enum NetworkError: Error, LocalizedError {
    case requestError(ErrorResponse)
    case decodeError
    case pathError
    case networkFail
    case other(String)
    case unknown
}

extension NetworkError {
    public var errorDescription: String {
        switch self {
        case .requestError(let errorResponse):
            "Request Error: \(errorResponse.message)"
        case .decodeError:
            "Decode Error"
        case .pathError:
            "Path Error"
        case .networkFail:
            "Network Fail"
        case .other(let string):
            "Other : \(string)"
        case .unknown:
            "Unknown Error"
        }
    }
}

public struct ErrorResponse: Error, Decodable {
    public let timestamp: String
    public let status: Int
    public let error: String
    public let message: String
    public let path: String
}
