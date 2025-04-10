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
    
    func deleteBook(id: Int) async throws {
        try await NetworkManager.shared.requestVoid(endpoint: "/books/\(id)", method: "DELETE")
    }
    
    func searchBooksFromShelf(search: String, shelfId: Int) async throws -> PaginatedResponse<Book> {
        
        let response: PaginatedResponse<Book> = try await NetworkManager.shared.request(
            endpoint: "/shelves/\(shelfId)/books?search=\(search)&limit=100"
        )
        
        return response
    }
    
}
