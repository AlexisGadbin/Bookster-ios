//
//  SettingsView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 10/03/2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Button("Logout") {
            SessionManager.shared.logout()
        }
    }
}

#Preview {
    SettingsView()
}
