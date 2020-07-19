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
import RxCocoa

typealias ImageDownloadResult = (task: BehaviorRelay<ImageDownloadCancellable?>,
                                 event: PrimitiveSequence<SingleTrait, UIImage?>)

protocol ImageDownloadCancellable {
    func cancel()
}

protocol ImageDownloaderInterface {
    func download(with url: URL) -> ImageDownloadResult
}

final class ImageDownloader: ImageDownloaderInterface {
    
    static let `default` = ImageDownloader()
    
    private let kfManager: KingfisherManager
    
    init(kfManager: KingfisherManager = .shared) {
        self.kfManager = kfManager
    }
    
    func download(with url: URL) -> ImageDownloadResult {
        var downloadTask: DownloadTask?
        let signal = Single<UIImage?>.create { [weak self] single -> Disposable in
            let closure: (Result<RetrieveImageResult, KingfisherError>) -> Void = { result in
                switch result {
                case .success(let image):
                    single(.success(image.image))
                case .failure(let error):
                    single(.error(error))
                }
            }
            downloadTask = self?.kfManager.retrieveImage(with: url, completionHandler: closure)
            return Disposables.create {}
        }
        return (task: BehaviorRelay<ImageDownloadCancellable?>(value: downloadTask), event: signal)
    }
}

extension DownloadTask: ImageDownloadCancellable {}
