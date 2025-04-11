//
//  AvatarCell.swift
//  Bookster
//
//  Created by Alexis Gadbin on 11/04/2025.
//

import SwiftUI

struct AvatarCell: View {

    var user: User

    var body: some View {
        Group {
            if let avatarUrl = user.avatarUrl, !avatarUrl.isEmpty {
                ImageLoaderView(urlString: avatarUrl)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    AvatarCell(user: User.mock)
}
