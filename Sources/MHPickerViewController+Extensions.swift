//
//  MHPickerViewController+Extensions.swift
//  Example
//
//  Created by iferret's on 2023/2/2.
//

import Foundation
import UIKit

extension MHPickerViewController {
    
    /// OptionSet
    public struct Options: OptionSet  {
        public var rawValue: Int
        
        /// 构建
        /// - Parameter rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
    
}

extension MHPickerViewController.Options {
    
    /// 默认项
    public static var `default`: Self {
        return [
            .allowsImage,
            .allowsVideo,
            .allowsGIF,
            .allowsTakePhotoInLibrary,
            .allowsCompressImage,
            .allowsBytes,
            .allowsPreview
        ]
    }
    
    /// 仅限图片
    public static var onlyImages: Self {
        return [
            .allowsImage,
            .allowsGIF,
            .allowsTakePhotoInLibrary,
            .allowsCompressImage,
            .allowsBytes,
            .allowsPreview
        ]
    }
    
    /// 仅限视频
    public static var onlyVideos: Self {
        return [
            .allowsVideo,
            .allowsTakePhotoInLibrary,
            .allowsBytes,
            .allowsPreview
        ]
    }
}

extension MHPickerViewController.Options {
    
    /// 允许选择图片
    public static var allowsImage: Self {
        return .init(rawValue:  1 << 1)
    }
    
    /// 允许选择视频
    public static var allowsVideo: Self {
        return .init(rawValue: 1 << 2)
    }
    
    /// 允许选择GIF
    public static var allowsGIF: Self {
        return .init(rawValue: 1 << 3)
    }

    /// 允许拍照
    public static var allowsTakePhotoInLibrary: Self {
        return .init(rawValue: 1 << 4)
    }
    
    /// 允许压缩图片
    public static var allowsCompressImage: Self {
        return .init(rawValue: 1 << 5)
    }
    
    /// 允许资源大小
    public static var allowsBytes: Self {
        return .init(rawValue: 1 << 6)
    }
    
    /// 允许预览
    public static var allowsPreview: Self {
        return .init(rawValue: 1 << 7)
    }
  
}

extension MHPickerViewController {
    
    /// Hue
    public struct Hue {
        public let major: UIColor
        public let primary: UIColor
        public let secondary: UIColor
        public let light: UIColor
        public let background: UIColor
        public let shadow: UIColor
        public let placeholder: UIColor
        public let separator: UIColor
        public let border: UIColor
        public let naviBackground: UIColor
        public let naviTint: UIColor
        public let tabbarBackground: UIColor
    }
}

extension MHPickerViewController.Hue {

    /// MHPickerViewController.Hue
    /// - Returns: `default`
    public static func `default`() -> MHPickerViewController.Hue {
        return .init(major: .major,
                     primary: .primary,
                     secondary: .secondary,
                     light: .light,
                     background: .background,
                     shadow: .shadow,
                     placeholder: .placeholder,
                     separator: .separator,
                     border: .border,
                     naviBackground: .naviBackground,
                     naviTint: .naviTint,
                     tabbarBackground: .tabbarBackground)
    }
}

extension UIColor {
    
    /// UIColor
    fileprivate static var major: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#3D69DB"), dark: .init(hex: "#3D69DB"))
        } else {
            return .init(hex: "#3D69DB")
        }
    }

    /// UIColor
    fileprivate static var separator: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#E6E6E6"), dark: .init(hex: "#313131"))
        } else {
            return .init(hex: "#E6E6E6")
        }
    }

    /// UIColor
    fileprivate static var primary: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#212121"), dark: .init(hex: "#EBE9DF"))
        } else {
            return .init(hex: "#212121")
        }
    }

    /// secondary
    fileprivate static var secondary: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#808080"), dark: .init(hex: "#999A96"))
        } else {
            return .init(hex: "#808080")
        }
    }

    /// UIColor
    fileprivate static var light: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#E2E3E6"), dark: .init(hex: "#66645F"))
        } else {
            return .init(hex: "#E2E3E6")
        }
    }

    /// UIColor
    fileprivate static var background: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#FFFFFF"), dark: .init(hex: "#000000"))
        } else {
            return .init(hex: "#FFFFFF")
        }
    }

    /// shadow
    fileprivate static var shadow: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#B4B4B4"), dark: .init(hex: "#535353"))
        } else {
            return .init(hex: "#B4B4B4")
        }
    }

    /// placeholder
    fileprivate static var placeholder: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#BBBBBB"), dark: .init(hex: "#858688"))
        } else {
            return .init(hex: "#BBBBBB")
        }
    }
    
    /// border
    fileprivate static var border: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#FFFFFF"), dark: .init(hex: "#FFFFFF"))
        } else {
            return .init(hex: "#FFFFFF")
        }
    }
    
    /// UIColor
    fileprivate static var naviBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#FFFFFF"), dark: .init(hex: "#040404"))
        } else {
            return .init(hex: "#FFFFFF")
        }
    }

    /// UIColor
    fileprivate static var naviTint: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#353539"), dark: .init(hex: "#CFD1BD"))
        } else {
            return .init(hex: "#353539")
        }
    }

    /// tabbarBackground
    fileprivate static var tabbarBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#FFFFFF"), dark: .init(hex: "#040404"))
        } else {
            return .init(hex: "#FFFFFF")
        }
    }

    
}
