import UIKit
import SygicMapsKit
import SygicUIKit
import SygicMaps


class BrowseModuleExampleViewController: UIViewController, SYMKModulePresenter {
    
    var presentedModules = [SYMKModuleViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Transition demo"
        
        let browseMap = SYMKBrowseMapViewController()
        browseMap.delegate = self
        browseMap.useCompass = true
        browseMap.useRecenterButton = true
        browseMap.useZoomControl = true
        browseMap.mapSelectionMode = .all
        browseMap.bounceDefaultPoiDetailFirstTime = shouldBouncePoiDetail()
        
        presentModule(browseMap)
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

extension BrowseModuleExampleViewController: SYMKBrowseMapViewControllerDelegate {
    
    func browseMapController(_ browseController: SYMKBrowseMapViewController, didSelect data: SYMKPoiDataProtocol) {
        let routeComputeModule = SYMKRouteComputeController()
        routeComputeModule.mapState = browseController.mapState.copy() as! SYMKMapState
        routeComputeModule.delegate = self
        
        presentModule(routeComputeModule)
    }
    
}

extension BrowseModuleExampleViewController: SYMKRouteComputeControllerProtocol {
    
    func routeComputeControllerGoBack() {
        dismissModule()
    }
    
}
