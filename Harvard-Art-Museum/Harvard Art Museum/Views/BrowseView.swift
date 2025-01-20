//
//  BrowseView.swift
//  Harvard Art Museum
//
//  Created by Shriya on 1/19/25.
//

import SwiftUI

struct BrowseView: View {
    @StateObject private var viewModel = BrowseViewModel()
    @State private var searchText = ""

    var filteredExhibitions: [Exhibition] {
        guard !searchText.isEmpty else { return viewModel.exhibitions }
        return viewModel.exhibitions.filter { exhibition in exhibition.title.localizedCaseInsensitiveContains(searchText) || ((exhibition.description?.localizedCaseInsensitiveContains(searchText)) != nil) }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                List {
                    ForEach(filteredExhibitions, id: \.exhibitionid) { exhibition in
                        ZStack(alignment: .leading) {
                            NavigationLink(destination: ExhibitionView(exhibition: exhibition)) { EmptyView()
                            }
                            .opacity(0)
                            VStack(alignment: .leading) {
                                AsyncImage(url: URL(string: exhibition.primaryimageurl)) { image in image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 126)
                                        .clipped()
                                        .cornerRadius(8)
                                } placeholder: {
                                    Color.gray
                                        .frame(height: 126)
                                }
                                HStack {
                                    Text(exhibition.title)
                                        .font(.system(size: 17))
                                        .bold()
                                        .lineLimit(1)
                                    Spacer()
                                    Text("\(formatDate(exhibition.begindate ?? "unknown")) - \(formatDate(exhibition.enddate ?? "unknown"))")
                                        .font(.footnote)
                                        .bold()
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                                Text(exhibition.description ?? "No description available")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .lineLimit(3)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .searchable(text: $searchText, prompt: "Search for an exhibition")
                .listStyle(PlainListStyle())
                .task {
                    await viewModel.fetchExhibitions()
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Browse")
        }
    }
    
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Input format
        guard let date = dateFormatter.date(from: dateString) else { return "Unknown Date" }
        dateFormatter.dateFormat = "MMM dd" // Output format
        return dateFormatter.string(from: date)
    }
}


#Preview {
    BrowseView()
}
