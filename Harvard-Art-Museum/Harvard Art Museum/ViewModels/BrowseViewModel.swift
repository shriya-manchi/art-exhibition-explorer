//
//  ExhibitionViewModel.swift
//  Harvard Art Museum
//
//  Created by Shriya on 1/19/25.
//

import Foundation

class BrowseViewModel: ObservableObject {
    @Published var exhibitions: [Exhibition] = []

    private let apiKey = "1a87581b-4e1f-4c63-b9fc-fcac376ed87f"
    private let baseURL = "https://api.harvardartmuseums.org/exhibition"

    func fetchExhibitions() async {
        // create url
        guard let url = URL(string: "\(baseURL)?apikey=\(apiKey)") else {
            print("invalid url")
            return
        }
        await fetchAllPages(url: url)
    }
    
    
    private func fetchAllPages(url: URL) async {
        // fetch data from url
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            // decode data
            if let decodedResponse = try? JSONDecoder().decode(ExhibitionResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.exhibitions.append(contentsOf: decodedResponse.records)
                }
                // check if there's more pages
                if let nextPageURLString = decodedResponse.info.next,
                   let nextPageURL = URL(string: nextPageURLString) {
                    // fetch  next page
                    await fetchAllPages(url: nextPageURL)
                }
            }
        } catch {
            print("failed to fetch data")
        }
    }
}

struct ExhibitionResponse: Codable {
    let info: Info
    let records: [Exhibition]
    
    struct Info: Codable {
        let next: String?
    }
}

