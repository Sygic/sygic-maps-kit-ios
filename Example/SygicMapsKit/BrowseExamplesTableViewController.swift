import UIKit
import SygicMapsKit

class BrowseExamplesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Browse map examples"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Default Browse Map"
        case 1:
            cell.textLabel?.text = "Browse Map with all default controls"
        case 2:
            cell.textLabel?.text = "Custom callback"
        case 3:
            cell.textLabel?.text = "Custom annotation view"
        case 4:
            cell.textLabel?.text = "Custom Skin"
        case 5:
            cell.textLabel?.text = "Custom Pois"
        case 6:
            cell.textLabel?.text = "Transition between modules"
        default:
            break
        }
        
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(SYMKBrowseMapViewController(), animated: true)
        case 1:
            let browseMapVC = SYMKBrowseMapViewController()
            browseMapVC.showUserLocation = true
            browseMapVC.useCompass = true
            browseMapVC.useZoomControl = true
            browseMapVC.useRecenterButton = true
            browseMapVC.mapSelectionMode = .all
            browseMapVC.bounceDefaultPoiDetailFirstTime = true
            navigationController?.pushViewController(browseMapVC, animated: true)
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

}
