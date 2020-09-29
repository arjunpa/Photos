//
//  PhotoListRepository.swift
//  Photos
//
//  Created by Arjun P A on 18/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation
import RxSwift

protocol PhotoListRepositoryInterface {
    func fetchPhotos(ignoreCache: Bool) -> Observable<PhotoListResponse>
}

final class PhotoListRepository: PhotoListRepositoryInterface  {
    
    private typealias Response = APIHTTPDecodableResponse<PhotoListResponse>
    
    private let apiService: APIServiceInterface
    
    init(with apiService: APIServiceInterface) {
        self.apiService = apiService
    }
    
    func fetchPhotos(ignoreCache: Bool) -> Observable<PhotoListResponse> {
        let request = Request(url: APIEndPoint.photosAPI,
                            method: .get,
                            parameters: nil,
                            headers: nil,
                            encoding: RequestURLEncoding(),
                            ignoreCache: ignoreCache)
        return self.apiService
                        .request(with: request)
                        .asObservable()
                        .flatMapLatest { (response: Response) -> Observable<PhotoListResponse> in
                            return Observable.just(response.decoded)
        }
    }
}
 
