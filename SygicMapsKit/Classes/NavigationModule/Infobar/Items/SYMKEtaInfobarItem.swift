//// SYMKEtaInfobarItem.swift
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


public class SYMKEtaInfobarItem: SYMKInfobarItem {
    public var type: SYMKInfobarItemType = .estimatedTimeOfArrival(0)
    public let view: UIView = SYUIInfobarSecondaryLabel()
    
    private let timeFormatter: DateFormatter = {
        let timeFormater = DateFormatter()
        timeFormater.timeStyle = .short
        return timeFormater
    }()
    
    public func update(with valueType: SYMKInfobarItemType) {
        switch valueType {
        case .estimatedTimeOfArrival(let time):
            type = valueType
            guard let label = view as? SYUIInfobarLabel else { return }
            label.text = formattedValue(time)
        default:
            break
        }
    }
    
    private func formattedValue(_ remainingTime: TimeInterval?) -> String {
        if let time = remainingTime {
            return timeFormatter.string(from: Date(timeIntervalSinceNow: time))
        }
        return ""
    }
}