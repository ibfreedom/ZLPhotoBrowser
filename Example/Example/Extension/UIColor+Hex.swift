//
//  UIColor+Hex.swift
//  Example
//
//  Created by long on 2022/7/1.
//

import UIKit

extension UIColor {
    class func color(hexRGB: Int64, alpha: CGFloat = 1.0) -> UIColor {
        let r: Int64 = (hexRGB & 0xFF0000) >> 16
        let g: Int64 = (hexRGB & 0xFF00) >> 8
        let b: Int64 = (hexRGB & 0xFF)
        
        let color = UIColor(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: alpha
        )

        return color
    }
}

extension UIColor {

    /// 构建
    /// - Parameter hex: String
    internal convenience init(hex: String) {
        var hex = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        guard hex.count == 3 || hex.count == 6 else {
            self.init(white: 1.0, alpha: 0.0)
            return
        }
        if hex.count == 3 {
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }
        guard let intCode = Int(hex, radix: 16) else {
            self.init(white: 1.0, alpha: 0.0)
            return
        }
        
        self.init(red: CGFloat((intCode >> 16) & 0xFF) / 255.0,
                  green: CGFloat((intCode >> 8) & 0xFF) / 255.0,
                  blue:  CGFloat((intCode) & 0xFF) / 255.0, alpha: 1.0)
    }
    
    /// 构建
    /// - Parameters:
    ///   - light: UIColor
    ///   - dark: UIColor
    @available(iOS 13.0, *)
    internal convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? dark : light
        }
    }
}
