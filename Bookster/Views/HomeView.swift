//
//  HomeView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 06/03/2025.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(SessionManager.self) var session
    
    var body: some View {
        ZStack {
            colorScheme == .dark ? Color.booksterBlack.ignoresSafeArea() : Color.booksterWhite.ignoresSafeArea()
            
            Text(session.currentUser?.firstName ?? "Marche pas")
        }
    }
}

#Preview("Logged In") {
    let sessionManagar = SessionManager(token: "mockToken", user: User(id: 1, firstName: "Alexis", lastName: "Gadbin", email: "alexis@gadbin.com", avatarUrl: nil))
    
    HomeView()
        .environment(sessionManagar)
}

#Preview("Logged Out") {
    HomeView()
        .environment(SessionManager.shared)
}
    
