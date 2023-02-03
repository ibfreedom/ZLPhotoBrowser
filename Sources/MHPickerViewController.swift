//
//  MHPickerViewController.swift
//  Example
//
//  Created by iferret's on 2023/2/2.
//

import Foundation
import UIKit
import Photos

/// MHPickerViewController
public class MHPickerViewController: NSObject {
    public typealias Element = (asset: PHAsset, urlAsset: AVURLAsset?, image: UIImage, index: Int)
    
    // MARK: 公开属性
    
    /// Options
    public let options: Options
    /// 最大选择数量
    public var maxLimit: Int = 20
    /// 配色方案
    public var hue: MHPickerViewController.Hue = .default()
    
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
    public init(options: Options, maxLimit: Int = 20, completionHandler: @escaping (Result<(elements: [Element], isOriginal: Bool), Error>) -> Void) {
        self.options = options
        self.maxLimit = maxLimit
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
    public func show(onTarget target: UIViewController) {
        // 配置UI
        ZLPhotoUIConfiguration.default().themeColor                             = hue.major
        ZLPhotoUIConfiguration.default().placeholderColor                       = hue.placeholder
        ZLPhotoUIConfiguration.default().navBarColor                            = hue.naviBackground
        ZLPhotoUIConfiguration.default().navTitleColor                          = hue.naviTint
        ZLPhotoUIConfiguration.default().navArrowColor                          = hue.secondary
        ZLPhotoUIConfiguration.default().navTitleBorderColor                    = hue.light
        ZLPhotoUIConfiguration.default().navEmbedTitleViewBgColor               = .clear
        ZLPhotoUIConfiguration.default().navViewBlurEffectOfAlbumList           = nil
        ZLPhotoUIConfiguration.default().albumListBgColor                       = hue.naviBackground
        ZLPhotoUIConfiguration.default().separatorColor                         = hue.separator
        ZLPhotoUIConfiguration.default().albumListTitleColor                    = hue.primary
        ZLPhotoUIConfiguration.default().albumListCountColor                    = hue.secondary
        ZLPhotoUIConfiguration.default().thumbnailBgColor                       = hue.background
        ZLPhotoUIConfiguration.default().shadowColor                            = hue.shadow
        ZLPhotoUIConfiguration.default().borderColor                            = hue.light
        ZLPhotoUIConfiguration.default().embedAlbumListTranslucentColor         = .black.withAlphaComponent(0.4)
        
        ZLPhotoUIConfiguration.default().bottomToolViewBgColor                  = hue.tabbarBackground
        ZLPhotoUIConfiguration.default().bottomViewBlurEffectOfAlbumList        = nil
        ZLPhotoUIConfiguration.default().bottomToolViewBtnNormalTitleColor      = hue.primary
        ZLPhotoUIConfiguration.default().bottomToolViewBtnDisableTitleColor     = hue.placeholder
        ZLPhotoUIConfiguration.default().bottomToolViewDoneBtnNormalTitleColor  = .white
        ZLPhotoUIConfiguration.default().bottomToolViewDoneBtnDisableTitleColor = hue.secondary
        ZLPhotoUIConfiguration.default().bottomToolPlaceholderColor             = hue.secondary
        ZLPhotoUIConfiguration.default().bottomToolViewBtnNormalBgColor         = hue.major
        ZLPhotoUIConfiguration.default().bottomToolViewBtnDisableBgColor        = hue.light
        
        ZLPhotoUIConfiguration.default().navViewBlurEffectOfPreview             = .init(style: .dark)
        ZLPhotoUIConfiguration.default().navBarColorOfPreviewVC                 = .clear
        ZLPhotoUIConfiguration.default().bottomViewBlurEffectOfPreview          = .init(style: .dark)
        ZLPhotoUIConfiguration.default().bottomToolViewBgColorOfPreviewVC       = .clear
        
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
        ZLPhotoConfiguration.default().maxSelectCount           = maxLimit
        ZLPhotoConfiguration.default().allowPreviewPhotos       = options.intersection(.allowsPreview) == .allowsPreview
         
        // show on target
        let obj: ZLPhotoPreviewSheet = .init(results: results)
        obj.selectImageBlock = { (models, original) in
            if models.contains(where: { $0.asset.mediaType == .video }) == true {
                let videos: [ZLResultModel] = models.filter { $0.asset.mediaType == .video }
                ZLPhotoManager.fetchAVAssets(for: videos.map { $0.asset }) { elements in
                    for element in elements {
                        guard let urlAsset = element.avAsset as? AVURLAsset else { continue }
                        models.first(where: { $0.asset.localIdentifier == element.phAsset.localIdentifier })?.urlAsset = urlAsset
                    }
                    // callback
                    let elements: [Element] = models.map { ($0.asset, $0.urlAsset, $0.image, $0.index) }
                    self.completionHandler(.success((elements, original)))
                }
            } else {
                let elements: [Element] = models.map { ($0.asset, $0.urlAsset, $0.image, $0.index) }
                self.completionHandler(.success((elements, original)))
            }
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
