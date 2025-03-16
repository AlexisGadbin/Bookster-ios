//
//  ShelfPickerView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 15/03/2025.
//

import SwiftUI

struct ShelfPickerView: View {
    @Binding var selectedShelves: [Shelf]
    @State var shelves: [Shelf] = []

    var body: some View {
        Form {
            ForEach(shelves) { shelf in
                MultipleSelectionRow(
                    title: shelf.name,
                    isSelected: selectedShelves.contains(where: {
                        $0.id == shelf.id
                    })
                ) {
                    if let index = selectedShelves.firstIndex(where: {
                        $0.id == shelf.id
                    }) {
                        selectedShelves.remove(at: index)
                    } else {
                        selectedShelves.append(shelf)
                    }
                }
            }
        }
    }

    struct MultipleSelectionRow: View {
        @Environment(\.colorScheme) var colorScheme
        
        var title: String
        var isSelected: Bool
        var action: () -> Void

        var body: some View {
            Button(action: action) {
                HStack {
                    Text(title)
                        .foregroundStyle(
                            colorScheme == .dark
                            ? .booksterWhite : .booksterBlack
                        )
                    Spacer()
                    if isSelected {
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedShelves: [Shelf] = []
    
        ShelfPickerView(
            selectedShelves: $selectedShelves,
            shelves: Shelf.mocks(count: 5)
        )
    
}
