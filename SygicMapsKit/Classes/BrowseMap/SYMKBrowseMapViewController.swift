import SygicMaps
import SygicUIKit


public class SYMKBrowseMapViewController: UIViewController {
    
    public var useCompass = true
    private var pinManager = SYMKMapMarkersManager<SYMKMapPin>()
    
    override public func loadView() {
        view = SYMKBrowserMapView()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        initSygicMapsSDK()
        
        if let view = (view as? SYMKBrowserMapView) {
            view.compass.isHidden = !useCompass
        }
    }
    
    // MARK: - Private Methods
    
    private func sygicSDKInitialized() {
        SYOnlineSession.shared().onlineMapsEnabled = true
        (view as! SYMKBrowserMapView).setupMapView()
        setupDelegates()
        setupPinManager()
    }
    
    private func setupDelegates() {
        guard let view = view as? SYMKBrowserMapView, let mapView = view.mapView else { return }
        view.compass.delegate = self
        mapView.delegate = self
    }
    
    private func setupPinManager() {
        guard let view = view as? SYMKBrowserMapView, let mapView = view.mapView else { return }
        pinManager.mapObjectsManager = self
        pinManager.clusterLayer = SYMapMarkersCluster()
        mapView.addMapMarkersCluster(self.pinManager.clusterLayer!)
    }
}

extension SYMKBrowseMapViewController: SYMapViewDelegate {
    
    public func mapView(_ mapView: SYMapView, didChangeCameraPosition geoCenter: SYGeoCoordinate, zoom: CGFloat, rotation: CGFloat, tilt: CGFloat) {
        guard let view = view as? SYMKBrowserMapView else { return }
        
        if useCompass {
            view.compass.isHidden = (rotation == 0)
            view.compass.viewModel = SYUICompassViewModel(course: Double(rotation), autoHide: false)
        }
    }
    
    public func mapView(_ mapView: SYMapView, didSelect objects: [SYViewObject]) {
        if !pinManager.markers.isEmpty {
            self.pinManager.removeAllMarkers()
            return
        }
        
        var viewObj: SYViewObject?
        
        for obj in objects {
            if let poi = obj as? SYPoiObject, poi.type == .poi {
                SYPlaces.shared().loadPoiObjectPlace(poi) { (place: SYPlace) in
                    let pin = SYMKMapPin(coordinate: place.coordinate, properties: SYUIPinViewViewModel(icon: SygicIcon.stationPetrol, color: .darkGray, selected: true, animated: false))
                    self.pinManager.addMapMarker(pin)
                }
                return
            } else {
                viewObj = obj
            }
        }
        
        if let coord = viewObj?.coordinate {
            let pin = SYMKMapPin(coordinate: coord, properties: SYUIPinViewViewModel(icon: SygicIcon.POIPoi, color: .darkGray, selected: true, animated: false))
            self.pinManager.addMapMarker(pin)
        }
    }

}

extension SYMKBrowseMapViewController: SYUICompassDelegate {
    
    public func compassDidTap(_ compass: SYUICompass) {
        guard let view = view as? SYMKBrowserMapView, let mapView = view.mapView else { return }
        
        let rotationAngle = mapView.rotation < 180.0 ? -mapView.rotation : 360.0 - mapView.rotation
        mapView.rotateView(rotationAngle, withDuration: 0.2, curve: .decelerate, completion: nil)
        compass.isHidden = true
    }
    
}

extension SYMKBrowseMapViewController {
    
    private func initSygicMapsSDK() {
        SYContext.initWithAppKey(SYMKApiKeys.appKey, appSecret: SYMKApiKeys.appSecret) { initResult in
            if initResult == .success {
                self.sygicSDKInitialized()
            }
        }
    }
    
}

extension SYMKBrowseMapViewController : SYMKMapObjectsManager {
    public func addMapObject(_ mapObject: SYMapObject) {
        guard let view = view as? SYMKBrowserMapView, let mapView = view.mapView else { return }
        mapView.add(mapObject)
    }

    public func removeMapObject(_ mapObject: SYMapObject) {
        guard let view = view as? SYMKBrowserMapView, let mapView = view.mapView else { return }
        mapView.remove(mapObject)
    }
}

