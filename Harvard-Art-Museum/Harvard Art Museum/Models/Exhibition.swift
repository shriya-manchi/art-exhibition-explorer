//
//  Exhibition.swift
//  Harvard Art Museum
//
//  Created by Shriya on 1/19/25.
//

import Foundation

struct Exhibition: Codable {
    let exhibitionid: Int
    let title: String
    let primaryimageurl: String
    let begindate: String?
    let enddate: String?
    let description: String?
}
