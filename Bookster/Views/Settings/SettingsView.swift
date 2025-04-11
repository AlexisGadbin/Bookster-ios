//
//  SettingsView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 10/03/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(SessionManager.self) var session
    
    @State private var showLogoutConfirmation = false
    
 
    
    var body: some View {
        guard let user = session.currentUser else {
            return AnyView(EmptyView())
        }
        
        return AnyView(
            NavigationStack {
                List {
                    Section {
                        HStack(spacing: 16) {
                            AvatarCell(user: user)
                            
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.firstName + " " + user.lastName)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Section(header: Text("Paramètres")) {
                        NavigationLink(destination: UpdateProfileView()) {
                            Label("Modifier le profil", systemImage: "person.crop.circle")
                        }
                        
                        NavigationLink(destination: Text("Préférences de notification")) {
                            Label("Notifications", systemImage: "bell.fill")
                        }
                        .disabled(true)
                        
                        NavigationLink(destination: Text("Confidentialité")) {
                            Label("Confidentialité", systemImage: "lock.fill")
                        }
                        .disabled(true)
                    }
                    
                    Section(header: Text("À propos")) {
                        NavigationLink(destination: Text("Conditions d'utilisation")) {
                            Label("Conditions d'utilisation", systemImage: "doc.plaintext")
                        }
                        .disabled(true)
                        
                        NavigationLink(destination: Text("Politique de confidentialité")) {
                            Label("Politique de confidentialité", systemImage: "shield.lefthalf.fill")
                        }
                        .disabled(true)
                        
                        VersionLink()
                    }
                    
                    Section {
                        Button(role: .destructive) {
                            showLogoutConfirmation = true
                        } label: {
                            Text("Se déconnecter")
                        }
                    }
                }
                .navigationTitle("Paramètres")
                .confirmationDialog("Es-tu sûr de vouloir te déconnecter ?", isPresented: $showLogoutConfirmation, titleVisibility: .visible) {
                    Button("Se déconnecter", role: .destructive) {
                        SessionManager.shared.logout()
                    }
                    Button("Annuler", role: .cancel) { }
                }
            }
        )
    }
}

#if DEBUG
#Preview {
    SettingsView()
        .environment(SessionManager(user: User.mock))
}
#endif
