//
//  PageMeta.swift
//  Bookster
//
//  Created by Alexis Gadbin on 12/03/2025.
//

import Foundation

struct PageMeta: Codable {
    let total: Int
    let perPage: Int
    let currentPage: Int
    let lastPage: Int
    let firstPage: Int

    let firstPageUrl: String
    let lastPageUrl: String
    let nextPageUrl: String?
    let previousPageUrl: String?
}
