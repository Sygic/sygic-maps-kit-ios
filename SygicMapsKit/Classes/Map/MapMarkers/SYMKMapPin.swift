import Foundation
import SygicMaps
import SygicUIKit

/**
 Implementation of SYMKMapMarker protocol, to display SYUIPinView as markers on map.
 */
public class SYMKMapPin: SYMKMapMarker {
    public var pin: SYUIPinView
    public private(set) var mapMarker: SYMapMarker
    
    public var highlighted: Bool {
        didSet {
            if oldValue == highlighted {
                return
            }
        
            pin.isHighlighted = highlighted

            if let image = pin.imageFromView() {
                updateMarkerImage(image)
            }
        }
    }
    
    public init?(coordinate: SYGeoCoordinate, icon: String, color: UIColor, highlighted: Bool) {
        pin = SYUIPinView(icon: icon, color: color, highlighted: highlighted, animatedHighlight: false)
        self.highlighted = highlighted
        
        guard let image = pin.imageFromView() else {
            return nil
        }

        mapMarker = SYMapMarker(coordinate: coordinate, image: image)
        updateMarkerImage(image)
    }

    public static func ==(lhs: SYMKMapPin, rhs: SYMKMapPin) -> Bool {
        return lhs === rhs
    }
    
    private func updateMarkerImage(_ image: UIImage) {
        mapMarker.image = image
        mapMarker.anchorPosition = pin.isHighlighted ? CGPoint(x: 0.5, y: 0.9) : CGPoint(x: 0.5, y: 0.5)
    }
}
