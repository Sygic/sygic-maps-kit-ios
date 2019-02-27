import UIKit
import SygicMaps
import SygicMapsKit


class CustomDataHandlingViewController: UIViewController, SYMKModulePresenter {
    
    var presentedModules = [SYMKModuleViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Custom Tap Handling Example"
        
        let browseMap = SYMKBrowseMapViewController()
        browseMap.mapState.geoCenter = SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)!
        browseMap.mapState.zoom = 16
        browseMap.delegate = self
        browseMap.mapSelectionMode = .all
        presentModule(browseMap)
    }
    
}

extension CustomDataHandlingViewController: SYMKBrowseMapViewControllerDelegate {
    
    func browseMapController(_ browseController: SYMKBrowseMapViewController, didSelect data: SYMKPoiDataProtocol) {
        let alert = UIAlertController(title: nil, message: "\(data)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
