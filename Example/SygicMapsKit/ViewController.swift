import UIKit
import SygicMapsKit
import SygicUIKit
import SygicMaps


class ViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let browseMap = SYMKBrowseMapViewController()
        browseMap.useCompass = true
        browseMap.useRecenterButton = true
        browseMap.useZoomControl = true
        browseMap.mapSelectionMode = .all
        browseMap.customMarkers = customMarkers()
        present(browseMap, animated: false)
    }
    
    private func customMarkers() -> [SYMKMapPin] {
        let poi1 = markerWithEverything()
        let poi2 = SYMKMapPin(coordinate: SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)!, icon: SygicIcon.android, color: .green)!
        let poi3 = SYMKMapPin(coordinate: SYGeoCoordinate(latitude: 48.147128, longitude: 17.104651)!, icon: SygicIcon.sygic, color: .red)!
        return [poi1, poi2, poi3]
    }
    
    private func markerWithEverything() -> SYMKMapPin {
        var poi = SYMKPoiData(with: SYGeoCoordinate(latitude: 48.147128, longitude: 17.102631)!)
        poi.name = "Super custom POI"
        poi.street = "Mlynske Nivy"
        poi.houseNumber = "16"
        poi.city = "Bratislava"
        poi.postal = "831 09"
        poi.website = "www.sygic.com"
        
        let marker = SYMKMapPin(coordinate: poi.coordinate, icon: SygicIcon.apple, color: .gray, highlighted: true)!
        marker.data = poi
        return marker
    }
}
