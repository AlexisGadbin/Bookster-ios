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
    let emoji: String
    let color: String
    let userId: Int
    let books: [Book]?
    let user: User?

    static var mock: Shelf {
        Shelf(id: 1, name: "Favourites", emoji: "❤️", color: "#FF0000", userId: 1, books: Book.mocks(count: 8), user: nil)
    }
    
    static func mocks(count: Int) -> [Shelf] {
        return (0..<count).map { index in
            Shelf(id: index, name: "Shelf \(index)", emoji: "📚", color: "#000000", userId: 1, books: nil, user: nil)
        }
    }
}
