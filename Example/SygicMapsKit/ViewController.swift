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
        browseMap.customPois = customPoiData()
        present(browseMap, animated: false)
    }
    
    private func customPoiData() -> [SYMKPoiData] {
        let poi1 = poiWithEverything()
        var poi2 = SYMKPoiData(with: SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)!)
        poi2.color = .green
        poi2.icon = SygicIcon.android
        var poi3 = SYMKPoiData(with: SYGeoCoordinate(latitude: 48.147128, longitude: 17.104651)!)
        poi3.color = .red
        poi3.icon = SygicIcon.sygic
        return [poi1, poi2, poi3]
    }
    
    private func poiWithEverything() -> SYMKPoiData {
        var poi = SYMKPoiData(with: SYGeoCoordinate(latitude: 48.147128, longitude: 17.102631)!)
        poi.name = "Super custom POI"
        poi.street = "Mlynske Nivy"
        poi.houseNumber = "16"
        poi.city = "Bratislava"
        poi.postal = "831 09"
        poi.website = "www.sygic.com"
        poi.icon = SygicIcon.apple
        poi.color = .gray
        return poi
    }
}
