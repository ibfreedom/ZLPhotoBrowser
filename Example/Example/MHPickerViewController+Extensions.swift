//
//  MHPickerViewController+Extensions.swift
//  Example
//
//  Created by iferret's on 2023/2/2.
//

import Foundation

extension MHPickerViewController {
    
    /// OptionSet
    struct Options: OptionSet  {
        internal var rawValue: Int
    }
    
}

extension MHPickerViewController.Options {
    
    /// 默认项
    internal static var `default`: Self {
        return [.allowsImage, .allowsVideo, .allowsGIF, .allowsTakePhotoInLibrary, .allowsCompressImage, allowsBytes]
    }
}

extension MHPickerViewController.Options {
    
    /// 允许选择图片
    internal static var allowsImage: Self {
        return .init(rawValue:  1 << 1)
    }
    
    /// 允许选择视频
    internal static var allowsVideo: Self {
        return .init(rawValue: 1 << 2)
    }
    
    /// 允许选择GIF
    internal static var allowsGIF: Self {
        return .init(rawValue: 1 << 3)
    }

    /// 允许拍照
    internal static var allowsTakePhotoInLibrary: Self {
        return .init(rawValue: 1 << 4)
    }
    
    /// 允许压缩图片
    internal static var allowsCompressImage: Self {
        return .init(rawValue: 1 << 5)
    }
    
    /// 允许资源大小
    internal static var allowsBytes: Self {
        return .init(rawValue: 1 << 5)
    }
  
}
