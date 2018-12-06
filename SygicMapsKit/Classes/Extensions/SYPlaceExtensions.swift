import Foundation
import SygicMaps

public extension SYPlace {
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
    
    // MARK: Address
    
    var street: String? { return unemptyLocationInfo(for: .street) }
    var houseNumber: String? { return unemptyLocationInfo(for: .houseNum) }
    var city: String? { return unemptyLocationInfo(for: .city) }
    var postal: String? { return unemptyLocationInfo(for: .postal) }
}
