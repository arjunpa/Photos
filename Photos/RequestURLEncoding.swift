//
//  RequestURLEncoding.swift
//  Photos
//
//  Created by Arjun P A on 18/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

struct RequestURLEncoding: RequestEncoding {
    
    func encode(_ request: Requestable, with parameters: RequestParameters?) throws -> URLRequest {
        var urlRequest = try request.asURLRequest()
        guard
          let requestMethod = urlRequest.requestMethod,
          let parameters = parameters
          else { return urlRequest }
        
        if self.shouldEncodeParametersInURL(forRequestMethod: requestMethod) {
            guard let url = urlRequest.url else {
                throw APIServiceError.URLEncodingError.failed(.invalidURL)
            }
            
            if
              !parameters.isEmpty,
              var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                let queryEncodedURL = (urlComponents.percentEncodedQuery.map({ $0 + "&" }) ?? "") + self.queryEncodedString(from: parameters)
                urlComponents.percentEncodedQuery = queryEncodedURL
                urlRequest.url = urlComponents.url ?? urlRequest.url
            } else {
                urlRequest.httpBody = self.queryEncodedString(from: parameters).data(using: .utf8)
            }
        }
        
        return urlRequest
    }
    
    private func shouldEncodeParametersInURL(forRequestMethod requestMethod: RequestMethod) -> Bool {
        return requestMethod == .get
    }
    
    private func queryEncodedString(from parmeters: RequestParameters) -> String {
        var queryComponents: [(String, String)] = []
        for key in parmeters.keys.sorted() {
            guard let value = parmeters[key] else { continue }
            queryComponents.append(self.queryEncode(key: key, value: value))
        }
        return queryComponents.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    private func queryEncode(key: String, value: Any) -> (String, String) {
        if let nsNumber = value as? NSNumber {
            if nsNumber.isBool {
                return (self.addPercentEncoding(on: key), self.addPercentEncoding(on: String(describing: nsNumber.boolValue)))
            } else {
                return (self.addPercentEncoding(on: key), self.addPercentEncoding(on: "\(nsNumber)"))
            }
        } else if let boolValue = value as? Bool {
            return (self.addPercentEncoding(on: key), self.addPercentEncoding(on: String(describing: boolValue)))
        } else {
            return (self.addPercentEncoding(on: key), self.addPercentEncoding(on: "\(value)"))
        }
    }
    
    private func addPercentEncoding(on string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
    }
}

extension NSNumber {
    fileprivate var isBool: Bool {
        String(cString: objCType) == "c"
    }
}
