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
    func fetchPhotos() -> Observable<PhotoListResponse>
}

final class PhotoListRepository: PhotoListRepositoryInterface  {
    
    private let apiService: APIService
    
    init(with apiService: APIService) {
        self.apiService = apiService
    }
    
    func fetchPhotos() -> Observable<PhotoListResponse> {
        let request = Request(url: "", method: .get, parameters: nil, headers: nil, encoding: RequestURLEncoding())
        return self.apiService.request(with: request)
               .asObservable()
               .flatMap { (response: APIHTTPDecodableResponse<PhotoListResponse>) -> Observable<PhotoListResponse> in
                return Observable.just(response.decoded)
        }.share()
    }
}
 
