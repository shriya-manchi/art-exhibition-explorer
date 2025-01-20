//
//  FavoritesManager.swift
//  Harvard Art Museum
//
//  Created by Shriya on 1/20/25.
//

import Foundation

class FavoritesManager: ObservableObject {
    @Published var favoriteArtworks: [Object] = []

    func toggleFavorite(_ object: Object) {
        if let index = favoriteArtworks.firstIndex(where: { $0.objectid == object.objectid }) {
            favoriteArtworks.remove(at: index) // remove
        } else {
            favoriteArtworks.append(object) // add
        }
    }

    func isFavorite(_ object: Object) -> Bool {
        favoriteArtworks.contains(where: { $0.objectid == object.objectid })
    }
}

