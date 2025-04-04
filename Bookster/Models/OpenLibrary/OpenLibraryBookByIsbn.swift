//
//  OpenLibraryBookByIsbn.swift
//  Bookster
//
//  Created by Alexis Gadbin on 02/04/2025.
//

import Foundation

struct OpenLibraryBookByIsbn: Codable {
    let title: String
    let authors: [AuthorKey]?
    let covers: [Int]?
}

struct AuthorKey: Codable {
    let key: String?
}
