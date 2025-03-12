//
//  ContentView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 05/03/2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(SessionManager.self) var session
    
    var body: some View {
        
        if !session.isLoggedIn {
            AuthView()
        } else {
            TabView {
                Tab("Accueil", systemImage: "book.closed") {
                    HomeView()
                }
    //            .badge(2)
                
                Tab("Réglages", systemImage: "gearshape") {
                    SettingsView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(SessionManager.shared)
}
