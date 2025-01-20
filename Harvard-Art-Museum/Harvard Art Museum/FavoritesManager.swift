//
//  FavoritesManager.swift
//  Harvard Art Museum
//
//  Created by Shriya on 1/20/25.
//

import Foundation

class FavoritesManager: ObservableObject {
    @Published var favoriteIDs: Set<Int> = [] // stores favorite object IDs
    var allObjects: [Object] = []

    func addFavorite(_ object: Object) {
        favoriteIDs.insert(object.objectid)
    }

    func removeFavorite(_ object: Object) {
        favoriteIDs.remove(object.objectid)
    }

    func toggleFavorite(_ object: Object) {
        if favoriteIDs.contains(object.objectid) {
            removeFavorite(object)
        } else {
            addFavorite(object)
        }
    }

    func isFavorite(_ object: Object) -> Bool {
        favoriteIDs.contains(object.objectid)
    }

    func favoriteObjects() -> [Object] {
        allObjects.filter { favoriteIDs.contains($0.objectid) }
    }
}

