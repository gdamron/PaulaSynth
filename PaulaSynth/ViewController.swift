//
//  ViewController.swift
//  AudioEngine2
//
//  Created by Grant Damron on 2/16/15.
//  Copyright (c) 2015 Grant Damron. All rights reserved.
//

import UIKit
import AVFoundation
import AudioKit

class ViewController: UIViewController {
    var ignoreTouches = false
    let onAlpha: CGFloat = 1.0
    let offAlpha: CGFloat = 0.75
    var keys = [Bool](repeating: false, count: 8)
    var waveform = SynthSound.Square
    var notes = Scale.MinorPentatonic.notes
    var synth = Synthesizer(sound: .Square, isPoly: true)
    let transitionManager = TransitionManager()
    var polyphonyOn = true
    
    @IBOutlet var tiles: [UIView]!
    @IBOutlet weak var settingsTab: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        for tile in tiles {
            tile.backgroundColor = Util.randomColor()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let settings = UserSettings.sharedInstance
        waveform = settings.sound
        synth = Synthesizer(sound: waveform, isPoly: true)
        notes = settings.scale.notes
        polyphonyOn = settings.polyphonyOn
        Synthesizer.start()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        Synthesizer.stop()
        let toVC = segue.destination
        toVC.transitioningDelegate = transitionManager
    }
    
    @IBAction func dismissSettingsTab(_ sender: AnyObject) {
        UserSettings.sharedInstance.tabHiddenCount += 1
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.settingsTab.frame.origin.x = -self.settingsTab.frame.size.width
            }, completion: nil)
    }
    
    @IBAction func showSettingsTab(_ sender: UIScreenEdgePanGestureRecognizer) {
        allNotesOff()
        ignoreTouches = true
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.settingsTab.frame.origin.x = 0
        }) { done in
            self.ignoreTouches = false
        }
    }
    
    @IBAction func unwindToHere(_ segue: UIStoryboardSegue) {}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AudioKit.start()
        if UserSettings.sharedInstance.hideSettingsTab {
            dismissSettingsTab(self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func noteOn(_ v: UIView) {
        if !polyphonyOn {
            allNotesOff()
        }
        
        if !keys[v.tag] {
            synth.noteOn(note: notes[v.tag])
            keys[v.tag] = true
            v.alpha = onAlpha
        }
    }
    
    func noteOff(_ v: UIView) {
        if keys[v.tag] {
            synth.noteOff(note: notes[v.tag])
            keys[v.tag] = false
            v.alpha = offAlpha
        }
    }
    
    func allNotesOff() {
        for tile in tiles {
            noteOff(tile)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        update(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        update(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        end(touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        end(touches)
    }
    
    func printTouches(_ touches: Set<UITouch>, prefix: String) {
        
        let touchedViews = tiles.filter {v in
            for touch in touches {
                let point = touch.location(in: self.view)
                return v.frame.contains(point)
            }
            return false
        }
        
        for v in touchedViews {
            print("[\(prefix)] in view \(v.tag)")
        }
    }
    
    func update(_ touches: Set<UITouch>) {
        if (ignoreTouches) { return }
        
        let touchedViews = tiles.filter {v in
            for touch in touches {
                let point = touch.location(in: self.view)
                return v.frame.contains(point)
            }
            return false
        }
        
        let untouchedViews = tiles.filter {v in
            for touch in touches {
                let point = touch.location(in: self.view)
                return !v.frame.contains(point)
            }
            return true
        }
        
        for v in touchedViews {
            noteOn(v)
        }
        
        for v in untouchedViews {
            noteOff(v)
        }
    }
    
    func end(_ touches: Set<UITouch>) {
        let untouchedViews = tiles.filter {v in
            for touch in touches {
                let point = touch.location(in: self.view)
                return v.frame.contains(point)
            }
            return false
        }
        
        for v in untouchedViews {
            noteOff(v)
        }
    }
}

