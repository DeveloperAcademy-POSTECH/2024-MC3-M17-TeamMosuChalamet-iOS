//
//  TokenStorage.swift
//  Shoak
//
//  Created by 정종인 on 7/28/24.
//

import Foundation

/// Keychain을 활용하는 토큰 스토리지.
/// 세팅하면 자동으로 keychain에 저장함.
@propertyWrapper
struct TokenStorage<Item: Token>: Sendable {
    private let service: String
    private let key: String
    private let keychain: Keychain<Item>

    init() {
        service = Bundle.main.bundleIdentifier ?? "NoIdentifier"
        key = String(describing: Item.self)
        keychain = Keychain<Item>(service: service, account: key)
    }

    var wrappedValue: Item? {
        get {
            do {
                let item = try keychain.searchItem()
                print("Get \(key) from keychain")
                return item
            } catch {
                print("Unable to read \(key) from keychain")
                return nil
            }
        }

        set {
            guard let newValue else {
                deleteToken()
                return
            }

            do {
                try keychain.saveItem(newValue)
                print("Set \(key) to keychain")
            } catch {
                print("Unable to save \(key) from keychain")
            }
        }
    }

    private func deleteToken() {
        do {
            try keychain.deleteItem()
        } catch {
            print("Unable to delete \(key) from keychain")
        }
    }
}
