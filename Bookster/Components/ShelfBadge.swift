//
//  ShelfBadge.swift
//  Bookster
//
//  Created by Alexis Gadbin on 09/04/2025.
//

import SwiftUI

struct ShelfBadge: View {
    var name: String = "Shelf Name"
    var emoji: String = "📚"
    var color: String = "#FF5733"
    
    var body: some View {
        Text("\(emoji) \(name)")
            .font(.headline)
            .fontWeight(.bold)
            .fixedSize()
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(Color(hex: color))
            .cornerRadius(10)
    }
}

#Preview {
    ShelfBadge()
}
