import UIKit
import SygicMaps
import SygicUIKit
import SygicMapsKit


class RootTableViewController: UITableViewController {
    
    let mapsKitGithub = "https://github.com/Sygic/sygic-maps-kit-ios"
    let mapsKitWiki = "https://github.com/Sygic/sygic-maps-kit-ios/wiki"
    let sectionsData = ["Modules", "Getting started!"]
    let rowsData = [["Browse Map", "Search", "Navigation"],
                    ["Source code", "Wiki"]]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsData.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsData[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsData[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = rowsData[indexPath.section][indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            navigationController?.pushViewController(BrowseExamplesTableViewController(), animated: true)
        }
        
        if indexPath.section == 0 && indexPath.row == 1 {
            navigationController?.pushViewController(SearchExamplesTableViewController(), animated: true)
        }
        
        if indexPath.section == 1 {
            let url = indexPath.row == 0 ? mapsKitGithub : mapsKitWiki
            guard let safariUrl = URL(string: url) else { return }
            UIApplication.shared.open(safariUrl)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}
