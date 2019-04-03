import Foundation
import SygicMaps
import SygicUIKit


extension SYSearchResult: SYUIDetailCellDataSource {
    public var height: CGFloat {
        return 60
    }
    
    public var title: NSMutableAttributedString? {
        var title = "\(type)"
        
        if let mapResult = self as? SYMapSearchResult {
            if mapResult.mapResultType == .poiCategory || mapResult.mapResultType == .poiCategoryGroup {
                if let poiCategory = mapResult.resultLabels.poiCategory?.value {
                    title = poiCategory
                } else if let poiGroup = mapResult.resultLabels.poiCategoryGroup?.value {
                    title = poiGroup
                }
            } else if mapResult.mapResultType == .poi {
                if let poi = mapResult.resultLabels.poi?.value {
                    title = poi
                }
            } else {
                if let street = mapResult.resultLabels.street?.value, street.count > 0 {
                    title = street
                    if let addressPoint = mapResult.resultLabels.addressPoint?.value, addressPoint.count > 0 {
                        title += " \(addressPoint)"
                    }
                } else {
                    if let city = mapResult.resultLabels.city?.value {
                        title = city
                    }
                }
            }
        }
        
        return NSMutableAttributedString(string: title, attributes: SYSearchResult.defaultTitleAttributes)
    }
    
    public var subtitle: NSMutableAttributedString? {
        var title: String? = nil
        if let mapResult = self as? SYMapSearchResult {
            if let city = mapResult.resultLabels.city?.value, let country = mapResult.resultLabels.country?.value {
                title = "\(city), \(country)"
            }
        }
        guard let subtitle = title else { return nil }
        return NSMutableAttributedString(string: subtitle, attributes: SYSearchResult.defaultSubtitleAttributes)
    }
    
    public var leftIcon: SYUIDetailCellIconDataSource? {
        var icon = SYUIIcon.pinPlace
        var color: UIColor = .textBody
        
        if let category = self as? SYMapSearchResultPoiCategory {
            let poiCategory = SYMKPoiCategory.with(syPoiCategory: category.category)
            icon = poiCategory.icon
            color = poiCategory.color
        } else if let group = self as? SYMapSearchResultPoiGroup {
            let poiGroup = SYMKPoiGroup.with(syPoiGroup: group.group)
            icon = poiGroup.icon
            color = poiGroup.color
        }
        
        return SYUIDetailCellIconDataSource(icon: icon, color: .textInvert, backgroundColor: color)
    }
    
    public var rightIcon: SYUIDetailCellIconDataSource? {
        return nil
    }
    
    public var backgroundColor: UIColor? {
        return UIColor.background
    }
    
    public func detail(for coordinates: SYGeoCoordinate? = nil, data: @escaping (_ result: SYSearchResultDetail?) -> ()) {
        guard let mapSearchResult = self as? SYMapSearchResult else {
            data(nil)
            return
        }
        let location = coordinates ?? mapSearchResult.coordinate ?? SYGeoCoordinate()
        let search = SYSearch()
        search.start(SYSearchResultDetailRequest(result: mapSearchResult, atLocation: location)) { detail, state in
            _ = search // reference to search instance, so completion block is executed
            data(detail)
        }
    }

}
