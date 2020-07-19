//
//  PhotoViewModel.swift
//  Photos
//
//  Created by Arjun P A on 19/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol PhotoViewModelInterface {
    var title: Driver<String> { get }
    var description: Driver<String?> { get }
    var image: Driver<UIImage?>  { get }
    func downloadImage()
    func cancelDownload()
}

final class PhotoViewModel: PhotoViewModelInterface {
    
    var title: Driver<String> {
        return self.titleRelaySubject.asDriver(onErrorJustReturn: "")
    }
    
    var description: Driver<String?> {
        return self.descriptionRelaySubject.asDriver(onErrorJustReturn: nil)
    }
    
    var image: Driver<UIImage?> {
        return self.imageRelaySubject.asDriver(onErrorJustReturn: nil)
    }
    
    private let photo: Photo
    
    private let imageDownloader: ImageDownloader
    
    private let titleRelaySubject: BehaviorRelay<String>
    
    private let descriptionRelaySubject: BehaviorRelay<String?>
    
    private let imageRelaySubject = BehaviorRelay<UIImage?>(value: nil)
    
    private let disposeBag = DisposeBag()
    
    private var downloadTask: BehaviorRelay<ImageDownloadCancellable?>?
    
    init(photo: Photo, imageDownloader: ImageDownloader = .default) {
        self.photo = photo
        self.titleRelaySubject = BehaviorRelay<String>(value: photo.title)
        self.descriptionRelaySubject = BehaviorRelay<String?>(value: photo.description)
        self.imageDownloader = imageDownloader
    }
    
    func downloadImage() {
        guard let imageURL = self.photo.imageHref else {
            self.imageRelaySubject.accept(nil)
            return
        }
        let result = self.imageDownloader.download(with: imageURL)
        result.event.subscribe(onSuccess: { [weak self] image in
                                    self?.imageRelaySubject.accept(image)
                     },
                               onError: { [weak self] _ in
                                    self?.imageRelaySubject.accept(nil)
        }).disposed(by: self.disposeBag)
        self.downloadTask = result.task
    }
    
    func cancelDownload() {
        self.downloadTask?.value?.cancel()
    }
}
