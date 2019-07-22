//// SYManeuverExtensions.swift
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


/// Maneuver extensions for mapping arrow directions to vector images from assets catalog.
public extension SYManeuver {
    
    @objc func toImage() -> String {
        return type.toImage()
    }
    
}

public extension SYManeuverExit {
    
    override func toImage() -> String {
        return exitType.toImage()
    }
    
}

public extension SYManeuverRoundabout {
    
    override func toImage() -> String {
        return roundaboutType.toImage()
    }
    
}

public extension SYManeuverType {
    
    func toImage() -> String {
        switch self {
        case .none:
            return ""
        case .start, .end, .via:
            return "direction_start_via_end"
        case .easyLeft:
            return "direction_easy_left"
        case .easyRight:
            return "direction_easy_right"
        case .keepLeft:
            return "direction_keep_left"
        case .keepRight:
            return "direction_keep_right"
        case .left:
            return "direction_left"
        case .right, .outOfRoute:
            return "direction_right"
        case .sharpLeft:
            return "direction_sharp_left"
        case .sharpRight:
            return "direction_sharp_right"
        case .straight, .follow:
            return "direction_follow"
        case .uTurnLeft:
            return "direction_uturn_left"
        case .uTurnRight:
            return "direction_uturn_right"
        case .ferry:
            return "direction_ferry"
        case .stateBoundary:
            return "state_boundary"
        case .motorway:
            return "direction_motorway"
        case .tunnel:
            return "direction_tunnel"
        case .roundabout, .exit:
            return ""
        }
    }
    
}

public extension SYRoundaboutType {
    
    func toImage() -> String {
        switch self {
        case .SE:
            return "direction_rb_se"
        case .E:
            return "direction_rb_e"
        case .NE:
            return "direction_rb_ne"
        case .N:
            return "direction_rb_n"
        case .NW:
            return "direction_rb_nw"
        case .W:
            return "direction_rb_w"
        case .SW:
            return "direction_rb_sw"
        case .S:
            return "direction_rb_s"
        case .leftSE:
            return "direction_rb_l_se"
        case .leftE:
            return "direction_rb_l_e"
        case .leftNE:
            return "direction_rb_l_ne"
        case .leftN:
            return "direction_rb_l_n"
        case .leftNW:
            return "direction_rb_l_nw"
        case .leftW:
            return "direction_rb_l_w"
        case .leftSW:
            return "direction_rb_l_sw"
        case .leftS:
            return "direction_rb_l_s"
        }
    }
    
}

public extension SYExitType {
    
    func toImage() -> String {
        switch self {
        case .left:
            return "direction_exit_left"
        case .right:
            return "direction_exit_right"
        }
    }
    
}
