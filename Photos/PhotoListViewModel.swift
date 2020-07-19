//
//  PhotoListViewModel.swift
//  Photos
//
//  Created by Arjun P A on 19/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol PhotoListViewModelInterface {
    var photoViewModel: Driver<[PhotoViewModelInterface]> { get }
    var error: Driver<LocalizedError?> { get }
    func fetchPhotos()
}

final class PhotoListViewModel: PhotoListViewModelInterface  {
    
    var photoViewModel: Driver<[PhotoViewModelInterface]> {
        self.photoViewModelSubject
        .flatMap { (viewModel: [PhotoViewModel]) -> Observable<[PhotoViewModelInterface]> in
            return Observable.just(viewModel)
        }.asDriver(onErrorJustReturn: [])
    }
    
    var error: Driver<LocalizedError?> {
        return self.errorSubject.asDriver(onErrorJustReturn: nil)
    }
    
    private let repository: PhotoListRepositoryInterface
    
    private let disposeBag = DisposeBag()
    
    private let photoViewModelSubject = PublishSubject<[PhotoViewModel]>()
    
    private let errorSubject = PublishSubject<LocalizedError?>()
    
    init(with repository: PhotoListRepositoryInterface) {
        self.repository = repository
    }
    
    func fetchPhotos() {
        _ = self.repository
            .fetchPhotos()
            .subscribe(onNext: { response in
                self.photoViewModelSubject.onNext(response.rows.map({ PhotoViewModel(photo: $0) }))
            },
            onError: { _ in
                self.errorSubject.onNext(LocalizedError.generic)
            },
            onCompleted: nil,
            onDisposed: nil)
    }
}
