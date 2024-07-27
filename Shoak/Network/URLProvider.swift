//
//  URLProvider.swift
//  Shoak
//
//  Created by 정종인 on 7/27/24.
//

import Foundation

public protocol URLProvider {
    func provide(version: URLVersion) -> URL
}

public enum URLVersion: String {
    case none = ""
}

public struct ShoakURLProvider: URLProvider {
    private var baseURL: String {
        Secrets.baseURL
    }

    private var testURL: String {
        baseURL
    }

    public func provide(version: URLVersion) -> URL {
        #if TEST
        // TODO: 아직 scheme과 custom flag 설정 안해둠. configuration은 해둠.
        URL(string: testURL + version.rawValue)!
        #else
        URL(string: baseURL + version.rawValue)!
        #endif
    }
}

private struct Secrets {
    static var baseURL: String {
        guard let url = Bundle.main.url(forResource: "Secret", withExtension: "plist") else {
            return ""
        }

        guard let dictionary = try? NSDictionary(contentsOf: url, error: ()), let baseURL = dictionary["baseURL"] as? String else {
            return ""
        }

        return baseURL
    }
}
