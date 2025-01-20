//
//  ObjectView.swift
//  Harvard Art Museum
//
//  Created by Shriya on 1/20/25.
//

import SwiftUI

struct ObjectView: View {
    var object: Object
    @StateObject private var viewModel = ExhibitionViewModel()
    @State private var favoriteArtworks = Set<Int>()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center) {
                    AsyncImage(url: URL(string: object.primaryimageurl)) { image in image
                            .resizable()
                            .scaledToFit()
                            .clipped()
                            .cornerRadius(8)
                    } placeholder: {
                        Color.gray
                            .frame(height: 217)
                            .cornerRadius(8)
                    }
                .padding(.bottom)
                }
                // title and favorite button
                HStack {
                    Text(object.title)
                        .font(.title)
                        .bold()
                    Spacer()
                    Button(action: {
                        toggleFavorite(objectId: object.objectid)
                    }) {
                        Image(systemName: favoriteArtworks.contains(object.objectid) ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }
                }
                // artist
                HStack {
                    Text("Artist:")
                        .bold()
                    Text("\(object.artist ?? "Unknown") (\(object.lifespan ?? "Unknown Date"))")
                }
                .font(.system(size: CGFloat(15)))

                // date of creation
                HStack {
                    Text("Date:")
                        .bold()
                    Text(object.dated ?? "unknown")
                }
                .font(.system(size: CGFloat(15)))

                // medium
                HStack {
                    Text("Medium:")
                        .bold()
                    Text(object.medium ?? "unknown")
                }
                .font(.system(size: CGFloat(15)))

                // dimensions
                HStack {
                    Text("Dimensions:")
                        .bold()
                    Text(object.dimensions)
                }
                .lineLimit(1)
                .font(.system(size: CGFloat(15)))

                // description
                VStack(alignment: .leading) {
                    Text("Description:")
                        .bold()
                    Text(object.description ?? "No description")
                        .foregroundColor(.secondary)
                }
                .font(.system(size: CGFloat(15)))

            }
            .padding(.horizontal)
            Spacer()
        }
    }
    private func toggleFavorite(objectId: Int) {
        if favoriteArtworks.contains(objectId) {
            favoriteArtworks.remove(objectId)
        } else {
            favoriteArtworks.insert(objectId)
        }
    }
}

#Preview {
    ObjectView(object: Object(
        objectid: 1,
        title: "Starry Night",
        dated: "1889",
        primaryimageurl: "https://sanctuarymentalhealth.org/wp-content/uploads/2021/03/The-Starry-Night-1200x630-1.jpg",
        description: "Vincent van Gogh's Starry Night is a masterful depiction of a night sky filled with swirling energy, luminous stars, and a tranquil village below. Painted from his room at the Saint-Paul-de-Mausole asylum in Saint-Rémy-de-Provence, France, this work reflects van Gogh’s profound emotional state and his fascination with the natural world.",
        medium: "Oil on canvas",
        dimensions: "29 x 36 1/4 in",
        people: [Person(name: "Vincent Van Gogh", displaydate: "1853-1890")]
    ))
}
