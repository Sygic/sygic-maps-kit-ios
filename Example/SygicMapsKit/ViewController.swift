import UIKit
import SygicMaps
import SygicUIKit
import SygicMapsKit

class ViewController: UIViewController {
    var mapView: SYMapView?
    var favoritePinManager: SYMKMapMarkersManager<SYMKMapPin>!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        favoritePinManager = SYMKMapMarkersManager(with: self)
    }
    
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
        symapView.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.favoritePinManager.clusterLayer = SYMapMarkersCluster()
            symapView.addMapMarkersCluster(self.favoritePinManager.clusterLayer!)
            
            for lat in 1...10 {
                for lon in 1...10 {
                    if let pin = SYMKMapPin(coordinate: SYGeoCoordinate(latitude: symapView.geoCenter.latitude + Double(lat)*0.003, longitude:symapView.geoCenter.longitude + Double(lon)*0.003)!, properties: SYUIPinViewViewModel(icon: SygicIcon.stationPetrol, color: .darkGray, selected: false, animated: false)) {
                        self.favoritePinManager.addMapMarker(pin)
                    }
                }
            }
        }
    }
}

extension ViewController: SYMKMapObjectsManager {
    func addMapObject(_ mapObject: SYMapObject) {
        mapView?.add(mapObject)
    }
    
    func removeMapObject(_ mapObject: SYMapObject) {
        mapView?.remove(mapObject)
    }
}

extension ViewController: SYMapViewDelegate {
    func mapView(_ mapView: SYMapView, didSelect objects: [SYViewObject]) {
        for obj in objects {
            if let mapMarker = obj as? SYMapMarker, let pin = favoritePinManager.findMarker(for: mapMarker) {
                favoritePinManager.highlightMarker(pin)
            }
        }
    }
}

