//
//  CreateShelfView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 22/03/2025.
//

import SwiftUI

struct CreateShelfView: View {
    @State private var name: String = ""
    @State var onCreate: () -> Void
    
    var body: some View {
        VStack {
            TextField("Nom", text: $name)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button(action: {
                Task {
                    await createShelf()
                }
            }) {
                Text("Créer l'étagère")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    private func createShelf() async {
        do {
            let editShelfRequest = EditShelfRequest(name: name)
            let response = try await ShelfService.shared.createShelf(editShelfRequest: editShelfRequest)
            
            onCreate()
        } catch {
            print("Error creating shelf: \(error)")
        }
    }
}

#Preview {
    CreateShelfView {
        print("Create shelf")
    }
}
