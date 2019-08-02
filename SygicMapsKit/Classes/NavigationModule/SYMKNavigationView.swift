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
    private var infobarTrailingConstraint: NSLayoutConstraint?
    private var infobarWidthConstraint: NSLayoutConstraint?
    private var instructionTrailingConstraint: NSLayoutConstraint?
    private var instrunctionWidthConstraint: NSLayoutConstraint?
    
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
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateInfobarLayoutConstraints()
        updateInstructionLayoutConstraints()
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
        routePreview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(routePreview)
        if let infobar = infobarView {
            routePreview.centerXAnchor.constraint(equalTo: infobar.centerXAnchor).isActive = true
            routePreview.bottomAnchor.constraint(equalTo: infobar.topAnchor, constant: -margin).isActive = true
        } else {
            routePreview.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            routePreview.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -margin).isActive = true
        }
    }
    
    /// Setup route preview control view
    ///
    /// - Parameter routePreview: route preview control view
    public func setupInfobarView(_ infobar: UIView?) {
        self.infobarView?.removeFromSuperview()
        self.infobarView = infobar
        guard let infobar = infobar else { return }
        infobar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(infobar)
        infobar.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: margin).isActive = true
        infobar.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -margin).isActive = true
        infobarTrailingConstraint = infobar.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -margin)
        infobarWidthConstraint = infobar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4)
        updateInfobarLayoutConstraints()
    }
    
    /// Setup instruction view for navigation module.
    ///
    /// - Parameter instructionView: view with navigating instructions.
    public func setupInstructionView(_ instructionView: SYMKInstructionView?) {
        self.instructionView?.removeFromSuperview()
        self.instructionView = instructionView
        guard let instructionView = instructionView else { return }
        instructionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(instructionView)
        instructionView.topAnchor.constraint(equalTo: safeTopAnchor, constant: margin).isActive = true
        instructionView.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: margin).isActive = true
        instrunctionWidthConstraint = instructionView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4)
        instructionTrailingConstraint = instructionView.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -margin)
        updateInstructionLayoutConstraints()
    }

    // MARK: - Private Methods
    
    private func setupUI() {
        accessibilityLabel = "view.browseModule.root"
        backgroundColor = UIColor.gray
    }
    
    private func updateInfobarLayoutConstraints() {
        let isPortrait = SYUIDeviceOrientationUtils.isPortraitLayout(traitCollection)
        infobarWidthConstraint?.isActive = !isPortrait
        infobarTrailingConstraint?.isActive = isPortrait
    }
    
    private func updateInstructionLayoutConstraints() {
        let isLandscape = SYUIDeviceOrientationUtils.isLandscapeLayout(traitCollection)
        instructionTrailingConstraint?.isActive = !isLandscape
        instrunctionWidthConstraint?.isActive = isLandscape
    }
}
