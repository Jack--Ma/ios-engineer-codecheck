//
//  Toast.swift
//  iOSEngineerCodeCheck
//
//  Created by jackma on 2023/5/29.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit

let kToastDefaultDisplayInterval: Double = 2.5

extension Toast {
    private static var lastToast: Toast?
    
    public static func show(_ text: String, inView parentView: UIView?) {
        guard !text.isEmpty, parentView != nil else {
            return
        }
        lastToast?.dismiss(false)
        let toast = Toast(text, parentView)
        toast.show()
        lastToast = toast
    }
}

class Toast: UIView {
    
    lazy var contentView: UIView! = {
        var view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 2.0
        return view
    }()
    
    lazy var textLabel: UILabel! = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.preferredMaxLayoutWidth = 200
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private var text: String?
    private weak var parentView: UIView?
    
    init(_ text: String, _ parentView: UIView?) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.text = text
        self.parentView = parentView
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(contentView)
        addSubview(textLabel)
        textLabel.text = text
    }
    
    private func show() {
        guard let parentView = parentView else { return }
        parentView.addSubview(self)
        
        frame = parentView.frame
        textLabel.sizeToFit()
        contentView.frame = CGRectInset(textLabel.frame, -10, -10)
        contentView.center = CGPoint(x: self.center.x, y: self.center.y-100)
        textLabel.center = contentView.center
        self.showAnimation()
    }
    
    private func showAnimation() {
        contentView.alpha = 0.0
        textLabel.alpha = 0.0
        UIView.animate(withDuration: 0.15) {
            self.contentView.alpha = 1.0
            self.textLabel.alpha = 1.0
        } completion: { finished in
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(self.dismiss), with: true, afterDelay: kToastDefaultDisplayInterval)
        }
    }
    
    @objc func dismiss(_ animation: Bool) {
        UIView.animate(withDuration: animation ? 0.15 : 0.0) {
            self.contentView.alpha = 0.0
            self.textLabel.alpha = 0.0
        } completion: { finished in
            self.parentView = nil
            self.removeFromSuperview()
        }
    }
}
