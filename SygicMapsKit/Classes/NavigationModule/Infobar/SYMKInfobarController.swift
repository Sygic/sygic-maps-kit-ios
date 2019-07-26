//// SYMKInfobarController.swift
//
// Copyright (c) 2019 - Sygic a.s.
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

import Foundation
import SygicMaps
import SygicUIKit


/// Predefined
public enum SYMKInfobarItemType {
    case estimatedTimeOfArrival(_ value: TimeInterval?)
    case remainingTime(_ value: TimeInterval?)
    case remainingDistance(_ value: UInt)
    case currentSpeed(_ value: SYSpeed)
    case altitude(_ value: Double)
    case custom(_ value: Any? = nil)
}

public protocol SYMKInfobarItem {
    var type: SYMKInfobarItemType { get }
    var view: UIView { get }
    func update(with valueType: SYMKInfobarItemType)
}


public class SYMKInfobarController {
    
    // MARK: - Public Properties
    
    /// Max 3
    public var items: [SYMKInfobarItem] = [] {
        didSet {
            infobarView.items = items.map { $0.view }
        }
    }
    
    /// Max 3
    public var secondaryItems: [SYMKInfobarItem] = [] {
        didSet {
            infobarView.secondaryItems = secondaryItems.map { $0.view }
        }
    }
    
    public let infobarView = SYUIInfobarView()
    
    // MARK: - Public Methods
    
    public init() {
        items.append(SYMKRemainingTimeInfobarItem())
        secondaryItems.append(SYMKRemainingDistanceInfobarItem())
        secondaryItems.append(SYMKAltitudeInfobarItem())
        secondaryItems.append(SYMKEtaInfobarItem())
        infobarView.items = items.map { $0.view }
        infobarView.secondaryItems = secondaryItems.map { $0.view }
    }
    
    public func updateRouteInfo(_ info: SYOnRouteInfo) {
        updateItemView(of: .remainingTime(info.timeToEndWithSpeedProfileAndTraffic))
        updateItemView(of: .estimatedTimeOfArrival(info.timeToEndWithSpeedProfileAndTraffic))
        updateItemView(of: .remainingDistance(info.distanceToEnd))
    }
    
    public func updatePositionInfo(_ info: SYPositionInfo) {
        guard let position = SYPositioning.shared().lastKnownLocation else { return }
        if let altitude = position.coordinate?.altitude {
            updateItemView(of: .altitude(altitude))
        }
        updateItemView(of: .currentSpeed(position.speed))
    }
    
    // MARK: - Private Methods
    
    private func updateItemView(of type: SYMKInfobarItemType) {
        for item in items {
            item.update(with: type)
        }
        for item in secondaryItems {
            item.update(with: type)
        }
    }
}
