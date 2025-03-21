//
//  UserService.swift
//  Bookster
//
//  Created by Alexis Gadbin on 17/03/2025.
//

import Foundation
import UIKit

struct UserService {
    static let shared = UserService()
    
    private init() {}
    
    func updateProfilePicture(image: UIImage) async throws -> User {
        let images: [String: UIImage] = ["profilePicture": image]
        
        let response: User = try await NetworkManager.shared
            .uploadMultipart(
                endpoint: "/me/profile-picture",
                parameters: [:],
                images: images,
                httpMethod: "PUT"
            )
        
        await SessionManager.shared.fetchCurrentUser()
        
        return response
    }
    
    func getMyShelves() async throws -> [Shelf] {
        let response: [Shelf] = try await NetworkManager.shared.request(endpoint: "/me/shelves");
        
        return response
    }
    
    func getMyBooks(search: String) async throws -> PaginatedResponse<Book> {
        let response: PaginatedResponse<Book> = try await NetworkManager.shared.request(endpoint: "/me/books?search=\(search)&limit=100");
        
        return response
    }
}
