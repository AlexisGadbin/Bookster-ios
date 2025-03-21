//
//  ShelfCell.swift
//  Bookster
//
//  Created by Alexis Gadbin on 19/03/2025.
//

import SwiftUI

struct ShelfCell: View {
    @Environment(\.colorScheme) var colorScheme
    
    var shelf: Shelf
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    colorScheme == .dark
                    ? Color.booksterBlack
                    : Color.white
                )
                .brightness(-0.01)
                .shadow(
                    color: colorScheme == .dark
                    ? Color.clear
                    : Color.black.opacity(0.1),
                    radius: 4,
                    x: 0,
                    y: 2
                )
            VStack(alignment: .leading) {
                HStack {
                    Text(shelf.name)
                        .font(.title3)
                        .fontDesign(.rounded)
                    
                    Spacer()
                    
                    Text("\(shelf.books?.count ?? 0)")
                        .font(.callout)
                    
                    Image(systemName: "chevron.right")
                        .font(.callout)
                }
                .fontWeight(.bold)
                
                if let books = shelf.books {
                    if !books.isEmpty {
                        HStack(spacing: 16) {
                            ForEach(books) { book in
                                
                                ImageLoaderView(
                                    urlString: book.coverImageUrl!
                                )
                                .frame(width: 60, height: 100)
                            }
                        }
                    }
                    else {
                        Text("Tu n'as pas encore commencé à remplir cette étagère !")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .frame(
                                maxWidth: .infinity,
                                minHeight: 100,
                                maxHeight: 100,
                                alignment: .center
                            )
                    }
                }
            }
            .padding(16)
            .padding(.top, 4)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .foregroundColor(
            colorScheme == .dark
            ? .white
            : .black
        )
    }
}

#Preview {
    ShelfCell(
        shelf: Shelf.mock
    )
}
