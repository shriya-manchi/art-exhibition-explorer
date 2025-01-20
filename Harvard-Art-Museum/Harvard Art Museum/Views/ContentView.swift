//
//  ContentView.swift
//  Harvard Art Museum
//
//  Created by Shriya on 1/18/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "photo")
                }
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
            SearchView(exhibition: Exhibition(
                exhibitionid: 1,
                title: "Van Gogh Exhibition: The Immersive Experience",
                primaryimageurl: "https://example.com/vangogh.jpg",
                begindate: "2025-01-01",
                enddate: "2025-12-31",
                description: "It is a fully immersive room with a 360° digital show. 60 projectors bring 200 Van Gogh’s masterpieces to life on a 1000 m2 surface."
            ))
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    ContentView()
}
