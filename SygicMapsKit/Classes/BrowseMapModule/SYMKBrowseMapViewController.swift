//// SYMKBrowseMapViewController.swift
//
// Copyright (c) 2019 - Sygic a.s.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the &quot;Software&quot;), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import SygicMaps
import SygicUIKit


/// Browse map module output protocol.
///
/// Adopting of this protocol overrides default behaviour, which means, bottom sheet
/// is no longer showed after tap on map. Delegate receives raw data instead.
public protocol SYMKBrowseMapViewControllerDelegate: class {
    
    /// Delegate receives data about (point of interest) that was selected on map.
    ///
    /// - Parameters:
    ///   - browseController: Browse map module controller.
    ///   - data: Data about selected point of interest.
    func browseMapController(_ browseController: SYMKBrowseMapViewController, didSelect data: SYMKPoiDataProtocol)
}

/// Browse map module annotation protocol.
///
/// In case you want draw custom `UIView` object on map, you must conform to this protocol.
/// Add annotation object (object with coordinates) with `addAnnotation(SYAnnotation)` method
public protocol SYMKBrowserMapViewControllerAnnotationDelegate: class {
    
    /// When map reaches some annotation, this method is called. It needs `SYAnnotationView` object
    /// to draw at annotations coordinates on map.
    /// - Parameters:
    ///   - browseController: Browse map module controller.
    ///   - annotation: Annotation for that view is needed.
    /// - Returns: View drawn on map.
    func browseMapController(_ browseController: SYMKBrowseMapViewController, wantsViewFor annotation: SYAnnotation) -> SYAnnotationView
}

/// Browse Map module.
///
/// Browse Map module contains map on whole screen. You can use map controls:
/// - compass
/// - zoom controls
/// - recenter button
/// - markers
/// - poi detail (bottom sheet with marker information)
public class SYMKBrowseMapViewController: SYMKModuleViewController {
    
    // MARK: - Public Properties
    
    public enum MapSkins: String {
        case day
        case night
    }
    
    public enum UsersLocationSkins: String {
        case pedestrian
        case car
    }
    
    /// Delegate output for browse map controller.
    public weak var delegate: SYMKBrowseMapViewControllerDelegate?
    /// Annotation delegate for browse map controller.
    public weak var annotationDelegate: SYMKBrowserMapViewControllerAnnotationDelegate?
    
    /// Enables compass functionality.
    public var useCompass = false
    
    /// Enables zoom control functionality.
    public var useZoomControl = false

    /// Enables recenter button functionality.
    /// Button is automatically shown if map camera isn't centered to current position.
    /// After tapping recenter button, camera is automatically recentered and button disappears.
    public var useRecenterButton = false
    
    /// Enables bounce in animation on first appearance of default poi detail bottom sheet
    public var bounceDefaultPoiDetailFirstTime = false
    
    /// Displays user's location on map. When set to true, permission to device GPS location dialog is presented and access is required.
    public var showUserLocation = false {
        didSet {
            triggerUserLocation(showUserLocation)
        }
    }
    
    /// Current map selection mode.
    /// Map interaction allows user to tap certain objects on map. Place pin and place detail are displayed for selected object.
    ///
    /// - if MapSelectionMode.markers option is set, only customPois markers will interact to user selection
    public var mapSelectionMode: SYMKMapSelectionManager.MapSelectionMode = .markers {
        didSet {
            mapController?.selectionManager?.mapSelectionMode = mapSelectionMode
        }
    }
    
    /// Custom pois presented by markers in map.
    public var customMarkers: [SYMKMapPin]? {
        didSet {
            if let allMarkers = customMarkers {
                if let oldMarkers = oldValue {
                    removeCustomMarkersFromMap(oldMarkers.filter{ !allMarkers.contains($0) })
                    addCustomMarkersToMap(allMarkers.filter{ !oldMarkers.contains($0) })
                } else {
                    addCustomMarkersToMap(allMarkers)
                }
            } else if let oldMarkers = oldValue {
                removeCustomMarkersFromMap(oldMarkers)
            }
        }
    }
    
    public var mapSkin: MapSkins = .day {
        didSet {
            mapController?.mapView.activeSkins = [mapSkin.rawValue, userLocationSkin.rawValue]
        }
    }
    
    public var userLocationSkin: UsersLocationSkins = .car {
        didSet {
            mapController?.mapView.activeSkins = [mapSkin.rawValue, userLocationSkin.rawValue]
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
    
    public override func loadView() {
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
            map.renderEnabled = true
        }
        super.viewDidAppear(animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        mapController?.mapView.renderEnabled = false
        super.viewWillDisappear(animated)
    }
    
    /// Add annotation to map.
    ///
    /// - Parameter annotation: Annotation added on a map.
    public func addAnnotation(_ annotation: SYAnnotation) {
        mapController?.mapView.addAnnotation(annotation)
    }
    
    /// Add annotations to map.
    ///
    /// - Parameter annotations: Array of annotations added on a map.
    public func addAnnotations(_ annotations: [SYAnnotation]) {
        mapController?.mapView.addAnnotations(annotations)
    }
    
    /// Returns a reusable annotation view object located by its identifier.
    ///
    /// - Parameter reuseIdentifier: A string identifying the view object to be reused. This parameter must not be nil.
    /// - Returns: A `SYAnnotationView` object with the associated identifier or nil if no such object exists in the reusable-view queue.
    public func dequeueReusableAnnotation(for reuseIdentifier: String) -> SYAnnotationView? {
        return mapController?.mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
    }

    /// Remove annotation from map.
    ///
    /// - Parameter annotation: Annotation removed from a map.
    public func removeAnnotation(_ annotation: SYAnnotation) {
        mapController?.mapView.removeAnnotation(annotation)
    }
    
    /// Remove annotations from map.
    ///
    /// - Parameter annotations: Annotations removed from a map.
    public func removeAnnotations(_ annotations: [SYAnnotation]) {
        mapController?.mapView.removeAnnotations(annotations)
    }
        
    // MARK: - Private Methods
    
    internal override func sygicSDKInitialized() {
        SYOnlineSession.shared().onlineMapsEnabled = true
        triggerUserLocation(showUserLocation)
        setupMapController()
        setupViewDelegates()
    }
    
    private func setupMapController() {
        let mapController = SYMKMapController(with: mapState, mapFrame: view.bounds)
        mapController.selectionManager = SYMKMapSelectionManager(with: mapSelectionMode)
        mapController.selectionManager?.delegate = self
        mapController.mapView.activeSkins = [mapSkin.rawValue, userLocationSkin.rawValue]
        (view as! SYMKBrowseMapView).setupMapView(mapController.mapView)
        self.mapController = mapController
        addCustomMarkersToMap(customMarkers)
    }
    
    private func setupViewDelegates() {
        compassController.delegate = mapController
        recenterController.delegate = mapController
        zoomController.delegate = mapController
        mapController?.delegate = self
        
    }
    
    private func addCustomMarkersToMap(_ markers: [SYMKMapPin]?) {
        guard let markers = markers, markers.count > 0, let mapController = mapController else { return }
        for marker in markers {
            mapController.selectionManager?.addCustomPin(marker)
        }
    }
    
    private func removeCustomMarkersFromMap(_ markers: [SYMKMapPin]?) {
        guard let markers = markers, markers.count > 0, let mapController = mapController else { return }
        for marker in markers {
            mapController.selectionManager?.removeCustomPin(marker)
        }
    }
    
    // MARK: User Location
    
    private func triggerUserLocation(_ show: Bool) {
        guard SYMKSdkManager.shared.isSdkInitialized else { return }
        if show {
            SYPositioning.shared().startUpdatingPosition()
        } else {
            SYPositioning.shared().stopUpdatingPosition()
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

extension SYMKBrowseMapViewController: SYMKMapControllerDelegate {
    
    public func mapController(_ controller: SYMKMapController, didUpdate mapState: SYMKMapState) {
        if mapState.cameraMovementMode != .free && !showUserLocation {
            showUserLocation = true
        }
        mapControls.forEach { $0.update(with: mapState) }
    }
    
    public func mapControllerWantsView(for annotation: SYAnnotation) -> SYAnnotationView {
        guard let customAnnotationDelegate = annotationDelegate else { return SYAnnotationView(frame: .zero) }
        return customAnnotationDelegate.browseMapController(self, wantsViewFor: annotation)
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
