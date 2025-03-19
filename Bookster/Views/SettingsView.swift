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
            NavigationView {
                List {
                    Section {
                        HStack(spacing: 16) {
                            if let avatarUrl = user.avatarUrl {
                                ImageLoaderView(urlString: avatarUrl)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.firstName + " " + user.lastName)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
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
                        
                        NavigationLink(destination: Text("Politique de confidentialité")) {
                            Label("Politique de confidentialité", systemImage: "shield.lefthalf.fill")
                        }
                        
                        NavigationLink(destination: Text("Version 1.0.0")) {
                            Label("Version", systemImage: "info.circle")
                        }
                    }
                    .disabled(true)
                    
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

#Preview {
    SettingsView()
        .environment(SessionManager(user: User.mock))
}
