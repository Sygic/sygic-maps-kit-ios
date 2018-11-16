import SygicMaps
import SygicUIKit


public class SYMKBrowseMapViewController: UIViewController {
    
    public var useCompass = true
    
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
        setupViewDelegates()
    }
    
    private func setupViewDelegates() {
        guard let view = view as? SYMKBrowserMapView, let mapView = view.mapView else { return }
        view.compass.delegate = self
        mapView.delegate = self
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
