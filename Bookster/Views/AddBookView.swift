//
//  AddBookView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 15/03/2025.
//

import PhotosUI
import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SessionManager.self) var session
    
    @State private var title: String = ""
    @State private var authorName: String = ""
    @State private var description: String = ""
    
    @State private var note: Float = 5.0
    
    @State private var coverImage: PhotosPickerItem?
    @State private var backCoverImage: PhotosPickerItem?
    
    @State private var coverUIImage: UIImage?
    @State private var backCoverUIImage: UIImage?
    
    @State private var selectedShelves: [Shelf] = []
    
    @State private var isSaving = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Informations du livre")) {
                    TextField("Titre", text: $title)
                    TextField("Auteur", text: $authorName)
                    TextField(
                        "Description", text: $description, axis: .vertical
                    )
                    .lineLimit(3...6)
                }
                
                Section(header: Text("Couvertures")) {
                    PhotosPicker(selection: $coverImage, matching: .images) {
                        HStack {
                            Text("Image de couverture")
                            Spacer()
                            if let image = coverUIImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 90)
                                    .clipped()
                                    .cornerRadius(6)
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.booksterLightGray)
                            }
                        }
                    }
                    
                    PhotosPicker(selection: $backCoverImage, matching: .images)
                    {
                        HStack {
                            Text("4ème de couverture")
                            Spacer()
                            if let image = backCoverUIImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 90)
                                    .clipped()
                                    .cornerRadius(6)
                            } else {
                                Image(systemName: "photo.on.rectangle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.booksterLightGray)
                            }
                        }
                    }
                }
                
                Section(header: Text("Note")) {
                    HStack {
                        Slider(
                            value: $note,
                            in: 0...10,
                            step: 0.5
                        )
                        .foregroundStyle(.booksterGreen)
                        
                            Text("\(note, specifier: "%.1f")")
                                .foregroundStyle(.secondary)
                        
                    }
                }
                
                Section(header: Text("Étagère")) {
                    NavigationLink {
                        ShelfPickerView(
                            selectedShelves: $selectedShelves,
                            shelves: session.currentUser?.shelves ?? []
                        )
                    } label: {
                        HStack {
                            Text("Sélectionner une étagère")
                            Spacer()
                            Text("\(selectedShelves.count) étagères")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Section {
                    Button {
                        Task {
                            await saveBook()
                        }
                    } label: {
                        HStack {
                            Spacer()
                            if isSaving {
                                ProgressView()
                            } else {
                                Text("Enregistrer le livre")
                                    .bold()
                            }
                            Spacer()
                        }
                    }
                    .disabled(isSaving || title.isEmpty || authorName.isEmpty)
                }
            }
            .navigationTitle("Ajouter un livre")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: coverImage) { newItem in
                loadImage(from: newItem, into: $coverUIImage)
            }
            .onChange(of: backCoverImage) { newItem in
                loadImage(from: newItem, into: $backCoverUIImage)
            }
        }
    }
    
    private func loadImage(
        from item: PhotosPickerItem?, into imageBinding: Binding<UIImage?>
    ) {
        guard let item else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data)
            {
                imageBinding.wrappedValue = uiImage
            }
        }
    }
    
    private func saveBook() async {
        isSaving = true
        
        do {
            let shelfIds = selectedShelves.map { $0.id }
            
            let parameters: [String: Any] = [
                "title": title,
                "description": description,
                "authorName": authorName,
                "note": note,
                "shelfIds": shelfIds
            ]
            
            let images: [String: UIImage?] = [
                "coverImage": coverUIImage,
                "backCoverImage": backCoverUIImage
            ]
            
            let response: Book = try await NetworkManager.shared.uploadMultipart(
                endpoint: "/books",
                parameters: parameters,
                images: images
            )
            
            dismiss()
            
        } catch {
            print(
                "❌ Erreur lors de l'ajout du livre : \(error.localizedDescription)"
            )
        }
        
        isSaving = false
    }
}



#if DEBUG
#Preview {
    AddBookView()
        .environment(SessionManager.preview)
}
#endif
