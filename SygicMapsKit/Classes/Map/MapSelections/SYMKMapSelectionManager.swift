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


public protocol SYMKMapSelectionProtocol: class {
    var mapView: SYMapView? { get set }
    func selectMapObjects(_ objects: [SYViewObject])
    func addCustomMarker(_ marker: SYMapMarker)
    func removeCustomMarker(_ marker: SYMapMarker)
}

public extension SYMKMapSelectionProtocol {
    func addCustomMarker(_ marker: SYMapMarker) {}
    func removeCustomMarker(_ marker: SYMapMarker) {}
}

/// Delegate of map selection actions
public protocol SYMKMapSelectionDelegate: class {
    
    /// Delegated method called when data are received.
    ///
    /// - Parameter poiData: poi data of selected place on map.
    func mapSelection(didSelect poiData: SYMKPlaceDataProtocol)
    
    /// Informs delegate that map selection will select data in `mapSelection(didSelect poiData: SYMKPoiDataProtocol)` call.
    func mapSelectionWillSelectData(_ mapSelection: SYMKMapSelectionManager)
    
    /// Delegate method that asks for pin added to map.
    ///
    /// - Parameter coordinates: Pin coordinatss.
    /// - Returns: Pin added on map. Return nil for no pin.
    func mapSelectionShouldAddMarkerToMap(location: SYGeoCoordinate) -> SYMapMarker?
    
    /// Delegate method called when map selection occured (by tap gesture).
    ///
    /// - Parameters:
    ///   - selectionType: Type of object tapped on.
    ///   - location: Map coordinates tapped on.
    /// - Returns: Returns if data should be processed and returned in `mapSelection(didSelect poiData: SYMKPoiDataProtocol)` method.
    func mapSelectionDidTapOnMap(selectionType: SYMKSelectionType, location: SYGeoCoordinate) -> Bool
    
    /// Asks delegate if poi detail was shown.
    ///
    /// - Returns: If poi detail was shown.
    func mapSelectionPoiDetailWasShown() -> Bool
}

/// Map selection manager.
///
/// Defines selection behavior for provided mapView. Provides interface for managing custom pois. Defines
public class SYMKMapSelectionManager: SYMKMapSelectionProtocol {
    
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
    
    private var reverseSearch = SYReverseSearch()
    private var defaultMarker: SYMapMarker?
    private var markersCluster: SYMapMarkersCluster?
    
    // MARK: - Public Methods
    
    public init(with mode: MapSelectionMode, customMarkers: [SYMapMarker]? = nil) {
        mapSelectionMode = mode
        
        customMarkers?.forEach {
            addCustomMarker($0)
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
        
        let firstCoordinateObject = objects.first { $0.coordinate != nil }
        guard let firstObject = firstCoordinateObject else { return }
        guard let objectCoordinates = firstObject.coordinate else { return }
        
        let pinWasShown = defaultMarker != nil
        let poiDetailWasShown = delegate?.mapSelectionPoiDetailWasShown()
        
        if let markerShown = defaultMarker {
            mapView?.remove(markerShown)
            defaultMarker = nil
        }
        
        let shouldProcess = delegate?.mapSelectionDidTapOnMap(selectionType: firstObject.selectionType, location: objectCoordinates)
        
        if mapSelectionMode == .markers {
            guard firstObject.selectionType == .marker else { return }
            if let processData = shouldProcess, processData == true {
                selectViewObject(firstObject)
            }
        } else if mapSelectionMode == .all {
            if firstObject.selectionType != .marker {
                if (!pinWasShown && !poiDetailWasShown!) || firstObject.selectionType == .poi {
                    if let marker = delegate?.mapSelectionShouldAddMarkerToMap(location: objectCoordinates) {
                        defaultMarker = marker
                        mapView?.add(marker)
                    }
                }
            }
            if let processData = shouldProcess, processData == true {
                if let poiDetailWasShown = poiDetailWasShown {
                    if !poiDetailWasShown && !pinWasShown {
                        selectViewObject(firstObject)
                    } else if poiDetailWasShown && (firstObject.selectionType == .poi || firstObject.selectionType == .marker) {
                        selectViewObject(firstObject)
                    }
                }
            }
        }
    }
    
    /// Adds provided pin to mapView
    ///
    /// - Parameter pin: new map pin
    public func addCustomMarker(_ marker: SYMapMarker) {
        mapView?.add(marker)
    }
    
    /// Removes provided pin from mapView
    ///
    /// - Parameter pin: pin to remove
    public func removeCustomMarker(_ marker: SYMapMarker) {
        mapView?.remove(marker)
    }
    
    // MARK: - Private Methods
    
    // MARK: - Marker Cluster
    
    private func setupMarkersClusterIfNeeded() {
        guard let mapView = mapView, markersCluster == nil else { return }
        markersCluster = SYMapMarkersCluster()
        mapView.addMapMarkersCluster(markersCluster!)
    }
    
    private func removeMarkersCluster() {
        guard let markersCluster = markersCluster else { return }
        if let markers = markersCluster.mapMarkers {
            mapView?.remove(markers)
        }
        mapView?.removeMapMarkersCluster(markersCluster)
    }
    
    // MARK: - Selection
    
    private func selectViewObject(_ object: SYViewObject) {
        delegate?.mapSelectionWillSelectData(self)
        if let poi = object as? SYProxyPlace, poi.type == .poi, mapSelectionMode == .all {
            selectMapPoi(poi)
        } else if let marker = object as? SYMapMarker {
            selectCustomMarker(marker)
        } else if mapSelectionMode == .all {
            selectCoordinate(object.coordinate!)
        }
    }
    
    private func selectMapPoi(_ proxyPlace: SYProxyPlace) {
        SYProxyObjectsManager.loadPlaceLink(from: proxyPlace) { [weak self] (link, _) in
            guard let link = link else { return }
            SYPlacesManager.sharedPlaces().loadPlace(link, withCompletion: { (place, _) in
                guard let place = place else { return }
                self?.selectPlace(with: SYMKPlaceData(with: place), category: SYMKPlaceCategory.with(sdkPlaceCategory: place.category))
            })
        }
    }
    
    private func selectCoordinate(_ coordinate: SYGeoCoordinate) {
        reverseSearch.reverseSearch(with: coordinate, withFilter: nil) { [weak self] (results, _) in
            guard let result = results?.first else { return }
            self?.selectPlace(with: SYMKPlaceData(with: result))
        }
    }
    
    private func selectPlace(with poiData: SYMKPlaceData, category: SYMKPlaceCategory = SYMKPlaceCategory(icon: SYUIIcon.POIPoi, color: .action), highlighted: Bool = true) {
        delegate?.mapSelection(didSelect: poiData)
    }
    
    private func selectCustomMarker(_ mapMarker: SYMapMarker) {
        if let dataPayload = mapMarker.payload as? SYMKPlaceDataProtocol {
            delegate?.mapSelection(didSelect: dataPayload)
        } else if let location = mapMarker.coordinate {
            let poiData = SYMKPlaceData(with: location)
            poiData.customData = mapMarker.payload
            delegate?.mapSelection(didSelect: poiData)
        }
    }
}
