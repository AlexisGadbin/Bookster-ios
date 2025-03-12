//
//  LoginForm.swift
//  Bookster
//
//  Created by Alexis Gadbin on 06/03/2025.
//

import SwiftUI

struct LoginForm: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?

    @Environment(SessionManager.self) var session

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                TextField("Email", text: $email)
                    .padding()
                    .background(
                        .booksterGray.opacity(0.4)
                    )
                    .cornerRadius(8)
                    .autocapitalization(.none)

                SecureField("Mot de Passe", text: $password)
                    .padding()
                    .background(
                        .booksterGray.opacity(0.4)
                    )
                    .cornerRadius(8)

                Text(errorMessage ?? " ")
                    .foregroundStyle(.red)
                    .font(.callout)

            }

            VStack(alignment: .leading, spacing: 8) {
                Button(action: {
                    Task {
                        await login()
                    }
                }) {
                    if session.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Se connecter")
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(session.isLoading)
                .padding()
                .background(
                    session.isLoading
                        ? Color.booksterGreen.opacity(0.75)
                        : Color.booksterGreen
                )
                .foregroundStyle(.booksterBlack)
                .cornerRadius(8)
                .animation(.easeInOut, value: session.isLoading)

                Text("Pas encore de compte ?")
                    .font(.callout)
                    .foregroundColor(.booksterLightGray)
                    + Text(" S'inscrire")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.booksterGreen)
            }
        }
    }

    private func login() async {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Veuillez renseigner tous les champs."
            return
        }

        errorMessage = nil

        await session.login(email: email, password: password)

        if !session.isLoggedIn {
            errorMessage = "Identifiants incorrects"
        }
    }
}

#Preview {
    LoginForm()
        .environment(SessionManager.shared)
}
