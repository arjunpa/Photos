//
//  PhotoListResponse.swift
//  Photos
//
//  Created by Arjun P A on 18/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

struct PhotoListResponse: Decodable {
    let title: String
    let rows: [Photo]
}

struct Photo: Decodable {
    let title: String
    let description: String?
    let imageHref: URL?
}
