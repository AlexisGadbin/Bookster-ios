//
//  User.swift
//  Bookster
//
//  Created by Alexis Gadbin on 06/03/2025.
//

import Foundation

struct User: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let avatarUrl: String?
    
    static var mock: User {
        User(id: 1, firstName: "Alexis", lastName: "Gadbin", email: "alexis@gadbin.com", avatarUrl: nil)
    }
}
