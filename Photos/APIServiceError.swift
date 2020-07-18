//
//  APIServiceError.swift
//  Photos
//
//  Created by Arjun P A on 18/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

enum APIServiceError: Error {
    
    enum URLFormableError: Error {
        case failed
    }
    
    enum URLEncodingErrorReason {
        case invalidURL
    }
    
    enum URLEncodingError: Error {
        case failed(URLEncodingErrorReason)
    }
    
    enum APIResponseErrorReason: Error {
        case httpStatusCodeFailure
    }
    
    enum APIResponseError: Error {
        case failed(APIResponseErrorReason)
    }
}

