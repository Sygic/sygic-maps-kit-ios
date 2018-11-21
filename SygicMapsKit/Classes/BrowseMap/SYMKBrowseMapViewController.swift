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
            view.compass.viewModel = SYUICompassViewModel(course: 0, autoHide: true)
            view.compass.isHidden = !useCompass
        }
    }
    
    // MARK: - Private Methods
    
    private func sygicSDKInitialized() {
        SYOnlineSession.shared().onlineMapsEnabled = true
        (view as! SYMKBrowserMapView).setupMapView()
        setupViewDelegates()
    }
    
    private func sygicSDKFailure() {
        let alert = UIAlertController(title: "Error", message: "Error during SDK initialization", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    
    private func setupViewDelegates() {
        guard let view = view as? SYMKBrowserMapView, let mapView = view.mapView else { return }
        mapView.delegate = self
        view.compass.delegate = self
    }
    
}

// MARK: - Map delegate

extension SYMKBrowseMapViewController: SYMapViewDelegate {
    
    public func mapView(_ mapView: SYMapView, didChangeCameraPosition geoCenter: SYGeoCoordinate, zoom: CGFloat, rotation: CGFloat, tilt: CGFloat) {
        guard let view = view as? SYMKBrowserMapView else { return }
        
        if useCompass, let compassViewModel = view.compass.viewModel {
            var newViewModel = SYUICompassViewModel(with: compassViewModel)
            newViewModel.compassCourse = Double(rotation)
            view.compass.viewModel = newViewModel
        }
    }
    
}

// MARK: - Compass Delegate

extension SYMKBrowseMapViewController: SYUICompassDelegate {
    
    public func compassDidTap(_ compass: SYUICompass) {
        guard let view = view as? SYMKBrowserMapView, let mapView = view.mapView else { return }
        
        let rotationAngle = mapView.rotation < 180.0 ? -mapView.rotation : 360.0 - mapView.rotation
        mapView.rotateView(rotationAngle, withDuration: 0.2, curve: .decelerate, completion: nil)
    }
    
}

// MARK: - SDK handling

extension SYMKBrowseMapViewController {
    
    private func initSygicMapsSDK() {
        SYContext.initWithAppKey(SYMKApiKeys.appKey, appSecret: SYMKApiKeys.appSecret) { initResult in
            if initResult == .success {
                self.sygicSDKInitialized()
            } else {
                self.sygicSDKFailure()
            }
        }
    }
    
}
