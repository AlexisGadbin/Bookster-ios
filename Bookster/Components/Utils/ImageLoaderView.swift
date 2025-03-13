//
//  ImageLoaderView.swift
//  Bookster
//
//  Created by Alexis Gadbin on 12/03/2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageLoaderView: View {
    
    private var urlString: String
    private var resizingMode: ContentMode
    
    init(urlString: String = Constants.randomImage, resizingMode: ContentMode = .fill) {
        self.urlString = urlString
        self.resizingMode = resizingMode
    }
    
    var body: some View {
        Rectangle()
            .opacity(0.001)
            .overlay {
                WebImage(url: URL(string: urlString))
                    .resizable()
                    .indicator(.activity)
                    .aspectRatio(contentMode: resizingMode)
                    .allowsHitTesting(false)
            }
            .clipped()
        
    }
}

#Preview {
    ImageLoaderView()
        .cornerRadius(30)
        .padding(30)
        .padding(.vertical, 60)
}
