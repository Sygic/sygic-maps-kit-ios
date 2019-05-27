//// SYMapMarkerExtension.swift
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


public extension SYMapMarker {
    
    /// Initialize SYMapMarker object with default pin image using provided icon and color. SYMKPoiData will be set as object payload.
    ///
    /// - Parameters:
    ///   - payload: serializable SYMKPoiData object that will be set as SYMapMarker payload
    ///   - icon: icon that will be displayed inside marker image
    ///   - color: color of marker image
    convenience init(with payload: SYMKPoiData, icon: String = SYUIIcon.POIPoi, color: UIColor = .action) {
        let pinView = SYUIPinView(icon: icon, color: color, highlighted: true)
        let pinImage = pinView.imageFromView()! 
        self.init(coordinate: payload.location, image: pinImage, payload: payload)
        anchorPosition = CGPoint(x: 0.5, y: 1)
    }
}
