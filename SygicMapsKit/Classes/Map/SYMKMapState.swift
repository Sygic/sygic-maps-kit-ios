import Foundation
import SygicMaps


internal protocol MapControl {
    func update(with mapState: SYMKMapState)
}

public class SYMKMapState {
    
    public var geoCenter: SYGeoCoordinate = SYGeoCoordinate(latitude: 48.147, longitude: 17.101878)!
    public var zoom: CGFloat = 16
    public var rotation: CGFloat = 0
    public var tilt: CGFloat = 0
    
    public var cameraMovementMode: SYCameraMovement = .free
    public var cameraRotationMode: SYCameraRotation = .free
    
    public var isTilt3D: Bool {
        return tilt >= 0.01
    }

}
