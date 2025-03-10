//
//  AuthResponse.swift
//  Bookster
//
//  Created by Alexis Gadbin on 06/03/2025.
//

import Foundation

struct AuthRequest: Codable {
    let email: String
    let password: String
}
