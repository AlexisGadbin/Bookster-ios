//
//  NetworkManager.swift
//  Bookster
//
//  Created by Alexis Gadbin on 12/03/2025.
//

import Foundation
import UIKit

@Observable
final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    @MainActor
    func requestVoid(
        endpoint: String,
        method: String = "GET",
        body: Encodable? = nil,
        requiresAuth: Bool = true
    ) async throws {
        guard let url = URL(string: Constants.apiBaseURL + endpoint) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if requiresAuth {
            guard let token = SessionManager.shared.token else {
                throw URLError(.userAuthenticationRequired)
            }

            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        switch httpResponse.statusCode {
        case 200..<300:
            print("✅ Réponse OK (vide)")
        case 401:
            SessionManager.shared.logout()
            throw URLError(.userAuthenticationRequired)
        default:
            throw URLError(.badServerResponse)
        }
    }
    
    // MARK: - Generic Request Function
    @MainActor
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Encodable? = nil,
        requiresAuth: Bool = true
    ) async throws -> T {
        
        guard let url = URL(string: Constants.apiBaseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        if requiresAuth {
            guard let token = SessionManager.shared.token else {
                throw URLError(.userAuthenticationRequired)
            }
            
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            print("Réponse OK")
            break
        case 401:
            SessionManager.shared.logout()
            throw URLError(.userAuthenticationRequired)
        default:
            print(response.description)
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(T.self, from: data)
        return decoded
    }
    
    
    @MainActor
    func uploadMultipart<T: Decodable>(
        endpoint: String,
        parameters: [String: Any],
        images: [String: UIImage?],
        requiresAuth: Bool = true,
        httpMethod: String = "POST"
    ) async throws -> T {

        guard let url = URL(string: Constants.apiBaseURL + endpoint) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod

        let boundary = "Boundary-\(UUID().uuidString)"

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        if requiresAuth {
            guard let token = SessionManager.shared.token else {
                throw URLError(.userAuthenticationRequired)
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let body = createMultipartBody(parameters: parameters, images: images, boundary: boundary)
        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("Status code : \(httpResponse.statusCode)")

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }

    private func createMultipartBody(
        parameters: [String: Any],
        images: [String: UIImage?],
        boundary: String
    ) -> Data {

        var body = Data()
        let lineBreak = "\r\n"

        // Paramètres texte
        for (key, value) in parameters {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append("\(value)\(lineBreak)")
        }

        // Images
        for (key, image) in images {
            guard let image = image,
                  let imageData = image.jpegData(compressionQuality: 0.8) else { continue }

            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(UUID().uuidString).jpg\"\(lineBreak)")
            body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)")
            body.append(imageData)
            body.append(lineBreak)
        }

        body.append("--\(boundary)--\(lineBreak)")

        return body
    }
}

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
