//
//  TransitionManager.swift
//  AudioEngine2
//
//  Created by Grant Damron on 10/6/16.
//  Copyright © 2016 Grant Damron. All rights reserved.
//

import UIKit
import CoreGraphics

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    var isPresenting = true
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        

        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        guard let bottomVC = (isPresenting ? fromVC : toVC) as? ViewController else { return }
        let menuVC = isPresenting ? toVC : fromVC
        
        let hide = UserSettings.sharedInstance.hideSettingsTab
        let offLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
        let offRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        let hiddenTab = CGAffineTransform(translationX: -bottomVC.settingsTab.frame.size.width, y: 0)
        
        let fromTranform = isPresenting ? offLeft : CGAffineTransform.identity
        let toTransform = isPresenting ? CGAffineTransform.identity : offLeft
        let tabTransform = isPresenting ? offRight : (hide ? hiddenTab : CGAffineTransform.identity)
        
        menuVC.view.transform = fromTranform
        bottomVC.ignoreTouches = isPresenting
        container.addSubview(bottomVC.view)
        container.addSubview(menuVC.view)
        
        let dur = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: dur, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
                menuVC.view.transform = toTransform
                bottomVC.settingsTab.transform = tabTransform
            }) { (finished) in
                transitionContext.completeTransition(true)
                UIApplication.shared.keyWindow?.addSubview(toVC.view)
        }
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2;
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}
