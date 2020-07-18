//
//  RequestEncoding.swift
//  Photos
//
//  Created by Arjun P A on 18/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

typealias RequestParameters = [String: Any]
typealias RequestHeaders = [String: String]

protocol RequestEncoding {
    func encode(_ request: Requestable, with parameters: RequestParameters?) throws -> URLRequest
} 
