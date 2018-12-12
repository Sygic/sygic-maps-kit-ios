import SygicUIKit


public class SYMKMapRecenterController: SYUIMapRecenterController, MapControl {
    
    func update(with mapState: SYMKMapState) {
        allowedStates = mapState.recenterStates
        currentState = mapState.recenterCurrentState
    }
    
}

extension SYMKMapState {
    
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
