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
    
    static func start() {
        AudioKit.start()
    }
    
    static func stop() {
        AudioKit.stop()
    }
    
    init(sound: SynthSound, isPoly: Bool) {
        self.sound = sound
        switch sound {
        case .Sawtooth:
            synth = AKOscillatorBank(waveform: AKTable(.sawtooth))
        case .Scream:
            synth = AKFMOscillatorBank(waveform: AKTable(.reverseSawtooth),
                                       carrierMultiplier: 0.9,
                                       modulatingMultiplier: 1.5,
                                       modulationIndex: 1.01,
                                       attackDuration: 0.01,
                                       decayDuration: 0.1,
                                       sustainLevel: 0.55,
                                       releaseDuration: 0.2,
                                       detuningOffset: 0,
                                       detuningMultiplier: 1)
        case .Sine:
            synth = AKOscillatorBank(waveform: AKTable(.sine))
        case .Square:
            synth = AKOscillatorBank(waveform: AKTable(.square))
        case .Triangle:
            synth = AKOscillatorBank(waveform: AKTable(.triangle))
        case .TwentySixHundred:
            synth = AKPWMOscillatorBank(pulseWidth: 0.8,
                                        attackDuration: 0.1,
                                        decayDuration: 0,
                                        sustainLevel: 0.8,
                                        releaseDuration: 0,
                                        detuningOffset: 0,
                                        detuningMultiplier: 1)
        }
        
        AudioKit.output = synth
    }
    
    func noteOn(note: Int) {
        synth.play(noteNumber: note, velocity: sound.velocity)
    }
    
    func noteOff(note: Int) {
        synth.stop(noteNumber: note)
    }
}
