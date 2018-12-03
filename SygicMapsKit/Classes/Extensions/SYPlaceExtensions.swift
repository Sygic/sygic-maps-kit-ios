import Foundation
import SygicMaps

extension SYPlace {
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
    
    func unemptyLocationInfo(for field: SYLocationInfoField) -> String? {
        if let info = locationInfo?.values(for: field)?.first, !info.isEmpty {
            return info
        }
        return nil
    }
}

extension SYPlace: SYMKPoiDetailModel {    
    var title: String {
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
    
    var subtitle: String? {
        if name.isEmpty {
            return city
        } else {
            return fullAddress
        }
    }
    
    // MARK: Address
    
    var street: String? { return unemptyLocationInfo(for: .street) }
    var houseNumber: String? { return unemptyLocationInfo(for: .houseNum) }
    var city: String? { return unemptyLocationInfo(for: .city) }
    var postal: String? { return unemptyLocationInfo(for: .postal) }
    
    // MARK: Contacts
    
    var phone: String? {
        guard let locationInfo = locationInfo else { return nil }
        return locationInfo.values(for: .phone)?.first
    }
    
    var email: String? {
        guard let locationInfo = locationInfo else { return nil }
        return locationInfo.values(for: .mail)?.first
    }
    
    var website: String? {
        guard let locationInfo = locationInfo else { return nil }
        return locationInfo.values(for: .url)?.first
    }
}
