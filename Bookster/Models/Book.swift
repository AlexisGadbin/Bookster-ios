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

    let author: Author
    let contributor: User

    let coverImageUrl: String?
    let backCoverImageUrl: String?

    let isWishlisted: Bool
    let note: Double?
    let isRead: Bool
    let isNextRead: Bool
    let isInLibrary: Bool

    static var mock: Book {
        Book(
            id: 1, title: "Harry Potter and the Philosopher's Stone",
            description: "The first book in the Harry Potter series",
            author: Author.mock, contributor: User.mock,
            coverImageUrl: Constants.randomImage,
            backCoverImageUrl: Constants.randomImage, isWishlisted: false,
            note: nil, isRead: false, isNextRead: false, isInLibrary: false)
    }

    static func mocks(count: Int) -> [Book] {
        return (0..<count).map { index in
            Book(
                id: index,
                title: "Book \(index)",
                description: "Description \(index)",
                author: Author.mock,
                contributor: User.mock,
                coverImageUrl: Constants.randomImage,
                backCoverImageUrl: Constants.randomImage,
                isWishlisted: false,
                note: 10,
                isRead: false,
                isNextRead: false,
                isInLibrary: false
            )
        }
    }
}
