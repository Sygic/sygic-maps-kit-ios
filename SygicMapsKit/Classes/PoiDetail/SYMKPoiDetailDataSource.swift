import Foundation
import SygicMaps
import SygicUIKit

class SYMKPoiDetailDataSource {
    
    let topOffset: CGFloat = 68
    
    var place: SYPlace?
    var coordinates: SYGeoCoordinate
    
    lazy var contacts: [SYUIPoiDetailCellDataSource] = {
        var contacts = [SYUIPoiDetailCellDataSource]()
        guard let place = place else { return contacts }
        if let phone = place.phone {
            contacts.append(SYUIPoiDetailCellViewModel(title: "Phone", subtitle: phone, icon: SygicIcon.call))
        }
        if let email = place.email {
            contacts.append(SYUIPoiDetailCellViewModel(title: "Email", subtitle: email, icon: SygicIcon.email))
        }
        if let website = place.website {
            contacts.append(SYUIPoiDetailCellViewModel(title: "URL", subtitle: website, icon: SygicIcon.website))
        }
        return contacts
    }()
    
    init(with place: SYPlace) {
        self.place = place
        self.coordinates = place.coordinate
    }
    
    init(with coordinates: SYGeoCoordinate) {
        self.coordinates = coordinates
    }
}

extension SYMKPoiDetailDataSource: SYUIPoiDetailDataSource {
    public var poiDetailMaxTopOffset: CGFloat {
        return topOffset
    }
    
    public var poiDetailTitle: String {
        if let place = place {
            return place.name
        }
        return coordinates.string
    }
    
    public var poiDetailSubtitle: String? {
        if let place = place {
            return place.fullAddress
        }
        return nil
    }
    
    public var poiDetailNumberOfActionButtons: Int {
        return 1
    }
    
    public func poiDetailActionButtonProperties(at index: Int) -> SYUIActionButtonProperties? {
        return SYUIActionButtonViewModel(title: "Primary action", icon: SygicIcon.routeStart)
    }
    
    public func poiDetailNumberOfRows(in section: SYUIPoiDetailSectionType) -> Int {
        switch section {
        case .actions:
            return 1
        case .contactInfo:
            return contacts.count
        default:
            return 0
        }
    }
    
    public func poiDetailCellViewModel(for indexPath: IndexPath) -> SYUIPoiDetailCellDataSource {
        guard let section = SYUIPoiDetailSectionType(rawValue: indexPath.section) else { return SYUIPoiDetailCellViewModel(title: "") }
        switch section {
        case .actions:
            return SYUIPoiDetailCellViewModel(title: "GPS", subtitle: coordinates.string, icon: SygicIcon.streetView, stringToCopy: coordinates.string)
        case .contactInfo:
            return contacts[indexPath.row]
        default:
            return SYUIPoiDetailCellViewModel(title: "")
        }
    }
}

//extension SYMKPoiDetailDataSource: SYUIPoiDetailDelegate {
//    public func poiDetailDidPressActionButton(at index: Int) {
//        print("action button pressed \(index)")
//    }
//
//    public func poiDetailDidSelectCell(at indexPath: IndexPath) {
//        print("poi detail cell \(indexPath)")
//    }
//}
