import UIKit
import SygicMaps
import SygicMapsKit


class SearchExamplesTableViewController: UITableViewController {
    
    let modulesData = [
        ModuleData(title: "Search - Default", subtitle: "Search module with no configuration", image: ""),
        ModuleData(title: "Browse Map with Search", subtitle: "Browse Map module with action button transitioning to search", image: "")
    ]
    
    private let cellHeight: CGFloat = 330

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search Examples"
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
            navigationController?.pushViewController(SYMKSearchViewController(), animated: true)
        case 1:
            navigationController?.pushViewController(BrowseMapWithSearchViewController(), animated: true)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

}
