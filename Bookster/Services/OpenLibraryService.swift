//
//  OpenLibraryService.swift
//  Bookster
//
//  Created by Alexis Gadbin on 02/04/2025.
//

import Foundation

final class OpenLibraryService {
    
    static let shared = OpenLibraryService()
    
    private init() {}
    
    func getBookByIsbn(isbn: String) async throws -> OpenLibraryBookByIsbn {
        let response: OpenLibraryBookByIsbn = try await NetworkManager.shared.request(
            endpoint: "/isbn/\(isbn).json",
            requiresAuth: false,
            baseURL: Constants.openLibraryApiBaseURL
        )
        
        return response
    }
    
    func getAuthorByKey(key: String) async throws -> OpenLibraryAuthor {
        let response: OpenLibraryAuthor = try await NetworkManager.shared.request(
            endpoint: "\(key).json",
            requiresAuth: false,
            baseURL: Constants.openLibraryApiBaseURL
        )
        
        return response
    }
    
}

