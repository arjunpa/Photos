//
//  Request.swift
//  Photos
//
//  Created by Arjun P A on 18/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

struct Request: Requestable {
    
    let url: URLFormable
    let httpMethod: RequestMethod
    let parameters: RequestParameters?
    let headers: RequestHeaders?
    let encoding: RequestEncoding
    let ignoreCache: Bool
    
    init(url: URLFormable,
        method: RequestMethod,
        parameters: RequestParameters?,
        headers: RequestHeaders?,
        encoding: RequestEncoding,
        ignoreCache: Bool = false) {
        self.url = url
        self.httpMethod = method
        self.parameters = parameters
        self.headers = headers
        self.encoding = encoding
        self.ignoreCache = ignoreCache
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = try URLRequest(with: self.url, method: self.httpMethod, headers: self.headers)
        request.allHTTPHeaderFields = self.headers
        if let parameters = self.parameters {
            request = try self.encoding.encode(request, with: parameters)
        }
        request.cachePolicy = self.ignoreCache ? .reloadIgnoringLocalAndRemoteCacheData : .returnCacheDataElseLoad
        return request
    }
}
