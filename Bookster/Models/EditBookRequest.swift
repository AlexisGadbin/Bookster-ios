//
//  EditBookRequest.swift
//  Bookster
//
//  Created by Alexis Gadbin on 16/03/2025.
//

import Foundation
import UIKit

struct EditBookRequest {
    let title: String
    let description: String?
    let authorName: String
    let coverImage: UIImage?
    let backCoverImage: UIImage?
    let note: Int?
}
