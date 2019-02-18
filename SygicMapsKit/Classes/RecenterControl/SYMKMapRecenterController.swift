import SygicUIKit


/// Recenter controller manages recenter button.
///
/// This is subclass of `SYUIMapRecenterController` in MapsKit framework, so it can conforms to `MapControl` protocol
/// and implement `update(with SYMKMapState)` method for updating recenter button based on map interaction.
public class SYMKMapRecenterController: SYUIMapRecenterController { }

extension SYMKMapRecenterController: MapControl {
    
    func update(with mapState: SYMKMapState) {
        allowedStates = mapState.recenterStates
        currentState = mapState.recenterCurrentState
    }
    
}

extension SYMKMapState {
    
    public var recenterCurrentState: SYUIRecenterState {
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
    
    public var recenterStates: [SYUIRecenterState] {
        switch recenterCurrentState {
        case .free:
            return [.free, .locked]
        case .locked,
             .lockedCompass:
            return [.locked, .lockedCompass]
        }
    }
    
}
