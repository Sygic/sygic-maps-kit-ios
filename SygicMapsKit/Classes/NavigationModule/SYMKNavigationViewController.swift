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
    
    /// Enables current speed and speed limit.
    public var useSpeedControls = false
    
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

    private let routePreviewController = SYMKRoutePreviewController()
    private let speedController = SYMKSpeedController()

    private var instructionsController: SYMKDirectionController? = SYMKDirectionController() {
        didSet {
            guard let navigationView = view as? SYMKNavigationView, let instructionsController = instructionsController else {
                (view as? SYMKNavigationView)?.setupInstructionView(nil)
                return
            }
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
        if useSpeedControls {
            navigationView.setupSpeedControlView(speedController.view)
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
        setupSpeedUpdater()
        
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
    public func stopNavigation() {
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
    
    private func startPreview() {
        guard let route = route else { return }
        routePreviewController.startPreview(route)
        guard let navigationView = view as? SYMKNavigationView else { return }
        navigationView.setupRoutePreviewView(routePreviewController.expandableButtonsView)
    }
    
    private func stopPreview() {
        routePreviewController.stopPreview()
        guard let navigationView = view as? SYMKNavigationView else { return }
        navigationView.routePreviewView?.removeFromSuperview()
    }
    
    private func setupSpeedUpdater() {
        guard useSpeedControls else { return }
        
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let weakSelf = self else {
                timer.invalidate()
                return
            }
            guard timer.isValid else { return }
            guard let speed = SYPositioning.shared().lastKnownLocation?.speed else { return }
            weakSelf.speedController.currentSpeed = Int(speed)
        }
    }
}

extension SYMKNavigationViewController: SYNavigationDelegate {
    
    public func navigation(_ navigation: SYNavigation, didUpdate route: SYRoute?) {
        print("navigation updated route")
    }
    
    public func navigation(_ navigation: SYNavigation, didUpdate positionInfo: SYPositionInfo?) {
        
    }
    
    public func navigation(_ navigation: SYNavigation, didUpdate limit: SYSpeedLimit?) {
        speedController.update(with: limit)
    }
    
    public func navigation(_ navigation: SYNavigation, didUpdateSignpost signpostInfo: [SYSignpost]?) {
        guard let signposts = signpostInfo, let signpostController = instructionsController as? SYMKSignpostController else { return }
        signpostController.update(with: signposts)
    }
    
    public func navigation(_ navigation: SYNavigation, didUpdateDirection instruction: SYInstruction?) {
        guard let instruction = instruction, let instructionsController = instructionsController else { return }
        instructionsController.update(with: instruction)
    }
}

extension SYMKNavigationViewController: SYMKRoutePreviewDelegate {
    
    public func routePreviewDidStop(_ controller: SYMKRoutePreviewController) {
        preview = false
    }
    
}
