import UIKit
import SygicMaps
import SygicUIKit
import SygicMapsKit


class RootTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Browse Map Module"
        case 1:
            cell.textLabel?.text = "Custom Pois"
        case 2:
            cell.textLabel?.text = "Custom Marker Info"
        case 3:
            cell.textLabel?.text = "Custom Data handling"
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(BrowseModuleExampleViewController(), animated: true)
        case 1:
            navigationController?.pushViewController(CustomMarkersExampleViewController(), animated: true)
        case 2:
            navigationController?.pushViewController(CustomMarkerInfoExampleViewController(), animated: true)
        case 3:
            navigationController?.pushViewController(CustomDataHandlingViewController(), animated: true)
        default:
            break
        }
    }
}
