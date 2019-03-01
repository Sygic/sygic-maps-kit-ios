import SygicMapsKit
import SygicUIKit


class BrowseMapWithSearchViewController: UIViewController, SYMKModulePresenter {
    
    var presentedModules = [SYMKModuleViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let browseMap = SYMKBrowseMapViewController()
        browseMap.useCompass = true
        browseMap.useRecenterButton = true
        browseMap.useZoomControl = true
        browseMap.mapSelectionMode = .all
        
        presentModule(browseMap)
        
        setupSearchButton()
    }
    
    private func setupSearchButton() {
        let searchButton = SYUIActionButton()
        searchButton.style = .secondary
        searchButton.icon = SYUIIcon.search
        searchButton.accessibilityIdentifier = "Search Button"
        searchButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchButton)
        searchButton.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -16).isActive = true
        searchButton.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -16).isActive = true
    }
    
    @objc private func tapped() {
        let searchModule = SYMKSearchViewController()
        presentModule(searchModule)
    }

}
