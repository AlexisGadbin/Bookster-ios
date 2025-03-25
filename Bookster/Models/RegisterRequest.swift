//
//  RegisterRequest.swift
//  Bookster
//
//  Created by Alexis Gadbin on 25/03/2025.
//

import Foundation

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let passwordConfirmation: String
    let firstName: String
    let lastName: String
}
