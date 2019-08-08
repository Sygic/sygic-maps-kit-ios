//// SYLaneExtension.swift
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


extension SYLane {
    
    func toArrowImageNames() -> [String] {
        
        if arrows.isEmpty {
            return []
        }
        
        var arrowImageNames = [String]()
        
        if arrows.contains(.left) {
            arrowImageNames.append("laneassist_left")
        }
        
        if arrows.contains(.halfLeft) {
            arrowImageNames.append("laneassist_half_left")
        }
        
        if arrows.contains(.sharpLeft) {
            arrowImageNames.append("laneassist_sharp_left")
        }
        
        if arrows.contains(.uTurnLeft) {
            arrowImageNames.append("laneassist_uturn_left")
        }
        
        if arrows.contains(.right) {
            arrowImageNames.append("laneassist_right")
        }
        
        if arrows.contains(.halfRight) {
            arrowImageNames.append("laneassist_half_right")
        }
        
        if arrows.contains(.sharpRight) {
            arrowImageNames.append("laneassist_sharp_right")
        }
        
        if arrows.contains(.uTurnRight) {
            arrowImageNames.append("laneassist_uturn_right")
        }
        
        if arrows.contains(.straight) {
            arrowImageNames.append("laneassist_straight")
        }
        
        return arrowImageNames
    }
    
}
