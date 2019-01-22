import SygicMaps
import SygicUIKit


public protocol SYMKBrowseMapViewControllerDelegate: class {
    func browseMapController(_ browseController: SYMKBrowseMapViewController, didSelect data: SYMKPoiDataProtocol)
}

public class SYMKBrowseMapViewController: SYMKModuleViewController {
    
    // MARK: - Public Properties
    
    /**
        Delegate output for browse map controller
     */
    public weak var delegate: SYMKBrowseMapViewControllerDelegate?
    
    /**
        Enables compass functionality.
    */
    public var useCompass = false
    
    /**
        Enables zoom control functionality.
     */
    public var useZoomControl = false

    /**
        Enables recenter button functionality.
        Button is automatically shown if map camera isn't centered to current position. After tapping recenter button, camera is automatically recentered and button disappears.
    */
    public var useRecenterButton = false
    
    /**
        Enables bounce in animation on first appearance of default poi detail bottom sheet
     */
    public var bounceDefaultPoiDetailFirstTime = false
    
    /**
        Current map selection mode.
        Map interaction allows user to tap certain objects on map. Place pin and place detail are displayed for selected object.
        - if MapSelectionMode.markers option is set, only customPois markers will interact to user selection
     */
    public var mapSelectionMode: SYMKMapSelectionManager.MapSelectionMode = .markers {
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
            mapControls.append(compassController)
        }
        if useRecenterButton {
            browseView.setupRecenter(recenterController.button)
            mapControls.append(recenterController)
        }
        if useZoomControl {
            browseView.setupZoomControl(zoomController.expandableButtonsView)
            mapControls.append(zoomController)
        }
        view = browseView
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        if let map = mapState.map {
            (view as! SYMKBrowseMapView).setupMapView(map)
            map.delegate = mapController
            map.setup(with: mapState)
        }
        super.viewDidAppear(animated)
    }
        
    // MARK: - Private Methods
    
    internal override func sygicSDKInitialized() {
        SYOnlineSession.shared().onlineMapsEnabled = true
        SYPositioning.shared().startUpdatingPosition()
        
        setupMapController()
        setupViewDelegates()
    }
    
    internal override func sygicSDKFailure() {
        let alert = UIAlertController(title: "Error", message: "Error during SDK initialization", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    
    private func setupMapController() {
        let mapController = SYMKMapController(with: mapState, mapFrame: view.bounds)
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
        poiDetailViewController?.presentPoiDetailAsChildViewController(to: self, bounce: bounceDefaultPoiDetailFirstTime, completion: nil)
        bounceDefaultPoiDetailFirstTime = false
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
    
    public func mapSelectionShouldAddPoiPin() -> Bool {
        return delegate == nil
    }
    
    public func mapSelection(didSelect poiData: SYMKPoiDataProtocol) {
        guard let poiData = poiData as? SYMKPoiData else { return }
        if let delegate = delegate {
            delegate.browseMapController(self, didSelect: poiData)
        } else {
            showPoiDetail(with: poiData)
        }
    }
    
    public func mapSelectionDeselectAll() {
        hidePoiDetail()
    }
    
}
