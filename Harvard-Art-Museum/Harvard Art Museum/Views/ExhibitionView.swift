//
//  ExhibitionView.swift
//  Harvard Art Museum
//
//  Created by Shriya on 1/19/25.
//

import SwiftUI

struct ExhibitionView: View {
    var exhibition: Exhibition
    @StateObject private var viewModel = ExhibitionViewModel()
    @State private var favoriteArtworks = Set<Int>()
    @State private var searchText = ""
    
    var filteredObjects: [Object] {
        guard !searchText.isEmpty else { return viewModel.objects }
        return viewModel.objects.filter { object in object.title.localizedCaseInsensitiveContains(searchText) || ((object.description?.localizedCaseInsensitiveContains(searchText)) != nil) || ((object.artist?.localizedCaseInsensitiveContains(searchText)) != nil) }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // title
                Text(exhibition.title)
                    .font(.system(size: 28))
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.bottom, 4)
                    .multilineTextAlignment(.leading)
                
                // description
                Text(exhibition.description ?? "No description available")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .lineLimit(3)
                
                // objects
                List {
                    ForEach(filteredObjects, id: \.objectid) { object in
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
                                        toggleFavorite(objectId: object.objectid)
                                    }) {
                                        ZStack {
                                            Circle()
                                                .fill()
                                                .foregroundColor(.white)
                                                .frame(width: 28, height: 28)
                                            Image(systemName: favoriteArtworks.contains(object.objectid) ? "heart.fill" : "heart")
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
            .task {
                await viewModel.fetchObjects(exhibitionId: exhibition.exhibitionid)
            }
        .searchable(text: $searchText, prompt: "Search for artwork")
        }
    }
    
    // favorite state for an artwork
    private func toggleFavorite(objectId: Int) {
        if favoriteArtworks.contains(objectId) {
            favoriteArtworks.remove(objectId)
        } else {
            favoriteArtworks.insert(objectId)
        }
    }


}

#Preview {
    ExhibitionView(exhibition: Exhibition(
        exhibitionid: 1,
        title: "Van Gogh Exhibition: The Immersive Experience",
        primaryimageurl: "https://example.com/vangogh.jpg",
        begindate: "2025-01-01",
        enddate: "2025-12-31",
        description: "It is a fully immersive room with a 360° digital show. 60 projectors bring 200 Van Gogh’s masterpieces to life on a 1000 m2 surface."
    ))
}
