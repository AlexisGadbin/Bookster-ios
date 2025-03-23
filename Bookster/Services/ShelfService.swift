//
//  ShelfService.swift
//  Bookster
//
//  Created by Alexis Gadbin on 22/03/2025.
//

import Foundation

final class ShelfService {
    
    static let shared = ShelfService()
    
    private init() {}
    
    func createShelf(editShelfRequest: EditShelfRequest) async throws -> Shelf {
        
        let shelf: Shelf = try await NetworkManager.shared.request(
            endpoint: "/shelves",
            method: "POST",
            body: editShelfRequest
        )
        
        return shelf
    }
    
    func updateShelf(id: Int, editShelfRequest: EditShelfRequest) async throws -> Shelf {
        
        let shelf: Shelf = try await NetworkManager.shared.request(
            endpoint: "/shelves/\(id)",
            method: "PUT",
            body: editShelfRequest
        )
        
        return shelf
    }
    
    func deleteShelf(id: Int) async throws {
        try await NetworkManager.shared.requestVoid(
            endpoint: "/shelves/\(id)",
            method: "DELETE"
        )
    }

}
