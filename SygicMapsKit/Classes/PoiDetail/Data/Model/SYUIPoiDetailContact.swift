import Foundation
import SygicUIKit

public enum SYMKPoiDetailContact {
    case phone(_ value: String)
    case email(_ value: String)
    case website(_ value: String)
    
    var title: String {
        switch self {
        case .phone:
            return "Phone"
        case .email:
            return "Email"
        case .website:
            return "URL"
        }
    }
    
    var value: String {
        switch self {
        case .phone(let value):
            return value
        case .email(let value):
            return value
        case .website(let value):
            return value
        }
    }
    
    var icon: String {
        switch self {
        case .phone:
            return SygicIcon.call
        case .email:
            return SygicIcon.email
        case .website:
            return SygicIcon.website
        }
    }
    
    func cellDataSourece() -> SYUIPoiDetailCellDataSource {
        return SYUIPoiDetailCellData(title: self.title, subtitle: self.value, icon: self.icon)
    }
}
