//// SYMKMapState.swift
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

import Foundation
import SygicMaps


/// Implement MapControl protocol for update components with new state based on map changes.
internal protocol MapControl {
    func update(with mapState: SYMKMapState)
}

/// Map state class holds state of map.
public class SYMKMapState: NSCopying {
    
    // MARK: - Public Properties
    
    /// Map to which a state belongs.
    ///
    /// When you pass map state between multiple modules, you can pass `SYMapView` as
    /// well, so you don't need to allocate new `SYMapView` object. You will prevent
    /// black screen, the moment while `SYMapView` is allocated.
    public var map: SYMapView?
    
    /// Center of a map
    public var geoCenter: SYGeoCoordinate = SYGeoCoordinate(latitude: 0, longitude: 0)! {
        didSet {
            if map?.geoCenter != geoCenter {
                map?.geoCenter = geoCenter
            }
        }
    }
    
    /// Zoom of a map.
    public var zoom: CGFloat = 0 {
        didSet {
            if map?.zoom != zoom {
                map?.zoom = zoom
            }
        }
    }
    
    /// Rotation of a map.
    public var rotation: CGFloat = 0 {
        didSet {
            if map?.rotation != rotation {
                map?.rotation = rotation
            }
        }
    }
    
    /// Tilt of a map.
    public var tilt: CGFloat = 0 {
        didSet {
            if map?.tilt != tilt {
                map?.tilt = tilt
            }
        }
    }
    
    /// Camera movement mode. Default is `.free`.
    public var cameraMovementMode: SYCameraMovement = .free
    
    /// Camera rotation mode. Default is `.free`.
    public var cameraRotationMode: SYCameraRotation = .free
    
    /// Returns, whether tilt is 3D or not.
    public var isTilt3D: Bool {
        return tilt >= 0.01
    }
    
    var boundingBoxSetting: SYGeoBoundingBox?
    
    /// Initializes and returns map. If map isn't already initialized, returns new map instance with defined state values.
    ///
    /// - Parameter frame: Initial frame of a map. Default is `CGRect.zero`.
    /// - Returns: Loaded `SYMapView` object.
    public func loadMap(with frame: CGRect = .zero) -> SYMapView {
        if let initializedMap = map {
            return initializedMap
        } else {
            map = SYMapView(frame: frame, geoCenter: geoCenter, rotation: rotation, zoom: zoom, tilt: tilt)
            map?.accessibilityLabel = "Map"
            return map!
        }
    }
    
    /// Sets visible map rectangle defined by parameters
    ///
    /// - Parameters:
    ///   - boundingBox: visible bounding box to be set
    ///   - edgeInsets: map edge insets around visible bounding box (in relative screen coordinates <0,1>)
    ///   - duration: map transition animation duration
    ///   - completion: completion block pass false when bounding box cannot be set or animation was canceled. True otherwise after animation was completed.
    public func setMapBoundingBox(_ boundingBox: SYGeoBoundingBox, edgeInsets: UIEdgeInsets, duration: TimeInterval = 0, completion: ((_ success: Bool)->())? = nil) {
        self.boundingBoxSetting = boundingBox
        if map?.boundingBox != boundingBox {
            map?.setViewBoundingBox(boundingBox, with: edgeInsets, duration: duration, curve: .accelerateDecelerate) { [weak self] (animId, success) in
                self?.boundingBoxSetting = nil
                completion?(success)
            }
        }
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = SYMKMapState()
        copy.map = map
        copy.geoCenter = geoCenter
        copy.zoom = zoom
        copy.rotation = rotation
        copy.tilt = tilt
        copy.cameraMovementMode = cameraMovementMode
        copy.cameraRotationMode = cameraRotationMode
        return copy
    }

}

extension SYMapView {
    
    /// Set up map with new state.
    ///
    /// - Parameter mapState: State for map.
    public func setup(with mapState: SYMKMapState) {
        guard mapState.boundingBoxSetting == nil else { return }
        geoCenter = mapState.geoCenter
        zoom = mapState.zoom
        rotation = mapState.rotation
        tilt = mapState.tilt
        cameraMovementMode = mapState.cameraMovementMode
        cameraRotationMode = mapState.cameraRotationMode
    }
    
}
