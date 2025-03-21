//
//  ContentView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 05/03/2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(SessionManager.self) var session
    @AppStorage("activeTab") var activeTab = 0
    
    var body: some View {
        
        if !session.isLoggedIn {
            AuthView()
        } else {
            TabView(selection: $activeTab) {
                HomeView()
                    .tabItem {
                        Label("Accueil", systemImage: "book.closed")
                    }
                    .tag(0)
                
                MyLibraryView()
                    .tabItem {
                        Label("Ma bibliothèque", systemImage: "books.vertical.fill")
                    }
                    .tag(1)
                
                SettingsView()
                    .tabItem {
                        Label("Réglages", systemImage: "gearshape")
                    }
                    .tag(2)
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(SessionManager.shared)
}
