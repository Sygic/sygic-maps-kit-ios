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


/// Predefined types of informations appearing inside infobar
public enum SYMKInfobarItemType {
    /// Estimated time of arrival computed with current speed and traffic on route
    case estimatedTimeOfArrival(_ value: Date)
    /// Remaining time to the end of route
    case remainingTime(_ value: TimeInterval?)
    /// Remaining distance to the end of route
    case remainingDistance(_ value: UInt)
    /// Current driving speed
    case currentSpeed(_ value: SYSpeed)
    /// Altitude of current location
    case altitude(_ value: Double)
    /// Custom undefined item
    case custom
}

/// Protocol for infobar items
public protocol SYMKInfobarItem {
    var type: SYMKInfobarItemType { get }
    var view: UIView { get }
    func update(with valueType: SYMKInfobarItemType)
}


/// Controls infobar view, presented informations and updating items.
public class SYMKInfobarController {
    
    // MARK: - Public Properties
    
    /// Primary infobar items presented in first row. Infobar shows max 3 items by default.
    public var items: [SYMKInfobarItem] = [] {
        didSet {
            infobarView.items = items.map { $0.view }
        }
    }
    
    /// Secondary infobar items presented in second row. Infobar shows max 3 items by default.
    public var secondaryItems: [SYMKInfobarItem] = [] {
        didSet {
            infobarView.secondaryItems = secondaryItems.map { $0.view }
        }
    }
    
    /// InfobarView
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
    
    /// Updates infobar items with route info data
    /// - Parameter info: route info
    public func updateRouteInfo(_ info: SYOnRouteInfo) {
        updateItemView(of: .remainingTime(info.timeToEndWithSpeedProfileAndTraffic))
        updateItemView(of: .estimatedTimeOfArrival(Date(timeIntervalSinceNow: info.timeToEndWithSpeedProfileAndTraffic)))
        updateItemView(of: .remainingDistance(info.distanceToEnd))
    }
    
    /// Updates infobar items with position data
    /// - Parameter info: position info
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
