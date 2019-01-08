import SygicMaps


public protocol SYMKRouteComputeControllerProtocol: class {
    func routeComputeControllerGoBack()
}

public class SYMKRouteComputeController: ModuleUIViewController {
    
    public var useTraffic = true
    public var computeMultipleRoutes = true
    
    public weak var delegate: SYMKRouteComputeControllerProtocol?
    
    private var mapController: SYMKMapController?
    
    public var mapState: SYMKMapState = SYMKMapState() {
        didSet {
            mapState = mapState.copy() as! SYMKMapState
        }
    }
    
    public override func loadView() {
        let routeComputeView = SYMKRouteComputeView()
        routeComputeView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view = routeComputeView
    }
    
    @objc public func backButtonTapped() {
        delegate?.routeComputeControllerGoBack()
    }
    
    override internal func sygicSDKInitialized() {
        SYOnlineSession.shared().onlineMapsEnabled = true
        SYPositioning.shared().startUpdatingPosition()
        
        setupMapController()
    }
    
    override internal func sygicSDKFailure() {
        let alert = UIAlertController(title: "Error", message: "Error during SDK initialization", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    
    private func setupMapController() {
        let mapController = SYMKMapController(with: mapState)
        mapController.selectionManager = SYMKMapSelectionManager(with: .none)
        (view as! SYMKRouteComputeView).setupMapView(mapController.mapView)
        self.mapController = mapController
    }
    
}
