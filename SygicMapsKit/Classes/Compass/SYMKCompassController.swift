import SygicUIKit


/// Compass controller manages compass view.
///
/// This is subclass of `SYUICompassController` in MapsKit framework, so it can conforms to `MapControl` protocol
/// and implement `update(with SYMKMapState)` method for updating compass based on map interaction.
public class SYMKCompassController: SYUICompassController { }

extension SYMKCompassController: MapControl {
    
    func update(with mapState: SYMKMapState) {
        course = Double(mapState.rotation)
    }
    
}
