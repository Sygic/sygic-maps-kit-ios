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
    
    /// Implement this method to present default selection UI interface (`SYMKPoiDetailController`)
    /// Although delegate still receives method event `browseMapController(_:, didSelect:)`
    ///
    /// - Parameters:
    ///   - browseController: Browse map module controller.
    /// - Returns: Return true if default UI should be presented. Default return value is false.
    func browseMapControllerShouldPresentDefaultPoiDetail(_ browseController: SYMKBrowseMapViewController) -> Bool
    
    /// Modifies the map marker default behavior. Override this method to use custom map marker.
    ///
    /// - Parameters:
    ///   - browseController: Browse map module.
    ///   - location: Coordinates for map marker.
    /// - Returns: Return map marker or return nil for no map marker.
    func browseMapControllerShouldAddMarkerOnTap(_ browseController: SYMKBrowseMapViewController, location: SYGeoCoordinate) -> SYMapMarker?
    
    /// Delegate receives data about (point of interest) that was selected on map.
    ///
    /// - Parameters:
    ///   - browseController: Browse map module controller.
    ///   - data: Data about selected point of interest. Data will be nil if method was called by marker deselection.
    func browseMapController(_ browseController: SYMKBrowseMapViewController, didSelect data: SYMKPoiDataProtocol)
    
    /// Delegate method called after tap to the map.
    ///
    /// - Parameters:
    ///   - browseController: Browse map module.
    ///   - selectionType: Type belonging to the tap on the map.
    ///   - coordinates: Coordinates belonging to the tap on the map.
    /// - Returns: True to continue to proceed the map tap data, False otherwise. Default value is True.
    func browseMapControllerDidTapOnMap(_ browseController: SYMKBrowseMapViewController, selectionType: SYMKSelectionType, location: SYGeoCoordinate) -> Bool
}

public extension SYMKBrowseMapViewControllerDelegate {
    
    func browseMapControllerShouldPresentDefaultPoiDetail(_ browseController: SYMKBrowseMapViewController) -> Bool {
        return true
    }
    
    func browseMapControllerShouldAddMarkerOnTap(_ browseController: SYMKBrowseMapViewController, location: SYGeoCoordinate) -> SYMapMarker? {
        return SYMapMarker(with: SYMKPoiData(with: location))
    }
    
    func browseMapControllerDidTapOnMap(_ browseController: SYMKBrowseMapViewController, selectionType: SYMKSelectionType, location: SYGeoCoordinate) -> Bool {
        return true
    }
    
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
        case device
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
    /// Recenter button requires showUserLocation to be true and turns it ON automatically when locking maps camera.
    public var useRecenterButton = false
    
    /// Enables bounce in animation on first appearance of default poi detail bottom sheet
    public var bounceDefaultPoiDetailFirstTime = false
    
    /// Displays user's location on map. When set to true, permission to device GPS location dialog is presented and access is required.
    public var showUserLocation = false {
        didSet {
            triggerUserLocation(showUserLocation)
            if let mapController = mapController {
                mapController.mapView.positionIndicator.visible = showUserLocation
            }
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
    public var customMarkers: [SYMapMarker]? {
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
    
    public var mapSkin: MapSkins = .device {
        didSet {
            mapController?.mapView.activeSkins = activeSkins
        }
    }
    
    public var userLocationSkin: UsersLocationSkins = .car {
        didSet {
            mapController?.mapView.activeSkins = activeSkins
        }
    }
    
    // MARK: - Private Properties
    
    private var mapController: SYMKMapController?
    private var compassController = SYMKCompassController(course: 0, autoHide: true)
    private var recenterController = SYMKMapRecenterController()
    private var zoomController = SYMKZoomController()
    private var poiDetailViewController: SYMKPoiDetailViewController?
    
    private var mapControls = [MapControl]()
    
    private var activeSkins: [String] {
        var skins: [String] = []
        if #available(iOS 12.0, *) {
            if mapSkin == .night || (mapSkin == .device && traitCollection.userInterfaceStyle == .dark) {
                skins.append(MapSkins.night.rawValue)
            } else {
                skins.append(MapSkins.day.rawValue)
            }
        } else {
            skins.append(mapSkin.rawValue)
        }
        if userLocationSkin == .pedestrian {
            skins.append(userLocationSkin.rawValue)
        }
        return skins
    }
    
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
            map.renderEnabled = true
            map.setup(with: mapState)
        }
        super.viewDidAppear(animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        mapController?.mapView.renderEnabled = false
        super.viewWillDisappear(animated)
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 12.0, *), mapSkin == .device {
            mapController?.mapView.activeSkins = activeSkins
        }
    }
    
    /// Setup action button with passed attributes and action and add it in bottom right corner of view
    ///
    /// - Parameters:
    ///   - title: title
    ///   - icon: icon
    ///   - style: action button style. Default is .secondary
    ///   - action: action block called on touch up inside event
    public func setupActionButton(with title: String?,icon: String?, style: SYUIActionButtonStyle = .secondary, action: (()->())?) {
        guard let browseView = view as? SYMKBrowseMapView else { return }
        browseView.setupActionButton(with: title, icon: icon, style: style, action: action)
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
        for annotation in annotations {
            mapController?.mapView.addAnnotation(annotation)
        }
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
        for annotation in annotations {
            mapController?.mapView.removeAnnotation(annotation)
        }
    }
        
    // MARK: - Private Methods
    
    deinit {
        if showUserLocation {
            showUserLocation = false
        }
    }
    
    internal override func sygicSDKInitialized() {
        setupMapController()
        let applyLocationValue = showUserLocation
        showUserLocation = applyLocationValue
        setupViewDelegates()
    }
    
    private func setupMapController() {
        let mapController = SYMKMapController(with: mapState, mapFrame: view.bounds)
        mapController.selectionManager = SYMKMapSelectionManager(with: mapSelectionMode)
        mapController.selectionManager?.delegate = self
        mapController.mapView.activeSkins = activeSkins
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
    
    private func addCustomMarkersToMap(_ markers: [SYMapMarker]?) {
        guard let markers = markers, markers.count > 0, let mapController = mapController else { return }
        for marker in markers {
            mapController.selectionManager?.addCustomMarker(marker)
        }
    }
    
    private func removeCustomMarkersFromMap(_ markers: [SYMapMarker]?) {
        guard let markers = markers, markers.count > 0, let mapController = mapController else { return }
        for marker in markers {
            mapController.selectionManager?.removeCustomMarker(marker)
        }
    }
    
    // MARK: PoiDetail
    
    private func updatePoiDetail(with data: SYMKPoiDetailModel) {
        if let poiDetail = poiDetailViewController {
            poiDetail.update(with: data)
        }
    }
    
    private func showPoiDetailWithLoading() {
        poiDetailViewController = SYMKPoiDetailViewController()
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
    
    public func mapSelectionPoiDetailWasShown() -> Bool {
        return poiDetailViewController != nil
    }
    
    public func mapSelection(didSelect poiData: SYMKPoiDataProtocol) {
        guard let poiData = poiData as? SYMKPoiData else { return }
        updatePoiDetail(with: poiData)
        delegate?.browseMapController(self, didSelect: poiData)
    }
    
    public func mapSelectionShouldAddMarkerToMap(location: SYGeoCoordinate) -> SYMapMarker? {
        if let delegate = delegate {
            return delegate.browseMapControllerShouldAddMarkerOnTap(self, location: location)
        }
        return SYMapMarker(with: SYMKPoiData(with: location))
    }
    
    public func mapSelectionDidTapOnMap(selectionType: SYMKSelectionType, location: SYGeoCoordinate) -> Bool {
        hidePoiDetail()
        if let delegate = delegate {
            return delegate.browseMapControllerDidTapOnMap(self, selectionType: selectionType, location: location)
        }
        return true
    }
    
    public func mapSelectionWillSelectData(_ mapSelection: SYMKMapSelectionManager) {
        if delegate == nil || delegate!.browseMapControllerShouldPresentDefaultPoiDetail(self) {
            showPoiDetailWithLoading()
        }
    }
    
}
