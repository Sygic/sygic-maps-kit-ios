import SygicMapsKit
import SygicUIKit
import SygicMaps


class BrowseMapWithSearchViewController: UIViewController, SYMKModulePresenter, SYMKSearchViewControllerDelegate {
    
    var presentedModules = [SYMKModuleViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let browseMap = SYMKBrowseMapViewController()
        browseMap.useCompass = true
        browseMap.useRecenterButton = true
        browseMap.useZoomControl = true
        browseMap.mapSelectionMode = .all
        
        presentModule(browseMap)
        
        setupSearchButton(for: browseMap)
    }
    
    private func setupSearchButton(for browseMap: SYMKBrowseMapViewController) {
        let searchButton = SYUIActionButton()
        searchButton.style = .secondary
        searchButton.icon = SYUIIcon.search
        searchButton.accessibilityIdentifier = "Search Button"
        searchButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        browseMap.view.addSubview(searchButton)
        searchButton.trailingAnchor.constraint(equalTo: browseMap.view.safeTrailingAnchor, constant: -16).isActive = true
        searchButton.bottomAnchor.constraint(equalTo: browseMap.view.safeBottomAnchor, constant: -16).isActive = true
    }
    
    @objc private func tapped() {
        let searchModule = SYMKSearchViewController()
        searchModule.delegate = self
        presentModule(searchModule)
    }
    
    func searchController(_ searchController: SYMKSearchViewController, didSearched results: [SYSearchResult]) {
        dismissModule()
        let alert = UIAlertController(title: nil, message: "\(results)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func searchControllerDidCancel(_ searchController: SYMKSearchViewController) {
        dismissModule()
    }

}


