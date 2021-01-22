//
//  TileInterface.swift
//  PaulaSynth
//
//  Created by Grant Damron on 1/23/20.
//  Copyright © 2020 Grant Damron. All rights reserved.
//

import UIKit

class TileInterface
{
    var tiles: [TileView] = []
    var touched = [Bool](repeating: false, count: 8)
    var synth = Synthesizer(sound: .Square, isPoly: true)
    var notes = Scale.Blues.notes
    var waveform = SynthSound.Square
    
    let onAlpha: CGFloat = 1.0
    let offAlpha: CGFloat = 0.5
    
    var count: Int {
        return tiles.count
    }
    
    func start(tiles: [TileView]) {
        self.tiles = tiles.sorted(by: { (lhs, rhs) -> Bool in
            lhs.tag < rhs.tag
        })
        for tile in tiles {
            tile.color = Util.randomColor()
        }
    }
    
    func noteOn(_ i: Int) {
        if !touched[i] {
            let note = indexToMidi(index: i)
            synth.noteOn(note: note)
            touched[i] = true
            tiles[i].alpha = onAlpha
        }
    }
    
    func noteOff(_ i: Int) {
        if touched[i] {
            let note = indexToMidi(index: i)
            synth.noteOff(note: note)
            touched[i] = false
            tiles[i].alpha = offAlpha
        }
    }
    
    func allNotesOff() {
        for i in 0..<tiles.count {
            noteOff(i)
        }
    }
    
    func reset(sound: SynthSound, scale: [UInt8]) {
        waveform = sound
        notes = scale
        synth = Synthesizer(sound: waveform, isPoly: true)
        touched = [Bool](repeating: false, count: tiles.count)
    }
    
    func indexToMidi(index: Int) -> UInt8 {
        let i = index % notes.count
        let octave : UInt8 = 12 * UInt8(index / notes.count)
        let note = notes[i] + octave
        return note
    }
}
