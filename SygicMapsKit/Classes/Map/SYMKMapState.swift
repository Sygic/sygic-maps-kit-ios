import Foundation
import SygicMaps

public struct SYMKMapState {
    var geoCenter: SYGeoCoordinate = SYGeoCoordinate(latitude: 48.147, longitude: 17.101878)!
    var zoom: CGFloat = 16
    var rotation: CGFloat = 0
    var tilt: CGFloat = 0
    
    var cameraMovementMode: SYCameraMovement = .free
    var cameraRotationMode: SYCameraRotation = .free
    
    var isTilt3D: Bool {
        return tilt >= 0.01
    }
    
    var recenterCurrentState: SYMKMapRecenterController.state {
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
    
    var recenterStates: [SYMKMapRecenterController.state] {
        switch recenterCurrentState {
        case .free:
            return [.free, .locked]
        case .locked,
             .lockedCompass:
            return [.locked, .lockedCompass]
        }
    }
}
