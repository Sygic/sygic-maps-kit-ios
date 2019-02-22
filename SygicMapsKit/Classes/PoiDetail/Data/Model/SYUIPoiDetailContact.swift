import Foundation
import SygicUIKit

/// Supported contact types for poi detail
///
/// - phone: phone contact
/// - email: email contact
/// - website: website url
public enum SYMKPoiDetailContact {
    case phone(_ value: String)
    case email(_ value: String)
    case website(_ value: String)
    
    /// Title for contact detail
    var title: String {
        switch self {
        case .phone:
            return LS("detail.contact.phone")
        case .email:
            return LS("detail.contact.mail")
        case .website:
            return LS("detail.contact.url")
        }
    }
    
    /// Value for contact detail
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
    
    /// Icon for contact detail
    var icon: String {
        switch self {
        case .phone:
            return SYUIIcon.call
        case .email:
            return SYUIIcon.email
        case .website:
            return SYUIIcon.website
        }
    }
    
    /// Contact data source for cell in poi detail
    ///
    /// - Returns: cell data source
    func cellDataSourece() -> SYUIPoiDetailCellDataSource {
        return SYUIPoiDetailCellData(title: self.title, subtitle: self.value, icon: self.icon)
    }
}
