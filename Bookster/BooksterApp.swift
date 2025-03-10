//
//  BooksterApp.swift
//  Bookster
//
//  Created by Alexis Gadbin on 05/03/2025.
//

import SwiftUI

@main
struct BooksterApp: App {
    @State private var session = SessionManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(session)
        }
    }
}
