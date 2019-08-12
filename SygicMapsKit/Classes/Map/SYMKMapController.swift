//// SYMKMapController.swift
//
// Copyright (c) 2019 - Sygic a.s.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the &quot;Software&quot;), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import SygicMaps
import SygicUIKit


/// Map controller delegate.
public protocol SYMKMapControllerDelegate: class {
    
    /// Informs delegate that map has updated with new state.
    ///
    /// - Parameters:
    ///   - controller: Map controller.
    ///   - mapState: New state of map.
    func mapController(_ controller: SYMKMapController, didUpdate mapState: SYMKMapState)
    
    /// Map controller needs `SYAnnotationView` from its delegate, so it
    /// can draw view on map for an annotation.
    ///
    /// - Parameter annotation: Annotation that needs `SYAnnotationView`.
    /// - Returns: `SYAnnotationView` to be drawn on map.
    func mapControllerWantsView(for annotation: SYAnnotation) -> SYAnnotationView
}

public extension SYMKMapControllerDelegate {
    func mapControllerWantsView(for annotation: SYAnnotation) -> SYAnnotationView {
        return SYAnnotationView()
    }
}

/// Controller that managing map view.
public class SYMKMapController: NSObject {
    
    // MARK: - Public Properties
    
    /// Map controller delegate.
    public weak var delegate: SYMKMapControllerDelegate?
    /// Selection manager for map.
    public var selectionManager: SYMKMapSelectionManager? {
        didSet {
            selectionManager?.mapView = mapView
        }
    }
    /// State of map.
    public private(set) var mapState: SYMKMapState
    /// View with map.
    public private(set) var mapView: SYMapView
    
    // MARK: - Private Properties
    
    private enum ZoomActionType: CGFloat {
        case zoomIn = 1
        case zoomOut = -1
    }
    
    private enum Tilt: CGFloat {
        case _2D = 0.0
        case _3D = 80.0
    }
    
    // MARK: - Public Methods
    
    public init(with mapState: SYMKMapState, mapFrame: CGRect = .zero) {
        mapView = mapState.loadMap(with: mapFrame)
        mapView.camera.rotationMode = mapState.cameraRotationMode
        mapView.camera.movementMode = mapState.cameraMovementMode
        self.mapState = mapState
        
        super.init()
        
        mapView.delegate = self
    }
    
    // MARK: - Private Methods
    
    private func rotateMapNorth() {
        let rotation = mapView.camera.rotation
        let rotationAngle = rotation < 180.0 ? -rotation : 360.0 - rotation
        mapView.camera.rotateView(rotationAngle, withDuration: 0.2, curve: .decelerate, completion: nil)
    }
    
    private func zoomMap(_ zoomAction: ZoomActionType) {
        mapView.camera.animate({ [unowned self] in
            self.mapView.camera.zoom += zoomAction.rawValue
        }, withDuration: 0.3, curve: .linear, completion: nil)
    }
    
    private func toggleTilt() {
        let isActual3D = mapView.camera.tilt >= 0.01
        let newTilt = isActual3D ? Tilt._2D : Tilt._3D
        
        mapView.camera.animate({
            self.mapView.camera.tilt = newTilt.rawValue
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
        
        delegate?.mapController(self, didUpdate: mapState)
    }
    
    public func mapView(_ mapView: SYMapView, didChangeCameraMovementMode mode: SYCameraMovement) {
        if mode == .free {
            mapView.camera.rotationMode = .free
        }
        mapState.cameraMovementMode = mode
        delegate?.mapController(self, didUpdate: mapState)
    }
    
    public func mapView(_ mapView: SYMapView, didChangeCameraRotationMode mode: SYCameraRotation) {
        mapState.cameraRotationMode = mode
        delegate?.mapController(self, didUpdate: mapState)
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
        if mapView.camera.movementMode != .free {
            mapView.camera.rotationMode = .free
        }
        rotateMapNorth()
    }
    
}

// MARK: - Map Recenter delegate

extension SYMKMapController: SYUIMapRecenterDelegate {
    
    public func didChangeRecenterButtonState(button: SYUIActionButton, state: SYUIRecenterState) {
        switch state {
        case .locked:
            mapView.camera.movementMode = .followGpsPositionWithAutozoom
            if mapView.camera.rotationMode == .attitude {
                mapView.camera.rotationMode = .free
                rotateMapNorth()
            }
        case .lockedCompass:
            mapView.camera.movementMode = .followGpsPositionWithAutozoom
            mapView.camera.rotationMode = .attitude
        default:
            break
        }
    }
    
}

// MARK: - Zoom buttons Delegate

extension SYMKMapController: SYUIZoomControllerDelegate {
    public func zoomController(_ controller: SYUIZoomController, wants activity: SYUIZoomActivity) {
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
