//// SYMKLaneAssistController.swift
//
// Copyright (c) 2019 Sygic a.s.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import SygicMaps


/// Controller that manages lanes instruction information.
public class SYMKLaneAssistController {
    
    public let view = SYMKLaneAssistView()
    
    /// Update lanes assistance information.
    ///
    /// - Parameter lanesInfo: SDK lanes information.
    public func update(with lanesInfo: SYLaneInfo?) {
        guard let lanesInfo = lanesInfo, lanesInfo.isActive, !lanesInfo.simpleLaneInformation.isEmpty else {
            view.updateLaneArrows([])
            view.isHidden = true
            return
        }
        var lanes = [(arrows: [String], highlighted: Bool)]()
        for lane in lanesInfo.simpleLaneInformation {
            let arrowImageNames = lane.toArrowImageNames()
            lanes.append((arrows: arrowImageNames, highlighted: lane.highlighted))
        }
        
        view.updateLaneArrows(lanes.reversed())
        view.isHidden = false
    }
    
}
