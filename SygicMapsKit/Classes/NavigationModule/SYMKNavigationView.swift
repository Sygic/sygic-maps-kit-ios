//// SYMKNavigationView.swift
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
import SygicMaps
import SygicUIKit


/// Navigation Module's view.
public class SYMKNavigationView: UIView {
    
    // MARK: - Public Properties
    
    /// Map view.
    public private(set) weak var mapView: UIView?

    /// Route preview view with controlls to manage route preview playback.
    public private(set) weak var routePreviewView: UIView?
    
    /// Infobar View.
    public private(set) weak var infobarView: UIView?
    
    /// Instruction view.
    public private(set) weak var instructionView: SYMKInstructionView?
    
    // MARK: - Private Properties
    
    private let margin: CGFloat = 16
    private var actionButtonActionBlock: (()->())?
    
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
    /// - Parameter mapView: Map view to set up
    public func setupMapView(_ mapView: UIView) {
        self.mapView = mapView
        mapView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mapView)
        sendSubviewToBack(mapView)
        mapView.coverWholeSuperview()
    }
    
    /// Setup route preview control view
    ///
    /// - Parameter routePreview: route preview control view
    public func setupRoutePreviewView(_ routePreview: UIView) {
        self.routePreviewView?.removeFromSuperview()
        self.routePreviewView = routePreview
        addSubview(routePreview)
        bringSubviewToFront(routePreview)
        routePreview.translatesAutoresizingMaskIntoConstraints = false
        routePreview.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: margin).isActive = true
        if let infobar = infobarView {
            routePreview.bottomAnchor.constraint(equalTo: infobar.topAnchor, constant: -margin).isActive = true
        } else {
            routePreview.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -margin).isActive = true
        }
    }
    
    /// Setup instruction view for navigation module.
    ///
    /// - Parameter instructionView: view with navigating instructions.
    public func setupInstructionView(_ instructionView: SYMKInstructionView?) {
        self.instructionView?.removeFromSuperview()
        guard let instructionView = instructionView else { return }
        self.instructionView = instructionView
        instructionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(instructionView)
        instructionView.topAnchor.constraint(equalTo: safeTopAnchor, constant: margin).isActive = true
        instructionView.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: margin).isActive = true
        instructionView.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -margin).isActive = true
    }

    // MARK: - Private Methods
    
    private func setupUI() {
        accessibilityLabel = "view.browseModule.root"
        backgroundColor = UIColor.gray
    }
}
