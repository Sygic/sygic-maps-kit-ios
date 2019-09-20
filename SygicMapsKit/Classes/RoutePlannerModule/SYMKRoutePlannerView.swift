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
    
    public var navigateButton: SYUIActionButton = {
        let button = SYUIActionButton()
        button.title = "Start navigation"
        button.icon = SYUIIcon.directions
        return button
    }()
    
    public var previewButton: SYUIActionButton = {
        let button = SYUIActionButton()
        button.title = "Play route preview"
        button.icon = SYUIIcon.vehicle
        button.style = .secondary
        return button
    }()
    
    public var backButton: SYUIActionButton = {
        let button = SYUIActionButton()
        button.style = .secondary
        button.icon = SYUIIcon.close
        return button
    }()
    
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
    
    public func setupBackButton() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: safeTopAnchor, constant: sideMargin).isActive = true
        backButton.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: sideMargin).isActive = true
    }
    
    public func setupNavigateButtons() {
        navigateButton.translatesAutoresizingMaskIntoConstraints = false
        previewButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(navigateButton)
        addSubview(previewButton)
        previewButton.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -sideMargin).isActive = true
        previewButton.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: sideMargin).isActive = true
        previewButton.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -sideMargin).isActive = true
        navigateButton.bottomAnchor.constraint(equalTo: previewButton.topAnchor, constant: -sideMargin).isActive = true
        navigateButton.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: sideMargin).isActive = true
        navigateButton.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -sideMargin).isActive = true
    }
    
    private func setupUI() {
        backgroundColor = UIColor.gray
        setupBackButton()
    }
    
}
