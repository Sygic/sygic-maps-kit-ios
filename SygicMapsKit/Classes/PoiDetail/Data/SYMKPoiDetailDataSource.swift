import Foundation
import SygicMaps
import SygicUIKit


/// Provides implementation of SYUIPoiDetailDataSource procotol based on SYMKPoiDetailModel protocol
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
        return model.poiDetailTitle
    }
    
    public var poiDetailSubtitle: String? {
        return model.poiDetailSubtitle
    }
    
    public func poiDetailNumberOfRows(in section: SYUIPoiDetailSectionType) -> Int {
        switch section {
        case .actions:
            return 1
        case .contactInfo:
            return model.poiDetailContacts.count
        default:
            return 0
        }
    }
    
    public func poiDetailCellData(for indexPath: IndexPath) -> SYUIPoiDetailCellDataSource {
        guard let section = SYUIPoiDetailSectionType(rawValue: indexPath.section) else { return SYUIPoiDetailCellData(title: "") }
        switch section {
        case .actions:
            return SYUIPoiDetailCellData(title: "GPS", subtitle: model.coordinate.string, icon: SYUIIcon.pinPlace, stringToCopy: model.coordinate.string)
        case .contactInfo:
            return model.poiDetailContacts[indexPath.row].cellDataSourece()
        default:
            return SYUIPoiDetailCellData(title: "")
        }
    }
}
