import UIKit
import SygicMaps
import SygicUIKit

class ViewController: UIViewController {
    var mapView: SYMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SYContext.isInitialized() {
            addMapView()
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(self.addMapView), name: Notification.Name("SDKdone"), object: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func addMapView() {
        mapView = SYMapView(frame: view.frame, geoCenter: SYGeoCoordinate(latitude: 48.14816, longitude: 17.10674)!, rotation: 0, zoom: 15, tilt: 0)
        guard let symapView = mapView  else {
            return
        }
        
        view.addSubview(symapView)
        symapView.translatesAutoresizingMaskIntoConstraints = false;
        symapView.coverWholeSuperview()
    }
}

