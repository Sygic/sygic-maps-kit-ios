import SygicMaps
import SygicUIKit


/// output
public protocol SYMKSearchViewControllerDelegate {
    
    func searchController(_ searchController: SYMKSearchViewController, didSearched results: [Any])
}

public class SYMKSearchViewController: SYMKModuleViewController {
    
    /// input
    public func prefillSearch(with text: String) {
        
    }
    
    /// input
    public func mapCoordinates(coordinates: SYGeoCoordinate) {
        
    }
    
    public override func loadView() {
        let searchView = SYMKSearchView()
        view = searchView
    }
    
}
