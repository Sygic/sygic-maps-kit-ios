import Foundation
import SygicMaps


internal protocol MapControl {
    func update(with mapState: SYMKMapState)
}

public class SYMKMapState: NSCopying {
    
    public var map: SYMapView?
    public var geoCenter: SYGeoCoordinate = SYGeoCoordinate(latitude: 0, longitude: 0)!
    public var zoom: CGFloat = 0
    public var rotation: CGFloat = 0
    public var tilt: CGFloat = 0
    
    public var cameraMovementMode: SYCameraMovement = .free
    public var cameraRotationMode: SYCameraRotation = .free
    
    public var isTilt3D: Bool {
        return tilt >= 0.01
    }
    
    public func loadMap(with frame: CGRect = .zero) -> SYMapView {
        if let initializedMap = map {
            return initializedMap
        } else {
            map = SYMapView(frame: frame, geoCenter: geoCenter, rotation: rotation, zoom: zoom, tilt: tilt)
            map?.accessibilityLabel = "Map"
            return map!
        }
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = SYMKMapState()
        copy.map = map
        copy.geoCenter = geoCenter
        copy.zoom = zoom
        copy.rotation = rotation
        copy.tilt = tilt
        copy.cameraMovementMode = cameraMovementMode
        copy.cameraRotationMode = cameraRotationMode
        return copy
    }

}

extension SYMapView {
    
    func setup(with mapState: SYMKMapState) {
        geoCenter = mapState.geoCenter
        zoom = mapState.zoom
        rotation = mapState.rotation
        tilt = mapState.tilt
        cameraMovementMode = mapState.cameraMovementMode
        cameraRotationMode = mapState.cameraRotationMode
    }
    
}
