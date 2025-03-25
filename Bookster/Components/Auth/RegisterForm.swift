//
//  RegisterForm.swift
//  Bookster
//
//  Created by Alexis Gadbin on 25/03/2025.
//

import SwiftUI

struct RegisterForm: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordConfirmation: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var errorMessage: String?
    var onLinkClick: () -> Void
    
    @Environment(SessionManager.self) var session
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                
                HStack {
                    TextField("Prénom", text: $firstName)
                        .padding()
                        .background(
                            .booksterGray.opacity(0.4)
                        )
                        .cornerRadius(8)
                    
                    TextField("Nom", text: $lastName)
                        .padding()
                        .background(
                            .booksterGray.opacity(0.4)
                        )
                        .cornerRadius(8)
                }
                
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
                
                SecureField("Confirmer le mot de passe", text: $passwordConfirmation)
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
                        await register()
                    }
                }) {
                    if session.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("S'inscrire")
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
                
                HStack(spacing: 4) {
                    Text("Déjà inscrit ?")
                        .font(.callout)
                        .foregroundColor(.booksterLightGray)
                    
                    Text("Se connecter")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.booksterGreen)
                        .onTapGesture {
                            onLinkClick()
                        }
                }
            }
        }
    }
    
    private func register() async {
        if email.isEmpty || password.isEmpty || passwordConfirmation.isEmpty || firstName.isEmpty || lastName.isEmpty {
            errorMessage = "Veuillez renseigner tous les champs."
            return
        }
        
        errorMessage = nil
        
        await session.register(
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation,
            firstName: firstName,
            lastName: lastName
        )
        
        if !session.isLoggedIn {
            errorMessage = "Identifiants incorrects"
        }
    }
}

#Preview {
    RegisterForm(onLinkClick: {
        print("Link clicked")
    })
        .environment(SessionManager.shared)
}
