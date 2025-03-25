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
                
                if books.isEmpty {
                    VStack(alignment: .center, spacing: 12) {
                        Text("Vous n'avez pas encore de livre enregistré.")
                            .font(.title3)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 32)
                }
                
                
                ScrollView(.vertical) {
                    VStack(spacing: 12) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                            ForEach(books) { book in
                                bookCell(book: book)
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
                    NavigationLink {
                        AddBookView {
                            Task {
                                await fetchBooks()
                            }
                        }
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
            let fetchedBooks = try await UserService.shared.getMyBooks(search: search)
            books = fetchedBooks.data
        } catch {
            print("❌ Erreur BookService : \(error.localizedDescription)")
        }
    }
    
    private func bookCell(book: Book) -> some View {
        NavigationLink {
            BookDetailView(book: book, onDelete: {
                Task {
                    isSearchActive = false
                    searchText = ""
                    await fetchBooks()
                }
            })
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
    HomeView(books: Book.mocks(count: 10))
        .environment(SessionManager.preview)
}

#Preview("Logged Out") {
    HomeView()
        .environment(SessionManager.shared)
}
#endif
