import SygicMaps
import SygicUIKit


/// output
public protocol SYMKSearchViewControllerDelegate {
    
    func searchController(_ searchController: SYMKSearchViewController, didSearched results: [Any])
}

public class SYMKSearchViewController: SYMKModuleViewController {
    
    // MARK: - Public properties
    
    var resultsViewController: SYUISearchResultsViewController<SYSearchResult> = SYUISearchResultsTableViewController<SYSearchResult>()
    
    // MARK: - Public methods
    
    /// input
    public func prefillSearch(with text: String) {
        
    }
    
    /// input
    public func mapCoordinates(coordinates: SYGeoCoordinate) {
        
    }
    
    public override func loadView() {
        let searchView = SYMKSearchView()
        view = searchView
        
        addChild(resultsViewController)
        searchView.setupResultsView(resultsViewController.view)
    }
    
    // MARK: - Private methods
}
