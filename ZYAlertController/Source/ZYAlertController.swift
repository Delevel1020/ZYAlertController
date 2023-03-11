//
//  ZYAlertController.swift
//  ZYAlertController
//
//  Created by Ding on 2023/3/7.
//

import Foundation
import UIKit

public typealias ZYAlertControllerLifeClosure = (_ alertView: UIView?) -> Void
public typealias ZYAlertControllerDismissClosure = () -> Void

public enum ZYAlertControllerStyle {
    case alert
    case actionSheet
}

public enum ZYAlertTransitionAnimation {
    case fade
    case scaleFade
    case dropDown
    case dropTop
    case custom
}

public enum ZYAlertBlurEffectStyle {
    case light
    case extraLight
    case darkEffect
}


//MARK: - Class
public class ZYAlertController: UIViewController {
    public private(set) var alertView: UIView?
    public var backgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4) {
        didSet { self.backgroundView.backgroundColor = backgroundColor }
    }
    public var backgroundView: UIView = UIView() {
        didSet { self.didSetBackgroundView() }
    }
    public var backgoundTapDismissEnable: Bool = false {
        didSet { self.singleTap?.isEnabled = backgoundTapDismissEnable }
    }

    public private(set) var style: ZYAlertControllerStyle = .alert
    public private(set) var animation: ZYAlertTransitionAnimation = .fade
    public private(set) var animationClass: ZYUIAnimationEx.Type = ZYUIAnimationEx.self
    
    public private(set) var alertStyleEdging: CGFloat = 25 //alert 左右边距
    public private(set) var actionSheetStyleEdging: CGFloat = 0 //actionSheet 左右边距
    
    public private(set) var alertViewOriginY: CGFloat = 0
    public private(set) var alertViewCenterY: CGFloat = 0
    public private(set) var alertViewCenterYConstraint: NSLayoutConstraint?

    public private(set) var singleTap: UITapGestureRecognizer?
        
    public var viewWillShowClosure: ZYAlertControllerLifeClosure? = .none
    public var viewDidShowClosure: ZYAlertControllerLifeClosure? = .none
    public var viewWillHideClosure: ZYAlertControllerLifeClosure? = .none
    public var viewDidHideClosure: ZYAlertControllerLifeClosure? = .none
    public var dismissCompleteClosure: ZYAlertControllerDismissClosure? = .none
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(alertView: ZYAlertView?,
         style: ZYAlertControllerStyle = .alert,
         animation: ZYAlertTransitionAnimation = .fade) {
        self.init()
        self.alertView = alertView
        self.style = style
        self.animation = animation
        self.configPresent()
    }
    
    convenience init(alertView: ZYAlertView?,
         style: ZYAlertControllerStyle = .alert,
         animationClass: ZYUIAnimationEx.Type) {
        self.init()
        self.alertView = alertView
        self.style = style
        self.animation = .custom
        self.animationClass = animationClass
        self.configPresent()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        guard let viewWillShowClosure = viewWillShowClosure else { return }
        viewWillShowClosure(alertView)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        guard let viewDidShowClosure = viewDidShowClosure else { return }
        viewDidShowClosure(alertView)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        guard let viewWillHideClosure = viewWillHideClosure else { return }
        viewWillHideClosure(alertView)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        guard let viewDidHideClosure = viewDidHideClosure else { return }
        viewDidHideClosure(alertView)
    }
    
    public override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clear
        self.addBackgroundView()
        self.addSingleTapGesture()
        self.addStyleView()
        if style == .alert {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    fileprivate func configPresent() {
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
}

//MARK: - Config
extension ZYAlertController {
    fileprivate func addBackgroundView() {
        self.backgroundView.removeFromSuperview()
        self.backgroundView.backgroundColor = self.backgroundColor
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(self.backgroundView, at: 0)
        self.view.addConstraintEdge(view: self.backgroundView, edge: UIEdgeInsets.zero)
    }
    
    fileprivate func didSetBackgroundView() {
        self.addBackgroundView()
        self.backgroundView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 1
        } completion: { finished in
            self.addSingleTapGesture()
            self.addStyleView()
        }
    }
    
    fileprivate func addSingleTapGesture() {
        self.view.isUserInteractionEnabled = true;
        self.backgroundView.isUserInteractionEnabled = true;
        self.singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapAction))
        self.singleTap!.isEnabled = self.backgoundTapDismissEnable;
        self.backgroundView.addGestureRecognizer(self.singleTap!)
    }
    
    @objc fileprivate func singleTapAction() {
        self.dismiss(animated: true, completion: self.dismissCompleteClosure);
    }
    
    fileprivate func addStyleView() {
        guard let alertView = alertView else { return }
        alertView.isUserInteractionEnabled = true
        self.view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        switch style {
        case .alert:
            self.addAlertView()
        case .actionSheet:
            self.addActionSheetView()
        }
    }
    
    fileprivate func addAlertView() {
        self.view.addConstraintCenter(xView: alertView, yView: nil)
        self.addStyleSizeView()
        alertViewCenterYConstraint = self.view.addConstraintCenterY(view: alertView, constant: 0)
        if alertViewOriginY > 0 {
            alertView!.layoutIfNeeded()
            alertViewCenterY = alertViewOriginY - CGRectGetHeight(self.view.frame) - CGRectGetHeight(alertView!.frame)/2
            alertViewCenterYConstraint?.constant = alertViewCenterY
        } else {
            alertViewCenterY = 0
        }
    }
    
    fileprivate func addActionSheetView() {
        alertView!.removeConstraintAttribute(attr: .width)
        self.view.addConstraintAll(view: alertView, topView: nil, leftView: self.view, bottomView: self.view, rightView: self.view, edge: UIEdgeInsets(top: 0, left: actionSheetStyleEdging, bottom: 0, right: -actionSheetStyleEdging))
        if CGRectGetHeight(alertView!.frame) > 0 {
            alertView!.addConstraintSize(width: 0, height: CGRectGetHeight(alertView!.frame))
        }
    }
    
    fileprivate func addStyleSizeView() {
        if CGSizeEqualToSize(alertView!.frame.size, CGSize.zero) {
            var findAlertViewWidthConstraint = false
            for constraint in alertView!.constraints {
                if constraint.firstAttribute == .width {
                    findAlertViewWidthConstraint = true
                }
            }
            if findAlertViewWidthConstraint == false {
                alertView!.addConstraintSize(width: CGRectGetWidth(self.view.frame) - 2 * alertStyleEdging, height: 0)
            }
        } else {
            alertView!.addConstraintSize(width: CGRectGetWidth(alertView!.frame), height: CGRectGetHeight(alertView!.frame))
        }
    }
}

//MARK: - keyboard notification
extension ZYAlertController {
    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        guard let alertView = alertView else { return }
        guard let userInfo = notification.userInfo as? NSDictionary else { return }
        let value = userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey)
        let keyboardRect = (value as AnyObject).cgRectValue ?? CGRect.zero
        
        let alertViewBottomEdge = CGRectGetHeight(self.view.frame) - CGRectGetHeight(alertView.frame)/2 - alertViewCenterY
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let differ = CGRectGetHeight(keyboardRect) - alertViewBottomEdge
        if alertViewCenterYConstraint?.constant == (CGFloat(-differ) - statusBarHeight) {
            return
        }
        if differ > 0 {
            alertViewCenterYConstraint?.constant = alertViewCenterY - differ - statusBarHeight
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        alertViewCenterYConstraint?.constant = alertViewCenterY
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}



//MARK: -Blure
extension ZYAlertController {
    func blureEffectView(view: UIView?) {
        self.blureEffectViewStyle(view: view, style: .light)
    }
    
    func blureEffectViewStyle(view: UIView?, style: ZYAlertBlurEffectStyle) {
        let snapshotImage = UIImage.zy_snapshotImage(view: view)
        let blureImage = self.blureImage(snapshatImage: snapshotImage, style: style)
        self.backgroundView = UIImageView(image: blureImage)
    }
    
    func blureEffectViewColor(view: UIView?, color: UIColor?) {
        let snapshotImage = UIImage.zy_snapshotImage(view: view)
        let blureImage = snapshotImage?.zy_applyBlureTintEffect(color)
        self.backgroundView = UIImageView(image: blureImage)
    }

    func blureImage(snapshatImage: UIImage?, style: ZYAlertBlurEffectStyle) -> UIImage? {
        guard let snapshatImage = snapshatImage else { return nil }
        switch style {
        case .light:
            return snapshatImage.zy_applyLightEffect()
        case .extraLight:
            return snapshatImage.zy_applyExtraLightEffect()
        case .darkEffect:
            return snapshatImage.zy_applyDarkEffect()
        }
    }
}

//MARK: -Animation
extension ZYAlertController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch self.animation {
        case .fade:
            return ZYUIAnimationFadeEx(isPresenting: true)
        case .scaleFade:
            return ZYUIAnimationScaleFadeEx(isPresenting: true)
        case .dropTop:
            return ZYUIAnimationDropTopEx(isPresenting: true)
        case .dropDown:
            return ZYUIAnimationDropDownEx(isPresenting: true)
        case .custom:
            return self.animationClass.init(isPresenting: true, style: self.style)
        }
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch self.animation {
        case .fade:
            return ZYUIAnimationFadeEx(isPresenting: false)
        case .scaleFade:
            return ZYUIAnimationScaleFadeEx(isPresenting: false)
        case .dropTop:
            return ZYUIAnimationDropTopEx(isPresenting: false)
        case .dropDown:
            return ZYUIAnimationDropDownEx(isPresenting: false)
        case .custom:
            return self.animationClass.init(isPresenting: false, style: self.style)
        }
    }
}
