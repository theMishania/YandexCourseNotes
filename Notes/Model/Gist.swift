//
//  Gist.swift
//  Notes
//
//  Created by Мишаня  on 11/08/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import Foundation

struct Gist: Codable {
    let files: [String: GistFile]?
    var isPublic: Bool?
    var id: String?
    
    enum CodingKeys: String, CodingKey {
        case files
        case isPublic = "public"
        case id
    }
}

struct GistFile: Codable {
    let filename: String
    let rawUrl: String?
    let content: String
    
    enum CodingKeys: String, CodingKey { // Позволяет использовать названия полей в структуре отличающиеся от названий ключей в JSON
        case filename
        case rawUrl = "raw_url"
        case content
    }
}
