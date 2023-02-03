//
//  MHPreviewController.swift
//  Example
//
//  Created by iferret's on 2023/2/3.
//

import Foundation
import ZLPhotoBrowser
import Photos

class MHPreviewController: ZLImagePreviewController {
    
    // MARK: 私有属性
    
    /// (_ elements: [PHAsset], _ isOriginal: Bool) -> Void
    private let completionHandler: (_ elements: [PHAsset], _ isOriginal: Bool) -> Void

    // MARK: 生命周期
    
    internal init(elements: [PHAsset], initialIndex: Int = 0, completionHandler: @escaping (_ elements: [PHAsset], _ isOriginal: Bool) -> Void) {
        self.completionHandler = completionHandler
        super.init(datas: elements, index: initialIndex, showSelectBtn: true, showBottomView: true, urlType: nil, urlImageLoader: nil)
        
    }
    
}
