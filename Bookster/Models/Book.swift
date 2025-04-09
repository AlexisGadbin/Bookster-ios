//
//  Book.swift
//  Bookster
//
//  Created by Alexis Gadbin on 12/03/2025.
//

import Foundation

struct Book: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String?
    let authorId: Int
    let contributorId: Int
    
    let author: Author?
    let contributor: User?
    
    let coverImageUrl: String?
    let backCoverImageUrl: String?
    
    let note: Double?
    
    let shelves: [Shelf]?
    
    static var mock: Book {
        Book(
            id: 1,
            title: "Harry Potter and the Philosopher's Stone",
            description: "The first book in the Harry Potter series",
            authorId: 1,
            contributorId: 1,
            author: Author.mock,
            contributor: User.mock,
            coverImageUrl: Constants.randomImage,
            backCoverImageUrl: Constants.randomImage,
            note: 8.5,
            shelves: Shelf.mocks(count: 4)
        )
    }
    
    static func mocks(count: Int) -> [Book] {
        return (0..<count).map { index in
            Book(
                id: index,
                title: "Book \(index)",
                description: "Description \(index)",
                authorId: 1,
                contributorId: 1,
                author: Author.mock,
                contributor: User.mock,
                coverImageUrl: Constants.randomImage,
                backCoverImageUrl: Constants.randomImage,
                note: 10,
                shelves: Shelf.mocks(count: 4)
            )
        }
    }
}
