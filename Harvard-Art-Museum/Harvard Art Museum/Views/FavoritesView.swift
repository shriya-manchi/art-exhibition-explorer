//
//  FavoritesView.swift
//  Harvard Art Museum
//
//  Created by Shriya on 1/19/25.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var searchText = ""
    
    var filteredFavorites: [Object] {
        if searchText.isEmpty {
            return favoritesManager.favoriteArtworks
        } else {
            return favoritesManager.favoriteArtworks.filter { object in
                object.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if favoritesManager.favoriteArtworks.isEmpty { // no favorites
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
                            ZStack(alignment: .leading) {
                                NavigationLink(destination: ObjectView(object: object)) { EmptyView()
                                }
                                .opacity(0)
                                HStack(alignment: .top) {
                                    // image
                                    ZStack(alignment: .topTrailing) {
                                        AsyncImage(url: URL(string: object.primaryimageurl)) { image in
                                            image.resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 185, height: 112)
                                                .cornerRadius(8)
                                                .clipped()
                                        } placeholder: {
                                            Color.gray
                                                .frame(width: 185, height: 112)
                                                .cornerRadius(8)
                                        }
                                        // favorite button
                                        Button(action: {
                                            favoritesManager.toggleFavorite(object)
                                        }) {
                                            ZStack {
                                                Circle()
                                                    .fill()
                                                    .foregroundColor(.white)
                                                    .frame(width: 28, height: 28)
                                                Image(systemName: favoritesManager.isFavorite(object) ? "heart.fill" : "heart")
                                                    .foregroundColor(.red)
                                                    .offset(y: 2)
                                            }
                                        }
                                        .offset(x: -12, y: 12)
                                        .buttonStyle(BorderlessButtonStyle())
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        // artwork title
                                        Text(object.title)
                                            .font(.headline)
                                            .lineLimit(1)
                                        
                                        // artist, year
                                        if let artist = object.artist, let year = object.dated {
                                            Text("\(artist), \(year)")
                                                .font(.system(size: CGFloat(15)))
                                        } else if let artist = object.artist {
                                            Text(artist)
                                                .font(.system(size: CGFloat(15)))
                                        } else if let year = object.dated {
                                            Text(year)
                                                .font(.system(size: CGFloat(15)))
                                        }
                                        
                                        // description
                                        Text(object.description ?? "No description available")
                                            .font(.system(size: CGFloat(13)))
                                            .foregroundColor(.secondary)
                                            .lineLimit(4)
                                    }
                                }
                            }
                            .padding(.bottom)
                            .listRowInsets(EdgeInsets())
                        }
                        .listRowSeparator(.hidden)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Favorites")
            .searchable(text: $searchText, prompt: "Search for an artwork")
        }
    }
}

#Preview {
    FavoritesView()
}
