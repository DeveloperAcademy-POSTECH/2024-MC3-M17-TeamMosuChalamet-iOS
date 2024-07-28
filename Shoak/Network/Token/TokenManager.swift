//
//  TokenManager.swift
//  Shoak
//
//  Created by 정종인 on 7/28/24.
//

import Foundation

@propertyWrapper
struct TokenStorage<Item: Token> {
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
                if item.isExpired() {
                    deleteToken()
                    return nil
                }
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
