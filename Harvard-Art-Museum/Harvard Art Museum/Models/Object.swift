//
//  Object.swift
//  Harvard Art Museum
//
//  Created by Shriya on 1/20/25.
//

import Foundation

struct Object: Codable {
    let objectid: Int
    let title: String
    let dated: String?
    let primaryimageurl: String
    let description: String?
    let medium: String?
    let dimensions: String
    let people: [Person]?
    
    var artist: String? {
        // return the name of the first person associated with the object
        people?.first?.name
    }
    var lifespan: String? {
        people?.first?.displaydate
    }
}

struct Person: Codable {
    let name: String
    let displaydate: String?
}
