//
//  PhotoViewModel.swift
//  Photos
//
//  Created by Arjun P A on 19/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

protocol PhotoViewModelInterface {
    var title: String { get }
    var description: String? { get }
    var imageURL: URL { get }
}
