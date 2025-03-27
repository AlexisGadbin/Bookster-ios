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
                HStack(alignment: .center) {
                    Text(shelf.emoji)
                        .font(.title3)
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
                .padding(16)
                .background(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [
                                Color(hex: shelf.color) ?? Color.booksterGray,
                                Color(hex: shelf.color)!.opacity(0.5)
                            ]
                        ),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(.rect(
                    topLeadingRadius: 12,
                    topTrailingRadius: 12
                ))
                
                Group {
                    if let books = shelf.books {
                        if !books.isEmpty {
                            GeometryReader { geometry in
                                HStack(spacing: 16) {
                                    ForEach(books.prefix(8)) { book in
                                        ImageLoaderView(
                                            urlString: book.coverImageUrl!
                                        )
                                        .frame(width: 60, height: 100)
                                    }
                                    Spacer()
                                }
                                .frame(maxWidth: geometry.size.width, alignment: .leading)
                                .clipped()
                            }
                            .frame(height: 100)
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
                .padding(.vertical, 4)
                .padding(.bottom, 4)
                .padding(.horizontal, 16)
            }
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
    ZStack {
        ShelfCell(
            shelf: Shelf.mock
        )
    }
}
