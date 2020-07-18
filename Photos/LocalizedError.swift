//
//  LocalizedError.swift
//  Photos
//
//  Created by Arjun P A on 19/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

struct LocalizedError: Error {
    var title: String
    var body: String
}

extension LocalizedError {
    static let generic = LocalizedError(title: "Error", body: "Something went wrong. Please try again")
}
