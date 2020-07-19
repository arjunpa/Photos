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
    var title: Driver<String?> { get }
    var isLoading: Driver<Bool> { get }
    var photoViewModel: Driver<[PhotoViewModelInterface]> { get }
    var error: Driver<LocalizedError?> { get }
    func fetchPhotos(ignoreCache: Bool)
    func cancelDownload(at index: Int)
}

final class PhotoListViewModel: PhotoListViewModelInterface  {
    
    var title: Driver<String?> {
        return self.titleRelay.asDriver(onErrorJustReturn: nil)
    }
    
    var isLoading: Driver<Bool> {
        return self.isLoadingRelay.asDriver()
    }
    
    var photoViewModel: Driver<[PhotoViewModelInterface]> {
        self.photoViewModelRelay
        .flatMap { (viewModel: [PhotoViewModel]) -> Observable<[PhotoViewModelInterface]> in
            return Observable.just(viewModel)
        }.asDriver(onErrorJustReturn: [])
    }
    
    var error: Driver<LocalizedError?> {
        return self.errorRelay.asDriver(onErrorJustReturn: nil)
    }
    
    private let repository: PhotoListRepositoryInterface
    
    private let disposeBag = DisposeBag()
    
    private let titleRelay = BehaviorRelay<String?>(value: nil)
    
    private let photoViewModelRelay = BehaviorRelay<[PhotoViewModel]>(value: [])
    
    private let errorRelay = BehaviorRelay<LocalizedError?>(value: nil)
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    init(with repository: PhotoListRepositoryInterface) {
        self.repository = repository
    }
    
    func fetchPhotos(ignoreCache: Bool) {
        self.isLoadingRelay.accept(true)
        self
            .repository
            .fetchPhotos(ignoreCache: ignoreCache)
            .subscribe(onNext: { [weak self] response in
                self?
                    .photoViewModelRelay
                    .accept(response.rows.map({ PhotoViewModel(photo: $0) }))
                
                self?.titleRelay.accept(response.title)
                self?.isLoadingRelay.accept(false)
            },
            onError: { [weak self] _ in
                self?.errorRelay.accept(LocalizedError.generic)
            },
            onCompleted: nil,
            onDisposed: nil)
            .disposed(by: self.disposeBag)
    }
    
    func cancelDownload(at index: Int) {
        self.photoViewModelRelay.value[index].cancelDownload()
    }
}
