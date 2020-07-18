//
//  APIServiceInterface.swift
//  Photos
//
//  Created by Arjun P A on 18/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation
import RxSwift

protocol APIServiceInterface {
    func request<T: Decodable>(with request: Requestable) -> Single<APIHTTPDecodableResponse<T>>
}
