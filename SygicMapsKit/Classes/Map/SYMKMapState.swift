import Foundation
import SygicMaps

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
    
    public var recenterCurrentState: SYMKMapRecenterController.state {
        if cameraMovementMode == .free {
            return .free
        } else {
            if cameraRotationMode == .attitude {
                return .lockedCompass
            } else {
                return .locked
            }
        }
    }
    
    public var recenterStates: [SYMKMapRecenterController.state] {
        switch recenterCurrentState {
        case .free:
            return [.free, .locked]
        case .locked,
             .lockedCompass:
            return [.locked, .lockedCompass]
        }
    }
    
    public init() {}
}
