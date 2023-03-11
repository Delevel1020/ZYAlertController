//
//  ZYExtension.swift
//  ZYAlertController
//
//  Created by Ding on 2023/3/10.
//

import Foundation
import UIKit

public extension UIFont {
    static func pingFangRegular(_ ofSize: CGFloat) -> UIFont {
        return pingFangText(ofSize, W: "Regular")
    }
    static func pingFangMedium(_ ofSize: CGFloat) -> UIFont {
        return pingFangText(ofSize, W: "Medium")
    }
    static func pingFangBold(_ ofSize: CGFloat) -> UIFont {
        return pingFangText(ofSize, W: "Semibold")
    }
    /// 文字字体
    private static func pingFangText(_ ofSize: CGFloat, W Weight: String) -> UIFont {
        let fontName = "PingFangSC-" + Weight
        return appCustomFont(fontName: fontName, ofSize: ofSize)
    }
    /// 自定义的字体
    private static func appCustomFont(fontName: String, ofSize: CGFloat) -> UIFont {
        if let font = UIFont(name: fontName, size: ofSize) {
            return font
        } else {
            return UIFont.systemFont(ofSize: ofSize)
        }
    }
}

public extension UIColor {
    /// 十六进制 Int 颜色的使用(方法) Int 颜色 0x999999
    static func hexIntColor(hexInt: Int, alpha: CGFloat = 1) -> UIColor {
        let redComponet: Float = Float(hexInt >> 16)
        let greenComponent: Float = Float((hexInt & 0xFF00) >> 8)
        let blueComponent: Float = Float(hexInt & 0xFF)
        return UIColor(red: CGFloat(redComponet / 255.0), green: CGFloat(greenComponent / 255.0), blue: CGFloat(blueComponent / 255.0), alpha: alpha)
    }
}


public extension String {
    /// 字符串是否为空
    var isBlank: Bool {
        let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
        return trimmed.isEmpty
    }
    /// 计算字符串的Height
    func heightFont(_ font: UIFont?, width: CGFloat) -> CGFloat {
        var textSize: CGSize?
        if let font {
            textSize = (self as NSString).boundingRect(
                with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [NSAttributedString.Key.font: font],
                context: nil).size
        }
        guard textSize == nil else {
            return ceil(textSize!.height) + 1 // 计算精度不够准确  需要 ceil
        }
        return CGFloat.zero
    }
}

public extension UIColor {
    /// 颜色转变为图片
    var toImage: UIImage? {
        let size: CGSize = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.set()
        UIRectFill(CGRectMake(0, 0, size.width, size.height))
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image
    }
}

extension UIView {
    /// 获取当前view的viewcontroller
    var currentVC: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
