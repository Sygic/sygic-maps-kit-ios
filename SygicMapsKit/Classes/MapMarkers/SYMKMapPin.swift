import Foundation
import SygicMaps
import SygicUIKit

public class SYMKMapPin: SYMKMapMarker {
    public var pinProperties: SYUIPinViewProperties!
    public private(set) var mapMarker: SYMapMarker
    
    public init?(coordinate: SYGeoCoordinate, properties: SYUIPinViewProperties) {
        let view = SYUIPinView()
        view.viewModel = properties
        
        if let image = view.imageFromView() {
            mapMarker = SYMapMarker(coordinate: coordinate, image: image)
            pinProperties = properties
            //            if pinViewModel.isSelected {
            //                pinView.anchorPosition = CGPoint(x: 0.5, y: 0.9)
            //            }
        } else {
            return nil
        }
    }
    
    public func updateProperties(_ properties: SYUIPinViewProperties){
        let view = SYUIPinView()
        view.viewModel = properties
        pinProperties = properties
        
        if let image = view.imageFromView() {
            mapMarker.image = image
        }
    }
    
    public func highlight(_ highlight: Bool) {
        if pinProperties.isSelected == highlight {
            return
        }
        
        var newProp = SYUIPinViewViewModel(with: pinProperties)
        newProp.isSelected = highlight
        
        updateProperties(newProp)
    }
    
    public static func ==(lhs: SYMKMapPin, rhs: SYMKMapPin) -> Bool {
        return lhs === rhs
    }
}
