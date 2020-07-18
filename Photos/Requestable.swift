//
//  Requestable.swift
//  Photos
//
//  Created by Arjun P A on 18/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol Requestable {
    func asURLRequest() throws -> URLRequest
}

extension URLRequest: Requestable {
    
    func asURLRequest() throws -> URLRequest {
        return self
    }
}
