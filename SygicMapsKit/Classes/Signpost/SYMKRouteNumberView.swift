//// SYMKRouteNumberView.swift
//
// Copyright (c) 2019 Sygic a.s.
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

import SygicUIKit
import SygicMaps
import SwiftSVG


public class SYMKRouteNumberView: UIView {

    private let svgSize: CGFloat = 28.0

    private var shape: SYNumberShapeType? {
        didSet {
            if oldValue?.rawValue == shape?.rawValue {
                return
            }

            if let shape = shape, let url = Bundle(for: SYMKRouteNumberView.self).url(forResource: SYMKRouteNumberView.shapeToSVG(shape: shape), withExtension: "svg") {
                _ = CALayer(SVGURL: url) { [unowned self] svgLayer in
                    self.signLayer = svgLayer
                }
            } else {
                signLayer = nil
            }
        }
    }

    private var signLayer: SVGLayer? {
        didSet {
            oldValue?.removeFromSuperlayer()
            if let signLayer = signLayer {
                layer.insertSublayer(signLayer, below: numberLabel.layer)
            }
        }
    }

    private let numberLabel = SYMKInsetLabel()

    public init() {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.textAlignment = .center
        numberLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        numberLabel.font = SYUIFont.with(SYUIFont.bold, size: 14.0)
        addSubview(numberLabel)
        heightAnchor.constraint(equalToConstant: svgSize).isActive = true
        numberLabel.contentInset = UIEdgeInsets.init(top: 0, left: 6.0, bottom: 0, right: 6.0)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[numberLabel]|", options: [], metrics: nil, views: ["numberLabel": numberLabel]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[numberLabel]|", options: [], metrics: nil, views: ["numberLabel": numberLabel]))
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        if let signLayer = signLayer {
            var scaleFactorX = layer.frame.size.width / signLayer.boundingBox.width
            let scaleFactorY = layer.frame.size.height / signLayer.boundingBox.height

            if shape == .usaShield {
                scaleFactorX *= 1.5
            }

            signLayer.transform = CATransform3DMakeScale(scaleFactorX, scaleFactorY, 1.0)
        }
    }

    public func update(with format: SYRouteNumberFormat?) {
        if let format = format {
            numberLabel.text = format.insideNumber
            numberLabel.textColor = SYMKRouteNumberView.numberColor(from: format.numberColor)
            shape = format.shape
        } else {
            shape = nil
            numberLabel.text = nil
            numberLabel.textColor = nil
        }
    }

    public class func shapeToSVG(shape: SYNumberShapeType) -> String {
        switch shape {
        case .blueShape1: return ""//
        case .greenEShape3: return "are-green-white-border"
        case .greenEShape2: return "hun-green-white-border"
        case .blueNavyShape2: return "hun-blue-white-border"
        case .greenAShape4: return "aus-4-green"
        case .blueShape5: return "aus-2-blue"
        case .blueShape6: return "deu"
        case .redShape5: return "nzl-red-white-border"
        case .redShape6: return "tur"
        case .redShape8: return "che-red-white-border"
        case .redShape9, .redShape10: return "rect-red"
        case .greenEShape6: return "svn"
        case .brownShape7: return "aus-1-brown"
        case .blueRedCanShape: return "can-8"
        case .blackShape11WhiteBorder: return "aus-4-black"
        case .whiteShape12BlueNavyBorder: return "aus-5-white-black-border"//
        case .yellowShape13GreenABorder: return "aus-5-green-yellow-border"//
        case .whiteShape14GreenEBorder: return "can-9"
        case .whiteShape15BlackBorder: return "can-3"
        case .greenEShape16WhiteBorder, .greenEShape18WhiteBorder: return "ita"
        case .whiteShape17BlackBorder, .whiteShape24BlackBorder: return ""//
        case .blueShape17WhiteBorder: return "isr-blue-white-border"
        case .blueShape18BlackBorder: return "vnm"//
        case .yellowShape18BlackBorder: return "mys"
        case .orangeShape19BlackBorder: return ""//
        case .whiteShape20BlackBorder: return "nld-white-black-border"
        case .whiteShape22BlackBorder: return "usa-white-black-border-1"
        case .whiteShape21BlackBorder: return "usa-white-black-border-2"
        case .orangeShape23WhiteBorder: return "hkg-orange-white-border"
        case .whiteShape24BlueMexBorder: return "isr-white-blue-border"
        case .whiteShape24RedBorder: return "isr-white-red-border"
        case .whiteShape24GreenEBorder: return "isr-white-green-border"
        case .redMexShape, .blueMexShape: return"mex"
        case .usaShield: return "usa-blue-red-border"//
        case .greenESauShape1: return ""//
        case .greenESauShape2: return ""//
        case .greenESauShape3: return ""//
        case .whiteRect, .whiteRectBlackBorder: return "rect-white-black-border"
        case .whiteRectGreenEBorder: return "rect-white-green-border"
        case .whiteRectYellowBorder: return "rect-white-yellow-border"
        case .blueRect, .blueNavyRect, .blueRectWhiteBorder, .blueNavyRectWhiteBorder: return "rect-blue"
        case .blueRectBlackBorder: return "rect-blue-black-border"
        case .redRect, .redRectWhiteBorder: return "rect-red"
        case .redRectBlackBorder: return "rect-red-black-border"
        case .brownRect: return "rect-brown"
        case .orangeRect: return "rect-orange"
        case .yellowRect, .yellowRectWhiteBorder: return "rect-yellow"
        case .yellowRectBlackBorder: return "rect-yellow-black-border"
        case .greenERectBlackBorder: return "rect-green-black-border"
        case .greenARect, .greenERect, .greenERectWhiteBorder, .greenARectGreenEBorder, .unknown: return "rect-green"
        }
    }

    public class func numberColor(from shapeColor: SYNumberTextColor) -> UIColor {
        switch shapeColor {
        case .black: return .black
        case .white, .unknown: return .white
        case .greenA, .greenE: return UIColor(argb: 0xff009966)
        case .blue, .blueMex, .blueNavy: return UIColor(argb: 0xff0080ff)
        case .red: return UIColor(argb: 0xffcc0000)
        case .yellow: return UIColor(argb: 0xffefef00)
        case .orange: return UIColor(argb: 0xffffcc00)
        case .brown: return UIColor(argb: 0xff990000)
        }
    }
    
}

class SYMKInsetLabel: UILabel {
    
    var contentInset: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + contentInset.left + contentInset.right, height: size.height + contentInset.top + contentInset.bottom)
    }
    
    override public func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInset))
    }
    
}
