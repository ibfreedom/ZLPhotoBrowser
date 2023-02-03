//
//  ZLProgressHUD.swift
//  ZLPhotoBrowser
//
//  Created by long on 2020/8/17.
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

public class ZLProgressHUD: UIView {
    @objc public enum HUDStyle: Int {
        case light
        case lightBlur
        case dark
        case darkBlur
        
        /// UIColor
        var bgColor: UIColor {
            switch self {
            case .light:        return .white
            case .dark:         return .darkGray
            case .lightBlur:    return .clear
            case .darkBlur:     return .clear
            }
        }
        
        /// UIImage
        var icon: UIImage? {
            switch self {
            case .light, .lightBlur:    return .zl.getImage("zl_loading_dark")?.zl.withTint(color: .zl.themeColor)
            case .dark, .darkBlur:      return .zl.getImage("zl_loading_light")?.zl.withTint(color: .zl.themeColor)
            }
        }
        
        /// UIColor
        var textColor: UIColor {
            switch self {
            case .light, .lightBlur:    return .darkText
            case .dark, .darkBlur:      return .lightText
            }
        }
        
        /// UIBlurEffect.Style
        var blurEffectStyle: UIBlurEffect.Style? {
            switch self {
            case .light, .dark: return nil
            case .lightBlur:    return .extraLight
            case .darkBlur:     return .dark
            }
        }
    }
    
    private let style: ZLProgressHUD.HUDStyle
    
    private lazy var loadingView = UIImageView(image: style.icon)
    
    private var timer: Timer?
    
    var timeoutBlock: (() -> Void)?
    
    deinit {
        zl_debugPrint("ZLProgressHUD deinit")
        cleanTimer()
    }
    
    @objc public init(style: ZLProgressHUD.HUDStyle) {
        self.style = style
        super.init(frame: UIScreen.main.bounds)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0))
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = style.bgColor
        view.clipsToBounds = true
        view.center = center
        
        if let effectStyle = style.blurEffectStyle {
            let effect = UIBlurEffect(style: effectStyle)
            let effectView = UIVisualEffectView(effect: effect)
            effectView.frame = view.bounds
            view.addSubview(effectView)
        }
        
        loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0)
        loadingView.center.x = view.bounds.width * 0.5
        loadingView.center.y = view.bounds.height * 0.5 - 12.0
        view.addSubview(loadingView)
        
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: 30.0))
        label.center.x = view.bounds.width * 0.5
        label.frame.origin.y = loadingView.frame.maxY + 8.0
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = style.textColor
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.text = localLanguageTextValue(.hudLoading)
        
        view.addSubview(label)
        
        addSubview(view)
    }
    
    private func startAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.duration = 0.8
        animation.repeatCount = .infinity
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        loadingView.layer.add(animation, forKey: nil)
    }
    
    @objc public func show(timeout: TimeInterval = 100) {
        ZLMainAsync {
            self.startAnimation()
            UIApplication.shared.keyWindow?.addSubview(self)
        }
        if timeout > 0 {
            cleanTimer()
            timer = Timer.scheduledTimer(timeInterval: timeout, target: ZLWeakProxy(target: self), selector: #selector(timeout(_:)), userInfo: nil, repeats: false)
            RunLoop.current.add(timer!, forMode: .default)
        }
    }
    
    @objc public func hide() {
        cleanTimer()
        ZLMainAsync {
            self.loadingView.layer.removeAllAnimations()
            self.removeFromSuperview()
        }
    }
    
    @objc func timeout(_ timer: Timer) {
        timeoutBlock?()
        hide()
    }
    
    func cleanTimer() {
        timer?.invalidate()
        timer = nil
    }
}
