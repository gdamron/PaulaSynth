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
        case .FM:
            synth = AKFMOscillatorBank(waveform: AKTable(.sine),
                                       carrierMultiplier: 1,
                                       modulatingMultiplier: 0.75,
                                       modulationIndex: 20,
                                       attackDuration: 0.001,
                                       decayDuration: 1.5,
                                       sustainLevel: 0.6,
                                       releaseDuration: 0.25,
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
                                        attackDuration: 0.001,
                                        decayDuration: 0.75,
                                        sustainLevel: 0.8,
                                        releaseDuration: 0.2,
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
