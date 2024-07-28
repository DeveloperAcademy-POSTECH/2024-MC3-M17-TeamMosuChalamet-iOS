//
//  KeyChain.swift
//  Shoak
//
//  Created by 정종인 on 7/28/24.
//

import Foundation

public struct Keychain<Item: Codable> {
    private let service: String
    private let account: String
    private let accessGroup: String?

    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()

    public init(service: String, account: String, accessGroup: String? = nil) {
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }

    public func searchItem() throws -> Item {
        let query = readQuery()
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status != errSecItemNotFound else { throw KeychainError.notFound }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }

        guard let existingItem = item as? [String: Any],
              let itemData = existingItem[kSecValueData as String] as? Data,
              let item = try? jsonDecoder.decode(Item.self, from: itemData)
        else {
            throw KeychainError.unexpectedData
        }

        return item
    }

    public func saveItem(_ value: Item) throws {
        do {
            // 이미 해당 Item이 있다면 갱신.
            try checkItemExists()
            try updateItem(value)
        } catch KeychainError.notFound {
            // 해당 Item이 없다면 새로 추가해주기
            try addItem(value)
        }
    }

    public func deleteItem() throws {
        let query = searchQuery()

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    private func checkItemExists() throws {
        let query = searchQuery()
        let status = SecItemCopyMatching(query as CFDictionary, nil)

        guard status != errSecItemNotFound else { throw KeychainError.notFound }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }

    private func updateItem(_ value: Item) throws {
        let query = searchQuery()
        guard let itemData = try? jsonEncoder.encode(value) else {
            throw KeychainError.codingError
        }
        let attributes: [String: Any] = [
            kSecValueData as String: itemData
        ]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

        guard status != errSecItemNotFound else { throw KeychainError.notFound }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }

    private func addItem(_ value: Item) throws {
        guard let itemData = try? jsonEncoder.encode(value) else {
            throw KeychainError.codingError
        }
        
        let query = addQuery(itemData)

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
}

extension Keychain {
    private func searchQuery() -> [String: Any] {
        var query = [String: Any]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service
        query[kSecAttrAccount as String] = account

        if let accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }

        return query
    }

    private func readQuery() -> [String: Any] {
        var query = searchQuery()

        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue

        return query
    }

    private func addQuery(_ value: Data) -> [String: Any] {
        var query = searchQuery()

        query[kSecValueData as String] = value

        return query
    }
}

public enum KeychainError: Error {
    case notFound
    case unknown
    case unexpectedData
    case unhandledError(status: OSStatus)
    case codingError
}
