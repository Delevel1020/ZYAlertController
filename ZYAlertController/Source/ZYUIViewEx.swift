//
//  UIViewEx.swift
//  ZYAlertController
//
//  Created by Ding on 2023/3/7.
//

import Foundation
import UIKit

public extension UIView {
    
    func addConstraintEdge(view: UIView?, edge: UIEdgeInsets) {
        self.addConstraintAll(view: view, topView: self, leftView: self, bottomView: self, rightView: self, edge: edge)
    }
    
    func addConstraintAll(view: UIView?, topView: UIView?, leftView: UIView?, bottomView: UIView?, rightView: UIView?, edge: UIEdgeInsets) {
        guard let view = view else { return }
        if topView != nil {
            let layoutConstraint = NSLayoutConstraint (item: view, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .top, multiplier: 1, constant: edge.top)
            self.addConstraint(layoutConstraint)
        }
        if bottomView != nil {
            let layoutConstraint = NSLayoutConstraint (item: view, attribute: .bottom, relatedBy: .equal, toItem: bottomView, attribute: .bottom, multiplier: 1, constant: edge.bottom)
            self.addConstraint(layoutConstraint)
        }
        if leftView != nil {
            let layoutConstraint = NSLayoutConstraint (item: view, attribute: .left, relatedBy: .equal, toItem: leftView, attribute: .left, multiplier: 1, constant: edge.left)
            self.addConstraint(layoutConstraint)
        }
        if rightView != nil {
            let layoutConstraint = NSLayoutConstraint (item: view, attribute: .right, relatedBy: .equal, toItem: rightView, attribute: .right, multiplier: 1, constant: edge.right)
            self.addConstraint(layoutConstraint)
        }
    }
    
    @discardableResult
    func addConstraintLeftToRight(leftView: UIView?, rightView: UIView?, constant: Double) -> NSLayoutConstraint? {
        guard let leftView = leftView else { return nil }
        let layoutConstraint = NSLayoutConstraint (item: leftView, attribute: .right, relatedBy: .equal, toItem: rightView, attribute: .left, multiplier: 1, constant: -constant)
        self.addConstraint(layoutConstraint)
        return layoutConstraint
    }
    
    @discardableResult
    func addConstraintTopToBottom(topView: UIView?, bottomView: UIView?, constant: Double) -> NSLayoutConstraint? {
        guard let topView = topView else { return nil }
        let layoutConstraint = NSLayoutConstraint (item: topView, attribute: .bottom, relatedBy: .equal, toItem: bottomView, attribute: .top, multiplier: 1, constant: -constant)
        self.addConstraint(layoutConstraint)
        return layoutConstraint
    }
    
    func addConstraintSize(width: Double, height: Double) {
        if width > 0 {
            let layoutConstraint = NSLayoutConstraint (item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
            self.addConstraint(layoutConstraint)
        }
        if height > 0 {
            let layoutConstraint = NSLayoutConstraint (item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
            self.addConstraint(layoutConstraint)
        }
    }
    
    func addConstraintEquqlSize(view: UIView?, widthView: UIView?, heightView: UIView?) {
        guard let view = view else { return }
        if widthView != nil {
            let layoutConstraint = NSLayoutConstraint (item: view, attribute: .width, relatedBy: .equal, toItem: widthView, attribute: .width, multiplier: 1, constant: 0)
            self.addConstraint(layoutConstraint)
        }
        if heightView != nil {
            let layoutConstraint = NSLayoutConstraint (item: view, attribute: .height, relatedBy: .equal, toItem: heightView, attribute: .height, multiplier: 1, constant: 0)
            self.addConstraint(layoutConstraint)
        }
    }
    
    func addConstraintCenter(xView: UIView?, yView: UIView?) {
        if xView != nil {
            let layoutConstraint = NSLayoutConstraint (item: xView!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            self.addConstraint(layoutConstraint)
        }
        if yView != nil {
            let layoutConstraint = NSLayoutConstraint (item: yView!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            self.addConstraint(layoutConstraint)
        }
    }
    
    @discardableResult
    func addConstraintCenterX(view: UIView?, constant: Double) -> NSLayoutConstraint? {
        if view != nil {
            let layoutConstraint = NSLayoutConstraint (item: view!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: constant)
            self.addConstraint(layoutConstraint)
            return layoutConstraint
        }
        return nil
    }
    
    @discardableResult
    func addConstraintCenterY(view: UIView?, constant: Double) -> NSLayoutConstraint? {
        if view != nil {
            let layoutConstraint = NSLayoutConstraint (item: view!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: constant)
            self.addConstraint(layoutConstraint)
            return layoutConstraint
        }
        return nil
    }
    
    func removeConstraintAttribute(attr: NSLayoutConstraint.Attribute) {
        for constraint in constraints {
            if constraint.firstAttribute == attr {
                self.removeConstraint(constraint)
                break;
            }
        }
    }
    
    func removeConstraintView(view: UIView?, attr: NSLayoutConstraint.Attribute) {
        for constraint in constraints {
            if  let item = constraint.firstItem as? UIView, item == view, constraint.firstAttribute == attr {
                self.removeConstraint(constraint)
                break;
            }
        }
    }
    
    func removeAllConstraint() {
        self.removeConstraints(self.constraints)
    }
}
