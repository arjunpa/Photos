//
//  ImageDownloader.swift
//  Photos
//
//  Created by Arjun P A on 19/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift

protocol ImageDownloaderInterface {
    func download(with url: URL) -> Single<UIImage?>
}

final class ImageDownloader: ImageDownloaderInterface {
    
    static let `default` = ImageDownloader()
    
    private let kfManager: KingfisherManager
    
    init(kfManager: KingfisherManager = .shared) {
        self.kfManager = kfManager
    }
    
    func download(with url: URL) -> Single<UIImage?> {
        return Single<UIImage?>.create { [weak self] single -> Disposable in
            self?.kfManager.retrieveImage(with: url) { result in
                switch result {
                case .success(let image):
                    single(.success(image.image))
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create {}
        }
    }
}
