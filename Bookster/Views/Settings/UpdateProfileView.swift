//
//  UpdateProfileView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 17/03/2025.
//

import PhotosUI
import SwiftUI

struct UpdateProfileView: View {
    @Environment(SessionManager.self) var session
    @Environment(\.colorScheme) var colorScheme
    
    @State private var profileImage: Image? = Image(
        systemName: "person.circle.fill")
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedUIImage: UIImage?
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    
    var body: some View {
        if let user = session.currentUser {
            return AnyView(
                ZStack {
                    VStack(spacing: 0) {
                        AvatarCell(user: user)
                        
                        PhotosPicker(
                            selection: $selectedItem, matching: .images
                        ) {
                            Text("Modifier la photo de profil")
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                if let data = try? await newItem?
                                    .loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data)
                                {
                                    selectedUIImage = uiImage
                                    profileImage = Image(uiImage: uiImage)
                                }
                                
                                await updateProfilePicture()
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 20)
                        
                        Form {
                            Section {
                                TextField("Prénom", text: $firstName)
                                TextField("Nom", text: $lastName)
                                TextField("Email", text: $email)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                            }
                        }
                        
                        Spacer()
                    }
                    .onAppear {
                        firstName = user.firstName
                        lastName = user.lastName
                        email = user.email
                        
                    }
                    .toolbar(.hidden, for: .tabBar)
                    .navigationTitle("Modifier le profil")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                Task {
                                    await updateProfile()
                                }
                            } label: {
                                Text("Sauvegarder")
                            }.disabled(isSaveDisabled())
                        }
                    }
                })
        } else {
            return AnyView(EmptyView())
        }
    }
    
    private func isSaveDisabled() -> Bool {
        guard let user = session.currentUser else { return true }
        
        if(firstName.isEmpty || lastName.isEmpty || email.isEmpty) {
            return true
        }
        
        if(user .firstName == firstName &&
           user.lastName == lastName &&
           user.email == email) {
            return true
        }
        
        
        return false
    }
    
    private func updateProfilePicture() async {
        guard let image = selectedUIImage else { return }
        //TODO: chargement
        do {
            let response: User = try await UserService.shared
                .updateProfilePicture(image: image)
        } catch {
            print("Error updating profile picture")
        }
    }
    
    private func updateProfile() async {
        guard let user = session.currentUser else { return }
        
        do {
            let updateProfileRequest = UpdateProfileRequest(
                firstName: firstName,
                lastName: lastName,
                email: email
            )
            
            let response: User = try await UserService.shared
                .updateProfile(updateProfileRequest: updateProfileRequest)
            session.currentUser = response
        } catch {
            print("Error updating profile")
        }
    }
}

#Preview {
    NavigationStack {
        UpdateProfileView()
            .environment(SessionManager.preview)
    }
}
