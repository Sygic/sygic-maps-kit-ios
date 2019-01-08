import UIKit
import SygicMapsKit
import SygicUIKit
import SygicMaps


class BrowseMapModuleExample: UIViewController {
    
    private var presentedModules = [ModuleUIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let browseMap = SYMKBrowseMapViewController()
        browseMap.delegate = self
        browseMap.useCompass = true
        browseMap.useRecenterButton = true
        browseMap.useZoomControl = true
        browseMap.mapSelectionMode = .all
        browseMap.bounceDefaultPoiDetailFirstTime = shouldBouncePoiDetail()
        browseMap.customMarkers = customMarkers()
        
        presentModule(browseMap)
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
    
    private func shouldBouncePoiDetail() -> Bool {
        let firstBouncePlayedKey = "com.sygicMapsKit.firstBounceBrowseMapPoiDetailPlayed"
        if !UserDefaults.standard.bool(forKey: firstBouncePlayedKey) {
            UserDefaults.standard.set(true, forKey: firstBouncePlayedKey)
            return true
        }
        return false
    }
    
    private func presentModule(_ viewController: ModuleUIViewController) {
        removeLastModuleFromSuperview()
        presentedModules.append(viewController)
        addModuleAsSubview(viewController)
    }
    
    private func dismissModule() {
        removeLastModuleFromSuperview()
        _ = presentedModules.popLast()
        
        if let lastModule = presentedModules.last {
            addModuleAsSubview(lastModule)
        }
    }
    
    private func addModuleAsSubview(_ module: ModuleUIViewController) {
        addChildViewController(module)
        view.addSubview(module.view)
        module.view.translatesAutoresizingMaskIntoConstraints = false
        module.view.coverWholeSuperview()
    }
    
    private func removeLastModuleFromSuperview() {
        guard let lastModule = presentedModules.last else { return }
        lastModule.view.removeFromSuperview()
        lastModule.removeFromParentViewController()
    }
    
}

extension BrowseMapModuleExample: SYMKBrowseMapViewControllerDelegate {
    
    func browseMapController(_ browseController: SYMKBrowseMapViewController, didSelect data: SYMKPoiDataProtocol) {
        let routeComputeModule = SYMKRouteComputeController()
        routeComputeModule.mapState = browseController.mapState
        routeComputeModule.delegate = self
        
        presentModule(routeComputeModule)
    }
    
}

extension BrowseMapModuleExample: SYMKRouteComputeControllerProtocol {
    
    func routeComputeControllerGoBack() {
        dismissModule()
    }
    
}
