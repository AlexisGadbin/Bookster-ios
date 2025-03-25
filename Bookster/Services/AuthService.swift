//
//  AuthService.swift
//  Bookster
//
//  Created by Alexis Gadbin on 07/03/2025.
//

import Foundation

class AuthService {
    static let shared = AuthService()
    private init() {}

    func login(email: String, password: String) async throws -> AuthResponse {
        guard let url = URL(string: Constants.apiBaseURL + "/auth/login") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = LoginRequest(email: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let loginResponse = try JSONDecoder().decode(AuthResponse.self, from: data)

        return loginResponse
    }
    
    func register(
        email: String,
        password: String,
        passwordConfirmation: String,
        firstName: String,
        lastName: String
    ) async throws -> AuthResponse {
        guard let url = URL(string: Constants.apiBaseURL + "/auth/register") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = RegisterRequest(
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation,
            firstName: firstName,
            lastName: lastName
        )
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }

        let registerResponse = try JSONDecoder().decode(AuthResponse.self, from: data)

        return registerResponse
    }
        
    
    func getMe(token: String) async throws -> User {
        guard let url = URL(string: Constants.apiBaseURL + "/auth/me") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let user = try JSONDecoder().decode(User.self, from: data)

        return user
    }
    
    func logout(token: String) async throws {
        guard let url = URL(string: Constants.apiBaseURL + "/auth/logout") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }

}
