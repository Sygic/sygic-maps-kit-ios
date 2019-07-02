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
                guard let route = route else { return }
                if let previewPosition = SYRoutePositionSimulator(route: route) {
                    SYPositioning.shared().dataSource = previewPosition
                    previewPosition.start()
                }
            } else {
                if let simulator = SYPositioning.shared().dataSource as? SYRoutePositionSimulator {
                    simulator.stop()
                    SYPositioning.shared().dataSource = nil
                }
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
    
    // MARK: - Public Methods
    
    public init(with route: SYRoute? = nil) {
        self.route = route
        if let newRoute = route {
            mapRoute = SYMapRoute(route: newRoute, type: .primary)
        }
        
        super.init(nibName: nil, bundle: nil)
        
        self.mapState.cameraMovementMode = .followGpsPositionWithAutozoom
        self.mapState.cameraRotationMode = .vehicle
        self.mapState.tilt = 60.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopNavigation()
    }
    
    public override func loadView() {
        let navigationView = SYMKNavigationView()
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
        triggerUserLocation(true)
        let map = mapState.loadMap(with: view.bounds)
        navigationView.setupMapView(map)
        
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
}

extension SYMKNavigationViewController: SYNavigationDelegate {
    public func navigation(_ navigation: SYNavigation, didUpdate route: SYRoute?) {
        print("navigation updated route")
    }
    
    public func navigation(_ navigation: SYNavigation, didUpdate positionInfo: SYPositionInfo?) {
        
    }
    
    public func navigation(_ navigation: SYNavigation, didUpdate limit: SYSpeedLimit?) {
        
    }
    
    public func navigation(_ navigation: SYNavigation, didUpdateSignpost signpostInfo: [SYSignpost]?) {
        
    }
    
    public func navigation(_ navigation: SYNavigation, didUpdateDirection instruction: SYInstruction?) {
        
    }
    
    public func navigation(_ navigation: SYNavigation, didUpdate info: SYOnRouteInfo?) {
        
    }
}
