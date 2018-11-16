import Foundation
import SygicMaps
import SygicUIKit

/*
 SYMKMapObjectsManager is a protocol used by SYMKMapMarkersManager to add/remove SYMapObject to/from SYMapView.
 */
public protocol SYMKMapObjectsManager: class {
    func addMapObject(_ mapObject: SYMapObject)
    func removeMapObject(_ mapObject: SYMapObject)
}

/*
 Protocol for map markers classes
 */
public protocol SYMKMapMarker: Equatable{
    var mapMarker: SYMapMarker { get }
    func highlight(_ highlight: Bool)
}

/*
 
 */
public class SYMKMapMarkersManager<T: SYMKMapMarker> {
    public private(set) var markers = [T]()
    public var clusterLayer: SYMapMarkersCluster? {
        willSet {
            guard let old = clusterLayer else {
                return
            }
            
            for marker in markers {
                old.removeMapMarker(marker.mapMarker)
            }
        }
        
        didSet {
            if let new = clusterLayer {
                for marker in markers {
                    new.addMapMarker(marker.mapMarker)
                }
            }
        }
    }
        
    private weak var mapObjectsManager: SYMKMapObjectsManager!
    private var highlighted: T?
    
    public init(with mapObjectsManager: SYMKMapObjectsManager) {
        self.mapObjectsManager = mapObjectsManager
    }
    
    public func addMapMarker(_ marker: T, at index: Int? = nil) {
        if markers.contains(marker) {
            return
        }

        if let index = index {
            markers.insert(marker, at: index)
        } else {
            markers.append(marker)
        }
        
        mapObjectsManager.addMapObject(marker.mapMarker)
        
        if let cluster = clusterLayer {
            cluster.addMapMarker(marker.mapMarker)
        }
    }

    public func removeMapMarker(_ markerItem: T) {
        guard let markerToRemove = markers.first(where: { $0 == markerItem }) else { return }

        clusterLayer?.removeMapMarker(markerToRemove.mapMarker)
        mapObjectsManager.removeMapObject(markerToRemove.mapMarker)

        markers = markers.filter { $0 != markerItem }
    }

    public func removeAllMarkers() {
        markers.forEach { removeMapMarker($0) }
    }
    
    public func findMarker(for mapMarker: SYMapMarker) -> T? {
        for marker in markers {
            if marker.mapMarker === mapMarker {
                return marker
            }
        }
        
        return nil
    }

    public func highlightMarker(_ marker: T?) {
        if let old = highlighted {
            old.highlight(false)
        }
        
        if let new = marker {
            new.highlight(true)
            highlighted = new
        }
    }
    
// MARK: - MarkersVisibilityManager
    public func showAllMarkers() {
        for markerItem in markers {
            markerItem.mapMarker.visibility = true
        }
    }

    public func hideAllMarkers() {
        for markerItem in markers {
            markerItem.mapMarker.visibility = false
        }
    }
}
