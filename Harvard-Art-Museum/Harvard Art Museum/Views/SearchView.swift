//
//  SearchView.swift
//  Harvard Art Museum
//
//  Created by Shriya on 1/19/25.
//

import SwiftUI

struct SearchView: View {
    var exhibition: Exhibition
    @StateObject private var viewModel = ExhibitionViewModel()
    @State private var searchText = ""
    
    var filteredObjects: [Object] {
        guard !searchText.isEmpty else { return viewModel.objects }
        return viewModel.objects.filter { object in object.title.localizedCaseInsensitiveContains(searchText) || ((object.description?.localizedCaseInsensitiveContains(searchText)) != nil) || ((object.artist?.localizedCaseInsensitiveContains(searchText)) != nil) }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                List {
                    ForEach(filteredObjects, id: \.objectid) { object in
                        HStack {
                            AsyncImage(url: URL(string: object.primaryimageurl)) { image in image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(4)
                                    .clipped()
                            } placeholder: {
                                Color.gray
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(4)
                            }
                            VStack(alignment: .leading) {
                                Text(object.title)
                                    .lineLimit(1)
                                    .font(.callout)
                                    .bold()
                                Text("Artwork")
                                    .font(.callout)
                            }
                        }
                        .listRowInsets(EdgeInsets())
                    }
                    .listRowSeparator(.hidden)
                }
                .scrollContentBackground(.hidden)
            }
        }
        .searchable(text: $searchText, prompt: "Search for an artwork")
        .task {
            await viewModel.fetchObjects(exhibitionId: exhibition.exhibitionid)
        }
    }
}

#Preview {
    SearchView(exhibition: Exhibition(
        exhibitionid: 1,
        title: "Van Gogh Exhibition: The Immersive Experience",
        primaryimageurl: "https://example.com/vangogh.jpg",
        begindate: "2025-01-01",
        enddate: "2025-12-31",
        description: "It is a fully immersive room with a 360° digital show. 60 projectors bring 200 Van Gogh’s masterpieces to life on a 1000 m2 surface."
    ))
}
