//
//  NetworkManager.swift
//  Bookster
//
//  Created by Alexis Gadbin on 12/03/2025.
//

import Foundation

@Observable
final class NetworkManager {

    static let shared = NetworkManager()

    private init() {}

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
}
