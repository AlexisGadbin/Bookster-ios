//
//  HomeView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 06/03/2025.
//

import SwiftUI
import DebouncedOnChange

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(SessionManager.self) var session

    @State private var books: [Book] = []
    @State private var isSearchActive = false
    @State private var searchText = ""

    init(books: [Book] = []) {
        _books = State(initialValue: books)
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
                            ForEach(books) { book in
                                NavigationLink {
    //                                BookDetailsView(book: book)
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
                    }
                }
            }
            .navigationTitle(Text("Bookster"))
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
                        //TODO: ajouter un livre
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.booksterGreen)
                    }
                }
            }
            .if(isSearchActive) { view in
                view.searchable(
                    text: $searchText, isPresented: $isSearchActive,
                    prompt: "Rechercher un livre")
                .onChange(of: searchText, debounceTime: .seconds(2)) { oldValue, newValue in
                    Task {
                        await fetchBooks(search: newValue)
                    }
                }
            }
        }
        .task {
            await fetchBooks()
        }
        .refreshable {
            searchText = ""
            await fetchBooks()
        }
    }

    private func fetchBooks(search: String = "") async {
        do {
            print("🔍 Recherche de livres")
            let fetchedBooks = try await BookService.shared.searchBooks(search: search)
            books = fetchedBooks.data
        } catch {
            print("❌ Erreur BookService : \(error.localizedDescription)")
        }
    }
}

#Preview("Logged In") {
    let mockSession = SessionManager(
        token: "token",
        user: User(
            id: 1, firstName: "Alexis", lastName: "Gadbin",
            email: "alexis@gadbin.com", avatarUrl: nil))
    
    // Use the mock 

    HomeView(books: Book.mocks(count: 10))
    .environment(mockSession)
}

#Preview("Logged Out") {
    HomeView()
        .environment(SessionManager.shared)
}
