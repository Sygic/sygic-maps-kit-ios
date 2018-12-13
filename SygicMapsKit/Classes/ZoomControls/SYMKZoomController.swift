import SygicUIKit


public class SYMKZoomController: SYUIZoomController, MapControl {

    func update(with mapState: SYMKMapState) {
        is3D = !mapState.isTilt3D
    }
    
}
