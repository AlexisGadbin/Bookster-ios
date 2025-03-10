//
//  AuthResponse.swift
//  Bookster
//
//  Created by Alexis Gadbin on 06/03/2025.
//

import Foundation

struct AuthResponse: Codable {
    let user: User
    let token: TokenDetails
}

struct TokenDetails: Codable {
    let type: String
    let name: String?
    let token: String
    let abilities: [String]
    let lastUsedAt: String?
    let expiresAt: String?
}
