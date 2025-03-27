//
//  BookDetailView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 13/03/2025.
//

import SwiftUI

struct BookDetailView: View {
    let book: Book
    var onDelete: (() -> Void)? = nil

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss

    @State private var showDeleteConfirmation = false
    @State private var isDeleting = false

    var body: some View {
        ZStack(alignment: .top) {
            colorScheme == .dark
                ? Color.booksterBlack.ignoresSafeArea()
                : Color.booksterWhite.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {

                Text(book.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)

                HStack(alignment: .center, spacing: 32) {
                    if let coverImageUrl = book.coverImageUrl {
                        ImageLoaderView(urlString: coverImageUrl)
                            .frame(width: 140, height: 240)
                    }

                    if let coverImageUrl = book.backCoverImageUrl {
                        ImageLoaderView(urlString: coverImageUrl)
                            .frame(width: 140, height: 240)
                    }
                }
                .frame(maxWidth: .infinity)

                if let description = book.description {
                    Text(description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Pas de description renseignée")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text("Auteur :")
                        .font(.body)
                        .foregroundStyle(.secondary)
                    Text(book.author?.name ?? "Inconnu")
                        .font(.body)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                }

                VStack {
                    if let shelves = book.shelves {
                        Text("Etagères :")
                            .font(.body)

                        ForEach(shelves) { shelf in
                            Text(shelf.name)
                        }
                    }
                }
                
                Spacer()

                ConstructionBanner()
            }
        }
        .alert("Supprimer ce livre ?", isPresented: $showDeleteConfirmation) {
            Button("Supprimer", role: .destructive) {
                Task {
                    await deleteBook()
                }
            }
            Button("Annuler", role: .cancel) {
                showDeleteConfirmation = false
            }
        } message: {
            Text("Cette action est irréversible.")
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Edit
                } label: {
                    Image(systemName: "pencil")
                }
                .disabled(true)
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Share
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .disabled(true)
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
    }

    private func deleteBook() async {
        //TODO: Loading
        isDeleting = true
        do {
            try await BookService.shared.deleteBook(id: book.id)
        } catch {
            print(error)
        }
        isDeleting = false

        onDelete?()

        dismiss()
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            BookDetailView(book: Book.mock)
                .environment(SessionManager.preview)
        }
    }
#endif
