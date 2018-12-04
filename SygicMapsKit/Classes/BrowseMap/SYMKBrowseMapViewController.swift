import SygicMaps
import SygicUIKit


public class SYMKBrowseMapViewController: UIViewController {
    
    // MARK: - Public Properties
    
    /// Map selection mode
    public enum MapSelectionMode {
        /// No selection
        case none
        /// Allows to select map markers
        case markers
        /// Allows to select anything on map
        case all
    }
    
    public enum ZoomActionType: CGFloat {
        case zoomIn = 1
        case zoomOut = -1
    }
    
    public enum Tilt: CGFloat {
        case _2D = 0.0
        case _3D = 80.0
    }

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
     */
    public var mapSelectionMode = MapSelectionMode.all
    
    // MARK: - Private Properties
    
    private var mapSelectionManager = SYMKMapMarkersManager<SYMKMapPin>()
    private var compassController = SYUICompassController(course: 0, autoHide: true)
    private var recenterController = SYMKMapRecenterController()
    private var zoomController = SYUIZoomController()
    private var poiDetailViewController: SYUIPoiDetailViewController?
    
    private var reverseSearch: SYReverseSearch!
    
    // MARK: - Public Methods
    
    override public func loadView() {
        let browseView = SYMKBrowseMapView()
        browseView.setupCompass(compassController.compass)
        browseView.setupRecenter(recenterController.button)
        browseView.setupZoomControl(zoomController.expandableButtonsView)
        recenterController.button.isHidden = !useRecenterButton
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
        
        reverseSearch = SYReverseSearch()
    }
    
    private func sygicSDKFailure() {
        let alert = UIAlertController(title: "Error", message: "Error during SDK initialization", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    
    private func setupViewDelegates() {
        guard let view = view as? SYMKBrowseMapView, let mapView = view.mapView else { return }
        mapView.delegate = self

        compassController.delegate = self
        recenterController.delegate = self
        zoomController.delegate = self
    }
    
    private func setupMapSelectionManager() {
        guard let view = view as? SYMKBrowseMapView, let mapView = view.mapView else { return }
        mapSelectionManager.mapObjectsManager = self
        mapSelectionManager.clusterLayer = SYMapMarkersCluster()
        mapView.addMapMarkersCluster(mapSelectionManager.clusterLayer!)
    }
    
    private func rotateMapNorth() {
        guard let view = view as? SYMKBrowseMapView, let mapView = view.mapView else { return }
        let rotationAngle = mapView.rotation < 180.0 ? -mapView.rotation : 360.0 - mapView.rotation
        mapView.rotateView(rotationAngle, withDuration: 0.2, curve: .decelerate, completion: nil)
    }
    
    private func zoomMap(_ zoomAction: ZoomActionType) {
        guard let view = view as? SYMKBrowseMapView, let mapView = view.mapView else { return }
        mapView.animate({
            mapView.zoom += zoomAction.rawValue
        }, withDuration: 0.3, curve: .linear, completion: nil)
    }
    
    // TODO: Refactor to MapController
    private func handleTilt() {
        guard let view = view as? SYMKBrowseMapView, let mapView = view.mapView else { return }
        
        let isActual3D = mapView.tilt >= 0.01
        let newTilt = isActual3D ? Tilt._2D : Tilt._3D
        zoomController.is3D = !isActual3D
        
        mapView.animate({
            mapView.tilt = newTilt.rawValue
        }, withDuration: 0.2, curve: .decelerate, completion: nil)
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

// MARK: - Map delegate

extension SYMKBrowseMapViewController: SYMapViewDelegate {
    
    public func mapView(_ mapView: SYMapView, didChangeCameraPosition geoCenter: SYGeoCoordinate, zoom: CGFloat, rotation: CGFloat, tilt: CGFloat) {
        compassController.course = Double(rotation)
    }
    
    public func mapView(_ mapView: SYMapView, didChangeCameraMovementMode mode: SYCameraMovement) {
        guard let view = view as? SYMKBrowseMapView else { return }
        
        if mode == .free {
            recenterController.allowedStates = [.free, .locked]
            recenterController.currentState = .free
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
                SYPlaces.shared().loadPoiObjectPlace(poi) { [weak self] (place: SYPlace) in
                    let category = SYMKPoiCategory.with(syPoiCategory: place.category)
                    if let pin = SYMKMapPin(coordinate: place.coordinate, icon: category.icon, color: category.color, highlighted: true) {
                        self?.mapSelectionManager.addMapMarker(pin)
                        self?.showPoiDetail(with: place)
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
        
        if let coordinate = viewObj?.coordinate {
            if let pin = SYMKMapPin(coordinate: coordinate, icon: SygicIcon.POIPoi, color: .darkGray, highlighted: true) {
                mapSelectionManager.addMapMarker(pin)
                reverseSearch.reverseSearch(with: coordinate) { [weak self] results in
                    guard let result = results.first else { return }
                    self?.showPoiDetail(with: result)
                }
            }
        }
    }
}

// MARK: - Compass Delegate

extension SYMKBrowseMapViewController: SYUICompassDelegate {
    public func compassDidTap(_ compass: SYUICompass) {
        guard let view = view as? SYMKBrowseMapView, let mapView = view.mapView else { return }
        
        if mapView.cameraMovementMode != .free {
            mapView.cameraRotationMode = .free
            recenterController.currentState = .locked
        }
        
        rotateMapNorth()
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

// MARK: - Map Objects Manager

extension SYMKBrowseMapViewController: SYMKMapObjectsManager {
    public func addMapObject(_ mapObject: SYMapObject) {
        guard let view = view as? SYMKBrowseMapView, let mapView = view.mapView else { return }
        mapView.add(mapObject)
    }

    public func removeMapObject(_ mapObject: SYMapObject) {
        guard let view = view as? SYMKBrowseMapView, let mapView = view.mapView else { return }
        mapView.remove(mapObject)
    }
}

// MARK: - Map Recenter delegate

extension SYMKBrowseMapViewController: SYMKMapRecenterDelegate {
    public func didChangeRecenterButtonState(button: SYUIActionButton, state: SYMKMapRecenterController.state) {
        guard let view = view as? SYMKBrowseMapView, let mapView = view.mapView else { return }
        
        switch state {
        case .locked:
            recenterController.allowedStates = [.locked, .lockedCompass]
            mapView.cameraMovementMode = .followGpsPositionWithAutozoom
            if mapView.cameraRotationMode == .attitude {
                mapView.cameraRotationMode = .free
                rotateMapNorth()
            }
        case .lockedCompass:
            mapView.cameraMovementMode = .followGpsPositionWithAutozoom
            mapView.cameraRotationMode = .attitude
        default:
            break
        }
    }
}

extension SYMKBrowseMapViewController: SYUIZoomControllerDelegate {
    public func zoomController(wants activity: SYUIZoomActivity) {
        switch activity {
        case .zoomIn, .zoomingIn:
            zoomMap(.zoomIn)
        case .zoomOut, .zoomingOut:
            zoomMap(.zoomOut)
        case .toggle3D:
            handleTilt()
        default:
            break
        }
    }
}
