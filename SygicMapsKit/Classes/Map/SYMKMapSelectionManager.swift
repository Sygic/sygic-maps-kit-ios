import Foundation
import SygicMaps
import SygicUIKit

public protocol SYMKMapSelectionDelegate: class {
    func mapController(didSelect poiData: SYMKPoiDetailModel)
    func mapControllerDeselectAll()
}

public class SYMKMapSelectionManager {
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
                SYPlaces.shared().loadPoiObjectPlace(poi) { [weak self] (place: SYPlace) in
                    guard let weakSelf = self else { return }
                    let category = SYMKPoiCategory.with(syPoiCategory: place.category)
                    if let pin = SYMKMapPin(coordinate: place.coordinate, icon: category.icon, color: category.color, highlighted: true) {
                        weakSelf.mapMarkersManager.addMapMarker(pin)
                        weakSelf.delegate?.mapController(didSelect: place)
                    }
                }
                return
            } else if let marker = viewObj as? SYMapMarker, mapSelectionMode == .markers {
                viewObj = marker
            } else if mapSelectionMode == .all && viewObj == nil {
                viewObj = obj
            }
        }
        
        if hadPin {
            return
        }
        
        if let coordinate = viewObj?.coordinate {
            if let pin = SYMKMapPin(coordinate: coordinate, icon: SygicIcon.POIPoi, color: .darkGray, highlighted: true) {
                mapMarkersManager.addMapMarker(pin)
                reverseSearch.reverseSearch(with: coordinate) { [weak self] results in
                    guard let result = results.first else { return }
                    self?.delegate?.mapController(didSelect: result)
                }
            }
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
