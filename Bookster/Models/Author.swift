//
//  Author.swift
//  Bookster
//
//  Created by Alexis Gadbin on 12/03/2025.
//

import Foundation

struct Author: Codable {
    let id: Int
    
    let name: String
    
    static var mock: Author {
        Author(id: 1, name: "J.K. Rowling")
    }
}
