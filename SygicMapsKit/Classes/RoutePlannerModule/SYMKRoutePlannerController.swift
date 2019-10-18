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
    
    func routePlanner(_ planner: SYMKRoutePlannerController, wantsAddNewWaypoint newWaypointBlock: @escaping SYMKRouteWaypointsAddBlock)
}

public extension SYMKRoutePlannerControllerDelegate {
    func routePlanner(_ planner: SYMKRoutePlannerController, didCompute route: SYRoute, type: SYMapRouteType) {}
    func routePlanner(_ planner: SYMKRoutePlannerController, switch primaryRoute: SYRoute, alternativeRoutes: [SYRoute]) {}
    func routePlanner(_ planner: SYMKRoutePlannerController, routingFinishedWith error: SYRoutingError) -> String? {
        return error.errorMessage()
    }
    func routePlanner(_ planner: SYMKRoutePlannerController, wantsAddNewWaypoint newWaypointBlock: @escaping SYMKRouteWaypointsAddBlock) {}
}


/// Route planner module
public class SYMKRoutePlannerController: SYMKModuleViewController {
    
    // MARK: - Public Properties
    
    /// Waypoints define a route's stopovers, including its start point it's destination point and any points in between.
    /// Changing waypoints array will trigger route computing
    public var waypoints = [SYWaypoint]() {
        didSet {
            computeRoute()
        }
    }
    
    /// All available options for route computing algorithm
    /// Changing waypoints array will trigger route computing
    public var routingOptions: SYRoutingOptions? {
        didSet {
            computeRoute()
        }
    }
    
    public var useTraffic = true // TODO:
    public var useCancelButton = false
    public var useOptionsButton = false
    
    public weak var delegate: SYMKRoutePlannerControllerDelegate?
    
    public var primaryRoute: SYRoute? {
        return routeSelectionManager?.primaryRoute
    }
    
    public var alternativeRoutes: [SYRoute] {
        return routeSelectionManager?.alternativeRoutes ?? []
    }
    
    public var units: SYUIDistanceUnits = .kilometers {
        didSet {
            routesController.units = units
            if let routesSelectionManager = mapController?.selectionManager as? SYMKRouteSelectionManager {
                routesSelectionManager.units = units
            }
        }
    }
    
    // MARK: - Private Properties
    
    private var mapInsets: UIEdgeInsets {
        UIEdgeInsets(top: 0.15, left: 0.1, bottom: 0.24, right: 0.1)
    }
    
    private var mapController: SYMKMapController?
    private var routingManager: SYRouting?
    private var routeSelectionManager: SYMKRouteSelectionManager?
    private var routesController = SYMKRoutesViewController()
    private var waypointsController: SYMKRouteWaypointsViewController?
    
    // MARK: - Public Methods
    
    public override func loadView() {
        let plannerView = SYMKRoutePlannerView()
        if useCancelButton {
            plannerView.setupBackButton()
            plannerView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
        if useOptionsButton {
            plannerView.setupOptionsButton()
            plannerView.optionsButton.addTarget(self, action: #selector(optionsButtonTapped), for: .touchUpInside)
        }
        view = plannerView
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let isLandscape = size.width > size.height
        mapState.updateMapCenter(isLandscape)
    }
    
    override internal func sygicSDKInitialized() {
        super.sygicSDKInitialized()
        setupMapController()
        mapState.updateMapCenter(SYUIDeviceOrientationUtils.isLandscapeStatusBar())
        routingManager = SYRouting()
        routingManager?.delegate = self
        if waypoints.count > 1 {
            computeRoute()
        } else {
            showWaypointsEditor()
        }
    }
    
    /// Starts route computing.
    /// Method is triggered automatically when waypoints or routingOptions have changed.
    public func computeRoute() {
        guard waypoints.count >= 2, let routing = routingManager else { return }
        routing.cancelComputing()
        let start = waypoints.first!
        let destination = waypoints.last!
        var actualWaypoints: [SYWaypoint]?
        if waypoints.count > 2 {
            actualWaypoints = Array(waypoints[1..<waypoints.count])
        }
        routeSelectionManager?.removeAllMapRoutes()
        routing.computeRoute(start, to: destination, via: actualWaypoints, with: routingOptions)
        zoomMap()
    }
    
    /// Cances route computing
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
        self.routeSelectionManager = routeSelectionManager
        (view as! SYMKRoutePlannerView).setupMapView(mapController.mapView)
        self.mapController = mapController
    }
    
    private func zoomMap() {
        view.layoutIfNeeded()
        guard let box = routeSelectionManager?.routesBoundingBox ?? waypoints.boundingBox else { return }
        mapState.setMapBoundingBox(box, edgeInsets: mapInsets, duration: 1, completion: nil)
    }
    
    @objc private func backButtonTapped() {
        delegate?.routePlannerDidCancel(self)
    }
    
    @objc private func optionsButtonTapped() {
        let optionsAction = UIAlertAction(title: LS("routeCompute.options.title"), style: .default, handler: { [weak self] _ in
            self?.showRouteOptions()
        })
        let waypointsAction = UIAlertAction(title: LS("detail.action.addVia"), style: .default, handler: { [weak self] _ in
            self?.showWaypointsEditor()
        })
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(optionsAction)
        actionSheet.addAction(waypointsAction)
        actionSheet.addAction(UIAlertAction(title: LS("Cancel"), style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func showRouteOptions() {
        let optionsController = SYMKRouteOptionsViewController(with: routingOptions, currentRoute: primaryRoute)
        optionsController.delegate = self
        present(UINavigationController(rootViewController: optionsController), animated: true, completion: nil)
    }
    
    private func showWaypointsEditor() {
        guard let view = view as? SYMKRoutePlannerView else { return }
        routesController.routesView.isHidden = true
        let waypointsController = SYMKRouteWaypointsViewController(with: waypoints)
        waypointsController.delegate = self
        addChild(waypointsController)
        view.setupWaypointsView(waypointsController.waypointsView)
        view.waypointsView?.isHidden = false
        self.waypointsController = waypointsController
    }
    
    private func dismissWaypointsEditor() {
        guard let controller = waypointsController else { return }
        controller.view.removeFromSuperview()
        controller.removeFromParent()
        waypointsController = nil
        routesController.routesView.isHidden = false
    }
}

extension SYMKRoutePlannerController: SYRoutingDelegate {
    
    public func routingDidStartRouteComputing(_ routing: SYRouting) {
        guard let plannerView = view as? SYMKRoutePlannerView else { return }
        plannerView.setupRoutesView(routesController.routesView)
        routesController.routes.removeAll()
        routesController.delegate = self
    }
    
    public func routing(_ routing: SYRouting, didComputePrimaryRoute route: SYRoute?) {
        guard let route = route else { return }
        routeSelectionManager?.addMapRoute(from: route, type: .primary)
        routesController.routes.append(route)
        delegate?.routePlanner(self, didCompute: route, type: .primary)
    }
    
    public func routing(_ routing: SYRouting, didComputeAlternativeRoute route: SYRoute?) {
        guard let route = route else { return }
        routeSelectionManager?.addMapRoute(from: route, type: .alternative)
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
    
    public func routeSelection(_ manager: SYMKRouteSelectionManager, didSelect route: SYRoute) {
        routesController.switchCurrentRoute(route)
        delegate?.routePlanner(self, switch: route, alternativeRoutes: alternativeRoutes)
    }
    
    public func routeSelection(_ manager: SYMKRouteSelectionManager, didUpdate mapObjects: [SYMapObject]) {
        zoomMap()
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
        guard let routesManager = mapController?.selectionManager as? SYMKRouteSelectionManager else { return }
        routesManager.switchPrimaryRoute(selectedRoute)
    }
}

extension SYMKRoutePlannerController: SYMKRouteOptionsViewControllerDelegate {
    
    public func routeOptionsController(_ controller: SYMKRouteOptionsViewController, didUpdate options: SYRoutingOptions) {
        routingOptions = options
    }
}

extension SYMKRoutePlannerController: SYMKRouteWaypointsViewControllerDelegate {
    public func routeWaypointsController(_ controller: SYMKRouteWaypointsViewController, wantAddWaypoint block: @escaping SYMKRouteWaypointsAddBlock) {
        delegate?.routePlanner(self, wantsAddNewWaypoint: block)
    }
    
    public func routeWaypointsController(_ controller: SYMKRouteWaypointsViewController, didUpdate waypoints: [SYWaypoint]) {
        self.waypoints = waypoints
    }
    
    public func routeWaypointsControllerDidFinish(_ controller: SYMKRouteWaypointsViewController) {
        dismissWaypointsEditor()
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
        case .noLicense:
            return LS("No licence")
        }
    }
}
