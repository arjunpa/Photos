//
//  UITableViewCell+ReuseIdentifier.swift
//  Photos
//
//  Created by Arjun P A on 19/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

protocol ReuseIdentifier {
    static var reuseIdentifier: String { get }
}

protocol NibLoadable {
    static var nibName: String { get }
}

extension NibLoadable where Self: UITableViewCell {
    
    static var nibName: String {
        return String(describing: self)
    }
}

extension ReuseIdentifier where Self: UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseIdentifier {}
extension UITableViewCell: NibLoadable {}
