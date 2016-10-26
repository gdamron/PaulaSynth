//
//  SettingsViewController.swift
//  AudioEngine2
//
//  Created by Grant Damron on 10/8/16.
//  Copyright © 2016 Grant Damron. All rights reserved.
//

import UIKit

enum PickerType {
    case Scale, Sound
}

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var pickerType = PickerType.Scale
    var selectedScale = Scale.MinorPentatonic.rawValue
    var selectedSound = SynthSound.Square.name
    
    @IBOutlet var tiles: [UIView]!
    @IBOutlet weak var pickerWrapper: UIView!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var scaleButton: UIButton!
    @IBOutlet weak var scaleLabel: UILabel!
    @IBOutlet weak var lowNoteLabel: UILabel!
    @IBOutlet weak var lowNoteSlider: UISlider!
    @IBOutlet weak var polyphonySwitch: UISwitch!
    @IBOutlet weak var polyphonyLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    var isUIEnabled = true {
        didSet {
            soundButton.isUserInteractionEnabled = isUIEnabled
            scaleButton.isUserInteractionEnabled = isUIEnabled
            lowNoteSlider.isUserInteractionEnabled = isUIEnabled
            polyphonySwitch.isUserInteractionEnabled = isUIEnabled
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    @IBAction func chooseSound(_ button: UIButton) {
        pickerType = .Sound
        picker.selectRow(SynthSound.keys.index(of: selectedSound)!, inComponent: 0, animated: false)
        picker.reloadAllComponents()
        showPicker()
    }
    
    @IBAction func chooseScale(_ button: UIButton) {
        pickerType = .Scale
        picker.selectRow(Scale.list.index(of: selectedScale)!, inComponent: 0, animated: false)
        picker.reloadAllComponents()
        showPicker()
    }
    
    @IBAction func lowNoteSliderChanged(_ slider: UISlider) {
        let lowNote = Int(slider.value)
        UserSettings.sharedInstance.lowNote = lowNote
        lowNoteLabel.text = noteName(forInt: lowNote)
    }
    
    @IBAction func polyphonySwitched(_ swtch: UISwitch) {
        let isOn = swtch.isOn
        UserSettings.sharedInstance.polyphonyOn = isOn
        polyphonyLabel.text = isOn ? "On" : "Off"
    }
    
    @IBAction func selectedPickerValue(_ button: UIButton) {
        if pickerType == .Scale {
            scaleLabel.text = selectedScale
            UserSettings.sharedInstance.scale = Scale(rawValue: selectedScale)!
        } else {
            soundLabel.text = selectedSound
            UserSettings.sharedInstance.sound = SynthSound(key: selectedSound)
        }
        
        dismissPicker()
    }
    
    @IBAction func cancelPickerView(_ button: UIButton) {
        dismissPicker()
    }
    
    @IBAction func mainViewTapped(_ tap: UIGestureRecognizer) {
        let point = tap.location(in: view)
        let yThresh = view.frame.height - pickerWrapper.frame.height
        if !pickerWrapper.isHidden && point.y < yThresh {
            dismissPicker()
        }
    }
    
    // MARK: UI Helper Methods
    
    func refreshUI() {
        for tile in tiles {
            tile.backgroundColor = Util.randomColor()
        }
        
        let settings = UserSettings.sharedInstance
        scaleLabel.text = settings.scale.rawValue
        selectedScale = settings.scale.rawValue
        soundLabel.text = settings.sound.name
        selectedSound = settings.sound.name
        lowNoteLabel.text = noteName(forInt: settings.lowNote)
        lowNoteSlider.value = Float(CGFloat(settings.lowNote))
        polyphonyLabel.text = settings.polyphonyOn ? "On" : "Off"
        polyphonySwitch.isOn = settings.polyphonyOn
    }
    
    func noteName(forInt note: Int) -> String {
        let remainder = note % 12
        let octave = note / 12 - 1
        var name = "C"
        
        switch remainder {
        case 0: name = "C"
        case 1: name = "C#"
        case 2: name = "D"
        case 3: name = "Eb"
        case 4: name = "E"
        case 5: name = "F"
        case 6: name = "F#"
        case 7: name = "G"
        case 8: name = "G#"
        case 9: name = "A"
        case 10: name = "Bb"
        case 11: name = "B"
        default: name = "C"
        }
        
        name += "\(octave)"
        
        return name
    }
    
    // MARK: Picker View Methods
    
    func showPicker() {
        pickerWrapper.frame.origin.y = view.frame.size.height
        pickerWrapper.isHidden = false
        isUIEnabled = false
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: { 
            self.pickerWrapper.frame.origin.y = self.view.frame.size.height - self.pickerWrapper.frame.size.height
            })
    }
    
    func dismissPicker() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: { 
            self.pickerWrapper.frame.origin.y = self.view.frame.size.height
            }) { (finished) in
                self.pickerWrapper.isHidden = true
                self.isUIEnabled = true
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerType == .Scale {
            return Scale.list.count
        }
        
        return SynthSound.keys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerType == .Scale {
            return Scale.list[row]
        }
        return SynthSound.keys[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerType == .Scale {
            selectedScale = Scale.list[row]
        } else {
            selectedSound = SynthSound.keys[row]
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

}
