//// SYMKSpeedInfobarItem.swift
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
import SygicUIKit
import SygicMaps


/// Item for infobar controller showing current speed
public class SYMKSpeedInfobarItem: SYMKInfobarItem {
    public var type: SYMKInfobarItemType = .currentSpeed(0)
    public let view: UIView = SYUIInfobarSecondaryLabel()
    
    public init() {
        update(with: type)
    }
    
    public func update(with valueType: SYMKInfobarItemType) {
        switch valueType {
        case .currentSpeed(let speed, let units):
            type = valueType
            guard let label = view as? SYUIInfobarLabel else { return }
            label.text = formattedValue(speed, units)
        default:
            break
        }
    }

    private func formattedValue(_ speed: SYSpeed, _ units: SYUIDistanceUnits) -> String {
        return "\(speed)\(units.speedTitle)"
    }
}
