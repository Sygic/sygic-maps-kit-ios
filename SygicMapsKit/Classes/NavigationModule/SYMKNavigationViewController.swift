//// SYMKNavigationViewController.swift
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

import UIKit
import SygicMaps
import SygicUIKit


/// Type of view with navigation instructions.
///
/// - direction: Instructions using arrow direction with distance and road street names.
/// - signpost: Extended direction instructions with signposts.
/// - none: No instruction view.
public enum SYMKInstructionType {
    case direction
    case signpost
    case none
}

/// Navigation module
public class SYMKNavigationViewController: SYMKModuleViewController {
    
    // MARK: - Public Properties
    
    /// Navigation route
    public private(set) var route: SYRoute? {
        didSet {
            guard route != oldValue else { return }
            if let newRoute = route {
                mapRoute = SYMapRoute(route: newRoute, type: .primary)
                SYNavigation.shared().start(with: route)
            } else {
                mapRoute = nil
                stopNavigation()
            }
        }
    }
    
    /// Indicates if navigation should simulate device position through route. Default: false
    public var preview: Bool = false {
        didSet {
            guard preview != oldValue, SYMKSdkManager.shared.isSdkInitialized else { return }
            if preview {
                startPreview()
            } else {
                stopPreview()
            }
        }
    }
    
    public var useLaneAssist: Bool = true
    
    /// Enables current speed.
    public var useCurrentSpeed = true
    
    /// Enables speed limit. If both current speed and speed limit are enabled, speed limit is showed on top of current speed.
    public var useSpeedLimit = true

    /// Enables infobar functionality
    public var useInfobar: Bool = true
    
    /// Button that appears inside infobarView. Default button locks map position on user location
    public var leftInfobarButton: SYUIActionButton? {
        didSet {
            infobarController?.infobarView.leftButton = leftInfobarButton
        }
    }
    
    /// Button that appears inside infobarView. Default button cancels navigation
    public var rightInfobarButton: SYUIActionButton? {
        didSet {
            infobarController?.infobarView.rightButton = rightInfobarButton
        }
    }
    
    /// Type of view with navigation instructions.
    public var instructionsType: SYMKInstructionType = .direction {
        didSet {
            switch instructionsType {
            case .direction:
                instructionsController = SYMKDirectionController()
            case .signpost:
                instructionsController = SYMKSignpostController()
            case .none:
                instructionsController = nil
            }
        }
    }
    
    /// Distance units. Default value is metric units.
    public var units: SYUIDistanceUnits = .kilometers {
        didSet {
            instructionsController?.units = units
            infobarController?.units = units
            speedController?.units = units
        }
    }
    
    // MARK: - Private Properties
    
    private var mapRoute: SYMapRoute? {
        didSet {
            guard let navigationView = view as? SYMKNavigationView, let map = navigationView.mapView as? SYMapView else { return }
            if let oldRoute = oldValue {
                map.remove(oldRoute)
            }
            if let newRoute = mapRoute {
                map.add(newRoute)
            }
        }
    }
    
    private var laneAssistController = SYMKLaneAssistController()
    
    private var infobarController: SYMKInfobarController?
    private var speedController: SYMKSpeedController?
    private let routePreviewController = SYMKRoutePreviewController()

    private var instructionsController: SYMKDirectionController? = SYMKDirectionController() {
        didSet {
            guard let navigationView = view as? SYMKNavigationView, let instructionsController = instructionsController else {
                (view as? SYMKNavigationView)?.setupInstructionView(nil)
                return
            }
            instructionsController.units = units
            navigationView.setupInstructionView(instructionsController.view)
        }
    }
    
    // MARK: - Public Methods
    
    public init(with route: SYRoute? = nil) {
        self.route = route
        if let newRoute = route {
            mapRoute = SYMapRoute(route: newRoute, type: .primary)
        }
        
        super.init(nibName: nil, bundle: nil)
        
        mapState.cameraMovementMode = .followGpsPositionWithAutozoom
        mapState.cameraRotationMode = .vehicle
        mapState.tilt = 60.0
        
        routePreviewController.previewDelegate = self
        
        let lockButton = SYUIActionButton()
        lockButton.style = .primary13
        lockButton.icon = SYUIIcon.positionIos
        lockButton.height = 48
        lockButton.addTarget(self, action: #selector(lockPosition), for: .touchUpInside)
        leftInfobarButton = lockButton
        
        let cancelRouteButton = SYUIActionButton()
        cancelRouteButton.style = .error13
        cancelRouteButton.icon = SYUIIcon.close
        cancelRouteButton.height = 48
        cancelRouteButton.addTarget(self, action: #selector(stopNavigation), for: .touchUpInside)
        rightInfobarButton = cancelRouteButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopNavigation()
    }
    
    public override func loadView() {
        let navigationView = SYMKNavigationView()
        if let instructionsController = instructionsController {
            navigationView.setupInstructionView(instructionsController.view)
        }
        if useLaneAssist {
            navigationView.setupLaneAssistView(laneAssistController.view)
        }
        if useInfobar {
            setupInfobarController()
            if let infobarController = infobarController {
                navigationView.setupInfobarView(infobarController.infobarView)
            }
        }
        if useCurrentSpeed || useSpeedLimit {
            speedController = SYMKSpeedController(currentSpeed: useCurrentSpeed, speedLimit: useSpeedLimit)
            if let speedController = speedController, let speedControlsView = speedController.view {
                navigationView.setupSpeedControlView(speedControlsView)
            }
        }
        view = navigationView
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        if let map = mapState.map {
            (view as! SYMKNavigationView).setupMapView(map)
            map.renderEnabled = true
            map.setup(with: mapState)
        }
        super.viewDidAppear(animated)
    }
    
    override func sygicSDKInitialized() {
        guard let navigationView = view as? SYMKNavigationView else { return }
        let map = mapState.loadMap(with: view.bounds)
        navigationView.setupMapView(map)
        triggerUserLocation(true)
        
        if useCurrentSpeed {
            speedController?.setupSpeedUpdater()
        }
        
        SYNavigation.shared().delegate = self
    
        guard let route = route, let mapRoute = mapRoute else { return }
        map.remove(mapRoute)
        map.add(mapRoute)
        SYNavigation.shared().start(with: route)
    }
    
    /// Start navigation
    /// - Parameter route: route
    /// - Parameter preview: if true, navigation will simulate device position through route (default: false)
    public func startNavigation(with route: SYRoute, preview: Bool = false) {
        self.route = route
        self.preview = preview
    }
    
    /// Stops current navigation and removes route
    @objc public func stopNavigation() {
        guard SYMKSdkManager.shared.isSdkInitialized else { return }
        if SYNavigation.shared().isNavigating() {
            SYNavigation.shared().stop()
        }
        preview = false
        if route != nil {
            route = nil
        }
    }
    
    // MARK: - Private Methods
    
    private func setupInfobarController() {
        infobarController = SYMKInfobarController()
        infobarController?.units = units
        infobarController?.infobarView.leftButton = leftInfobarButton
        infobarController?.infobarView.rightButton = rightInfobarButton
    }
    
    private func startPreview() {
        guard let route = route else { return }
        routePreviewController.startPreview(route)
        guard let navigationView = view as? SYMKNavigationView else { return }
        navigationView.setupRoutePreviewView(routePreviewController.view)
    }
    
    private func stopPreview() {
        routePreviewController.stopPreview()
        guard let navigationView = view as? SYMKNavigationView else { return }
        navigationView.routePreviewView?.removeFromSuperview()
    }
    
    @objc private func lockPosition() {
        mapState.cameraMovementMode = .followGpsPositionWithAutozoom
        mapState.cameraRotationMode = .vehicle
    }
    
}

extension SYMKNavigationViewController: SYNavigationDelegate {
    
    public func navigation(_ navigation: SYNavigation, didUpdate route: SYRoute?) {
        print("navigation updated route")
    }
    
    public func navigation(_ navigation: SYNavigation, didUpdate positionInfo: SYPositionInfo?) {
        guard let info = positionInfo else { return }
        infobarController?.updatePositionInfo(info)
    }
    
    public func navigation(_ navigation: SYNavigation, didUpdate limit: SYSpeedLimit?) {
        if useSpeedLimit {
            speedController?.update(with: limit)
        }
    }
    
    public func navigation(_ navigation: SYNavigation, didUpdateSignpost signpostInfo: [SYSignpost]?) {
        guard let signposts = signpostInfo, let signpostController = instructionsController as? SYMKSignpostController else { return }
        signpostController.update(with: signposts)
    }
    
    public func navigation(_ navigation: SYNavigation, didUpdateDirection instruction: SYInstruction?) {
        guard let instruction = instruction, let instructionsController = instructionsController else { return }
        instructionsController.update(with: instruction)
    }
    
    public func navigation(_ navigation: SYNavigation, didUpdate info: SYOnRouteInfo?) {
        guard let info = info else { return }
        infobarController?.updateRouteInfo(info)
    }
    
    public func navigation(_ navigation: SYNavigation, didUpdate lanesInfo: SYLanesInformation?) {
        guard useLaneAssist else { return }
        laneAssistController.update(with: lanesInfo)
    }
    
}

extension SYMKNavigationViewController: SYMKRoutePreviewDelegate {
    
    public func routePreviewDidStop(_ controller: SYMKRoutePreviewController) {
        preview = false
    }
    
}
