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
        _ = self.imageDownloader
                    .download(with: imageURL)
                    .subscribe(onSuccess: { [weak self] image in
                        self?.imageRelaySubject.accept(image)
                     },
                               onError: { [weak self] _ in
                        self?.imageRelaySubject.accept(nil)
                     })
    }
}
