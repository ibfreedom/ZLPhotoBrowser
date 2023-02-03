//
//  MHPreviewController.swift
//  Example
//
//  Created by iferret's on 2023/2/3.
//

import Foundation
import UIKit
import Photos

public class MHPreviewController: NSObject {
    public typealias Element = MHPickerViewController.Element
    public typealias Hue = MHPickerViewController.Hue
    
    // MARK: 公开属性
    
    /// 最大选择数量
    public var maxLimit: Int = 20
    /// 配色方案
    public var hue: Hue = .default()
    
    // MARK: 私有属性
    
    /// (Result<(elements: [Element], original: Bool), Error>) -> Void
    private let completionHandler: (Result<(elements: [Element], original: Bool), Error>) -> Void
    /// 起始位置
    private let initailIndex: Int
    /// [PHAsset]
    private let elements: [PHAsset]
    
    // MARK: 生命周期
    
    
    /// 构建
    /// - Parameters:
    ///   - elements: [PHAsset]
    ///   - initailIndex: Int
    ///   - maxLimit: Int
    ///   - completionHandler: @escaping (Result<(elements: [Element], original: Bool), Error>) -> Void
    public init(elements: [PHAsset],
                initailIndex: Int = 0,
                maxLimit: Int = 20,
                completionHandler: @escaping (Result<(elements: [Element], original: Bool), Error>) -> Void) {
        self.elements = elements
        self.initailIndex = initailIndex
        self.completionHandler = completionHandler
        super.init()
    }
    
    deinit {
        print(#function, (#file as NSString).lastPathComponent)
    }
}

extension MHPreviewController {
    
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
        ZLPhotoConfiguration.default().allowSelectLivePhoto     = false
        ZLPhotoConfiguration.default().allowEditImage           = false
        ZLPhotoConfiguration.default().allowSelectOriginal      = false
        ZLPhotoConfiguration.default().showSelectedIndex        = false
        ZLPhotoConfiguration.default().showSelectCountOnDoneBtn = false
        ZLPhotoConfiguration.default().compressBytes            = 150 * 1024
        ZLPhotoConfiguration.default().maxSelectCount           = maxLimit
        
        // show on target
        let obj: ZLPhotoPreviewSheet = .init()
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
        obj.previewAssets(sender: target, assets: elements, index: initailIndex, isOriginal: false, selectAll: false, showBottomViewAndSelectBtn: true)
    }
}

