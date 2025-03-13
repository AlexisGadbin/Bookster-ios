//
//  ImageTitleCell.swift
//  Bookster
//
//  Created by Alexis Gadbin on 12/03/2025.
//

import SwiftUI

struct ImageTitleCell: View {
    var imageWidth: CGFloat = 120
    var imageHeight: CGFloat = 150
    var imageName: String = Constants.randomImage
    var title: String = "Des diables et des saints"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ImageLoaderView(urlString: imageName)
                .frame(width: imageWidth, height: imageHeight)
            
            Text(title)
                .font(.callout)
                .foregroundStyle(.booksterLightGray)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        // Pour que le texte ne dépasse pas l'image
        .frame(width: imageWidth)
    }
}

#Preview {
    ImageTitleCell()
}
