//// SYMKRoutePlannerView.swift
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

import SygicUIKit
import UIKit


class SYMKRoutePlannerView: UIView {
    
    private let sideMargin: CGFloat = 16
    
    public private(set) weak var mapView: UIView?
    
    public var optionsButton: SYUIActionButton = {
        let button = SYUIActionButton()
        button.iconImage = SYUIIcon.options
        button.style = .plain
        return button
    }()
    
    public var backButton: SYUIActionButton = {
        let button = SYUIActionButton()
        button.style = .secondary
        button.icon = SYUIIcon.close
        return button
    }()
    
    public var routesView: SYUIBubbleView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupMapView(_ mapView: UIView) {
        self.mapView = mapView
        mapView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mapView)
        sendSubviewToBack(mapView)
        mapView.coverWholeSuperview()
    }
    
    public func setupRoutesView(_ view: SYUIBubbleView) {
        guard routesView == nil else { return }
        view.addToView(self, landscapeLayout: SYUIDeviceOrientationUtils.isLandscapeLayout(traitCollection), animated: true, completion: nil)
        routesView = view
    }
    
    private func setupUI() {
        backgroundColor = UIColor.gray
        setupBackButton()
        setupOptionsButton()
    }
    
    private func setupBackButton() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: safeTopAnchor, constant: sideMargin).isActive = true
        backButton.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: sideMargin).isActive = true
    }
    
    private func setupOptionsButton() {
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(optionsButton)
        optionsButton.topAnchor.constraint(equalTo: safeTopAnchor, constant: sideMargin).isActive = true
        optionsButton.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -sideMargin).isActive = true
    }
}
