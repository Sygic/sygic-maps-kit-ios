import Foundation
import SygicMaps
import SygicUIKit

protocol SYMKPoiDetailModel {
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
    var contacts: [SYUIPoiDetailContact] {
        var contacts = [SYUIPoiDetailContact]()
        if let phone = phone {
            contacts.append(SYUIPoiDetailContact.phone(phone))
        }
        if let email = email {
            contacts.append(SYUIPoiDetailContact.email(email))
        }
        if let website = website {
            contacts.append(SYUIPoiDetailContact.website(website))
        }
        return contacts
    }
}

public enum SYUIPoiDetailContact {
    case phone(_ value: String)
    case email(_ value: String)
    case website(_ value: String)
    
    static let count = 3
    
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

class SYMKPoiDetailDataSource {
    
    private var model: SYMKPoiDetailModel
    private let topOffset: CGFloat = 68
    
    init(with model: SYMKPoiDetailModel) {
        self.model = model
    }
}

extension SYMKPoiDetailDataSource: SYUIPoiDetailDataSource {
    
    public var poiDetailMaxTopOffset: CGFloat {
        return topOffset
    }
    
    public var poiDetailTitle: String {
        return model.title
    }
    
    public var poiDetailSubtitle: String? {
        return model.subtitle
    }
    
    public func poiDetailNumberOfRows(in section: SYUIPoiDetailSectionType) -> Int {
        switch section {
        case .actions:
            return 1
        case .contactInfo:
            return model.contacts.count
        default:
            return 0
        }
    }
    
    public func poiDetailCellData(for indexPath: IndexPath) -> SYUIPoiDetailCellDataSource {
        guard let section = SYUIPoiDetailSectionType(rawValue: indexPath.section) else { return SYUIPoiDetailCellData(title: "") }
        switch section {
        case .actions:
            return SYUIPoiDetailCellData(title: "GPS", subtitle: model.coordinate.string, icon: SygicIcon.pinPlace, stringToCopy: model.coordinate.string)
        case .contactInfo:
            return model.contacts[indexPath.row].cellDataSourece()
        default:
            return SYUIPoiDetailCellData(title: "")
        }
    }
}
