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
    public private(set) weak var instructionView: UIView?
    
    /// Lane assist view.
    public private(set) weak var laneAssistView: UIView?
    
    /// Current speed and speed limit view.
    public private(set) weak var speedControlView: SYUISpeedControlView?
    
    // MARK: - Private Properties
    
    private let margin: CGFloat = 16
    private let landscapeWidthMultiplier: CGFloat = 0.4
    private var actionButtonActionBlock: (()->())?
    private var infobarTrailingConstraint: NSLayoutConstraint?
    private var infobarWidthConstraint: NSLayoutConstraint?
    private var instructionTrailingConstraint: NSLayoutConstraint?
    private var instructionWidthConstraint: NSLayoutConstraint?
    private var laneAssistTrailingConstraint: NSLayoutConstraint?
    private var laneAssistWidthConstraint: NSLayoutConstraint?
    private var speedControlBottomPortraitContraint: NSLayoutConstraint?
    private var speedControlBottomLandscapeContraint: NSLayoutConstraint?
    
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
        updateLaneAssistLayoutConstraints()
        updateSpeedControlLayoutConstraints()
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
    
    /// Setup route preview control view.
    ///
    /// - Parameter routePreview: Route preview control view.
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
    
    /// Setup route preview control view.
    ///
    /// - Parameter routePreview: Route preview control view.
    public func setupInfobarView(_ infobar: UIView?) {
        self.infobarView?.removeFromSuperview()
        self.infobarView = infobar
        guard let infobar = infobar else { return }
        infobar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(infobar)
        infobar.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: margin).isActive = true
        infobar.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -margin).isActive = true
        infobarTrailingConstraint = infobar.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -margin)
        infobarWidthConstraint = infobar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: landscapeWidthMultiplier)
        updateInfobarLayoutConstraints()
    }
    
    /// Setup instruction view for navigation module.
    ///
    /// - Parameter instructionView: View with navigating instructions.
    public func setupInstructionView(_ instructionView: UIView?) {
        self.instructionView?.removeFromSuperview()
        self.instructionView = instructionView
        guard let instructionView = instructionView else { return }
        instructionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(instructionView)
        instructionView.topAnchor.constraint(equalTo: safeTopAnchor, constant: margin).isActive = true
        instructionView.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: margin).isActive = true
        instructionTrailingConstraint = instructionView.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -margin)
        instructionWidthConstraint = instructionView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: landscapeWidthMultiplier)
        updateInstructionLayoutConstraints()
    }
    
    /// Setup lane assist view for navigation module.
    ///
    /// - Parameter laneAssistView: View with lane directions.
    public func setupLaneAssistView(_ laneAssistView: UIView) {
        self.laneAssistView = laneAssistView
        guard let directionView = instructionView else { return }
        addSubview(laneAssistView)
        laneAssistView.translatesAutoresizingMaskIntoConstraints = false
        laneAssistView.topAnchor.constraint(equalTo: directionView.bottomAnchor, constant: margin/2).isActive = true
        laneAssistView.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: margin).isActive = true
        laneAssistTrailingConstraint = laneAssistView.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -margin)
        laneAssistWidthConstraint = laneAssistView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: landscapeWidthMultiplier)
        updateLaneAssistLayoutConstraints()
        laneAssistView.isHidden = true
    }
    
    /// Setup speed cobntrol view for navigation module.
    ///
    /// - Parameter speedControlView: View with current speed and speed limit.
    public func setupSpeedControlView(_ speedControlView: SYUISpeedControlView) {
        self.speedControlView = speedControlView
        speedControlView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(speedControlView)
        if let infobarView = infobarView {
            speedControlBottomPortraitContraint = speedControlView.bottomAnchor.constraint(equalTo: infobarView.topAnchor, constant: -margin)
        } else {
            speedControlBottomPortraitContraint = speedControlView.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -margin)
        }
        speedControlBottomLandscapeContraint = speedControlView.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -margin)
        speedControlView.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -margin).isActive = true
        updateSpeedControlLayoutConstraints()
    }

    // MARK: - Private Methods
    
    private func setupUI() {
        accessibilityLabel = "view.browseModule.root"
        backgroundColor = UIColor.gray
    }
    
    private func updateInfobarLayoutConstraints() {
        updateConstraints(portrait: infobarTrailingConstraint, landscape: infobarWidthConstraint)
    }
    
    private func updateLaneAssistLayoutConstraints() {
        updateConstraints(portrait: laneAssistTrailingConstraint, landscape: laneAssistWidthConstraint)
    }

    private func updateInstructionLayoutConstraints() {
        updateConstraints(portrait: instructionTrailingConstraint, landscape: instructionWidthConstraint)
    }
    
    private func updateSpeedControlLayoutConstraints() {
        updateConstraints(portrait: speedControlBottomPortraitContraint, landscape: speedControlBottomLandscapeContraint)
    }
    
    private func updateConstraints(portrait: NSLayoutConstraint?, landscape: NSLayoutConstraint?) {
        let isLandscape = SYUIDeviceOrientationUtils.isLandscapeLayout(traitCollection)
        landscape?.isActive = isLandscape
        portrait?.isActive = !isLandscape
    }
    
}
