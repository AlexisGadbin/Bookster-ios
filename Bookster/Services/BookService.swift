//
//  BookService.swift
//  Bookster
//
//  Created by Alexis Gadbin on 12/03/2025.
//

import Foundation

final class BookService {

    static let shared = BookService()

    private init() {}

    func fetchBooks() async throws -> PaginatedResponse<Book> {
        
        return try await NetworkManager.shared.request(endpoint: "/books?limit=100")
    }
    
    func searchBooks(search: String) async throws -> PaginatedResponse<Book> {
        
        return try await NetworkManager.shared.request(endpoint: "/books?search=\(search)&limit=100")
    }
    
    func deleteBook(id: Int) async throws {
        try await NetworkManager.shared.requestVoid(endpoint: "/books/\(id)", method: "DELETE")
    }

}
