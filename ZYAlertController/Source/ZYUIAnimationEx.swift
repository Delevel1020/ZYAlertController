//
//  UIAnimation_TYBase.swift
//  ZYAlertController
//
//  Created by Ding on 2023/3/7.
//

import Foundation
import UIKit

open class ZYUIAnimationEx: NSObject, UIViewControllerAnimatedTransitioning {
    private(set) var isPresenting: Bool = false
    private(set) var style: ZYAlertControllerStyle = .alert

    required public init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
    
    required public init(isPresenting: Bool, style: ZYAlertControllerStyle) {
        self.isPresenting = isPresenting
        self.style = style
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            self.presentAnimatedTransition(transition: transitionContext)
        } else {
            self.dimissAnimatedTransition(transition: transitionContext)
        }
    }
    
    open func presentAnimatedTransition(transition: UIViewControllerContextTransitioning) {
        
    }
    
    open func dimissAnimatedTransition(transition: UIViewControllerContextTransitioning) {
        
    }
}


public class ZYUIAnimationFadeEx: ZYUIAnimationEx {
    public override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if self.isPresenting {
            return 0.45
        }
        return 0.25
    }
    
    public override func presentAnimatedTransition(transition: UIViewControllerContextTransitioning) {
        guard let alertController = transition.viewController(forKey: UITransitionContextViewControllerKey.to) as? ZYAlertController else {
            transition.completeTransition(true)
            return
        }
        alertController.backgroundView.alpha = 0.0
        switch alertController.style {
        case .alert:
            alertController.alertView?.alpha = 0.0
            alertController.alertView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        case .actionSheet:
            let y: CGFloat = CGRectGetHeight(alertController.alertView?.frame ?? CGRectZero)
            alertController.alertView?.transform = CGAffineTransform(translationX: 0, y: y)
        }
        
        let containerView: UIView = transition.containerView
        containerView.addSubview(alertController.view)
        
        let completionDuration = 0.2
        
        UIView.animate(withDuration: self.transitionDuration(using: transition) - completionDuration) {
            alertController.backgroundView.alpha = 1.0
            switch alertController.style {
            case .alert:
                alertController.alertView?.alpha = 1.0
                alertController.alertView?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            case .actionSheet:
                alertController.alertView?.transform = CGAffineTransform(translationX: 0, y: -10)
            }
        } completion: { finished in
            UIView.animate(withDuration: completionDuration) {
                alertController.alertView?.transform = CGAffineTransform.identity
            } completion: { finished in
                transition.completeTransition(true)
            }
        }
    }
    
    public override func dimissAnimatedTransition(transition: UIViewControllerContextTransitioning) {
        guard let alertController = transition.viewController(forKey: UITransitionContextViewControllerKey.from) as? ZYAlertController else {
            transition.completeTransition(true)
            return
        }
        UIView.animate(withDuration: self.transitionDuration(using: transition)) {
            alertController.backgroundView.alpha = 0.0;
            switch alertController.style {
            case .alert:
                alertController.alertView?.alpha = 0.0
                alertController.alertView?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            case .actionSheet:
                let y: CGFloat = CGRectGetHeight(alertController.alertView?.frame ?? CGRectZero)
                alertController.alertView?.transform = CGAffineTransform(translationX: 0, y: y)
            }
        } completion: { finished in
            transition.completeTransition(true)
        }
    }
}


public class ZYUIAnimationScaleFadeEx: ZYUIAnimationEx {
    public override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public override func presentAnimatedTransition(transition: UIViewControllerContextTransitioning) {
        guard let alertController = transition.viewController(forKey: UITransitionContextViewControllerKey.to) as? ZYAlertController else {
            transition.completeTransition(true)
            return
        }
        alertController.backgroundView.alpha = 0.0
        switch alertController.style {
        case .alert:
            alertController.alertView?.alpha = 0.0
            alertController.alertView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        case .actionSheet:
            let y: CGFloat = CGRectGetHeight(alertController.alertView?.frame ?? CGRectZero)
            alertController.alertView?.transform = CGAffineTransform(translationX: 0, y: y)
        }
        
        let containerView: UIView = transition.containerView
        containerView.addSubview(alertController.view)
        
        UIView.animate(withDuration: self.transitionDuration(using: transition)) {
            alertController.backgroundView.alpha = 1.0
            switch alertController.style {
            case .alert:
                alertController.alertView?.alpha = 1.0
                alertController.alertView?.transform = CGAffineTransform.identity
            case .actionSheet:
                alertController.alertView?.transform = CGAffineTransform.identity
            }
        } completion: { finished in
            transition.completeTransition(true)
        }
    }
    
    public override func dimissAnimatedTransition(transition: UIViewControllerContextTransitioning) {
        guard let alertController = transition.viewController(forKey: UITransitionContextViewControllerKey.from) as? ZYAlertController else {
            transition.completeTransition(true)
            return
        }
        UIView.animate(withDuration: self.transitionDuration(using: transition)) {
            alertController.backgroundView.alpha = 0.0;
            switch alertController.style {
            case .alert:
                alertController.alertView?.alpha = 0.0
                alertController.alertView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            case .actionSheet:
                let y: CGFloat = CGRectGetHeight(alertController.alertView?.frame ?? CGRectZero)
                alertController.alertView?.transform = CGAffineTransform(translationX: 0, y: y)
            }
        } completion: { finished in
            transition.completeTransition(true)
        }
    }
}


public class ZYUIAnimationDropDownEx: ZYUIAnimationEx {
    public override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if self.isPresenting {
            return 0.5
        }
        return 0.25
    }
    
    public override func presentAnimatedTransition(transition: UIViewControllerContextTransitioning) {
        guard let alertController = transition.viewController(forKey: UITransitionContextViewControllerKey.to) as? ZYAlertController else {
            transition.completeTransition(true)
            return
        }
        alertController.backgroundView.alpha = 0.0
        switch alertController.style {
        case .alert:
            let y: CGFloat = CGRectGetMaxY(alertController.alertView?.frame ?? CGRectZero)
            alertController.alertView?.transform = CGAffineTransform(translationX: 0, y: -y)
        case .actionSheet:
            #if DEBUG
            print("don't support ActionSheet style!")
            #endif
        }
        
        let containerView: UIView = transition.containerView
        containerView.addSubview(alertController.view)
        
        UIView.animate(withDuration: self.transitionDuration(using: transition), delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.5) {
            alertController.backgroundView.alpha = 1.0
            alertController.alertView?.transform = CGAffineTransform.identity
        } completion: { finished in
            transition.completeTransition(true)
        }
    }
    
    public override func dimissAnimatedTransition(transition: UIViewControllerContextTransitioning) {
        guard let alertController = transition.viewController(forKey: UITransitionContextViewControllerKey.from) as? ZYAlertController else {
            transition.completeTransition(true)
            return
        }
        UIView.animate(withDuration: self.transitionDuration(using: transition)) {
            alertController.backgroundView.alpha = 0.0;
            switch alertController.style {
            case .alert:
                alertController.alertView?.alpha = 0.0
                alertController.alertView?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            case .actionSheet:
                #if DEBUG
                    print("don't support ActionSheet style!")
                #endif
            }
        } completion: { finished in
            transition.completeTransition(true)
        }
    }
}


class ZYUIAnimationDropTopEx: ZYUIAnimationEx {
    public override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if self.isPresenting {
            return 0.5
        }
        return 0.25
    }
    
    public override func presentAnimatedTransition(transition: UIViewControllerContextTransitioning) {
        guard let alertController = transition.viewController(forKey: UITransitionContextViewControllerKey.to) as? ZYAlertController else {
            transition.completeTransition(true)
            return
        }
        alertController.backgroundView.alpha = 0.0
        switch alertController.style {
        case .alert:
            let y: CGFloat = CGRectGetMaxY(alertController.alertView?.frame ?? UIScreen.main.bounds)
            alertController.alertView?.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height * 2 - y)
        case .actionSheet:
            #if DEBUG
            print("don't support ActionSheet style!")
            #endif
        }
        
        let containerView: UIView = transition.containerView
        containerView.addSubview(alertController.view)
        
        UIView.animate(withDuration: self.transitionDuration(using: transition), delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.5) {
            alertController.backgroundView.alpha = 1.0
            alertController.alertView?.transform = CGAffineTransform.identity
        } completion: { finished in
            transition.completeTransition(true)
        }
    }
    
    public override func dimissAnimatedTransition(transition: UIViewControllerContextTransitioning) {
        guard let alertController = transition.viewController(forKey: UITransitionContextViewControllerKey.from) as? ZYAlertController else {
            transition.completeTransition(true)
            return
        }
        UIView.animate(withDuration: self.transitionDuration(using: transition)) {
            alertController.backgroundView.alpha = 0.0;
            switch alertController.style {
            case .alert:
                alertController.alertView?.alpha = 0.0
                alertController.alertView?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            case .actionSheet:
                #if DEBUG
                    print("don't support ActionSheet style!")
                #endif
            }
        } completion: { finished in
            transition.completeTransition(true)
        }
    }
}
