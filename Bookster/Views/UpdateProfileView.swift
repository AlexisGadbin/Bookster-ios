//
//  UpdateProfileView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 17/03/2025.
//

import SwiftUI
import PhotosUI

struct UpdateProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var profileImage: Image? = Image(systemName: "person.circle.fill")
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedUIImage: UIImage?

    @State private var username: String = ""
    @State private var email: String = ""

    var body: some View {
        ZStack {
            colorScheme == .dark
                ? Color.booksterBlack.ignoresSafeArea()
                : Color.booksterWhite.ignoresSafeArea()
            
                VStack(spacing: 0) {
                        profileImage?
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .foregroundColor(.gray)
                            .shadow(radius: 4)

                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Text("Modifier la photo de profil")
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedUIImage = uiImage
                                    profileImage = Image(uiImage: uiImage)
                                }
                                
                                await updateProfilePicture()
                            }
                        
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 20)

                    Spacer()
                }
                .navigationTitle("Modifier le profil")
                .navigationBarTitleDisplayMode(.inline)
            }
    }
    
    private func updateProfilePicture() async {
        guard let image = selectedUIImage else { return }
        //TODO: chargement
        do {
            let response: User = try await UserService.shared.updateProfilePicture(image: image)
        } catch {
            print("Error updating profile picture")
        }
    }
}

#Preview {
    NavigationView {
        UpdateProfileView()
    }
}
