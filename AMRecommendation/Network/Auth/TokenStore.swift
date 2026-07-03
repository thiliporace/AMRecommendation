//
//  TokenStore.swift
//  AMRecommendation
//
//  Created by Thiago Liporace on 01/07/26.
//

import Foundation
import Security

// Protocol that will allow us to create the mocked class KeychainTokenStoreMock
protocol TokenStoreProtocol {
    func loadRefreshToken() -> String?
    func save(refreshToken: String) throws
    func clear() throws
}

// Responsible for reading and writing to the device's Keychain, which is an encrypted, secure database managed by the operating system
final class KeychainTokenStore: TokenStoreProtocol {
    private let service: String
    private let account: String
    
    init(service: String, account: String) {
        self.service = service
        self.account = account
    }
    
    // Computed property that creates a reusable dictionary
    // kSecClass: A dictionary key whose value is the item’s class.
    // kSecClassGenericPassword: The value that indicates a generic password item
    // kSecAttrService: A key whose value is a string indicating the item’s service.
    // kSecAttrAccount: A key whose value is a string indicating the item’s account name
    private var baseQuery: [String: Any] {
        [kSecClass as String: kSecClassGenericPassword,
         kSecAttrService as String: service,
         kSecAttrAccount as String: account]
    }
    
    // Uses baseQuery, adds the flags asking for data (kSecReturnData) and limiting the result to one (kSecMatchLimitOne)
    // and asks the OS to find it via SecItemCopyMatching.
    // If found, it converts the raw data back into a readable UTF-8 Swift String.
    func loadRefreshToken() -> String? {
        var query = baseQuery
        
        // kSecReturnData: A key whose value is a Boolean that indicates whether or not to return item data.
        query[kSecReturnData as String] = true
        
        // kSecMatchLimit: A key whose value indicates the match limit.
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var item: CFTypeRef?
        
        // Returns one or more keychain items that match a search query, or copies attributes of specific keychain items.
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        // Status needs to be errSecSuccess and it can be read as binary Data
        guard status == errSecSuccess, let data = item as? Data else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
    
    // Before saving, delete any existing token with the same identifier using SecItemDelete.
    // It then packages the new token into a dictionary and saves it via SecItemAdd.
    func save(refreshToken: String) throws {
        SecItemDelete(baseQuery as CFDictionary)
        
        var attributes = baseQuery
        attributes[kSecValueData as String] = Data(refreshToken.utf8)
        
        let status = SecItemAdd(attributes as CFDictionary, nil)
        guard status == errSecSuccess else { throw AppErrorEnum.accessTokenMissing }
    }
    
    // Finds the token and permanently deletes it from the device.
    func clear() throws {
        let status = SecItemDelete(baseQuery as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw AppErrorEnum.accessTokenMissing
        }
    }
}
