//
//  AddBookView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 15/03/2025.
//

import PhotosUI
import SwiftUI

struct EditBookView: View {
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
    
    @State private var isbnCode: String?
    
    @State private var isShowingScanner = false
    @State private var isFetchingOpenLibrary = false
    @State private var showBookNotFoundAlert = false
    
    var onAdd: (() -> Void)?
    var bookId: Int?
    
    init(onAdd: (() -> Void)? = nil) {
        self.onAdd = onAdd
    }
    
    init(
        title: String,
        authorName: String,
        description: String,
        note: Float,
        coverImage: UIImage?,
        backCoverImage: UIImage?,
        selectedShelves: [Shelf],
        bookId: Int? = nil,
        onAdd: (() -> Void)? = nil
    ) {
        self.title = title
        self.authorName = authorName
        self.description = description
        self.note = note
        self.coverUIImage = coverImage
        self.backCoverUIImage = backCoverImage
        self.selectedShelves = selectedShelves
        self.bookId = bookId
        self.onAdd = onAdd
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                        .disabled(isSaving || title.isEmpty || authorName.isEmpty || coverUIImage == nil)
                    }
                }
                .toolbar(.hidden, for: .tabBar)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isShowingScanner = true
                        } label: {
                            Image(systemName: "barcode.viewfinder")
                        }
                        .sheet(isPresented: $isShowingScanner) {
                            ScanBarcodeView { isbnCode in
                                self.isbnCode = isbnCode
                                fetchBookByIsbn()
                                isShowingScanner = false
                            }
                        }
                    }
                }
                .disabled(isFetchingOpenLibrary)
                .navigationBarBackButtonHidden(isFetchingOpenLibrary)
                .navigationTitle("Ajouter un livre")
                .navigationBarTitleDisplayMode(.inline)
                .onChange(of: coverImage) { newItem in
                    loadImage(from: newItem, into: $coverUIImage)
                }
                .onChange(of: backCoverImage) { newItem in
                    loadImage(from: newItem, into: $backCoverUIImage)
                }
                .alert(
                    "Livre non reconnu",
                    isPresented: $showBookNotFoundAlert,
                    actions: {
                        Button("OK", role: .cancel) { }
                    },
                    message: {
                        Text("Désolé, nous n'avons pas pu trouver ton livre !")
                    }
                )
                
                if isFetchingOpenLibrary {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .overlay(
                            ProgressView("Powered by OpenLibrary...")
                                .progressViewStyle(.circular)
                                .padding(20)
                                
                        )
                }
            }
        }
        .allowsHitTesting(!isFetchingOpenLibrary)
    }
    
    private func downloadImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, response) = try await
            URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            return UIImage(data: data)
        } catch {
            print("❌ Erreur lors du téléchargement de l'image : \(error.localizedDescription)")
            return nil
        }
    }
    
    private func fetchBookByIsbn() {
        Task {
            isFetchingOpenLibrary = true
            defer { isFetchingOpenLibrary = false }
            
            do {
                guard let isbnCode = isbnCode else { return }
                
                let book = try await OpenLibraryService.shared.getBookByIsbn(isbn: isbnCode)
                title = book.title
                
                if let authorKey = book.authors?.first?.key {
                    let author = try await OpenLibraryService.shared.getAuthorByKey(key: authorKey)
                    authorName = author.name
                }
                
                let coverImageUrl = "\(Constants.openLibraryCoverURL)/b/isbn/\(isbnCode)-L.jpg?default=false"
                print(coverImageUrl)
                if let coverImage = await downloadImage(from: coverImageUrl) {
                    coverUIImage = coverImage
                }
                
            } catch {
                showBookNotFoundAlert = true
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
            
            onAdd?()
            
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
    EditBookView()
        .environment(SessionManager.preview)
}
#endif
