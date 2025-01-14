//
//  UIViewEx.swift
//  ZYAlertController
//
//  Created by Ding on 2023/3/7.
//

import Foundation
import UIKit

internal extension UIView {
    func addConstraintEdge(view: UIView?, edge: UIEdgeInsets) {
        addConstraintAll(view: view, topView: self, leftView: self, bottomView: self, rightView: self, edge: edge)
    }

    func addConstraintAll(view: UIView?, topView: UIView?, leftView: UIView?, bottomView: UIView?, rightView: UIView?, edge: UIEdgeInsets) {
        guard let view = view else { return }
        if topView != nil {
            let layoutConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .top, multiplier: 1, constant: edge.top)
            addConstraint(layoutConstraint)
        }
        if bottomView != nil {
            let layoutConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: bottomView, attribute: .bottom, multiplier: 1, constant: edge.bottom)
            addConstraint(layoutConstraint)
        }
        if leftView != nil {
            let layoutConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: leftView, attribute: .leading, multiplier: 1, constant: edge.left)
            addConstraint(layoutConstraint)
        }
        if rightView != nil {
            let layoutConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: rightView, attribute: .trailing, multiplier: 1, constant: edge.right)
            addConstraint(layoutConstraint)
        }
    }
    
    @discardableResult
    func addConstraintLeft(view: UIView?, leftView: UIView?, constant: Double) -> NSLayoutConstraint? {
        guard let view = view else { return nil }
        if leftView != nil {
            let layoutConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: leftView, attribute: .leading, multiplier: 1, constant: constant)
            addConstraint(layoutConstraint)
            return layoutConstraint
        }
        return nil
    }
    
    @discardableResult
    func addConstraintRight(view: UIView?, rightView: UIView?, constant: Double) -> NSLayoutConstraint? {
        guard let view = view else { return nil }
        if rightView != nil {
            let layoutConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: rightView, attribute: .trailing, multiplier: 1, constant: constant)
            addConstraint(layoutConstraint)
            return layoutConstraint
        }
        return nil
    }
    
    @discardableResult
    func addConstraintTop(view: UIView?, topView: UIView?, constant: Double) -> NSLayoutConstraint? {
        guard let view = view else { return nil }
        if topView != nil {
            let layoutConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .top, multiplier: 1, constant: constant)
            addConstraint(layoutConstraint)
            return layoutConstraint
        }
        return nil
    }
    
    @discardableResult
    func addConstraintBottom(view: UIView?, bottomView: UIView?, constant: Double) -> NSLayoutConstraint? {
        guard let view = view else { return nil }
        if bottomView != nil {
            let layoutConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: bottomView, attribute: .bottom, multiplier: 1, constant: constant)
            addConstraint(layoutConstraint)
            return layoutConstraint
        }
        return nil
    }

    @discardableResult
    func addConstraintLeftToRight(leftView: UIView?, rightView: UIView?, constant: Double) -> NSLayoutConstraint? {
        guard let leftView = leftView else { return nil }
        let layoutConstraint = NSLayoutConstraint(item: leftView, attribute: .trailing, relatedBy: .equal, toItem: rightView, attribute: .leading, multiplier: 1, constant: -constant)
        addConstraint(layoutConstraint)
        return layoutConstraint
    }

    @discardableResult
    func addConstraintTopToBottom(topView: UIView?, bottomView: UIView?, constant: Double) -> NSLayoutConstraint? {
        guard let topView = topView else { return nil }
        let layoutConstraint = NSLayoutConstraint(item: topView, attribute: .bottom, relatedBy: .equal, toItem: bottomView, attribute: .top, multiplier: 1, constant: -constant)
        addConstraint(layoutConstraint)
        return layoutConstraint
    }

    func addConstraintSize(width: Double, height: Double) {
        if width > 0 {
            let layoutConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
            addConstraint(layoutConstraint)
        }
        if height > 0 {
            let layoutConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
            addConstraint(layoutConstraint)
        }
    }

    func addConstraintEquqlSize(view: UIView?, widthView: UIView?, heightView: UIView?) {
        guard let view = view else { return }
        if widthView != nil {
            let layoutConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: widthView, attribute: .width, multiplier: 1, constant: 0)
            addConstraint(layoutConstraint)
        }
        if heightView != nil {
            let layoutConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: heightView, attribute: .height, multiplier: 1, constant: 0)
            addConstraint(layoutConstraint)
        }
    }

    func addConstraintCenter(xView: UIView?, yView: UIView?) {
        if xView != nil {
            let layoutConstraint = NSLayoutConstraint(item: xView!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            addConstraint(layoutConstraint)
        }
        if yView != nil {
            let layoutConstraint = NSLayoutConstraint(item: yView!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            addConstraint(layoutConstraint)
        }
    }

    @discardableResult
    func addConstraintCenterX(view: UIView?, constant: Double) -> NSLayoutConstraint? {
        if view != nil {
            let layoutConstraint = NSLayoutConstraint(item: view!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: constant)
            addConstraint(layoutConstraint)
            return layoutConstraint
        }
        return nil
    }

    @discardableResult
    func addConstraintCenterY(view: UIView?, constant: Double) -> NSLayoutConstraint? {
        if view != nil {
            let layoutConstraint = NSLayoutConstraint(item: view!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: constant)
            addConstraint(layoutConstraint)
            return layoutConstraint
        }
        return nil
    }

    func removeConstraintAttribute(attr: NSLayoutConstraint.Attribute) {
        for constraint in constraints {
            if constraint.firstAttribute == attr {
                removeConstraint(constraint)
                break
            }
        }
    }

    func removeConstraintView(view: UIView?, attr: NSLayoutConstraint.Attribute) {
        for constraint in constraints {
            if let item = constraint.firstItem as? UIView, item == view, constraint.firstAttribute == attr {
                removeConstraint(constraint)
                break
            }
        }
    }

    func removeAllConstraint() {
        removeConstraints(constraints)
    }
}
