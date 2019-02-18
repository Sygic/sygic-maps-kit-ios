import SygicUIKit


/// Zoom controller manages zoom control view.
///
/// This is subclass of `SYUIZoomController` in MapsKit framework, so it can conforms to `MapControl` protocol
/// and implement `update(with SYMKMapState)` method for updating zoom controls based on map interaction.
public class SYMKZoomController: SYUIZoomController { }

extension SYMKZoomController: MapControl {
    
    func update(with mapState: SYMKMapState) {
        is3D = !mapState.isTilt3D
    }
    
}
