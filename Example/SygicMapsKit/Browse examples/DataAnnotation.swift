//// DataAnnotation.swift
//
// Copyright (c) 2019 - Sygic a.s.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the &quot;Software&quot;), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import SygicUIKit
import SygicMaps
import SygicMapsKit


class DataAnnotation: SYAnnotation {
    
    var data: SYMKPoiDataProtocol
    
    init(data: SYMKPoiDataProtocol) {
        self.data = data
        super.init()
        self.coordinate = data.coordinate
    }
    
}

class DataAnnotationView: SYAnnotationView {
    
    public var firstText: String? {
        set {
            firstLabel.text = newValue
            firstLabel.sizeToFit()
        }
        get {
            return firstLabel.text
        }
    }
    
    public var secondText: String? {
        set {
            secondLabel.text = newValue
            secondLabel.sizeToFit()
        }
        get {
            return secondLabel.text
        }
    }
    
    private let firstLabel = UILabel()
    private let secondLabel = UILabel()
    
    private let stack = UIStackView()
    
    public override init(annotation: SYAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        firstLabel.text = ""
        secondLabel.text = ""
    }
    
    override func draw(_ rect: CGRect) {
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: rect.width, height: rect.height-10), cornerRadius: 8)
        UIColor.white.setFill()
        rectanglePath.fill()
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: rect.width/2 - 10, y: rect.height - 10))
        bezierPath.addLine(to: CGPoint(x: rect.width/2, y: rect.height))
        bezierPath.addLine(to: CGPoint(x: rect.width/2 + 10, y: rect.height - 10))
        UIColor.white.setFill()
        bezierPath.fill()
    }
    
    private func setupUI() {
        frame = CGRect(x: 0, y: 0, width: 160, height: 80)
        backgroundColor = .clear
        
        anchorPoint = CGPoint(x: 0.5, y: 1)
        
        firstLabel.textAlignment = .center
        secondLabel.textAlignment = .center
        firstLabel.font = SYUIFont.with(SYUIFont.semiBold, size: SYUIFontSize.heading)
        secondLabel.font = SYUIFont.with(SYUIFont.semiBold, size: SYUIFontSize.heading)
        
        stack.addArrangedSubview(firstLabel)
        stack.addArrangedSubview(secondLabel)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        
        addSubview(stack)
        
        stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        stack.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18).isActive = true
    }
    
}
