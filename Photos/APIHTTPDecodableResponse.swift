//
//  APIResponse.swift
//  Photos
//
//  Created by Arjun P A on 18/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

struct APIHTTPDecodableResponse<T> where T:Decodable {
    let data: Data
    let decoded: T
    let httpResponse: HTTPURLResponse?
}
