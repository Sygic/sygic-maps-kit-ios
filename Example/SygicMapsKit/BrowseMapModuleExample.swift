import UIKit
import SygicMapsKit
import SygicUIKit
import SygicMaps


class BrowseMapModuleExample: UIViewController {
    
    private var presentedModules = [SYMKModuleViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    private func presentModule(_ viewController: SYMKModuleViewController) {
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
    
    private func addModuleAsSubview(_ module: SYMKModuleViewController) {
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
        routeComputeModule.mapState = browseController.mapState.copy() as! SYMKMapState
        routeComputeModule.delegate = self
        
        presentModule(routeComputeModule)
    }
    
}

extension BrowseMapModuleExample: SYMKRouteComputeControllerProtocol {
    
    func routeComputeControllerGoBack() {
        dismissModule()
    }
    
}
