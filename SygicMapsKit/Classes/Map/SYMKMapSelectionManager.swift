import Foundation
import SygicMaps
import SygicUIKit

public protocol SYMKMapSelectionDelegate: class {
    func mapController(didSelect poiData: SYMKPoiDataProtocol)
    func mapControllerDeselectAll()
}

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
    
    public weak var delegate: SYMKMapSelectionDelegate?
    public weak var mapView: SYMapView? {
        didSet {
            mapView?.addMapMarkersCluster(mapMarkersManager.clusterLayer!)
        }
    }
    public var mapSelectionMode = MapSelectionMode.all
    
    // MARK: - Private Properties
    
    private var mapMarkersManager = SYMKMapMarkersManager<SYMKMapPin>()
    private var reverseSearch = SYReverseSearch()
    
    // MARK: - Public Methods
    
    public init(with mode: MapSelectionMode) {
        mapSelectionMode = mode
        mapMarkersManager.mapObjectsManager = self
        mapMarkersManager.clusterLayer = SYMapMarkersCluster()
    }
    
    public func selectMapObjects(_ objects: [SYViewObject]) {
        guard mapSelectionMode != .none else { return }
        
        let hadPin = !mapMarkersManager.markers.isEmpty
        if hadPin {
            mapMarkersManager.removeAllMarkers()
            delegate?.mapControllerDeselectAll()
        }
        
        var viewObj: SYViewObject?
        for obj in objects {
            if let poi = obj as? SYPoiObject, poi.type == .poi, mapSelectionMode == .all {
                selectMapPoi(poi)
                return
            } else if let marker = viewObj as? SYMapMarker, mapSelectionMode == .markers {
                viewObj = marker
            } else if mapSelectionMode == .all && viewObj == nil {
                viewObj = obj
            }
        }
        
        guard !hadPin else { return }
        if let coordinate = viewObj?.coordinate {
            selectCoordinate(coordinate)
        }
    }
    
    // MARK: - Private Methods
    
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
    
    private func selectPlace(with poiData: SYMKPoiData, category: SYMKPoiCategory = SYMKPoiCategory(icon: SygicIcon.POIPoi, color: .darkGray), highlighted: Bool = true) {
        if let pin = SYMKMapPin(coordinate: poiData.coordinate, icon: category.icon, color: category.color, highlighted: highlighted) {
            mapMarkersManager.addMapMarker(pin)
            self.delegate?.mapController(didSelect: poiData)
        }
    }
}

// MARK: - Map Objects Manager

extension SYMKMapSelectionManager: SYMKMapObjectsManager {
    public func addMapObject(_ mapObject: SYMapObject) {
        mapView?.add(mapObject)
    }
    
    public func removeMapObject(_ mapObject: SYMapObject) {
        mapView?.remove(mapObject)
    }
}
