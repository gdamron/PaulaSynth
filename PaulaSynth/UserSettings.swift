//
//  UserSettings.swift
//  AudioEngine2
//
//  Created by Grant Damron on 10/4/16.
//  Copyright © 2016 Grant Damron. All rights reserved.
//

import UIKit
import Foundation

class UserSettings: NSObject {
    static let sharedInstance = UserSettings()
    
    fileprivate enum Keys: String {
        case LowNote = "lowNote"
        case PolyOn = "polyphonyOn"
        case Scale = "scale"
        case Sound = "sound"
        case TabHidden = "tabHidden"
    }

    
    let tabHiddenThresh = 3
    var lowNote = 48 {
        didSet {
            dirty = true
        }
    }
    var polyphonyOn = false {
        didSet {
            dirty = true
        }
    }
    var scale = Scale.Blues {
        didSet {
            dirty = true
        }
    }
    
    var tabHiddenCount = 0 {
        didSet {
            dirty = true
            tabHiddenCount = min(tabHiddenCount, tabHiddenThresh)
        }
    }
    
    var hideSettingsTab: Bool {
        return tabHiddenCount >= tabHiddenThresh
    }
    
    var sound = SynthSound.Square
    
    fileprivate var dirty = false
    
    open func save() {
        if (dirty) {
            let defaults = UserDefaults.standard
            defaults.set(lowNote, forKey: Keys.LowNote.rawValue)
            defaults.set(polyphonyOn, forKey: Keys.PolyOn.rawValue)
            defaults.set(scale.rawValue, forKey: Keys.Scale.rawValue)
            defaults.set(sound.name, forKey: Keys.Sound.rawValue)
            defaults.set(tabHiddenCount, forKey: Keys.TabHidden.rawValue)
            defaults.synchronize()
            dirty = false
        }
    }
    
    open func load() {
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: Keys.LowNote.rawValue) != nil {
            lowNote = defaults.integer(forKey: Keys.LowNote.rawValue)
        }
        
        // default value of false is acceptable
        polyphonyOn = defaults.bool(forKey: Keys.PolyOn.rawValue)
        
        // default vale of 0 is fine
        tabHiddenCount = defaults.integer(forKey: Keys.TabHidden.rawValue)
        
        if let val = defaults.string(forKey: Keys.Scale.rawValue),
            let s = Scale(rawValue: val) {
            scale = s
        }
        
        if let soundVal = defaults.string(forKey: Keys.Sound.rawValue) {
            sound = SynthSound(key: soundVal)
        }
    }
}
