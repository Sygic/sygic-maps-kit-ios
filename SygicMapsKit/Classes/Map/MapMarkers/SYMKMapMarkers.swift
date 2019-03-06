//// SYMKMapMarkers.swift
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
import SygicUIKit


/// SYMKMapObjectsManager is a protocol used by SYMKMapMarkersManager to display SYMapObject in SYMapView.
/// Implementing class is responsible for adding and removing SYMapObject to/from SYMapView.
public protocol SYMKMapObjectsManager: class {
    /// responsible for adding mapObject to SYMapView. Returns true if succeeded
    func addMapObject(_ mapObject: SYMapObject) -> Bool
    ///responsible for removing mapObject from SYMapView
    func removeMapObject(_ mapObject: SYMapObject)
}


/// Protocol for map marker class, which is used to define look of SYMapMarker displayed on map
public protocol SYMKMapMarker: Equatable {
    var mapMarker: SYMapMarker { get }
    var highlighted: Bool {get set }
}

/// Class responsible for management of displayed SYMKMapMarker instances. It includes
/// adding, removing, hiding, clustering and highlighting SYMKMapMarkers.
public class SYMKMapMarkersManager<T: SYMKMapMarker> {
    
    // MARK: - Public Properties
    
    public private(set) var markers = [T]()
    public weak var mapObjectsManager: SYMKMapObjectsManager?
    public var clusterLayer: SYMapMarkersCluster? {
        willSet {
            guard let currentCluster = clusterLayer else { return }
            for marker in markers {
                currentCluster.removeMapMarker(marker.mapMarker)
            }
        }
        
        didSet {
            guard let newCluster = clusterLayer else { return }
            for marker in markers {
                newCluster.addMapMarker(marker.mapMarker)
            }
        }
    }
    
    public var highlightedMarker: T? {
        willSet {
            if var currentHighlighted = highlightedMarker, highlightedMarker != newValue, markers.contains(currentHighlighted) {
                currentHighlighted.highlighted = false
            }
        }
        
        didSet {
            if var newHighlighted = highlightedMarker, newHighlighted != oldValue {
                newHighlighted.highlighted = true
            }
        }
    }
    
    // MARK: - Public Methods
    
    public func addMapMarker(_ marker: T, at index: Int? = nil) {
        if markers.contains(marker) {
            return
        }

        if let index = index {
            markers.insert(marker, at: index)
        } else {
            markers.append(marker)
        }
        
        if let mapObjectsManager = mapObjectsManager, mapObjectsManager.addMapObject(marker.mapMarker) {
            if let cluster = clusterLayer {
                cluster.addMapMarker(marker.mapMarker)
            }
        }
        
        if marker.highlighted {
            highlightMarker(marker)
        }
    }

    public func removeMapMarker(_ markerItem: T) {
        guard let markerToRemove = markers.first(where: { $0 == markerItem }) else { return }

        clusterLayer?.removeMapMarker(markerToRemove.mapMarker)
        mapObjectsManager?.removeMapObject(markerToRemove.mapMarker)

        markers = markers.filter { $0 != markerItem }
        if markerItem == highlightedMarker {
            highlightedMarker = nil
        }
    }

    public func removeAllMarkers() {
        markers.forEach { removeMapMarker($0) }
    }

    public func highlightMarker(_ marker: T?) {
        if highlightedMarker == marker {
            return
        }
        
        if var currentHighlighted = highlightedMarker {
            currentHighlighted.highlighted = false
        }
        
        if var newHighlighted = marker {
            newHighlighted.highlighted = true
        }
        
        highlightedMarker = marker
    }
    
    // MARK: MarkersVisibilityManager
    
    public func showAllMarkers() {
        for markerItem in markers {
            markerItem.mapMarker.visibility = true
        }
    }

    public func hideAllMarkers() {
        for markerItem in markers {
            markerItem.mapMarker.visibility = false
        }
    }
    
}
