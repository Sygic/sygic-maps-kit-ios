//// DemoExampleViewController.swift
// 
// Copyright (c) 2019 - Sygic a.s.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import SygicMapsKit
import SygicUIKit
import SygicMaps


class DemoViewController: UIViewController, SYMKModulePresenter {
    var presentedModules = [SYMKModuleViewController]()
    
    lazy var browseModule: SYMKBrowseMapViewController = {
        let browseMap = SYMKBrowseMapViewController()
        browseMap.useCompass = true
        browseMap.useZoomControl = true
        browseMap.useRecenterButton = true
        browseMap.showUserLocation = true
        browseMap.mapSelectionMode = .all
        browseMap.delegate = self
        browseMap.setupActionButton(with: nil, icon: SYUIIcon.search) { [unowned self] in
            self.presentModule(self.searchModule)
        }
        return browseMap
    }()
    
    lazy var searchModule: SYMKSearchViewController = {
        let search = SYMKSearchViewController()
        search.multipleResultsSelection = false
        search.delegate = self
        return search
    }()
    
    var placeDetail: SYMKPlaceDetailViewController?
    
    var addWaypointToRouteBlock: SYMKRouteWaypointsAddBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DEMO"
        presentModule(browseModule)
    }
    
    func showPlaceDetail(with data: SYMKPlaceData, loading: Bool, zoom: Bool = false) {
        // MOVE MAP TO PLACE
        browseModule.mapState.cameraMovementMode = .free
        browseModule.mapState.geoCenter = data.location
        if zoom {
            browseModule.mapState.zoom = SYMKMapZoomLevels.streetsZoom
        }
        
        // PIN
        if let pin = SYMKMapPin(data: data) {
            pin.highlighted = true
            browseModule.customMarkers = [pin.mapMarker]
        }
        
        // CUSTOM PLACE DETAIL WITH NAVIGATION BUTTON
        let placeController = SYMKPlaceDetailViewController(with: loading ? nil : data)
        placeController.placeView.addActionButton(placeDetailActionButton(isEnabled: !loading))
        placeController.presentPlaceDetailAsChildViewController(to: browseModule, landscapeLayout: UIApplication.shared.statusBarOrientation.isLandscape, animated: true, completion: nil)
        placeDetail = placeController
    }
    
    func placeDetailActionButton(isEnabled: Bool) -> SYUIActionButton {
        let button = SYUIActionButton()
        button.style = .primary13
        button.title = LS("Get direction")
        button.iconImage = SYUIIcon.getDirection
        button.height = SYUIActionButtonSize.infobar.height
        button.isEnabled = isEnabled
        button.action = { [weak self] _ in
            guard let weakSelf = self, let data = weakSelf.placeDetail?.model as? SYMKPlaceData else { return }
            weakSelf.computeRoute(to: data)
            weakSelf.hidePlaceDetail()
        }
        return button
    }
    
    func hidePlaceDetail() {
        placeDetail?.dismissPoiDetail(completion: nil)
        placeDetail = nil
        browseModule.customMarkers = []
    }
    
    func computeRoute(to placeData: SYMKPlaceData) {
        var waypoints = [SYWaypoint]()
        if let startWP = SYWaypoint.currentLocationWaypoint() {
            waypoints.append(startWP)
        }
        waypoints.append(SYWaypoint(position: placeData.location, type: .end, name: placeData.poiDetailTitle))
        let routePlannerModule = SYMKRoutePlannerController()
        routePlannerModule.mapState = browseModule.mapState
        routePlannerModule.useCancelButton = true
        routePlannerModule.useOptionsButton = true
        routePlannerModule.delegate = self
        routePlannerModule.waypoints = waypoints
        presentModule(routePlannerModule)
    }
    
    func startNavigation(with route: SYRoute, preview: Bool) {
        let navigationModule = SYMKNavigationViewController(with: route)
        navigationModule.delegate = self
        navigationModule.mapState = browseModule.mapState
        navigationModule.instructionsType = .signpost
        navigationModule.mapState.cameraMovementMode = .followGpsPositionWithAutozoom
        navigationModule.mapState.cameraRotationMode = .vehicle
        navigationModule.mapState.tilt = 60
        navigationModule.preview = preview
        presentModule(navigationModule)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension DemoViewController: SYMKBrowseMapViewControllerDelegate {
    
    func browseMapControllerDidTapOnMap(_ browseController: SYMKBrowseMapViewController, selectionType: SYMKSelectionType, location: SYGeoCoordinate) -> Bool {
        if placeDetail == nil {
            showPlaceDetail(with: SYMKPlaceData(with: location), loading: true)
            return true
        } else {
            hidePlaceDetail()
            return false
        }
    }
    
    func browseMapControllerShouldAddMarkerOnTap(_ browseController: SYMKBrowseMapViewController, location: SYGeoCoordinate) -> SYMapMarker? {
        return nil
    }
    
    func browseMapControllerShouldPresentDefaultPoiDetail(_ browseController: SYMKBrowseMapViewController) -> Bool {
        return false
    }
    
    func browseMapController(_ browseController: SYMKBrowseMapViewController, didSelect data: SYMKPlaceDataProtocol) {
        guard let data = data as? SYMKPlaceData else { return }
        placeDetail?.model = data
    }
}

extension DemoViewController: SYMKSearchViewControllerDelegate {
    
    func searchController(_ searchController: SYMKSearchViewController, didSearched results: [SYSearchGeocodingResult]) {
        hidePlaceDetail()
        dismissModule()
        
        guard results.count == 1, let result = results.first, let location = result.location else { return }
        
        if let addWaypoint = addWaypointToRouteBlock {
            let newWaypoint = SYWaypoint(position: location, type: .end, name: result.detailCellTitle?.string)
            addWaypoint(newWaypoint)
            addWaypointToRouteBlock = nil
            return
        }
        
        if let placeResult = result as? SYSearchPlaceResult {
            showPlaceDetail(with: SYMKPlaceData(with: location), loading: false, zoom: true)
            SYPlacesManager.sharedPlaces().loadPlace(placeResult.link) { [weak self] (place, error) in
                guard let place = place else {
                    self?.hidePlaceDetail()
                    return
                }
                self?.placeDetail?.model = SYMKPlaceData(with: place)
            }
        } else {
            showPlaceDetail(with: SYMKPlaceData(with: result)!, loading: false, zoom: true)
        }
    }
    
    func searchControllerDidCancel(_ searchController: SYMKSearchViewController) {
        addWaypointToRouteBlock = nil
        searchController.prefillSearch(with: "")
        dismissModule()
    }
}

extension DemoViewController: SYMKRoutePlannerControllerDelegate {
    
    func routePlanner(_ planner: SYMKRoutePlannerController, didSelect route: SYRoute, preview: Bool) {
        if presentedModules.last == planner {
            dismissModule()
        }
        startNavigation(with: route, preview: preview)
    }
    
    func routePlannerDidCancel(_ planner: SYMKRoutePlannerController) {
        browseModule.mapState.resetMapCenter()
        dismissModule()
    }
    
    func routePlanner(_ planner: SYMKRoutePlannerController, wantsAddNewWaypoint newWaypointBlock: @escaping SYMKRouteWaypointsAddBlock) {
        addWaypointToRouteBlock = newWaypointBlock
        presentModule(searchModule)
    }
}

extension DemoViewController: SYMKNavigationViewControllerDelegate {
    
    func navigationControllerDidStopNavigating(_ controller: SYMKNavigationViewController) {
        if presentedModules.last == controller {
            finishNavigationAndRestoreBrowseMap()
        }
    }
    
    func navigationControllerDidReachFinish(_ controller: SYMKNavigationViewController) {
        if presentedModules.last == controller {
            finishNavigationAndRestoreBrowseMap()
        }
    }
    
    private func finishNavigationAndRestoreBrowseMap() {
        browseModule.mapState.resetMapCenter()
        dismissModule()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
