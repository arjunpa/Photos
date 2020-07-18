//
//  APIService.swift
//  Photos
//
//  Created by Arjun P A on 18/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation
import RxSwift

final class APIService: APIServiceInterface {
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func request<T: Decodable>(with request: Requestable) -> Single<APIHTTPDecodableResponse<T>> {
        return Single<APIHTTPDecodableResponse<T>>.create { single -> Disposable in
            do {
                
                let urlRequest = try request.asURLRequest()
                self.session.dataTask(with: urlRequest) { data, response, error in
                    if let error = error {
                        single(.error(error))
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else  {
                        single(.error(APIServiceError.APIResponseError.failed(.httpStatusCodeFailure)))
                        return
                    }
                    let data = data ?? Data()
                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: data)
                        single(.success(APIHTTPDecodableResponse<T>(data: data, decoded: decoded, httpResponse: httpResponse)))
                    } catch {
                        single(.error(error))
                    }
                }
                
            } catch {
                single(.error(error))
            }
            return Disposables.create {
                
            }
        }
    }
}
