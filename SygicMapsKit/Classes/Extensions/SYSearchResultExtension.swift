import Foundation
import SygicMaps
import SygicUIKit


extension SYSearchResult: SYUIDetailCellDataSource {
    public var height: CGFloat {
        return 60
    }
    
    public var title: NSMutableAttributedString? {
        return NSMutableAttributedString(string: "\(type)", attributes: SYSearchResult.defaultTitleAttributes)
    }
    
    public var subtitle: NSMutableAttributedString? {
        return nil
    }
    
    public var leftIcon: SYUIDetailCellIconDataSource? {
        return SYUIDetailCellIconDataSource(icon: SYUIIcon.search, color: UIColor.white, backgroundColor: UIColor.textBody)
    }
    
    public var rightIcon: SYUIDetailCellIconDataSource? {
        return nil
    }
    
    public var backgroundColor: UIColor? {
        return UIColor.background
    }
    
    
}
