//
//  Data+UTF8Representation.swift
//  Photos
//
//  Created by Arjun P A on 19/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

extension Data {
    
    var utf8Representation: Data? {
        if let utfEncodedData = String(data: self, encoding: .utf8) {
            return utfEncodedData.data(using: .utf8) ?? self
        }
        guard let asciiRepresentation = String(data: self, encoding: .ascii) else { return nil }
        return asciiRepresentation.data(using: .utf8)
    }
}
