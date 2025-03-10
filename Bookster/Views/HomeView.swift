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

#Preview {
    HomeView()
}
