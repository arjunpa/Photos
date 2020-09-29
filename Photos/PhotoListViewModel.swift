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
    
    let title: Driver<String?>
    
    let isLoading: Driver<Bool>
    
    let photoViewModel: Driver<[PhotoViewModelInterface]>
    
    let error: Driver<LocalizedError?>
    
    private let repository: PhotoListRepositoryInterface
    
    private let disposeBag = DisposeBag()
    
    private let titleRelay = BehaviorRelay<String?>(value: nil)
    
    private let photoViewModelRelay = BehaviorRelay<[PhotoViewModel]>(value: [])
    
    private let errorRelay = BehaviorRelay<LocalizedError?>(value: nil)
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    init(with repository: PhotoListRepositoryInterface) {
        self.repository = repository
        self.title = self.titleRelay.asDriver(onErrorJustReturn: nil)
        self.isLoading = self.isLoadingRelay.asDriver()
        self.photoViewModel = self.photoViewModelRelay
                                    .flatMap { (viewModel: [PhotoViewModel]) -> Observable<[PhotoViewModelInterface]> in
                                                return Observable.just(viewModel)
                                              }
                                     .asDriver(onErrorJustReturn: [])
        
        self.error = self.errorRelay.asDriver(onErrorJustReturn: nil)
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
                self?.isLoadingRelay.accept(false)
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
