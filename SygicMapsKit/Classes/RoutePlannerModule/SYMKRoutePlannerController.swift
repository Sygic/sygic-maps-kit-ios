//// SYMKRoutePlannerController.swift
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

import SygicMaps
import SygicUIKit


public protocol SYMKRoutePlannerControllerDelegate: class {
    func routePlanner(_ planner: SYMKRoutePlannerController, didSelect route: SYRoute, preview: Bool)
    func routePlannerDidCancel(_ planner: SYMKRoutePlannerController)
}

public class SYMKRoutePlannerController: SYMKModuleViewController {
    
    // MARK: - Public Properties
    
    public var waypoints = [SYWaypoint]() {
        didSet {
            startRouting()
        }
    }
    
    public var routingOptions: SYRoutingOptions?
    
    public var useTraffic = true
    public var computeMultipleRoutes = true
    
    public weak var delegate: SYMKRoutePlannerControllerDelegate?
    
    public var primaryRoute: SYRoute? {
        didSet {
            updateMapObjects()
        }
    }
    public var alternativeRoutes = [SYRoute]() {
        didSet {
            updateMapObjects()
        }
    }
    
    public var units: SYUIDistanceUnits = .kilometers
    
    // MARK: - Private Properties
    
    private var mapInsets: UIEdgeInsets {
        UIEdgeInsets(top: 0.15, left: 0.1, bottom: 0.24, right: 0.1)
    }
    
    private var mapController: SYMKMapController?
    private var routingManager: SYRouting?
    private var mapObjects = [SYMapObject]()
    
    // MARK: - Public Methods
    
    public override func loadView() {
        let plannerView = SYMKRoutePlannerView()
        plannerView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        plannerView.navigateButton.addTarget(self, action: #selector(navigationButtonTapped), for: .touchUpInside)
        plannerView.previewButton.addTarget(self, action: #selector(previewButtonTapped), for: .touchUpInside)
        view = plannerView
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        removeAllMapObjects()
        super.viewWillDisappear(animated)
    }
    
    @objc public func backButtonTapped() {
        delegate?.routePlannerDidCancel(self)
    }
    
    @objc public func navigationButtonTapped() {
        guard let route = primaryRoute else { return }
        delegate?.routePlanner(self, didSelect: route, preview: false)
    }
    
    @objc public func previewButtonTapped() {
        guard let route = primaryRoute else { return }
        delegate?.routePlanner(self, didSelect: route, preview: true)
    }
    
    override internal func sygicSDKInitialized() {
        setupMapController()
        
        routingManager = SYRouting()
        routingManager?.delegate = self
        
        startRouting()
    }
    
    // MARK: - Private Methods
    
    private func setupMapController() {
        mapState.map?.renderEnabled = true
        let mapController = SYMKMapController(with: mapState)
        mapController.selectionManager = SYMKMapSelectionManager(with: .none)
        (view as! SYMKRoutePlannerView).setupMapView(mapController.mapView)
        self.mapController = mapController
    }
    
    private func startRouting() {
        routingManager?.cancelComputing()
        guard waypoints.count >= 2, let routing = routingManager else { return }
        
        let start = waypoints.first!
        let destination = waypoints.last!
        var actualWaypoints: [SYWaypoint]?
        if waypoints.count > 2 {
            actualWaypoints = Array(waypoints[1..<waypoints.count])
        }
        routing.computeRoute(start, to: destination, via: actualWaypoints, with: routingOptions)
        
        var boundingBox = SYGeoBoundingBox(bottomLeft: start.originalPosition, topRight: start.originalPosition)
        for wp in waypoints {
            if let newBox = boundingBox.union(with: SYGeoBoundingBox(bottomLeft: wp.originalPosition, topRight: wp.originalPosition)) {
                boundingBox = newBox
            }
        }
        mapState.setMapBoundingBox(boundingBox, edgeInsets: mapInsets, duration: 1, completion: nil)
    }
    
    private func updateMapObjects() {
        removeAllMapObjects()
        
        guard let primaryRoute = primaryRoute else { return }
        addMapRoute(to: primaryRoute, primary: true)
        var boundingBox = primaryRoute.box
        
        for route in alternativeRoutes {
            addMapRoute(to: route)
            if let newBox = boundingBox.union(with: route.box) {
                boundingBox = newBox
            }
        }
        mapState.map?.add(mapObjects)
        mapState.setMapBoundingBox(boundingBox, edgeInsets: mapInsets, duration: 1, completion: nil)
    }
    
    private func removeAllMapObjects() {
        mapState.map?.remove(mapObjects)
        mapObjects.removeAll()
    }
    
    private func addMapRoute(to route: SYRoute, primary: Bool = false) {
        let mapRoute = SYMapRoute(route: route, type: primary ? .primary : .alternative)
        let labelStyle: SYMapObjectTextStyle
        if primary {
            labelStyle = SYMapObjectTextStyle(fontSize: 17, fontStyle: .bold, textColor: .action, borderSize: 0, borderColor: nil)
        } else {
            labelStyle = SYMapObjectTextStyle(fontSize: 17, fontStyle: .regular, textColor: .gray, borderSize: 0, borderColor: nil)
        }
        
        let distance = route.info.length as SYDistance
        let formattedDistance = distance.format(toShortUnits: true, andRound: distance>1000, usingOtherThenFormattersUnits: units)
        
        let mapRouteLabel = SYMapRouteLabel(text: "\(formattedDistance)", textStyle: labelStyle, placeOn: route)
        mapObjects.append(mapRoute)
        mapObjects.append(mapRouteLabel)
    }
}

extension SYMKRoutePlannerController: SYRoutingDelegate {
    
    public func routing(_ routing: SYRouting, didComputePrimaryRoute route: SYRoute?) {
        if primaryRoute == nil, let plannerView = view as? SYMKRoutePlannerView {
            plannerView.setupNavigateButtons()
        }
        primaryRoute = route
    }
    
    public func routing(_ routing: SYRouting, didComputeAlternativeRoute route: SYRoute?) {
        guard let route = route else { return }
        alternativeRoutes.append(route)
    }
    
    public func routing(_ routing: SYRouting, didUpdateComputingProgress progress: Float, onRoute routeIndex: UInt) {
        
    }
    
    public func routingDidFinishRouteCompute(_ routing: SYRouting) {
        print("ROUTING finished")
    }
    
    public func routing(_ routing: SYRouting, computingFailedWithError error: SYRoutingError) {
        print("ROUTING ERROR: \(error)")
    }
}
