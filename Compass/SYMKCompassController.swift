import SygicUIKit


public class SYMKCompassController: SYUICompassController, MapControl {
    
    func update(with mapState: SYMKMapState) {
        course = Double(mapState.rotation)
    }
    
}
