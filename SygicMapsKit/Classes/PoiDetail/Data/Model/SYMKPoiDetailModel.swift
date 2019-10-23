//// SYMKPoiDetailModel.swift
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
import UIKit
import SygicMaps
import SygicUIKit


/// Protocol for poi data
public protocol SYMKPoiDataProtocol {
    /// POI geo coordinates (latitude, longitude)
    var location: SYGeoCoordinate { get }
    /// POI name (optional)
    var name: String? { get }
    /// POI address
    var street: String? { get }
    /// POI address
    var houseNumber: String? { get }
    /// POI address
    var city: String? { get }
    /// POI address
    var postal: String? { get }
    /// POI contact
    var phone: String? { get }
    /// POI contact
    var email: String? { get }
    /// POI contact
    var website: String? { get }
}

/// Protocol for poi detail model
///
/// Extension of Poi data protocol. Provides data for Poi detail data source
public protocol SYMKPoiDetailModel: SYMKPoiDataProtocol {
    var poiDetailTitle: String { get }
    var poiDetailSubtitle: String? { get }
    var poiDetailContacts: [SYMKPoiDetailContact] { get }
}

/// Implementation of poi data protocol
public class SYMKPoiData: NSObject, SYMKPoiDataProtocol, NSCoding {
    public var location: SYGeoCoordinate
    public var name: String? = nil
    public var street: String? = nil
    public var houseNumber: String? = nil
    public var city: String? = nil
    public var postal: String? = nil
    public var phone: String? = nil
    public var email: String? = nil
    public var website: String? = nil
    public var customData: NSCoding? = nil
    
    private enum EncodeKeys: String {
        case location = "KeyLocation"
        case name = "KeyName"
        case street = "KeyStreet"
        case houseNumber = "KeyHouseNumber"
        case city = "KeyCity"
        case postal = "KeyPostal"
        case phone = "KeyPhone"
        case email = "KeyEmail"
        case website = "KeyWebsite"
        case data = "KeyData"
    }
    
    /// Basic initializer only with mandatory attributes
    ///
    /// - Parameter coordinate: geo coordinates
    public init(with location: SYGeoCoordinate) {
        self.location = location
    }
    
    /// Initializer used with map place data
    ///
    /// - Parameter place: map place provided by SYMapView
    public convenience init(with place: SYPlace) {
        self.init(with: place.location)
        
        street = place.street
        houseNumber = place.houseNumber
        postal = place.postal
        city = place.city
        
        phone = place.phone
        email = place.email
        website = place.website
        
        if !place.name.isEmpty {
            name = place.name
        }
    }
    
    /// Initializer used with reverse search data (address point)
    ///
    /// - Parameter reverseResult: search result provided by SYReverseSearch for geo coordinates
    public convenience init(with reverseResult: SYReverseSearchResult) {
        self.init(with: reverseResult.coordinate)
        
        if let resultStreet = reverseResult.resultDescription.street, !resultStreet.isEmpty {
            street = resultStreet
        }
        if let resultHouseNum = reverseResult.resultDescription.houseNumber, !resultHouseNum.isEmpty {
            houseNumber = resultHouseNum
        }
        if let resultCity = reverseResult.resultDescription.city, !resultCity.isEmpty {
            city = resultCity
        }
    }
    
    /// Initailizer used with map search result. Extracts basic address info. Initializer will fail if search result location is nil (Group or Category result).
    ///
    /// - Parameter mapResult: SYMapSearchResult
    public convenience init?(with mapResult: SYMapSearchResult) {
        guard let location = mapResult.coordinate else { return nil }
        self.init(with: location)
        if mapResult.mapResultType == .poi {
            if let poi = mapResult.resultLabels.poi?.value {
                name = poi
            }
        }
        street = mapResult.resultLabels.street?.value
        city = mapResult.resultLabels.city?.value
        postal = mapResult.resultLabels.postal?.value
        houseNumber = mapResult.resultLabels.addressPoint?.value
    }
    
    /// Initializer used with search poi data
    ///
    /// - Parameter poiDetail: search result detail provided by SYSearch for detail request on SYMapSearchResult
    public convenience init(with poiDetail: SYSearchResultDetailPlace) {
        self.init(with: poiDetail.coordinate ?? SYGeoCoordinate())
        
        name = poiDetail.place.name
        
        street = poiDetail.place.street
        houseNumber = poiDetail.place.houseNumber
        postal = poiDetail.place.postal
        city = poiDetail.place.city
        
        phone = poiDetail.place.phone
        email = poiDetail.place.email
        website = poiDetail.place.website
    }
    
    public required init?(coder aDecoder: NSCoder) {
        location = aDecoder.decodeObject(forKey: EncodeKeys.location.rawValue) as! SYGeoCoordinate
        name = aDecoder.decodeObject(forKey: EncodeKeys.name.rawValue) as? String
        street = aDecoder.decodeObject(forKey: EncodeKeys.street.rawValue) as? String
        houseNumber = aDecoder.decodeObject(forKey: EncodeKeys.houseNumber.rawValue) as? String
        city = aDecoder.decodeObject(forKey: EncodeKeys.city.rawValue) as? String
        postal = aDecoder.decodeObject(forKey: EncodeKeys.postal.rawValue) as? String
        phone = aDecoder.decodeObject(forKey: EncodeKeys.phone.rawValue) as? String
        email = aDecoder.decodeObject(forKey: EncodeKeys.email.rawValue) as? String
        website = aDecoder.decodeObject(forKey: EncodeKeys.website.rawValue) as? String
        customData = aDecoder.decodeObject(forKey: EncodeKeys.data.rawValue) as? NSCoding
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(location, forKey: EncodeKeys.location.rawValue)
        aCoder.encode(name, forKey: EncodeKeys.name.rawValue)
        aCoder.encode(street, forKey: EncodeKeys.street.rawValue)
        aCoder.encode(houseNumber, forKey: EncodeKeys.houseNumber.rawValue)
        aCoder.encode(city, forKey: EncodeKeys.city.rawValue)
        aCoder.encode(postal, forKey: EncodeKeys.postal.rawValue)
        aCoder.encode(phone, forKey: EncodeKeys.phone.rawValue)
        aCoder.encode(email, forKey: EncodeKeys.email.rawValue)
        aCoder.encode(website, forKey: EncodeKeys.website.rawValue)
        aCoder.encode(customData, forKey: EncodeKeys.data.rawValue)
    }
    
    private func formattedAddress(from street: String? = nil, houseNumber: String? = nil, city: String? = nil, postal: String? = nil) -> String? {
        var address = ""
        
        if let street = street {
            address.append(street)
            
            if let houseNumber = houseNumber {
                if !address.isEmpty {
                    address.append(" ")
                }
                address.append(houseNumber)
            }
        }
        
        if let city = city {
            if !address.isEmpty {
                if postal == nil {
                    address.append(",")
                }
                address.append(" ")
            }
            address.append(city)
        }
        
        if let postal = postal {
            if !address.isEmpty {
                address.append(", ")
            }
            address.append(postal)
        }
        
        if address.isEmpty {
            return nil
        }
        
        return address
    }
}

extension SYMKPoiData: SYMKPoiDetailModel {
    
    public var poiDetailTitle: String {
        if let name = name {
            return name
        } else if let streetAndHouseNumber = formattedAddress(from: street, houseNumber: houseNumber) {
            return streetAndHouseNumber
        } else if let postalAndCity = formattedAddress(city: city, postal: postal) {
            return postalAndCity
        }
        return location.string
    }
    
    public var poiDetailSubtitle: String? {
        var distanceString: String? = nil
        var addressString: String? = nil
        if let userPosition = SYPosition.lastKnownLocation(), let userLocation = userPosition.coordinate {
            let distance: UInt = location.distance(to: userLocation)
            if distance > 1000 {
                distanceString = "\(distance/1000)\(LS("km"))"
            } else {
                distanceString = "\(distance)\(LS("m"))"
            }
        }
        if name != nil {
            addressString = formattedAddress(from: street, houseNumber: houseNumber, city: city, postal: postal)
        } else if let postalAndCity = formattedAddress(city: city, postal: postal), postalAndCity != poiDetailTitle {
            addressString = postalAndCity
        }
        if let distance = distanceString, let address = addressString {
            return "\(distance)・\(address)"
        }
        if let address = addressString {
            return address
        }
        return distanceString
    }
    
    public var poiDetailContacts: [SYMKPoiDetailContact] {
        var contacts = [SYMKPoiDetailContact]()
        if let phone = phone {
            contacts.append(SYMKPoiDetailContact.phone(phone))
        }
        if let email = email {
            contacts.append(SYMKPoiDetailContact.email(email))
        }
        if let website = website {
            contacts.append(SYMKPoiDetailContact.website(website))
        }
        return contacts
    }
}
