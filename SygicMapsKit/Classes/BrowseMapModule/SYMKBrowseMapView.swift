//// SYMKBrowseMapView.swift
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
import SygicMaps
import SygicUIKit


/// Browse Map Module's view.
public class SYMKBrowseMapView: UIView {
    
    // MARK: - Public Properties
    
    /// Map view.
    public private(set) weak var mapView: UIView?
    /// Compass view.
    public private(set) weak var compass: UIView?
    /// Recenter button view.
    public private(set) weak var recenterButton: UIView?
    /// Zoom control view.
    public private(set) weak var zoomControl: UIView?
    
    // MARK: - Private Properties
    
    private let sideMargin: CGFloat = 16
    
    // MARK: - Public Methods
    
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
    
    /// Setup map view on whole scene.
    ///
    /// - Parameter mapView: Map view to set up.
    public func setupMapView(_ mapView: UIView) {
        self.mapView = mapView
        mapView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mapView)
        sendSubviewToBack(mapView)
        mapView.coverWholeSuperview()
    }
    
    /// Setup compass on scene.
    ///
    /// - Parameter compass: Compass to set up.
    public func setupCompass(_ compass: UIView) {
        self.compass = compass
        addSubview(compass)
        bringSubviewToFront(compass)
        compass.translatesAutoresizingMaskIntoConstraints = false
        compass.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -sideMargin).isActive = true
        compass.topAnchor.constraint(equalTo: safeTopAnchor, constant: sideMargin).isActive = true
    }
    
    /// Setup zoom control on scene.
    ///
    /// - Parameter zoomControl: Zoom Control to set up.
    public func setupZoomControl(_ zoomControl: UIView) {
        self.zoomControl = zoomControl
        addSubview(zoomControl)
        bringSubviewToFront(zoomControl)
        zoomControl.translatesAutoresizingMaskIntoConstraints = false
        zoomControl.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: sideMargin).isActive = true
        if let recenterButton = recenterButton {
            zoomControl.bottomAnchor.constraint(equalTo: recenterButton.topAnchor, constant: -sideMargin).isActive = true
        } else {
            zoomControl.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -sideMargin).isActive = true
        }
    }
    
    /// Setup recenter button on scene.
    ///
    /// - Parameter recenter: Recenter button to set up.
    public func setupRecenter(_ recenter: UIView) {
        recenterButton = recenter
        addSubview(recenter)
        bringSubviewToFront(recenter)
        recenter.translatesAutoresizingMaskIntoConstraints = false
        recenter.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: sideMargin).isActive = true
        recenter.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -sideMargin).isActive = true
    }

    // MARK: - Private Methods
    
    private func setupUI() {
        accessibilityLabel = "view.browseModule.root"
        backgroundColor = UIColor.gray
    }
    
}
