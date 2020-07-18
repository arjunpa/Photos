//
//  URLRequest+RequestMethod.swift
//  Photos
//
//  Created by Arjun P A on 18/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

extension URLRequest {
    
    var requestMethod: RequestMethod? {
        guard let httpMethod = self.httpMethod else { return nil }
        return RequestMethod(rawValue: httpMethod)
    }
    
    init(with url: URLFormable, method: RequestMethod, headers: [String: String]?) throws {
        self.init(url: try url.asURL())
        self.httpMethod = method.rawValue
        self.allHTTPHeaderFields = headers
    }
}

