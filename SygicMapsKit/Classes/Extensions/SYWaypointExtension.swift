//// SYWaypointExtension.swift
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


public extension SYWaypoint {
    static var currentLocationIdentifier: String {
        LS("Current location")
    }
    
    static func currentLocationWaypoint() -> SYWaypoint? {
        guard let location = SYPosition.lastKnownLocation()?.coordinate else { return nil }
        return SYWaypoint(position: location, type: .start, name: SYWaypoint.currentLocationIdentifier)
    }
    
    var isCurrentLocationWaypoint: Bool {
        return name == SYWaypoint.currentLocationIdentifier
    }
}

extension Array where Element == SYWaypoint {
    func waypointsWithTypeCorrection() -> [SYWaypoint] {
        var fixed = [SYWaypoint]()
        for (index, wp) in enumerated() {
            var type: SYWaypointType = .via
            if index == 0 {
                type = .start
            } else if index == count-1 {
                type = .end
            }
            fixed.append(SYWaypoint(position: wp.originalPosition, type: type, name: wp.name))
        }
        return fixed
    }
}
