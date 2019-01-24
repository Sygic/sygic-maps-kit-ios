import UIKit
import SygicMapsKit
import SygicUIKit
import SygicMaps

class CustomMarkersExampleViewController: UIViewController, SYMKModulePresenter {
    
    var presentedModules = [SYMKModuleViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Custom markers"

        let browseMapModule = SYMKBrowseMapViewController()
        browseMapModule.mapSelectionMode = .markers
        browseMapModule.customMarkers = customMarkers()
        browseMapModule.mapState.geoCenter = SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)!
        browseMapModule.mapState.zoom = 16
    
        presentModule(browseMapModule)
    }
    
    private func customMarkers() -> [SYMKMapPin] {
        let pin1 = pinWithEverything()
        let pin2 = SYMKMapPin(coordinate: SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)!, icon: SYUIIcon.android, color: .green)!
        let pin3 = SYMKMapPin(coordinate: SYGeoCoordinate(latitude: 48.147128, longitude: 17.104651)!, icon: SYUIIcon.sygic, color: .red)!
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
        
        let marker = SYMKMapPin(coordinate: data.coordinate, icon: SYUIIcon.apple, color: .gray, highlighted: false)!
        marker.data = data
        return marker
    }
}
