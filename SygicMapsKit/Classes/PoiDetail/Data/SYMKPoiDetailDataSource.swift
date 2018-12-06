import Foundation
import SygicMaps
import SygicUIKit

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
