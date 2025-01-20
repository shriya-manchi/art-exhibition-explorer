//
//  ExhibitionViewModel.swift
//  Harvard Art Museum
//
//  Created by Shriya on 1/19/25.
//

import Foundation

class ExhibitionViewModel: ObservableObject {
    @Published var objects: [Object] = []
    
    private let apiKey = "1a87581b-4e1f-4c63-b9fc-fcac376ed87f"
    private let baseURL = "https://api.harvardartmuseums.org/object"
    
    func fetchObjects(exhibitionId: Int) async {
        guard let url = URL(string: "\(baseURL)?apikey=\(apiKey)&exhibition=\(exhibitionId)") else {
            print("Invalid URL")
            return
        }
        await fetchAllObjects(url: url)
    }
    
    private func fetchAllObjects(url: URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(ObjectResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.objects = decodedResponse.records
                }
            }
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
        }
    }
}

struct ObjectResponse: Codable {
    let records: [Object]
}


