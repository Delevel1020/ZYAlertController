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

// MARK: - Class

public class ZYAlertController: UIViewController {
    public private(set) var alertView: UIView?
    public var backgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4) {
        didSet { backgroundView.backgroundColor = backgroundColor }
    }

    public var backgroundView: UIView = UIView() {
        didSet { didSetBackgroundView() }
    }

    public var backgoundTapDismissEnable: Bool = false {
        didSet { singleTap?.isEnabled = backgoundTapDismissEnable }
    }

    public private(set) var style: ZYAlertControllerStyle = .alert
    public private(set) var animation: ZYAlertTransitionAnimation = .fade
    public private(set) var animationClass: ZYUIAnimationEx.Type = ZYUIAnimationEx.self

    public private(set) var alertStyleEdging: CGFloat = 25 // alert 左右边距
    public private(set) var actionSheetStyleEdging: CGFloat = 0 // actionSheet 左右边距

    // 下面三参数是用来记录 alert的layout
    public private(set) var alertViewOriginY: CGFloat = 0
    public private(set) var alertViewCenterY: CGFloat = 0
    public private(set) var alertViewCenterYConstraint: NSLayoutConstraint?
    
    // 下面三个参数是用来记录 actionsheet的layout
    public private(set) var alertViewBottom: CGFloat = 0
    public var alertViewLastTextViewBottom: CGFloat = 0
    public private(set) var alertViewBottomConstraint: NSLayoutConstraint?

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

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public convenience init(alertView: UIView?,
                            style: ZYAlertControllerStyle = .alert,
                            animation: ZYAlertTransitionAnimation = .fade) {
        self.init()
        self.alertView = alertView
        self.style = style
        self.animation = animation
        configPresent()
    }

    public convenience init(alertView: UIView?,
                            style: ZYAlertControllerStyle = .alert,
                            animationClass: ZYUIAnimationEx.Type) {
        self.init()
        self.alertView = alertView
        self.style = style
        animation = .custom
        self.animationClass = animationClass
        configPresent()
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
        view.backgroundColor = UIColor.clear
        addBackgroundView()
        addSingleTapGesture()
        addStyleView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    fileprivate func configPresent() {
        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
}

// MARK: - Config

extension ZYAlertController {
    fileprivate func addBackgroundView() {
        backgroundView.removeFromSuperview()
        backgroundView.backgroundColor = backgroundColor
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(backgroundView, at: 0)
        view.addConstraintEdge(view: backgroundView, edge: UIEdgeInsets.zero)
    }

    fileprivate func didSetBackgroundView() {
        addBackgroundView()
        backgroundView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 1
        } completion: { _ in
            self.addSingleTapGesture()
        }
    }

    fileprivate func addSingleTapGesture() {
        view.isUserInteractionEnabled = true
        backgroundView.isUserInteractionEnabled = true
        singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapAction))
        singleTap!.isEnabled = backgoundTapDismissEnable
        backgroundView.addGestureRecognizer(singleTap!)
    }

    @objc fileprivate func singleTapAction() {
        dismiss(animated: true, completion: dismissCompleteClosure)
    }

    fileprivate func addStyleView() {
        guard let alertView = alertView else { return }
        alertView.isUserInteractionEnabled = true
        view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        switch style {
        case .alert:
            addAlertView()
        case .actionSheet:
            addActionSheetView()
        }
    }

    fileprivate func addAlertView() {
        view.addConstraintCenter(xView: alertView, yView: nil)
        addStyleSizeView()
        alertViewCenterYConstraint = view.addConstraintCenterY(view: alertView, constant: 0)
        if alertViewOriginY > 0 {
            alertView!.layoutIfNeeded()
            alertViewCenterY = alertViewOriginY - CGRectGetHeight(view.frame) - CGRectGetHeight(alertView!.frame) / 2
            alertViewCenterYConstraint?.constant = alertViewCenterY
        } else {
            alertViewCenterY = 0
        }
    }

    fileprivate func addActionSheetView() {
        alertView!.removeConstraintAttribute(attr: .width)
        alertViewBottom = 0
        view.addConstraintLeft(view: alertView, leftView: view, constant: actionSheetStyleEdging)
        view.addConstraintRight(view: alertView, rightView: view, constant: -actionSheetStyleEdging)
        alertViewBottomConstraint = view.addConstraintBottom(view: alertView, bottomView: view, constant: 0)
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
                alertView!.addConstraintSize(width: CGRectGetWidth(view.frame) - 2 * alertStyleEdging, height: 0)
            }
        } else {
            alertView!.addConstraintSize(width: CGRectGetWidth(alertView!.frame), height: CGRectGetHeight(alertView!.frame))
        }
    }
}

// MARK: - keyboard notification

extension ZYAlertController {
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let alertView = alertView else { return }
        if style == .alert {
            if let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                let alertViewBottomEdge = (view.frame.height - alertView.frame.height) / 2 - alertViewCenterY
                // 获取状态栏高度
                let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
                let differ = keyboardRect.height - alertViewBottomEdge
                // 检查是否需要更新约束
                if alertViewCenterYConstraint?.constant == -differ - statusBarHeight {
                    return
                }
                if differ >= 0 {
                    alertViewCenterYConstraint?.constant = alertViewCenterY - differ - statusBarHeight
                    UIView.animate(withDuration: 0.25) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
        } else if style == .actionSheet {
            if let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                let differ = alertViewBottom - keyboardRect.height + alertViewLastTextViewBottom
                // 检查是否需要更新约束
                if alertViewBottomConstraint?.constant == differ {
                    return
                }
                if differ <= 0 {
                    alertViewBottomConstraint?.constant = differ
                    UIView.animate(withDuration: 0.25) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if style == .alert {
            alertViewCenterYConstraint?.constant = alertViewCenterY
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else if style == .actionSheet {
            alertViewBottomConstraint?.constant = alertViewBottom
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - Blure

extension ZYAlertController {
    public func blureEffectView(view: UIView?) {
        blureEffectViewStyle(view: view, style: .light)
    }

    public func blureEffectViewStyle(view: UIView?, style: ZYAlertBlurEffectStyle) {
        let snapshotImage = UIImage.zy_snapshotImage(view: view)
        let blureImage = self.blureImage(snapshatImage: snapshotImage, style: style)
        backgroundView = UIImageView(image: blureImage)
    }

    public func blureEffectViewColor(view: UIView?, color: UIColor?) {
        let snapshotImage = UIImage.zy_snapshotImage(view: view)
        let blureImage = snapshotImage?.zy_applyBlureTintEffect(color)
        backgroundView = UIImageView(image: blureImage)
    }

    fileprivate func blureImage(snapshatImage: UIImage?, style: ZYAlertBlurEffectStyle) -> UIImage? {
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

// MARK: - Animation

extension ZYAlertController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch animation {
        case .fade:
            return ZYUIAnimationFadeEx(isPresenting: true)
        case .scaleFade:
            return ZYUIAnimationScaleFadeEx(isPresenting: true)
        case .dropTop:
            return ZYUIAnimationDropTopEx(isPresenting: true)
        case .dropDown:
            return ZYUIAnimationDropDownEx(isPresenting: true)
        case .custom:
            return animationClass.init(isPresenting: true, style: style)
        }
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch animation {
        case .fade:
            return ZYUIAnimationFadeEx(isPresenting: false)
        case .scaleFade:
            return ZYUIAnimationScaleFadeEx(isPresenting: false)
        case .dropTop:
            return ZYUIAnimationDropTopEx(isPresenting: false)
        case .dropDown:
            return ZYUIAnimationDropDownEx(isPresenting: false)
        case .custom:
            return animationClass.init(isPresenting: false, style: style)
        }
    }
}
