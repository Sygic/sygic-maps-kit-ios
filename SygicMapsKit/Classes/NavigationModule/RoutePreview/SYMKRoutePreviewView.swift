//// SYMKRoutePreviewView.swift
//
// Copyright (c) 2019 - Sygic a.s.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import SygicUIKit


public class SYMKRoutePreviewView: UIView {
    
    public let stopButton: UIButton = {
        let button = UIButton()
        let bundle = Bundle(for: SYUIIcon.self)
        let image = UIImage(named: "square", in: bundle, compatibleWith: nil)
        button.setImage(image, for: .normal)
        return button
    }()
    public let playButton = UIButton()
    public let speedButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        return button
    }()
    
    private let height: CGFloat = 40
    private let cornerRadius: CGFloat = 18
    
    private class func button() -> UIButton {
        return UIButton()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: height).isActive = true
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
        var blurStyle: UIBlurEffect.Style = .light
        if #available(iOS 13.0, *) {
            blurStyle = .systemThinMaterial
        }
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        blur.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blur)
        blur.coverWholeSuperview()
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stack.spacing = 16
        stack.addArrangedSubview(playButton)
        stack.addArrangedSubview(speedButton)
        stack.addArrangedSubview(stopButton)
        addSubview(stack)
        stack.coverWholeSuperview()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
