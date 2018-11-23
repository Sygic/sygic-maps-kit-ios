import Foundation
import SygicMaps

extension SYPlace {
    var fullAddress: String? {
        guard let locationInfo = locationInfo else { return nil }
        
        var address = ""
        if let street = locationInfo.values(for: .street)?.first, !street.isEmpty {
            address.append(street)
        }
        
        if let houseNum = locationInfo.values(for: .houseNum)?.first {
            if !address.isEmpty {
                address.append(" ")
            }
            address.append(houseNum)
        }
        if let city = locationInfo.values(for: .city)?.first {
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
