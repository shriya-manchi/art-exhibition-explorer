//
//  Harvard_Art_MuseumApp.swift
//  Harvard Art Museum
//
//  Created by Shriya on 1/18/25.
//

import SwiftUI

@main
struct Harvard_Art_MuseumApp: App {
    @StateObject private var favoritesManager = FavoritesManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoritesManager)
        }
    }
}
