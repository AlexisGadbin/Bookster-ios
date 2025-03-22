//
//  ShelfDetailView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 21/03/2025.
//

import SwiftUI
import DebouncedOnChange

struct ShelfDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(SessionManager.self) var session
    @Environment(\.dismiss) var dismiss

    @State private var showDeleteConfirmation = false

    @State private var shelf: Shelf
    @State private var filteredBooks: [Book] = []
    @State private var isSearchActive = false
    @State private var searchText = ""
    
    var onDelete: (() -> Void)? = nil

    init(shelf: Shelf, onDelete: (() -> Void)? = nil) {
        _shelf = State(initialValue: shelf)
        _filteredBooks = State(initialValue: shelf.books ?? [])
        self.onDelete = onDelete
    }

    var body: some View {
        NavigationStack {
            ZStack {
                colorScheme == .dark
                    ? Color.booksterBlack.ignoresSafeArea()
                    : Color.booksterWhite.ignoresSafeArea()

                
                ScrollView(.vertical) {
                    VStack(spacing: 12) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                            ForEach(filteredBooks) { book in
                                bookCell(book: book)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                        }
                    }
                }
            }
            .navigationTitle(Text(shelf.name))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            isSearchActive.toggle()
                        }
                    } label: {
                        Image(
                            systemName: "magnifyingglass"
                        )
                        .foregroundColor(.booksterGreen)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showDeleteConfirmation = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            .if(isSearchActive) { view in
                view.searchable(
                    text: $searchText, isPresented: $isSearchActive,
                    prompt: "Rechercher un livre")
                .onChange(of: searchText, debounceTime: .seconds(0.5)) { oldValue, newValue in
                    searchBooks()
                }
            }
            .alert("Supprimer cette étagère ?", isPresented: $showDeleteConfirmation) {
                Button("Supprimer", role: .destructive) {
                    Task {
                        await deleteShelf()
                    }
                }
                Button("Annuler", role: .cancel) {
                    showDeleteConfirmation = false
                }
            } message: {
                Text("Cette action est irréversible.")
            }
            .toolbar(.hidden, for: .tabBar)
        }
    }
    
    private func deleteShelf() async {
        //TODO: Loading
        do {
            try await ShelfService.shared.deleteShelf(id: shelf.id)
        } catch {
            print(error)
        }
        
        onDelete?()

        dismiss()
    }
    
    private func searchBooks() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if searchText.isEmpty {
                filteredBooks = shelf.books ?? []
            } else {
                filteredBooks = shelf.books?.filter { book in
                    book.title.lowercased().contains(searchText.lowercased())
                } ?? []
            }
        }
    }
    
    private func bookCell(book: Book) -> some View {
        NavigationLink {
            BookDetailView(book: book)
        } label: {
            ImageTitleCell(
                imageWidth: 100,
                imageHeight: 160,
                imageName: book.coverImageUrl
                ?? Constants.randomImage,
                title: book.title
            )
        }
    }
}

#Preview("Logged In") {
    let mockSession = SessionManager(
        token: "token",
        user: User(
            id: 1,
            firstName: "Alexis",
            lastName: "Gadbin",
            email: "alexis@gadbin.com",
            avatarUrl: nil,
            shelves: Shelf.mocks(
                count: 4
            )
        )
    )

    ShelfDetailView(shelf: Shelf.mock)
    .environment(mockSession)
}
