import Foundation
import SygicMaps

public protocol SYMKPoiDetailModel {
    var coordinate: SYGeoCoordinate { get }
    var street: String? { get }
    var houseNumber: String? { get }
    var city: String? { get }
    var postal: String? { get }
    var phone: String? { get }
    var email: String? { get }
    var website: String? { get }
    
    var title: String { get }
    var subtitle: String? { get }
}

extension SYMKPoiDetailModel {
    var contacts: [SYMKPoiDetailContact] {
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

// MARK: - SYPlace

extension SYPlace: SYMKPoiDetailModel {
    public var title: String {
        if name.isEmpty {
            if let street = streetAndHouseNumber {
                return street
            } else if let city = city {
                return city
            }
        } else {
            return name
        }
        return coordinate.string
    }
    
    public var subtitle: String? {
        if name.isEmpty {
            return city
        } else {
            return fullAddress
        }
    }
    
    // MARK: Contacts
    
    public var phone: String? {
        guard let locationInfo = locationInfo else { return nil }
        return locationInfo.values(for: .phone)?.first
    }
    
    public var email: String? {
        guard let locationInfo = locationInfo else { return nil }
        return locationInfo.values(for: .mail)?.first
    }
    
    public var website: String? {
        guard let locationInfo = locationInfo else { return nil }
        return locationInfo.values(for: .url)?.first
    }
}

// MARK: - SYReverseSearchResult

extension SYReverseSearchResult: SYMKPoiDetailModel {
    public var street: String? {
        if let street = resultDescription.street, !street.isEmpty {
            return street
        }
        return nil
    }
    
    public var houseNumber: String? {
        if let houseNumber = resultDescription.houseNumber, !houseNumber.isEmpty {
            return houseNumber
        }
        return nil
    }
    
    public var city: String? {
        if let city = resultDescription.city, !city.isEmpty {
            return city
        }
        return nil
    }
    
    public var postal: String? {
        return nil
    }
    
    public var phone: String? {
        return nil
    }
    
    public var email: String? {
        return nil
    }
    
    public var website: String? {
        return nil
    }
    
    public var title: String {
        if let street = street {
            if let houseNumber = houseNumber {
                return "\(street) \(houseNumber)"
            }
            return street
        } else if let city = city {
            return city
        }
        return coordinate.string
    }
    
    public var subtitle: String? {
        guard city != title else { return nil }
        return city
    }
}
