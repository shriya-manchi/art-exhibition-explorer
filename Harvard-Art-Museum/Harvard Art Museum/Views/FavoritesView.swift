//
//  FavoritesView.swift
//  Harvard Art Museum
//
//  Created by Shriya on 1/19/25.
//

import SwiftUI

struct FavoritesView: View {
    @State private var favoriteArtworks: [Object] = [] // List of favorited artworks
    @State private var searchText = ""

    var filteredFavorites: [Object] {
        if searchText.isEmpty {
            return favoriteArtworks
        } else {
            return favoriteArtworks.filter { object in
                object.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                if favoriteArtworks.isEmpty { // no favorites
                    VStack(spacing: 16) {
                        Text("You have no favorited artworks.")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        NavigationLink(destination: BrowseView()) {
                            Text("Browse art")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 220, height: 43)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .searchable(text: $searchText, prompt: "Search for an artwork")
                    }
                } else {
                    List {
                        ForEach(filteredFavorites, id: \.objectid) { object in
                            HStack(alignment: .top) {
                                // image
                                AsyncImage(url: URL(string: object.primaryimageurl)) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(8)
                                        .clipped()
                                } placeholder: {
                                    Color.gray
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(8)
                                }
                                
                                // artwork details
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(object.title)
                                        .font(.headline)
                                        .lineLimit(1)
                                    Text("\(object.artist ?? "Unknown Artist"), \(object.dated ?? "Unknown Date")")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(object.description ?? "No description available")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                }
                                Spacer()
                                
                                Button(action: {
                                    toggleFavorite(object: object)
                                }) {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    .searchable(text: $searchText, prompt: "Search for an artwork")
                }
            }
            .navigationTitle("Favorites")
        }
    }

    // Toggle favorite functionality
    private func toggleFavorite(object: Object) {
        if let index = favoriteArtworks.firstIndex(where: { $0.objectid == object.objectid }) {
            favoriteArtworks.remove(at: index)
        }
    }
}

#Preview {
    FavoritesView()
}
