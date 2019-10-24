//// SYMKMapPin.swift
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


/// Implementation of SYMKMapMarker protocol, to display SYUIPinView as markers on map.
public class SYMKMapPin: SYMKMapMarker {
    
    // MARK: - Public Properties
    
    public var pin: SYUIPinView
    public var data: SYMKPlaceDataProtocol?
    public private(set) var mapMarker: SYMapMarker
    
    public var coordinate: SYGeoCoordinate {
        return mapMarker.coordinate!
    }
    
    public var highlighted: Bool {
        didSet {
            if oldValue == highlighted {
                return
            }
            pin.isHighlighted = highlighted
            if let image = pin.imageFromView() {
                updateMarkerImage(image)
            }
        }
    }
    
    // MARK: - Public Methods
    
    public init?(coordinate: SYGeoCoordinate, icon: String = SYUIIcon.POIPoi, color: UIColor = .darkGray, highlighted: Bool = false) {
        pin = SYUIPinView(icon: icon, color: color, highlighted: highlighted, animatedHighlight: false)
        self.highlighted = highlighted
        
        guard let image = pin.imageFromView() else {
            return nil
        }

        mapMarker = SYMapMarker(coordinate: coordinate, image: image)
        updateMarkerImage(image)
    }
    
    public convenience init?(data: SYMKPlaceData, icon: String = SYUIIcon.POIPoi, color: UIColor = .darkGray, highlighted: Bool = false) {
        self.init(coordinate: data.location, icon: icon, color: color, highlighted: highlighted)
        self.data = data
    }

    public static func ==(lhs: SYMKMapPin, rhs: SYMKMapPin) -> Bool {
        return lhs === rhs
    }
    
    private func updateMarkerImage(_ image: UIImage) {
        mapMarker.image = image
        mapMarker.anchorPosition = pin.isHighlighted ? CGPoint(x: 0.5, y: 0.9) : CGPoint(x: 0.5, y: 0.5)
    }
}
