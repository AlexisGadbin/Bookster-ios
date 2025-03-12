//
//  SplashScreenView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 11/03/2025.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.5
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            colorScheme == .dark
                ? Color.booksterBlack.ignoresSafeArea()
                : Color.booksterWhite.ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "book.fill") // Remplace par ton logo 📚
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.booksterGreen)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                            logoScale = 1.0
                            logoOpacity = 1.0
                        }
                    }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
