import UIKit
import SygicMaps
import SygicMapsKit

struct ModuleData {
    let title: String
    let subtitle: String
    let image: String
}

class BrowseExamplesTableViewController: UITableViewController {
    
    let modulesData = [
        ModuleData(title: "Browse Map - Default", subtitle: "Browse Map module with no configuration", image: "preview-browsemap-default"),
        ModuleData(title: "Browse Map - Full", subtitle: "Browse Map module with full configuration", image: "preview-browsemap-full"),
        ModuleData(title: "Browse Map - Tap handling", subtitle: "Browse Map module with own tap handling", image: "preview-browsemap-data"),
        ModuleData(title: "Custom annotation view", subtitle: "", image: ""),
        ModuleData(title: "Browse Map - Themes", subtitle: "Browse Map module with custom themes", image: ""),
        ModuleData(title: "Custom Pois", subtitle: "", image: ""),
        ModuleData(title: "Transition between modules", subtitle: "", image: "")
    ]
    
    private let cellHeight: CGFloat = 330

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Browse Map Examples"
        tableView.register(UINib(nibName: "ModuleExampleTableViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        tableView.separatorStyle = .none
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modulesData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ModuleExampleTableViewCell
        let data = modulesData[indexPath.row]
        cell.title = data.title
        cell.subtitle = data.subtitle
        cell.imageName = data.image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(SYMKBrowseMapViewController(), animated: true)
        case 1:
            navigationController?.pushViewController(browseMapWithAllControls(), animated: true)
        case 2:
            navigationController?.pushViewController(CustomDataHandlingViewController(), animated: true)
        case 3:
            navigationController?.pushViewController(CustomMarkerInfoExampleViewController(), animated: true)
        case 4:
            navigationController?.pushViewController(CustomSkinExampleViewController(), animated: true)
        case 5:
            navigationController?.pushViewController(CustomMarkersExampleViewController(), animated: true)
        case 6:
            navigationController?.pushViewController(BrowseModuleExampleViewController(), animated: true)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    private func browseMapWithAllControls() -> SYMKBrowseMapViewController {
        let browseMapVC = SYMKBrowseMapViewController()
        browseMapVC.showUserLocation = true
        browseMapVC.useCompass = true
        browseMapVC.useZoomControl = true
        browseMapVC.useRecenterButton = true
        browseMapVC.mapSelectionMode = .all
        browseMapVC.bounceDefaultPoiDetailFirstTime = true
        browseMapVC.mapState.geoCenter = SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)!
        browseMapVC.mapState.zoom = 16
        return browseMapVC
    }

}
