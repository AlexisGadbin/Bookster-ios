//
//  AuthView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 06/03/2025.
//

import SwiftUI

struct AuthView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isRegistering = false

    var body: some View {
        ZStack {
            colorScheme == .dark
                ? Color.booksterBlack.ignoresSafeArea()
                : Color.booksterWhite.ignoresSafeArea()

            VStack {
                Text("Bienvenue sur")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    
                Text("Bookster")
                    .font(.title)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.booksterGreen)
                
                if !isRegistering {
                    LoginForm {
                        isRegistering = true
                    }
                } else {
                    RegisterForm {
                        isRegistering = false
                    }
                }
            }
            .padding(.horizontal, 32)
        }
    }
}

#if DEBUG
#Preview {
    AuthView()
        .environment(SessionManager.preview)
}
#endif
