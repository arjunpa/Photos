//
//  URLFormable.swift
//  Photos
//
//  Created by Arjun P A on 18/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

protocol URLFormable {
    func asURL() throws -> URL
}

extension String: URLFormable {
    
    func asURL() throws -> URL {
        guard let url = URL(string: self) else {
            throw APIServiceError.URLFormableError.failed
        }
        return url
    }
}

extension URL: URLFormable {
    
    func asURL() throws -> URL {
        return self
    }
}
