import Foundation
import UIKit
import SygicMaps
import SygicUIKit


/// Protocol for poi data
public protocol SYMKPoiDataProtocol {
    /// POI geo coordinates (latitude, longitude)
    var coordinate: SYGeoCoordinate { get }
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
public struct SYMKPoiData: SYMKPoiDataProtocol {
    public var coordinate: SYGeoCoordinate
    public var name: String? = nil
    public var street: String? = nil
    public var houseNumber: String? = nil
    public var city: String? = nil
    public var postal: String? = nil
    public var phone: String? = nil
    public var email: String? = nil
    public var website: String? = nil
    
    /// Basic initializer only with mandatory attributes
    ///
    /// - Parameter coordinate: geo coordinates
    public init(with coordinate: SYGeoCoordinate) {
        self.coordinate = coordinate
    }
    
    /// Initializer used with map place data
    ///
    /// - Parameter place: map place provided by SYMapView
    public init(with place: SYPlace) {
        self.init(with: place.coordinate)
        
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
    public init(with reverseResult: SYReverseSearchResult) {
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
        
        if let postal = postal {
            if !address.isEmpty {
                address.append(", ")
            }
            address.append(postal)
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
        return coordinate.string
    }
    
    public var poiDetailSubtitle: String? {
        if name != nil {
            return formattedAddress(from: street, houseNumber: houseNumber, city: city, postal: postal)
        } else if let postalAndCity = formattedAddress(city: city, postal: postal), postalAndCity != poiDetailTitle {
            return postalAndCity
        }
        return nil
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
