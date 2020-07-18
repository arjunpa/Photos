//
//  PhotoListViewModel.swift
//  Photos
//
//  Created by Arjun P A on 19/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation
import RxSwift


final class PhotoListViewModel {
    
    private let repository: PhotoListRepositoryInterface
    
    init(with repository: PhotoListRepositoryInterface) {
        self.repository = repository
    }
}
