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
    func routeSelection(didSelect route: SYRoute)
    
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
    public weak var mapView: SYMapView? {
        didSet {
//            setupMarkersClusterIfNeeded()
        }
    }
    
    /// Map selection mode. Default is `.routeAndRouteLabel`.
    public var selectionMode = RouteSelectionMode.routeAndRouteLabel
    
    // MARK: - Private Properties
    
    private var reverseSearch = SYReverseSearch()
    private var defaultMarker: SYMapMarker?
    private var markersCluster: SYMapMarkersCluster?
    
    // MARK: - Public Methods
    
    public init(with mode: RouteSelectionMode) {
        selectionMode = mode
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
        
        if let route = routeObject as? SYMapRoute {
            delegate?.routeSelection(didSelect: route.route)
        } else if let routeLabel = routeObject as? SYMapRouteLabel {
            delegate?.routeSelection(didSelect: routeLabel.route)
        }
    }
}
