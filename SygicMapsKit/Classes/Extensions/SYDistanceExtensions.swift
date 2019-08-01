//// SYDistanceExtensions.swift
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


public extension SYDistance {
    
    var yards: Double {
        return Double(self) * 10000.0 / 9144.0
    }
    
    var feet: Double {
        return Double(self) * 328084.0 / 100000.0
    }
    
    var kilometers: Double {
        return Double(self) / 1000
    }
    
    var stringValue: String {
        let distanceWithUnits = self.format(toShortUnits: true, andRound: true)
        return "\(distanceWithUnits.formattedDistance) \(distanceWithUnits.units)"
    }
    
    func round() -> SYDistance {
        let distance = self
        
        var correctedDistance = Swift.min(distance, UInt(Int.max))
        
        if correctedDistance < 5 {
            return 0
        }
        
        if correctedDistance < 30 {
            correctedDistance += 2
            return correctedDistance - correctedDistance % 5
        }
        
        if correctedDistance < 250 {
            correctedDistance += 5
            return correctedDistance - correctedDistance % 10
        }
        
        if correctedDistance < 800 {
            correctedDistance += 25
            return correctedDistance - correctedDistance % 50
        }
        
        if correctedDistance < 10000 {
            correctedDistance += 50
            return correctedDistance - correctedDistance % 100
        }
        
        correctedDistance += 500
        return correctedDistance - correctedDistance % 1000
    }
    
    func format(toShortUnits shortUnits: Bool, andRound round: Bool, usingOtherThenFormattersUnits units: SYUIDistanceUnits = SYUIFormattersUnits.distanceUnits) -> (formattedDistance: String, units: String) {
        switch units {
        case .kilometers:
            return format(intoKilometersAndRound: round, toShortUnits: shortUnits)
        case .milesFeet:
            return format(intoMilesFeetAndRound: round, toShortUnits: shortUnits)
        case .milesYards:
            return format(intoMilesYardsAndRound: round, toShortUnits: shortUnits)
        }
    }
    
    private func format(intoKilometersAndRound round: Bool, toShortUnits shortUnits: Bool) -> (formattedDistance: String, units: String) {
        
        var formattedDistance: String
        var units: String
        let distance = round ? self.round() : self
        
        if distance < 1000 {
            formattedDistance = String(format: "%d", distance)
            units = shortUnits ? "m" : LS("meters")
        } else if distance < 10000 {
            formattedDistance = String(format: "%.1f", Double(Int(distance.kilometers*10))/10.0)
            units = shortUnits ? "km" : LS("kilometers")
        } else {
            formattedDistance = String(format: "%d", Int(distance.kilometers))
            units = shortUnits ? "km" : LS("kilometers")
        }
        
        return (formattedDistance, units)
    }
    
    private func format(intoMilesFeetAndRound round: Bool, toShortUnits shortUnits: Bool) -> (formattedDistance: String, units: String) {
        
        var formattedDistance: String
        var units: String
        let distance = round ? SYDistance(self.feet).round() : SYDistance(self.feet)
        
        if distance < 1000 {
            formattedDistance = String(format: "%d", distance)
            units = shortUnits ? LS("ft", "feet short") : LS("feet")
        } else if distance < 10 * 5280 {
            formattedDistance = String(format: "%.1f", Double(distance)/5280)
            units = shortUnits ? LS("mi", "miles short") : LS("miles")
        } else {
            formattedDistance = String(format: "%.0f", Double(distance)/5280)
            units = shortUnits ? LS("mi", "miles short") : LS("miles")
        }
        
        return (formattedDistance, units)
    }
    
    private func format(intoMilesYardsAndRound round: Bool, toShortUnits shortUnits: Bool) -> (formattedDistance: String, units: String) {
        
        var formattedDistance: String
        var units: String
        let distance = round ? SYDistance(self.yards).round() : SYDistance(self.yards)
        
        if distance < 1000 {
            formattedDistance = String(format: "%d", distance)
            units = shortUnits ? LS("yd", "yards short") : LS("yards")
        } else if distance < 10*1760 {
            formattedDistance = String(format: "%.1f", Double(distance)/1760)
            units = shortUnits ? LS("mi", "miles short") : LS("miles")
        } else {
            formattedDistance = String(format: "%.0f", Double(distance)/1760)
            units = shortUnits ? LS("mi", "miles short") : LS("miles")
        }
        
        return (formattedDistance, units)
    }
    
}
