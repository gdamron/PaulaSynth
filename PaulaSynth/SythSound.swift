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
    case Square, Triangle, Sawtooth, FM, Sine, TwentySixHundred
    
    static var keys: [String] {
        return ["Square", "Triangle", "Sawtooth", "FM", "Sine", "2600"]
    }
    
    var waveform: AKTable {
        switch self {
        case .Square: return AKTable(.square)
        case .Triangle: return AKTable(.triangle)
        case .Sawtooth: return AKTable(.sawtooth)
        case .FM: return AKTable(.square)
        case .Sine: return AKTable(.sine)
        case .TwentySixHundred: return AKTable(.reverseSawtooth)
        }
    }
    
    var name: String {
        switch self {
        case .Square: return SynthSound.keys[0]
        case .Triangle: return SynthSound.keys[1]
        case .Sawtooth: return SynthSound.keys[2]
        case .FM: return SynthSound.keys[3]
        case .Sine: return SynthSound.keys[4]
        case .TwentySixHundred: return SynthSound.keys[5]
        }
    }
    
    var velocity: Int {
        switch self {
        case .Square: return 64
        case .Triangle: return 96
        case .Sawtooth: return 64
        case .FM: return 64
        case .Sine: return 96
        case .TwentySixHundred: return 72
        }
    }
    
    init(key: String) {
        switch key {
        case SynthSound.keys[0]: self = .Square
        case SynthSound.keys[1]: self = .Triangle
        case SynthSound.keys[2]: self = .Sawtooth
        case SynthSound.keys[3]: self = .FM
        case SynthSound.keys[4]: self = .Sine
        case SynthSound.keys[5]: self = .TwentySixHundred
        default: self = .Square
        }
    }
}
