//
//  Scale.swift
//  AudioEngine2
//
//  Created by Grant Damron on 10/8/16.
//  Copyright © 2016 Grant Damron. All rights reserved.
//

import Foundation

enum Scale: String {
    case MinorPentatonic = "Minor Pentatonic",
    MajorPentatonic = "Major Pentatonic",
    Blues = "Blues",
    Major = "Major",
    Minor = "Minor",
    Dorian = "Dorian",
    Mixolydian = "Mixolydian",
    Phrygian = "Phyrgian",
    Lydian = "Lydian",
    HarmonicMinor = "Harmonic Minor",
    MelodicMidnor = "Melodic Minor"
    
    var notes: [Int] {
        var scale:[Int]
        
        switch self {
            
        case .MinorPentatonic: scale = [0, 2, 5, 7, 9]
        case .MajorPentatonic: scale = [0, 2, 4, 7, 9]
        case .Blues: scale = [0, 2, 5, 7, 8, 9]
        case .Major: scale = [0, 2, 4, 5, 7, 9, 11]
        case .Minor: scale = [0, 2, 3, 5, 7, 8, 10]
        case .Dorian: scale = [0, 2, 3, 5, 7, 9, 10]
        case .Mixolydian: scale = [0, 2, 4, 5, 7, 9, 10]
        case .Phrygian: scale = [0, 1, 3, 5, 7, 8, 10]
        case .Lydian: scale = [0, 2, 4, 6, 7, 9, 11]
        case .HarmonicMinor: scale = [0, 2, 3, 5, 7, 8, 11]
        case .MelodicMidnor: scale = [0, 2, 3, 5, 7, 9, 11]
            
        }
        
        return scale.map {$0 + UserSettings.sharedInstance.lowNote}
    }
    
    static var list: [String] {
        return [
            Scale.MinorPentatonic.rawValue,
            Scale.MajorPentatonic.rawValue,
            Scale.Blues.rawValue,
            Scale.Major.rawValue,
            Scale.Minor.rawValue,
            Scale.Dorian.rawValue,
            Scale.Mixolydian.rawValue,
            Scale.Phrygian.rawValue,
            Scale.Lydian.rawValue,
            Scale.HarmonicMinor.rawValue,
            Scale.MelodicMidnor.rawValue
        ]
    }
}
