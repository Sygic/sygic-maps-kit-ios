import SygicUIKit


public class SYMKMapRecenterController: SYUIMapRecenterController, MapControl {
    
    func update(with mapState: SYMKMapState) {
        allowedStates = mapState.recenterStates
        currentState = mapState.recenterCurrentState
    }
    
}
