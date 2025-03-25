//
//  SessionManager.swift
//  Bookster
//
//  Created by Alexis Gadbin on 10/03/2025.
//

import Foundation

@Observable
final class SessionManager {

    static let shared = SessionManager()

    var token: String?
    var currentUser: User?
    
    var isLoading: Bool = false

    private init() {
        self.token = KeychainService.shared.getToken()

        if token != nil {
            Task {
                await fetchCurrentUser()
            }
        }
    }

    #if DEBUG
        init(token: String? = nil, user: User? = nil) {
            self.token = token
            self.currentUser = user
        }
    #endif

    var isLoggedIn: Bool {
        return token != nil
    }

    @MainActor
    func login(email: String, password: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let authResponse = try await AuthService.shared.login(
                email: email, password: password)
            let token = authResponse.token.token

            self.token = token
            let isSaved = KeychainService.shared.save(token: token)

            if isSaved {
                await fetchCurrentUser()
            } else {
                print("Erreur lors de la sauvegarde du token dans le keychain")
            }
        } catch {
            print("❌ Login failed: \(error)")
            logout()
        }
    }
    
    @MainActor
    func register(
        email: String,
        password: String,
        passwordConfirmation: String,
        firstName: String,
        lastName: String
    ) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let authResponse = try await AuthService.shared.register(
                email: email,
                password: password,
                passwordConfirmation: passwordConfirmation,
                firstName: firstName,
                lastName: lastName
            )
            let token = authResponse.token.token

            self.token = token
            let isSaved = KeychainService.shared.save(token: token)

            if isSaved {
                await fetchCurrentUser()
            } else {
                print("Erreur lors de la sauvegarde du token dans le keychain")
            }
        } catch {
            print("❌ Register failed: \(error)")
            logout()
        }
    }

    func logout() {
        guard let token else { return }
        isLoading = true
        defer { isLoading = false }

        Task {
            do {
                try await AuthService.shared.logout(token: token)
            } catch {
                print("⚠️ Erreur lors de la déconnexion : \(error)")
            }
        }

        self.token = nil
        self.currentUser = nil
        KeychainService.shared.delete()
    }

    @MainActor
    func fetchCurrentUser() async {
        guard let token else { return }

        do {
            let user = try await AuthService.shared.getMe(token: token)
            self.currentUser = user
        } catch {
            print(
                "⚠️ Erreur lors de la récupération de l'utilisateur : \(error)")
        }
    }
}

#if DEBUG
extension SessionManager {
    static let preview = SessionManager(user: User.mock)
}
#endif
