//
//  VersionLink.swift
//  Bookster
//
//  Created by Alexis Gadbin on 09/04/2025.
//

import SwiftUI

struct VersionLink: View {
    @State private var showVersion = false
    
    private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
    private let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "?"
    
    var body: some View {
        Button(action: {
            showVersion.toggle()
        }) {
            Label("Version", systemImage: "info.circle")
        }
        .buttonStyle(.plain)
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
