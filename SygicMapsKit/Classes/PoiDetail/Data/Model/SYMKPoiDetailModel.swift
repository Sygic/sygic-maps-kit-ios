import Foundation
import SygicMaps

public protocol SYMKPoiDataProtocol {
    var coordinate: SYGeoCoordinate { get }
    var name: String? { get }
    var street: String? { get }
    var houseNumber: String? { get }
    var city: String? { get }
    var postal: String? { get }
    var phone: String? { get }
    var email: String? { get }
    var website: String? { get }
}

public protocol SYMKPoiDetailModel {
    var title: String { get }
    var subtitle: String? { get }
    var contacts: [SYMKPoiDetailContact] { get }
}

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
    
    public init(with place: SYPlace) {
        coordinate = place.coordinate
        
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
    
    public init(with reverseResult: SYReverseSearchResult) {
        coordinate = reverseResult.coordinate
        
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
    
    public var title: String {
        if let name = name {
            return name
        } else if let streetAndHouseNumber = formattedAddress(from: street, houseNumber: houseNumber) {
            return streetAndHouseNumber
        } else if let postalAndCity = formattedAddress(city: city, postal: postal) {
            return postalAndCity
        }
        return coordinate.string
    }
    
    public var subtitle: String? {
        if name != nil {
            return formattedAddress(from: street, houseNumber: houseNumber, city: city, postal: postal)
        } else if let postalAndCity = formattedAddress(city: city, postal: postal), postalAndCity != title {
            return postalAndCity
        }
        return nil
    }
    
    public var contacts: [SYMKPoiDetailContact] {
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
