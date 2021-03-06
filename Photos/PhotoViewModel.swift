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
    var description: Driver<String> { get }
    var image: Driver<UIImage?>  { get }
    func downloadImage()
    func cancelDownload()
}

final class PhotoViewModel: PhotoViewModelInterface {
    
    private enum Constants {
        static let placeholderImageName = "place-holder-image"
    }
    
    let title: Driver<String>
    
    let description: Driver<String>
    
    let image: Driver<UIImage?>
    
    private let photo: Photo
    
    private let imageDownloader: ImageDownloader
    
    private let titleRelaySubject: BehaviorRelay<String>
    
    private let descriptionRelaySubject: BehaviorRelay<String>
    
    private let imageRelaySubject = BehaviorRelay<UIImage?>(value: nil)
    
    private let disposeBag = DisposeBag()
    
    private var downloadTask: BehaviorRelay<ImageDownloadCancellable?>?
    
    private var placeHolderImage: UIImage? {
        return UIImage(named: Constants.placeholderImageName)
    }
    
    init(photo: Photo, imageDownloader: ImageDownloader = .default) {
        self.photo = photo
        self.titleRelaySubject = BehaviorRelay<String>(value: photo.title)
        self.descriptionRelaySubject = BehaviorRelay<String>(value: photo.description)
        self.imageDownloader = imageDownloader
        
        self.title = self.titleRelaySubject.asDriver(onErrorJustReturn: "")
        self.description = self.descriptionRelaySubject.asDriver(onErrorJustReturn: "")
        self.image = self.imageRelaySubject.asDriver(onErrorJustReturn: nil)
    }
    
    func downloadImage() {
        guard let imageURL = self.photo.imageHref else {
            self.imageRelaySubject.accept(placeHolderImage)
            return
        }
        
        self.imageRelaySubject.accept(placeHolderImage)
        
        let result = self.imageDownloader.download(with: imageURL)
        result.event.subscribe(onSuccess: { [weak self] image in
                                    self?.imageRelaySubject.accept(image ?? self?.placeHolderImage)
                     },
                               onError: { [weak self] _ in
                                    self?.imageRelaySubject.accept(self?.placeHolderImage)
        }).disposed(by: self.disposeBag)
        self.downloadTask = result.task
    }
    
    func cancelDownload() {
        self.downloadTask?.value?.cancel()
    }
}
