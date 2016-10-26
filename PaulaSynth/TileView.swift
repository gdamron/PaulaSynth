//
//  TileView.swift
//  PaulaSynth
//
//  Created by Grant Damron on 10/21/16.
//  Copyright © 2016 Grant Damron. All rights reserved.
//

import UIKit

@IBDesignable
class TileView: UIView {
    @IBInspectable
    var color: UIColor = UIColor.clear  {
        didSet {
            tile?.backgroundColor = color
        }
    }
    @IBInspectable
    var trailing: CGFloat = 0.0 {
        didSet {
            trailingMargin?.constant = trailing
        }
    }
    @IBInspectable
    var top: CGFloat = 0.0 {
        didSet {
            topMargin?.constant = top
        }
    }
    @IBInspectable
    var bottom: CGFloat = 0.0 {
        didSet {
            bottomMargin?.constant = bottom
        }
    }
    @IBInspectable
    var leading: CGFloat = 0.0 {
        didSet {
            leadingMargin?.constant = leading
        }
    }
    @IBOutlet var view: UIView!
    @IBOutlet weak var tile: UIView?
    @IBOutlet weak var trailingMargin: NSLayoutConstraint?
    @IBOutlet weak var topMargin: NSLayoutConstraint?
    @IBOutlet weak var bottomMargin: NSLayoutConstraint?
    @IBOutlet weak var leadingMargin: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TileView", bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        updateConstraintsIfNeeded()
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
}
