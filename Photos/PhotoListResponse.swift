//
//  PhotoListResponse.swift
//  Photos
//
//  Created by Arjun P A on 18/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

struct PhotoListResponse: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case title
        case rows
    }
    
    let title: String
    let rows: [Photo]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.rows = try container.decode([SafeDecodable<Photo>].self, forKey: .rows).compactMap({ $0.underlyingBase })
    }
}

struct Photo: Decodable {
    let title: String
    let description: String?
    let imageHref: URL?
}
