//
//  LoggerPlugin.swift
//  Shoak
//
//  Created by 정종인 on 7/29/24.
//

import Moya

struct LoggerPlugin: PluginType {
    func willSend(_ request: any RequestType, target: any TargetType) {
        let requestURL = request.request?.url?.absoluteString ?? "!URL ERROR!"
        print("\n🐈🐈🐈🐈 Moya Logger 🐈🐈🐈🐈")
        print("🐈🐈🐈🐈 Sending Request : \(requestURL)")

    }

    func didReceive(_ result: Result<Response, MoyaError>, target: any TargetType) {
        print("\n🐈🐈🐈🐈 Moya Logger 🐈🐈🐈🐈")
        switch result {
        case .success(let response):
            let statusCode = response.statusCode
            print("🐈🐈🐈🐈 Received success. code=\(statusCode)")
        case .failure(let failure):
            print("🐈🐈🐈🐈 Receive failed. \(failure.localizedDescription)")
        }
    }
}
