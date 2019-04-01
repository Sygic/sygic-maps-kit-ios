//// SYPlaceExtensions.swift
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

import Foundation
import SygicMaps


public extension SYPlace {
    
    /// Formatted string containing street and house number from place address
    var streetAndHouseNumber: String? {
        var address = ""
        if let street = street {
            address.append(street)
        }
        if let houseNum = houseNumber {
            if !address.isEmpty {
                address.append(" ")
            }
            address.append(houseNum)
        }
        if address.isEmpty {
            return nil
        }
        return address
    }
    
    /// Formatted string containing all available address segments.
    var fullAddress: String? {
        var address = ""
        if let streetHouse = streetAndHouseNumber {
            address.append(streetHouse)
        }
        
        if let city = city {
            if !address.isEmpty {
                address.append(", ")
            }
            address.append(city)
        }
        
        if address.isEmpty {
            return nil
        }
        
        return address
    }
    
    /// Location info for provided Location info field
    ///
    /// - Parameter field: desired location info type
    /// - Returns: Location info value string. If empty, returns nil.
    func unemptyLocationInfo(for field: SYLocationInfoField) -> String? {
        if let info = locationInfo?.values(for: field)?.first, !info.isEmpty {
            return info
        }
        return nil
    }
    
    // MARK: Address
    
    var street: String? { return unemptyLocationInfo(for: .street) }
    var houseNumber: String? { return unemptyLocationInfo(for: .houseNum) }
    var city: String? { return unemptyLocationInfo(for: .city) }
    var postal: String? { return unemptyLocationInfo(for: .postal) }
    
    // MARK: Contacts
    var phone: String? { return unemptyLocationInfo(for: .phone) }
    var email: String? { return unemptyLocationInfo(for: .mail) }
    var website: String? { return unemptyLocationInfo(for: .url) }
    
}
