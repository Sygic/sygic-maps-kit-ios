//// SYMKMapSelectionManager.swift
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


/// Delegate of map selection actions
public protocol SYMKMapSelectionDelegate: class {
    
    /// Tells selection manager, if should mark selected place with default MapPin marker
    func mapSelectionShouldAddPoiPin() -> Bool
    
    /// Delegated method called when map selection occured (by tap gesture...)
    ///
    /// - Parameter poiData: poi data of selected place on map
    func mapSelection(didSelect poiData: SYMKPoiDataProtocol)
    
    /// Delegated method called by deselection map gesture
    func mapSelectionDeselectAll()
}

/// Map selection manager.
///
/// Defines selection behavior for provided mapView. Provides interface for managing custom pois. Defines
public class SYMKMapSelectionManager {
    
    // MARK: - Public Properties
    
    /// Map selection mode
    public enum MapSelectionMode {
        /// No selection
        case none
        /// Allows to select map markers
        case markers
        /// Allows to select anything on map
        case all
    }
    
    /// Map selection manager delegate.
    public weak var delegate: SYMKMapSelectionDelegate?
    
    /// Map view. Has to be set after SDK initialization.
    public weak var mapView: SYMapView? {
        didSet {
            setupMarkersClusterIfNeeded()
        }
    }
    
    /// Map selection mode. Default is `.all`.
    public var mapSelectionMode = MapSelectionMode.all
    
    // MARK: - Private Properties
    
    private var mapMarkersManager = SYMKMapMarkersManager<SYMKMapPin>()
    private var customMarkersManager = SYMKMapMarkersManager<SYMKMapPin>()
    private var reverseSearch = SYReverseSearch()
    
    // MARK: - Public Methods
    
    public init(with mode: MapSelectionMode, customMarkers: [SYMKMapPin]? = nil) {
        mapSelectionMode = mode
        
        mapMarkersManager.mapObjectsManager = self
        customMarkersManager.mapObjectsManager = self
        
        customMarkers?.forEach {
            addCustomPin($0)
        }
    }
    
    deinit {
        removeMarkersCluster()
    }
    
    /// Evaluates map objects from input and forwards final selection data by delegate
    ///
    /// - Parameter objects: Objects provided by SYMapView delegate when tap gesture occured
    public func selectMapObjects(_ objects: [SYViewObject]) {
        guard mapSelectionMode != .none else { return }
        
        let hadPinSelected = !mapMarkersManager.markers.isEmpty || customMarkersManager.highlightedMarker != nil
        if hadPinSelected {
            mapMarkersManager.removeAllMarkers()
            customMarkersManager.highlightedMarker = nil
        }
        
        var viewObj: SYViewObject?
        for obj in objects {
            if let poi = obj as? SYPoiObject, poi.type == .poi, mapSelectionMode == .all {
                selectMapPoi(poi)
                return
            } else if let marker = obj as? SYMapMarker {
                if let customMarker = customMarkersManager.markers.first(where: { $0.mapMarker == marker }) {
                    selectCustomMarker(customMarker)
                    return
                }
            } else if mapSelectionMode == .all && viewObj == nil {
                viewObj = obj
            }
        }
        
        if hadPinSelected {
            // deselected delegate message call only if no selection was made
            delegate?.mapSelectionDeselectAll()
        } else if let coordinate = viewObj?.coordinate {
            selectCoordinate(coordinate)
            return
        }
    }
    
    /// Adds provided pin to mapView
    ///
    /// - Parameter pin: new map pin
    public func addCustomPin(_ pin: SYMKMapPin) {
        customMarkersManager.addMapMarker(pin)
    }
    
    /// Removes provided pin from mapView
    ///
    /// - Parameter pin: pin to remove
    public func removeCustomPin(_ pin: SYMKMapPin) {
        customMarkersManager.removeMapMarker(pin)
    }
    
    // MARK: - Private Methods
    
    // MARK: - Marker Cluster
    
    private func setupMarkersClusterIfNeeded() {
        guard let mapView = mapView, mapMarkersManager.clusterLayer == nil else { return }
        let markersCluster = SYMapMarkersCluster()
        mapMarkersManager.clusterLayer = markersCluster
        customMarkersManager.clusterLayer = markersCluster
        mapView.addMapMarkersCluster(markersCluster)
    }
    
    private func removeMarkersCluster() {
        guard let markersCluster = mapMarkersManager.clusterLayer else { return }
        if let clusterMarkers = markersCluster.mapMarkers {
            mapView?.remove(clusterMarkers)
        }
        mapView?.removeMapMarkersCluster(markersCluster)
    }
    
    // MARK: - Selection
    
    private func selectMapPoi(_ poi: SYPoiObject) {
        SYPlaces.shared().loadPoiObjectPlace(poi) { [weak self] (place: SYPlace) in
            self?.selectPlace(with: SYMKPoiData(with: place), category: SYMKPoiCategory.with(syPoiCategory: place.category))
        }
    }
    
    private func selectCoordinate(_ coordinate: SYGeoCoordinate) {
        reverseSearch.reverseSearch(with: coordinate) { [weak self] results in
            guard let result = results.first else { return }
            self?.selectPlace(with: SYMKPoiData(with: result))
        }
    }
    
    private func selectPlace(with poiData: SYMKPoiData, category: SYMKPoiCategory = SYMKPoiCategory(icon: SYUIIcon.POIPoi, color: .action), highlighted: Bool = true) {
        if let delegate = delegate, delegate.mapSelectionShouldAddPoiPin(), let pin = SYMKMapPin(coordinate: poiData.coordinate, icon: category.icon, color: category.color, highlighted: highlighted) {
            mapMarkersManager.addMapMarker(pin)
        }
        delegate?.mapSelection(didSelect: poiData)
    }
    
    private func selectCustomMarker(_ mapMarker: SYMKMapPin) {
        customMarkersManager.highlightedMarker = mapMarker
        if let dataPayload = mapMarker.data {
            delegate?.mapSelection(didSelect: dataPayload)
        } else {
            delegate?.mapSelection(didSelect: SYMKPoiData(with: mapMarker.coordinate))
        }
    }
}

// MARK: - Map Objects Manager

extension SYMKMapSelectionManager: SYMKMapObjectsManager {
    
    public func addMapObject(_ mapObject: SYMapObject) -> Bool {
        guard let mapView = mapView else { return false }
        mapView.add(mapObject)
        return true
    }
    
    public func removeMapObject(_ mapObject: SYMapObject) {
        mapView?.remove(mapObject)
    }
    
}
