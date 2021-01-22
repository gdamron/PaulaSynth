//
//  Synthesizer.swift
//  AudioEngine2
//
//  Created by Grant Damron on 10/4/16.
//  Copyright © 2016 Grant Damron. All rights reserved.
//

import UIKit
import AudioKit
class Synthesizer: NSObject {
    
    fileprivate var synth: AKPolyphonicNode!
    fileprivate var sound = SynthSound.Square
    
    static func start() throws {
        try AKManager.start()
    }
    
    static func stop() throws {
        try AKManager.stop()
    }
    
    init(sound: SynthSound, isPoly: Bool) {
        self.sound = sound
        switch sound {
        case .Sawtooth:
            synth = AKOscillatorBank(waveform: AKTable(.sawtooth))
        case .FM:
            synth = AKFMOscillatorBank(waveform: AKTable(.sine),
                                       carrierMultiplier: 1,
                                       modulatingMultiplier: 0.75,
                                       modulationIndex: 20,
                                       attackDuration: 0.001,
                                       decayDuration: 1.5,
                                       sustainLevel: 0.6,
                                       releaseDuration: 0.25,
                                       pitchBend: 0,
                                       vibratoDepth: 0,
                                       vibratoRate: 0)
        case .Sine:
            synth = AKOscillatorBank(waveform: AKTable(.sine))
        case .Square:
            synth = AKOscillatorBank(waveform: AKTable(.square))
        case .Triangle:
            synth = AKOscillatorBank(waveform: AKTable(.triangle))
        case .TwentySixHundred:
            synth = AKPWMOscillatorBank(pulseWidth: 0.8,
                                        attackDuration: 0.001,
                                        decayDuration: 0.75,
                                        sustainLevel: 0.8,
                                        releaseDuration: 0.2,
                                        pitchBend: 0,
                                        vibratoDepth: 0,
                                        vibratoRate: 0)
        }
        
        AKManager.output = synth
    }
    
    func noteOn(note: UInt8) {
        synth.play(noteNumber: note, velocity: sound.velocity)
    }
    
    func noteOff(note: UInt8) {
        synth.stop(noteNumber: note)
    }
}
