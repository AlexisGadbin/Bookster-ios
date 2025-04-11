//
//  UpdateProfileRequest.swift
//  Bookster
//
//  Created by Alexis Gadbin on 11/04/2025.
//

import Foundation

struct UpdateProfileRequest: Codable {
    let firstName: String
    let lastName: String
    let email: String
}
