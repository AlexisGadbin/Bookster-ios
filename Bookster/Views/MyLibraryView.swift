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

    @State private var isCreatingShelf = false

    init(shelves: [Shelf] = []) {
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
                                ShelfDetailView(
                                    shelf: shelf
                                ) {
                                    Task {
                                        await fetchUserShelves()
                                    }
                                } fetchShelves: {
                                    Task {
                                        await fetchUserShelves()
                                    }
                                }

                            } label: {
                                ShelfCell(shelf: shelf)
                            }
                        }

                        Button("Ajouter une étagère", systemImage: "plus") {
                            isCreatingShelf.toggle()
                        }
                        .padding(.vertical, 16)
                    }
                }

            }
            .navigationTitle("Ma bibliothèque")
            .toolbarTitleDisplayMode(.inlineLarge)
            .sheet(isPresented: $isCreatingShelf) {
                EditShelfView {
                    isCreatingShelf.toggle()
                    Task {
                        await fetchUserShelves()
                    }
                }
                .presentationDetents([.height(200)])
                .presentationDragIndicator(.visible)
            }
        }
        .task {
            await fetchUserShelves()
        }
    }

    private func fetchUserShelves() async {
        do {
            let fetchedShelves = try await UserService.shared.getMyShelves()

            shelves = fetchedShelves
            print("done")
        } catch {
            print("❌ Erreur UserService : \(error.localizedDescription)")
        }
    }
}

#Preview {
    MyLibraryView(shelves: Shelf.mocks(count: 5))
        .environment(SessionManager.shared)
}
