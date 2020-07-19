//
//  APIEndPoint.swift
//  Photos
//
//  Created by Arjun P A on 19/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

enum APIEndPoint: String, URLFormable {
    case photosAPI = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    
    func asURL() throws -> URL {
        try self.rawValue.asURL()
    }
}
