import UIKit
import SygicMaps
import SygicUIKit
import SygicMapsKit


class BrowseMapSelectionModesExampleViewController: UIViewController, SYMKModulePresenter {
    
    var presentedModules = [SYMKModuleViewController]()
    var browseMap: SYMKBrowseMapViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selection Modes Example"
        
        let browseMapModule = SYMKBrowseMapViewController()
        browseMapModule.useZoomControl = true
        browseMapModule.useRecenterButton = true
        browseMapModule.mapSelectionMode = .all
        browseMapModule.customMarkers = customMarkers()
        browseMapModule.mapState.geoCenter = SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)!
        browseMapModule.mapState.zoom = 16
        browseMap = browseMapModule
        
        presentModule(browseMapModule)
        
        setupModesSelectionButton()
    }
    
    private func customMarkers() -> [SYMKMapPin] {
        let pin1 = SYMKMapPin(coordinate: SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)!, icon: SYUIIcon.apple, color: .gray)!
        let pin2 = SYMKMapPin(coordinate: SYGeoCoordinate(latitude: 48.147128, longitude: 17.104651)!, icon: SYUIIcon.sygic, color: .red)!
        return [pin1, pin2]
    }
    
    private func setupModesSelectionButton() {
        let modeSelectButton = SYUIActionButton()
        modeSelectButton.style = .secondary
        modeSelectButton.title = "Selection mode"
        modeSelectButton.height = 44
        modeSelectButton.titleSize = 15
        modeSelectButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        modeSelectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modeSelectButton)
        modeSelectButton.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -16).isActive = true
        modeSelectButton.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 16).isActive = true
    }
    
    @objc private func tapped() {
        let modes = UIAlertController(title: "Selection Modes", message: nil, preferredStyle: .actionSheet)
        modes.addAction(UIAlertAction(title: "All", style: .default, handler: { [weak self] _ in
            self?.browseMap?.mapSelectionMode = .all
        }))
        modes.addAction(UIAlertAction(title: "Markers only", style: .default, handler: { [weak self] _ in
            self?.browseMap?.mapSelectionMode = .markers
        }))
        modes.addAction(UIAlertAction(title: "None", style: .default, handler: { [weak self] _ in
            self?.browseMap?.mapSelectionMode = .none
        }))
        present(modes, animated: true)
    }
    
}
