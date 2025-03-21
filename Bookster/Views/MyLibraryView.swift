//
//  MyLibraryView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 19/03/2025.
//

import SwiftUI

struct MyLibraryView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(SessionManager.self) var session
    
    @State private var shelves: [Shelf]
    
    init( shelves: [Shelf] = []) {
        self.shelves = shelves
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                colorScheme == .dark
                ? Color.booksterBlack.ignoresSafeArea()
                : Color.white.ignoresSafeArea()
                
                ScrollView(.vertical) {
                    VStack(spacing: 12) {
                        ForEach(shelves) { shelf in
                            NavigationLink {
                                ShelfDetailView(shelf: shelf)
                            } label: {
                                ShelfCell(shelf: shelf)
                            }
                        }
                    }
                }
                
            }
            .navigationTitle("Ma bibliothèque")
            .toolbarTitleDisplayMode(.inlineLarge)
        }
        .task {
            await fetchUserShelves()
        }
    }
    
    private func fetchUserShelves() async {
        do {
            let fetchedShelves = try await UserService.shared.getMyShelves()
            
            shelves = fetchedShelves
        } catch {
            print("❌ Erreur UserService : \(error.localizedDescription)")
        }
    }
}

#Preview {
    MyLibraryView(shelves: Shelf.mocks(count: 5))
        .environment(SessionManager.shared)
}
