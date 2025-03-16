//
//  Shelf.swift
//  Bookster
//
//  Created by Alexis Gadbin on 14/03/2025.
//

import Foundation

struct Shelf: Identifiable, Codable {
    let id: Int
    let name: String
    let userId: Int
    let books: [Book]?
    let user: User?
    
    static var mock: Shelf {
        Shelf(id: 1, name: "Favourites", userId: 1, books: nil, user: nil)
    }
    
    static func mocks(count: Int) -> [Shelf] {
        return (0..<count).map { index in
            Shelf(id: index, name: "Shelf \(index)", userId: 1, books: nil, user: nil)
        }
    }
}
