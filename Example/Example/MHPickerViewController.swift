//
//  MHPickerViewController.swift
//  Example
//
//  Created by iferret's on 2023/2/2.
//

import Foundation
import ZLPhotoBrowser
import UIKit
import Photos

/// MHPickerViewController
class MHPickerViewController: NSObject {
    typealias Element = (asset: PHAsset, image: UIImage, index: Int)
    
    // MARK: 公开属性
    
    /// Options
    internal let options: Options
    
    // MARK: 私有属性
    
    /// (Result<(elements: [Element], isOriginal: Bool), Error>) -> Void
    private let completionHandler: (Result<(elements: [Element], isOriginal: Bool), Error>) -> Void
    /// [ZLPhotoModel]
    private lazy var results: [ZLResultModel] = []
    
    // MARK: 生命周期
    
    
    /// 构建
    /// - Parameters:
    ///   - options: Options
    ///   - completionHandler: (Result<(elements: [Element], isOriginal: Bool), Error>) -> Void
    internal init(options: Options, completionHandler: @escaping (Result<(elements: [Element], isOriginal: Bool), Error>) -> Void) {
        self.options = options
        self.completionHandler = completionHandler
        super.init()
    }
    
    deinit {
        print(#function, (#file as NSString).lastPathComponent)
    }
}

extension MHPickerViewController {
    
    /// show on target
    /// - Parameter target: UIViewController
    internal func show(onTarget target: UIViewController) {
        // 配置UI
        ZLPhotoUIConfiguration.default().themeColor                         = .major
        ZLPhotoUIConfiguration.default().placeholderColor                   = .placeholder
        ZLPhotoUIConfiguration.default().navBarColor                        = .naviBackground
        ZLPhotoUIConfiguration.default().navTitleColor                      = .naviTint
        ZLPhotoUIConfiguration.default().navArrowColor                      = .secondary
        ZLPhotoUIConfiguration.default().navTitleBorderColor                = .light
        ZLPhotoUIConfiguration.default().navEmbedTitleViewBgColor           = .clear
        ZLPhotoUIConfiguration.default().navViewBlurEffectOfAlbumList       = nil
        ZLPhotoUIConfiguration.default().albumListBgColor                   = .naviBackground
        ZLPhotoUIConfiguration.default().separatorColor                     = .separator
        ZLPhotoUIConfiguration.default().albumListTitleColor                = .primary
        ZLPhotoUIConfiguration.default().albumListCountColor                = .secondary
        ZLPhotoUIConfiguration.default().thumbnailBgColor                   = .background
        ZLPhotoUIConfiguration.default().shadowColor                        = .shadow
        ZLPhotoUIConfiguration.default().borderColor                        = .light
        ZLPhotoUIConfiguration.default().embedAlbumListTranslucentColor     = .black.withAlphaComponent(0.4)
        
        ZLPhotoUIConfiguration.default().bottomToolViewBgColor              = .tabbarBackground
        ZLPhotoUIConfiguration.default().bottomViewBlurEffectOfAlbumList    = nil
        ZLPhotoUIConfiguration.default().bottomToolViewBtnNormalTitleColor  = .primary
        ZLPhotoUIConfiguration.default().bottomToolViewBtnDisableTitleColor = .placeholder
        ZLPhotoUIConfiguration.default().bottomToolViewDoneBtnNormalTitleColor = .white
        ZLPhotoUIConfiguration.default().bottomToolViewDoneBtnDisableTitleColor = .secondary
        ZLPhotoUIConfiguration.default().bottomToolPlaceholderColor = .secondary
        ZLPhotoUIConfiguration.default().bottomToolViewBtnNormalBgColor = .major
        ZLPhotoUIConfiguration.default().bottomToolViewBtnDisableBgColor = .light
        if #available(iOS 13.0, *) {
            ZLPhotoUIConfiguration.default().hudStyle = UITraitCollection.current.userInterfaceStyle == .dark ? .darkBlur : .lightBlur
        } else {
            ZLPhotoUIConfiguration.default().hudStyle = .lightBlur
        }
        
        
        // 配置参数
        ZLPhotoConfiguration.default().allowSelectImage         = options.intersection(.allowsImage) == .allowsImage
        ZLPhotoConfiguration.default().allowSelectVideo         = options.intersection(.allowsVideo) == .allowsVideo
        ZLPhotoConfiguration.default().allowSelectGif           = options.intersection(.allowsGIF) == .allowsGIF
        ZLPhotoConfiguration.default().allowSelectLivePhoto     = false
        ZLPhotoConfiguration.default().allowTakePhotoInLibrary  = options.intersection(.allowsTakePhotoInLibrary) == .allowsTakePhotoInLibrary
        ZLPhotoConfiguration.default().allowEditImage           = false
        ZLPhotoConfiguration.default().allowSelectOriginal      = false
        ZLPhotoConfiguration.default().allowBytes               = options.intersection(.allowsBytes) == .allowsBytes
        ZLPhotoConfiguration.default().allowCompressImage       = options.intersection(.allowsCompressImage) == .allowsCompressImage
        ZLPhotoConfiguration.default().showSelectedIndex        = false
        ZLPhotoConfiguration.default().showSelectCountOnDoneBtn = false
        ZLPhotoConfiguration.default().compressBytes            = 150 * 1024
        
        // show on target
        let obj: ZLPhotoPreviewSheet = .init(results: results)
        obj.selectImageBlock = { (models, isOriginal) in
            let elements: [Element] = models.map { ($0.asset, $0.image, $0.index) }
            self.completionHandler(.success((elements, isOriginal)))
        }
        obj.selectImageRequestErrorBlock = {(assets, _) in
            let error: NSError = .init(domain: "MHPickerViewController",
                                       code: 1001,
                                       userInfo: [NSLocalizedDescriptionKey: "媒体资源获取失败 \(assets)"])
            self.completionHandler(.failure(error))
        }
        obj.showPhotoLibrary(sender: target)
    }
}


extension UIColor {
    
    /// UIColor
    internal static var major: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#3D69DB"), dark: .init(hex: "#3D69DB"))
        } else {
            return .init(hex: "#3D69DB")
        }
    }
    
    /// UIColor
    internal static var naviBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#FFFFFF"), dark: .init(hex: "#040404"))
        } else {
            return .init(hex: "#FFFFFF")
        }
    }
    
    /// UIColor
    internal static var naviTint: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#353539"), dark: .init(hex: "#CFD1BD"))
        } else {
            return .init(hex: "#353539")
        }
    }
    
    /// UIColor
    internal static var separator: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#E6E6E6"), dark: .init(hex: "#313131"))
        } else {
            return .init(hex: "#E6E6E6")
        }
    }
    
    /// UIColor
    internal static var primary: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#212121"), dark: .init(hex: "#EBE9DF"))
        } else {
            return .init(hex: "#212121")
        }
    }
    
    /// secondary
    internal static var secondary: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#808080"), dark: .init(hex: "#999A96"))
        } else {
            return .init(hex: "#808080")
        }
    }
    
    /// UIColor
    internal static var light: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#E2E3E6"), dark: .init(hex: "#66645F"))
        } else {
            return .init(hex: "#E2E3E6")
        }
    }
    
    /// UIColor
    internal static var background: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#FFFFFF"), dark: .init(hex: "#000000"))
        } else {
            return .init(hex: "#FFFFFF")
        }
    }
    
    /// shadow
    internal static var shadow: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#B4B4B4"), dark: .init(hex: "#535353"))
        } else {
            return .init(hex: "#B4B4B4")
        }
    }
    
    /// placeholder
    internal static var placeholder: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#BBBBBB"), dark: .init(hex: "#858688"))
        } else {
            return .init(hex: "#BBBBBB")
        }
    }
    
    internal static var tabbarBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#FFFFFF"), dark: .init(hex: "#040404"))
        } else {
            return .init(hex: "#FFFFFF")
        }
    }
    
    internal static var border: UIColor {
        if #available(iOS 13.0, *) {
            return .init(light: .init(hex: "#FFFFFF"), dark: .init(hex: "#FFFFFF"))
        } else {
            return .init(hex: "#FFFFFF")
        }
    }
    
}
