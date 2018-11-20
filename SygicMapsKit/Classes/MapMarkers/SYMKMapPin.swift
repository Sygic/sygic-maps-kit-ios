import Foundation
import SygicMaps
import SygicUIKit

/*
 Implementation of SYMKMapMarker protocol, to display SYUIPinView as markers on map.
 */
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
    
    public init?(coordinate: SYGeoCoordinate, properties: SYUIPinViewProperties) {
        guard let image = SYMKMapPin.generateImage(properties) else {
            return nil
        }
        
        mapMarker = SYMapMarker(coordinate: coordinate, image: image)
        highlighted = properties.isSelected
        updateProperties(properties)
    }
    
    public func updateProperties(_ properties: SYUIPinViewProperties) {
        pinProperties = properties
        mapMarker.anchorPosition = pinProperties.isSelected ? CGPoint(x: 0.5, y: 0.9) : CGPoint(x: 0.5, y: 0.5)
        
        if let image = SYMKMapPin.generateImage(properties) {
            mapMarker.image = image
        }
    }
    
    private class func generateImage(_ properties: SYUIPinViewProperties) -> UIImage? {
        let view = SYUIPinView()
        view.viewModel = properties
        return view.imageFromView()
    }
    
    public static func ==(lhs: SYMKMapPin, rhs: SYMKMapPin) -> Bool {
        return lhs === rhs
    }
}
