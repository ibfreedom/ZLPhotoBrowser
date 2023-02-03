//
//  ZLAlbumListCell.swift
//  ZLPhotoBrowser
//
//  Created by long on 2020/8/19.
//
//  Copyright (c) 2020 Long Zhang <495181165@qq.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

class ZLAlbumListCell: UITableViewCell {
    
    private lazy var coverImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        if ZLPhotoUIConfiguration.default().cellCornerRadio > 0 {
            view.layer.masksToBounds = true
            view.layer.cornerRadius = ZLPhotoUIConfiguration.default().cellCornerRadio
            view.layer.borderWidth = 0.5
            view.layer.borderColor = UIColor.zl.borderColor.cgColor
        }
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zl.font(ofSize: 16)
        label.textColor = .zl.albumListTitleColor
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .zl.font(ofSize: 13)
        label.textColor = .zl.albumListCountColor
        return label
    }()
    
    private var imageIdentifier: String?
    
    private var model: ZLAlbumListModel!
    
    private var style: ZLPhotoBrowserStyle = .embedAlbumList
    
    /// checkmark
    internal var checkmark: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// traitCollectionDidChange
    /// - Parameter previousTraitCollection: UITraitCollection
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if ZLPhotoUIConfiguration.default().cellCornerRadio > 0 {
            coverImageView.layer.borderColor = UIColor.zl.borderColor.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageViewX: CGFloat
        if style == .embedAlbumList {
            imageViewX = 0
        } else {
            imageViewX = 12
        }
        
        coverImageView.frame = CGRect(x: imageViewX, y: 0.0, width: bounds.height * 0.9, height: bounds.height * 0.9)
        coverImageView.center.y = contentView.center.y
        if let m = model {
            let titleW = min(
                bounds.width / 3 * 2,
                m.title.zl.boundingRect(
                    font: .zl.font(ofSize: 17),
                    limitSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30)
                ).width
            )
            titleLabel.frame = CGRect(x: coverImageView.frame.maxX + 10, y: (bounds.height - 30) / 2, width: titleW, height: 30)
            
            let countSize = ("(" + String(model.count) + ")").zl
                .boundingRect(
                    font: .zl.font(ofSize: 16),
                    limitSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30)
                )
            countLabel.frame = CGRect(x: titleLabel.frame.maxX, y: (bounds.height - 30) / 2, width: countSize.width, height: 30)
        }
    }
    
    func setupUI() {
        backgroundColor = .zl.albumListBgColor
        selectionStyle = .none
        
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
    }
    
    func configureCell(model: ZLAlbumListModel, style: ZLPhotoBrowserStyle) {
        self.model = model
        self.style = style
        
        titleLabel.text = self.model.title
        countLabel.text = "(" + String(self.model.count) + ")"
        
        if style == .embedAlbumList {
            accessoryType = checkmark == true ? .checkmark : .none
            tintColor = .zl.themeColor
        } else {
            accessoryType = .disclosureIndicator
        }
        
        imageIdentifier = self.model.headImageAsset?.localIdentifier
        if let asset = self.model.headImageAsset {
            let w = bounds.height * 2.5
            ZLPhotoManager.fetchImage(for: asset, size: CGSize(width: w, height: w)) { [weak self] image, _ in
                if self?.imageIdentifier == self?.model.headImageAsset?.localIdentifier {
                    self?.coverImageView.image = image ?? .zl.getImage("zl_defaultphoto")
                }
            }
        }
    }
    
}
