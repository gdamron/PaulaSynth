//
//  ViewExtension.swift
//  AudioEngine2
//
//  Created by Grant Damron on 10/8/16.
//  Copyright © 2016 Grant Damron. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
