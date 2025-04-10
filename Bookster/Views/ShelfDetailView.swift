//
//  ShelfDetailView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 21/03/2025.
//

import DebouncedOnChange
import EmojiPicker
import SwiftUI

struct ShelfDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(SessionManager.self) var session
    @Environment(\.dismiss) var dismiss

    @State private var showDeleteConfirmation = false

    @State private var books: [Book] = []
    @State private var isSearchActive = false
    @State private var searchText = ""
    @State private var isEditing = false

    var shelf: Shelf
    var onDelete: () -> Void
    var fetchShelves: () -> Void

    init(
        shelf: Shelf, onDelete: @escaping () -> Void,
        fetchShelves: @escaping () -> Void,
        books: [Book] = []
    ) {
        self.shelf = shelf
        _books = State(initialValue: books)
        self.onDelete = onDelete
        self.fetchShelves = fetchShelves
    }

    var body: some View {
        NavigationStack {
            ZStack {
                colorScheme == .dark
                    ? Color.booksterBlack.ignoresSafeArea()
                    : Color.booksterWhite.ignoresSafeArea()

                ScrollView(.vertical) {
                    VStack(spacing: 12) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))])
                        {
                            ForEach(books) { book in
                                bookCell(book: book)
                                    .transition(
                                        .move(edge: .bottom).combined(
                                            with: .opacity))
                            }
                        }
                    }
                }
            }
            .navigationTitle(
                Text(shelf.emoji + " " + shelf.name)
            )
            .toolbarTitleDisplayMode(.inlineLarge)
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

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isEditing.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
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
                    prompt: "Rechercher un livre"
                )
                .onChange(of: searchText, debounceTime: .seconds(2)) {
                    oldValue, newValue in
                    Task {
                        await fetchBooks(search: newValue)
                    }
                }
            }
            .alert(
                "Supprimer cette étagère ?",
                isPresented: $showDeleteConfirmation
            ) {
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
            .sheet(isPresented: $isEditing) {
                EditShelfView(
                    name: shelf.name,
                    emoji: Emoji(value: shelf.emoji, name: "Emoj"),
                    color: Color(
                        hex: shelf.color
                    ) ?? .booksterGreen,
                    shelfId: shelf.id
                ) {
                    isEditing.toggle()
                    Task {
                        fetchShelves()
                    }
                }
                .presentationDetents([.height(200)])
                .presentationDragIndicator(.visible)
            }
            .task {
                await fetchBooks()
            }
            .refreshable {
                searchText = ""
                await fetchBooks()
            }
        }
    }
    
    private func fetchBooks(search: String = "") async {
        do {
            let fetchedBooks = try await BookService.shared.searchBooksFromShelf(search: search, shelfId: shelf.id)
            books = fetchedBooks.data
        } catch {
            print("❌ Erreur BookService : \(error.localizedDescription)")
        }
    }

    private func deleteShelf() async {
        //TODO: Loading
        do {
            try await ShelfService.shared.deleteShelf(id: shelf.id)
            await SessionManager.shared.fetchCurrentUser()
        } catch {
            print(error)
        }

        onDelete()

        dismiss()
    }

    private func bookCell(book: Book) -> some View {
        NavigationLink {
            BookDetailView(book: book) {
                Task {
                    isSearchActive = false
                    searchText = ""
                    await fetchBooks()
                    fetchShelves()
                }
            } refreshBooks: {
                Task {
                    isSearchActive = false
                    searchText = ""
                    await fetchBooks()
                    fetchShelves()
                }
            }
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

#if DEBUG
#Preview("Logged In") {

    ShelfDetailView(
        shelf: Shelf.mock,
        onDelete: {},
        fetchShelves: {}
    )
    .environment(SessionManager.preview)
}

#endif
