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
    
    // MARK: - Public Properties
    
    /// Speed controllers view.
    public var view: SYUISpeedControlView?
    
    /// Updates current speed.
    public var currentSpeed: Double = 0 {
        didSet {
            var speeding = false
            if let speedLimit = actualSpeedLimit {
                speeding = currentSpeed > speedLimit*speedingTreshold
            }
            let formattedSpeed = SYUIGeneralFormatter.format(currentSpeed, from: .kilometers, to: units)
            view?.updateCurrentSpeed(with: Int(formattedSpeed), speeding: speeding)
        }
    }
    
    /// Speed treshold multiplier when speeding apperence should change
    public var speedingTreshold: Double = 1.06
    
    /// Distance units shown in distance labels
    public var units: SYUIDistanceUnits = .kilometers {
        didSet {
            view?.updateUnits(units)
        }
    }
    
    // MARK: - Private Properties
    
    private var actualSpeedLimit: Double?
    
    // MARK: - Public Methods
    
    public init(currentSpeed: Bool, speedLimit: Bool) {
        view = SYUISpeedControlView(currentSpeed: currentSpeed, speedLimit: speedLimit)
    }
    
    /// Updates speed limit and type of speed limit.
    ///
    /// - Parameter speedLimit: Speed limit info.
    public func update(with speedLimit: SYSpeedLimit?) {
        guard let speedLimit = speedLimit else {
            actualSpeedLimit = nil
            view?.updateSpeedLimit(with: 0, isAmerica: false)
            return
        }
        actualSpeedLimit = speedLimit.speedLimit
        view?.updateSpeedLimit(with: Int(speedLimit.speedLimit), isAmerica: speedLimit.country == .america)
    }
    
    /// Setup timer for update speed every second based on sdk last known location.
    public func setupSpeedUpdater() {
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let weakSelf = self else {
                timer.invalidate()
                return
            }
            guard timer.isValid else { return }
            guard let speed = SYPositioning.shared().lastKnownLocation?.speed else { return }
            weakSelf.currentSpeed = speed
        }
    }
    
}
