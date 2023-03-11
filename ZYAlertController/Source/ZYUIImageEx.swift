//
//  UIImageEx.swift
//  ZYAlertController
//
//  Created by Ding on 2023/3/7.
//

import Accelerate
import UIKit

public extension UIImage {
    func zy_applyLightEffect() -> UIImage? {
        return zy_applyBlure(radius: 30, tintColor: UIColor(white: 1.0, alpha: 0.3), delta: 1.8, maskImage: nil)
    }

    func zy_applyExtraLightEffect() -> UIImage? {
        return zy_applyBlure(radius: 20, tintColor: UIColor(white: 0.97, alpha: 0.82), delta: 1.8, maskImage: nil)
    }

    func zy_applyDarkEffect() -> UIImage? {
        return zy_applyBlure(radius: 20, tintColor: UIColor(white: 0.11, alpha: 0.73), delta: 1.8, maskImage: nil)
    }

    // 毛玻璃
    func zy_applyBlureTintEffect(_ color: UIColor?) -> UIImage? {
        guard let color = color else { return nil }
        let effectColorAlpha = 0.6
        var effectColor = color
        let componentCount = color.cgColor.numberOfComponents
        if componentCount == 2 {
            var b: CGFloat = 0
            if color.getWhite(&b, alpha: nil) {
                effectColor = UIColor(white: b, alpha: effectColorAlpha)
            }
        } else {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            if color.getRed(&red, green: &green, blue: &blue, alpha: nil) {
                effectColor = UIColor(red: red, green: green, blue: blue, alpha: effectColorAlpha)
            }
        }
        return zy_applyBlure(radius: 10, tintColor: effectColor, delta: -1.0, maskImage: nil)
    }

    // 毛玻璃
    fileprivate func zy_applyBlure(radius: Double, tintColor: UIColor?, delta: Double, maskImage: UIImage?) -> UIImage? {
        guard size.width > 1, size.height > 1 else { return nil }
        guard let cgImage = cgImage else { return nil }
        if maskImage != nil, maskImage!.cgImage == nil { return nil }

        let width = size.width
        let height = size.height
        let imageRect = CGRect(x: 0, y: 0, width: width, height: height)
        var effectImage = self

        let hasRadiusBlure = radius > Double.ulpOfOne
        let hasDeltaChange = fabs(delta - 1.0) > Double.ulpOfOne

        if hasRadiusBlure, hasDeltaChange {
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            guard let effectInContext = UIGraphicsGetCurrentContext() else { return nil }
            effectInContext.scaleBy(x: 1.0, y: -1.0)
            effectInContext.translateBy(x: 0, y: -height)
            effectInContext.draw(cgImage, in: imageRect)
            var effectInBuffer = createEffectBuffer(effectInContext)

            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            guard let effectOutContext = UIGraphicsGetCurrentContext() else { return nil }
            var effectOutBuffer = createEffectBuffer(effectOutContext)

            if hasRadiusBlure {
                let inputRadius = radius * UIScreen.main.scale
                var resultRadius = UInt32(floor(inputRadius * 3.0 * sqrt(2 * Double.pi) / 4 + 0.5))
                if resultRadius % 2 != 1 {
                    resultRadius += 1
                }
                let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, resultRadius, resultRadius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, resultRadius, resultRadius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, resultRadius, resultRadius, nil, imageEdgeExtendFlags)
            }

            var effectImageBuffersAreSwapped = false

            if hasDeltaChange {
                let floatingPointSaturationMatrix = [
                    0.0722 + 0.9278 * delta, 0.0722 - 0.0722 * delta, 0.0722 - 0.0722 * delta, 0,
                    0.7152 - 0.7152 * delta, 0.7152 + 0.2848 * delta, 0.7152 - 0.7152 * delta, 0,
                    0.2126 - 0.2126 * delta, 0.2126 - 0.2126 * delta, 0.2126 + 0.7873 * delta, 0,
                    0, 0, 0, 1,
                ]
                let divisor: CGFloat = 256
                let matrixSize = floatingPointSaturationMatrix.count
                var saturationMatrix = [Int16](repeating: 0, count: matrixSize)
                for i: Int in 0 ..< matrixSize {
                    saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
                }
                if hasRadiusBlure {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                } else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }
            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            UIGraphicsEndImageContext()

            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            UIGraphicsEndImageContext()
        }

        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let outputContext = UIGraphicsGetCurrentContext() else { return nil }
        outputContext.scaleBy(x: 1.0, y: -1.0)
        outputContext.translateBy(x: 0, y: -height)
        outputContext.draw(cgImage, in: imageRect)
        if hasRadiusBlure {
            outputContext.saveGState()
            if let maskcgImage = maskImage?.cgImage {
                outputContext.clip(to: imageRect, mask: maskcgImage)
            }
            outputContext.draw(effectImage.cgImage!, in: imageRect)
            outputContext.restoreGState()
        }
        if let color = tintColor {
            outputContext.saveGState()
            outputContext.setFillColor(color.cgColor)
            outputContext.fill(imageRect)
            outputContext.restoreGState()
        }
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage
    }

    // 截图
    internal static func zy_snapshotImage(view: UIView?) -> UIImage? {
        guard let view = view else { return nil }
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    // 创建Buffer Image
    fileprivate func createEffectBuffer(_ context: CGContext) -> vImage_Buffer {
        let data = context.data
        let width = vImagePixelCount(context.width)
        let height = vImagePixelCount(context.height)
        let rowBytes = context.bytesPerRow
        return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes)
    }
}
