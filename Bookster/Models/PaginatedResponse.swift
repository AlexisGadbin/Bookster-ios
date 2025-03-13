//
//  PaginatedResponse.swift
//  Bookster
//
//  Created by Alexis Gadbin on 12/03/2025.
//

import Foundation

struct PaginatedResponse<T: Codable>: Codable {
    let meta: PageMeta
    let data: [T]
}
