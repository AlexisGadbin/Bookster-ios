//
//  ConstructionBanner.swift
//  Bookster
//
//  Created by Alexis Gadbin on 25/03/2025.
//

import SwiftUI

struct ConstructionBanner: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "wrench.and.screwdriver.fill")
            Text("Page en construction")
                .font(.footnote)
                .fontWeight(.semibold)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.yellow.opacity(0.2))
        .cornerRadius(12)
        .padding(.top, 16)
    }
}

#Preview {
    ConstructionBanner()
}
