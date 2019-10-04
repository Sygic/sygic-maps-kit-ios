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
    //MARK: required
    func routePlanner(_ planner: SYMKRoutePlannerController, didSelect route: SYRoute, preview: Bool)
    func routePlannerDidCancel(_ planner: SYMKRoutePlannerController)
    
    //MARK: optional
    func routePlanner(_ planner: SYMKRoutePlannerController, didCompute route: SYRoute, type: SYMapRouteType)
    func routePlanner(_ planner: SYMKRoutePlannerController, switch primaryRoute: SYRoute, alternativeRoutes: [SYRoute])
    
    /// Called when error occures while route is computed. Override this method to handle showing error message. Return nil if you don't want to show any message.
    /// - Parameter planner: route planner controller
    /// - Parameter error: routing error
    func routePlanner(_ planner: SYMKRoutePlannerController, routingFinishedWith error: SYRoutingError) -> String?
}

public extension SYMKRoutePlannerControllerDelegate {
    func routePlanner(_ planner: SYMKRoutePlannerController, didCompute route: SYRoute, type: SYMapRouteType) {}
    func routePlanner(_ planner: SYMKRoutePlannerController, switch primaryRoute: SYRoute, alternativeRoutes: [SYRoute]) {}
    func routePlanner(_ planner: SYMKRoutePlannerController, routingFinishedWith error: SYRoutingError) -> String? {
        return error.errorMessage()
    }
}


/// Route planner module
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
    
    public var units: SYUIDistanceUnits = .kilometers {
        didSet {
            routesController.units = units
        }
    }
    
    // MARK: - Private Properties
    
    private var mapInsets: UIEdgeInsets {
        UIEdgeInsets(top: 0.15, left: 0.1, bottom: 0.24, right: 0.1)
    }
    
    private var mapController: SYMKMapController?
    private var routingManager: SYRouting?
    private var mapObjects = [SYMapObject]()
    private var routesController = SYMKRoutesViewController()
    
    // MARK: - Public Methods
    
    public override func loadView() {
        let plannerView = SYMKRoutePlannerView()
        plannerView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        plannerView.optionsButton.addTarget(self, action: #selector(optionsButtonTapped), for: .touchUpInside)
        view = plannerView
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let isLandscape = size.width > size.height
        mapState.updateMapCenter(isLandscape)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        removeAllMapObjects()
        super.viewWillDisappear(animated)
    }
    
    @objc public func backButtonTapped() {
        delegate?.routePlannerDidCancel(self)
    }
    
    @objc public func optionsButtonTapped() {
        present(UINavigationController(rootViewController: SYMKRouteOptionsViewController(with: routingOptions)), animated: true, completion: nil)
    }
    
    override internal func sygicSDKInitialized() {
        setupMapController()
        mapState.updateMapCenter(SYUIDeviceOrientationUtils.isLandscapeStatusBar())
        routingManager = SYRouting()
        routingManager?.delegate = self
        startRouting()
    }
    
    public func cancelComputing() {
        routingManager?.cancelComputing()
    }
    
    // MARK: - Private Methods
    
    private func setupMapController() {
        mapState.map?.renderEnabled = true
        let mapController = SYMKMapController(with: mapState, mapFrame: view.bounds)
        let routeSelectionManager = SYMKRouteSelectionManager(with: .routeAndRouteLabel)
        routeSelectionManager.delegate = self
        mapController.selectionManager = routeSelectionManager
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
        zoomMap()
    }
    
    private func updateMapObjects() {
        removeAllMapObjects()
        guard let primaryRoute = primaryRoute else { return }
        addMapRoute(to: primaryRoute, primary: true)
        for route in alternativeRoutes {
            addMapRoute(to: route)
        }
        mapState.map?.add(mapObjects)
        zoomMap()
    }
    
    private func removeAllMapObjects() {
        mapState.map?.remove(mapObjects)
        mapObjects.removeAll()
    }
    
    private func addMapRoute(to route: SYRoute, primary: Bool = false) {
        let labelStyle: SYMapObjectTextStyle
        if primary {
            labelStyle = SYMapObjectTextStyle(fontSize: 17, fontStyle: .bold, textColor: .action, borderSize: 0, borderColor: nil)
        } else {
            labelStyle = SYMapObjectTextStyle(fontSize: 17, fontStyle: .regular, textColor: .gray, borderSize: 0, borderColor: nil)
        }
        let mapRouteLabel = SYMapRouteLabel(text: "\(route.formattedDistance(units)) / \(route.formatedDuration())", textStyle: labelStyle, placeOn: route)
        let mapRoute = SYMapRoute(route: route, type: primary ? .primary : .alternative)
        mapObjects.append(mapRoute)
        mapObjects.append(mapRouteLabel)
    }
    
    private func zoomMap() {
        view.layoutIfNeeded()
        var boundingBox: SYGeoBoundingBox?
        if let route = primaryRoute {
            boundingBox = route.box
            for alternative in alternativeRoutes {
                if let newBox = boundingBox!.union(with: alternative.box) {
                    boundingBox = newBox
                }
            }
        } else if let startWP = waypoints.first, waypoints.count > 1 {
            boundingBox = SYGeoBoundingBox(bottomLeft: startWP.originalPosition, topRight: startWP.originalPosition)
            for wp in waypoints {
                if let newBox = boundingBox!.union(with: SYGeoBoundingBox(bottomLeft: wp.originalPosition, topRight: wp.originalPosition)) {
                    boundingBox = newBox
                }
            }
        }
        guard let box = boundingBox else { return }
        mapState.setMapBoundingBox(box, edgeInsets: mapInsets, duration: 1, completion: nil)
    }
    
    private func switchPrimaryRoute(_ newPrimaryRoute: SYRoute) {
        guard let oldPrimaryRoute = primaryRoute, newPrimaryRoute != primaryRoute else { return }
        alternativeRoutes.removeAll { $0 == newPrimaryRoute }
        alternativeRoutes.append(oldPrimaryRoute)
        primaryRoute = newPrimaryRoute
        updateMapObjects()
        delegate?.routePlanner(self, switch: newPrimaryRoute, alternativeRoutes: alternativeRoutes)
    }
}

extension SYMKRoutePlannerController: SYRoutingDelegate {
    
    public func routingDidStartRouteComputing(_ routing: SYRouting) {
        guard let plannerView = view as? SYMKRoutePlannerView else { return }
        plannerView.setupRoutesView(routesController.routesView)
        routesController.delegate = self
    }
    
    public func routing(_ routing: SYRouting, didComputePrimaryRoute route: SYRoute?) {
        guard let route = route else { return }
        primaryRoute = route
        routesController.routes.append(route)
        delegate?.routePlanner(self, didCompute: route, type: .primary)
        if !computeMultipleRoutes {
            routing.cancelComputing()
        }
    }
    
    public func routing(_ routing: SYRouting, didComputeAlternativeRoute route: SYRoute?) {
        guard computeMultipleRoutes, let route = route else { return }
        alternativeRoutes.append(route)
        routesController.routes.append(route)
        delegate?.routePlanner(self, didCompute: route, type: .alternative)
    }
    
    public func routing(_ routing: SYRouting, didUpdateComputingProgress progress: Float, onRoute routeIndex: UInt) {
        // TODO:
    }
    
    public func routingDidFinishRouteCompute(_ routing: SYRouting) {
        // TODO:
    }
    
    public func routing(_ routing: SYRouting, computingFailedWithError error: SYRoutingError) {
        guard let errorMessage = delegate?.routePlanner(self, routingFinishedWith: error) else { return }
        let alert = UIAlertController(title: LS("Routing error"), message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension SYMKRoutePlannerController: SYMKRouteSelectionDelegate {
    
    public func routeSelection(didSelect route: SYRoute) {
        guard route != primaryRoute else { return }
        routesController.switchCurrentRoute(route)
        switchPrimaryRoute(route)
    }
}

extension SYMKRoutePlannerController: SYMKRoutesViewControllerDelegate {
    
    public func routesViewControllerNavigationPressed(_ controller: SYMKRoutesViewController) {
        guard let route = primaryRoute else { return }
        delegate?.routePlanner(self, didSelect: route, preview: false)
    }
    
    public func routesViewControllerPreviewPressed(_ controller: SYMKRoutesViewController) {
        guard let route = primaryRoute else { return }
        delegate?.routePlanner(self, didSelect: route, preview: true)
    }
    
    public func routesViewController(_ controller: SYMKRoutesViewController, switchRoute selectedRoute: SYRoute) {
        switchPrimaryRoute(selectedRoute)
    }
}

public extension SYRoutingError {
    
    func errorMessage() -> String? {
        switch self {
        case .unspecifiedFault:
            return LS("Unspecified fault")
        case .frontEmpty:
            return LS("Front empty")
        case .pathReconstructFailed:
            return LS("Path reconstruction failed")
        case .wrongFromPoint:
            return LS("Wrong starting location")
        case .pathConstructFailed:
            return LS("Path construction failed")
        case .pathNotFound:
            return LS("Path not found")
        case .unreachableTarget:
            return LS("Unreachable target")
        case .invalidSelection:
            return LS("Invalid selection")
        case .onlineServiceError:
            return LS("Online servide error")
        case .onlineServiceNotAvailable:
            return LS("Online service not available")
        case .onlineServiceWrongResponse:
            return LS("Online service wrong response")
        case .onlineServiceTimeout:
            return LS("Online service timeout")
        case .noComputeCanBeCalled:
            return LS("No compute can be called")
        case .couldNotRetrieveSavedRoute:
            return LS("Could not retrieve saved route")
        case .mapNotAvailable:
            return LS("Map not available")
        case .selectionOutsideOfMap:
            return LS("Selection outside of map")
        case .userCanceled:
            return nil
        case .alternativeRejected:
            return LS("Alternative rejected")
        }
    }
}
