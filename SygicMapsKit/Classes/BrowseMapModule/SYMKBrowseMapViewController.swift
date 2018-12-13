import SygicMaps
import SygicUIKit


public protocol SYMKBrowseMapViewControllerDelegate: class {
    func browseMapController(_ browseController: SYMKBrowseMapViewController, didSelectData: SYMKPoiDataProtocol)
}

public class SYMKBrowseMapViewController: UIViewController {
    
    // MARK: - Public Properties
    
    /**
        Delegate output for browse map controller
     */
    public weak var delegate: SYMKBrowseMapViewControllerDelegate?
    
    /**
        Enables compass functionality.
    */
    public var useCompass = true
    
    /**
        Enables zoom control functionality.
     */
    public var useZoomControl = true

    /**
        Enables recenter button functionality.
        Button is automatically shown if map camera isn't centered to current position. After tapping recenter button, camera is automatically recentered and button disappears.
    */
    public var useRecenterButton = true
    
    /**
        Current map selection mode.
        Map interaction allows user to tap certain objects on map. Place pin and place detail are displayed for selected object.
        - if MapSelectionMode.markers option is set, only customPois markers will interact to user selection
     */
    public var mapSelectionMode: SYMKMapSelectionManager.MapSelectionMode = .all {
        didSet {
            mapController?.selectionManager?.mapSelectionMode = mapSelectionMode
        }
    }
    
    /**
        Custom pois presented by markers in map.
     */
    public var customMarkers: [SYMKMapPin]? {
        didSet {
            addCustomMarkersToMap()
        }
    }
    
    // MARK: - Private Properties
    
    private var mapController: SYMKMapController?
    private var compassController = SYMKCompassController(course: 0, autoHide: true)
    private var recenterController = SYMKMapRecenterController()
    private var zoomController = SYMKZoomController()
    private var poiDetailViewController: SYUIPoiDetailViewController?
    
    private var mapControls = [MapControl]()
    
    // MARK: - Public Methods
    
    override public func loadView() {
        let browseView = SYMKBrowseMapView()
        if useCompass {
            browseView.setupCompass(compassController.compass)
        }
        if useRecenterButton {
            browseView.setupRecenter(recenterController.button)
        }
        if useZoomControl {
            browseView.setupZoomControl(zoomController.expandableButtonsView)
        }
        view = browseView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        SYMKSdkManager.shared.initializeIfNeeded { [weak self] success in
            if success {
                self?.sygicSDKInitialized()
            } else {
                self?.sygicSDKFailure()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func sygicSDKInitialized() {
        SYOnlineSession.shared().onlineMapsEnabled = true
        SYPositioning.shared().startUpdatingPosition()
        
        setupMapController()
        setupViewDelegates()
        mapControls = [compassController, zoomController, recenterController]
    }
    
    private func sygicSDKFailure() {
        let alert = UIAlertController(title: "Error", message: "Error during SDK initialization", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    
    private func setupMapController() {
        let mapController = SYMKMapController(with: nil)
        mapController.selectionManager = SYMKMapSelectionManager(with: mapSelectionMode)
        mapController.selectionManager?.delegate = self
        (view as! SYMKBrowseMapView).setupMapView(mapController.mapView)
        self.mapController = mapController
        addCustomMarkersToMap()
    }
    
    private func setupViewDelegates() {
        compassController.delegate = mapController
        recenterController.delegate = mapController
        zoomController.delegate = mapController
        mapController?.delegate = self
    }
    
    private func addCustomMarkersToMap() {
        guard let markers = customMarkers, let mapController = mapController else { return }
        for marker in markers {
            mapController.selectionManager?.addCustomPin(marker)
        }
    }
    
    // MARK: PoiDetail
    
    private func showPoiDetail(with data: SYMKPoiDetailModel) {
        poiDetailViewController = SYMKPoiDetailViewController(with: data)
        poiDetailViewController?.presentPoiDetailAsChildViewController(to: self, completion: nil)
    }
    
    private func hidePoiDetail() {
        guard let poiDetail = poiDetailViewController else { return }
        poiDetail.dismissPoiDetail(completion: { [weak self] _ in
            guard poiDetail == self?.poiDetailViewController else { return }
            self?.poiDetailViewController = nil
        })
    }
}

extension SYMKBrowseMapViewController: SYMKMapViewControllerDelegate {
    
    public func mapController(_ controller: SYMKMapController, didUpdate mapState: SYMKMapState, on mapView: SYMapView) {
        mapControls.forEach { $0.update(with: mapState) }
    }
    
}

extension SYMKBrowseMapViewController: SYMKMapSelectionDelegate {
    
    public func mapSelection(didSelect poiData: SYMKPoiDataProtocol) {
        guard let poiData = poiData as? SYMKPoiData else { return }
        if let delegate = delegate {
            delegate.browseMapController(self, didSelectData: poiData)
        } else {
            showPoiDetail(with: poiData)
        }
    }
    
    public func mapSelectionDeselectAll() {
        hidePoiDetail()
    }
    
}
