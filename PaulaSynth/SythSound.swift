//
//  SythSound.swift
//  AudioEngine2
//
//  Created by Grant Damron on 10/10/16.
//  Copyright © 2016 Grant Damron. All rights reserved.
//

import Foundation
import AudioKit

enum SynthSound: String {
    case Square, Triangle, Sawtooth, Scream, Sine, TwentySixHundred
    
    static var keys: [String] {
        return ["Square", "Triangle", "Sawtooth", "Scream", "Sine", "2600"]
    }
    
    var waveform: AKTable {
        switch self {
        case .Square: return AKTable(.square)
        case .Triangle: return AKTable(.triangle)
        case .Sawtooth: return AKTable(.sawtooth)
        case .Scream: return AKTable(.square)
        case .Sine: return AKTable(.sine)
        case .TwentySixHundred: return AKTable(.reverseSawtooth)
        }
    }
    
    var name: String {
        switch self {
        case .Square: return SynthSound.keys[0]
        case .Triangle: return SynthSound.keys[1]
        case .Sawtooth: return SynthSound.keys[2]
        case .Scream: return SynthSound.keys[3]
        case .Sine: return SynthSound.keys[4]
        case .TwentySixHundred: return SynthSound.keys[5]
        }
    }
}
