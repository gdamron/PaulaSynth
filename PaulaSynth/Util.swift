//
//  Util.swift
//  AudioEngine2
//
//  Created by Grant Damron on 10/9/16.
//  Copyright © 2016 Grant Damron. All rights reserved.
//

import Foundation
import UIKit

class Util {
    private static var lastRand: CGFloat = 0.0
    
    static func randomColor() -> UIColor {
        
        let maxVal: UInt32 = 360
        let delta = CGFloat(maxVal) / 16.0
        let Φ: CGFloat = 0.618033988749895
        
        var h = CGFloat(arc4random_uniform(maxVal))
        
        while abs(h - lastRand) < delta {
            h = CGFloat(arc4random_uniform(maxVal))
        }
        
        lastRand = h
        
        h = h / 360.0 + Φ
        
        if h > 1 {
            h -= 1.0
        }
        
        return UIColor(hue: h,
                       saturation: CGFloat(arc4random_uniform(100)) / 100.0 * 0.25 + 0.45,
                       brightness: 0.95,
                       alpha: 1.0)
    }
}
