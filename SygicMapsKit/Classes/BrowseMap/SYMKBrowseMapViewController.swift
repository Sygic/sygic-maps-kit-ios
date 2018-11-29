import SygicMaps
import SygicUIKit


public class SYMKBrowseMapViewController: UIViewController {
    /// Map selection mode
    public enum MapSelectionMode {
        /// No selection
        case none
        /// Allows to select map markers
        case markers
        /// Allows to select anything on map
        case all
    }

    public var useCompass = true

    /**
        Enables recenter button functionality.
        Button is automatically shown if map camera isn't centered to current position. After tapping recenter button, camera is automatically recentered and button disappears.
    */
    public var useRecenterButton = true
    
    /**
        Current map selection mode.
        Map interaction allows user to tap certain objects on map. Place pin and place detail are displayed for selected object.
     */
    public var mapSelectionMode = MapSelectionMode.all
    
    private var mapSelectionManager = SYMKMapMarkersManager<SYMKMapPin>()
    private var compassController = SYUICompassController(course: 0, autoHide: true)
    private var poiDetailDataSource: SYMKPoiDetailDataSource?
    private var poiDetailViewController: SYUIPoiDetailViewController?
    
    override public func loadView() {
        let browseView = SYMKBrowseMapView()
        browseView.setupCompass(compassController.compass)
        browseView.recenter.setup(with: SYUIActionButtonViewModel(title: "", icon: SygicIcon.positionLockIos, style: .secondary))
        browseView.recenter.isHidden = !useRecenterButton
        view = browseView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        initSygicMapsSDK()
    }
    
    // MARK: - Private Methods
    
    private func sygicSDKInitialized() {
        SYOnlineSession.shared().onlineMapsEnabled = true
        SYPositioning.shared().startUpdatingPosition()
        (view as! SYMKBrowseMapView).setupMapView()
        setupViewDelegates()
        setupMapSelectionManager()
    }
    
    private func sygicSDKFailure() {
        let alert = UIAlertController(title: "Error", message: "Error during SDK initialization", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    
    private func setupViewDelegates() {
        guard let view = view as? SYMKBrowseMapView, let mapView = view.mapView else { return }
        mapView.delegate = self
        view.recenter.addTarget(self, action: #selector(SYMKBrowseMapViewController.didTapRecenterButton), for: .touchUpInside)
        compassController.delegate = self
    }
    
    private func setupMapSelectionManager() {
        guard let view = view as? SYMKBrowseMapView, let mapView = view.mapView else { return }
        mapSelectionManager.mapObjectsManager = self
        mapSelectionManager.clusterLayer = SYMapMarkersCluster()
        mapView.addMapMarkersCluster(mapSelectionManager.clusterLayer!)
    }
    
    // MARK: - PoiDetail
    
    private func showPoiDetail(with poiDetailData: SYMKPoiDetailDataSource) {
        poiDetailDataSource = poiDetailData
        poiDetailViewController = SYUIPoiDetailViewController()
        poiDetailViewController?.dataSource = poiDetailData
        poiDetailViewController?.presentPoiDetailAsChildViewController(to: self, completion: nil)
    }
    
    private func hidePoiDetail() {
        guard let poiDetail = poiDetailViewController else { return }
        poiDetail.dismissPoiDetail(completion: { [weak self] _ in
            guard poiDetail == self?.poiDetailViewController else { return }
            self?.poiDetailViewController = nil
            self?.poiDetailDataSource = nil
        })
    }
    
    // MARK: - Actions
    
    @objc func didTapRecenterButton() {
        guard let view = view as? SYMKBrowseMapView, let mapView = view.mapView else { return }
        mapView.cameraMovementMode = .followGpsPositionWithAutozoom
        mapView.cameraRotationMode = .vehicle
    }
}

// MARK: - Map delegate

extension SYMKBrowseMapViewController: SYMapViewDelegate {
    
    public func mapView(_ mapView: SYMapView, didChangeCameraPosition geoCenter: SYGeoCoordinate, zoom: CGFloat, rotation: CGFloat, tilt: CGFloat) {
        compassController.course = Double(rotation)
    }
    
    public func mapView(_ mapView: SYMapView, didChangeCameraMovementMode mode: SYCameraMovement) {
        guard let view = view as? SYMKBrowseMapView else { return }
        view.recenter.isHidden = !useRecenterButton || (mode != SYCameraMovement.free)
        
        if mode == .free {
            view.mapView?.cameraRotationMode = .free
        }
    }
    
    public func mapView(_ mapView: SYMapView, didSelect objects: [SYViewObject]) {
        guard mapSelectionMode != .none else { return }
        
        let hadPin = !mapSelectionManager.markers.isEmpty
        if !mapSelectionManager.markers.isEmpty {
            mapSelectionManager.removeAllMarkers()
            hidePoiDetail()
        }
        
        var viewObj: SYViewObject?
        
        for obj in objects {
            if let poi = obj as? SYPoiObject, poi.type == .poi, mapSelectionMode == .all {
                SYPlaces.shared().loadPoiObjectPlace(poi) { (place: SYPlace) in
                    let category = SYMKPoiCategory.with(syPoiCategory: place.category)
                    if let pin = SYMKMapPin(coordinate: place.coordinate, icon: category.icon, color: category.color, highlighted: true) {
                        self.mapSelectionManager.addMapMarker(pin)
                        self.showPoiDetail(with: SYMKPoiDetailDataSource(with: place))
                    }
                }
                return
            } else if let marker = viewObj as? SYMapMarker, mapSelectionMode == .markers {
                viewObj = marker
            } else if mapSelectionMode == .all && viewObj == nil {
                viewObj = obj
            }
        }
        
        if hadPin {
            return
        }
        
        if let coord = viewObj?.coordinate {
            if let pin = SYMKMapPin(coordinate: coord, icon: SygicIcon.POIPoi, color: .darkGray, highlighted: true) {
                mapSelectionManager.addMapMarker(pin)
                showPoiDetail(with: SYMKPoiDetailDataSource(with: coord))
            }
        }
    }

}

// MARK: - Compass Delegate

extension SYMKBrowseMapViewController: SYUICompassDelegate {
    public func compassDidTap(_ compass: SYUICompass) {
        guard let view = view as? SYMKBrowseMapView, let mapView = view.mapView else { return }
        
        if mapView.cameraMovementMode != .free {
            mapView.cameraRotationMode = .northUp
        } else {
            let rotationAngle = mapView.rotation < 180.0 ? -mapView.rotation : 360.0 - mapView.rotation
            mapView.rotateView(rotationAngle, withDuration: 0.2, curve: .decelerate, completion: nil)
        }
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

extension SYMKBrowseMapViewController : SYMKMapObjectsManager {
    public func addMapObject(_ mapObject: SYMapObject) {
        guard let view = view as? SYMKBrowseMapView, let mapView = view.mapView else { return }
        mapView.add(mapObject)
    }

    public func removeMapObject(_ mapObject: SYMapObject) {
        guard let view = view as? SYMKBrowseMapView, let mapView = view.mapView else { return }
        mapView.remove(mapObject)
    }
}
