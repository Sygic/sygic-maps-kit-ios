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
        browseMap.bounceDefaultPoiDetailFirstTime = shouldBouncePoiDetail()
        browseMap.customMarkers = customMarkers()
        present(browseMap, animated: false)
    }
    
    private func customMarkers() -> [SYMKMapPin] {
        let pin1 = pinWithEverything()
        let pin2 = SYMKMapPin(coordinate: SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)!, icon: SygicIcon.android, color: .green)!
        let pin3 = SYMKMapPin(coordinate: SYGeoCoordinate(latitude: 48.147128, longitude: 17.104651)!, icon: SygicIcon.sygic, color: .red)!
        return [pin1, pin2, pin3]
    }
    
    private func pinWithEverything() -> SYMKMapPin {
        var data = SYMKPoiData(with: SYGeoCoordinate(latitude: 48.147128, longitude: 17.102631)!)
        data.name = "Super custom POI"
        data.street = "Mlynske Nivy"
        data.houseNumber = "16"
        data.city = "Bratislava"
        data.postal = "831 09"
        data.website = "www.sygic.com"
        
        let marker = SYMKMapPin(coordinate: data.coordinate, icon: SygicIcon.apple, color: .gray, highlighted: false)!
        marker.data = data
        return marker
    }
    
    private func shouldBouncePoiDetail() -> Bool {
        let firstBouncePlayedKey = "com.sygicMapsKit.firstBounceBrowseMapPoiDetailPlayed"
        if !UserDefaults.standard.bool(forKey: firstBouncePlayedKey) {
            UserDefaults.standard.set(true, forKey: firstBouncePlayedKey)
            return true
        }
        return false
    }
}
