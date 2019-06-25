import UIKit
import SygicMaps
import SygicMapsKit


class SearchExamplesTableViewController: UITableViewController {
    
    let modulesData = [
        ModuleData(title: "Search - Default", subtitle: "Search module with geo coordinates", image: "preview-search-basic"),
        ModuleData(title: "Browse Map with Search", subtitle: "Browse Map module with action button transitioning to search", image: "preview-search-browsemap"),
        ModuleData(title: "Search Results on Map", subtitle: "Browse map module with search results", image: "preview-search-results"),
        ModuleData(title: "Prefill Search", subtitle: "Search module with prefill search and geo coordinates", image: "preview-search-basic")
    ]
    
    private let cellHeight: CGFloat = 330
    private let reuseIdentifier = String(describing: ModuleExampleTableViewCell.self)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search Examples"
        tableView.register(UINib(nibName: "ModuleExampleTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modulesData.count
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ModuleExampleTableViewCell
        let data = modulesData[indexPath.row]
        cell.title = data.title
        cell.subtitle = data.subtitle
        cell.imageName = data.image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let searchModule = SYMKSearchViewController()
            searchModule.searchCoordinates = SYGeoCoordinate(latitude: 48.147128, longitude: 17.103641)!
            navigationController?.pushViewController(searchModule, animated: true)
        case 1:
            navigationController?.pushViewController(BrowseMapWithSearchViewController(), animated: true)
        case 2:
            navigationController?.pushViewController(BrowseMapWithSearchResults(), animated: true)
        case 3:
            let searchModule = SYMKSearchViewController()
            searchModule.searchCoordinates = SYGeoCoordinate(latitude: 51.507320, longitude: -0.127786)!
            searchModule.maxResultsCount = 5
            searchModule.prefillSearch(with: "London Eye")
            navigationController?.pushViewController(searchModule, animated: true)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

}
