//
//  EditShelfView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 22/03/2025.
//

import EmojiPicker
import SwiftUI

struct EditShelfView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var name: String = ""
    @State private var emoji: Emoji? = Emoji(value: "📚", name: "Books")
    @State private var color: Color = .booksterGreen
    @State var onEdit: () -> Void
    var shelfId: Int?
    
    let presetColors: [Color] = [
        .booksterGreen, .blue, .orange, .pink, .purple, .red,
    ]
    
    init(onEdit: @escaping () -> Void) {
        self.onEdit = onEdit
    }
    
    init(
        name: String,
        emoji: Emoji,
        color: Color,
        shelfId: Int,
        onEdit: @escaping () -> Void
    ) {
        self.name = name
        self.emoji = emoji
        self.color = color
        self.shelfId = shelfId
        self.onEdit = onEdit
    }
    
    @State
    var displayEmojiPicker: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button {
                    displayEmojiPicker = true
                } label: {
                    Text(emoji?.value ?? "📚")
                        .font(.title)
                        .font(.title)
                        .frame(width: 50, height: 50)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }
                
                TextField("Nom", text: $name)
                    .padding(.horizontal)
                    .frame(height: 50)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
            }
            
            HStack(spacing: 12) {
                ForEach(presetColors, id: \.self) { preset in
                    Circle()
                        .fill(preset)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(
                                    color == preset
                                    ? Color.accentColor : Color.clear,
                                    lineWidth: 3)
                        )
                        .onTapGesture {
                            color = preset
                            print(color)
                        }
                }
                
                ZStack {
                    Circle()
                        .fill(
                            AngularGradient(
                                gradient: Gradient(colors: [
                                    .red, .orange, .yellow, .green, .blue,
                                    .purple, .red,
                                ]),
                                center: .center
                            )
                        )
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(
                                    presetColors.contains(color)
                                    ? Color.clear : Color.accentColor,
                                    lineWidth: 3
                                )
                        )
                    
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.callout)
                    
                    ColorPicker("", selection: $color, supportsOpacity: false)
                        .labelsHidden()
                        .frame(width: 30, height: 30)
                        .blendMode(.destinationOver)
                }
                
            }
            .padding(.horizontal)
            
            Button(action: {
                Task {
                    await editShelf()
                }
            }) {
                Text(shelfId == nil ? "Créer l'étagère" : "Modifier l'étagère")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(color)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .sheet(isPresented: $displayEmojiPicker) {
            NavigationView {
                EmojiPickerView(
                    selectedEmoji: $emoji,
                    selectedColor: .accentColor
                )
                .navigationTitle("Emojis")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    trailing: Button("Fermer", systemImage: "xmark") {
                        displayEmojiPicker = false
                    }
                        .foregroundStyle(
                            colorScheme == .dark
                            ? .booksterWhite : .booksterBlack
                            
                        )
                )
            }
        }
    }
    
    private func editShelf() async {
        guard !name.isEmpty else {
            return
        }
        
        guard let emoji = emoji else {
            return
        }
        
        guard let color = color.toHexString() else {
            return
        }
        
        do {
            let editShelfRequest = EditShelfRequest(
                name: name,
                emoji: emoji.value,
                color: color
            )
            
            if let shelfId = shelfId
            {
                let response = try await ShelfService.shared.updateShelf(
                    id: shelfId,
                    editShelfRequest: editShelfRequest
                )
            } else {
                let response = try await ShelfService.shared.createShelf(
                    editShelfRequest: editShelfRequest
                )
            }
            
            await SessionManager.shared.fetchCurrentUser()
            onEdit()
        } catch {
            print("Error editing shelf: \(error)")
        }
    }
}

#Preview {
    EditShelfView {
        print("Create shelf")
    }
}
