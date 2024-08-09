//
//  LoggerPlugin.swift
//  Shoak
//
//  Created by 정종인 on 7/29/24.
//

import Moya
import Foundation

struct LoggerPlugin: PluginType {
    func willSend(_ request: any RequestType, target: any TargetType) {
        let requestURL = request.request?.url?.absoluteString ?? "!URL ERROR!"
        print("\n🐈🐈🐈🐈 Moya Logger 🐈🐈🐈🐈")
        print("🐈🐈🐈🐈 Sending Request : \(requestURL)")
        var log = "🐈🐈🐈🐈 Sending Headers : \n"
        request.request?.headers.forEach { header in
            log.append("\(header.name): \(header.value)\n")
        }
        log.append("🐈🐈🐈🐈 Sending Data : \n")
        if let reqString = String(bytes: (request.request?.httpBody) ?? Data(), encoding: String.Encoding.utf8) {
            log.append("\(reqString)\n")
        }
        log.append("🐈🐈🐈🐈 END 🐈🐈🐈🐈")
        print(log)

    }

    func didReceive(_ result: Result<Response, MoyaError>, target: any TargetType) {
        print("\n🐈🐈🐈🐈 Moya Logger 🐈🐈🐈🐈")
        switch result {
        case .success(let response):
            print("🐈🐈🐈🐈 Receiving Response : ")
            var log = "🐈🐈🐈🐈 Received Headers\n"
            response.response?.allHeaderFields.forEach {
                log.append("\($0): \($1)\n")
            }
            log.append("🐈🐈🐈🐈 Receiving Data : \n")
            if let reString = String(bytes: response.data, encoding: String.Encoding.utf8) {
                log.append("\(reString)\n")
            }
            log.append("🐈🐈🐈🐈 END 🐈🐈🐈🐈")
            print(log)
            let statusCode = response.statusCode
            print("🐈🐈🐈🐈 Received success. code=\(statusCode)")
        case .failure(let failure):
            print("❌❌❌❌ Receive failed. \(failure.localizedDescription)")
            let response = failure.response
            print("❌❌❌❌ Receiving Response : ")
            var log = "❌❌❌❌ Received Headers\n"
            response?.response?.allHeaderFields.forEach {
                log.append("\($0): \($1)\n")
            }
            log.append("❌❌❌❌ Receiving Data : \n")
            if let reString = String(bytes: response?.data ?? Data(), encoding: String.Encoding.utf8) {
                log.append("\(reString)\n")
            }
            log.append("❌❌❌❌ END ❌❌❌❌")
            print(log)
        }
    }
}
