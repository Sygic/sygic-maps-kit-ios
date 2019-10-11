//// SYMKRouteSelectionManager.swift
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

import Foundation
import SygicMaps
import SygicUIKit


/// Delegate of route selection actions
public protocol SYMKRouteSelectionDelegate: class {
    
    /// Delegated method called when map route selection occured.
    ///
    /// - Parameter route: route map object.
    func routeSelection(_ manager: SYMKRouteSelectionManager, didSelect route: SYRoute)
    
    func routeSelection(_ manager: SYMKRouteSelectionManager, didUpdate mapObjects: [SYMapObject])
}

/// Map selection manager.
///
/// Defines selection behavior for provided mapView. Provides interface for managing custom pois. Defines
public class SYMKRouteSelectionManager: SYMKMapSelectionProtocol {
    
    // MARK: - Public Properties
    
    /// Map selection mode
    public enum RouteSelectionMode {
        /// No selection
        case none
        /// Allows to select map routes
        case route
        /// Allows to select map route and route label objects
        case routeAndRouteLabel
    }
    
    /// Map selection manager delegate.
    public weak var delegate: SYMKRouteSelectionDelegate?
    
    /// Map view. Has to be set after SDK initialization.
    public weak var mapView: SYMapView?
    
    /// Map selection mode. Default is `.routeAndRouteLabel`.
    public var selectionMode = RouteSelectionMode.routeAndRouteLabel
    
    /// Map objects units
    public var units: SYUIDistanceUnits = .kilometers {
        didSet {
            updateMapObjects()
        }
    }
    
    /// Primary route
    public var primaryRoute: SYRoute?
    
    /// Alternative routes
    public var alternativeRoutes = [SYRoute]()
    
    /// Returns visible united bounding box of all map routes on mapView
    public var routesBoundingBox: SYGeoBoundingBox? {
        var boundingBox: SYGeoBoundingBox?
        if let route = primaryRoute {
            boundingBox = route.box
            for alternative in alternativeRoutes {
                if let newBox = boundingBox!.union(with: alternative.box) {
                    boundingBox = newBox
                }
            }
        }
        return boundingBox
    }
    
    // MARK: - Private Properties
    
    private var mapObjects = [SYMapObject]()
    
    // MARK: - Public Methods
    
    public init(with mode: RouteSelectionMode) {
        selectionMode = mode
    }
    
    deinit {
        removeAllMapObjects()
    }
    
    /// Evaluates map objects from input and forwards final selection data by delegate
    ///
    /// - Parameter objects: Objects provided by SYMapView delegate when tap gesture occured
    public func selectMapObjects(_ objects: [SYViewObject]) {
        guard selectionMode != .none else { return }
        
        let routeObject = objects.first { [unowned self] viewObject in
            let selection = viewObject.selectionType
            if self.selectionMode == .routeAndRouteLabel {
                return selection == .routeLabel || selection == .route
            } else if self.selectionMode == .route {
                return selection == .route
            }
            return false
        }
        
        var selectedRoute: SYRoute?
        if let mapRoute = routeObject as? SYMapRoute {
            selectedRoute = mapRoute.route
        } else if let routeLabel = routeObject as? SYMapRouteLabel {
            selectedRoute = routeLabel.route
        }
        if let route = selectedRoute {
            switchPrimaryRoute(route)
        }
    }
    
    /// Adds provided route to mapView
    /// - Parameter route: SYRoute
    /// - Parameter type: SYRouteType
    public func addMapRoute(from route: SYRoute, type: SYMapRouteType) {
        if type == .primary {
            primaryRoute = route
        } else {
            alternativeRoutes.append(route)
        }
        updateMapObjects()
    }
    
    /// Removes all routes from mapView
    public func removeAllMapRoutes() {
        primaryRoute = nil
        alternativeRoutes.removeAll()
        removeAllMapObjects()
    }
    
    /// Changes primary route and move oldPrimary to alternative routes
    /// - Parameter newPrimaryRoute: SYRoute
    public func switchPrimaryRoute(_ newPrimaryRoute: SYRoute) {
        guard let oldPrimaryRoute = primaryRoute, newPrimaryRoute != primaryRoute else { return }
        alternativeRoutes.removeAll { $0 == newPrimaryRoute }
        alternativeRoutes.append(oldPrimaryRoute)
        primaryRoute = newPrimaryRoute
        updateMapObjects()
        delegate?.routeSelection(self, didSelect: newPrimaryRoute)
    }
    
    // MARK: - Private Methods
    
    private func updateMapObjects() {
        removeAllMapObjects()
        guard let primaryRoute = primaryRoute else { return }
        addMapRoute(to: primaryRoute, primary: true)
        for route in alternativeRoutes {
            addMapRoute(to: route)
        }
        mapView?.add(mapObjects)
        delegate?.routeSelection(self, didUpdate: mapObjects)
    }
    
    private func removeAllMapObjects() {
        mapView?.remove(mapObjects)
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
}

public extension Array where Element == SYWaypoint {
    var boundingBox: SYGeoBoundingBox? {
        guard let startWP = first, count > 1 else { return nil }
        var boundingBox = SYGeoBoundingBox(bottomLeft: startWP.originalPosition, topRight: startWP.originalPosition)
        for wp in self {
            guard let newBox = boundingBox.union(with: SYGeoBoundingBox(bottomLeft: wp.originalPosition, topRight: wp.originalPosition)) else { continue }
            boundingBox = newBox
        }
        return boundingBox
    }
}
