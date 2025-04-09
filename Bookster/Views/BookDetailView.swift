//
//  BookDetailView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 13/03/2025.
//

import SwiftUI
import WrappingHStack

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

                VStack(alignment: .leading, spacing: 4) {
                    Text(book.title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                    
                    HStack {
                        Text(book.author?.name ?? "Inconnu")
                            .font(.body)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                        
                        Spacer()
                        
                        if let note = book.note {
                            let formattedNote = note.truncatingRemainder(dividingBy: 1) == 0
                                ? String(format: "%.0f", note)
                                : String(format: "%.1f", note)
                            Text("\(formattedNote)/10")
                                .font(.body)
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                        } else {
                            Text("Pas de note")
                                .font(.body)
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                        }
                            
                    }
                }
                

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
                
                if let shelves = book.shelves {
                    WrappingHStack(shelves) { shelf in
                        ShelfBadge(
                            name: shelf.name,
                            emoji: shelf.emoji,
                            color: shelf.color
                        )
                        .padding(.vertical, 4)
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Notes de l'utilisateur")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text(book.description ?? "Pas de notes renseignées")
                        .font(.body)
                }
            }
            .padding(.horizontal, 16)
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
