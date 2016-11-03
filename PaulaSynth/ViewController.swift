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
    var touched = [UITouch?](repeating: nil, count: 8)
    var touchStack:[MetaTouch] = []
    var waveform = SynthSound.Square
    var notes = Scale.MinorPentatonic.notes
    var synth = Synthesizer(sound: .Square, isPoly: true)
    let transitionManager = TransitionManager()
    var polyphonyOn = true
    var viewActive = true
    
    let onAlpha: CGFloat = 1.0
    let offAlpha: CGFloat = 0.5
    let animDur: TimeInterval = 0.2
    let animDamp: CGFloat = 0.9
    let animVel: CGFloat = 0.1
    let dismissInterval: TimeInterval = 5.0
    
    @IBOutlet var tiles: [TileView]!
    @IBOutlet weak var settingsTab: UIView!
    
    override var prefersStatusBarHidden: Bool {
        return viewActive
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return viewActive ? .default : .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        for tile in tiles {
            tile.color = Util.randomColor()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewActive = true
        let settings = UserSettings.sharedInstance
        waveform = settings.sound
        synth = Synthesizer(sound: waveform, isPoly: true)
        notes = settings.scale.notes
        polyphonyOn = settings.polyphonyOn
        Synthesizer.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AudioKit.start()
        if UserSettings.sharedInstance.hideSettingsTab {
            dismissSettingsTab(self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        Synthesizer.stop()
        viewActive = false
        let toVC = segue.destination
        toVC.transitioningDelegate = transitionManager
    }
    
    @IBAction func dismissSettingsTab(_ sender: AnyObject) {
        UserSettings.sharedInstance.tabHiddenCount += 1
        UIView.animate(withDuration: animDur, delay: 0, usingSpringWithDamping: animDamp, initialSpringVelocity: animVel, options: .curveEaseOut, animations: {
            self.settingsTab.frame.origin.x = -self.settingsTab.frame.size.width
            }, completion: nil)
    }
    
    @IBAction func showSettingsTab(_ sender: UIScreenEdgePanGestureRecognizer) {
        allNotesOff()
        ignoreTouches = true
        UIView.animate(withDuration: animDur, delay: 0, usingSpringWithDamping: animDamp, initialSpringVelocity: animVel, options: .curveEaseOut, animations: {
            self.settingsTab.frame.origin.x = 0
        }) { done in
            self.ignoreTouches = false
            if UserSettings.sharedInstance.hideSettingsTab {
                Timer.scheduledTimer(timeInterval: self.dismissInterval, target: self, selector: #selector(self.timedDismissSettings(timer:)), userInfo: nil, repeats: false)
            }
        }
    }
    
    @IBAction func unwindToHere(_ segue: UIStoryboardSegue) {
        viewActive = true
        UIView.animate(withDuration: animDur) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func timedDismissSettings(timer: Timer) {
        dismissSettingsTab(self)
    }
    
    func noteOn(_ v: UIView, touch: UITouch) {
        if touched[v.tag] == nil {
            let index = v.tag % notes.count * ( v.tag / notes.count + 1)
            synth.noteOn(note: notes[index])
            touched[v.tag] = touch
            v.alpha = onAlpha
        }
    }
    
    func noteOff(_ v: UIView) {
        if touched[v.tag] != nil {
            let index = v.tag % notes.count * ( v.tag / notes.count + 1)
            synth.noteOff(note: notes[index])
            touched[v.tag] = nil
            v.alpha = offAlpha
        }
    }
    
    func allNotesOff() {
        for tile in tiles {
            noteOff(tile)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!polyphonyOn) {
            allNotesOff()
        }
        for touch in touches {
            let point = touch.location(in: self.view)
            for v in tiles {
                if v.frame.contains(point) {
                    noteOn(v, touch: touch)
                    let mt = MetaTouch(touch: touch, tile: v)
                    touchStack.append(mt)
                    break
                }
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let monoTouch = touchStack.last
        for touch in touches {
            if (!polyphonyOn && touch !== monoTouch?.touch) {
                continue
            }
            var touched: UIView?
            let point = touch.location(in: self.view)
            for v in tiles {
                if v.frame.contains(point) {
                    touched = v
                    break
                }
            }
            
            for i in stride(from: touchStack.count - 1, to: -1, by: -1) {
                if let touched = touched, touchStack[i].touch === touch {
                    noteOff(touchStack[i].tile)
                    noteOn(touched, touch: touch)
                    touchStack[i].tile = touched
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        end(touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        end(touches)
    }
    
    func end(_ touches: Set<UITouch>) {
        for touch in touches {
            for i in stride(from: touchStack.count - 1, to: -1, by: -1) {
                if (touchStack[i].touch === touch) {
                    let mt = touchStack.remove(at: i)
                    noteOff(mt.tile)
                    break
                }
            }
        }
        
        if !polyphonyOn, let monoTouch = touchStack.last {
            noteOn(monoTouch.tile, touch: monoTouch.touch)
        }
    }
}

class MetaTouch {
    var touch: UITouch
    var tile: UIView
    
    init(touch: UITouch, tile: UIView) {
        self.touch = touch
        self.tile = tile
    }
}
