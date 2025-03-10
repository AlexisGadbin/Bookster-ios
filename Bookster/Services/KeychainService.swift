//
//  KeychainService.swift
//  Bookster
//
//  Created by Alexis Gadbin on 09/03/2025.
//

import Foundation

final class KeychainService {
    
    static let shared = KeychainService()
    private init() {}

    // MARK: - Save Token
    func save(token: String, for key: String = "userToken") -> Bool {
        guard let data = token.data(using: .utf8) else { return false }

        // Supprime si déjà présent
        delete(for: key)

        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    // MARK: - Get Token
    func getToken(for key: String = "userToken") -> String? {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : true,
            kSecMatchLimit as String  : kSecMatchLimitOne
        ]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess,
              let data = item as? Data,
              let token = String(data: data, encoding: .utf8) else {
            return nil
        }

        return token
    }

    // MARK: - Delete Token
    func delete(for key: String = "userToken") {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key
        ]

        SecItemDelete(query as CFDictionary)
    }
}
