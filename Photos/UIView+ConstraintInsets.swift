//
//  UIView+ConstraintInsets.swift
//  Photos
//
//  Created by Arjun P A on 06/10/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

extension UIView {
    
    func addSubview(_ view: UIView, insets: UIEdgeInsets) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: insets.left),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom)
        ])
    }
}
