//// SYMKSpeedController.swift
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
import SygicUIKit


/// Controller for current speed and speed limit.
public class SYMKSpeedController {
    
    public init() { }
    
    /// Speed controllers view.
    public let view = SYUISpeedControlView()
    
    /// Updates current speed.
    public var currentSpeed = 0 {
        didSet {
            view.updateCurrentSpeed(with: currentSpeed)
        }
    }
    
    /// Updates speed limit and type of speed limit.
    /// - Parameter speedLimit: Speed limit info.
    public func update(with speedLimit: SYSpeedLimit?) {
        guard let speedLimit = speedLimit else {
            view.updateSpeedLimit(with: 0, isAmerica: false)
            return
        }
        view.updateSpeedLimit(with: Int(speedLimit.speedLimit), isAmerica: speedLimit.country == .america)
    }
    
}
