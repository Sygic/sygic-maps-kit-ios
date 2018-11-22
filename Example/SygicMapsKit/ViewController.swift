import UIKit
import SygicMapsKit


class ViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let browseMap = SYMKBrowseMapViewController()
        browseMap.useCompass = true
        browseMap.useRecenterButton = true
        browseMap.mapSelectionMode = .all
        present(browseMap, animated: false)
    }
    
}
