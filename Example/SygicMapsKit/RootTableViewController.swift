import UIKit
import SygicMaps
import SygicUIKit
import SygicMapsKit


class RootTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Browse Map"
        case 1:
            cell.textLabel?.text = "Search"
        case 2:
            cell.textLabel?.text = "Navigation"
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(BrowseExamplesTableViewController(), animated: true)
        default:
            break
        }
    }
}
