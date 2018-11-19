import Foundation
import SygicMaps
import SygicUIKit

public class SYMKMapPin: SYMKMapMarker {
    public var pinProperties: SYUIPinViewProperties!
    public private(set) var mapMarker: SYMapMarker
    
    public var highlighted: Bool {
        didSet {
            if oldValue == highlighted {
                return
            }
        
            var newProp = SYUIPinViewViewModel(with: pinProperties)
            newProp.isSelected = highlighted
            
            updateProperties(newProp)
        }
    }
    
    public init(coordinate: SYGeoCoordinate, properties: SYUIPinViewProperties) {
        mapMarker = SYMapMarker(coordinate: coordinate, image: UIImage())
        highlighted = properties.isSelected
        updateProperties(properties)
    }
    
    public func updateProperties(_ properties: SYUIPinViewProperties) {
        pinProperties = properties
        let view = SYUIPinView()
        view.viewModel = pinProperties
        
        mapMarker.anchorPosition = pinProperties.isSelected ? CGPoint(x: 0.5, y: 0.9) : CGPoint(x: 0.5, y: 0.5)
        mapMarker.zIndex = pinProperties.isSelected ? 1 : 0
        
        if let image = view.imageFromView() {
            mapMarker.image = image
        }
    }
    
    public static func ==(lhs: SYMKMapPin, rhs: SYMKMapPin) -> Bool {
        return lhs === rhs
    }
}
