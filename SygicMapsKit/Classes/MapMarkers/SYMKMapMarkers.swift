import Foundation
import SygicMaps
import SygicUIKit

/**
 SYMKMapObjectsManager is a protocol used by SYMKMapMarkersManager to display SYMapObject in SYMapView.
 Implementing class is responsible for adding and removing SYMapObject to/from SYMapView.
 */
public protocol SYMKMapObjectsManager: class {
    func addMapObject(_ mapObject: SYMapObject)
    func removeMapObject(_ mapObject: SYMapObject)
}

/**
 Protocol for map marker class, which is used to define look of SYMapMarker displayed on map
 */
public protocol SYMKMapMarker: Equatable {
    var mapMarker: SYMapMarker { get }
    var highlighted: Bool {get set }
}

/**
 Class responsible for managment of displayed SYMKMapMarker instances. It includes adding, removing,
 hiding, clustering and highlighting SYMKMapMarkers.
 */
public class SYMKMapMarkersManager<T: SYMKMapMarker> {
    public private(set) var markers = [T]()
    public weak var mapObjectsManager: SYMKMapObjectsManager!
    public var clusterLayer: SYMapMarkersCluster? {
        willSet {
            guard let currentCluster = clusterLayer else {
                return
            }
            
            for marker in markers {
                currentCluster.removeMapMarker(marker.mapMarker)
            }
        }
        
        didSet {
            if let newCluster = clusterLayer {
                for marker in markers {
                    newCluster.addMapMarker(marker.mapMarker)
                }
            }
        }
    }
    
    public var highlightedMarker: T? {
        willSet {
            if var currentHighlighted = highlightedMarker, highlightedMarker != newValue, markers.contains(currentHighlighted) {
                currentHighlighted.highlighted = false
            }
        }
        
        didSet {
            if var newHighlighted = highlightedMarker, newHighlighted != oldValue {
                newHighlighted.highlighted = true
            }
        }
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
        
        if marker.highlighted {
            highlightMarker(marker)
        }
    }

    public func removeMapMarker(_ markerItem: T) {
        guard let markerToRemove = markers.first(where: { $0 == markerItem }) else { return }

        clusterLayer?.removeMapMarker(markerToRemove.mapMarker)
        mapObjectsManager.removeMapObject(markerToRemove.mapMarker)

        markers = markers.filter { $0 != markerItem }
        if markerItem == highlightedMarker {
            highlightedMarker = nil
        }
    }

    public func removeAllMarkers() {
        markers.forEach { removeMapMarker($0) }
    }

    public func highlightMarker(_ marker: T?) {
        if highlightedMarker == marker {
            return
        }
        
        if var currentHighlighted = highlightedMarker {
            currentHighlighted.highlighted = false
        }
        
        if var newHighlighted = marker {
            newHighlighted.highlighted = true
        }
        
        highlightedMarker = marker
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
