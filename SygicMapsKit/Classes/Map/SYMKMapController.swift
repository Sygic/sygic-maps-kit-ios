import SygicMaps
import SygicUIKit

public protocol SYMKMapViewControllerDelegate: class {
    func mapController(_ controller: SYMKMapController, didUpdate mapState: SYMKMapState, on mapView: SYMapView)
    func mapControllerWantsView(for annotation: SYAnnotation) -> SYAnnotationView
}

public class SYMKMapController: NSObject {
    
    public weak var delegate: SYMKMapViewControllerDelegate?
    public var selectionManager: SYMKMapSelectionManager? {
        didSet {
            selectionManager?.mapView = mapView
        }
    }
    public private(set) var mapState: SYMKMapState
    public private(set) var mapView: SYMapView
    
    public enum ZoomActionType: CGFloat {
        case zoomIn = 1
        case zoomOut = -1
    }
    
    public enum Tilt: CGFloat {
        case _2D = 0.0
        case _3D = 80.0
    }
    
    public init(with mapState: SYMKMapState, mapFrame: CGRect = .zero) {
        mapView = mapState.loadMap(with: mapFrame)
        mapView.cameraRotationMode = mapState.cameraRotationMode
        mapView.cameraMovementMode = mapState.cameraMovementMode
        self.mapState = mapState
        
        super.init()
        
        mapView.delegate = self
    }
    
    // MARK: - Private Methods
    
    private func rotateMapNorth() {
        let rotationAngle = mapView.rotation < 180.0 ? -mapView.rotation : 360.0 - mapView.rotation
        mapView.rotateView(rotationAngle, withDuration: 0.2, curve: .decelerate, completion: nil)
    }
    
    private func zoomMap(_ zoomAction: ZoomActionType) {
        mapView.animate({ [unowned self] in
            self.mapView.zoom += zoomAction.rawValue
        }, withDuration: 0.3, curve: .linear, completion: nil)
    }
    
    private func toggleTilt() {
        let isActual3D = mapView.tilt >= 0.01
        let newTilt = isActual3D ? Tilt._2D : Tilt._3D
        
        mapView.animate({
            self.mapView.tilt = newTilt.rawValue
        }, withDuration: 0.2, curve: .decelerate, completion: nil)
    }
}

// MARK: - Map delegate

extension SYMKMapController: SYMapViewDelegate {
    
    public func mapView(_ mapView: SYMapView, didChangeCameraPosition geoCenter: SYGeoCoordinate, zoom: CGFloat, rotation: CGFloat, tilt: CGFloat) {
        mapState.geoCenter = geoCenter
        mapState.zoom = zoom
        mapState.rotation = rotation
        mapState.tilt = tilt
        
        delegate?.mapController(self, didUpdate: mapState, on: mapView)
    }
    
    public func mapView(_ mapView: SYMapView, didChangeCameraMovementMode mode: SYCameraMovement) {
        if mode == .free {
            mapView.cameraRotationMode = .free
        }
        mapState.cameraMovementMode = mode
        delegate?.mapController(self, didUpdate: mapState, on: mapView)
    }
    
    public func mapView(_ mapView: SYMapView, didChangeCameraRotationMode mode: SYCameraRotation) {
        mapState.cameraRotationMode = mode
        delegate?.mapController(self, didUpdate: mapState, on: mapView)
    }
    
    public func mapView(_ mapView: SYMapView, didSelect objects: [SYViewObject]) {
        selectionManager?.selectMapObjects(objects)
    }
    
    public func mapView(_ mapView: SYMapView, viewFor annotation: SYAnnotation) -> SYAnnotationView {
        guard let delegate = delegate else { return SYAnnotationView(frame: .zero) }
        return delegate.mapControllerWantsView(for: annotation)
    }
    
}

// MARK: - Compass Delegate

extension SYMKMapController: SYUICompassDelegate {
    public func compassDidTap(_ compass: SYUICompass) {
        if mapView.cameraMovementMode != .free {
            mapView.cameraRotationMode = .free
        }
        rotateMapNorth()
    }
}

// MARK: - Map Recenter delegate

extension SYMKMapController: SYUIMapRecenterDelegate {
    public func didChangeRecenterButtonState(button: SYUIActionButton, state: SYMKMapRecenterController.state) {
        switch state {
        case .locked:
            mapView.cameraMovementMode = .followGpsPositionWithAutozoom
            if mapView.cameraRotationMode == .attitude {
                mapView.cameraRotationMode = .free
                rotateMapNorth()
            }
        case .lockedCompass:
            mapView.cameraMovementMode = .followGpsPositionWithAutozoom
            mapView.cameraRotationMode = .attitude
        default:
            break
        }
    }
}

// MARK: - Zoom buttons Delegate

extension SYMKMapController: SYUIZoomControllerDelegate {
    public func zoomController(wants activity: SYUIZoomActivity) {
        switch activity {
        case .zoomIn, .zoomingIn:
            zoomMap(.zoomIn)
        case .zoomOut, .zoomingOut:
            zoomMap(.zoomOut)
        case .toggle3D:
            toggleTilt()
        default:
            break
        }
    }
}
