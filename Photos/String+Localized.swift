//
//  String+Localized.swift
//  Photos
//
//  Created by Arjun P A on 07/10/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
