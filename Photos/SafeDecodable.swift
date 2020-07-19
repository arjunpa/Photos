//
//  SafeDecodable.swift
//  Photos
//
//  Created by Arjun P A on 19/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

struct SafeDecodable<Base: Decodable>: Decodable {
    let underlyingBase: Base?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.underlyingBase = try? container.decode(Base.self)
    }
}
