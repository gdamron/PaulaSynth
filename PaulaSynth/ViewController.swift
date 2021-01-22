//
//  ViewController.swift
//  AudioEngine2
//
//  Created by Grant Damron on 2/16/15.
//  Copyright (c) 2015 Grant Damron. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var ignoreTouches = false
    var touchStack:[MetaTouch] = []
    let tileInterface = TileInterface()
    let transitionManager = TransitionManager()
    var polyphonyOn = true
    var viewActive = true
    
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
        tileInterface.start(tiles: tiles)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserSettings.sharedInstance.hideSettingsTab {
            dismissSettingsTab(self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        do {
            try Synthesizer.stop()
        } catch let e {
            print(e)
        }
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
        tileInterface.allNotesOff()
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
        refresh()
        UIView.animate(withDuration: animDur) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    @objc func timedDismissSettings(timer: Timer) {
        dismissSettingsTab(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!polyphonyOn) {
            tileInterface.allNotesOff()
        }
        for touch in touches {
            let point = touch.location(in: self.view)
            for v in tiles {
                if v.frame.contains(point) {
                    tileInterface.noteOn(v.tag)
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
                    tileInterface.noteOff(touchStack[i].tile.tag)
                    tileInterface.noteOn(touched.tag)
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
                    tileInterface.noteOff(mt.tile.tag)
                    break
                }
            }
        }
        
        if !polyphonyOn, let monoTouch = touchStack.last {
            tileInterface.noteOn(monoTouch.tile.tag)
        }
    }
    
    func refresh() {
        viewActive = true
        let settings = UserSettings.sharedInstance
        tileInterface.reset(
            sound: settings.sound,
            scale: settings.scale.notes
        )
        polyphonyOn = settings.polyphonyOn
        
        do {
            try Synthesizer.start()
        } catch let e {
            print(e)
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
