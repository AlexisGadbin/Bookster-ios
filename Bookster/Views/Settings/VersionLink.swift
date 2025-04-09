//
//  VersionLink.swift
//  Bookster
//
//  Created by Alexis Gadbin on 09/04/2025.
//

import SwiftUI

struct VersionLink: View {
    @State private var showVersion = false
    @Environment(\.colorScheme) private var colorScheme
    
    private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
    private let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "?"
    
    var body: some View {
        Button(action: {
            showVersion.toggle()
        }) {
            Label {
                Text("Version")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            } icon: {
                Image(systemName: "info.circle")
            }
        }
        .alert(isPresented: $showVersion) {
            Alert(
                title: Text("Version"),
                message: Text("Version \(version) (\(build))"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    Form {
        Section {
            VersionLink()
            VersionLink()
        }
    }
}
